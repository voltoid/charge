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
%ifndef _CHARGE_VIDEO_VIDEOINIT_S_
%define _CHARGE_VIDEO_VIDEOINIT_S_

%define VIDEO_STATE_TABLE	0x7BC0

; These flags determine what features of the video card are available. For the first
; stage, only the first two bits are used.
VideoCardFlags:		DB	0

; This is the current display page number
VideoDisplayPage:	DB	0

; InitVideoDefualt - Initializes the default (Text Mode 25x80) video mode
InitVideoDefault:
	; First, we set up the function command and parameters. We are calling the interrupt
	; to get the video card's display combination code.
	MOV AX, 0x1A00
	
	; Some BIOSes don't set the carry flag if this function is unsupported. We will set
	; it just in case. However, if the function does exist and is successful, then the
	; carry flag is guaranteed to be zero.
	STC
	
	; Now we execute the interrupt.
	INT 0x10
	
	; Now we will compare the value in the return register to the success code (0x1A).
	; If they are not equal, then we must assume that a video card is not present. If
	; they are equal, we set the 'Video Card Present' flag in the VideoCardFlags
	; memory location.
	CMP AL, 0x1A
	JNE .Done
	
	; We null DX so that we are guaranteed that no flags will be set before we
	; initialize the video card code.
	XOR DX, DX
	
	; We OR the register's first bit so it is set.
	OR DL, 0x01
	
	; Finally, we store it in the VideoCardFlags memory location.
	MOV BYTE [VideoCardFlags], DL
	
	.CheckTextMode:
		; Now we will check what mode the video card is in. We will use function
		; 0x1B so that we get a table of video card information.
		MOV AX, 0x1B00
		
		; Now we null the BX register so we can null the ES segment register.
		XOR BX, BX
		MOV ES, BX
		
		; Next, we store the location of the video card's state table into the DI
		; register.
		MOV DI, VIDEO_STATE_TABLE
		
		; Now we call the interrupt.
		INT 0x10
		
		; If the value in AL is not equal to 0x1B, then the function is not
		; supported and we assume that the wrong video mode is currently set.
		; Otherwise, we will determine what video mode it is in, and act according
		; to that value.
		CMP AL, 0x1B
		JNE .SetDefaultMode
		
		; If the function was successful, we will set the 'Video Card State Table'
		; flag to one.
		MOV DL, BYTE [VideoCardFlags]
		OR DL, 0x02
		MOV BYTE [VideoCardFlags], DL
		
		; Now we will test if the current video mode is mode 3 (Text Mode). If it
		; is not, we will set the video mode. Otherwise, we continue tests.
		CMP BYTE [DI + 0x04], 0x03
		JNE .SetDefaultMode
		
		; Now we will test the number of columns. If it isn't 80 columns, then we
		; will have to set the video mode. Otherwise, we continue tests.
		CMP BYTE [DI + 0x05], 80
		JNE .SetDefaultMode

		; From reading Brendan Trotter's documents, it seems that Ralf Brown's
		; information on the video card's state table may be incorrect. His
		; information states that the number of rows returned in the state table
		; is equal to the number of rows minus one. However, real hardware shows
		; that the assumption is not always true, so we test for both the
		; condtions of rows minus one, and rows.
		
		; If the number of rows is either 26, 25, or 24, then we are in the
		; correct mode and will begin setting video hardware information.
		; Otherwise, we must set the video mode.
		CMP BYTE [DI + 0x22], 25
		JE .DefaultMode
		CMP BYTE [DI + 0x22], 24
		JE .DefaultMode
	
	.SetDefaultMode:
		; Here we call the function for setting the video mode, and will set it
		; to mode 0x03 (Text Mode 25x80).
		MOV AX, 0x0003
		
		; Then we execute the interrupt.
		INT 0x10
		
	.DefaultMode:
		; Now we will disable the cursor. Since we won't be taking any input
		; yet, there's really no reason for it. The function for this is 0x01.
		MOV AH, 0x01
		
		; Setting bits 5 and 6 of the CH register sets the cursor mode to 
		; invisible, so we can't see it. Bits 4 to 0 of both the CH and CL
		; registers refers to the position of the cursor on the top and bottom
		; scan lines, respectively.
		MOV CX, 0x2D0E
		
		; Now we execute the interrupt.
		INT 0x10
		
		; Now we disable blinking and enable intensity of the background. The
		; function value for is is 0x1003 stored in the AX register.
		MOV AX, 0x1003
		
		; Now we set BL to 0x00 to enable intensity, and BH to 0x00 to prevent
		; problems with some adapters.
		XOR BX, BX
		
		; Then we execute the interrupt.
		INT 0x10
		
		; Now we get the value of the current display page. This value will be
		; returned in BL, so we will null the entire BX register to prevent
		; problems with some adapters.
		XOR BX, BX
		
		; The function value for this interrupt is 0x0F, stored in the AH
		; register.
		MOV AH, 0x0F
		
		; Then the interrupt is called, and the return value is stored in the
		; memory location of VideoCardPage.
		INT 0x10
		MOV [VideoDisplayPage], BH
		
	.Done:
		; Now we return.
		RET
		
	
%endif ;_CHARGE_VIDEO_VIDEOINIT_S_
