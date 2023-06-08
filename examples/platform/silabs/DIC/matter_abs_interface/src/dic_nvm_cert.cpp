/**
 * @file
 * @brief Matter abstraction layer for Direct Internet Connectivity.
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc.
 *www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon
 *Laboratories Inc. Your use of this software is
 *governed by the terms of Silicon Labs Master
 *Software License Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.
 *This software is distributed to you in Source Code
 *format and is governed by the sections of the MSLA
 *applicable to Source Code.
 *
 ******************************************************************************/
#include "stddef.h"
#include <cstring>

#include "dic_nvm_cert.h"
#include <lib/core/CHIPError.h>
#include <lib/support/logging/CHIPLogging.h>

#define USE_AWS 1
#define USE_MOSQUITTO 0

#if USE_AWS

#define DIC_CLIENT_ID "DIC_2"
#define DIC_SERVER_HOST	"a2m21kovu9tcsh-ats.iot.ap-southeast-1.amazonaws.com"

/*
 * Certificate set for TLS Connection to public endpoint
*/
char ca_certificate[] = "-----BEGIN CERTIFICATE-----\n"
"MIIDQTCCAimgAwIBAgITBmyfz5m/jAo54vB4ikPmljZbyjANBgkqhkiG9w0BAQsF\n"
"ADA5MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRkwFwYDVQQDExBBbWF6\n"
"b24gUm9vdCBDQSAxMB4XDTE1MDUyNjAwMDAwMFoXDTM4MDExNzAwMDAwMFowOTEL\n"
"MAkGA1UEBhMCVVMxDzANBgNVBAoTBkFtYXpvbjEZMBcGA1UEAxMQQW1hem9uIFJv\n"
"b3QgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJ4gHHKeNXj\n"
"ca9HgFB0fW7Y14h29Jlo91ghYPl0hAEvrAIthtOgQ3pOsqTQNroBvo3bSMgHFzZM\n"
"9O6II8c+6zf1tRn4SWiw3te5djgdYZ6k/oI2peVKVuRF4fn9tBb6dNqcmzU5L/qw\n"
"IFAGbHrQgLKm+a/sRxmPUDgH3KKHOVj4utWp+UhnMJbulHheb4mjUcAwhmahRWa6\n"
"VOujw5H5SNz/0egwLX0tdHA114gk957EWW67c4cX8jJGKLhD+rcdqsq08p8kDi1L\n"
"93FcXmn/6pUCyziKrlA4b9v7LWIbxcceVOF34GfID5yHI9Y/QCB/IIDEgEw+OyQm\n"
"jgSubJrIqg0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC\n"
"AYYwHQYDVR0OBBYEFIQYzIU07LwMlJQuCFmcx7IQTgoIMA0GCSqGSIb3DQEBCwUA\n"
"A4IBAQCY8jdaQZChGsV2USggNiMOruYou6r4lK5IpDB/G/wkjUu0yKGX9rbxenDI\n"
"U5PMCCjjmCXPI6T53iHTfIUJrU6adTrCC2qJeHZERxhlbI1Bjjt/msv0tadQ1wUs\n"
"N+gDS63pYaACbvXy8MWy7Vu33PqUXHeeE6V/Uq2V8viTO96LXFvKWlJbYK8U90vv\n"
"o/ufQJVtMVT8QtPHRh8jrdkPSHCa2XV4cdFyQzR1bldZwgJcJmApzyMZFo6IQ6XU\n"
"5MsI+yMRQ+hDKXJioaldXgjUkK642M4UwtBV8ob2xJNDd2ZhwLnoQdeXeGADbkpy\n"
"rqXRfboQnoZsG4q5WTP468SQvvG5\n"
"-----END CERTIFICATE-----";

