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
; Assembled as BootEntry_Floppy.bin using the command line:
;	nasm -fbin -o../../bin/BootEntry_Floppy.bin entry_floppy.asm
;========================================================================================
BITS 16
CPU 8086

ORG 0x0500

EntryPoint:
	JMP 0x0000:Main
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include "memory/memorymap.s"
%include "memory/memory.s"
%include "memory/a20.s"
%include "memory/gdt.s"
%include "memory/paging.s"
%include "cpu/cputest.s"
%include "cpu/cpuid.s"
	
Main:
	; First, we disable interrupts.
	CLI
	
	; Next, we null the segments and setup the stack.
	XOR AX, AX
	MOV DS, AX
	MOV ES, AX
	MOV SS, AX
	MOV SP, 0xFFFF
	
	; Lastly, we reenable interrupts.
	STI
	
	; Now we will determine what kind of CPU we have.
	CALL CheckCPU
	
	; From this point, we will switch to stage 3 - however, we will have one of
	; three different routes. We can be either 16-Bit, 32-Bit, or 64-Bit. Due to
	; this fact, the bootloader will have to split into three parts for stage 3
	; and beyond.
	CMP CPUType, 0
	JE .Go16Bit
	
	CMP CPUType, 1
	JE .Go32Bit
	
	CMP CPUType, 2
	JE .Go64Bit
	
	JMP Abort.CPUError

	