
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64A
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 2048 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0800
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _recentMenu=R5
	.DEF _sleepTime=R6
	.DEF _bluetoothResetTime=R8
	.DEF _timer=R10
	.DEF _sleepTimer=R12
	.DEF _doesPlaying=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _Button_Pressed
	JMP  _EncoderButton_Pressed
	JMP  0x00
	JMP  0x00
	JMP  _Bluetooth_Mute
	JMP  0x00
	JMP  _TSOP
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _tim3_compa
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00

_char0:
	.DB  0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10
_char1:
	.DB  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
_char2:
	.DB  0x1C,0x1C,0x1C,0x1C,0x1C,0x1C,0x1C,0x1C
_char3:
	.DB  0x1E,0x1E,0x1E,0x1E,0x1E,0x1E,0x1E,0x1E
_char4:
	.DB  0x0,0x1B,0x1B,0x1B,0x1B,0x1B,0x1B,0x0
_char5:
	.DB  0x0,0x8,0xC,0xE,0xE,0xC,0x8,0x0
_char6:
	.DB  0x6,0x15,0xD,0x6,0xD,0x15,0x6,0x0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x6:
	.DB  0x5C,0xC1
_0x7:
	.DB  0x32
_0x8:
	.DB  0x32
_0x9:
	.DB  0x1
_0xA:
	.DB  0x1
_0x1C9:
	.DB  0x0,0x0,0x88,0x13,0x50,0xC3,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x42,0x6C,0x75,0x65,0x74,0x6F,0x6F,0x74
	.DB  0x68,0x20,0x50,0x6C,0x61,0x79,0x65,0x72
	.DB  0x0,0x2A,0x3C,0x2A,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x3E
	.DB  0x20,0x0,0x20,0x3C,0x20,0x20,0x20,0x20
	.DB  0x2A,0x20,0x2A,0x20,0x20,0x20,0x20,0x20
	.DB  0x3E,0x20,0x0,0x20,0x3C,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x2A,0x3E,0x2A,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x2D,0x0,0x3E
	.DB  0x0,0x3C,0x0,0x56,0x6F,0x6C,0x75,0x6D
	.DB  0x65,0x3A,0x20,0x25,0x64,0x20,0x0,0x54
	.DB  0x72,0x65,0x62,0x6C,0x65,0x3A,0x20,0x25
	.DB  0x64,0x20,0x0,0x54,0x72,0x65,0x62,0x6C
	.DB  0x65,0x3A,0x20,0x2B,0x25,0x64,0x20,0x0
	.DB  0x42,0x61,0x73,0x73,0x3A,0x20,0x25,0x64
	.DB  0x20,0x0,0x42,0x61,0x73,0x73,0x3A,0x20
	.DB  0x2B,0x25,0x64,0x20,0x0,0x49,0x6E,0x70
	.DB  0x75,0x74,0x3A,0x20,0x20,0x20,0x20,0x31
	.DB  0x20,0x32,0x20,0x33,0x20,0x0,0x47,0x61
	.DB  0x69,0x6E,0x3A,0x20,0x20,0x20,0x20,0x30
	.DB  0x20,0x20,0x64,0x62,0x20,0x20,0x0,0x33
	.DB  0x2E,0x32,0x35,0x20,0x20,0x37,0x2E,0x35
	.DB  0x20,0x20,0x31,0x31,0x2E,0x32,0x35,0x0
	.DB  0x47,0x61,0x69,0x6E,0x3A,0x20,0x2B,0x20
	.DB  0x33,0x2E,0x32,0x35,0x64,0x62,0x20,0x20
	.DB  0x0,0x20,0x20,0x30,0x20,0x20,0x20,0x37
	.DB  0x2E,0x35,0x20,0x20,0x31,0x31,0x2E,0x32
	.DB  0x35,0x0,0x47,0x61,0x69,0x6E,0x3A,0x20
	.DB  0x2B,0x20,0x37,0x2E,0x35,0x20,0x64,0x62
	.DB  0x20,0x20,0x0,0x20,0x20,0x30,0x20,0x20
	.DB  0x33,0x2E,0x32,0x35,0x20,0x20,0x31,0x31
	.DB  0x2E,0x32,0x35,0x0,0x47,0x61,0x69,0x6E
	.DB  0x3A,0x20,0x2B,0x31,0x31,0x2E,0x32,0x35
	.DB  0x64,0x62,0x20,0x20,0x0,0x20,0x20,0x30
	.DB  0x20,0x20,0x33,0x2E,0x32,0x35,0x20,0x20
	.DB  0x20,0x37,0x2E,0x32,0x35,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x33,0x2E,0x32,0x35
	.DB  0x0,0x30,0x0,0x4C,0x6F,0x75,0x64,0x6E
	.DB  0x65,0x73,0x73,0x3A,0x0,0x3E,0x20,0x4F
	.DB  0x4E,0x20,0x3C,0x20,0x20,0x20,0x20,0x20
	.DB  0x4F,0x46,0x46,0x20,0x0,0x20,0x20,0x4F
	.DB  0x4E,0x20,0x20,0x20,0x20,0x20,0x3E,0x20
	.DB  0x4F,0x46,0x46,0x20,0x3C,0x0,0x4C,0x65
	.DB  0x66,0x74,0x20,0x25,0x64,0x0,0x52,0x69
	.DB  0x67,0x68,0x74,0x0,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x0,0x46,0x72,0x6F,0x6E,0x74
	.DB  0x20,0x25,0x64,0x0,0x52,0x65,0x61,0x72
	.DB  0x0,0x20,0x20,0x20,0x42,0x6C,0x75,0x65
	.DB  0x74,0x6F,0x6F,0x74,0x68,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x45,0x6E,0x61,0x62,0x6C
	.DB  0x65,0x0,0x20,0x20,0x20,0x20,0x44,0x69
	.DB  0x73,0x61,0x62,0x6C,0x65,0x0,0x42,0x72
	.DB  0x69,0x67,0x68,0x74,0x6C,0x65,0x73,0x73
	.DB  0x3A,0x20,0x25,0x64,0x20,0x0,0x4F,0x70
	.DB  0x61,0x73,0x69,0x74,0x79,0x3A,0x20,0x25
	.DB  0x64,0x20,0x0,0x20,0x20,0x4C,0x65,0x73
	.DB  0x6B,0x69,0x76,0x0,0x20,0x20,0x20,0x20
	.DB  0x50,0x72,0x6F,0x64,0x75,0x63,0x74,0x69
	.DB  0x6F,0x6E,0x0,0x4D,0x41,0x0,0x4D,0x45
	.DB  0x0,0x4D,0x44,0x0,0x4F,0x76,0x65,0x72
	.DB  0x66,0x6C,0x6F,0x77,0x0,0x43,0x59,0x0
	.DB  0x41,0x75,0x64,0x69,0x6F,0x20,0x70,0x72
	.DB  0x6F,0x63,0x65,0x73,0x73,0x6F,0x72,0x0
	.DB  0x45,0x72,0x72,0x6F,0x72,0x3A,0x20,0x61
	.DB  0x64,0x72,0x65,0x73,0x73,0x0,0x45,0x72
	.DB  0x72,0x6F,0x72,0x20,0x77,0x69,0x74,0x68
	.DB  0x20,0x62,0x75,0x73,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x4E,0x65,0x77,0x41,0x6D,0x70
	.DB  0x0,0x20,0x20,0x46,0x69,0x72,0x6D,0x77
	.DB  0x61,0x72,0x65,0x20,0x33,0x2E,0x31,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _bluetoothResetTimer
	.DW  _0x6*2

	.DW  0x01
	.DW  _lastConectedState
	.DW  _0x7*2

	.DW  0x01
	.DW  _lastPlayingState
	.DW  _0x8*2

	.DW  0x01
	.DW  _PlayerMenu
	.DW  _0x9*2

	.DW  0x01
	.DW  _isOFF
	.DW  _0xA*2

	.DW  0x11
	.DW  _0xB
	.DW  _0x0*2

	.DW  0x11
	.DW  _0xB+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0xB+34
	.DW  _0x0*2+34

	.DW  0x11
	.DW  _0xB+51
	.DW  _0x0*2+51

	.DW  0x11
	.DW  _0x18
	.DW  _0x0*2+68

	.DW  0x11
	.DW  _0x23
	.DW  _0x0*2+68

	.DW  0x02
	.DW  _0x23+17
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0x23+19
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0x23+21
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0x23+23
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0x23+25
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0x3B
	.DW  _0x0*2+32

	.DW  0x02
	.DW  _0x3B+2
	.DW  _0x0*2+87

	.DW  0x02
	.DW  _0x3B+4
	.DW  _0x0*2+89

	.DW  0x02
	.DW  _0x3B+6
	.DW  _0x0*2+32

	.DW  0x02
	.DW  _0x3B+8
	.DW  _0x0*2+32

	.DW  0x02
	.DW  _0x3B+10
	.DW  _0x0*2+32

	.DW  0x11
	.DW  _0x6F
	.DW  _0x0*2+149

	.DW  0x11
	.DW  _0x7E
	.DW  _0x0*2+166

	.DW  0x11
	.DW  _0x7E+17
	.DW  _0x0*2+183

	.DW  0x11
	.DW  _0x7E+34
	.DW  _0x0*2+200

	.DW  0x11
	.DW  _0x7E+51
	.DW  _0x0*2+217

	.DW  0x11
	.DW  _0x7E+68
	.DW  _0x0*2+234

	.DW  0x11
	.DW  _0x7E+85
	.DW  _0x0*2+251

	.DW  0x11
	.DW  _0x7E+102
	.DW  _0x0*2+268

	.DW  0x11
	.DW  _0x7E+119
	.DW  _0x0*2+285

	.DW  0x11
	.DW  _0x7E+136
	.DW  _0x0*2+166

	.DW  0x0B
	.DW  _0x7E+153
	.DW  _0x0*2+302

	.DW  0x11
	.DW  _0x7E+164
	.DW  _0x0*2+200

	.DW  0x02
	.DW  _0x7E+181
	.DW  _0x0*2+313

	.DW  0x0A
	.DW  _0x8E
	.DW  _0x0*2+315

	.DW  0x10
	.DW  _0x8E+10
	.DW  _0x0*2+325

	.DW  0x11
	.DW  _0x8E+26
	.DW  _0x0*2+341

	.DW  0x06
	.DW  _0x94
	.DW  _0x0*2+366

	.DW  0x02
	.DW  _0x94+6
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0x94+8
	.DW  _0x0*2+85

	.DW  0x0F
	.DW  _0x94+10
	.DW  _0x0*2+372

	.DW  0x05
	.DW  _0xAD
	.DW  _0x0*2+396

	.DW  0x05
	.DW  _0xAD+5
	.DW  _0x0*2+396

	.DW  0x05
	.DW  _0xAD+10
	.DW  _0x0*2+396

	.DW  0x02
	.DW  _0xAD+15
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0xAD+17
	.DW  _0x0*2+85

	.DW  0x0F
	.DW  _0xAD+19
	.DW  _0x0*2+372

	.DW  0x0D
	.DW  _0xC0
	.DW  _0x0*2+401

	.DW  0x0C
	.DW  _0xC0+13
	.DW  _0x0*2+414

	.DW  0x0C
	.DW  _0xC0+25
	.DW  _0x0*2+426

	.DW  0x09
	.DW  _0xEF
	.DW  _0x0*2+467

	.DW  0x0F
	.DW  _0xEF+9
	.DW  _0x0*2+476

	.DW  0x03
	.DW  _0x118
	.DW  _0x0*2+491

	.DW  0x03
	.DW  _0x118+3
	.DW  _0x0*2+491

	.DW  0x03
	.DW  _0x16D
	.DW  _0x0*2+494

	.DW  0x03
	.DW  _0x16D+3
	.DW  _0x0*2+491

	.DW  0x03
	.DW  _0x16D+6
	.DW  _0x0*2+497

	.DW  0x09
	.DW  _0x17B
	.DW  _0x0*2+500

	.DW  0x03
	.DW  _0x17E
	.DW  _0x0*2+509

	.DW  0x10
	.DW  _0x1A0
	.DW  _0x0*2+512

	.DW  0x0E
	.DW  _0x1A0+16
	.DW  _0x0*2+528

	.DW  0x10
	.DW  _0x1A0+30
	.DW  _0x0*2+512

	.DW  0x0F
	.DW  _0x1A0+46
	.DW  _0x0*2+542

	.DW  0x0C
	.DW  _0x1A0+61
	.DW  _0x0*2+557

	.DW  0x0F
	.DW  _0x1A0+73
	.DW  _0x0*2+569

	.DW  0x09
	.DW  _0x1A0+88
	.DW  _0x0*2+467

	.DW  0x0F
	.DW  _0x1A0+97
	.DW  _0x0*2+476

	.DW  0x0A
	.DW  0x04
	.DW  _0x1C9*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x900

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.10 Evaluation
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : New Amp
;Version : 1.0.1
;Date    : 29.06.2014
;Author  : Leskiv Oleksandr
;Company : Home Labaratory
;Comments:
;I hope, it will work loud!
;
;
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <i2c.h>
;#include <alcd.h>
;#include <stdio.h>
;#include <DefineSymbols.h>

	.CSEG
_define_char:
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
	LDI  R17,LOW(0)