char device_certificate[] = "-----BEGIN CERTIFICATE-----\n"
"MIIB/DCCAaMCFFvLxRPNwTeVQB5YtKLbEdwdcvMaMAoGCCqGSM49BAMCMIGAMQsw\n"
"CQYDVQQGEwJJTjESMBAGA1UECAwJVGVsYW5nYW5hMQwwCgYDVQQHDANIeWQxDzAN\n"
"BgNVBAoMBlNpbGFiczEPMA0GA1UECwwGbWF0dGVyMQ8wDQYDVQQDDAZjaGFuZHUx\n"
"HDAaBgkqhkiG9w0BCQEWDXNoQHNpbGFicy5jb20wHhcNMjMwMzI0MTIwMzI5WhcN\n"
"MjQwMzE4MTIwMzI5WjCBgDELMAkGA1UEBhMCSU4xEjAQBgNVBAgMCVRlbGFuZ2Fu\n"
"YTEMMAoGA1UEBwwDSHlkMQ8wDQYDVQQKDAZTaWxhYnMxDzANBgNVBAsMBm1hdHRl\n"
"cjEPMA0GA1UEAwwGY2hhbmR1MRwwGgYJKoZIhvcNAQkBFg1zaEBzaWxhYnMuY29t\n"
"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEWIaIixoLW8k3JFROV0Uy+ja2Awhv\n"
"TnYXuuogAqbMsCsNB2kix3zIU6d8uYM/0QjVGBo3NT5S32BlvKa1aHaD+TAKBggq\n"
"hkjOPQQDAgNHADBEAiAMm4+cD3en9qYFHnRpl0YmVlj2bWpJ+VSDRlkUru2JdgIg\n"
"CLtDL0HQ9NZt+AwKGYwnBZwJLOMuBWczU4uCcXsFGUM=\n"
"-----END CERTIFICATE-----";

char device_key[] = "------BEGIN EC PRIVATE KEY-----\n"
"MHcCAQEEIFuiGwgW2Xj8QC+SO9LXNf9v6aSb+1vqAstp2h+dUArzoAoGCCqGSM49\n"
"AwEHoUQDQgAEWIaIixoLW8k3JFROV0Uy+ja2AwhvTnYXuuogAqbMsCsNB2kix3zI\n"
"U6d8uYM/0QjVGBo3NT5S32BlvKa1aHaD+Q==\n"
"-----END EC PRIVATE KEY-----";

#elif USE_MOSQUITTO

#define DIC_CLIENT_ID "test_client"
#define DIC_SERVER_HOST	"192.168.10.164"

/*
 * Certificate set for TLS Connection to local broker ex: mosquitto
*/
char ca_certificate[] = "-----BEGIN CERTIFICATE-----\n"
"MIICDTCCAbOgAwIBAgIUEvWwZ9IWWG5vB3CvKdx2TSXZCtwwCgYIKoZIzj0EAwIw\n"
"XDELMAkGA1UEBhMCSU4xDDAKBgNVBAgMA1RlbDEMMAoGA1UEBwwDSHlkMQ8wDQYD\n"
"VQQKDAZTaWxhYnMxDzANBgNVBAsMBk1hdHRlcjEPMA0GA1UEAwwGY2hhbmR1MB4X\n"
"DTIzMDUxNjA3MTE0NFoXDTI4MDUxNTA3MTE0NFowXDELMAkGA1UEBhMCSU4xDDAK\n"
"BgNVBAgMA1RlbDEMMAoGA1UEBwwDSHlkMQ8wDQYDVQQKDAZTaWxhYnMxDzANBgNV\n"
"BAsMBk1hdHRlcjEPMA0GA1UEAwwGY2hhbmR1MFkwEwYHKoZIzj0CAQYIKoZIzj0D\n"
"AQcDQgAEaLXdRUkf/j/RIVg38iSKygwfkuQhdMsPJjVDIMILr92WE4EapRNXf5ev\n"
"btK2O+ta6W0z7R2zifgdS3w6e3KFmqNTMFEwHQYDVR0OBBYEFD313w70tuyzOrkj\n"
"EUAlNEDbNVshMB8GA1UdIwQYMBaAFD313w70tuyzOrkjEUAlNEDbNVshMA8GA1Ud\n"
"EwEB/wQFMAMBAf8wCgYIKoZIzj0EAwIDSAAwRQIhANrH4g1DEmDzmwxhFtun+7Ky\n"
"bd71PuHl8lwXQeekEej7AiA1oSb6A9WF40TPFDJGxTh69y84GsTthUfchQMpvXzX\n"
"pA==\n"
"-----END CERTIFICATE-----";

