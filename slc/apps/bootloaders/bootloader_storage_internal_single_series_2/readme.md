# Internal Storage Bootloader (Single Image on 512 KB Device)

Internal storage bootloader for 512 KB devices. Single image slot at 0x44000 (192 kB). Default for Matter projects. See UG489 for configuration and storage layout.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This sample configuration of the simplicity bootloader configures the bootloader to use the internal main flash to store firmware update images. The storage configuration is set up to store a single firmware update image at a time, in a single storage slot. The storage slot is configured to start at address 0x44000 (or 0x8044000 for device with 0x8000000 flash base), and have a size of 192 kB. This can be configured on the *"Bootloader Storage Slot Setup"*. This is the default bootloader configuration to use with Matter projects.

When changing the storage layout of the bootloader, ensure that there is no overlap between the memory space the bootloader expects to use and the memory space the application or NVM system expects to use.

**Note**: This sample configuration will not use all available flash space for bootloader storage. As the memory layout may differ between different application projects, this bootloader project has a safe configuration that ensures that it doesn't overlap with any application sample configuration. This comes at the expense of leaving some unused flash space. Always make sure to configure your bootloader to use the same area for storage as is set aside by your application.

For information about multiple storage slot support, see the "Internal Storage Bootloader (multiple images)" sample configuration.

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

1. Build the bootloader project for your target board, or use a pre-built binary.
2. Flash the bootloader to the device before flashing the application. Pre-built bootloader binaries for supported devices are available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.0/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

## Troubleshooting

- **Storage overlap:** Ensure the bootloader storage slot does not overlap with application or NVM memory. Adjust *Bootloader Storage Slot Setup* to match the layout expected by your application.
- For configuration and security options, see *UG489: Simplicity Bootloader User's Guide*.

## Resources

- [UG489: Simplicity Bootloader User's Guide](https://www.silabs.com/documents/public/user-guides/ug489-gecko-bootloader-user-guide-gsdk-4.pdf)
- [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.0/matter-prerequisites/matter-artifacts#matter-bootloader-binaries)
- [Matter Prerequisites](https://docs.silabs.com/matter/2.9.0/matter-prerequisites)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
