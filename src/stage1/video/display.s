;========================================================================================
; Copyright (c) 2013, Adrian Collado & Voltoid Technologies
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;     * Redistributions of source code must retain the above copyright
;		notice, this list of conditions and the following disclaimer.
;	  * Redistributions in binary form must reproduce the above copyright
;		notice, this list of conditions and the following disclaimer in the
;		documentation and/or other materials provided with the distribution.
;	  * Neither the names of Charge nor the names of its contributors may be
;		used to endorse or promote products derived from this software without
;		prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL ADRIAN COLLADO OR VOLTOID TECHNOLOGIES BE LIABLE
; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
; SERVICES; LOSS OF USE, DATA OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
; AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
;========================================================================================
; Date: 2/26/2013 - 2/XX/2013
;========================================================================================
%ifndef _CHARGE_VIDEO_DISPLAY_S
%define _CHARGE_VIDEO_DISPLAY_S

; VideoDisplayChar - Displays a single ASCII Char
; Input:
;	AL - ASCII Character to display
VideoDisplayChar:
	; Push many registers.
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH BP
	
	; We will be using the teletype output function, which is 0x0E.
	MOV AH, 0x0E
	
	; We then must set the display page.
	MOV BH, [VideoDisplayPage]
	
	; Now we execute the interrupt.
	INT 0x10
	
	; Now we pop the previously pushed registers.
	POP BP
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	
	; Now we return.
	RET
	
; VideoDisplayString - Displays an ASCII String
; Input:
;	DS:SI - Address of the ASCII String
VideoDisplayString:
	; If we determined before that there was no video card, then
	; there is no reason to print a string. If the flag for 'Video
	; Card Present' is zero, we will just return.
	CMP BYTE [VideoCardFlags], 0
	JNE .PrintString
	RET
	
	.PrintString:
		; We will need to store these values for later.
		PUSH AX
		PUSH SI
		
		; Next we clear the carry flag just in case it was
		; accidentally set.
		CLD
		
		; Now we jump just after the display call so we can load a
		; char value.
		JMP .Init
		
		.Loop:
			; Now we call the character display function.
			CALL VideoDisplayChar
			
		.Init:
			; First, we load a string byte from the DS:SI memory
			; location.
			XCHG BX, BX
			LODSB
			
			; If it is 0x0 (END OF STRING), we will stop looping.
			OR AL, AL
			JNZ .Loop
			
	.Return:
		; We pop the previously pushed values.
		POP SI
		POP AX

		; Finally, we return.
		RET

%endif ;_CHARGE_VIDEO_DISPLAY_S
