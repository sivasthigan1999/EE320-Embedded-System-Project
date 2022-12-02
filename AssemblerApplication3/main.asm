;
; AssemblerApplication3.asm
;
; Created: 28/11/2022 05:56:06
; Author : Sivasthigan
;


.include "m328pdef.inc"
	.def	mask 	= r16		; mask register
	.def	ledR 	= r17		; led register
	.def	oLoopR 	= r18		; outer loop register
	.def	iLoopRl = r24		; inner loop register low
	.def	iLoopRh = r25		; inner loop register high

	.equ	oVal 	= 71		; outer loop value
	.equ	iVal 	= 28168		; inner loop value

	.cseg
	.org	0x00
	clr	ledR			; clear led register
	ldi	mask,(1<<PIND0)		; load 00000001 into mask register
	out	DDRB,mask		; set PINB0 to output


start:
	SBI DDRD, 0		;Set PD0 as output
	CBI DDRB, 4		;Set PB4 as input
	SBI DDRD, 1		;Set PD1 as output
	CBI DDRB, 0		;Set PB0 as input
	SBI DDRD, 2		;Set PD2 as output


forever:
L1:	SBIS PINB, 4	; Skip below statement if detection is get from pir
	RJMP L3
	
	 

	eor	ledR,mask		; toggle PINB0 in led register
	out	PORTD,ledR		; write led register to PORTB
	ldi	oLoopR,oVal		; initialize outer loop count

	oLoop:	
		ldi	iLoopRl,LOW(iVal)	; intialize inner loop count in inner
		ldi	iLoopRh,HIGH(iVal)	; loop high and low registers


	iLoop:
		sbiw	iLoopRl,1		; decrement inner loop registers
		brne	iLoop			; branch to iLoop if iLoop registers != 0
		dec	oLoopR		; decrement outer loop register
		brne	oLoop			; branch to oLoop if outer loop register != 0
	


L2:	SBIS PINB, 0	; Skip below statement if detection is get from IR
	RJMP L4
	SBI PORTD, 1	; Turn ON LED PD1 if pressed 
	SBI PORTD, 2	; Turn ON Buzzar if pressed 
	SBIC PINB, 0	; Skip below statement if no detection is get from IR
	RJMP L1

L3: CBI PORTD, 0
	rjmp L2

L4: CBI PORTD, 1
	CBI PORTD, 2	; Turn OFF LED PD2 if not pressed
	rjmp L1
