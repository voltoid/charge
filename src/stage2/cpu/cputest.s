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
; Date: 2/27/2013 - 2/27/2013
;========================================================================================
%ifndef _CHARGE_CPU_CPUTEST_S_
%define _CHARGE_CPU_CPUTEST_S_

CheckCPU:
	.Check8086:
		; First, we will push the flags register to the stack.
		PUSHF
		
		; Next, we will pop the value into the AX register, and see if bit 15 of
		; the flags register is set. If it is, it is an 8086 CPU.
		POP AX
		TEST AH, 0x80
		JNE .CPU16
		
		; Next, we will move the value 0x0F0 to the AH register, and then we will
		; push it onto the stack.
		MOV AH, 0x30
		PUSH AX
		
		; Next, we will pop the AX value into the flags register, push it back to
		; the stack, and finally pop the value into the BX register.
		POPF
		PUSHF
		POP BX
		
		; Now we will null all bits except the changed bits.
		XOR AX, BX
		
		; Next, we will test bits 12 and 13 of the flags register. If they aren't
		; changed, we're stuck with a pre-80386 CPU.
		TEST AH, 0x30
		JNE .CPU16
		
	
	.CPU16:
	
	.CPU32:
	
	.CPU64:
	
	.CPUNOSETTING:
	

%endif ;_CHARGE_CPU_CPUTEST_S_