char device_certificate[] = "-----BEGIN CERTIFICATE-----\n"
"MIIBuTCCAV4CFA403r7eu3X66+wO0H/nLno87MPuMAoGCCqGSM49BAMCMFwxCzAJ\n"
"BgNVBAYTAklOMQwwCgYDVQQIDANUZWwxDDAKBgNVBAcMA0h5ZDEPMA0GA1UECgwG\n"
"U2lsYWJzMQ8wDQYDVQQLDAZNYXR0ZXIxDzANBgNVBAMMBmNoYW5kdTAeFw0yMzA1\n"
"MTYwNzMwNTVaFw0yNDA1MTAwNzMwNTVaMGExCzAJBgNVBAYTAklOMQwwCgYDVQQI\n"
"DANUZWwxDDAKBgNVBAcMA0h5ZDEPMA0GA1UECgwGU2lsYXNiMQ8wDQYDVQQLDAZN\n"
"YXR0ZXIxFDASBgNVBAMMC3Rlc3RfY2xpZW50MFkwEwYHKoZIzj0CAQYIKoZIzj0D\n"
"AQcDQgAEIQEoK1nPu3DaDlG4TrxF5iiqcHApwFKD7y08hpuIxLzxqbNhOMARkA6F\n"
"PGi30Zwk+P00gwrTGFZrJLRpNemfRzAKBggqhkjOPQQDAgNJADBGAiEA7yN/zqwn\n"
"1X3lJ4eOVOW5empyPT21MnVAGczi0aez5twCIQC4FipkDePu2tDLysBFtDffb3s/\n"
"2obtyxPd8CzBJEZlGQ==\n"
"-----END CERTIFICATE-----";

char device_key[] = "-----BEGIN EC PRIVATE KEY-----\n"
"MHcCAQEEIPtBTYb6/TqhPXzAJAraOHGrxpbml29IWxFGRCRWiBeboAoGCCqGSM49\n"
"AwEHoUQDQgAEIQEoK1nPu3DaDlG4TrxF5iiqcHApwFKD7y08hpuIxLzxqbNhOMAR\n"
"kA6FPGi30Zwk+P00gwrTGFZrJLRpNemfRw==\n"
"-----END EC PRIVATE KEY-----";

#endif

using namespace chip::DeviceLayer::Internal;

CHIP_ERROR DICGetCACertificate(char * buf, size_t buf_len, size_t *bufSize)
{
    CHIP_ERROR status = CHIP_NO_ERROR;
#if SL_DIC_NVM_EMBED_CERT
    status = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_CACerts,reinterpret_cast<uint8_t *>(buf), buf_len, *bufSize);
#else
    *bufSize = sizeof(ca_certificate);
    if(buf == NULL && buf_len < *bufSize) {
        return CHIP_ERROR_INTERNAL;
    }
    strncpy(buf,ca_certificate,*bufSize);
#endif
    return status;
}

CHIP_ERROR DICGetDeviceCertificate(char * buf, size_t buf_len, size_t *bufSize) 
{
    CHIP_ERROR status = CHIP_NO_ERROR;
#if SL_DIC_NVM_EMBED_CERT
    status = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_DeviceCerts,reinterpret_cast<uint8_t *>(buf), buf_len, *bufSize);
#else
    *bufSize = sizeof(device_certificate);
    if(buf == NULL && buf_len < *bufSize) {
        return CHIP_ERROR_INTERNAL;
    }
    strncpy(buf,device_certificate,*bufSize);
#endif
    return status;
}

CHIP_ERROR DICGetDevicePrivKey(char * buf, size_t buf_len, size_t *bufSize) 
{
    CHIP_ERROR status = CHIP_NO_ERROR;
#if SL_DIC_NVM_EMBED_CERT
    status = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_DeviceKey,reinterpret_cast<uint8_t *>(buf), buf_len, *bufSize);
#else
    *bufSize = sizeof(device_key);
    if(buf == NULL && buf_len < *bufSize) {
        return CHIP_ERROR_INTERNAL;
    }
    strncpy(buf,device_key,*bufSize);
#endif
    return status;
}

CHIP_ERROR DICGetHostname(char * buf, size_t buf_len, size_t *bufSize) 
{
    CHIP_ERROR status = CHIP_NO_ERROR;
#if SL_DIC_NVM_EMBED_CERT
    status = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_hostname,reinterpret_cast<uint8_t *>(buf), buf_len, *bufSize);
#else
    *bufSize = sizeof(DIC_SERVER_HOST);
    if(buf == NULL && buf_len < *bufSize) {
        return CHIP_ERROR_INTERNAL;
    }
    strncpy(buf,DIC_SERVER_HOST,*bufSize);
#endif
    return status;
}

CHIP_ERROR DICGetClientId(char * buf, size_t buf_len, size_t *bufSize) 
{
    CHIP_ERROR status = CHIP_NO_ERROR;
#if SL_DIC_NVM_EMBED_CERT
    status = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_clientid,reinterpret_cast<uint8_t *>(buf), buf_len, *bufSize);
#else
    *bufSize = sizeof(DIC_CLIENT_ID);
    if(buf == NULL && buf_len < *bufSize) {
        return CHIP_ERROR_INTERNAL;
    }
    strncpy(buf,DIC_CLIENT_ID,*bufSize);
#endif
    return status;
}