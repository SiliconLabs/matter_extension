# Matter Provisioning


The provisioning script is used to load mandatory information into Matter devices, including commissioning and authentication
parameters. To facilitate the transition between development and production, this tool uses the same inputs as Silicon Labs's
[Custom Part Manufacturing Service](https://www.silabs.com/services/custom-part-manufacturing-service). Most of the parameters
are stored once during the manufacturing process, and shall not change during the lifetime of the device.
During runtime, two interfaces are used to pull the authentication data from permanent storage:
* [CommissionableDataProvider](../src/include/platform/CommissionableDataProvider.h), implemented as [SilabsDeviceDataProvider](../examples/platform/silabs/SilabsDeviceDataProvider.cpp)
* [DeviceAttestationCredsProvider](../src/credentials/DeviceAttestationCredsProvider.h), implemented as [SilabsDeviceAttestationCreds](../examples/platform/silabs/SilabsDeviceAttestationCreds.h)

The provisioning script on this folder now supercedes the following tools:
* [Credentials Example](https://github.com/SiliconLabs/matter/tree/release_1.1.0-1.1/silabs_examples/credentials)
* [Factory Data Provider](../scripts/tools/silabs/README.md)

## Provisioned Data

The Commissionable Data includes Serial Number, Vendor Id, Product Id, and the Setup Payload (typicallty displayed in the QR), while the Attestation Credentials includes the Certificate Declaration (CD), the Product Attestation Intermediate (PAI) certificate, and the DAC (Device Attestation Certificate).

During commissioning, Matter devices perform a Password Authenticated Key Exchange using the SPAKE2+ protocol. The SPAKE2+ verifier is pre-calculated [using an external tool](../src/tools/spake2p/README.md).

The passcode is used to derive a QR code, typically printed on the label, or displayed by the device itself. The QR code contains the pre-computed setup payload, which allows the commissioner to establish a session with the device. The parameters required to generate and validate the session keys are static and stored in NVM3.

To protect the attestation private-key (used to generate the DAC), the asymmetric key-pair should be generated on-device, using PSA, and the most secure storage location available to the specific part.
However, the private-key may be generated externally, and imported using the --dac_key parameter.

The DAC is generated and signed by a Certification Authority (CA), which may reside on a separate host. The `modules/signing_server.py` script simulates the role of the CA, and uses OpenSSL to to generate and sign the DAC. In a real factory environment, this script is replaced by an actual CA.


## Generator Firmware

The Generator Firmware (GFW) is a baremetal application that runs on the targeted device, and assists with the initial setup of the device. The GFW performs the following tasks:

* Generates the device key-pair on the most secure location available
* Returns a CSR (Certificate Signing Request) to the provisioning script. The CSR contains the device public-key, Vendor Id, Product Id, and Serial Number.
* Calculates the Setup Payload
* Stores the Commissionable Data into NVM3 (including the Setup Payload)
* Stores the Attestation Data on the main flash (CD, PAI, DAC)
* Stores the size and offsets used to store the Attestation Data, along with the KeyId used to generate the private-key

The main source code of the GFW is located under `provision/generator`, while the board support is located under `provision/support`. Pre-compiled images for the supported chips can be found in `provision/images`.

The directory structure is as follows:
- provision
    - generator
    - images
    - modules
    - support
        - efr32mg12
        - efr32mg24

## Provisioner Script

The `provision.py` file is the main script used to load all the required data on the Matter device. This script requires:
* [Simplicity Commander](https://community.silabs.com/s/article/simplicity-commander?language=en_US)
* [SEGGER J-Link](https://www.segger.com/downloads/jlink/)
* [SPAKE2+ generator](../src/tools/spake2p/README.md)
* [PyLink](https://pylink.readthedocs.io/en/latest/index.html)

sudo pip3 install ecdsa

The Provisioner Script executes the following steps:

1. Parses and validates the command-line arguments
2. Obtains the Part Number from the connected device (using Simplicity Commander)
3. If no SPAKE2+ verifier is provided:
   3.1. Generates SPAKE2+ verifier (using the external `spake2p` tool)
4. Loads the Generator Firmware into the device (if no GFW path is provided, the Part Number is used to choose the corresponding file from the `provision/images`)
5. Configures the NVM3 based on the flash size of the connected device
6. If CSR mode is used (--csr):
   6.1. Requests a CSR from the device
    - The GFW generates the key-pair and CSR, then returns the the CSR to the host script
   6.2. Sends the CSR to the Signing Server (`provision/modules/signing_server.py`), and retrieves the DAC
7. Sends CD, PAI, and DAC to the GFW
    - The GFW stores CD, PAI, and DAC on the last page of main flash, and updates the offsets and sizes in NVM3

8. Sends the Commissionable Data to the GFW
    - The GFW initializes the flash, generates the Setup Payload, and stores the data into NVM3
9. If a PFW is provided, writes the PFW into flash using Simplicity Commander

The provisioning script and the GFW communicates through J-Link RTT using the PyLink module.

### Arguments

| Arguments                 | Conformance          | Type               | Description                                                                             |
| ------------------------- | -------------------- | ------------------ | --------------------------------------------------------------------------------------- |
| -c,  --config             | optional             | string             | Path to a JSON configuration file            |
| -j,  --jlink              | optional<sup>1</sup> | dec/string         | JLink connection string.  |
| -l,  --pylink_lib         | optional             | string             | Path to the PyLink library.  |
| -g,  --generate           | optional             | flag               | Auto-generate test certificates            |
| -s,  --stop               | optional             | flag               | Stop mode: When true, only generate the JSON configuration, and exit.                    |
| -r,  --csr                | optional             | flag               | CSR mode: When true, instructs the GFW to generate the private key, and issue a CSR.                    |
| -gf, --gen_fw             | optional             | dec/hex            | Path to the Generator Firmware image.                                                   |
| -pf, --prod_fw            | optional             | dec/hex            | Path to the Production Firmware image.                                                   |
| -v,  --vendor_id          | optional             | dec/hex            | Vendor ID. e.g: 65521 or 0xFFF1 (Max 2 bytes).                              |
| -V,  --vendor_name        | optional             | string             | Vendor name (Max 32 char).                                                  |
| -p,  --product_id         | optional             | dec/hex            | Product ID. e.g: 32773 or 0x8005 (Max 2 bytes).                             |
| -P,  --product_name       | optional             | string             | Product name (Max 32 char).                                                 |
| -pl, --product_label      | optional             | string             | Product label.                |
| -pu, --product_url        | optional             | string             | Product URL.                |
| -pn, --part_number        | optional             | dec/hex            | Device Part Number (Max 32 char).                                               |
| -hv, --hw_version         | optional             | dec/hex            | The hardware version value (Max 2 bytes).                                       |
| -hs, --hw_version_str     | optional             | string             | The hardware version string (Max 64 char).                                      |
| -cf, --commissioning_flow | optional             | dec/hex            | Commissioning Flow 0=Standard, 1=User Action, 2=Custom.                         |
| -rf, --rendezvous_flags   | optional             | dec/hex            | Rendez-vous flag: 1=SoftAP, 2=BLE 4=OnNetwork (Can be combined).                |
| -md, --manufacturing_date | optional             | string             | Manufacturing date.                |
| -d,  --discriminator      | optional<sup>2</sup> | dec/hex            | BLE pairing discriminator. e.g: 3840 or 0xF00. (12-bit)                                 |
| -ct, --cert_tool          | optional             | string             | Path to the chip-cert tool. Defaults to `../out/tools/chip-cert`          |
| -ki, --key_id             | required             | dec/hex            | Attestation Key ID.                |
| -kp, --key_pass           | optional<sup>3</sup> | string             | Password for the key file.                |
| -xc, --att_certs          | optional<sup>3</sup> | string             | Path to the PKCS#12 attestation certificates file.                |
| -ic, --pai_cert           | required             | string             | Path to the PAI certificate.                |
| -dc, --dac_cert           | optional<sup>3</sup> | string             | Path to the PAI certificate.                |
| -dk, --dac_key            | optional<sup>3</sup> | dec/hex            | Path to the PAI private-key.                |
| -cd, --certification      | required             | string             | Path to the Certification Declaration (CD) file.                |
| -cn, --common_name        | optional<sup>4</sup> | string             | Common Name to use in the Device Certificate (DAC) .                |
| -u,  --unique_id          | optional<sup>5</sup> | hex string         | A 128 bits hex string unique id (without 0x).                                           |
| -sv, --spake2p_verifier   | optional             | string<sup>6</sup> | Pre-generated SPAKE2+ verifier.                                          |
| -sp, --spake2p_passcode   | required             | dec/hex            | Session passcode used to generate the SPAKE2+ verifier.        |
| -ss, --spake2p_salt       | required             | string<sup>6</sup> | Salt used to generate the SPAKE2+ verifier.                             |
| -si, --spake2p_iterations | required             | dec/hex            | Iteration count used to generate the SPAKE2+ verifier.                  |

<sup>1</sup> Use xxxxxxxxx for serial, or xxx.xxx.xxx.xxx[:yyyy] for TCP.
<sup>2</sup> If not provided (or zero), the `discriminator `is calculated as the last 12 bits of SHA256(serial_number)
<sup>3</sup> If the DAC is provided, its corresponding private-key also must be provided
<sup>4</sup> Required if the DAC is not provided
<sup>5</sup> If not provided, the `unique_id` is calculated as the first 128 bits of SHA256(serial_number)
<sup>6</sup> Salt and verifier must be provided as base64 string

For the hex type, provide the value with the `0x` prefix. For hex string type, do not add the `0x` prefix.

The -c/--config argument allows to read all the required parameters from a JSON file. The same validation rules apply
both for command line or configuration file, but JSON does not support hexadecimal numbers. Command line arguments
override arguments read from a configuration file.
For instance, with the configuration `example.json`:
```
{
    "version": "1.0",
    "matter": {
        "prod_fw": "/git/matter/out/lighting-app/BRD4187C/chip-efr32-lighting-example.s37",
        "vendor_id": 4169,
        "product_id": 32773,
        "discriminator": 3841,
        "attestation": {
            "dac_cert": "temp/certs/dac_cert.pem",
            "dac_key": "temp/certs/dac_key.pem",
            "pai_cert": "temp/certs/pai_cert.pem",
            "certification": "temp/certs/cd.der",
        },
        "spake2p": {
            "passcode": 62034001,
            "salt": "95834coRGvFhCB69IdmJyr5qYIzFgSirw6Ja7g5ySYA",
            "iterations": 15000
        }
    }
}
```
You may run:
```
python3 ./provision.py -c example.json -d 2748 -p 0x8006 -si 10000
```
Which will set the connected device with discriminator 2748 (instead of 3841), product ID 32774 (instead of 32773),
and use 10000 SPAKE2+ iterations (instead of 15000).

To ease development and testing, the `provision.py` script provides defaults for most of the parameters. The only
arguments that are truly mandatory are `vendor_id`, and `product_id`. Test certificates may be auto-generated using
the -g flag, provided the `chip-cert` can be found, either in the default location, or through the `--cert-tool` argument.
For instance, you may run:
```
python3 ./provision.py -v 0x1049 -p 0x8005 -g
```
Which will generate the test certificates using `chip-cert`, and set the device with the following parameters:
```
{
    "version": "1.0",
    "matter": {
        "generate": true,
        "vendor_id": 65522,
        "product_id": 32773,
        "discriminator": 3840,
        "attestation": {
            "cert_tool": "./out/tools/chip-cert",
            "key_id": 2,
        },
        "spake2p": {
            "verifier": null,
            "passcode": 62034001,
            "salt": "95834coRGvFhCB69IdmJyr5qYIzFgSirw6Ja7g5ySYA=",
            "iterations": 15000
        }
    }
}
```

For each run, `provision.py` will generate the file `provision/config/latest.json`, containing the arguments used to set up the device.
A default configuration with developer settings can be found at `provision/config/develop.json`:

```
python ./provision.py -c config/develop.json
```

## Attestation Files

The `--generate` option instructs the `provider.py` script to generate test attestation files with the given Vendor ID, and Product ID.
These files are generated using [the chip-cert tool](../src/tools/chip-cert/README.md),
and stored under the `provision/temp` folder.

To generate the certificates manually:
```
./out/debug/chip-cert gen-cd -f 1 -V 0xfff1 -p 0x8005 -d 0x0016 -c ZIG20142ZB330003-24 -l 0 -i 0 -n 257 -t 0 -o 0xfff1 -r 0x8005 -C ./credentials/test/certification-declaration/Chip-Test-CD-Signing-Cert.pem -K ./credentials/test/certification-declaration/Chip-Test-CD-Signing-Key.pem -O ./temp/cd.der

./out/debug/chip-cert gen-att-cert -t a -l 3660 -c "Matter PAA" -V 0xfff1 -o ./temp/paa_cert.pem -O ./temp/paa_key.pem

./out/debug/chip-cert gen-att-cert -t i -l 3660 -c "Matter PAI" -V 0xfff1 -P 0x8005 -C ./temp/paa_cert.pem -K ./temp/paa_key.pem -o ./temp/pai_cert.pem -O ./temp/pai_key.pem

./out/debug/chip-cert gen-att-cert -t d -l 3660 -c "Matter DAC" -V 0xfff1 -P 0x8005 -C ./temp/pai_cert.pem -K ./temp/pai_key.pem -o ./temp/dac_cert.pem -O ./temp/dac_key.pem
```

NOTE: The commissioning fails if the commissioner do not recognize the root certificate (PAA).
When using [chip-tool](../examples/chip-tool),
you can use the `--paa-trust-store-path` to enabled the PAA certificates for testing purposes.

## Example

From the root of the Silicon Labs Matter repo, build the application using the `chip_build_platform_attestation_credentials_provider` flag:
```
./scripts/examples/gn_efr32_example.sh ./examples/lighting-app/silabs/efr32 ./out/lighting-app/ BRD2703A chip_build_platform_attestation_credentials_provider=true
```

Set up the device with key generation:
```
python3 ./provision.py -v 0x1049 -p 0x8005 \
    -r -ki 2 -cn "Silabs Device" -ic ./temp/pai_cert.pem -cd ./temp/cd.der \
    -sp 62034001 -ss 95834coRGvFhCB69IdmJyr5qYIzFgSirw6Ja7g5ySYA= -si 15000 \
    -d 0xf01 -j 440266330 -pf /git/matter/core/out/lighting-app/BRD4187C/chip-efr32-lighting-example.s37
```

Or, set up the device with imported key:
```
python3 ./provision.py -v 0x1049 -p 0x8005 \
    -ki 2 -cn "Silabs Device" -dc ./temp/dac_cert.pem  -dk ./temp/dac_key.pem  -ic ./temp/pai_cert.pem -cd ./temp/cd.der \
    -sp 62034001 -ss 95834coRGvFhCB69IdmJyr5qYIzFgSirw6Ja7g5ySYA= -si 15000 \
    -d 0xf01 -j 440266330 -pf /git/matter/core/out/lighting-app/BRD4187C/chip-efr32-lighting-example.s37
```

## Self-Provisioning

Silicon Labs' Matter examples include the same provisioning engine used by the GFW. This allows applications to be flashed once but provisioned multiple times. There are two ways to put the application in provisioning mode:
* Factory-reset by pressing both BTN0 and BTN1 for six seconds
* Write 1 to the NVM3 key 0x87228. This is useful in boards with less than two buttons, and can be accomplished using Simplicity Commander:
```
commander nvm3 read -o ./temp/nvm3.s37
commander nvm3 set ./temp/nvm3.s37 --object 0x87228:01 --outfile ./temp/nvm3+.s37
commander flash ./temp/nvm3+.s37
```
Once in provisioning mode, the example firmware can be used as GFW, for instance:
```
python3 provision.py -c config/develop.json -gf ../out/light/BRD4187C/matter-silabs-lighting-example.s37
```
If the device was factory-reset, it becomes ready for commissioning right after self-provisioning.


## Validation

If the certificate injection is successful, the commissioning process should
complete normally. In order to verify that the new certificates are actually
being used, first check the last page of the flash using Commander. The content
of the flash must then be compared with the credentials received by the
commissioner, which can be done using a debugger.

### Flash Dump

On EFR32MG12, the last page starts at address 0x000FF800. On EFR32MG24,
the last page is located at 0x0817E000. These addresses can be found in
the memory map of the board's datasheet. For instance, for a MG24 board:

```shell
commander readmem --range 0x0817E000:+1536 --serialno 440266330`
```

The output should look something like:

commander readmem --range 0x0817E000:+1536 --serialno 440266330
Reading 1536 bytes from 0x0817e000...
{address:  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F}
000ff800: 30 82 01 D8 30 82 01 7F A0 03 02 01 02 02 04 07
000ff810: 5B CD 15 30 0A 06 08 2A 86 48 CE 3D 04 03 02 30
...
000ff9c0: 2B BA 15 32 2F 4C 69 F2 38 48 D2 BC 62 2A 47 FB
000ff9d0: 3F F7 28 8A 7C 90 75 72 58 84 96 E7 00 00 00 00
000ff9e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000ff9f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000ffa00: 30 82 01 C8 30 82 01 6E A0 03 02 01 02 02 08 79
000ffa10: 6E 32 5A FA 5B D1 F8 30 0A 06 08 2A 86 48 CE 3D
...
000ffbb0: FD 92 D1 EB 59 95 D8 38 DE 5D 80 E3 05 65 24 4A
000ffbc0: 62 FD 9F E9 D8 00 FA CD 0F 32 7C C9 00 00 00 00
000ffbd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000ffbe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000ffbf0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000ffc00: 30 81 EF 06 09 2A 86 48 86 F7 0D 01 07 02 A0 81
000ffc10: E1 30 81 DE 02 01 03 31 0D 30 0B 06 09 60 86 48
...
000ffce0: 28 41 FD B8 28 CD 19 F2 BB DB A0 0F 33 B2 21 D3
000ffcf0: 33 CE 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000ffd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


On this example, the DAC is located at address 0817e000 (offset 0), and
has 476 octets:
0817e000: 30 82 01 D9 30 82 01 7F A0 03 02 01 02 02 04 07
0817e010: 5B CD 15 30 0A 06 08 2A 86 48 CE 3D 04 03 02 30
...
0817e1c0: 2E 4F 10 20 38 BA A6 B5 F6 A4 77 7A 19 91 23 79
0817e1d0: 2F A0 FF AF F5 5C A1 59 98 08 C7 BC 5F 00 00 00

This should match the contents of the DER-formatted DAC certificate, which is
stored by the setup script as ./temp/dac.der :

```shell
$ xxd ./temp/dac.der
```
00000000: 3082 01d8 3082 017f a003 0201 0202 0407  0...0...........
00000010: 5bcd 1530 0a06 082a 8648 ce3d 0403 0230  [..0...*.H.=...0
...
000001c0: 2bba 1532 2f4c 69f2 3848 d2bc 622a 47fb  +..2/Li.8H..b*G.
000001d0: 3ff7 288a 7c90 7572 5884 96e7            ?.(.|.urX...


The PAI certificate is located at address 0x0817e200 (offset 512), and
has 460 octets:
0817e200: 30 82 01 C8 30 82 01 6E A0 03 02 01 02 02 08 79
0817e210: 6E 32 5A FA 5B D1 F8 30 0A 06 08 2A 86 48 CE 3D
...
0817e3b0: FD 92 D1 EB 59 95 D8 38 DE 5D 80 E3 05 65 24 4A
0817e3c0: 62 FD 9F E9 D8 00 FA CD 0F 32 7C C9 00 00 00 00

This should match the contents of the DER-formatted PAI certificate, which is
stored by the setup script as ./temp/pai_cert.der :

```shell
$ xxd ./temp/pai_cert.der
```
00000000: 3082 01c8 3082 016e a003 0201 0202 0879  0...0..n.......y
00000010: 6e32 5afa 5bd1 f830 0a06 082a 8648 ce3d  n2Z.[..0...*.H.=
...
000001b0: fd92 d1eb 5995 d838 de5d 80e3 0565 244a  ....Y..8.]...e$J
000001c0: 62fd 9fe9 d800 facd 0f32 7cc9            b........2|.


Finally, on this example the CD is located at address 0817e400
(offset 1024), and contains 541 octets:
0817e400: 30 81 EF 06 09 2A 86 48 86 F7 0D 01 07 02 A0 81
0817e410: E1 30 81 DE 02 01 03 31 0D 30 0B 06 09 60 86 48
...
0817e4d0: 02 20 38 B9 9C 73 B2 30 92 D7 A2 92 47 30 14 F7
0817e4e0: 28 41 FD B8 28 CD 19 F2 BB DB A0 0F 33 B2 21 D3
0817e4f0: 33 CE 00 00 00 00 00 00 00 00 00 00 00 00 00 00

The CD is a binary file, and is neither modified, nor validated by the setup
script. It is simply stored in flash after the DAC:

```shell
$ xxd cd.der
```
00000000: 3081 ef06 092a 8648 86f7 0d01 0702 a081  0....*.H........
00000010: e130 81de 0201 0331 0d30 0b06 0960 8648  .0.....1.0...`.H
...
000000e0: 2841 fdb8 28cd 19f2 bbdb a00f 33b2 21d3  (A..(.......3.!.
000000f0: 33ce                                     3.

The 0xff octets between the files and at the end of the flash are unmodified
sections of the flash storage.

### Device Terminal

Logs have beed added to the SilabsDeviceAttestationCreds, to help verifying if the Attestation
files are loaded correctly. The size and first eight bytes of CD, PAI, and DAC are printed, and
must match the contents of `cd.der`, `pai_cert.der`, and `dac.der`, respectively:
```
...
[00:00:05.109][info  ][ZCL] OpCreds: Certificate Chain request received for PAI
[00:00:05.109][info  ][DL] GetProductAttestationIntermediateCert, addr:0xffa00, size:460
[00:00:05.110][detail][ZCL] 0x30, 0x82, 0x01, 0xc8, 0x30, 0x82, 0x01, 0x6e,
...
[00:00:05.401][info  ][ZCL] OpCreds: Certificate Chain request received for DAC
[00:00:05.402][info  ][DL] GetDeviceAttestationCert, addr:0xff800, size:477
[00:00:05.402][detail][ZCL] 0x30, 0x82, 0x01, 0xd8, 0x30, 0x82, 0x01, 0x7f,
...

[00:00:05.694][info  ][ZCL] OpCreds: Received an AttestationRequest command
[00:00:05.695][info  ][DL] GetCertificationDeclaration, addr:0xffc00, size:242
[00:00:05.695][detail][ZCL] 0x30, 0x81, 0xef, 0x06, 0x09, 0x2a, 0x86, 0x48,
...
```

## Board Support

Pre-compiled images of the Generator Firmware can be found under provision/images. The source
code of these images is found under provision/support. A single image is provided for all EFR32MG12
parts, and another one for the EFR32MG24 family. To copy with the different flash sizes, the
`provision.py` script reads the device information using `commander`, and send it to the GFW,
which configures the NVM3 during the initialization step.