_0x4:
	CPI  R17,8
	BRSH _0x5
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	CALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x4
_0x5:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;
;unsigned char recentMenu;
;
;#define volumeMenu    0;
;#define trebleMenu    1;
;#define bassMenu      2;
;#define inputsMenu    3;
;#define preampMenu    4;
;#define loudnessMenu  5;
;#define LRBalanceMenu 6;
;#define FRBalanceMenu 7;
;#define bluetothMenu  8;
;
;unsigned int sleepTime = 5000;
;unsigned int bluetoothResetTime=50000;
;
;unsigned int timer=0, sleepTimer=0, bluetoothResetTimer=49500, bluetoothAskStateTimer=0;

	.DSEG
;
;char BlueBuffer[10];
;unsigned char doesPlaying=0;
;unsigned char doesConected=0;
;
;unsigned char lastConectedState=50;
;unsigned char lastPlayingState=50;
;
;unsigned char volume, treble, bass, input, gain, loudness, brightless, isBluetoothEnabled=0, PlayerMenu=1;
;signed char LR_balance, FR_balance;
;unsigned int opasity;
;
;char mayOFF=0;
;char isOFF=1;
;
;unsigned int encwas;
;char buffer[32];
;
;char k;
;char sleepBrightless;
;
;char wasPlayingBeforeSwitch =0;
;
;eeprom char doesEEpromWritten;
;eeprom int settings[12];
;
;#include <BluePlayerMenu.h>                                                      //recentMenu

	.CSEG
_BluePlayerMenu:
	CALL _lcd_clear
	__POINTW2MN _0xB,0
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRNE _0xF
	__POINTW2MN _0xB,17
	CALL SUBOPT_0x2
	BRNE _0x10
	LDI  R26,LOW(4)
	RJMP _0x1B1
_0x10:
	LDI  R26,LOW(5)
_0x1B1:
	CALL _lcd_putchar
	RJMP _0xE
_0xF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12
	__POINTW2MN _0xB,34
	CALL SUBOPT_0x2
	BRNE _0x13
	LDI  R26,LOW(4)
	RJMP _0x1B2
_0x13:
	LDI  R26,LOW(5)
_0x1B2:
	CALL _lcd_putchar
	RJMP _0xE
_0x12:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xE
	__POINTW2MN _0xB,51
	CALL SUBOPT_0x2
	BRNE _0x16
	LDI  R26,LOW(4)
	RJMP _0x1B3
_0x16:
	LDI  R26,LOW(5)
_0x1B3:
	CALL _lcd_putchar
_0xE:
	RET

	.DSEG
_0xB:
	.BYTE 0x44
;#include <ShowScaleSimple.h>                                                     //   0 - Volume

	.CSEG
_ShowScaleSimple:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
	CALL SUBOPT_0x3
	__POINTW2MN _0x18,0
	CALL SUBOPT_0x0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __DIVW21U
	MOV  R17,R30
_0x1A:
	CPI  R17,0
	BREQ _0x1B
	LDI  R26,LOW(255)
	CALL _lcd_putchar
	SUBI R17,1
	RJMP _0x1A
_0x1B:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21U
	MOV  R17,R30
	MOV  R30,R17
	CALL SUBOPT_0x4
	BRNE _0x1F
	LDI  R26,LOW(0)
	RJMP _0x1B4
_0x1F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20
	LDI  R26,LOW(1)
	RJMP _0x1B4
_0x20:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x21
	LDI  R26,LOW(2)
	RJMP _0x1B4
_0x21:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1E
	LDI  R26,LOW(3)
_0x1B4:
	CALL _lcd_putchar
_0x1E:
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.DSEG
_0x18:
	.BYTE 0x11
;#include <ShowScaleBalance.h>                                                    //   1 - Treble

	.CSEG
_ShowScaleBalance:
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	temp -> Y+3
;	temp2 -> Y+2
;	i -> R17
;	k -> R16
	CALL SUBOPT_0x3
	__POINTW2MN _0x23,0
	CALL SUBOPT_0x0
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRGE _0x24
	LDD  R17,Y+3
	ANDI R17,LOW(15)
	CPI  R17,15
	BREQ _0x25
	LDI  R16,LOW(0)
_0x27:
	CP   R16,R17
	BRSH _0x28
	__POINTW2MN _0x23,17
	CALL _lcd_puts
	SUBI R16,-1
	RJMP _0x27
_0x28:
_0x25:
	CALL SUBOPT_0x5
	LDD  R17,Y+3
	ANDI R17,LOW(15)
	LDI  R16,LOW(15)
_0x2A:
	CP   R17,R16
	BRSH _0x2B
	__POINTW2MN _0x23,19
	CALL _lcd_puts
	SUBI R16,1
	RJMP _0x2A
_0x2B:
	RJMP _0x2C
_0x24:
	LDD  R17,Y+3
	ANDI R17,LOW(15)
	LDI  R30,LOW(15)
	SUB  R30,R17
	MOV  R17,R30
	LDI  R16,LOW(0)
_0x2E:
	CPI  R16,7
	BRSH _0x2F
	__POINTW2MN _0x23,21
	CALL _lcd_puts
	SUBI R16,-1
	RJMP _0x2E
_0x2F:
	LDI  R16,LOW(0)
_0x31:
	CP   R16,R17
	BRSH _0x32
	__POINTW2MN _0x23,23
	CALL _lcd_puts
	SUBI R16,-1
	RJMP _0x31
_0x32:
	CALL SUBOPT_0x5
	LDI  R16,LOW(0)
_0x34:
	CPI  R16,7
	BRSH _0x35
	__POINTW2MN _0x23,25
	CALL _lcd_puts
	SUBI R16,-1
	RJMP _0x34
_0x35:
_0x2C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET

	.DSEG
_0x23:
	.BYTE 0x1B
;#include <bluetoothState_menu.h>                                                 //   2 - Bass

	.CSEG
_updateBluetoothState:
	ST   -Y,R26
;	isNecessarilyUpdate -> Y+0
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x36
	LDS  R26,_lastPlayingState
	CP   R4,R26
	BREQ _0x37
	CLR  R12
	CLR  R13
	STS  _lastPlayingState,R4
	RCALL _BluePlayerMenu
_0x37:
_0x36:
	TST  R5
	BREQ _0x38
	RJMP _0x2080006
_0x38:
	LDS  R30,_isBluetoothEnabled
	CPI  R30,0
	BREQ _0x39
	LDI  R30,LOW(14)
	CALL SUBOPT_0x6
	LDI  R26,LOW(6)
	CALL _lcd_putchar
	RJMP _0x3A
_0x39:
	LDI  R30,LOW(14)
	CALL SUBOPT_0x6
	__POINTW2MN _0x3B,0
	CALL _lcd_puts
	RJMP _0x2080006
_0x3A:
	LDS  R30,_doesConected
	LDS  R26,_lastConectedState
	CALL __NEB12
	LD   R26,Y
	OR   R30,R26
	BREQ _0x3C
	CLR  R12
	CLR  R13
	LDS  R30,_doesConected
	CPI  R30,0
	BREQ _0x3D
	LDI  R30,LOW(13)
	CALL SUBOPT_0x6
	__POINTW2MN _0x3B,2
	CALL _lcd_puts
	LDI  R30,LOW(15)
	CALL SUBOPT_0x6
	__POINTW2MN _0x3B,4
	RJMP _0x1B5
_0x3D:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x6
	__POINTW2MN _0x3B,6
	CALL _lcd_puts
	LDI  R30,LOW(15)
	CALL SUBOPT_0x6
	__POINTW2MN _0x3B,8
_0x1B5:
	CALL _lcd_puts
	LDS  R26,_doesConected
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_lastConectedState
	CALL SUBOPT_0x7
	BREQ _0x3F
	CALL SUBOPT_0x8
_0x3F:
	LDS  R30,_doesConected
	STS  _lastConectedState,R30
_0x3C:
	MOV  R30,R4
	LDS  R26,_lastPlayingState
	CALL __NEB12
	LD   R26,Y
	OR   R30,R26
	BREQ _0x40
	LDS  R30,_doesConected
	CPI  R30,0
	BRNE _0x41
	LDI  R30,LOW(14)
	CALL SUBOPT_0x9
	__POINTW2MN _0x3B,10
	CALL _lcd_puts
	RJMP _0x2080006
_0x41:
	CLR  R12
	CLR  R13
	LDI  R30,LOW(14)
	CALL SUBOPT_0x9
	TST  R4
	BREQ _0x42
	LDI  R26,LOW(5)
	RJMP _0x1B6
_0x42:
	LDI  R26,LOW(4)
_0x1B6:
	CALL _lcd_putchar
	STS  _lastPlayingState,R4
_0x40:
	RJMP _0x2080006

	.DSEG
_0x3B:
	.BYTE 0xC
;#include <volume_menu.h>                                                         //   3 - Inputs

	.CSEG
_volume_menu:
	ST   -Y,R17
;	temp -> R17
	CALL _lcd_clear
	LDS  R26,_volume
	LDI  R30,LOW(63)
	SUB  R30,R26
	MOV  R17,R30
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,91
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_volume
	CALL SUBOPT_0xB
	LDS  R26,_volume
	CLR  R27
	RCALL _ShowScaleSimple
	LDS  R30,_volume
	ANDI R30,LOW(0x3F)
	STS  _volume,R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	BREQ _0x44
	SBIS 0x1,4
	RJMP _0x45
	MOV  R26,R17
	CALL _i2c_write
_0x45:
	RJMP _0x46
_0x44:
	MOV  R26,R17
	CALL _i2c_write
_0x46:
	CALL _i2c_stop
	LDI  R26,LOW(1)
	RCALL _updateBluetoothState
	RJMP _0x2080007
;#include <treble_menu.h>                                                         //   4 - Preamp
_treble_menu:
	ST   -Y,R17
	ST   -Y,R16
;	temp2 -> R17
;	showtreble -> R16
	CALL _lcd_clear
	LDS  R30,_treble
	CALL SUBOPT_0xE
	BRNE _0x4A
	LDI  R16,LOW(242)
	LDI  R17,LOW(112)
	RJMP _0x49
_0x4A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4B
	LDI  R16,LOW(244)
	LDI  R17,LOW(113)
	RJMP _0x49
_0x4B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4C
	LDI  R16,LOW(246)
	LDI  R17,LOW(114)
	RJMP _0x49
_0x4C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4D
	LDI  R16,LOW(248)
	LDI  R17,LOW(115)
	RJMP _0x49
_0x4D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4E
	LDI  R16,LOW(250)
	LDI  R17,LOW(116)
	RJMP _0x49
_0x4E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4F
	LDI  R16,LOW(252)
	LDI  R17,LOW(117)
	RJMP _0x49
_0x4F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x50
	LDI  R16,LOW(254)
	LDI  R17,LOW(118)
	RJMP _0x49
_0x50:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x51
	LDI  R16,LOW(0)
	LDI  R17,LOW(119)
	RJMP _0x49
_0x51:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x52
	LDI  R16,LOW(2)
	LDI  R17,LOW(126)
	RJMP _0x49
_0x52:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x53
	LDI  R16,LOW(4)
	LDI  R17,LOW(125)
	RJMP _0x49
_0x53:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x54
	LDI  R16,LOW(6)
	LDI  R17,LOW(124)
	RJMP _0x49
_0x54:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x55
	LDI  R16,LOW(8)
	LDI  R17,LOW(123)
	RJMP _0x49
_0x55:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x56
	LDI  R16,LOW(10)
	LDI  R17,LOW(122)
	RJMP _0x49
_0x56:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x57
	LDI  R16,LOW(12)
	LDI  R17,LOW(121)
	RJMP _0x49
_0x57:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x49
	LDI  R16,LOW(14)
	LDI  R17,LOW(120)
_0x49:
	CPI  R16,1
	BRGE _0x59
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,103
	CALL SUBOPT_0xF
_0x59:
	CPI  R16,1
	BRLT _0x5A
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,115
	CALL SUBOPT_0xF
_0x5A:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	RJMP _0x2080005
;#include <bass_menu.h>                                                           //   5 - Loudness
_bass_menu:
	ST   -Y,R17
	ST   -Y,R16
;	temp2 -> R17
;	showbass -> R16
	CALL _lcd_clear
	LDS  R30,_bass
	CALL SUBOPT_0xE
	BRNE _0x5E
	LDI  R16,LOW(242)
	LDI  R17,LOW(96)
	RJMP _0x5D
_0x5E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R16,LOW(244)
	LDI  R17,LOW(97)
	RJMP _0x5D
_0x5F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x60
	LDI  R16,LOW(246)
	LDI  R17,LOW(98)
	RJMP _0x5D
_0x60:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x61
	LDI  R16,LOW(248)
	LDI  R17,LOW(99)
	RJMP _0x5D
_0x61:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x62
	LDI  R16,LOW(250)
	LDI  R17,LOW(100)
	RJMP _0x5D
_0x62:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x63
	LDI  R16,LOW(252)
	LDI  R17,LOW(101)
	RJMP _0x5D
_0x63:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x64
	LDI  R16,LOW(254)
	LDI  R17,LOW(102)
	RJMP _0x5D
_0x64:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x65
	LDI  R16,LOW(0)
	LDI  R17,LOW(103)
	RJMP _0x5D
_0x65:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x66
	LDI  R16,LOW(2)
	LDI  R17,LOW(110)
	RJMP _0x5D
_0x66:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x67
	LDI  R16,LOW(4)
	LDI  R17,LOW(109)
	RJMP _0x5D
_0x67:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x68
	LDI  R16,LOW(6)
	LDI  R17,LOW(108)
	RJMP _0x5D
_0x68:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x69
	LDI  R16,LOW(8)
	LDI  R17,LOW(107)
	RJMP _0x5D
