/****************************************************************************************
 * Copyright (c) 2013, Adrian Collado & Voltoid Technologies
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     - Redistributions of source code must retain the above copyright
 *		notice, this list of conditions and the following disclaimer.
 *	  - Redistributions in binary form must reproduce the above copyright
 *		notice, this list of conditions and the following disclaimer in the
 *		documentation and/or other materials provided with the distribution.
 *	  - Neither the names of BootKit nor the names of its contributors may be
 *		used to endorse or promote products derived from this software without
 *		prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ADRIAN COLLADO OR VOLTOID TECHNOLOGIES BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA OR PROFITS* OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 ****************************************************************************************
 * Date: 2/27/2013 - 2/27/2013
 ****************************************************************************************
 * FDC.h - Generic Driver Interface
 ****************************************************************************************
 */
 
#ifndef  _BOOTKIT_FDC_H_
#define  _BOOTKIT_FDC_H_

typedef enum FDCDORBitflags {
	MOTOR_D	= 0x80,
	MOTOR_C = 0x40,
	MOTOR_B = 0x20,
	MOTOR_A = 0x10,
	IRQ		= 0x08,
	RESET	= 0x04,
	DSEL1	= 0x02,
	DSEL0	= 0x01
};

typedef enum FDCMSRBitflags {
	RQM		= 0x80,
	DIO		= 0x40,
	NDMA	= 0x20,
	CB		= 0x10,
	ACTD	= 0x08,
	ACTC	= 0x04,
	ACTB	= 0x02,
	ACTA	= 0x01
};

typedef enum FDCRegisters {
	REG_STATUS_A				= 0x3F0, // Read
	REG_STATUS_B				= 0x3F1, // Read
	REG_DIGITAL_OUTPUT			= 0x3F2,
	REG_TAPE_DRIVE				= 0x3F3,
	REG_MAIN_STATUS				= 0x3F4, // Read
	REG_DATARATE_SELECT			= 0x3F4, // Write
	REG_FIFO					= 0x3F5,
	REG_DIGITAL_INPUT			= 0x3F7, // Read
	REG_CONFIGURATION_CONTROL	= 0x3F7	 // Write
};

typedef enum FDCCommands {
	READ_TRACK					= 0x02,
	SPECIFY						= 0x03,
	SENSE_DRIVE_STATUS			= 0x04,
	WRITE_DATA					= 0x05,
	READ_DATA					= 0x06,
	RECALIBRATE					= 0x07,
	SENSE_INTERRUPT				= 0x08,
	WRITE_DELETED_DATA			= 0x09,
	READ_ID						= 0x0A,
	READ_DELETED_DATA			= 0x0C,
	FORMAT_TRACK				= 0x0D,
	SEEK						= 0x0F,
	VERSION						= 0x10,
	SCAN_EQUAL					= 0x11,
	PERPENDICULAR_MODE			= 0x12,
	CONFIGURE					= 0x13,
	LOCK						= 0x14,
	VERIFY						= 0x16,
	SCAN_LOW_OR_EQUAL			= 0x19,
	SCAN_HIGH_OR_EQUAL			= 0x1D
};

#endif //_BOOTKIT_FDC_H_