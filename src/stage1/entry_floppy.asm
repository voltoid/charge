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
; Assembled as BootEntry_Floppy.bin using the command line:
;	nasm -fbin -oBootEntry_Floppy.bin entry_floppy.asm
;========================================================================================
BITS 16
CPU 8086

ORG 0x7C00

EntryPoint:
	JMP 0x0000:Main
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include "disk/fat12block.s"
%include "disk/floppy.s"
%include "video/videoinit.s"
%include "abort/abort.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Messages:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main:
	; First, we have to disable interrupts and set the segment registers
	; to usable values.
	CLI
	XOR AX, AX
	MOV DS, AX
	MOV ES, AX
	MOV SS, AX
	MOV SP, 0xFFFF
	STI
	
	; Next, we move the boot device number into
	; the location of ExtFATBlock.DriveNumber.
	; The BIOS puts the boot device number into
	; the DL register before giving us control.
	MOV [ExtFATBlock.DriveNumber], DL
	
	; Next, we initialize the default video text
	; mode for the bootloader. It has an '80 x 25'
	; resolution, which is default for most if not
	; all computers.
	CALL InitVideoDefault
	
	; We then display a message to let us know
	; that the screen is up and running. If we
	; don't see it, then it is assumed that either
	; the video card is unusable, or one does not
	; exist.
	MOV SI, Messages.VideoTestString
	CALL VideoDisplayString
	
	; Since this is a floppy disk, we can assume that the file system
	; on the disk is FAT12. According to the Omniboot Specification,
	; the disk's FAT Headers (AKA BIOS Parameter Block) must be valid
	; unless the disk's serial number is defined as 0x554E4B4E ("UNKN")
	; Therefore, we can extract disk geometry from that header. If,
	; however, the serial number IS 0x554E4B4E, then we must assume
	; that the floppy disk's size is 2880 sectors (1440 KiB)
	
	; We will be loading 5 sectors to disk, starting at LBA 1 and going
	; to LBA 5. These will be loaded to 0x0050:0x0000 (0x0500 Physical).
	MOV CX, 5
	MOV AX, 1
	MOV BX, 0x0050
	MOV ES, BX
	MOV BX, 0x0000
	CALL DiskReadSectors
	
	; If the loading failed, the carry flag is set, and the DX contains
	; error information. DH contains the sector it failed on, and DL
	; contains the error code. If DH is greater than 1, then we will have
	; access to more advanced error printing routines. This will give us
	; the ability to provide a more informational error message.
	JNC ExecuteStage2
	CMP DH, 1
	JA AbortAdvanced
	MOV SI, Messages.StandardError
	JE AbortStandard
	MOV SI, Messages.UnknownError
	JMP AbortUnknown
	
ExecuteStage2:
	; This will jump to our second stage bootloader, located at physical
	; address 0x0500. We will set the segment registers to 0x0050.
	JMP 0x0050:0x0000
	
	