_0x69:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x6A
	LDI  R16,LOW(10)
	LDI  R17,LOW(106)
	RJMP _0x5D
_0x6A:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x6B
	LDI  R16,LOW(12)
	LDI  R17,LOW(105)
	RJMP _0x5D
_0x6B:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x5D
	LDI  R16,LOW(14)
	LDI  R17,LOW(104)
_0x5D:
	CPI  R16,1
	BRGE _0x6D
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,128
	CALL SUBOPT_0xF
_0x6D:
	CPI  R16,1
	BRLT _0x6E
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,138
	CALL SUBOPT_0xF
_0x6E:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	RJMP _0x2080005
;#include <inputs_menu.h>                                                         //   6 - Balance Left - Right
_inputs_menu:
	ST   -Y,R17
;	send -> R17
	CALL _lcd_clear
	CALL SUBOPT_0x3
	LDS  R30,_loudness
	ANDI R30,LOW(0x4)
	STS  _loudness,R30
	LDS  R30,_gain
	ANDI R30,LOW(0x18)
	STS  _gain,R30
	LDS  R30,_input
	ANDI R30,LOW(0x3)
	STS  _input,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x6
	__POINTW2MN _0x6F,0
	CALL _lcd_puts
	LDS  R30,_input
	CALL SUBOPT_0xE
	BRNE _0x73
	LDI  R30,LOW(10)
	RJMP _0x1B7
_0x73:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x74
	LDI  R30,LOW(12)
	RJMP _0x1B7
_0x74:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x72
	LDI  R30,LOW(14)
_0x1B7:
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
_0x72:
	LDI  R26,LOW(217)
	CALL _lcd_putchar
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	RJMP _0x2080007

	.DSEG
_0x6F:
	.BYTE 0x11
;#include <preamp_menu.h>                                                         //   7 - Balance Front - Rear

	.CSEG
_preamp_menu:
	ST   -Y,R17
;	send -> R17
	CALL _lcd_clear
	LDS  R30,_input
	ANDI R30,LOW(0x3)
	STS  _input,R30
	CALL SUBOPT_0xE
	BRNE _0x79
	CALL SUBOPT_0x13
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x7D
	__POINTW2MN _0x7E,0
	CALL SUBOPT_0x0
	__POINTW2MN _0x7E,17
	RJMP _0x1B8
_0x7D:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x7F
	__POINTW2MN _0x7E,34
	CALL SUBOPT_0x0
	__POINTW2MN _0x7E,51
	RJMP _0x1B8
_0x7F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x80
	__POINTW2MN _0x7E,68
	CALL SUBOPT_0x0
	__POINTW2MN _0x7E,85
	RJMP _0x1B8
_0x80:
	SBIW R30,0
	BRNE _0x7C
	__POINTW2MN _0x7E,102
	CALL SUBOPT_0x0
	__POINTW2MN _0x7E,119
_0x1B8:
	CALL _lcd_puts
_0x7C:
	RJMP _0x78
_0x79:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x83
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x78
_0x83:
	CALL SUBOPT_0x13
_0x88:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x89
	__POINTW2MN _0x7E,136
	CALL SUBOPT_0x0
	__POINTW2MN _0x7E,153
	CALL _lcd_puts
	RJMP _0x87
_0x89:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x8A
	__POINTW2MN _0x7E,164
	CALL _lcd_puts
	LDI  R30,LOW(7)
	CALL SUBOPT_0x9
	__POINTW2MN _0x7E,181
	CALL _lcd_puts
	RJMP _0x87
_0x8A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x8B
	LDI  R30,LOW(16)
	STS  _gain,R30
	RJMP _0x88
_0x8B:
	SBIW R30,0
	BRNE _0x87
	LDI  R30,LOW(16)
	STS  _gain,R30
	RJMP _0x88
_0x87:
_0x78:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	RJMP _0x2080007

	.DSEG
_0x7E:
	.BYTE 0xB7
;#include <loudness_menu.h>                                                       //   8 - Bluetooth ON/OFF

	.CSEG
_loudness_menu:
	ST   -Y,R17
;	send -> R17
	CALL _lcd_clear
	__POINTW2MN _0x8E,0
	CALL SUBOPT_0x0
	LDS  R30,_loudness
	CPI  R30,0
	BRNE _0x8F
	__POINTW2MN _0x8E,10
	RJMP _0x1B9
_0x8F:
	__POINTW2MN _0x8E,26
_0x1B9:
	CALL _lcd_puts
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	RJMP _0x2080007

	.DSEG
_0x8E:
	.BYTE 0x2B
;#include <RL_balance_menu.h>                                                     //   9 - Brightless

	.CSEG
_RL_balance_menu:
	CALL SUBOPT_0x14
;	balance1 -> R17
;	balance2 -> R16
;	LF -> R19
;	RF -> R18
;	LR -> R21
;	RR -> R20
;	x -> Y+6
	BRGE _0x91
	MOV  R18,R17
	LDI  R19,LOW(31)
_0x91:
	LDS  R17,_LR_balance
	CPI  R17,31
	BRNE _0x92
	LDI  R30,LOW(31)
	MOV  R19,R30
	MOV  R18,R30
_0x92:
	LDS  R17,_LR_balance
	CPI  R17,32
	BRLT _0x93
	LDI  R30,LOW(62)
	SUB  R30,R17
	MOV  R17,R30
	MOV  R19,R17
	LDI  R18,LOW(31)
_0x93:
	MOV  R21,R19
	MOV  R20,R18
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,358
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R19
	CALL SUBOPT_0x16
	LDI  R30,LOW(7)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	MOV  R30,R18
	CALL SUBOPT_0x16
	LDI  R30,LOW(11)
	CALL SUBOPT_0x6
	__POINTW2MN _0x94,0
	CALL SUBOPT_0x0
	CPI  R19,0
	BREQ _0x95
	LDS  R17,_LR_balance
_0x97:
	CPI  R17,1
	BRLT _0x98
	__POINTW2MN _0x94,6
	CALL SUBOPT_0x19
	SUBI R17,LOW(5)
	RJMP _0x97
_0x98:
	CALL SUBOPT_0x5
_0x99:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x9B
	__POINTW2MN _0x94,8
	CALL SUBOPT_0x19
	RJMP _0x99
_0x9B:
	RJMP _0x9C
_0x95:
	__POINTW2MN _0x94,10
	CALL _lcd_puts
	CALL SUBOPT_0x5
_0x9C:
	CPI  R16,31
	BRGE _0x9D
	LDI  R30,LOW(31)
	SUB  R30,R16
	MOV  R16,R30
	SUB  R20,R16
	SUB  R21,R16
_0x9D:
	LDS  R16,_FR_balance
	CPI  R16,32
	BRLT _0x9E
	SUBI R16,LOW(31)
	SUB  R18,R16
	SUB  R19,R16
_0x9E:
	CALL SUBOPT_0xC
	CPI  R19,1
	BRLT _0x9F
	LDI  R30,LOW(31)
	SUB  R30,R19
	MOV  R19,R30
	RJMP _0xA0
_0x9F:
	LDI  R19,LOW(31)
_0xA0:
	CPI  R18,1
	BRLT _0xA1
	LDI  R30,LOW(31)
	SUB  R30,R18
	MOV  R18,R30
	RJMP _0xA2
_0xA1:
	LDI  R18,LOW(31)
_0xA2:
	CPI  R21,1
	BRLT _0xA3
	LDI  R30,LOW(31)
	SUB  R30,R21
	MOV  R21,R30
	RJMP _0xA4
_0xA3:
	LDI  R21,LOW(31)
_0xA4:
	CPI  R20,1
	BRLT _0xA5
	LDI  R30,LOW(31)
	SUB  R30,R20
	MOV  R20,R30
	RJMP _0xA6
_0xA5:
	LDI  R20,LOW(31)
_0xA6:
	RJMP _0x2080008

	.DSEG
_0x94:
	.BYTE 0x19
;#include <FR_balance_menu.h>                                                     //  10 - Opacity

	.CSEG
_FS_balance_menu:
	CALL SUBOPT_0x14
;	balance1 -> R17
;	balance2 -> R16
;	LF -> R19
;	RF -> R18
;	LR -> R21
;	RR -> R20
;	x -> Y+6
	BRGE _0xA7
	MOV  R18,R17
	LDI  R19,LOW(31)
_0xA7:
	LDS  R17,_LR_balance
	CPI  R17,31
	BRNE _0xA8
	LDI  R30,LOW(31)
	MOV  R19,R30
	MOV  R18,R30
_0xA8:
	LDS  R17,_LR_balance
	CPI  R17,32
	BRLT _0xA9
	LDI  R30,LOW(62)
	SUB  R30,R17
	MOV  R17,R30
	MOV  R19,R17
	LDI  R18,LOW(31)
_0xA9:
	MOV  R21,R19
	MOV  R20,R18
	CPI  R16,31
	BRGE _0xAA
	LDI  R30,LOW(31)
	SUB  R30,R16
	MOV  R16,R30
	SUB  R20,R16
	SUB  R21,R16
_0xAA:
	LDS  R16,_FR_balance
	CPI  R16,32
	BRLT _0xAB
	SUBI R16,LOW(31)
	SUB  R18,R16
	SUB  R19,R16
_0xAB:
	LDS  R16,_FR_balance
	CPI  R16,31
	BRGE _0xAC
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,99
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
	__POINTW2MN _0xAD,0
	CALL _lcd_puts
_0xAC:
	CPI  R16,31
	BRNE _0xAE
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	__POINTW2MN _0xAD,5
	CALL _lcd_puts
_0xAE:
	CPI  R16,32
	BRLT _0xAF
	LDI  R30,LOW(62)
	SUB  R30,R16
	MOV  R16,R30
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,387
	CALL SUBOPT_0xF
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	LDI  R30,LOW(8)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	__POINTW2MN _0xAD,10
	CALL _lcd_puts
_0xAF:
	LDS  R16,_FR_balance
	CPI  R16,62
	BREQ _0xB0
	LDS  R16,_FR_balance
_0xB2:
	CPI  R16,1
	BRLT _0xB3
	__POINTW2MN _0xAD,15
	CALL SUBOPT_0x19
	SUBI R16,LOW(5)
	RJMP _0xB2
_0xB3:
	CALL SUBOPT_0x5
_0xB4:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0xB6
	__POINTW2MN _0xAD,17
	CALL SUBOPT_0x19
	RJMP _0xB4
_0xB6:
	RJMP _0xB7
_0xB0:
	__POINTW2MN _0xAD,19
	CALL _lcd_puts
	CALL SUBOPT_0x5
_0xB7:
	CALL SUBOPT_0xC
	CPI  R19,1
	BRLT _0xB8
	LDI  R30,LOW(31)
	SUB  R30,R19
	MOV  R19,R30
	RJMP _0xB9
_0xB8:
	LDI  R19,LOW(31)
_0xB9:
	CPI  R18,1
	BRLT _0xBA
	LDI  R30,LOW(31)
	SUB  R30,R18
	MOV  R18,R30
	RJMP _0xBB
_0xBA:
	LDI  R18,LOW(31)
_0xBB:
	CPI  R21,1
	BRLT _0xBC
	LDI  R30,LOW(31)
	SUB  R30,R21
	MOV  R21,R30
	RJMP _0xBD
_0xBC:
	LDI  R21,LOW(31)
_0xBD:
	CPI  R20,1
	BRLT _0xBE
	LDI  R30,LOW(31)
	SUB  R30,R20
	MOV  R20,R30
	RJMP _0xBF
_0xBE:
	LDI  R20,LOW(31)
_0xBF:
_0x2080008:
	ANDI R19,LOW(31)
	ANDI R18,LOW(31)
	ANDI R21,LOW(31)
	ANDI R20,LOW(31)
	ORI  R19,LOW(128)
	ORI  R18,LOW(160)
	ORI  R21,LOW(192)
	ORI  R20,LOW(224)
	MOV  R26,R19
	CALL _i2c_write
	MOV  R26,R18
	CALL _i2c_write
	MOV  R26,R21
	CALL _i2c_write
	MOV  R26,R20
	CALL _i2c_write
	CALL _i2c_stop
	CALL __LOADLOCR6
	ADIW R28,7
	RET

	.DSEG
_0xAD:
	.BYTE 0x22
;#include <bluetooth_menu.h>                                                      //  11 - Bluetooth PlayerMenu

	.CSEG
_bluetooth_menu:
	CALL _lcd_clear
	__POINTW2MN _0xC0,0
	CALL SUBOPT_0x0
	LDS  R30,_isBluetoothEnabled
	CPI  R30,0
	BREQ _0xC1
	__POINTW2MN _0xC0,13
	RJMP _0x1BA
_0xC1:
	__POINTW2MN _0xC0,25
_0x1BA:
	CALL _lcd_puts
	RET

	.DSEG
_0xC0:
	.BYTE 0x25
;#include <brightless_menu.h>

	.CSEG
_brightless_menu:
	ST   -Y,R17
;	temp -> R17
	LDI  R30,LOW(105)
	OUT  0x33,R30
	SBI  0x18,4
	LDS  R30,_brightless
	OUT  0x31,R30
	MOV  R17,R30
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __DIVW21
	MOV  R17,R30
	LDS  R26,_brightless
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _sleepBrightless,R30
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,438
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	CALL SUBOPT_0xB
	MOV  R26,R17
	CLR  R27
	RCALL _ShowScaleSimple
_0x2080007:
	LD   R17,Y+
	RET
