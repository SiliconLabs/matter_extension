/*******************************************************************************
 * @file
 * @brief Chip-tool storage parser for matter ncp.
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
#include "chip_tool_storage.h"

#include <cstdio>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_map>

namespace {

// Decode a standard base64 string (with or without padding). Whitespace and
// newlines are ignored. Returns true on success and fills `out` with the
// decoded bytes.
static int8_t base64DecodeChar(char c)
{
    // -1 = invalid, -2 = whitespace/skip, -3 = padding '='
    if (c >= 'A' && c <= 'Z') return static_cast<int8_t>(c - 'A');
    if (c >= 'a' && c <= 'z') return static_cast<int8_t>(c - 'a' + 26);
    if (c >= '0' && c <= '9') return static_cast<int8_t>(c - '0' + 52);
    if (c == '+') return 62;
    if (c == '/') return 63;
    if (c == '=') return -3;
    if (c == ' ' || c == '\t' || c == '\r' || c == '\n') return -2;
    return -1;
}

static bool base64Decode(const char * input, size_t inputLen, std::vector<uint8_t> & out)
{
    if (input == nullptr)
    {
        return false;
    }

    out.clear();
    out.reserve((inputLen * 3) / 4);

    uint32_t accum   = 0;
    int      bits    = 0;
    bool     seenPad = false;

    for (size_t i = 0; i < inputLen; ++i)
    {
        int8_t v = base64DecodeChar(input[i]);
        if (v == -2)
        {
            continue;
        }
        if (v == -3)
        {
            seenPad = true;
            continue;
        }
        if (v < 0 || seenPad)
        {
            return false;
        }
        accum = (accum << 6) | static_cast<uint32_t>(v);
        bits += 6;
        if (bits >= 8)
        {
            bits -= 8;
            out.push_back(static_cast<uint8_t>((accum >> bits) & 0xFF));
        }
    }
    return true;
}

// Trim ASCII whitespace both sides.
static void trimWhiteSpaces(std::string & s)
{
    size_t i = 0;
    while (i < s.size() && (s[i] == ' ' || s[i] == '\t' || s[i] == '\r' || s[i] == '\n')) ++i;
    size_t j = s.size();
    while (j > i && (s[j-1] == ' ' || s[j-1] == '\t' || s[j-1] == '\r' || s[j-1] == '\n')) --j;
    s = s.substr(i, j - i);
}

// Read all key=value pairs under the [Default] section (or the file's default
// section). Skips empty lines and lines starting with '#' or ';'. Section
// headers are recognized but only [Default] entries are collected.
static bool loadIni(const std::string & path, std::unordered_map<std::string, std::string> & out)
{
    std::ifstream f(path);
    if (!f)
    {
        return false;
    }

    std::string section;
    std::string line;
    while (std::getline(f, line))
    {
        trimWhiteSpaces(line);
        if (line.empty() || line[0] == '#' || line[0] == ';')
        {
            continue;
        }
        if (line.front() == '[' && line.back() == ']')
        {
            section = line.substr(1, line.size() - 2);
            continue;
        }
        auto eq = line.find('=');
        if (eq == std::string::npos)
        {
            continue;
        }
        std::string key = line.substr(0, eq);
        std::string val = line.substr(eq + 1);
        trimWhiteSpaces(key);
        trimWhiteSpaces(val);
        if (section == "Default" || section.empty())
        {
            out.emplace(std::move(key), std::move(val));
        }
    }
    return true;
}

static bool decodeKey(const std::unordered_map<std::string, std::string> & m,
                      const char * key, std::vector<uint8_t> & out)
{
    if (key == nullptr)
    {
        return false;
    }
    auto it = m.find(key);
    if (it == m.end())
    {
        return false;
    }
    return base64Decode(it->second.data(), it->second.size(), out);
}

// -------------------- Minimal Matter TLV reader --------------------
//
// Only enough of the reader to walk a well-formed structure/list and locate
// context-tagged children. Length-of-length variants (2/4/8-byte lengths) are
// implemented; extended tag control bytes (implicit/common/full) are not used
// by the blobs we parse, so they are treated as an error.

enum : uint8_t {
    TLV_TC_ANON     = 0x00,
    TLV_TC_CONTEXT1 = 0x20,
};

// Element types (low 5 bits of the control byte).
enum : uint8_t {
    ET_UINT1   = 0x04,
    ET_UINT2   = 0x05,
    ET_UINT4   = 0x06,
    ET_UINT8   = 0x07,
    ET_OSTR1   = 0x10,
    ET_OSTR2   = 0x11,
    ET_OSTR4   = 0x12,
    ET_OSTR8   = 0x13,
    ET_STRUCT  = 0x15,
    ET_ARRAY   = 0x16,
    ET_LIST    = 0x17,
    ET_END     = 0x18,
};

struct TlvCursor
{
    const uint8_t * p;
    const uint8_t * end;
};

static bool tlvReadElem(TlvCursor & c, uint8_t & tagCtrl, uint8_t & elemType, uint64_t & tag,
                        const uint8_t *& valueStart, uint64_t & valueLen)
{
    if (c.p >= c.end) return false;
    uint8_t hdr = *c.p++;
    tagCtrl  = hdr & 0xE0;
    elemType = hdr & 0x1F;

    // Only anon and 1-byte context tags are supported here.
    if (tagCtrl == TLV_TC_ANON)
    {
        tag = 0;
    }
    else if (tagCtrl == TLV_TC_CONTEXT1)
    {
        if (c.p >= c.end) return false;
        tag = *c.p++;
    }
    else
    {
        return false;
    }

    valueStart = c.p;
    valueLen   = 0;

    switch (elemType)
    {
    case ET_UINT1: if (c.p + 1 > c.end) return false; valueLen = 1; c.p += 1; break;
    case ET_UINT2: if (c.p + 2 > c.end) return false; valueLen = 2; c.p += 2; break;
    case ET_UINT4: if (c.p + 4 > c.end) return false; valueLen = 4; c.p += 4; break;
    case ET_UINT8: if (c.p + 8 > c.end) return false; valueLen = 8; c.p += 8; break;
    case ET_OSTR1: {
        if (c.p + 1 > c.end) return false;
        valueLen   = *c.p++;
        valueStart = c.p;
        if (c.p + valueLen > c.end) return false;
        c.p += valueLen;
        break;
    }
    case ET_OSTR2: {
        if (c.p + 2 > c.end) return false;
        valueLen   = (uint16_t)c.p[0] | ((uint16_t)c.p[1] << 8);
        c.p += 2;
        valueStart = c.p;
        if (c.p + valueLen > c.end) return false;
        c.p += valueLen;
        break;
    }
    case ET_STRUCT:
    case ET_ARRAY:
    case ET_LIST:
    case ET_END:
        valueLen = 0;
        break;
    default:
        return false;
    }
    return true;
}

// Read a variable-width unsigned integer at `p` given elemType.
static uint64_t tlvReadUnsigned(const uint8_t * p, uint8_t elemType)
{
    switch (elemType)
    {
    case ET_UINT1: return (uint64_t)p[0];
    case ET_UINT2: return (uint64_t)p[0] | ((uint64_t)p[1] << 8);
    case ET_UINT4: {
        uint64_t v = 0;
        for (int i = 0; i < 4; ++i) v |= (uint64_t)p[i] << (8 * i);
        return v;
    }
    case ET_UINT8: {
        uint64_t v = 0;
        for (int i = 0; i < 8; ++i) v |= (uint64_t)p[i] << (8 * i);
        return v;
    }
    default: return 0;
    }
}

// Skip over the element at the cursor, descending into containers so that
// the cursor is left positioned just after this element.
static bool tlvSkipElement(TlvCursor & c)
{
    uint8_t tagCtrl, elemType;
    uint64_t tag, len;
    const uint8_t * val;
    if (!tlvReadElem(c, tagCtrl, elemType, tag, val, len)) return false;

    if (elemType == ET_STRUCT || elemType == ET_ARRAY || elemType == ET_LIST)
    {
        // recurse until matching END
        while (c.p < c.end)
        {
            if ((*c.p & 0x1F) == ET_END)
            {
                ++c.p;
                return true;
            }
            if (!tlvSkipElement(c)) return false;
        }
        return false;
    }
    return true;
}

// Extract the 16-byte IPK from the group-keyset TLV blob at f/1/k/0.
// Structure (per GroupDataProviderImpl persistence format):
//   struct { [1] uint gks_id, [2] uint policy, [3] array [ struct { [4] uint start,
//            [5] uint fabric_key_derivation_seed, [6] octet_string(16) epoch_key } ... ], ... }
// We walk to [3] (array), then read the first struct child, then find the
// first 16-byte OCTET STRING inside it.
static bool extractIpkFromGroupKeyset(const std::vector<uint8_t> & blob, std::vector<uint8_t> & out)
{
    if (blob.size() < 3 || blob[0] != ET_STRUCT) return false;

    TlvCursor c{ blob.data() + 1, blob.data() + blob.size() };

    while (c.p < c.end && *c.p != ET_END)
    {
        // Peek to inspect the tag.
        uint8_t hdr = *c.p;
        uint8_t tagCtrl  = hdr & 0xE0;
        uint8_t elemType = hdr & 0x1F;

        if (tagCtrl == TLV_TC_CONTEXT1 && (c.p + 1 < c.end) && c.p[1] == 3 && elemType == ET_ARRAY)
        {
            // Descend into the epoch_keys array.
            c.p += 2; // past hdr + tag
            if (c.p >= c.end || *c.p != ET_STRUCT) return false;
            c.p += 1; // into first struct

            // Look for the first OSTR of length 16 within this struct.
            while (c.p < c.end && *c.p != ET_END)
            {
                uint8_t chdr = *c.p;
                uint8_t cTagCtrl  = chdr & 0xE0;
                uint8_t cElemType = chdr & 0x1F;
                if (cTagCtrl != TLV_TC_CONTEXT1)
                {
                    return false;
                }
                const uint8_t * saveStart = c.p;
                (void)saveStart;
                if (cElemType == ET_OSTR1)
                {
                    // hdr (1) + tag (1) + len (1)
                    if (c.p + 3 > c.end) return false;
                    uint8_t olen = c.p[2];
                    if (olen == 16 && c.p + 3 + olen <= c.end)
                    {
                        out.assign(c.p + 3, c.p + 3 + olen);
                        return true;
                    }
                }
                if (!tlvSkipElement(c)) return false;
            }
            return false;
        }
        if (!tlvSkipElement(c)) return false;
    }
    return false;
}

// Walk into the outer Matter certificate struct and find the fabric-id value
// (Matter DN attribute tag 21) inside the subject list (ctx tag 6).
static bool extractFabricIdFromCertTlv(const std::vector<uint8_t> & certTlv, uint64_t & outFabricId)
{
    if (certTlv.size() < 3 || certTlv[0] != ET_STRUCT) return false;
    TlvCursor c{ certTlv.data() + 1, certTlv.data() + certTlv.size() };

    while (c.p < c.end && *c.p != ET_END)
    {
        uint8_t hdr = *c.p;
        uint8_t tagCtrl  = hdr & 0xE0;
        uint8_t elemType = hdr & 0x1F;

        // Looking for subject (ctx tag 6, list).
        if (tagCtrl == TLV_TC_CONTEXT1 && elemType == ET_LIST && (c.p + 1 < c.end) && c.p[1] == 6)
        {
            c.p += 2; // into the list
            while (c.p < c.end && *c.p != ET_END)
            {
                uint8_t dhdr = *c.p;
                uint8_t dTagCtrl  = dhdr & 0xE0;
                uint8_t dElemType = dhdr & 0x1F;
                if (dTagCtrl != TLV_TC_CONTEXT1) return false;
                if (c.p + 1 >= c.end) return false;
                uint8_t dnTag = c.p[1];

                if (dnTag == 21 /* matter-fabric-id */ &&
                    (dElemType >= ET_UINT1 && dElemType <= ET_UINT8))
                {
                    const uint8_t * val = c.p + 2;
                    outFabricId = tlvReadUnsigned(val, dElemType);
                    return true;
                }
                if (!tlvSkipElement(c)) return false;
            }
            return false;
        }
        if (!tlvSkipElement(c)) return false;
    }
    return false;
}

