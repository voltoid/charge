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
%ifndef _CHARGE_LEGACY_REAL_FATBLOCK_S_
%define _CHARGE_LEGACY_REAL_FATBLOCK_S_

BITS 16

; The standard FAT12 BIOS Parameter Block,
; also known as the FAT Block or BPB.
; These fields are here for legacy purposes,
; and in most cases, the drive geometry
; will be read by directly accessing the
; hardware.
FATBlock:
	.OEMName:			DB	"CHARGE  "
	.BytesPerSector:	DW	512
	.SectorsPerCluster:	DB	1
	.ReservedSectors:	DW	1
	.NumberOfFATs:		DB	2
	.RootEntries:		DW	224
	.TotalSectors:		DW	2880
	.MediaType:			DB	0xF0
	.SectorsPerFAT:		DW	9
	.SectorsPerTrack:	DW	18
	.HeadsPerCylinder:	DW	2
	.HiddenSectors:		DD	0
	.TotalSectorsBig:	DD	0
ExtFATBlock:
	.DriveNumber:		DB	0
	.Unused:			DB	0
	.ExtBootSignature:	DB	0x29
	.SerialNumber:		DD	0x02011997
	.VolumeLabel:		DB	"CHARGE BOOT"
	.FileSystem:		DB	"FAT12   "

%endif ;_CHARGE_LEGACY_REAL_FATBLOCK_S_