;#include <opasity_menu.h>
_opasity_menu:
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	__GETWRMN 16,17,0,_opasity
	CALL SUBOPT_0x1D
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	MOVW R26,R16
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	MOVW R16,R30
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,454
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	MOVW R26,R16
	RCALL _ShowScaleSimple
	RJMP _0x2080005
;
;
;
;//Update SCREEN information
;void UpdateMenu (void) {
; 0000 005E void UpdateMenu (void) {
_UpdateMenu:
; 0000 005F 
; 0000 0060 sleepTimer=0;
	CLR  R12
	CLR  R13
; 0000 0061 
; 0000 0062 	switch (recentMenu) {
	MOV  R30,R5
	CALL SUBOPT_0xE
; 0000 0063 		case 0: volume_menu();
	BRNE _0xC8
	RCALL _volume_menu
; 0000 0064 		break;
	RJMP _0xC7
; 0000 0065 		case 1: treble_menu();
_0xC8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC9
	RCALL _treble_menu
; 0000 0066 		break;
	RJMP _0xC7
; 0000 0067 		case 2: bass_menu();
_0xC9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCA
	RCALL _bass_menu
; 0000 0068 		break;
	RJMP _0xC7
; 0000 0069 		case 3: inputs_menu();
_0xCA:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xCB
	RCALL _inputs_menu
; 0000 006A 		break;
	RJMP _0xC7
; 0000 006B         case 4: preamp_menu();
_0xCB:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xCC
	RCALL _preamp_menu
; 0000 006C         break;
	RJMP _0xC7
; 0000 006D         case 5: loudness_menu();
_0xCC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xCD
	RCALL _loudness_menu
; 0000 006E         break;
	RJMP _0xC7
; 0000 006F         case 6: RL_balance_menu();
_0xCD:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xCE
	RCALL _RL_balance_menu
; 0000 0070         break;
	RJMP _0xC7
; 0000 0071         case 7: FS_balance_menu();
_0xCE:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xCF
	RCALL _FS_balance_menu
; 0000 0072         break;
	RJMP _0xC7
; 0000 0073         case 8: bluetooth_menu();
_0xCF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xD0
	RCALL _bluetooth_menu
; 0000 0074         break;
	RJMP _0xC7
; 0000 0075         case 9: brightless_menu();
_0xD0:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xD1
	RCALL _brightless_menu
; 0000 0076         break;
	RJMP _0xC7
; 0000 0077         case 10: opasity_menu();
_0xD1:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xD2
	RCALL _opasity_menu
; 0000 0078         break;
	RJMP _0xC7
; 0000 0079         case 11: BluePlayerMenu();
_0xD2:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xC7
	RCALL _BluePlayerMenu
; 0000 007A         break;
; 0000 007B 	}
_0xC7:
; 0000 007C };
	RET
;
;void SendToBluetoothByte (char data) {
; 0000 007E void SendToBluetoothByte (char data) {
_SendToBluetoothByte:
; 0000 007F 
; 0000 0080 while ( !( UCSR1A & (1<<UDRE1)) ) {}
	ST   -Y,R26
;	data -> Y+0
_0xD4:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0xD4
; 0000 0081 UDR1=data;
	LD   R30,Y
	STS  156,R30
; 0000 0082 }
	RJMP _0x2080006
;
;void SendToBluetooth (char *string){
; 0000 0084 void SendToBluetooth (char *string){
_SendToBluetooth:
; 0000 0085 SendToBluetoothByte('A');
	ST   -Y,R27
	ST   -Y,R26
;	*string -> Y+0
	LDI  R26,LOW(65)
	RCALL _SendToBluetoothByte
; 0000 0086 SendToBluetoothByte('T');
	LDI  R26,LOW(84)
	RCALL _SendToBluetoothByte
; 0000 0087 SendToBluetoothByte('#');
	LDI  R26,LOW(35)
	RCALL _SendToBluetoothByte
; 0000 0088 SendToBluetoothByte(*string);
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	RCALL _SendToBluetoothByte
; 0000 0089 *string++;
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
; 0000 008A SendToBluetoothByte(*string);
	LD   R26,X
	RCALL _SendToBluetoothByte
; 0000 008B SendToBluetoothByte(0x0a);
	LDI  R26,LOW(10)
	RCALL _SendToBluetoothByte
; 0000 008C SendToBluetoothByte(0x0d);
	LDI  R26,LOW(13)
	RCALL _SendToBluetoothByte
; 0000 008D 
; 0000 008E }
	ADIW R28,2
	RET
;
;void LED (unsigned char color) {
; 0000 0090 void LED (unsigned char color) {
_LED:
; 0000 0091 switch (color) {
	ST   -Y,R26
;	color -> Y+0
	LD   R30,Y
	CALL SUBOPT_0xE
; 0000 0092 case 0: PORTF=0b00000000; break;
	BRNE _0xDA
	LDI  R30,LOW(0)
	RJMP _0x1BB
; 0000 0093 case 1: PORTF=0b00000100; break;
_0xDA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xDB
	LDI  R30,LOW(4)
	RJMP _0x1BB
; 0000 0094 case 2: PORTF=0b00010000; break;
_0xDB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xDC
	LDI  R30,LOW(16)
	RJMP _0x1BB
; 0000 0095 case 3: PORTF=0b01000000; break;
_0xDC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xDD
	LDI  R30,LOW(64)
	RJMP _0x1BB
; 0000 0096 case 4: PORTF=0b00010100; break;
_0xDD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xDE
	LDI  R30,LOW(20)
	RJMP _0x1BB
; 0000 0097 case 5: PORTF=0b01000100; break;
_0xDE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xDF
	LDI  R30,LOW(68)
	RJMP _0x1BB
; 0000 0098 case 6: PORTF=0b01010000; break;
_0xDF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xE0
	LDI  R30,LOW(80)
	RJMP _0x1BB
; 0000 0099 case 7: PORTF=0b01010100; break;
_0xE0:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xD9
	LDI  R30,LOW(84)
_0x1BB:
	STS  98,R30
; 0000 009A }
_0xD9:
; 0000 009B }
_0x2080006:
	ADIW R28,1
	RET
;
;void BluetoothOFF (void) {
; 0000 009D void BluetoothOFF (void) {
_BluetoothOFF:
; 0000 009E PORTA.1=0;
	CALL SUBOPT_0x1E
; 0000 009F UCSR1A=0x00;
; 0000 00A0 UCSR1B=0x00;
; 0000 00A1 UCSR1C=0x00;
; 0000 00A2 UBRR1H=0x00;
; 0000 00A3 UBRR1L=0x00;
; 0000 00A4 
; 0000 00A5 isBluetoothEnabled=0;
	LDI  R30,LOW(0)
	STS  _isBluetoothEnabled,R30
; 0000 00A6 updateBluetoothState(0);
	LDI  R26,LOW(0)
	RCALL _updateBluetoothState
; 0000 00A7 doesConected=0;
	LDI  R30,LOW(0)
	STS  _doesConected,R30
; 0000 00A8 doesPlaying=0;
	CLR  R4
; 0000 00A9 }
	RET
;
;void BluetoothON (void) {
; 0000 00AB void BluetoothON (void) {
_BluetoothON:
; 0000 00AC PORTA.1=1;
	CALL SUBOPT_0x1F
; 0000 00AD UCSR1A=0x00;
; 0000 00AE UCSR1B=0xD8;
; 0000 00AF UCSR1C=0x06;
; 0000 00B0 UBRR1H=0x00;
; 0000 00B1 UBRR1L=0x08;
; 0000 00B2 
; 0000 00B3 bluetoothResetTimer=0;
; 0000 00B4 isBluetoothEnabled=1;
	LDI  R30,LOW(1)
	STS  _isBluetoothEnabled,R30
; 0000 00B5 updateBluetoothState(0);
	LDI  R26,LOW(0)
	RCALL _updateBluetoothState
; 0000 00B6 }
	RET
;
;void BluetoothReset(void) {
; 0000 00B8 void BluetoothReset(void) {
_BluetoothReset:
; 0000 00B9 
; 0000 00BA       if (doesConected|!isBluetoothEnabled) return;
	LDS  R30,_isBluetoothEnabled
	CALL __LNEGB1
	LDS  R26,_doesConected
	OR   R30,R26
	BREQ _0xE6
	RET
; 0000 00BB 
; 0000 00BC         if (bluetoothResetTimer<(bluetoothResetTime+500)) {
_0xE6:
	MOVW R30,R8
	SUBI R30,LOW(-500)
	SBCI R31,HIGH(-500)
	LDS  R26,_bluetoothResetTimer
	LDS  R27,_bluetoothResetTimer+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0xE7
; 0000 00BD            PORTA.1=0;
	CALL SUBOPT_0x1E
; 0000 00BE            UCSR1A=0x00;
; 0000 00BF            UCSR1B=0x00;
; 0000 00C0            UCSR1C=0x00;
; 0000 00C1            UBRR1H=0x00;
; 0000 00C2            UBRR1L=0x00;
; 0000 00C3            LED(3);
	LDI  R26,LOW(3)
	RJMP _0x1BC
; 0000 00C4         } else  {
_0xE7:
; 0000 00C5            PORTA.1=1;
	CALL SUBOPT_0x1F
; 0000 00C6            UCSR1A=0x00;
; 0000 00C7            UCSR1B=0xD8;
; 0000 00C8            UCSR1C=0x06;
; 0000 00C9            UBRR1H=0x00;
; 0000 00CA            UBRR1L=0x08;
; 0000 00CB            bluetoothResetTimer=0;
; 0000 00CC            if (isOFF) LED(0); else LED(2);
	LDS  R30,_isOFF
	CPI  R30,0
	BREQ _0xED
	LDI  R26,LOW(0)
	RJMP _0x1BC
_0xED:
	LDI  R26,LOW(2)
_0x1BC:
	RCALL _LED
; 0000 00CD         }
; 0000 00CE 
; 0000 00CF }
	RET
;
;#include <buttons_controll.c>
;void button_1 (void) {int k;
; 0000 00D1 void button_1 (void) {int k;
_button_1:
;#asm ("cli");
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	cli
;
;
;i2c_start();
	CALL SUBOPT_0xC
;i2c_write(0b10001000);
;i2c_write(63);
	LDI  R26,LOW(63)
	CALL _i2c_write
;i2c_write(0b10011111);
	LDI  R26,LOW(159)
	CALL _i2c_write
;i2c_write(0b10111111);
	LDI  R26,LOW(191)
	CALL _i2c_write
;i2c_write(0b11011111);
	LDI  R26,LOW(223)
	CALL _i2c_write
;i2c_write(0b11111111);
	LDI  R26,LOW(255)
	CALL _i2c_write
;i2c_stop();
	CALL _i2c_stop
;
;
;PORTA&=~1;
	CBI  0x1B,0
;delay_ms(10);
	LDI  R26,LOW(10)
	CALL SUBOPT_0x20
;lcd_clear();
	CALL _lcd_clear
;lcd_puts("  Leskiv");
	__POINTW2MN _0xEF,0
	CALL SUBOPT_0x0
;lcd_gotoxy(0,1);
;lcd_puts("    Production");
	__POINTW2MN _0xEF,9
	CALL _lcd_puts
;delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
;
;
;settings[0]=volume;
	LDS  R30,_volume
	LDI  R26,LOW(_settings)
	LDI  R27,HIGH(_settings)
	CALL SUBOPT_0x21
;settings[1]=bass;
	__POINTW2MN _settings,2
	LDS  R30,_bass
	CALL SUBOPT_0x21
;settings[2]=treble;
	__POINTW2MN _settings,4
	LDS  R30,_treble
	CALL SUBOPT_0x21
;settings[3]=gain;
	__POINTW2MN _settings,6
	CALL SUBOPT_0x13
	CALL __EEPROMWRW
;settings[4]=loudness;
	__POINTW2MN _settings,8
	LDS  R30,_loudness
	CALL SUBOPT_0x21
;settings[5]=LR_balance;
	__POINTW2MN _settings,10
	LDS  R30,_LR_balance
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __EEPROMWRW
;settings[6]=FR_balance;
	__POINTW2MN _settings,12
	LDS  R30,_FR_balance
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __EEPROMWRW
;settings[7]=input;
	__POINTW2MN _settings,14
	LDS  R30,_input
	CALL SUBOPT_0x21
;settings[8]=brightless;
	__POINTW2MN _settings,16
	LDS  R30,_brightless
	CALL SUBOPT_0x21
;settings[9]=opasity;
	__POINTW2MN _settings,18
	CALL SUBOPT_0x1D
	CALL __EEPROMWRW
;settings[10]=doesPlaying;
	__POINTW2MN _settings,20
	MOV  R30,R4
	CALL SUBOPT_0x21
;settings[11]=isBluetoothEnabled;
	__POINTW2MN _settings,22
	LDS  R30,_isBluetoothEnabled
	CALL SUBOPT_0x21
;doesEEpromWritten=1;
	LDI  R26,LOW(_doesEEpromWritten)
	LDI  R27,HIGH(_doesEEpromWritten)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
;
;
;for (k=opasity; k<500; k++) {
	__GETWRMN 16,17,0,_opasity
_0xF1:
	__CPWRN 16,17,500
	BRGE _0xF2
;OCR1A=k;
	__OUTWR 16,17,42
;delay_ms(1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x20
;}
	__ADDWRN 16,17,1
	RJMP _0xF1
_0xF2:
;
;for (k=brightless; k>=0; k--) {
	LDS  R16,_brightless
	CLR  R17
_0xF4:
	TST  R17
	BRMI _0xF5
;OCR0=k;
	OUT  0x31,R16
;delay_ms(1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x20
;}
	__SUBWRN 16,17,1
	RJMP _0xF4
_0xF5:
;
;TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;PORTB.4=0;
	CBI  0x18,4
;
;lcd_clear();
	CALL _lcd_clear
;
;delay_ms(50);
	LDI  R26,LOW(50)
	CALL SUBOPT_0x20
;
;WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
;WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
;
;#asm ("cli");
	cli
;while (1) {}
_0xF8:
	RJMP _0xF8
;
;
;
;}
_0x2080005:
	LD   R16,Y+
	LD   R17,Y+
	RET

	.DSEG
_0xEF:
	.BYTE 0x18
;
;
;void button_2 (void) {

	.CSEG
_button_2:
;if (recentMenu==1) {
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xFB
;recentMenu=bassMenu;} else {
	LDI  R30,LOW(2)
	RJMP _0x1BD
_0xFB:
;recentMenu=trebleMenu;}
	LDI  R30,LOW(1)
_0x1BD:
	MOV  R5,R30
;UpdateMenu();
	RJMP _0x2080004
;}
;
;
;void button_3 (void) {
_button_3:
;    if (recentMenu==3) {
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0xFD
;    recentMenu=preampMenu;} else
	LDI  R30,LOW(4)
	RJMP _0x1BE
_0xFD:
;    recentMenu=inputsMenu;
	LDI  R30,LOW(3)
_0x1BE:
	MOV  R5,R30
;UpdateMenu();
	RJMP _0x2080004
;}
;
;
;void button_4 (void) {
_button_4:
;recentMenu=5;
	LDI  R30,LOW(5)
	MOV  R5,R30
;UpdateMenu();
	RJMP _0x2080004
;}
;
;
;void button_5 (void) {
_button_5:
;if (recentMenu==6) {recentMenu=FRBalanceMenu}
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0xFF
	LDI  R30,LOW(7)
	RJMP _0x1BF
;else {recentMenu=LRBalanceMenu}
_0xFF:
	LDI  R30,LOW(6)
_0x1BF:
	MOV  R5,R30
;UpdateMenu();
	RJMP _0x2080004
;}
;
;
;void button_6 (void) {
_button_6:
;
;}
	RET
;
;
;void button_7 (void) {
_button_7:
;
;}
	RET
;
;
;void button_8 (void) {
_button_8:
;recentMenu=11;
	LDI  R30,LOW(11)
	MOV  R5,R30
;UpdateMenu();
	RJMP _0x2080004
;}
;
;
;void button_9 (void) {
_button_9:
;switch (recentMenu) {
	MOV  R30,R5
	LDI  R31,0
;case 8: recentMenu=9;  break;
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x104
	LDI  R30,LOW(9)
	RJMP _0x1C0
;case 9: recentMenu=10; break;
_0x104:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x105
	LDI  R30,LOW(10)
	RJMP _0x1C0
;case 10: recentMenu=8; break;
_0x105:
;default: recentMenu=8; break;
_0x1C1:
	LDI  R30,LOW(8)
_0x1C0:
	MOV  R5,R30
;}
;UpdateMenu();
_0x2080004:
	RCALL _UpdateMenu
;}
	RET
;
;
;//Called, when ENCODER has been rotated. 1: clockwise. 2: counterclockwise
;void ValueChanged (char direction) {
; 0000 00D4 void ValueChanged (char direction) {
_ValueChanged:
; 0000 00D5 if (isOFF) return;
	ST   -Y,R26
;	direction -> Y+0
	LDS  R30,_isOFF
	CPI  R30,0
	BREQ _0x108
	JMP  _0x2080002
; 0000 00D6 timer=0;
_0x108:
	CALL SUBOPT_0x22
; 0000 00D7 sleepTimer=0;
; 0000 00D8 switch (recentMenu) {
	MOV  R30,R5
	CALL SUBOPT_0x4
; 0000 00D9      case 1: if (direction==1) {if (treble<14) {treble++;}} else {if (treble!=0) {treble--;}}
	BRNE _0x10C
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x10D
	LDS  R26,_treble
	CPI  R26,LOW(0xE)
	BRSH _0x10E
	LDS  R30,_treble
	SUBI R30,-LOW(1)
	STS  _treble,R30
_0x10E:
	RJMP _0x10F
_0x10D:
	LDS  R30,_treble
	CPI  R30,0
	BREQ _0x110
	SUBI R30,LOW(1)
	STS  _treble,R30
_0x110:
_0x10F:
; 0000 00DA      break;
	RJMP _0x10B
; 0000 00DB      case 2: if (direction==1) {if (bass<14) {bass++;}} else {if (bass!=0) {bass--;}}
_0x10C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x111
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x112
	LDS  R26,_bass
	CPI  R26,LOW(0xE)
	BRSH _0x113
	LDS  R30,_bass
	SUBI R30,-LOW(1)
	STS  _bass,R30
_0x113:
	RJMP _0x114
_0x112:
	LDS  R30,_bass
	CPI  R30,0
	BREQ _0x115
	SUBI R30,LOW(1)
	STS  _bass,R30
_0x115:
_0x114:
; 0000 00DC      break;
	RJMP _0x10B
; 0000 00DD      case 3: if (input==1&isBluetoothEnabled&doesConected&doesPlaying) {
_0x111:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x116
	CALL SUBOPT_0xD
	LDS  R26,_doesConected
	AND  R30,R26
	AND  R30,R4
	BREQ _0x117
; 0000 00DE              wasPlayingBeforeSwitch=1; SendToBluetooth ("MA");}
	LDI  R30,LOW(1)
	STS  _wasPlayingBeforeSwitch,R30
	__POINTW2MN _0x118,0
	RCALL _SendToBluetooth
; 0000 00DF              if (direction==1) {if (input<2) {input++;}} else {if (input!=0) {input--;}}
_0x117:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x119
	LDS  R26,_input
	CPI  R26,LOW(0x2)
	BRSH _0x11A
	LDS  R30,_input
	SUBI R30,-LOW(1)
	STS  _input,R30
_0x11A:
	RJMP _0x11B
_0x119:
	LDS  R30,_input
	CPI  R30,0
	BREQ _0x11C
	SUBI R30,LOW(1)
	STS  _input,R30
_0x11C:
_0x11B:
; 0000 00E0              if (input==1&wasPlayingBeforeSwitch==1) {
	CALL SUBOPT_0x23
	LDS  R26,_wasPlayingBeforeSwitch
	CALL SUBOPT_0x7
	BREQ _0x11D
; 0000 00E1              wasPlayingBeforeSwitch=0; SendToBluetooth ("MA");}
	LDI  R30,LOW(0)
	STS  _wasPlayingBeforeSwitch,R30
	__POINTW2MN _0x118,3
	RCALL _SendToBluetooth
; 0000 00E2 
; 0000 00E3      break;
_0x11D:
	RJMP _0x10B
; 0000 00E4      case 4: if (direction==0) {if (gain<24) {gain+=8;}} else {if (gain!=0) {gain-=8;}}
_0x116:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11E
	LD   R30,Y
	CPI  R30,0
	BRNE _0x11F
	LDS  R26,_gain
	CPI  R26,LOW(0x18)
	BRSH _0x120
	LDS  R30,_gain
	SUBI R30,-LOW(8)
	STS  _gain,R30
_0x120:
	RJMP _0x121
_0x11F:
	LDS  R30,_gain
	CPI  R30,0
	BREQ _0x122
	SUBI R30,LOW(8)
	STS  _gain,R30
_0x122:
_0x121:
; 0000 00E5      break;
	RJMP _0x10B
; 0000 00E6      case 5: if (direction==0) {if (loudness!=0) {loudness=0;}} else {if (loudness!=4) {loudness=4;}}
_0x11E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x123
	LD   R30,Y
	CPI  R30,0
	BRNE _0x124
	LDS  R30,_loudness
	CPI  R30,0
	BREQ _0x125
	LDI  R30,LOW(0)
	STS  _loudness,R30
_0x125:
	RJMP _0x126
_0x124:
	LDS  R26,_loudness
	CPI  R26,LOW(0x4)
	BREQ _0x127
	LDI  R30,LOW(4)
	STS  _loudness,R30
_0x127:
_0x126:
; 0000 00E7      break;
	RJMP _0x10B
; 0000 00E8      case 6: if (direction==0) {if (LR_balance!=0) {LR_balance--;}} else {if (LR_balance<62) {LR_balance++;}}
_0x123:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x128
	LD   R30,Y
	CPI  R30,0
	BRNE _0x129
	LDS  R30,_LR_balance
	CPI  R30,0
	BREQ _0x12A
	SUBI R30,LOW(1)
	STS  _LR_balance,R30
_0x12A:
	RJMP _0x12B
_0x129:
	LDS  R26,_LR_balance
	CPI  R26,LOW(0x3E)
	BRGE _0x12C
	LDS  R30,_LR_balance
	SUBI R30,-LOW(1)
	STS  _LR_balance,R30
_0x12C:
_0x12B:
; 0000 00E9      break;
	RJMP _0x10B
; 0000 00EA      case 7: if (direction==0) {if (FR_balance!=0) {FR_balance--;}} else {if (FR_balance<62) {FR_balance++;}}
_0x128:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x12D
	LD   R30,Y
	CPI  R30,0
	BRNE _0x12E
	LDS  R30,_FR_balance
	CPI  R30,0
	BREQ _0x12F
	SUBI R30,LOW(1)
	STS  _FR_balance,R30
_0x12F:
	RJMP _0x130
_0x12E:
	LDS  R26,_FR_balance
	CPI  R26,LOW(0x3E)
	BRGE _0x131
	LDS  R30,_FR_balance
	SUBI R30,-LOW(1)
	STS  _FR_balance,R30
_0x131:
_0x130:
; 0000 00EB      break;
	RJMP _0x10B
; 0000 00EC      case 8: if (direction==0) {if (isBluetoothEnabled) {BluetoothOFF();}} else {BluetoothON();}
_0x12D:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x132
	LD   R30,Y
	CPI  R30,0
	BRNE _0x133
	LDS  R30,_isBluetoothEnabled
	CPI  R30,0
	BREQ _0x134
	RCALL _BluetoothOFF
_0x134:
	RJMP _0x135
_0x133:
	RCALL _BluetoothON
_0x135:
; 0000 00ED      break;
	RJMP _0x10B
; 0000 00EE      case 9: if (direction==0) {if (brightless>0) {brightless-=5;;}} else {if (brightless<255) {brightless+=5;}}
_0x132:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x136
	LD   R30,Y
	CPI  R30,0
	BRNE _0x137
	LDS  R26,_brightless
	CPI  R26,LOW(0x1)
	BRLO _0x138
	LDS  R30,_brightless
	SUBI R30,LOW(5)
	STS  _brightless,R30
_0x138:
	RJMP _0x139
_0x137:
	LDS  R26,_brightless
	CPI  R26,LOW(0xFF)
	BRSH _0x13A
	LDS  R30,_brightless
	SUBI R30,-LOW(5)
	STS  _brightless,R30
_0x13A:
_0x139:
; 0000 00EF      break;
	RJMP _0x10B
; 0000 00F0      case 10: if (direction==0) {if (opasity>0) {opasity-=10;;}} else {if (opasity<400) {opasity+=10;;}}
_0x136:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x13B
	LD   R30,Y
	CPI  R30,0
	BRNE _0x13C
	LDS  R26,_opasity
	LDS  R27,_opasity+1
	CALL __CPW02
	BRSH _0x13D
	CALL SUBOPT_0x1D
	SBIW R30,10
	CALL SUBOPT_0x24
_0x13D:
	RJMP _0x13E
_0x13C:
	LDS  R26,_opasity
	LDS  R27,_opasity+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRSH _0x13F
	CALL SUBOPT_0x1D
	ADIW R30,10
	CALL SUBOPT_0x24
_0x13F:
_0x13E:
; 0000 00F1      break;
	RJMP _0x10B
; 0000 00F2      case 11: if (direction==0) {if (PlayerMenu!=0) {PlayerMenu--;}} else {if (PlayerMenu!=2) {PlayerMenu++;}}
_0x13B:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x145
	LD   R30,Y
	CPI  R30,0
	BRNE _0x141
	LDS  R30,_PlayerMenu
	CPI  R30,0
	BREQ _0x142
	SUBI R30,LOW(1)
	STS  _PlayerMenu,R30
_0x142:
	RJMP _0x143
_0x141:
	LDS  R26,_PlayerMenu
	CPI  R26,LOW(0x2)
	BREQ _0x144
	LDS  R30,_PlayerMenu
	SUBI R30,-LOW(1)
	STS  _PlayerMenu,R30
_0x144:
_0x143:
; 0000 00F3      break;
	RJMP _0x10B
; 0000 00F4      default: recentMenu=0; if (direction==1) {if (volume<63) {volume++;}} else {if (volume!=0) {volume--;}}
_0x145:
	CLR  R5
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x146
	LDS  R26,_volume
	CPI  R26,LOW(0x3F)
	BRSH _0x147
	LDS  R30,_volume
	SUBI R30,-LOW(1)
	STS  _volume,R30
_0x147:
	RJMP _0x148
_0x146:
	LDS  R30,_volume
	CPI  R30,0
	BREQ _0x149
	SUBI R30,LOW(1)
	STS  _volume,R30
_0x149:
_0x148:
; 0000 00F5      break;
; 0000 00F6 }
_0x10B:
; 0000 00F7 UpdateMenu();
	RCALL _UpdateMenu
; 0000 00F8 }
	JMP  _0x2080002

	.DSEG
_0x118:
	.BYTE 0x6
;
;
;interrupt [USART1_RXC] void usart1_rx_isr(void) {
; 0000 00FB interrupt [31] void usart1_rx_isr(void) {

	.CSEG
_usart1_rx_isr:
	CALL SUBOPT_0x25
; 0000 00FC BlueBuffer[0]=BlueBuffer[1];
	__GETB1MN _BlueBuffer,1
	STS  _BlueBuffer,R30
; 0000 00FD BlueBuffer[1]=BlueBuffer[2];
	__GETB1MN _BlueBuffer,2
	__PUTB1MN _BlueBuffer,1
; 0000 00FE BlueBuffer[2]=BlueBuffer[3];
	__GETB1MN _BlueBuffer,3
	__PUTB1MN _BlueBuffer,2
; 0000 00FF BlueBuffer[3]=BlueBuffer[4];
	__GETB1MN _BlueBuffer,4
	__PUTB1MN _BlueBuffer,3
; 0000 0100 BlueBuffer[4]=UDR1;
	LDS  R30,156
	__PUTB1MN _BlueBuffer,4
; 0000 0101 
; 0000 0102 if (BlueBuffer[0]!=0x0d|BlueBuffer[1]!=0x0a) return;
	LDS  R26,_BlueBuffer
	LDI  R30,LOW(13)
	CALL __NEB12
	MOV  R0,R30
	__GETB2MN _BlueBuffer,1
	LDI  R30,LOW(10)
	CALL __NEB12
	OR   R30,R0
	BREQ _0x14A
	RJMP _0x1C8
; 0000 0103 
; 0000 0104 
; 0000 0105 if (BlueBuffer[2]==0x4d) {
_0x14A:
	__GETB2MN _BlueBuffer,2
	CPI  R26,LOW(0x4D)
	BRNE _0x14B
; 0000 0106   if (BlueBuffer[3]==0x52|BlueBuffer[3]==0x42) {doesPlaying=1;} else
	__GETB2MN _BlueBuffer,3
	LDI  R30,LOW(82)
	CALL __EQB12
	MOV  R0,R30
	__GETB2MN _BlueBuffer,3
	LDI  R30,LOW(66)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x14C
	LDI  R30,LOW(1)
	MOV  R4,R30
	RJMP _0x14D
_0x14C:
; 0000 0107     if (BlueBuffer[3]==0x50|BlueBuffer[3]==0x41) {doesPlaying=0;}
	__GETB2MN _BlueBuffer,3
	LDI  R30,LOW(80)
	CALL __EQB12
	MOV  R0,R30
	__GETB2MN _BlueBuffer,3
	LDI  R30,LOW(65)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x14E
	CLR  R4
; 0000 0108 
; 0000 0109   if (BlueBuffer[3]==0x47) {
_0x14E:
_0x14D:
	__GETB2MN _BlueBuffer,3
	CPI  R26,LOW(0x47)
	BRNE _0x14F
; 0000 010A                             if (BlueBuffer[4]==0x31) doesConected=0; else
	__GETB2MN _BlueBuffer,4
	CPI  R26,LOW(0x31)
	BRNE _0x150
	LDI  R30,LOW(0)
	RJMP _0x1C2
_0x150:
; 0000 010B                             if (BlueBuffer[4]==0x33) doesConected=1;}
	__GETB2MN _BlueBuffer,4
	CPI  R26,LOW(0x33)
	BRNE _0x152
	LDI  R30,LOW(1)
_0x1C2:
	STS  _doesConected,R30
_0x152:
; 0000 010C 
; 0000 010D }
_0x14F:
; 0000 010E 
; 0000 010F 
; 0000 0110 if (BlueBuffer[2]==0x49) {
_0x14B:
	__GETB2MN _BlueBuffer,2
	CPI  R26,LOW(0x49)
	BRNE _0x153
; 0000 0111   if (BlueBuffer[3]==0x56) doesConected=1; else
	__GETB2MN _BlueBuffer,3
	CPI  R26,LOW(0x56)
	BRNE _0x154
	LDI  R30,LOW(1)
	RJMP _0x1C3
_0x154:
; 0000 0112     if (BlueBuffer[3]==0x49) doesConected=0;
	__GETB2MN _BlueBuffer,3
	CPI  R26,LOW(0x49)
	BRNE _0x156
	LDI  R30,LOW(0)
_0x1C3:
	STS  _doesConected,R30
; 0000 0113 }
_0x156:
; 0000 0114 
; 0000 0115 
; 0000 0116 updateBluetoothState(0);
_0x153:
	LDI  R26,LOW(0)
	CALL _updateBluetoothState
; 0000 0117 
; 0000 0118 }
	RJMP _0x1C8
;
;interrupt [USART1_TXC] void usart1_tx_isr(void) {
; 0000 011A interrupt [33] void usart1_tx_isr(void) {
_usart1_tx_isr:
; 0000 011B 
; 0000 011C }
	RETI
;
;//Ext0 interrupt calling, when at least one BUTTON has been pressed//
;interrupt [EXT_INT0] void Button_Pressed(void) {
; 0000 011F interrupt [2] void Button_Pressed(void) {
_Button_Pressed:
	CALL SUBOPT_0x25
; 0000 0120 #asm("sei");
	sei
; 0000 0121 
; 0000 0122 timer=0;
	CALL SUBOPT_0x22
; 0000 0123 sleepTimer=0;
; 0000 0124 
; 0000 0125 delay_ms(20);
	LDI  R26,LOW(20)
	CALL SUBOPT_0x20
; 0000 0126 
; 0000 0127 if (isOFF) return;
	LDS  R30,_isOFF
	CPI  R30,0
	BREQ _0x157
	RJMP _0x1C8
; 0000 0128 
; 0000 0129 
; 0000 012A 
; 0000 012B if (PING&1==1) {if (mayOFF==1) {delay_ms(150); button_1();}}
_0x157:
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BREQ _0x158
	LDS  R26,_mayOFF
	CPI  R26,LOW(0x1)
	BRNE _0x159
	LDI  R26,LOW(150)
	CALL SUBOPT_0x20
	RCALL _button_1
_0x159:
; 0000 012C if ((PING>>1)&1==1) {button_2();}
_0x158:
	LDS  R30,99
	LDI  R31,0
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BREQ _0x15A
	RCALL _button_2
; 0000 012D if (PINC.0==1) {button_3();}
_0x15A:
	SBIC 0x13,0
	RCALL _button_3
; 0000 012E if (PINC.1==1) {button_4();}
	SBIC 0x13,1
	RCALL _button_4
; 0000 012F if (PINC.2==1) {button_5();}
	SBIC 0x13,2
	RCALL _button_5
; 0000 0130 if (PINC.3==1) {button_6();}
	SBIC 0x13,3
	RCALL _button_6
; 0000 0131 if (PINC.4==1) {button_7();}
	SBIC 0x13,4
	RCALL _button_7
; 0000 0132 if (PINC.5==1) {button_8();}
	SBIC 0x13,5
	RCALL _button_8
; 0000 0133 if (PINC.6==1) {button_9();}
	SBIC 0x13,6
	RCALL _button_9
; 0000 0134 }
	RJMP _0x1C8
;
;//Encoder Button
;interrupt [EXT_INT1] void EncoderButton_Pressed(void) {delay_ms(20); if (PIND.1==1) return; else while (PIND.1==0) {}
; 0000 0137 interrupt [3] void EncoderButton_Pressed(void) {delay_ms(20); if (PIND.1==1) return; else while (PIND.1==0) {}
_EncoderButton_Pressed:
	CALL SUBOPT_0x25
	LDI  R26,LOW(20)
	CALL SUBOPT_0x20
	SBIC 0x10,1
	RJMP _0x1C8
_0x164:
	SBIS 0x10,1
	RJMP _0x164
; 0000 0138 if (isOFF) return;
	LDS  R30,_isOFF
	CPI  R30,0
	BREQ _0x167
	RJMP _0x1C8
; 0000 0139 
; 0000 013A if (recentMenu==11) {switch (PlayerMenu) {
_0x167:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x168
	CALL SUBOPT_0x1
; 0000 013B case 0: SendToBluetooth ("ME"); break;
	BRNE _0x16C
	__POINTW2MN _0x16D,0
	RJMP _0x1C4
; 0000 013C case 1: SendToBluetooth ("MA"); if (doesPlaying==1) doesPlaying=0; else doesPlaying=1; break;
_0x16C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16E
	__POINTW2MN _0x16D,3
	RCALL _SendToBluetooth
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x16F
	CLR  R4
	RJMP _0x170
_0x16F:
	LDI  R30,LOW(1)
	MOV  R4,R30
_0x170:
	RJMP _0x16B
; 0000 013D case 2: SendToBluetooth ("MD"); break;
_0x16E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x16B
	__POINTW2MN _0x16D,6
_0x1C4:
	RCALL _SendToBluetooth
; 0000 013E } timer=0; sleepTimer=0;}
_0x16B:
	CALL SUBOPT_0x22
; 0000 013F else {recentMenu=volumeMenu;}
	RJMP _0x172
_0x168:
	CLR  R5
_0x172:
; 0000 0140 
; 0000 0141 
; 0000 0142 if (recentMenu!=11|recentMenu!=0)
	MOV  R26,R5
	LDI  R30,LOW(11)
	CALL __NEB12
	MOV  R0,R30
	LDI  R30,LOW(0)
	CALL __NEB12
	OR   R30,R0
	BREQ _0x173
; 0000 0143 {UpdateMenu();} else
	RCALL _UpdateMenu
	RJMP _0x174
_0x173:
; 0000 0144 updateBluetoothState(0);
	LDI  R26,LOW(0)
	CALL _updateBluetoothState
; 0000 0145 
; 0000 0146 }
_0x174:
	RJMP _0x1C8

	.DSEG
_0x16D:
	.BYTE 0x9
;
;//Bluetooth Mute (0 - enable, 1 - disable)
;interrupt [EXT_INT4] void Bluetooth_Mute(void) {
; 0000 0149 interrupt [6] void Bluetooth_Mute(void) {

	.CSEG
_Bluetooth_Mute:
	CALL SUBOPT_0x25
; 0000 014A 
; 0000 014B 
; 0000 014C 
; 0000 014D               if (PINE.4==1) {
	SBIS 0x1,4
	RJMP _0x175
; 0000 014E               doesPlaying=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 014F               i2c_start();
	CALL SUBOPT_0xC
; 0000 0150 		      i2c_write(0b10001000);
; 0000 0151               i2c_write(63-volume);
	LDS  R26,_volume
	LDI  R30,LOW(63)
	SUB  R30,R26
	MOV  R26,R30
	RJMP _0x1C5
; 0000 0152 		      i2c_stop();
; 0000 0153               } else {
_0x175:
; 0000 0154               doesPlaying=0;
	CLR  R4
; 0000 0155               i2c_start();
	CALL SUBOPT_0xC
; 0000 0156 		      i2c_write(0b10001000);
; 0000 0157               if (input==1&isBluetoothEnabled) i2c_write(63);
	CALL SUBOPT_0xD
	BREQ _0x177
	LDI  R26,LOW(63)
_0x1C5:
	CALL _i2c_write
; 0000 0158 		      i2c_stop();
_0x177:
	CALL _i2c_stop
; 0000 0159               }
; 0000 015A 
; 0000 015B               if (recentMenu==0|recentMenu==11)
	MOV  R26,R5
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(11)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x178
; 0000 015C               if (input==1&doesConected==1)
	CALL SUBOPT_0x23
	LDS  R26,_doesConected
	CALL SUBOPT_0x7
	BREQ _0x179
; 0000 015D               if (isBluetoothEnabled)
	LDS  R30,_isBluetoothEnabled
	CPI  R30,0
	BREQ _0x17A
; 0000 015E               updateBluetoothState(0);
	LDI  R26,LOW(0)
	CALL _updateBluetoothState
; 0000 015F 
; 0000 0160 }
_0x17A:
_0x179:
_0x178:
	RJMP _0x1C8
;
;
;int doesReceiving=0;
;int recentBitLenght;
;
;//Ext1 interrupt calling, when IR signal has been detected//
;interrupt [EXT_INT6] void TSOP(void) {
; 0000 0167 interrupt [8] void TSOP(void) {
_TSOP:
; 0000 0168 /*
; 0000 0169 sleepTimer=0;
; 0000 016A 
; 0000 016B if (PINE.6==1) {
; 0000 016C 
; 0000 016D if (!doesReceiving) return;
; 0000 016E 
; 0000 016F TCCR2=0;
; 0000 0170 recentBitLenght=TCNT2;
; 0000 0171 TCNT2=0;
; 0000 0172 sprintf(buffer, "Bit: %d ", recentBitLenght);
; 0000 0173 lcd_clear();
; 0000 0174 lcd_puts(buffer);
; 0000 0175 
; 0000 0176 doesReceiving=0;
; 0000 0177 
; 0000 0178 LED(2);
; 0000 0179 
; 0000 017A } else {
; 0000 017B doesReceiving=1;
; 0000 017C TCNT2=0;
; 0000 017D TCCR2=5;
; 0000 017E TIMSK=0x40;
; 0000 017F LED(6);
; 0000 0180 }
; 0000 0181 
; 0000 0182 
; 0000 0183 */
; 0000 0184 }
	RETI
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0187 {
_timer2_ovf_isr:
	CALL SUBOPT_0x25
; 0000 0188 lcd_clear();
	CALL _lcd_clear
; 0000 0189 lcd_puts("Overflow");
	__POINTW2MN _0x17B,0
	CALL _lcd_puts
; 0000 018A recentBitLenght=doesReceiving=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _doesReceiving,R30
	STS  _doesReceiving+1,R31
	STS  _recentBitLenght,R30
	STS  _recentBitLenght+1,R31
; 0000 018B }
	RJMP _0x1C8

	.DSEG
_0x17B:
	.BYTE 0x9
;
;//Called 140 times per second
;interrupt [TIM3_COMPA] void tim3_compa (void) {
; 0000 018E interrupt [27] void tim3_compa (void) {

	.CSEG
_tim3_compa:
	CALL SUBOPT_0x25
; 0000 018F     unsigned int enc;
; 0000 0190 
; 0000 0191       if (bluetoothAskStateTimer<100) bluetoothAskStateTimer++; else {bluetoothAskStateTimer=0; SendToBluetooth("CY");}
	ST   -Y,R17
	ST   -Y,R16
;	enc -> R16,R17
	LDS  R26,_bluetoothAskStateTimer
	LDS  R27,_bluetoothAskStateTimer+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRSH _0x17C
	LDI  R26,LOW(_bluetoothAskStateTimer)
	LDI  R27,HIGH(_bluetoothAskStateTimer)
	CALL SUBOPT_0x26
	RJMP _0x17D
_0x17C:
	LDI  R30,LOW(0)
	STS  _bluetoothAskStateTimer,R30
	STS  _bluetoothAskStateTimer+1,R30
	__POINTW2MN _0x17E,0
	RCALL _SendToBluetooth
_0x17D:
; 0000 0192 
; 0000 0193 
; 0000 0194       if (isBluetoothEnabled==1) {
	LDS  R26,_isBluetoothEnabled
	CPI  R26,LOW(0x1)
	BRNE _0x17F
; 0000 0195       bluetoothResetTimer++;
	LDI  R26,LOW(_bluetoothResetTimer)
	LDI  R27,HIGH(_bluetoothResetTimer)
	CALL SUBOPT_0x26
; 0000 0196       if (bluetoothResetTimer>bluetoothResetTime)
	LDS  R26,_bluetoothResetTimer
	LDS  R27,_bluetoothResetTimer+1
	CP   R8,R26
	CPC  R9,R27
	BRSH _0x180
; 0000 0197       BluetoothReset();
	RCALL _BluetoothReset
; 0000 0198       }
_0x180:
; 0000 0199 
; 0000 019A 
; 0000 019B     enc=PIND; enc>>=4; enc&=0b00000011;
_0x17F:
	IN   R16,16
	CLR  R17
	MOVW R30,R16
	CALL __LSRW4
	MOVW R16,R30
	__ANDWRN 16,17,3
; 0000 019C 	if (enc!=encwas) {
	LDS  R30,_encwas
	LDS  R31,_encwas+1
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x181
; 0000 019D 		if (encwas==3) {
	LDS  R26,_encwas
	LDS  R27,_encwas+1
	SBIW R26,3
	BRNE _0x182
; 0000 019E 			if (enc==1)  {ValueChanged(0);}
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x183
	LDI  R26,LOW(0)
	RCALL _ValueChanged
; 0000 019F 			if (enc==2)  {ValueChanged(1);}
_0x183:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x184
	LDI  R26,LOW(1)
	RCALL _ValueChanged
; 0000 01A0 			UpdateMenu();
_0x184:
	RCALL _UpdateMenu
; 0000 01A1 		}
; 0000 01A2 		encwas=enc;
_0x182:
	__PUTWMRN _encwas,0,16,17
; 0000 01A3     }
; 0000 01A4 
; 0000 01A5     if (recentMenu!=0) {
_0x181:
	TST  R5
	BREQ _0x185
; 0000 01A6       timer++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 01A7       if (recentMenu!=11) {
	LDI  R30,LOW(11)
	CP   R30,R5
	BREQ _0x186
; 0000 01A8       if (timer>700) {
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x187
; 0000 01A9       timer=0;
	CLR  R10
	CLR  R11
; 0000 01AA       recentMenu=0;
	CLR  R5
; 0000 01AB       UpdateMenu();
	RCALL _UpdateMenu
; 0000 01AC       }}
_0x187:
; 0000 01AD       else
	RJMP _0x188
_0x186:
; 0000 01AE       {if (timer>1400) {
	LDI  R30,LOW(1400)
	LDI  R31,HIGH(1400)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x189
; 0000 01AF       timer=0;
	CLR  R10
	CLR  R11
; 0000 01B0       recentMenu=0;
	CLR  R5
; 0000 01B1       UpdateMenu();}
	RCALL _UpdateMenu
; 0000 01B2       }
_0x189:
_0x188:
; 0000 01B3       }
; 0000 01B4 
; 0000 01B5 
; 0000 01B6       if (sleepTimer<sleepTime) {
_0x185:
	__CPWRR 12,13,6,7
	BRSH _0x18A
; 0000 01B7       sleepTimer++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 01B8 
; 0000 01B9       if (OCR0!=brightless)
	IN   R30,0x31
	MOV  R26,R30
	LDS  R30,_brightless
	CP   R30,R26
	BREQ _0x18B
; 0000 01BA       for (k=OCR0; k<=brightless; k++) {
	IN   R30,0x31
	STS  _k,R30
_0x18D:
	LDS  R30,_brightless
	LDS  R26,_k
	CP   R30,R26
	BRLO _0x18E
; 0000 01BB       OCR0=k;
	CALL SUBOPT_0x27
; 0000 01BC       delay_ms(2);
; 0000 01BD       }
	LDS  R30,_k
	SUBI R30,-LOW(1)
	STS  _k,R30
	RJMP _0x18D
_0x18E:
; 0000 01BE 
; 0000 01BF       } else if (brightless>sleepBrightless) {
_0x18B:
	RJMP _0x18F
_0x18A:
	LDS  R30,_sleepBrightless
	LDS  R26,_brightless
	CP   R30,R26
	BRSH _0x190
; 0000 01C0       for (k=OCR0; k>sleepBrightless; k--) {
	IN   R30,0x31
	STS  _k,R30
_0x192:
	LDS  R30,_sleepBrightless
	LDS  R26,_k
	CP   R30,R26
	BRSH _0x193
; 0000 01C1       OCR0=k;
	CALL SUBOPT_0x27
; 0000 01C2       delay_ms(2);
; 0000 01C3       }
	LDS  R30,_k
	SUBI R30,LOW(1)
	STS  _k,R30
	RJMP _0x192
_0x193:
; 0000 01C4 
; 0000 01C5       }
; 0000 01C6 
; 0000 01C7 
; 0000 01C8   }
_0x190:
_0x18F:
	LD   R16,Y+
	LD   R17,Y+
_0x1C8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI

	.DSEG
_0x17E:
	.BYTE 0x3
;
;void main(void) {
; 0000 01CA void main(void) {

	.CSEG
_main:
; 0000 01CB 
; 0000 01CC DDRA =0b00011111; DDRB =0b11111111; DDRD =0b00000000; DDRE= 0b00001110; DDRF= 0b00101010; DDRG =0b00001000; DDRC =0b10000000;
	LDI  R30,LOW(31)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
	LDI  R30,LOW(0)
	OUT  0x11,R30
	LDI  R30,LOW(14)
	OUT  0x2,R30
	LDI  R30,LOW(42)
	STS  97,R30
	LDI  R30,LOW(8)
	STS  100,R30
	LDI  R30,LOW(128)
	OUT  0x14,R30
; 0000 01CD PORTA=0b00011010; PORTB=0b00000000; PORTD=0b11110010; PORTE=0b01000000; PORTF=0b00001000; PORTG=0b00000011; PORTC=0b11111111;
	LDI  R30,LOW(26)
	OUT  0x1B,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(242)
	OUT  0x12,R30
	LDI  R30,LOW(64)
	OUT  0x3,R30
	LDI  R30,LOW(8)
	STS  98,R30
	LDI  R30,LOW(3)
	STS  101,R30
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 01CE 
; 0000 01CF TCCR1A=0b10000010;
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 01D0 TCCR1B=0b00000001;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 01D1 ICR1=480;
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 01D2 OCR1A=480;
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01D3 
; 0000 01D4 TCCR3A=0b00000000;
	LDI  R30,LOW(0)
	STS  139,R30
; 0000 01D5 TCCR3B=0b00000001;
	LDI  R30,LOW(1)
	STS  138,R30
; 0000 01D6 ETIMSK=0b00010000;
	LDI  R30,LOW(16)
	STS  125,R30
; 0000 01D7 OCR3AH=0b00001110;
	LDI  R30,LOW(14)
	STS  135,R30
; 0000 01D8 OCR3AL=0b10100000;
	LDI  R30,LOW(160)
	STS  134,R30
; 0000 01D9 
; 0000 01DA UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 01DB UCSR1B=0b11011000;       // Uart init:
	LDI  R30,LOW(216)
	STS  154,R30
; 0000 01DC UCSR1C=0b00000110;       // 9600 bouds / 8 data Bit / 1 Stop Bit / No parity
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 01DD UBRR1H=0x00;             // Interrupts RXC and TXC are enabled
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 01DE UBRR1L=0x08;
	LDI  R30,LOW(8)
	STS  153,R30
; 0000 01DF 
; 0000 01E0 EICRA=0b00001011;           // Interrupts setup:
	LDI  R30,LOW(11)
	STS  106,R30
; 0000 01E1 EICRB=0b00010001;           // INT0 - Rising edge interrupt (Buttons); INT1 - falling edge interrupt (ENC BUTTON);
	LDI  R30,LOW(17)
	OUT  0x3A,R30
; 0000 01E2 EIMSK=0b01010011;           // INT2 & INT3  - UART (unused ints); INT4 - Any change, BLUETOOTH MUTE; INT6 - Falling edge, TSOP;
	LDI  R30,LOW(83)
	OUT  0x39,R30
; 0000 01E3 
; 0000 01E4 
; 0000 01E5 if (doesEEpromWritten==1)
	LDI  R26,LOW(_doesEEpromWritten)
	LDI  R27,HIGH(_doesEEpromWritten)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x194
; 0000 01E6 isBluetoothEnabled=settings[11];
	__POINTW2MN _settings,22
	CALL __EEPROMRDB
	RJMP _0x1C6
; 0000 01E7 else
_0x194:
; 0000 01E8 isBluetoothEnabled=1;
	LDI  R30,LOW(1)
_0x1C6:
	STS  _isBluetoothEnabled,R30
; 0000 01E9 
; 0000 01EA 
; 0000 01EB 
; 0000 01EC if (!isBluetoothEnabled)
	CPI  R30,0
	BRNE _0x196
; 0000 01ED BluetoothOFF(); else bluetoothResetTimer=bluetoothResetTime-1000;
	RCALL _BluetoothOFF
	RJMP _0x197
_0x196:
	CALL SUBOPT_0x8
; 0000 01EE 
; 0000 01EF 
; 0000 01F0 #asm("sei");
_0x197:
	sei
; 0000 01F1 
; 0000 01F2 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 01F3 lcd_clear();
	CALL _lcd_clear
; 0000 01F4 
; 0000 01F5 //Writing New Symbols into LCD
; 0000 01F6 {
; 0000 01F7 define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _define_char
; 0000 01F8 define_char(char1,1);
	LDI  R30,LOW(_char1*2)
	LDI  R31,HIGH(_char1*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _define_char
; 0000 01F9 define_char(char2,2);
	LDI  R30,LOW(_char2*2)
	LDI  R31,HIGH(_char2*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _define_char
; 0000 01FA define_char(char3,3);
	LDI  R30,LOW(_char3*2)
	LDI  R31,HIGH(_char3*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _define_char
; 0000 01FB define_char(char4,4);
	LDI  R30,LOW(_char4*2)
	LDI  R31,HIGH(_char4*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL _define_char
; 0000 01FC define_char(char5,5);
	LDI  R30,LOW(_char5*2)
	LDI  R31,HIGH(_char5*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	CALL _define_char
; 0000 01FD define_char(char6,6);
	LDI  R30,LOW(_char6*2)
	LDI  R31,HIGH(_char6*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	CALL _define_char
; 0000 01FE }
; 0000 01FF 
; 0000 0200 
; 0000 0201 
; 0000 0202 while ((PING&1)==0) {if (doesConected) {settings[7]=1; goto start;}}
_0x198:
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BRNE _0x19A
	LDS  R30,_doesConected
	CPI  R30,0
	BREQ _0x19B
	__POINTW2MN _settings,14
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EEPROMWRW
	RJMP _0x19C
_0x19B:
	RJMP _0x198
_0x19A:
; 0000 0203 bluetoothResetTimer=bluetoothResetTime-1000;
	CALL SUBOPT_0x8
; 0000 0204 start:
_0x19C:
; 0000 0205 bluetoothResetTimer=0;
	LDI  R30,LOW(0)
	STS  _bluetoothResetTimer,R30
	STS  _bluetoothResetTimer+1,R30
; 0000 0206 
; 0000 0207 
; 0000 0208 isOFF=0;
	STS  _isOFF,R30
; 0000 0209 
; 0000 020A TCCR0=0b01101001;
	LDI  R30,LOW(105)
	OUT  0x33,R30
; 0000 020B 
; 0000 020C LED(2);
	LDI  R26,LOW(2)
	RCALL _LED
; 0000 020D PORTA|=1;
	SBI  0x1B,0
; 0000 020E 
; 0000 020F delay_ms(50);
	LDI  R26,LOW(50)
	CALL SUBOPT_0x20
; 0000 0210 i2c_init();//Test
	CALL _i2c_init
; 0000 0211 i2c_start();
	CALL _i2c_start
; 0000 0212 i2c_stop();
	CALL _i2c_stop
; 0000 0213 
; 0000 0214 
; 0000 0215 //Testing audioproccesor
; 0000 0216 if (i2c_start()==1) {
	CALL _i2c_start
	CPI  R30,LOW(0x1)
	BRNE _0x19D
; 0000 0217     if (i2c_write(0b10001000)==1) {}
	LDI  R26,LOW(136)
	CALL _i2c_write
	CPI  R30,LOW(0x1)
	BREQ _0x19F
; 0000 0218     else {
; 0000 0219     lcd_clear();
	RCALL _lcd_clear
; 0000 021A     lcd_puts("Audio processor");
	__POINTW2MN _0x1A0,0
	RCALL _lcd_puts
; 0000 021B     lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 021C     lcd_puts("Error: adress");
	__POINTW2MN _0x1A0,16
	RCALL _lcd_puts
; 0000 021D     i2c_stop();
	CALL _i2c_stop
; 0000 021E     #asm("cli");
	cli
; 0000 021F     while (1) {PORTF=0b00000100; delay_ms(1000); PORTF=0x00; delay_ms(1000);}}
_0x1A1:
	CALL SUBOPT_0x28
	RJMP _0x1A1
_0x19F:
; 0000 0220     }
; 0000 0221 
; 0000 0222 else {
	RJMP _0x1A4
_0x19D:
; 0000 0223 lcd_clear();
	RCALL _lcd_clear
; 0000 0224 lcd_puts("Audio processor");
	__POINTW2MN _0x1A0,30
	CALL SUBOPT_0x0
; 0000 0225 lcd_gotoxy(0,1);
; 0000 0226 lcd_puts("Error with bus");
	__POINTW2MN _0x1A0,46
	RCALL _lcd_puts
; 0000 0227 i2c_stop();
	CALL _i2c_stop
; 0000 0228 while (1) {PORTF=0b00000100; delay_ms(1000); PORTF=0x00; delay_ms(1000);}
_0x1A5:
	CALL SUBOPT_0x28
	RJMP _0x1A5
; 0000 0229 }
_0x1A4:
; 0000 022A 
; 0000 022B 
; 0000 022C 
; 0000 022D 
; 0000 022E //Writing default settings;
; 0000 022F 
; 0000 0230     if (doesEEpromWritten!=1) {
	LDI  R26,LOW(_doesEEpromWritten)
	LDI  R27,HIGH(_doesEEpromWritten)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x1A8
; 0000 0231     volume=10;
	LDI  R30,LOW(10)
	STS  _volume,R30
; 0000 0232 	bass=10;
	STS  _bass,R30
; 0000 0233 	treble=13;
	LDI  R30,LOW(13)
	STS  _treble,R30
; 0000 0234 	gain=0b00011000;
	LDI  R30,LOW(24)
	STS  _gain,R30
; 0000 0235 	loudness=0;
	LDI  R30,LOW(0)
	STS  _loudness,R30
; 0000 0236     LR_balance=31;
	LDI  R30,LOW(31)
	STS  _LR_balance,R30
; 0000 0237     FR_balance=31;
	STS  _FR_balance,R30
; 0000 0238     input=1;
	LDI  R30,LOW(1)
	STS  _input,R30
; 0000 0239     brightless=125;
	LDI  R30,LOW(125)
	STS  _brightless,R30
; 0000 023A     opasity=220;
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x24
; 0000 023B     isBluetoothEnabled=0;
	LDI  R30,LOW(0)
	RJMP _0x1C7
; 0000 023C     } else {
_0x1A8:
; 0000 023D     volume=settings[0];
	LDI  R26,LOW(_settings)
	LDI  R27,HIGH(_settings)
	CALL __EEPROMRDB
	STS  _volume,R30
; 0000 023E 	bass=settings[1];
	__POINTW2MN _settings,2
	CALL __EEPROMRDB
	STS  _bass,R30
; 0000 023F 	treble=settings[2];
	__POINTW2MN _settings,4
	CALL __EEPROMRDB
	STS  _treble,R30
; 0000 0240 	gain=settings[3];
	__POINTW2MN _settings,6
	CALL __EEPROMRDB
	STS  _gain,R30
; 0000 0241 	loudness=settings[4];
	__POINTW2MN _settings,8
	CALL __EEPROMRDB
	STS  _loudness,R30
; 0000 0242     LR_balance=settings[5];
	__POINTW2MN _settings,10
	CALL __EEPROMRDB
	STS  _LR_balance,R30
; 0000 0243     FR_balance=settings[6];
	__POINTW2MN _settings,12
	CALL __EEPROMRDB
	STS  _FR_balance,R30
; 0000 0244     input=settings[7];
	__POINTW2MN _settings,14
	CALL __EEPROMRDB
	STS  _input,R30
; 0000 0245     brightless=settings[8];
	__POINTW2MN _settings,16
	CALL __EEPROMRDB
	STS  _brightless,R30
; 0000 0246     opasity=settings[9];
	__POINTW2MN _settings,18
	CALL __EEPROMRDW
	CALL SUBOPT_0x24
; 0000 0247     doesPlaying=settings[10];
	__POINTW2MN _settings,20
	CALL __EEPROMRDB
	MOV  R4,R30
; 0000 0248     isBluetoothEnabled=settings[11];
	__POINTW2MN _settings,22
	CALL __EEPROMRDB
_0x1C7:
	STS  _isBluetoothEnabled,R30
; 0000 0249     }
; 0000 024A 
; 0000 024B 
; 0000 024C for (recentMenu=0; recentMenu<12; recentMenu++) {
	CLR  R5
_0x1AB:
	LDI  R30,LOW(12)
	CP   R5,R30
	BRSH _0x1AC
; 0000 024D UpdateMenu();
	CALL _UpdateMenu
; 0000 024E }
	INC  R5
	RJMP _0x1AB
_0x1AC:
; 0000 024F 
; 0000 0250 lcd_clear();
	RCALL _lcd_clear
; 0000 0251 lcd_puts("     NewAmp");
	__POINTW2MN _0x1A0,61
	CALL SUBOPT_0x0
; 0000 0252 lcd_gotoxy(0,1);
; 0000 0253 lcd_puts("  Firmware 3.1");
	__POINTW2MN _0x1A0,73
	CALL SUBOPT_0x29
; 0000 0254 delay_ms(1000);
; 0000 0255 lcd_clear();
	RCALL _lcd_clear
; 0000 0256 lcd_puts("  Leskiv");
	__POINTW2MN _0x1A0,88
	CALL SUBOPT_0x0
; 0000 0257 lcd_gotoxy(0,1);
; 0000 0258 lcd_puts("    Production");
	__POINTW2MN _0x1A0,97
	CALL SUBOPT_0x29
; 0000 0259 delay_ms(1000);
; 0000 025A 
; 0000 025B 
; 0000 025C 
; 0000 025D 
; 0000 025E recentMenu=0;
	CLR  R5
; 0000 025F UpdateMenu();
	CALL _UpdateMenu
; 0000 0260 
; 0000 0261 
; 0000 0262 mayOFF=1;
	LDI  R30,LOW(1)
	STS  _mayOFF,R30
; 0000 0263 
; 0000 0264 
; 0000 0265 while(1) {}
_0x1AD:
	RJMP _0x1AD
; 0000 0266 
; 0000 0267   /*
; 0000 0268 m1:
; 0000 0269 while (1) {
; 0000 026A       if (bluetoothResetTimer<49000) goto m1;
; 0000 026B       bluetoothResetTimer=0;
; 0000 026C 
; 0000 026D       if (doesConected) {
; 0000 026E       lastConectedState=50;
; 0000 026F       lastPlayingState=50;
; 0000 0270       } else {
; 0000 0271 
; 0000 0272          BluetoothOFF();
; 0000 0273          delay_ms(10000);
; 0000 0274          BluetoothON();
; 0000 0275 
; 0000 0276       }
; 0000 0277 }
; 0000 0278   */
; 0000 0279 
; 0000 027A }
_0x1B0:
	RJMP _0x1B0

	.DSEG
_0x1A0:
	.BYTE 0x70
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x3,2
	RJMP _0x2000005
_0x2000004:
	CBI  0x3,2
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x3,1
	RJMP _0x2000007
_0x2000006:
	CBI  0x3,1
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x18,7
	RJMP _0x2000009
_0x2000008:
	CBI  0x18,7
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	LDS  R30,101
	ORI  R30,8
	RJMP _0x200001D
_0x200000A:
	LDS  R30,101
	ANDI R30,0XF7
_0x200001D:
	STS  101,R30
	__DELAY_USB 11
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	RJMP _0x2080002
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2080002
_lcd_write_byte:
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080003
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	CALL SUBOPT_0x20
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	CALL SUBOPT_0x20
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080002
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080002
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	SBI  0x2,2
	SBI  0x2,1
	SBI  0x17,7
	LDS  R30,100
	ORI  R30,8
	STS  100,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x2,3
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x3,3
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	CALL SUBOPT_0x20
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x26
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x26
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G101:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x2B
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x2B
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x2C
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2D
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2F
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2F
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x2B
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2D
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x30
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x30
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_bluetoothResetTimer:
	.BYTE 0x2
_bluetoothAskStateTimer:
	.BYTE 0x2
_BlueBuffer:
	.BYTE 0xA
_doesConected:
	.BYTE 0x1
_lastConectedState:
	.BYTE 0x1
_lastPlayingState:
	.BYTE 0x1
_volume:
	.BYTE 0x1
_treble:
	.BYTE 0x1
_bass:
	.BYTE 0x1
_input:
	.BYTE 0x1
_gain:
	.BYTE 0x1
_loudness:
	.BYTE 0x1
_brightless:
	.BYTE 0x1
_isBluetoothEnabled:
	.BYTE 0x1
_PlayerMenu:
	.BYTE 0x1
_LR_balance:
	.BYTE 0x1
_FR_balance:
	.BYTE 0x1
_opasity:
	.BYTE 0x2
_mayOFF:
	.BYTE 0x1
_isOFF:
	.BYTE 0x1
_encwas:
	.BYTE 0x2
_buffer:
	.BYTE 0x20
_k:
	.BYTE 0x1
_sleepBrightless:
	.BYTE 0x1
_wasPlayingBeforeSwitch:
	.BYTE 0x1

	.ESEG
_doesEEpromWritten:
	.BYTE 0x1
_settings:
	.BYTE 0x18

	.DSEG
_doesReceiving:
	.BYTE 0x2
_recentBitLenght:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x0:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_PlayerMenu
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	CALL _lcd_puts
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R30,LOW(1)
	CP   R30,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(255)
	CALL _lcd_putchar
	LDI  R26,LOW(255)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	MOVW R30,R8
	SUBI R30,LOW(1000)
	SBCI R31,HIGH(1000)
	STS  _bluetoothResetTimer,R30
	STS  _bluetoothResetTimer+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC:
	CALL _i2c_start
	LDI  R26,LOW(136)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDS  R26,_input
	LDI  R30,LOW(1)
	CALL __EQB12
	LDS  R26,_isBluetoothEnabled
	AND  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CALL __CBD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	ST   -Y,R17
	MOV  R26,R16
	CALL _ShowScaleBalance
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	MOV  R26,R17
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x12:
	LDI  R17,LOW(64)
	LDS  R30,_input
	OR   R17,R30
	LDS  R30,_gain
	OR   R17,R30
	LDS  R30,_loudness
	OR   R17,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R30,_gain
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	SBIW R28,1
	LDI  R30,LOW(16)
	ST   Y,R30
	CALL __SAVELOCR6
	LDS  R17,_LR_balance
	LDS  R16,_FR_balance
	CPI  R17,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	CALL _lcd_clear
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x16:
	CALL __CBD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(58)
	CALL _lcd_putchar
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__POINTW1FN _0x0,99
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	CALL _lcd_puts
	LDD  R30,Y+6
	SUBI R30,LOW(1)
	STD  Y+6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1A:
	__POINTW1FN _0x0,387
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x1F
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	LDI  R30,LOW(8)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL _lcd_puts
	LDI  R30,LOW(12)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	__GETD1N 0x1F
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDS  R30,_opasity
	LDS  R31,_opasity+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1E:
	CBI  0x1B,1
	LDI  R30,LOW(0)
	STS  155,R30
	STS  154,R30
	STS  157,R30
	STS  152,R30
	STS  153,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1F:
	SBI  0x1B,1
	LDI  R30,LOW(0)
	STS  155,R30
	LDI  R30,LOW(216)
	STS  154,R30
	LDI  R30,LOW(6)
	STS  157,R30
	LDI  R30,LOW(0)
	STS  152,R30
	LDI  R30,LOW(8)
	STS  153,R30
	LDI  R30,LOW(0)
	STS  _bluetoothResetTimer,R30
	STS  _bluetoothResetTimer+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x20:
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x21:
	LDI  R31,0
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CLR  R10
	CLR  R11
	CLR  R12
	CLR  R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDS  R26,_input
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	STS  _opasity,R30
	STS  _opasity+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x25:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDS  R30,_k
	OUT  0x31,R30
	LDI  R26,LOW(2)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(4)
	STS  98,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  98,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2B:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
	.equ __sda_bit=7
	.equ __scl_bit=6
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,107
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,213
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
