;
; attiny13star.asm
;
; Created: 8/19/2021 10:53:54 PM
; Author : pappan
;
.DEF  TEMP = R16
.equ    fclk    = 1000000

.macro micros
ldi temp,@0
rcall delayTx1uS
.endm

.macro millis
ldi YL,low(@0)
ldi YH,high(@0)
rcall delayYx1mS
.endm

.cseg
ldi r16,(1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0)
out ddrb,r16
ldi r16, 0x00
out portb,r16
cycle:
rcall mode1
rcall mode2
rcall mode1
rcall mode3
rcall mode1
rcall mode4
rcall mode1
rcall mode5
rjmp cycle




mode1:
sbi portb,0
millis 1000
cbi portb,0
sbi portb,1
millis 1000
cbi portb,1
sbi portb,2
millis 1000
cbi portb,2
sbi portb,3
millis 1000
cbi portb,3
sbi portb,4
millis 1000
cbi portb,4
ret

mode2:
ldi r20,3
loop1:
sbi portb,0
millis 100
cbi portb,0
millis 100
sbi portb,1
millis 100
cbi portb,1
millis 100
sbi portb,2
millis 100
cbi portb,2
millis 100
sbi portb,3
millis 100
cbi portb,3
millis 100
sbi portb,4
millis 100
cbi portb,4
dec r20
brne loop1 
ret

mode3:
ldi r20,3
loop2:
sbi portb,0
millis 100
sbi portb,1
millis 100
sbi portb,2
millis 100
sbi portb,3
millis 100
sbi portb,4
millis 100
clr r16
out portb,r16
dec r20
brne loop2
ret


mode4:
ldi r20,3
loop3:
ldi r16,(1<<PB4)|(1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0)
out portb,r16
millis 100
clr r16
out portb,r16
millis 100
dec r20
brne loop2
ret


mode5:
ldi r20,3
loop4:
sbi portb,0
millis 100
cbi portb,0
millis 100
sbi portb,2
millis 100
cbi portb,2
millis 100
sbi portb,4
millis 100
cbi portb,4
millis 100
sbi portb,1
millis 100
cbi portb,1
millis 100
sbi portb,3
millis 100
cbi portb,3
dec r20
brne loop4 
ret










































; ============================== Time Delay Subroutines =====================
; Name:     delayYx1mS
; Purpose:  provide a delay of (YH:YL) x 1 mS
; Entry:    (YH:YL) = delay data
; Exit:     no parameters
; Notes:    the 16-bit register provides for a delay of up to 65.535 Seconds
;           requires delay1mS

delayYx1mS:
    rcall    delay1mS                        ; delay for 1 mS
    sbiw    YH:YL, 1                        ; update the the delay counter
    brne    delayYx1mS                      ; counter is not zero

; arrive here when delay counter is zero (total delay period is finished)
    ret
; ---------------------------------------------------------------------------
; Name:     delayTx1mS
; Purpose:  provide a delay of (temp) x 1 mS
; Entry:    (temp) = delay data
; Exit:     no parameters
; Notes:    the 8-bit register provides for a delay of up to 255 mS
;           requires delay1mS

delayTx1mS:
    rcall    delay1mS                        ; delay for 1 mS
    dec     temp                            ; update the delay counter
    brne    delayTx1mS                      ; counter is not zero

; arrive here when delay counter is zero (total delay period is finished)
    ret

; ---------------------------------------------------------------------------
; Name:     delay1mS
; Purpose:  provide a delay of 1 mS
; Entry:    no parameters
; Exit:     no parameters
; Notes:    chews up fclk/1000 clock cycles (including the 'call')

delay1mS:
    push    YL                              ; [2] preserve registers
    push    YH                              ; [2]
    ldi     YL, low(((fclk/1000)-18)/4)     ; [1] delay counter              (((fclk/1000)-18)/4)
    ldi     YH, high(((fclk/1000)-18)/4)    ; [1]                            (((fclk/1000)-18)/4)

delay1mS_01:
    sbiw    YH:YL, 1                        ; [2] update the the delay counter
    brne    delay1mS_01                     ; [2] delay counter is not zero

; arrive here when delay counter is zero
    pop     YH                              ; [2] restore registers
    pop     YL                              ; [2]
    ret                                     ; [4]

; ---------------------------------------------------------------------------
; Name:     delayTx1uS
; Purpose:  provide a delay of (temp) x 1 uS with a 16 MHz clock frequency
; Entry:    (temp) = delay data
; Exit:     no parameters
; Notes:    the 8-bit register provides for a delay of up to 255 uS
;           requires delay1uS

delayTx1uS:
    rcall    delay10uS                        ; delay for 1 uS
    dec     temp                            ; decrement the delay counter
    brne    delayTx1uS                      ; counter is not zero

; arrive here when delay counter is zero (total delay period is finished)
    ret

; ---------------------------------------------------------------------------
; Name:     delay10uS
; Purpose:  provide a delay of 1 uS with a 16 MHz clock frequency ;MODIFIED TO PROVIDE 10us with 1200000cs chip by Sajeev
; Entry:    no parameters
; Exit:     no parameters
; Notes:    add another push/pop for 20 MHz clock frequency

delay10uS:
    ;push    temp                            ; [2] these instructions do nothing except consume clock cycles
    ;pop     temp                            ; [2]
    ;push    temp                            ; [2]
    ;pop     temp                            ; [2]
    ;ret                                     ; [4]
     nop
     nop
     nop
     ret

; ============================== End of Time Delay Subroutines ==============
