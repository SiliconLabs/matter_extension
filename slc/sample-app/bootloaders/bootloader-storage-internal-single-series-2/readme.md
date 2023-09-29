# Internal Storage Bootloader (Single Image on 512 KB Device)

This sample configuration of the Gecko bootloader configures the bootloader to use the internal main flash to store firmware update images. The storage configuration is set up to store a single firmware update image at a time, in a single storage slot. The storage slot is configured to start at address 0x44000 (or 0x8044000 for device with 0x8000000 flash base), and have a size of 192 kB. This can be configured on the *"Bootloader Storage Slot Setup"*.This is the default bootloader configuration to use with Matter projects.

When changing the storage layout of the bootloader, ensure that there is no overlap between the memory space the bootloader expects to use and the memory space the application or NVM system expects to use.

**Note**: This sample configuration will not use all available flash space for bootloader storage. As the memory layout may differ between different application projects, this bootloader project has a safe configuration that ensures that it doesn't overlap with any application sample configuration. This comes at the expense of leaving some unused flash space. Always make sure to configure your bootloader to use the same area for storage as is set aside by your application.

For information about multiple storage slot support, see the "Internal Storage Bootloader (multiple images)" sample configuration.

See *UG489: Gecko Bootloader User's Guide* to learn more about how to configure the bootloader, configure storage layout, enable security features, etc.
