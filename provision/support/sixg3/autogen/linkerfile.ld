/***************************************************************************//**
 * GCC Linker script for Silicon Labs devices
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * SPDX-License-Identifier: Zlib
 *
 * The licensor of this software is Silicon Laboratories Inc.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 ******************************************************************************/





 MEMORY
 {
   FLASH_S    (rx)  : ORIGIN = 0x11000000, LENGTH = 0x8000
   FLASH      (rx)  : ORIGIN = 0x1008000, LENGTH = 0x3c8000
   RAM        (rwx) : ORIGIN = 0x20000000, LENGTH = 0x80000
   RAM_ALIAS  (x)   : ORIGIN = 0x800000, LENGTH = 0x80000
 }

__flash_size__ = 0x3d0000;
__flash_page_size__ = 0x1000;
__secure_flash_size__ = 0x8000;


ENTRY(Secure_Reset_Handler)

SECTIONS
{
  .secure_vectors :
  {
    KEEP(*(.secure_vectors))
  } > FLASH_S

  .secure_text :
  {
    *(SORT_BY_ALIGNMENT(.secure_text*))
    . = ALIGN(32);
  } > FLASH_S

  .vectors :
  {
    linker_vectors_begin = .;
    KEEP(*(.vectors))
    linker_vectors_end = .;

    __Vectors_End = .;
    __Vectors_Size = __Vectors_End - __Vectors;
    __lma_ramfuncs_start__ = .;
  } > FLASH
  text_ram :
  {
    . = ALIGN(4);
    __vma_ramfuncs_start__ = .;
    /* text_application_ram */
    __text_application_ram_start__ = .;

    *(text_application_ram)

    . = ALIGN(4);
    __text_application_ram_end__ = .;

    /* text_<component>_ram */
    __text_system_ram_start__ = .;
    *(text_system_*timecritical*)

    . = ALIGN(4);
    __text_system_ram_end__ = .;
    __text_clock_manager_ram_start__ = .;
    *(text_clock_manager_*timecritical*)

    . = ALIGN(4);
    __text_clock_manager_ram_end__ = .;
    __text_hal_gpio_ram_start__ = .;
    *(text_hal_gpio_*timecritical*)

    . = ALIGN(4);
    __text_hal_gpio_ram_end__ = .;
    __text_core_ram_start__ = .;
    *(text_core_*timecritical*)

    . = ALIGN(4);
    __text_core_ram_end__ = .;
    *libgcc.a:_*.*(.text*)
    *libgcc.a:_*.*(.rodata*)
    *memset.*(.text*)
    *memset.*(.rodata*)
    *cmsis_os2.*(.text*)
    *cmsis_os2.*(.rodata*)
    *croutine.*(.text*)
    *croutine.*(.rodata*)
    *event_groups.*(.text*)
    *event_groups.*(.rodata*)
    *list.*(.text*)
    *list.*(.rodata*)
    *queue.*(.text*)
    *queue.*(.rodata*)
    *stream_buffer.*(.text*)
    *stream_buffer.*(.rodata*)
    *tasks.*(.text*)
    *tasks.*(.rodata*)
    *timers.*(.text*)
    *timers.*(.rodata*)
    *portasm.*(.text*)
    *portasm.*(.rodata*)
    *port.*(.text*)
    *port.*(.rodata*)

    . = ALIGN(4);
    __vma_ramfuncs_end__ = .;
  } > RAM_ALIAS AT > FLASH

  .rodata :
  {
    __lma_ramfuncs_end__ = .;
    __rodata_start__ = .;
    __rodata_end__ = .;
  } > FLASH

  .text :
  {
    linker_code_begin = .;
    *(SORT_BY_ALIGNMENT(.text*))
    *(SORT_BY_ALIGNMENT(text_*))
    . = ALIGN(32);
    linker_code_end = .;

    KEEP(*(.init))
    KEEP(*(.fini))

    /* .ctors */
    *crtbegin.o(.ctors)
    *crtbegin?.o(.ctors)
    *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
    *(SORT(.ctors.*))
    *(.ctors)

    /* .dtors */
    *crtbegin.o(.dtors)
    *crtbegin?.o(.dtors)
    *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
    *(SORT(.dtors.*))
    *(.dtors)
    *(.rodata*)
    *(.eh_frame*)
  } > FLASH

  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > FLASH

  __exidx_start = .;
  .ARM.exidx :
  {
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
  } > FLASH
  __exidx_end = .;

  .copy.table :
  {
    . = ALIGN(4);
    __copy_table_start__ = .;

    LONG (__etext)
    LONG (__data_start__)
    LONG ((__data_end__ - __data_start__) / 4)

    /* Add each additional data section here */
    /*
    LONG (__etext2)
    LONG (__data2_start__)
    LONG ((__data2_end__ - __data2_start__) / 4)
    */
    __copy_table_end__ = .;
  } > FLASH

  .zero.table :
  {
    . = ALIGN(4);
    __zero_table_start__ = .;
    /* Add each additional bss section here */
    /*
    LONG (__bss2_start__)
    LONG ((__bss2_end__ - __bss2_start__) / 4)
    */
    __zero_table_end__ = .;
    __etext = .;
  } > FLASH

  .stack (NOLOAD):
  {  
    /* Offset the location counter to account for RAM code that was placed in
       the aliased RAM region.
     */
    . += (__vma_ramfuncs_end__ - __vma_ramfuncs_start__);    
    . = ALIGN(8);
    __StackLimit = .;
    KEEP(*(.stack*))
    . = ALIGN(4);
    __StackTop = .;
    PROVIDE(__stack = __StackTop);
  } > RAM

  .noinit (NOLOAD):
  {
    *(.noinit*);
  } > RAM

  .bss :
  {
    . = ALIGN(4);
    __bss_start__ = .;
    *(SORT_BY_ALIGNMENT(.bss*))
    *(COMMON)
    . = ALIGN(4);
    __bss_end__ = .;
  } > RAM

  .data :
  {
    . = ALIGN(4);
    __data_start__ = .;
    *(vtable)
    *(SORT_BY_ALIGNMENT(.data*))
    . = ALIGN(4);

    . = ALIGN(4);
    /* preinit data */
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP(*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);

    . = ALIGN(4);
    /* init data */
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP(*(SORT(.init_array.*)))
    KEEP(*(.init_array))
    PROVIDE_HIDDEN (__init_array_end = .);

    . = ALIGN(4);
    /* finit data */
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP(*(SORT(.fini_array.*)))
    KEEP(*(.fini_array))
    PROVIDE_HIDDEN (__fini_array_end = .);

    . = ALIGN(4);
    /* Shareable data sections here */
    __start_shareable = .;
    *(.rail_shareable)
    /* Add each additional shareable sections here */
    __stop_shareable = .;
    . = ALIGN(4);
    *(SEGGER_RTT)

    . = ALIGN(4);
    /* All data end */
    __data_end__ = .;

  } > RAM AT > FLASH
  .memory_manager_heap (NOLOAD):
  {
    . = ALIGN(8);
    __HeapBase = .;
    __end__ = .;
    end = __end__;
    _end = __end__;
    KEEP(*(.memory_manager_heap*))
    __HeapLimit = ORIGIN(RAM) + LENGTH(RAM);
  } > RAM

  __heap_size = __HeapLimit - __HeapBase;
  __ram_end__ = 0x20000000 + 0x80000;
  __main_flash_end__ = 0x1008000 + 0x3c8000;

   /* This is where we handle flash storage blocks. We use dummy sections for finding the configured
   * block sizes and then "place" them at the end of flash when the size is known. */
  .internal_storage (DSECT) : {
    KEEP(*(.internal_storage*))
  } > FLASH


  .nvm (DSECT) : {
    KEEP(*(.simee*))
  } > FLASH
  __ramfuncs_start__ = ORIGIN(RAM) + (__vma_ramfuncs_start__ - ORIGIN(RAM_ALIAS));
  __ramfuncs_end__ = ORIGIN(RAM) + (__vma_ramfuncs_end__ - ORIGIN(RAM_ALIAS));

  linker_nvm_end = __main_flash_end__;
  linker_nvm_begin = linker_nvm_end - SIZEOF(.nvm);
  linker_storage_end = linker_nvm_begin;
  __nvm3Base = linker_nvm_begin;

  linker_storage_begin = linker_storage_end - SIZEOF(.internal_storage);
  ASSERT((linker_storage_begin >= (__etext + SIZEOF(.data))), "FLASH memory overflowed !")


  app_flash_end = 0x1008000 + 0x3c8000;
  ASSERT( (linker_nvm_begin + SIZEOF(.nvm)) <= app_flash_end, "NVM3 is excessing the flash size !")
}
