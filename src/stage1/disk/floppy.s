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
; Date: 2/27/2013 - 2/XX/2013
;========================================================================================
%ifndef _CHARGE_DISK_FLOPPY_S_
%define _CHARGE_DISK_FLOPPY_S_

AbsTrack:		DB	0
AbsSector:		DB	0
AbsHead:		DB	0
DiskNumber:		DB	0
DiskAttempts:	DB	0

; LBACHS - Converts a LBA value to CHS values
; Input:
;	AX - LBA Value
; Output:
;	AbsTrack - CHS Track Number
;	AbsSector - CHS Sector Number
;	AbsHead	- CHS Head Number
LBACHS:
	; Null the DX register
	XOR DX, DX
	
	; Divide the AX register by the number of sectors in each track. This
	; will give us our Sector value minus 1.
	; Formula: (Logical Sector / Sectors per Track) = AbsSector - 1
	DIV WORD [FATBlock.SectorsPerTrack]
	
	; Now we increment that value to get the sector number. For some odd
	; reason, sector values start at 1, not 0.
	; Formula: (Logical Sector / Sectors per Track) + 1 = AbsSector
	INC DL
	
	; Then we store the value in the AbsSector memory location.
	MOV BYTE [AbsSector], DL
	
	; We null the DX register again
	XOR DX, DX
	
	; Now we divide the LBA value again by the number of heads per cylinder
	; This will give us both the Head value and the Track value.
	; Formula: (Logical Sector / Sectors per Track) % Number of Heads = AbsHead
	; Formula: Logical Sector / (Sectors per Track * Number of Heads = AbsTrack
	DIV WORD [FATBlock.HeadsPerCylinder]
	
	; We will store these values in their respective memory locations, and
	; return.
	MOV BYTE [AbsHead], DL
	MOV BYTE [AbsTrack], AL
	RET
	
; ReadSector - Loads a sector from the floppy disk
; Input:
;	AX - Sector to read
;	ES - Segment to store sector
;	BX - Offset to store sector into
;	CX - Number of sectors to read
; Output:
;	Flags - Carry set
;	DH - Error Code
;	DL - Error Sector
ReadSectors:
	.Main:
		; Here we are setting the current number of disk read attempts to zero.
		XOR DX, DX
		MOV [DiskAttempts], DL
		
	.Loop:
		; Store registers for later use
		PUSH AX
		PUSH BX
		PUSH CX
		
		; Store Sector Location in CHS Values
		CALL LBACHS
		
		; Increment the number of disk read attempts
		INC BYTE [DiskAttempts]
		
		; Load disk read values into registers. AH is the function command. AL
		; is the number of sectors to read. CH is the track number. CL is the
		; sector number. DH is the head number. DL is the disk number.
		MOV AH, 0x02
		MOV AL, 0x01
		MOV CH, BYTE [AbsTrack]
		MOV CL, BYTE [AbsSector]
		MOV DH, BYTE [AbsHead]
		MOV DL, BYTE [ExtFATBlock.DriveNumber]
		
		; We will store AX for error messages.
		PUSH AX
		
		; Call the BIOS Interrupt
		INT 0x13
		
		; If the read was successful, the carry flag will not be set, so we will
		; set up everything to load the next sector.
		JNC .Success
		
		; If we reach this point, we did not read the sector properly. Compare
		; the number of disk attempts to the number of max attempts (5), and if
		; that point is reached, abort!
		CMP BYTE [DiskAttempts], 5
		JAE .Abort
		
		; If we get here, we have not attempted at least 5 disk reads yet, so 
		; we will reset the disk and try again.
		
		; First, we will null the AX register.
		XOR AX, AX
		
		; Now we will set the Drive Number
		MOV DL, [ExtFATBlock.DriveNumber]
		
		; Finally, we will reset the drive
		INT 0x13
		
		; Pop back our error check values.
		POP DX
		
		; Pop back our reading values, and retry the sector read operation.
		POP CX
		POP BX
		POP AX
		
	.Abort:
		; Pop back our error check values
		POP DX
		
		; Set the error code to 0x0001 (Read Error), and store in DL
		MOV DH, 0x0001
		
		; Set the Carry flag so we know we failed
		STC
		
		; Restore registers and return
		POP CX
		POP BX
		POP AX
		RET
	
	.Success:
		; Pop back our error check values
		POP DX
		
		; Restore registers
		POP CX
		POP BX
		POP AX
		
		; Set next store point to the last store point plus the size
		; of one sector
		ADD BX, WORD [FATBlock.BytesPerSector]
		
		; Increment the sector we're reading from
		INC AX
		
		; Decrease the number of sectors to read. If the number becomes
		; zero, then we are done reading, and should return. Otherwise,
		; we read the next sector.
		DEC CX
		JNZ .Main
		RET

%endif ;_CHARGE_DISK_FLOPPY_S_
