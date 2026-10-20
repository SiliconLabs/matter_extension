/*******************************************************************************
 * @file
 * @brief Cert issuer for matter ncp
 *******************************************************************************
 * # License
 * <b>Copyright 2026 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/
#include "matter_cert_issuer.h"

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <string>
#include <vector>

#include <openssl/bn.h>
#include <openssl/core_names.h>
#include <openssl/ec.h>
#include <openssl/ecdsa.h>
#include <openssl/err.h>
#include <openssl/evp.h>
#include <openssl/obj_mac.h>
#include <openssl/param_build.h>
#include <openssl/params.h>
#include <openssl/rand.h>

namespace {

// ---------- Matter TLV element types (bottom 5 bits of control byte) ----------
constexpr uint8_t ET_UINT1  = 0x04;
constexpr uint8_t ET_UINT2  = 0x05;
constexpr uint8_t ET_UINT4  = 0x06;
constexpr uint8_t ET_UINT8  = 0x07;
constexpr uint8_t ET_BOOL_F = 0x08;
constexpr uint8_t ET_BOOL_T = 0x09;
constexpr uint8_t ET_OSTR1  = 0x10;
constexpr uint8_t ET_NULL   = 0x14;
constexpr uint8_t ET_STRUCT = 0x15;
constexpr uint8_t ET_ARRAY  = 0x16;
constexpr uint8_t ET_LIST   = 0x17;
constexpr uint8_t ET_END    = 0x18;

constexpr uint8_t TC_ANON    = 0x00;
constexpr uint8_t TC_CONTEXT = 0x20;

// ---------- Small TLV writer over std::vector<uint8_t> ----------
static void tlvPush(std::vector<uint8_t> & buf, uint8_t b) { buf.push_back(b); }

static void tlvWriteContainerStart(std::vector<uint8_t> & buf, uint8_t elemType, uint8_t contextTag)
{
    tlvPush(buf, TC_CONTEXT | elemType);
    tlvPush(buf, contextTag);
}

static void tlvWriteContainerStartAnon(std::vector<uint8_t> & buf, uint8_t elemType)
{
    tlvPush(buf, TC_ANON | elemType);
}

static void tlvWriteEnd(std::vector<uint8_t> & buf) { tlvPush(buf, ET_END); }

static void tlvWriteContextUnsigned(std::vector<uint8_t> & buf, uint8_t contextTag, uint64_t value)
{
    uint8_t et;
    uint8_t widthBytes;
    if      (value <= 0xFFULL)         { et = ET_UINT1; widthBytes = 1; }
    else if (value <= 0xFFFFULL)       { et = ET_UINT2; widthBytes = 2; }
    else if (value <= 0xFFFFFFFFULL)   { et = ET_UINT4; widthBytes = 4; }
    else                               { et = ET_UINT8; widthBytes = 8; }
    tlvPush(buf, TC_CONTEXT | et);
    tlvPush(buf, contextTag);
    for (uint8_t i = 0; i < widthBytes; ++i)
    {
        tlvPush(buf, static_cast<uint8_t>((value >> (8 * i)) & 0xFF));
    }
}

// Emit a uint8 always at 8-byte width — needed for Matter DN attributes like
// matter-node-id / matter-fabric-id, which must be encoded as fixed 8-byte
// unsigned integers to match the canonical form used elsewhere in the fabric.
static void tlvWriteContextUnsignedFixed64(std::vector<uint8_t> & buf, uint8_t contextTag, uint64_t value)
{
    tlvPush(buf, TC_CONTEXT | ET_UINT8);
    tlvPush(buf, contextTag);
    for (int i = 0; i < 8; ++i)
    {
        tlvPush(buf, static_cast<uint8_t>((value >> (8 * i)) & 0xFF));
    }
}

static void tlvWriteContextUnsignedFixed32(std::vector<uint8_t> & buf, uint8_t contextTag, uint32_t value)
{
    tlvPush(buf, TC_CONTEXT | ET_UINT4);
    tlvPush(buf, contextTag);
    for (int i = 0; i < 4; ++i)
    {
        tlvPush(buf, static_cast<uint8_t>((value >> (8 * i)) & 0xFF));
    }
}

static void tlvWriteAnonUnsigned1(std::vector<uint8_t> & buf, uint8_t value)
{
    tlvPush(buf, TC_ANON | ET_UINT1);
    tlvPush(buf, value);
}

// Matter TLV boolean with a 1-byte context tag; no payload beyond header+tag.
static void tlvWriteContextBool(std::vector<uint8_t> & buf, uint8_t contextTag, bool value)
{
    tlvPush(buf, TC_CONTEXT | (value ? ET_BOOL_T : ET_BOOL_F));
    tlvPush(buf, contextTag);
}

static void tlvWriteContextOctetString(std::vector<uint8_t> & buf, uint8_t contextTag,
                                       const uint8_t * data, size_t len)
{
    // ostr1 supports up to 255 bytes; all of our fields fit.
    tlvPush(buf, TC_CONTEXT | ET_OSTR1);
    tlvPush(buf, contextTag);
    tlvPush(buf, static_cast<uint8_t>(len));
    buf.insert(buf.end(), data, data + len);
}

// ---------- Small TLV reader helpers ----------

// Skip the element starting at `p` (with `end` as the buffer terminator).
// Advances `p` past the element. Descends into containers.
static bool tlvSkip(const uint8_t *& p, const uint8_t * end)
{
    if (p >= end) return false;
    uint8_t hdr = *p++;
    uint8_t et  = hdr & 0x1F;
    uint8_t tc  = hdr & 0xE0;

    if (et == ET_END) return true;

    // Consume tag bytes.
    if (tc == TC_CONTEXT) { if (p >= end) return false; ++p; }
    else if (tc != TC_ANON) { return false; }

    switch (et)
    {
    case ET_BOOL_F:
    case ET_BOOL_T:
    case ET_NULL:
        break;
    case ET_UINT1: p += 1; break;
    case ET_UINT2: p += 2; break;
    case ET_UINT4: p += 4; break;
    case ET_UINT8: p += 8; break;
    case ET_OSTR1: {
        if (p >= end) return false;
        uint8_t l = *p++;
        p += l;
        break;
    }
    case ET_STRUCT:
    case ET_ARRAY:
    case ET_LIST:
        while (p < end && *p != ET_END)
        {
            if (!tlvSkip(p, end)) return false;
        }
        if (p >= end) return false;
        ++p; // past END
        break;
    default:
        return false;
    }
    return p <= end;
}

// Find the element with context tag `wantTag` and element type `wantType`
// as a direct child of the outermost struct in `tlv`. On success sets
// `bodyStart` to the first byte AFTER the (control, tag) header and
// `bodyEnd` to one past the last content byte (i.e., the boundaries of
// the element's payload — for a container this is between the container
// start and the matching END).
static bool tlvFindContextChild(const std::vector<uint8_t> & tlv, uint8_t wantTag, uint8_t wantType,
                                const uint8_t *& bodyStart, const uint8_t *& bodyEnd)
{
    if (tlv.size() < 3 || tlv[0] != ET_STRUCT) return false;
    const uint8_t * p   = tlv.data() + 1;
    const uint8_t * end = tlv.data() + tlv.size();

    while (p < end && *p != ET_END)
    {
        uint8_t hdr = *p;
        uint8_t et  = hdr & 0x1F;
        uint8_t tc  = hdr & 0xE0;

        if (tc == TC_CONTEXT && p + 1 < end)
        {
            uint8_t tag = p[1];
            if (tag == wantTag && et == wantType)
            {
                const uint8_t * childHdr = p;
                bodyStart = p + 2; // skip control + tag
                // Determine content end.
                if (et == ET_STRUCT || et == ET_ARRAY || et == ET_LIST)
                {
                    const uint8_t * scan = bodyStart;
                    while (scan < end && *scan != ET_END)
                    {
                        if (!tlvSkip(scan, end)) return false;
                    }
                    if (scan >= end) return false;
                    bodyEnd = scan; // scan points to matching END
                    (void)childHdr;
                    return true;
                }
                if (et == ET_OSTR1)
                {
                    if (bodyStart >= end) return false;
                    uint8_t l = *bodyStart++;
                    if (bodyStart + l > end) return false;
                    bodyEnd = bodyStart + l;
                    return true;
                }
                return false;
            }
        }
        if (!tlvSkip(p, end)) return false;
    }
    return false;
}

// Same as tlvFindContextChild but scoped to a specified [begin,end) buffer
// interpreted as a sequence of TLV elements (i.e., the interior of a list).
static bool tlvFindInSequence(const uint8_t * begin, const uint8_t * end, uint8_t wantTag, uint8_t wantType,
                              const uint8_t *& bodyStart, const uint8_t *& bodyEnd)
{
    const uint8_t * p = begin;
    while (p < end && *p != ET_END)
    {
        uint8_t hdr = *p;
        uint8_t et  = hdr & 0x1F;
        uint8_t tc  = hdr & 0xE0;
        if (tc == TC_CONTEXT && p + 1 < end)
        {
            uint8_t tag = p[1];
            if (tag == wantTag && et == wantType)
            {
                bodyStart = p + 2;
                if (et == ET_STRUCT || et == ET_ARRAY || et == ET_LIST)
                {
                    const uint8_t * scan = bodyStart;
                    while (scan < end && *scan != ET_END)
                    {
                        if (!tlvSkip(scan, end)) return false;
                    }
                    if (scan >= end) return false;
                    bodyEnd = scan;
                    return true;
                }
                if (et == ET_OSTR1)
                {
                    if (bodyStart >= end) return false;
                    uint8_t l = *bodyStart++;
                    if (bodyStart + l > end) return false;
                    bodyEnd = bodyStart + l;
                    return true;
                }
                return false;
            }
        }
        if (!tlvSkip(p, end)) return false;
    }
    return false;
}

// ---------- OpenSSL wrappers (OpenSSL 3 EVP_PKEY API) ----------

// Generate a fresh P-256 keypair, returning the uncompressed point (65 bytes)
// and the private scalar (32 bytes, big-endian, zero-padded).
static bool generateOpKey(std::vector<uint8_t> & pubOut, std::vector<uint8_t> & privOut)
{
    EVP_PKEY * pkey = EVP_EC_gen("P-256");
    if (pkey == nullptr)
    {
        unsigned long e = ERR_peek_last_error();
        char buf[160] = {0};
        ERR_error_string_n(e, buf, sizeof(buf));
        fprintf(stderr, "generateOpKey: EVP_EC_gen(P-256) failed: %s\n", buf);
        return false;
    }

    // Ask for uncompressed encoding. On some OpenSSL 3 builds this param is
    // not settable, so we always re-normalize below via EC_POINT.
    (void)EVP_PKEY_set_utf8_string_param(pkey, OSSL_PKEY_PARAM_EC_POINT_CONVERSION_FORMAT,
                                         "uncompressed");

    bool ok = false;
    uint8_t rawPub[128] = {0};
    size_t publen = 0;
    EC_GROUP * group = nullptr;
    EC_POINT * point = nullptr;

    if (EVP_PKEY_get_octet_string_param(pkey, OSSL_PKEY_PARAM_PUB_KEY,
                                        rawPub, sizeof(rawPub), &publen) != 1
        || publen == 0)
    {
        fprintf(stderr, "generateOpKey: get PUB_KEY failed (publen=%zu)\n", publen);
        goto done;
    }

    // Normalize whatever we got (compressed 33B or uncompressed 65B) into 65B.
    group = EC_GROUP_new_by_curve_name(NID_X9_62_prime256v1);
    point = (group != nullptr) ? EC_POINT_new(group) : nullptr;
    if (group == nullptr || point == nullptr
        || EC_POINT_oct2point(group, point, rawPub, publen, nullptr) != 1)
    {
        fprintf(stderr, "generateOpKey: EC_POINT_oct2point failed\n");
        goto done;
    }
    pubOut.assign(65, 0);
    if (EC_POINT_point2oct(group, point, POINT_CONVERSION_UNCOMPRESSED,
                           pubOut.data(), pubOut.size(), nullptr) != 65)
    {
        fprintf(stderr, "generateOpKey: EC_POINT_point2oct did not produce 65 bytes\n");
        goto done;
    }

    {
        BIGNUM * priv = nullptr;
        if (EVP_PKEY_get_bn_param(pkey, OSSL_PKEY_PARAM_PRIV_KEY, &priv) != 1 || priv == nullptr)
        {
            fprintf(stderr, "generateOpKey: get PRIV_KEY failed\n");
        }
        else
        {
            privOut.assign(32, 0);
            int wrote = BN_bn2binpad(priv, privOut.data(), 32);
            if (wrote != 32) fprintf(stderr, "generateOpKey: BN_bn2binpad returned %d\n", wrote);
            ok = (wrote == 32);
            BN_free(priv);
        }
    }

done:
    if (point != nullptr) EC_POINT_free(point);
    if (group != nullptr) EC_GROUP_free(group);
    EVP_PKEY_free(pkey);
    return ok;
}

// One-shot SHA-256 via EVP.
static bool sha256(const uint8_t * data, size_t len, uint8_t out[32])
{
    size_t mdlen = 32;
    return EVP_Q_digest(nullptr, "SHA256", nullptr, data, len, out, &mdlen) == 1 && mdlen == 32;
}

// One-shot SHA-1 (for Matter SKI/AKI, per spec: SKI = SHA-1(subject_public_key)).
static bool sha1(const uint8_t * data, size_t len, uint8_t out[20])
{
    size_t mdlen = 20;
    return EVP_Q_digest(nullptr, "SHA1", nullptr, data, len, out, &mdlen) == 1 && mdlen == 20;
}

// Sign 32-byte hash with a P-256 private key given as a 32-byte raw scalar.
// Output is 64 raw bytes = R (32) || S (32), big-endian, zero-padded.
static bool ecdsaSignRawRS(const uint8_t privScalar[32], const uint8_t hash[32], uint8_t rsOut[64])
{
    BIGNUM * priv = BN_bin2bn(privScalar, 32, nullptr);
    if (priv == nullptr) return false;

    OSSL_PARAM_BLD * bld     = OSSL_PARAM_BLD_new();
    OSSL_PARAM     * params  = nullptr;
    EVP_PKEY_CTX   * fromCtx = nullptr;
    EVP_PKEY       * pkey    = nullptr;
    EVP_PKEY_CTX   * signCtx = nullptr;
    ECDSA_SIG      * sig     = nullptr;
    bool             ok      = false;

    if (bld != nullptr
        && OSSL_PARAM_BLD_push_utf8_string(bld, OSSL_PKEY_PARAM_GROUP_NAME, "P-256", 0) == 1
        && OSSL_PARAM_BLD_push_BN(bld, OSSL_PKEY_PARAM_PRIV_KEY, priv) == 1
        && (params = OSSL_PARAM_BLD_to_param(bld)) != nullptr
        && (fromCtx = EVP_PKEY_CTX_new_from_name(nullptr, "EC", nullptr)) != nullptr
        && EVP_PKEY_fromdata_init(fromCtx) == 1
        && EVP_PKEY_fromdata(fromCtx, &pkey, EVP_PKEY_KEYPAIR, params) == 1
        && (signCtx = EVP_PKEY_CTX_new_from_pkey(nullptr, pkey, nullptr)) != nullptr
        && EVP_PKEY_sign_init(signCtx) == 1)
    {
        size_t siglen = 0;
        if (EVP_PKEY_sign(signCtx, nullptr, &siglen, hash, 32) == 1)
        {
            std::vector<uint8_t> der(siglen);
            if (EVP_PKEY_sign(signCtx, der.data(), &siglen, hash, 32) == 1)
            {
                const uint8_t * dp = der.data();
                sig = d2i_ECDSA_SIG(nullptr, &dp, static_cast<long>(siglen));
                if (sig != nullptr)
                {
                    const BIGNUM * r = nullptr;
                    const BIGNUM * s = nullptr;
                    ECDSA_SIG_get0(sig, &r, &s);
                    ok = (BN_bn2binpad(r, rsOut,      32) == 32 &&
                          BN_bn2binpad(s, rsOut + 32, 32) == 32);
                }
            }
        }
    }

    if (sig)     ECDSA_SIG_free(sig);
    if (signCtx) EVP_PKEY_CTX_free(signCtx);
    if (pkey)    EVP_PKEY_free(pkey);
    if (fromCtx) EVP_PKEY_CTX_free(fromCtx);
    if (params)  OSSL_PARAM_free(params);
    if (bld)     OSSL_PARAM_BLD_free(bld);
    BN_free(priv);
    return ok;
}

// ---------- Matter epoch time ----------
// Matter epoch is 2000-01-01 00:00:00 UTC. NOC validity spans from 2021-01-01
// through the "never-expires" sentinel used by chip-tool test CAs.
static constexpr uint32_t kNotBefore2021 = 662774400U;  // 2021-01-01 00:00:00 UTC minus Matter epoch (2000-01-01)
static constexpr uint32_t kNeverExpires  = 0U;          // Matter TLV "0" means "no well-defined expiration"

// ---------- ASN.1 DER writer ----------
// The device rebuilds an ASN.1 DER TBS while decoding the TLV NOC and hashes
// that DER form (see CHIPCertToX509.cpp DecodeChipCert / kGenerateTBSHash).
// The signature must therefore be over SHA-256(DER_TBS), not SHA-256(TLV_TBS).
// The helpers below emit a byte-exact DER TBS matching the SDK's encoder
// (GenerateChipX509Cert.cpp EncodeTBSCert), driven by the same input fields.

// DER universal tags used here.
constexpr uint8_t DER_TAG_BOOLEAN          = 0x01;
constexpr uint8_t DER_TAG_INTEGER          = 0x02;
constexpr uint8_t DER_TAG_BIT_STRING       = 0x03;
constexpr uint8_t DER_TAG_OCTET_STRING     = 0x04;
constexpr uint8_t DER_TAG_OID              = 0x06;
constexpr uint8_t DER_TAG_UTF8STRING       = 0x0C;
constexpr uint8_t DER_TAG_SEQUENCE         = 0x30;
constexpr uint8_t DER_TAG_SET              = 0x31;
constexpr uint8_t DER_TAG_UTC_TIME         = 0x17;
constexpr uint8_t DER_TAG_GENERALIZED_TIME = 0x18;
constexpr uint8_t DER_CLASS_CONTEXT        = 0x80;
constexpr uint8_t DER_FORM_CONSTRUCTED     = 0x20;

// Pre-encoded OIDs (content bytes only; no tag/length).
static const uint8_t kDerOid_EcdsaSha256[] = {0x2A,0x86,0x48,0xCE,0x3D,0x04,0x03,0x02};
static const uint8_t kDerOid_EcPublicKey[] = {0x2A,0x86,0x48,0xCE,0x3D,0x02,0x01};
static const uint8_t kDerOid_Prime256v1[]  = {0x2A,0x86,0x48,0xCE,0x3D,0x03,0x01,0x07};
static const uint8_t kDerOid_BasicConstr[] = {0x55,0x1D,0x13};
static const uint8_t kDerOid_KeyUsage[]    = {0x55,0x1D,0x0F};
static const uint8_t kDerOid_ExtKeyUsage[] = {0x55,0x1D,0x25};
static const uint8_t kDerOid_SKI[]         = {0x55,0x1D,0x0E};
static const uint8_t kDerOid_AKI[]         = {0x55,0x1D,0x23};
static const uint8_t kDerOid_ServerAuth[]  = {0x2B,0x06,0x01,0x05,0x05,0x07,0x03,0x01};
static const uint8_t kDerOid_ClientAuth[]  = {0x2B,0x06,0x01,0x05,0x05,0x07,0x03,0x02};

// Matter DN attribute OIDs (1.3.6.1.4.1.37244.1.N — only the trailing byte differs).
static const uint8_t kDerOid_MatterNodeIdBytes[]   = {0x2B,0x06,0x01,0x04,0x01,0x82,0xA2,0x7C,0x01,0x01};
static const uint8_t kDerOid_MatterFwSignBytes[]   = {0x2B,0x06,0x01,0x04,0x01,0x82,0xA2,0x7C,0x01,0x02};
static const uint8_t kDerOid_MatterIcacIdBytes[]   = {0x2B,0x06,0x01,0x04,0x01,0x82,0xA2,0x7C,0x01,0x03};
static const uint8_t kDerOid_MatterRcacIdBytes[]   = {0x2B,0x06,0x01,0x04,0x01,0x82,0xA2,0x7C,0x01,0x04};
static const uint8_t kDerOid_MatterFabricIdBytes[] = {0x2B,0x06,0x01,0x04,0x01,0x82,0xA2,0x7C,0x01,0x05};
static const uint8_t kDerOid_MatterCaseAuthTag[]   = {0x2B,0x06,0x01,0x04,0x01,0x82,0xA2,0x7C,0x01,0x06};

static void derPushLen(std::vector<uint8_t> & out, size_t len)
{
    if (len < 0x80) {
        out.push_back(static_cast<uint8_t>(len));
    } else if (len < 0x100) {
        out.push_back(0x81);
        out.push_back(static_cast<uint8_t>(len));
    } else if (len < 0x10000) {
        out.push_back(0x82);
        out.push_back(static_cast<uint8_t>(len >> 8));
        out.push_back(static_cast<uint8_t>(len));
    } else {
        out.push_back(0x83);
        out.push_back(static_cast<uint8_t>(len >> 16));
        out.push_back(static_cast<uint8_t>(len >> 8));
        out.push_back(static_cast<uint8_t>(len));
    }
}

static void derWrite(std::vector<uint8_t> & out, uint8_t tag, const uint8_t * content, size_t len)
{
    out.push_back(tag);
    derPushLen(out, len);
    out.insert(out.end(), content, content + len);
}

static void derWrite(std::vector<uint8_t> & out, uint8_t tag, const std::vector<uint8_t> & content)
{
    derWrite(out, tag, content.data(), content.size());
}

static void derBool(std::vector<uint8_t> & out, bool v)
{
    out.push_back(DER_TAG_BOOLEAN);
    out.push_back(0x01);
    out.push_back(v ? 0xFF : 0x00);
}

// DER INTEGER with the leading-zero rule (prefix 0x00 when high bit set).
static void derIntegerBig(std::vector<uint8_t> & out, const uint8_t * bytes, size_t len)
{
    // Strip leading zero bytes to match DER minimal-length form (but keep one
    // zero if that's the only content, or when needed to keep positive).
    size_t start = 0;
    while (start + 1 < len && bytes[start] == 0x00 && (bytes[start + 1] & 0x80) == 0) {
        ++start;
    }
    std::vector<uint8_t> body;
    if (len - start > 0 && (bytes[start] & 0x80)) body.push_back(0x00);
    body.insert(body.end(), bytes + start, bytes + len);
    derWrite(out, DER_TAG_INTEGER, body);
}

static void derOid(std::vector<uint8_t> & out, const uint8_t * oid, size_t len)
{
    derWrite(out, DER_TAG_OID, oid, len);
}

static void derOctetString(std::vector<uint8_t> & out, const uint8_t * p, size_t len)
{
    derWrite(out, DER_TAG_OCTET_STRING, p, len);
}

static void derUtf8String(std::vector<uint8_t> & out, const char * s, size_t len)
{
    derWrite(out, DER_TAG_UTF8STRING, reinterpret_cast<const uint8_t *>(s), len);
}

// KeyUsage BIT STRING for Matter NOCs (digitalSignature only = value 1).
// The SDK's ASN1Writer::PutBitString(uint32_t) emits `03 02 07 80` for value 1.
static void derKeyUsageBitString(std::vector<uint8_t> & out, uint8_t value)
{
    // Bit i of `value` is bit i of the ASN.1 named-bit BIT STRING. For value=1
    // (bit 0 set) the single data byte is 0x80 with 7 unused trailing bits.
    // Generalize for other single-byte KeyUsage bitmaps used by NOCs.
    uint8_t reversed = 0;
    for (int i = 0; i < 8; ++i) if (value & (1u << i)) reversed |= (0x80u >> i);
    uint8_t highest = 0;
    for (int i = 7; i >= 0; --i) if (value & (1u << i)) { highest = static_cast<uint8_t>(i); break; }
    uint8_t unused = static_cast<uint8_t>(7 - highest);
    uint8_t bytes[2] = { unused, reversed };
    derWrite(out, DER_TAG_BIT_STRING, bytes, sizeof(bytes));
}

// UTCTime / GeneralizedTime per Matter's rule (year < 2050 => UTCTime).
static void derEncodeAsn1Time(std::vector<uint8_t> & out, int year, int mon, int day,
                              int hour, int min, int sec)
{
    char buf[16];
    if (year >= 1950 && year < 2050) {
        int n = snprintf(buf, sizeof(buf), "%02d%02d%02d%02d%02d%02dZ",
                         year % 100, mon, day, hour, min, sec);
        derWrite(out, DER_TAG_UTC_TIME, reinterpret_cast<const uint8_t *>(buf),
                 static_cast<size_t>(n));
    } else {
        int n = snprintf(buf, sizeof(buf), "%04d%02d%02d%02d%02d%02dZ",
                         year, mon, day, hour, min, sec);
        derWrite(out, DER_TAG_GENERALIZED_TIME, reinterpret_cast<const uint8_t *>(buf),
                 static_cast<size_t>(n));
    }
}

// Emit an [n] EXPLICIT wrapper of `content` (context-specific, constructed).
static void derExplicit(std::vector<uint8_t> & out, uint8_t tagNum,
                        const std::vector<uint8_t> & content)
{
    uint8_t tag = static_cast<uint8_t>(DER_CLASS_CONTEXT | DER_FORM_CONSTRUCTED | tagNum);
    derWrite(out, tag, content);
}

// [n] IMPLICIT primitive of `content` (context-specific, primitive).
static void derImplicitPrim(std::vector<uint8_t> & out, uint8_t tagNum,
                            const uint8_t * data, size_t len)
{
    uint8_t tag = static_cast<uint8_t>(DER_CLASS_CONTEXT | tagNum);
    derWrite(out, tag, data, len);
}

// Format a uint64 as 16 uppercase hex chars (Matter DN 64-bit convention).
static void hexUint64(uint64_t v, char out[16])
{
    static const char digits[] = "0123456789ABCDEF";
    for (int i = 15; i >= 0; --i) { out[i] = digits[v & 0xF]; v >>= 4; }
}

// Format a uint32 as 8 uppercase hex chars (Matter DN 32-bit convention).
static void hexUint32(uint32_t v, char out[8])
{
    static const char digits[] = "0123456789ABCDEF";
    for (int i = 7; i >= 0; --i) { out[i] = digits[v & 0xF]; v >>= 4; }
}

// Emit one DN attribute as SET { SEQ { OID, UTF8String } } into `out`.
static void derEmitAttr(std::vector<uint8_t> & out, const uint8_t * oid, size_t oidLen,
                        const char * value, size_t valueLen)
{
    std::vector<uint8_t> ava;
    derOid(ava, oid, oidLen);
    derUtf8String(ava, value, valueLen);
    std::vector<uint8_t> seq;
    derWrite(seq, DER_TAG_SEQUENCE, ava);
    derWrite(out, DER_TAG_SET, seq);
}

// Parse a Matter DN TLV list (interior between LIST start and END) and emit
// the equivalent X.509 Name (SEQUENCE OF SET OF AttributeTypeAndValue) into
// `derOut`. Attribute order is preserved. The hex-string width depends on
// the attribute OID (matches ChipDN::EncodeToASN1: 64-bit attrs -> 16 hex
// chars, 32-bit attrs -> 8 hex chars) regardless of the TLV integer width.
static bool derEmitDnFromMatterTlv(std::vector<uint8_t> & derOut,
                                   const uint8_t * begin, const uint8_t * end)
{
    std::vector<uint8_t> rdns;
    const uint8_t * p = begin;
    while (p < end && *p != ET_END)
    {
        uint8_t hdr = *p++;
        uint8_t et  = hdr & 0x1F;
        uint8_t tc  = hdr & 0xE0;
        if (tc != TC_CONTEXT) return false;
        if (p >= end) return false;
        uint8_t tag = *p++;

        const uint8_t * oidBytes = nullptr;
        size_t          oidLen   = 0;
        bool            is64bit  = false;
        switch (tag) {
        case 17: oidBytes = kDerOid_MatterNodeIdBytes;   oidLen = sizeof(kDerOid_MatterNodeIdBytes);   is64bit = true;  break;
        case 18: oidBytes = kDerOid_MatterFwSignBytes;   oidLen = sizeof(kDerOid_MatterFwSignBytes);   is64bit = true;  break;
        case 19: oidBytes = kDerOid_MatterIcacIdBytes;   oidLen = sizeof(kDerOid_MatterIcacIdBytes);   is64bit = true;  break;
        case 20: oidBytes = kDerOid_MatterRcacIdBytes;   oidLen = sizeof(kDerOid_MatterRcacIdBytes);   is64bit = true;  break;
        case 21: oidBytes = kDerOid_MatterFabricIdBytes; oidLen = sizeof(kDerOid_MatterFabricIdBytes); is64bit = true;  break;
        case 22: oidBytes = kDerOid_MatterCaseAuthTag;   oidLen = sizeof(kDerOid_MatterCaseAuthTag);   is64bit = false; break;
        default:
            // Unsupported / non-Matter DN attribute (e.g. domain component, OU).
            return false;
        }

        // Read the TLV integer value regardless of its stored width.
        uint64_t v = 0;
        if      (et == ET_UINT1) { if (p + 1 > end) return false; v = p[0]; p += 1; }
        else if (et == ET_UINT2) { if (p + 2 > end) return false; v = uint64_t(p[0]) | (uint64_t(p[1]) << 8); p += 2; }
        else if (et == ET_UINT4) { if (p + 4 > end) return false; for (int i = 0; i < 4; ++i) v |= uint64_t(p[i]) << (8*i); p += 4; }
        else if (et == ET_UINT8) { if (p + 8 > end) return false; for (int i = 0; i < 8; ++i) v |= uint64_t(p[i]) << (8*i); p += 8; }
        else return false;

        char hexBuf[16];
        size_t hexLen;
        if (is64bit) { hexUint64(v, hexBuf); hexLen = 16; }
        else         { hexUint32(static_cast<uint32_t>(v), hexBuf); hexLen = 8; }
        derEmitAttr(rdns, oidBytes, oidLen, hexBuf, hexLen);
    }
    derWrite(derOut, DER_TAG_SEQUENCE, rdns);
    return true;
}

// Extension helpers -- emit DER extensions in the exact form the SDK's
// DecodeConvertExtension()/EncodeXxxExtension() produces.
static void derEmitBasicConstraintsNotCa(std::vector<uint8_t> & out)
{
    std::vector<uint8_t> inner;                    // empty SEQUENCE (isCA=false, default)
    std::vector<uint8_t> extnValue;
    derWrite(extnValue, DER_TAG_SEQUENCE, inner);
    std::vector<uint8_t> ext;
    derOid(ext, kDerOid_BasicConstr, sizeof(kDerOid_BasicConstr));
    derBool(ext, true);                            // critical
    derOctetString(ext, extnValue.data(), extnValue.size());
    derWrite(out, DER_TAG_SEQUENCE, ext);
}

static void derEmitKeyUsage(std::vector<uint8_t> & out, uint8_t bits)
{
    std::vector<uint8_t> bs;
    derKeyUsageBitString(bs, bits);
    std::vector<uint8_t> ext;
    derOid(ext, kDerOid_KeyUsage, sizeof(kDerOid_KeyUsage));
    derBool(ext, true);                            // critical
    derOctetString(ext, bs.data(), bs.size());
    derWrite(out, DER_TAG_SEQUENCE, ext);
}

// NOC EKU order matches TLV order [ClientAuth, ServerAuth] and matches the SDK
// generator's {kOID_KeyPurpose_ClientAuth, kOID_KeyPurpose_ServerAuth}.
static void derEmitExtKeyUsageNoc(std::vector<uint8_t> & out)
{
    std::vector<uint8_t> inner;
    derOid(inner, kDerOid_ClientAuth, sizeof(kDerOid_ClientAuth));
    derOid(inner, kDerOid_ServerAuth, sizeof(kDerOid_ServerAuth));
    std::vector<uint8_t> extnValue;
    derWrite(extnValue, DER_TAG_SEQUENCE, inner);
    std::vector<uint8_t> ext;
    derOid(ext, kDerOid_ExtKeyUsage, sizeof(kDerOid_ExtKeyUsage));
    derBool(ext, true);                            // critical
    derOctetString(ext, extnValue.data(), extnValue.size());
    derWrite(out, DER_TAG_SEQUENCE, ext);
}

static void derEmitSki(std::vector<uint8_t> & out, const uint8_t ski[20])
{
    std::vector<uint8_t> extnValue;
    derOctetString(extnValue, ski, 20);
    std::vector<uint8_t> ext;
    derOid(ext, kDerOid_SKI, sizeof(kDerOid_SKI));
    derOctetString(ext, extnValue.data(), extnValue.size());
    derWrite(out, DER_TAG_SEQUENCE, ext);
}

static void derEmitAki(std::vector<uint8_t> & out, const uint8_t aki[20])
{
    std::vector<uint8_t> inner;                    // SEQUENCE { [0] IMPLICIT keyId }
    derImplicitPrim(inner, 0, aki, 20);
    std::vector<uint8_t> extnValue;
    derWrite(extnValue, DER_TAG_SEQUENCE, inner);
    std::vector<uint8_t> ext;
    derOid(ext, kDerOid_AKI, sizeof(kDerOid_AKI));
    derOctetString(ext, extnValue.data(), extnValue.size());
    derWrite(out, DER_TAG_SEQUENCE, ext);
}

// Emit the [3] EXPLICIT { SEQUENCE { extensions... } } for a NOC.
// Extension order matches EncodeExtensions() for CertType::kNode:
// BasicConstraints, KeyUsage, ExtKeyUsage, SubjectKeyIdentifier, AuthorityKeyIdentifier.
static void derEmitNocExtensions(std::vector<uint8_t> & out, const uint8_t nocSki[20],
                                 const uint8_t icacSki[20])
{
    std::vector<uint8_t> extList;
    derEmitBasicConstraintsNotCa(extList);
    derEmitKeyUsage(extList, 0x01);
    derEmitExtKeyUsageNoc(extList);
    derEmitSki(extList, nocSki);
    derEmitAki(extList, icacSki);
    std::vector<uint8_t> extSeq;
    derWrite(extSeq, DER_TAG_SEQUENCE, extList);
    derExplicit(out, 3, extSeq);
}

// Build the ASN.1 DER TBS certificate for our NOC.
static bool derBuildTbs(std::vector<uint8_t> & tbsOut,
                        const uint8_t * serial, size_t serialLen,
                        const uint8_t * issuerDnBegin, const uint8_t * issuerDnEnd,
                        uint64_t subjectNodeId, uint64_t subjectFabricId,
                        const uint8_t pubKey65[65],
                        const uint8_t nocSki[20], const uint8_t icacSki[20])
{
    std::vector<uint8_t> tbs;

    // version [0] EXPLICIT INTEGER 2
    {
        std::vector<uint8_t> v;
        uint8_t two = 2;
        derWrite(v, DER_TAG_INTEGER, &two, 1);
        derExplicit(tbs, 0, v);
    }

    // serialNumber INTEGER
    derIntegerBig(tbs, serial, serialLen);

    // signature AlgorithmIdentifier SEQUENCE { ecdsa-with-SHA256 }
    {
        std::vector<uint8_t> alg;
        derOid(alg, kDerOid_EcdsaSha256, sizeof(kDerOid_EcdsaSha256));
        derWrite(tbs, DER_TAG_SEQUENCE, alg);
    }

    // issuer Name (parsed from ICAC subject TLV)
    if (!derEmitDnFromMatterTlv(tbs, issuerDnBegin, issuerDnEnd)) return false;

    // validity SEQUENCE { notBefore, notAfter }
    {
        std::vector<uint8_t> v;
        // kNotBefore2021 -> 2021-01-01T00:00:00Z, kNeverExpires -> 9999-12-31T23:59:59Z
        derEncodeAsn1Time(v, 2021, 1, 1, 0, 0, 0);
        derEncodeAsn1Time(v, 9999, 12, 31, 23, 59, 59);
        derWrite(tbs, DER_TAG_SEQUENCE, v);
    }

    // subject Name (nodeId + fabricId, in TLV emission order)
    {
        std::vector<uint8_t> rdns;
        char hexBuf[16];
        hexUint64(subjectNodeId, hexBuf);
        derEmitAttr(rdns, kDerOid_MatterNodeIdBytes, sizeof(kDerOid_MatterNodeIdBytes), hexBuf, 16);
        hexUint64(subjectFabricId, hexBuf);
        derEmitAttr(rdns, kDerOid_MatterFabricIdBytes, sizeof(kDerOid_MatterFabricIdBytes), hexBuf, 16);
        derWrite(tbs, DER_TAG_SEQUENCE, rdns);
    }

    // SubjectPublicKeyInfo SEQUENCE { SEQUENCE { ecPublicKey, prime256v1 }, BIT STRING pubkey }
    {
        std::vector<uint8_t> alg;
        derOid(alg, kDerOid_EcPublicKey, sizeof(kDerOid_EcPublicKey));
        derOid(alg, kDerOid_Prime256v1,  sizeof(kDerOid_Prime256v1));
        std::vector<uint8_t> spki;
        derWrite(spki, DER_TAG_SEQUENCE, alg);
        // BIT STRING with 0 unused bits + 65 pubkey bytes
        std::vector<uint8_t> bs;
        bs.push_back(0);
        bs.insert(bs.end(), pubKey65, pubKey65 + 65);
        derWrite(spki, DER_TAG_BIT_STRING, bs);
        derWrite(tbs, DER_TAG_SEQUENCE, spki);
    }

    // extensions [3] EXPLICIT SEQUENCE { ... }
    derEmitNocExtensions(tbs, nocSki, icacSki);

    // Wrap the whole thing in the outer TBS SEQUENCE.
    derWrite(tbsOut, DER_TAG_SEQUENCE, tbs);
    return true;
}

} // namespace

IssuedNoc issueNoc(const ChipToolStorage & storage, uint64_t nodeId)
{
    IssuedNoc out;

    if (!storage.loaded)
    {
        out.error = "chip-tool storage not loaded";
        return out;
    }

    // ---- 1. Extract ICAC subject bytes (to reuse as NOC issuer). ----
    const uint8_t * icacSubjectBegin = nullptr;
    const uint8_t * icacSubjectEnd   = nullptr;
    if (!tlvFindContextChild(storage.icacTlv, /*wantTag=*/6, /*wantType=*/ET_LIST,
                              icacSubjectBegin, icacSubjectEnd))
    {
        out.error = "ICAC has no subject list at context tag 6";
        return out;
    }

    // ---- 2. Extract ICAC SKI (from extensions list at context tag 10, child ctx 4). ----
    const uint8_t * icacExtsBegin = nullptr;
    const uint8_t * icacExtsEnd   = nullptr;
    if (!tlvFindContextChild(storage.icacTlv, /*wantTag=*/10, /*wantType=*/ET_LIST,
                              icacExtsBegin, icacExtsEnd))
    {
        out.error = "ICAC has no extensions list at context tag 10";
        return out;
    }
    const uint8_t * icacSkiBegin = nullptr;
    const uint8_t * icacSkiEnd   = nullptr;
    if (!tlvFindInSequence(icacExtsBegin, icacExtsEnd, /*wantTag=*/4, /*wantType=*/ET_OSTR1,
                            icacSkiBegin, icacSkiEnd))
    {
        out.error = "ICAC has no subject-key-identifier in its extensions";
        return out;
    }
    if ((icacSkiEnd - icacSkiBegin) != 20)
    {
        out.error = "ICAC subject-key-identifier length is not 20";
        return out;
    }

    // ---- 3. Generate a fresh operational P-256 keypair. ----
    if (!generateOpKey(out.opKeyPub, out.opKeyPriv))
    {
        out.error = "failed to generate operational keypair";
        return out;
    }

    // ---- 4. Compute NOC SKI = SHA-1(pubkey). ----
    uint8_t nocSki[20];
    if (!sha1(out.opKeyPub.data(), out.opKeyPub.size(), nocSki))
    {
        out.error = "SHA-1 of operational pubkey failed";
        return out;
    }

    // ---- 5. Generate a random 20-byte serial number. ----
    uint8_t serial[20];
    if (RAND_bytes(serial, sizeof(serial)) != 1)
    {
        out.error = "RAND_bytes failed";
        return out;
    }
    // Ensure the leading byte is non-zero and < 0x80 so it stays within
    // Matter's valid serial range.
    serial[0] = (serial[0] & 0x7F) | 0x01;

    // ---- 6. Build the cert body (ctx1..ctx10). ----
    std::vector<uint8_t> body;
    body.reserve(512);

    // ctx1 = serial (octet string, up to 20 bytes)
    tlvWriteContextOctetString(body, 1, serial, sizeof(serial));

    // ctx2 = signature algorithm (enum, uint = 1 => ECDSAwithSHA256)
    tlvWriteContextUnsigned(body, 2, 1);

    // ctx3 = issuer (list of DN attrs, copied from ICAC subject).
    tlvWriteContainerStart(body, ET_LIST, 3);
    body.insert(body.end(), icacSubjectBegin, icacSubjectEnd);
    tlvWriteEnd(body);

    // ctx4 = not-before (uint32, Matter epoch seconds)
    tlvWriteContextUnsignedFixed32(body, 4, kNotBefore2021);
    // ctx5 = not-after (uint32, Matter epoch seconds; 0 sentinel = never-expires)
    tlvWriteContextUnsignedFixed32(body, 5, kNeverExpires);

    // ctx6 = subject (list). Matter DN attributes:
    //   tag 17 = matter-node-id (uint64)
    //   tag 21 = matter-fabric-id (uint64)
    tlvWriteContainerStart(body, ET_LIST, 6);
    tlvWriteContextUnsignedFixed64(body, 17, nodeId);
    tlvWriteContextUnsignedFixed64(body, 21, storage.fabricId);
    tlvWriteEnd(body);

    // ctx7 = public-key algorithm (enum, 1 => EC public key).
    tlvWriteContextUnsigned(body, 7, 1);
    // ctx8 = elliptic curve identifier (enum, 1 => prime256v1).
    tlvWriteContextUnsigned(body, 8, 1);
    // ctx9 = public key (octet string, 65 bytes uncompressed EC point).
    tlvWriteContextOctetString(body, 9, out.opKeyPub.data(), out.opKeyPub.size());

    // ctx10 = extensions (list).
    tlvWriteContainerStart(body, ET_LIST, 10);
    // ctx1: basic constraints (struct). Matter's TLV cert decoder requires
    // isCA to be explicitly present, so emit {isCA=false} for a leaf NOC.
    tlvWriteContainerStart(body, ET_STRUCT, 1);
    tlvWriteContextBool(body, 1, false);
    tlvWriteEnd(body);
    // ctx2: key usage bitmap (uint) = 0x01 (digitalSignature only for a NOC)
    tlvWriteContextUnsigned(body, 2, 0x01);
    // ctx3: extended key usage (array of anon enums). serverAuth=1, clientAuth=2.
    tlvWriteContainerStart(body, ET_ARRAY, 3);
    tlvWriteAnonUnsigned1(body, 2);
    tlvWriteAnonUnsigned1(body, 1);
    tlvWriteEnd(body);
    // ctx4: subject key identifier (octet string, 20 bytes)
    tlvWriteContextOctetString(body, 4, nocSki, sizeof(nocSki));
    // ctx5: authority key identifier (octet string, 20 bytes)
    tlvWriteContextOctetString(body, 5, icacSkiBegin, 20);
    tlvWriteEnd(body);

    // ---- 7. Build the ASN.1 DER TBS and hash it. ----
    // The device rebuilds an ASN.1 DER TBS while decoding the TLV NOC and
    // hashes that (see CHIPCertToX509.cpp:DecodeChipCert kGenerateTBSHash).
    // Signing must therefore be over SHA-256(DER_TBS), not SHA-256(TLV_TBS).
    std::vector<uint8_t> derTbs;
    derTbs.reserve(512);
    if (!derBuildTbs(derTbs, serial, sizeof(serial),
                     icacSubjectBegin, icacSubjectEnd,
                     nodeId, storage.fabricId,
                     out.opKeyPub.data(),
                     nocSki, icacSkiBegin))
    {
        out.error = "failed to build DER TBS";
        return out;
    }

    uint8_t hash[32];
    if (!sha256(derTbs.data(), derTbs.size(), hash))
    {
        out.error = "SHA-256 of TBS failed";
        return out;
    }
    out.tbsDer = std::move(derTbs);

    // ---- 8. Sign the TBS hash with the ICA private key. ----
    if (storage.icaPrivKey.size() != 32)
    {
        out.error = "ICA private key is not 32 bytes";
        return out;
    }
    uint8_t rs[64];
    if (!ecdsaSignRawRS(storage.icaPrivKey.data(), hash, rs))
    {
        out.error = "ECDSA signing failed";
        return out;
    }

    // ---- 9. Emit the final cert: 15 body <ctx11=octet_string(64) sig> 18 ----
    out.nocTlv.reserve(body.size() + 4 + 64 + 3);
    tlvWriteContainerStartAnon(out.nocTlv, ET_STRUCT);
    out.nocTlv.insert(out.nocTlv.end(), body.begin(), body.end());
    tlvWriteContextOctetString(out.nocTlv, 11, rs, sizeof(rs));
    tlvWriteEnd(out.nocTlv);

    out.ok = true;
    return out;
}
