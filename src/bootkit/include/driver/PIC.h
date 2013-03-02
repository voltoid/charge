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
 * Date of creation:  3/1/2013
 * Date of last edit: 3/1/2013
 ****************************************************************************************
 * PIC.h - Programmable Interrupt Controller Header
 ****************************************************************************************
 */
 
 // Port Locations - Master
 #define PIC_MASTER_BASE    0x20
 #define PIC_MASTER_COMMAND 0x20
 #define PIC_MASTER_DATA    0x21
 
 // Port Locations - Slave
 #define PIC_SLAVE_BASE     0xA0
 #define PIC_SLAVE_COMMAND  0xA0
 #define PIC_SLAVE_DATA     0xA1
 
 