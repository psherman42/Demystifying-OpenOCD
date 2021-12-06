OUTPUT_ARCH("riscv")

ENTRY( _start )

MEMORY
{
/*rom          : ORIGIN = 0x20000000, LENGTH = 0x20000000 */ /* 512MB off-chip, max */
  rom          : ORIGIN = 0x20000000, LENGTH = 0x1000000     /* 16MB off-chip */
  ram (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 0x4000 /* 16KB on-chip */
}

SECTIONS
{
  .text :
  {
    PROVIDE(_text_start = .);
    *(.text*)
    PROVIDE(_text_end = .);
  }
  > ram  /* ram or rom */

  . = ALIGN(4);

  .rodata :
  {
    PROVIDE(_rodata_start = .);
    *(.rodata*)
    PROVIDE(_rodata_end = .);
  }
  > ram  /* ram or rom */

  . = ALIGN(4);

  .bss :
  {
    PROVIDE(_bss_start = .);
    *(.bss*)
    PROVIDE(_bss_end = .);
  }
  > ram
}
