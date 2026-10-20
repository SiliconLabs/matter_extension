#include "chip_tool_storage.h"
#include "matter_cert_issuer.h"
#include <cstdio>
#include <openssl/bn.h>
#include <openssl/core_names.h>
#include <openssl/ecdsa.h>
#include <openssl/evp.h>
#include <openssl/param_build.h>
#include <openssl/params.h>

int main() {
    ChipToolStorage s;
    if (!loadChipToolStorage(s)) { fprintf(stderr, "storage load: %s\n", s.missingReason.c_str()); return 1; }
    auto issued = issueNoc(s, 0x000000000001B669ULL); // Test NOC
    if (!issued.ok) { fprintf(stderr, "issueNoc: %s\n", issued.error.c_str()); return 2; }

    // Find ctx11 signature (30 0B 40) in the TLV NOC.
    size_t sigBegin = 0;
    for (size_t i = 1; i + 2 < issued.nocTlv.size(); ++i) {
        if (issued.nocTlv[i]==0x30 && issued.nocTlv[i+1]==0x0B && issued.nocTlv[i+2]==0x40) {
            sigBegin = i + 3; break;
        }
    }
    if (!sigBegin) { fprintf(stderr, "sig marker not found\n"); return 3; }

    // Hash the DER TBS actually signed (matches device behaviour).
    uint8_t hash[32]; size_t hl = 32;
    EVP_Q_digest(nullptr, "SHA256", nullptr, issued.tbsDer.data(), issued.tbsDer.size(), hash, &hl);

    // Build ICA pub-only EVP_PKEY.
    OSSL_PARAM_BLD * bld = OSSL_PARAM_BLD_new();
    OSSL_PARAM_BLD_push_utf8_string(bld, OSSL_PKEY_PARAM_GROUP_NAME, "P-256", 0);
    OSSL_PARAM_BLD_push_octet_string(bld, OSSL_PKEY_PARAM_PUB_KEY, s.icaPubKey.data(), s.icaPubKey.size());
    OSSL_PARAM * params = OSSL_PARAM_BLD_to_param(bld);
    EVP_PKEY_CTX * fctx = EVP_PKEY_CTX_new_from_name(nullptr, "EC", nullptr);
    EVP_PKEY_fromdata_init(fctx);
    EVP_PKEY * pkey = nullptr;
    EVP_PKEY_fromdata(fctx, &pkey, EVP_PKEY_PUBLIC_KEY, params);

    // Rebuild ECDSA_SIG from r||s and DER-encode for EVP_PKEY_verify.
    BIGNUM * r = BN_bin2bn(&issued.nocTlv[sigBegin],      32, nullptr);
    BIGNUM * sbn = BN_bin2bn(&issued.nocTlv[sigBegin + 32], 32, nullptr);
    ECDSA_SIG * sig = ECDSA_SIG_new(); ECDSA_SIG_set0(sig, r, sbn);
    uint8_t der[128]; uint8_t * dp = der; int derlen = i2d_ECDSA_SIG(sig, &dp);

    EVP_PKEY_CTX * vctx = EVP_PKEY_CTX_new_from_pkey(nullptr, pkey, nullptr);
    EVP_PKEY_verify_init(vctx);
    int rc = EVP_PKEY_verify(vctx, der, derlen, hash, 32);
    printf("noc len=%zu, tbsDer len=%zu, verify rc=%d\n",
           issued.nocTlv.size(), issued.tbsDer.size(), rc);

    printf("tbsDer first 48 bytes:");
    for (size_t i = 0; i < 48 && i < issued.tbsDer.size(); ++i) printf(" %02x", issued.tbsDer[i]);
    printf("\n");

    EVP_PKEY_CTX_free(vctx);
    ECDSA_SIG_free(sig);
    EVP_PKEY_free(pkey);
    EVP_PKEY_CTX_free(fctx);
    OSSL_PARAM_free(params);
    OSSL_PARAM_BLD_free(bld);
    return rc == 1 ? 0 : 5;
}