// Extract vendor-id from f/1/m: struct { [0] uint vendor_id, [1] utf8 label }.
static bool extractVendorIdFromFabricMeta(const std::vector<uint8_t> & blob, uint16_t & outVendorId)
{
    if (blob.size() < 3 || blob[0] != ET_STRUCT) return false;
    TlvCursor c{ blob.data() + 1, blob.data() + blob.size() };
    while (c.p < c.end && *c.p != ET_END)
    {
        uint8_t hdr = *c.p;
        uint8_t tagCtrl  = hdr & 0xE0;
        uint8_t elemType = hdr & 0x1F;
        if (tagCtrl == TLV_TC_CONTEXT1 && (c.p + 1 < c.end) && c.p[1] == 0 &&
            (elemType == ET_UINT1 || elemType == ET_UINT2))
        {
            const uint8_t * val = c.p + 2;
            outVendorId = (uint16_t)tlvReadUnsigned(val, elemType);
            return true;
        }
        if (!tlvSkipElement(c)) return false;
    }
    return false;
}

} // namespace

bool loadChipToolStorage(ChipToolStorage & out)
{
    out = ChipToolStorage{};

    std::unordered_map<std::string, std::string> mainMap;
    std::unordered_map<std::string, std::string> alphaMap;

    if (!loadIni("chip_tool_config.ini", mainMap))
    {
        out.missingReason = "chip_tool_config.ini not found in current working directory";
        return false;
    }
    if (!loadIni("chip_tool_config.alpha.ini", alphaMap))
    {
        out.missingReason = "chip_tool_config.alpha.ini not found in current working directory";
        return false;
    }

    // RCAC and ICAC in Matter-TLV form.
    if (!decodeKey(mainMap, "f/1/r", out.rcacTlv) || out.rcacTlv.empty())
    {
        out.missingReason = "chip_tool_config.ini is missing f/1/r (RCAC)";
        return false;
    }
    if (!decodeKey(mainMap, "f/1/i", out.icacTlv) || out.icacTlv.empty())
    {
        out.missingReason = "chip_tool_config.ini is missing f/1/i (ICAC)";
        return false;
    }

    // Fabric-id from the NOC subject.
    std::vector<uint8_t> nocTlv;
    if (!decodeKey(mainMap, "f/1/n", nocTlv) || !extractFabricIdFromCertTlv(nocTlv, out.fabricId))
    {
        out.missingReason = "unable to extract fabric ID from chip_tool_config.ini f/1/n";
        return false;
    }

    // Vendor-id from f/1/m (fallback to 0xFFF1 = TestVendor1 if absent).
    std::vector<uint8_t> fabricMeta;
    if (!decodeKey(mainMap, "f/1/m", fabricMeta) || !extractVendorIdFromFabricMeta(fabricMeta, out.vendorId))
    {
        out.vendorId = 0xFFF1;
    }

    // IPK from f/1/k/0.
    std::vector<uint8_t> ipkBlob;
    if (!decodeKey(mainMap, "f/1/k/0", ipkBlob) || !extractIpkFromGroupKeyset(ipkBlob, out.ipk) ||
        out.ipk.size() != 16)
    {
        out.missingReason = "unable to extract IPK from chip_tool_config.ini f/1/k/0";
        return false;
    }

    // ICAC operational keypair from alpha file. Format is P256SerializedKeypair
    // = 65-byte uncompressed pubkey followed by 32-byte private scalar.
    std::vector<uint8_t> icaKeyBlob;
    if (!decodeKey(alphaMap, "ExampleOpCredsICAKey0", icaKeyBlob) || icaKeyBlob.size() != 97)
    {
        out.missingReason = "chip_tool_config.alpha.ini is missing ExampleOpCredsICAKey0 or it has an unexpected size";
        return false;
    }
    out.icaPubKey.assign(icaKeyBlob.begin(),        icaKeyBlob.begin() + 65);
    out.icaPrivKey.assign(icaKeyBlob.begin() + 65,  icaKeyBlob.end());

    out.loaded = true;
    return true;
}
