#include "AttestationKey.h"
#include <lib/support/CodeUtils.h>
#include <platform/silabs/SilabsConfig.h>
#include <mbedtls/x509_csr.h>
#include <mbedtls/asn1.h>
#include <mbedtls/pk.h>
#include <sl_psa_crypto.h>
#include <stdio.h>
#include <string.h>

#ifdef SLI_SI91X_MCU_INTERFACE
#include "sl_si91x_psa_wrap.h"
#endif

namespace chip {
namespace DeviceLayer {
namespace Silabs {
namespace Provision {

using SilabsConfig = chip::DeviceLayer::Internal::SilabsConfig;


int destroyKey(uint32_t kid)
{
    psa_key_handle_t key_handle;

    int err = psa_open_key(kid, &key_handle);
    if (err)
    {
        psa_close_key(kid);
    }
    else
    {
        err = psa_destroy_key(kid);
    }
    return err;
}

int generateKey(uint32_t kid)
{
    destroyKey(kid);

    psa_key_attributes_t attr = psa_key_attributes_init();

    psa_set_key_id(&attr, kid);
    psa_set_key_type(&attr, PSA_KEY_TYPE_ECC_KEY_PAIR(PSA_ECC_FAMILY_SECP_R1));
    psa_set_key_bits(&attr, 256);
    psa_set_key_algorithm(&attr, PSA_ALG_ECDSA(PSA_ALG_SHA_256));
    psa_set_key_usage_flags(
        &attr, PSA_KEY_USAGE_SIGN_HASH | PSA_KEY_USAGE_VERIFY_HASH | PSA_KEY_USAGE_SIGN_MESSAGE | PSA_KEY_USAGE_VERIFY_MESSAGE);
#ifdef SLI_SI91X_MCU_INTERFACE
    psa_set_key_lifetime(
        &attr, PSA_KEY_LIFETIME_FROM_PERSISTENCE_AND_LOCATION(PSA_KEY_LIFETIME_PERSISTENT, PSA_KEY_VOLATILE_PERSISTENT_WRAPPED));
#else
    psa_set_key_lifetime(
        &attr, PSA_KEY_LIFETIME_FROM_PERSISTENCE_AND_LOCATION(PSA_KEY_LIFETIME_PERSISTENT, sl_psa_get_most_secure_key_location()));
#endif
    psa_key_id_t id = 0;
    psa_status_t err = psa_generate_key(&attr, &id);
    return err;
}

int importKey(uint32_t kid, const uint8_t * value, size_t size)
{
    destroyKey(kid);
    psa_key_attributes_t attr = psa_key_attributes_init();
    psa_set_key_id(&attr, kid);
    psa_set_key_type(&attr, PSA_KEY_TYPE_ECC_KEY_PAIR(PSA_ECC_FAMILY_SECP_R1));
    psa_set_key_bits(&attr, 256);
    psa_set_key_algorithm(&attr, PSA_ALG_ECDSA(PSA_ALG_SHA_256));
    psa_set_key_usage_flags(
        &attr, PSA_KEY_USAGE_SIGN_HASH | PSA_KEY_USAGE_VERIFY_HASH | PSA_KEY_USAGE_SIGN_MESSAGE | PSA_KEY_USAGE_VERIFY_MESSAGE);
#ifdef SLI_SI91X_MCU_INTERFACE
    psa_set_key_lifetime(
        &attr, PSA_KEY_LIFETIME_FROM_PERSISTENCE_AND_LOCATION(PSA_KEY_LIFETIME_PERSISTENT, PSA_KEY_VOLATILE_PERSISTENT_WRAPPED));
#else
    psa_set_key_lifetime(
        &attr, PSA_KEY_LIFETIME_FROM_PERSISTENCE_AND_LOCATION(PSA_KEY_LIFETIME_PERSISTENT, sl_psa_get_most_secure_key_location()));
#endif

    psa_key_id_t id = 0;
    psa_status_t err = psa_import_key(&attr, value, size, &id);
    psa_reset_key_attributes(&attr);
    return err;
}


int importCallback(void *ctx, int tag, unsigned char *value, size_t size)
{
    if(MBEDTLS_ASN1_OCTET_STRING == tag)
    {
        uint32_t kid = *(uint32_t*)ctx;
        return importKey(kid, value, size);
    }
    return 0;
}


CHIP_ERROR AttestationKey::Import(const uint8_t * asn1, size_t size)
{
    uint8_t *p = (uint8_t *)asn1;
    uint8_t *q = p + size;

    int err = mbedtls_asn1_traverse_sequence_of(&p, q, 0, 0, 0, 0, importCallback, &mId);
    return err ? CHIP_ERROR_INTERNAL : CHIP_NO_ERROR;
}

CHIP_ERROR AttestationKey::Export(uint8_t * asn1, size_t max, size_t &size)
{
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}


CHIP_ERROR AttestationKey::GenerateCSR(uint16_t vid, uint16_t pid, const CharSpan &cn, MutableCharSpan & csr)
{
    mbedtls_pk_context key_ctx;
    mbedtls_x509write_csr csr_ctx;

    VerifyOrReturnError(nullptr != csr.data(), CHIP_ERROR_INVALID_ARGUMENT);
    VerifyOrReturnError(csr.size() >= 512, CHIP_ERROR_INVALID_ARGUMENT);

    mbedtls_x509write_csr_init(&csr_ctx);

    // Subject name
    char subject_name[64] = { 0 };
    if(cn.size() > 0)
    {
        snprintf(subject_name, sizeof(subject_name), "CN=%s Mvid:%04X Mpid:%04X", cn.data(), vid, pid);
    }
    else
    {
        snprintf(subject_name, sizeof(subject_name), "CN=Matter Device Mvid:%04X Mpid:%04X", vid, pid);
    }
    int err = mbedtls_x509write_csr_set_subject_name(&csr_ctx, subject_name);
    VerifyOrReturnError(0 == err, CHIP_ERROR_INTERNAL);

    // Algorithm
    mbedtls_x509write_csr_set_md_alg(&csr_ctx, MBEDTLS_MD_SHA256);

    // Generate key
    generateKey(mId);
    mbedtls_pk_init(&key_ctx);
    err = mbedtls_pk_setup_opaque(&key_ctx, mId);
    VerifyOrReturnError(0 == err, CHIP_ERROR_INTERNAL);
    mbedtls_x509write_csr_set_key(&csr_ctx, &key_ctx);

    // Generate
    err = mbedtls_x509write_csr_pem(&csr_ctx, (uint8_t *) csr.data(), csr.size(), NULL, NULL);
    VerifyOrReturnError(0 == err, CHIP_ERROR_INTERNAL);
    csr.reduce_size(strlen(csr.data()) + 1);

    // Release
    mbedtls_x509write_csr_free(&csr_ctx);

    return CHIP_NO_ERROR;
}


CHIP_ERROR AttestationKey::SignMessage(const ByteSpan & message, MutableByteSpan & out_span)
{
    uint8_t signature[64] = { 0 };
    size_t signature_size = sizeof(signature);

    psa_status_t err =
        psa_sign_message(static_cast<psa_key_id_t>(mId), PSA_ALG_ECDSA(PSA_ALG_SHA_256), message.data(),
                            message.size(), signature, signature_size, &signature_size);

    VerifyOrReturnError(!err, CHIP_ERROR_INTERNAL);
    return CopySpanToMutableSpan(ByteSpan(signature, signature_size), out_span);
}


} // namespace Provision
} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
