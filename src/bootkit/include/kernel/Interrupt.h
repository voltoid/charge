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
 * SERVICES; LOSS OF USE, DATA OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 ****************************************************************************************
 * Date of creation:  3/1/2013
 * Date of last edit: 3/1/2013
 ****************************************************************************************
 * Interrupt.h - Programmable Interrupt Controller Header
 ****************************************************************************************
 */
 
#ifndef  _BOOTKIT_INTERRUPT_H_
#define  _BOOTKIT_INTERRUPT_H_
 
struct _idtentry32s {
	unsigned short	BaseLow;
	unsigned short	SegSelector;
	unsigned char	Reserved;
	unsigned char	Flags;
	unsigned short	BaseHigh;
} __attribute__((packed));
 
struct _idtptr32s {
	unsigned short	Limit;
	unsigned int	Base;
} __attribute__((packed));

struct _idtentry64s {
	unsigned short	BaseLow;
	unsigned short	SegSelector;
	unsigned char	Reserved;
	unsigned char	Flags;
	unsigned short	BaseMiddle;
	unsigned int	BaseHigh;
	unsigned int	ReservedLong;
} __attribute__((packed));

struct _idtptr64s {
	unsigned short	Limit;
	unsigned int	BaseLow;
	unsigned int	BaseHigh;
} __attribute__((packed));

typedef struct  _idtentry32s    IDTEntry32_t;
typedef struct  _idtentry64s    IDTEntry64_t;

typedef struct  _idtptr32s      IDTPointer32_t;
typedef struct  _idtptr64s      IDTPointer64_t;

extern void (*cpuirq0) ();      // [FAULT]      Division by Zero
extern void (*cpuirq1) ();      // [FAULT/TRAP] Debug
extern void (*cpuirq2) ();      // [INTERRUPT]  Non Maskable Interrupt
extern void (*cpuirq3) ();      // [TRAP]       Breakpoint
extern void (*cpuirq4) ();      // [TRAP]       Overflow
extern void (*cpuirq5) ();      // [FAULT]      Bound Range Exceeded
extern void (*cpuirq6) ();      // [FAULT]      Invalid Opcode
extern void (*cpuirq7) ();      // [FAULT]      Device Not Available
extern void (*cpuirq8) ();      // [ABORT]      Double Fault                    [PUSHES ERROR]
extern void (*cpuirq9) ();      // [FAULT]      Coprocessor Segment Overrun
extern void (*cpuirq10)();      // [FAULT]      Invalid TSS                     [PUSHES ERROR]
extern void (*cpuirq11)();      // [FAULT]      Segment Not Present             [PUSHES ERROR]
extern void (*cpuirq12)();      // [FAULT]      Stack-Segment Fault             [PUSHES ERROR]
extern void (*cpuirq13)();      // [FAULT]      General Protection Fault        [PUSHES ERROR]
extern void (*cpuirq14)();      // [FAULT]      Page Fault                      [PUSHES ERROR]
extern void (*cpuirq15)();      //              Reserved
extern void (*cpuirq16)();      // [FAULT]      x87 Floating-Point Exception
extern void (*cpuirq17)();      // [FAULT]      Alignment Check                 [PUSHES ERROR]
extern void (*cpuirq18)();      // [ABORT]      Machine Check
extern void (*cpuirq19)();      // [FAULT]      SIMD Floating-Point Exception
extern void (*cpuirq20)();      //              Reserved
extern void (*cpuirq21)();      //              Reserved
extern void (*cpuirq22)();      //              Reserved
extern void (*cpuirq23)();      //              Reserved
extern void (*cpuirq24)();      //              Reserved
extern void (*cpuirq25)();      //              Reserved
extern void (*cpuirq26)();      //              Reserved
extern void (*cpuirq27)();      //              Reserved
extern void (*cpuirq28)();      //              Reserved
extern void (*cpuirq29)();      //              Reserved
extern void (*cpuirq30)();      //              Security Exception
extern void (*cpuirq31)();      //              Reserved

int InitCPUInterrupts32(struct _idtptr32 &IDTPointer);
int InitCPUInterrupts64(struct _idtptr64 &IDTPointer);

 #endif //_BOOTKIT_INTERRUPT_H_