.include "m8515def.inc"

.equ ROW_CLOCK  = PD7
.equ ROW_DATA   = PD6
.equ COL_LATCH  = PD5
.equ COL_CLOCK  = PD4
.equ COL_DATA   = PD3
.equ COL_ENABLE = PD2

; -----------------------------------------------------------------------------
.org 0x0000
 rjmp   reset


; -----------------------------------------------------------------------------
.dseg


; -----------------------------------------------------------------------------
.cseg
reset:
 ldi    r16,        low(RAMEND)     ; Initialise stack pointer to end of SRAM
 out    SPL,        r16
 ldi    r16,        high(RAMEND)
 out    SPH,        r16

 call   init_ports
 call   white_as_fuck
 sbi    PORTD,      COL_ENABLE

 jmp     main

; -----------------------------------------------------------------------------
main:
 sbi    PORTD,      ROW_DATA
 sbi    PORTD,      ROW_CLOCK
 cbi    PORTD,      ROW_CLOCK
 cbi    PORTD,      ROW_DATA

 ldi    r18,        $19
loop1:
 sbi    PORTD,      ROW_CLOCK
 cbi    PORTD,      ROW_CLOCK
 dec    r18
 brne   loop1

 rjmp   main

; -----------------------------------------------------------------------------
init_ports:
 ldi    r16,        0xCF            ; Pin 2-7 are output pins on port D
 out    DDRD,       r16
 ret

; -----------------------------------------------------------------------------
white_as_fuck:
;push   SREG
 sbi    PORTD,      COL_DATA        ; Here we shift a logic "1" 48 times into
 ldi    r18,        $48             ; the external shift registers.
loop:
 sbi    PORTD,      COL_CLOCK
 nop
 nop
 cbi    PORTD,      COL_CLOCK
 dec    r18
 brne   loop

 cbi    PORTD,      COL_LATCH       ; Latch the data we shifted
 SBI    PORTD,      COL_LATCH

;pop    r0
 ret
