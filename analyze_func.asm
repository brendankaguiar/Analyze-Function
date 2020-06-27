;----------------------------------------------------------------------------------------
; FILE NAME:	analyze_func.asm
;
; DESCRIPTION:	NASM program for Linux, Intel, IA-32
;		shows parameter passing via registers.
;
; ASSEMBLY:	nasm -f elf analyze_func.asm
; LINKING:	ld -m elf_i386 -s -o analyze_func analyze_func.o cs219_io.o
; TO RUN:	./analyze_func
;
; INPUT:	Input the a, b, c, and x values that make up a quadratic poynomial.
; OUTPUT:	f(x), the value of the polynomial at x.
;		f'(x), the value of the derivative at x.
; 
; MODIFICATION HISTORY:
;
; Author		Date		Version
;--------------------------------------------------------------------------------------
; Brendan Aguiar	05/07/2020	Started framework from array_test3.asm
;---------------------------------------------------------------------------------------

%include "cs219_io.mac"

segment .data			        ; segment for initialized data
 prompt1 db "Enter Coefficient [0]: " , 0 ; uses array to print coefficients
 prompt2 db "f(x) = a*x^2 + b*x + c", 0 ; polynomial form
 prompt3 dw "Enter input value [x]: ", 0 ; prompts user for x value
 prompt4 db "f(x) = ", 0		; pt1/3 of polynomial display
 prompt5 db "x^2 + ", 0			; pt 2/3 of polynomial display
 prompt6 db "x + ", 0			; pt 3/3 of polynomial and 2/2 derivative display
 prompt7 db "f'(x) = ", 0		; pt 1/2 of derivative display
; prompt8 dw "f(0) = 0*(0)^2 + 0*(0)  + 0 = 0", 0 ; uses array to print coeffecients
 SIZE	EQU 3				; size of array

segment .bss				; segment for the uninitialized data
 array	resd SIZE			; reserve Doublewords (4 bytes each)
 chr	resb 1				; reserve one byte for "chr"
 varx	resd 1				; reserve four bytes for "x" variable
; vary	resd 1				; reserve four bytes for "y" variable
segment .text				; segment for the code

 global _start

_start:
 nwln					; newline character
 PutStr prompt2				; Prints prompt2
 nwln
 nwln
 
 call	get_input			; read into the array
 call	display_f_of_x			; displays f(x)
 call	display_fp_of_x			; displays f'(x)
 nwln 
; call	eval_f_of_x			; calculate f(x)
;call	eval_fp_of_x			; calculate f'(x)
 nwln
done:
 exit

;----------------------------------------------------------------------------------------
; Procedure Name:	display_f_of_x
; Description:		Prints f_of_x with given coefficients
;----------------------------------------------------------------------------------------

display_f_of_x:
 mov		EBX, array		; EBX = pointer to array
 mov		ECX, SIZE		; ECX = size of array
 PutStr		prompt4			; pt 1/3 of polynomial display
 PutLInt	[EBX]			; display value at array[i]
 add		EBX, 4			; increment array pointer
 PutStr		prompt5			; pt 2/3 of polynomial display
 PutLInt	[EBX]			; display value at array[i]
 add		EBX, 4			; increment array pointer
 PutStr		prompt6			; pt 3/3 of polynomial display
 PutLInt	[EBX]			; display value at array[i]
 nwln
 ret					; return to "main"
;----------------------------------------------------------------------------------------
; Procedure Name:	display_fp_of_x
; Description:		Prints fp_of_x 
;----------------------------------------------------------------------------------------

display_fp_of_x:
 mov		EBX, array		; EBX = pointer to array
 mov		ECX, SIZE		; ECX = size of array
 PutStr		prompt7			; pt 1/2 of derivative display
 mov		EAX, [EBX]		; pass value of EBX into EAX
 add		EAX, EAX		; multiply value at array[i]*2
 PutLInt	EAX			; display value at array[i]
 add		EBX, 4			; increment array pointer
 PutStr		prompt6			; pt 2/2 of derivative display
 PutLInt	[EBX]			; display value at array[i]
 nwln
 ret					; return to "main"

;----------------------------------------------------------------------------------------
; Procedure Name:	get_input
; Description: 		Gets coeffiecients and puts into array
;			Gets value for varx.
;----------------------------------------------------------------------------------------

get_input:
 mov		[chr], byte 'a'		; ASCII value for letter character
 mov		EBX, array		; store array address to register EBX
 mov		ECX, SIZE		; store array size to register ECX

array_loop:
 mov		AL, [chr]		; chr needs to pass through register
 mov		[prompt1+19], AL	; write character to prompt1[18]
 PutStr		prompt1			; prompt for input value
 GetLInt	[EBX]			; read long integer into EBX
 add		EBX, 4			; increment array address
 inc		byte [chr]		; increment character's ASCII value
 loop		array_loop		; iterates SIZE times
 
 PutStr		prompt3			; prompts for the input of x value
 GetLInt	[varx]			; reads long integer into varx
 ret					; return to "main"

;----------------------------------------------------------------------------------------
; Procedure Name:	eval_f_of_x
; Description:		Prints f_of_x with coeffs., 
;----------------------------------------------------------------------------------------

;eval_f_of_x:
 ;mov		EBX, array		; store array address to register EBX
; mov		ECX, SIZE		; store array size to register ECX
; mov		EAX, varx		; chr needs to pass through register
; mov		[prompt8+3], EAX	; write character to prompt1[18]
; mov		[prompt8+8], [EBX]	;
; add		EBX, 4			; increment array address
;PutStr		prompt8			; prompt for input value
; ret					; return to main
