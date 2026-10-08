;------------------------------------------------------------------------------
;			'AGONY' Introduction "Film-Type" Music
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
;  « AMIGA AUDIO DRIVER by Jeroen G. Tel / Copyright 1991 The Sonic Circle »
;
;	Spreading, selling, copying, replicating, etc. is STRICTLY PROHIBITED
;	without written permission from Jeroen G. Tel / The Sonic Circle! 
;------------------------------------------------------------------------------

;SEQ:	$ff,$xx = Sequence repeat at position xx
;	$80-$fe	= Step total Tone-transpose
;	$7x	= Soundeffect-transpose with x
;	$6x	= repeat following step x times (0 = 1 time / f = 16 times)
;	$00-$5f = Play Step
;
;STEP:	$ff	= Step end (jump back to SEQ)
;	$fe	= Step end and stop channel
;	$fd,$xy	= Glide-set, x = speed / y = delay (NoteLenghts) 
;	$fc,$xx	= Volume-set, Volume
;	$fb	= NoteLink (The Note after this will be linked with last one)
;	$f1-$fa	= Pause with NoteLenght $01-$0a
;	$c0-$ef	= Soundeffect $00-$2f
;	$81-$bf	= NoteLenght $01-$3f
;	$6x	= Play Arpeggio x
;	$00-$5f = RealNote $00-$5f  
;
;SFX:	AA,Bb	= AA:Volume,		B :Vibrato-Depth b:Vibrato-Speed
;	CC,DD	= CC:Vibrato Delay	DD:b7 = Filter , b6 = Arpeggio
;	EE,FF	= EE:Fine Detune	FF:Release Speed
;	GG,HH	= GG:Release Delay	HH:Samples-Number
;
;ARP:	$ff,$xx = Repeat Arpeggio-tabel at position xx	
;	$fe	= End Arpeggio-tabel and keep last note running
;	$00-$fd	= Note-transpose
;------------------------------------------------------------------------------

Custom		equ	$dff000	

Adkcon	equ	$09e
Adkconr	equ	$010

Aud0lc	equ	$0a0
Aud0len	equ	$0a4
Aud0per	equ	$0a6
Aud0vol	equ	$0a8
Aud0dat	equ	$0aa

Dmacon	equ	$096
Dmaconr	equ	$002

Vhposr	equ	$006

Color	equ	$180

Potgo	equ	$034
Potgor	equ	$016

;..............................AUDIO-DRIVER-VARIABLES........................

SequInd	equ	$00
StepInd	equ	$04
FrqWord	equ	$08
ArpIndx	equ	$0c	

FadeWrd	equ	$10
FadeCnt	equ	$12
RealSmp	equ	$14
SequNum	equ	$16
StepNum	equ	$18
RealSnd	equ	$1a
SpdCoun	equ	$1c
SpdTest	equ	$1e
VibDlay	equ	$20	
GldDlay	equ	$22
MainVol	equ	$24
VoicVol	equ	$26
RealVol	equ	$28
RLDelay	equ	$2a
RLCount	equ	$2c

VibDep	equ	$2e
VibSpd	equ	$2f
VibDir	equ	$30
GldSpd	equ	$31
DestNot	equ	$32
ArpNumb	equ	$33
SfxByte	equ	$34
RepStep	equ	$35
SfxTran	equ	$36
RealLen	equ	$37
LenCopy	equ	$38
RealNot	equ	$39
TranByt	equ	$3a
VoicSts	equ	$3b
VoicTst	equ	$3c
AttTest	equ	$3d
NotLink equ	$3e

LabelEx	equ	$40	;Always dividable by $0004!

	SECTION	Main,Code_C

	movem.l	d0-d7/a0-a6,-(a7)

	lea	Custom,a5
;....................................................................
; IFF-Sample-Header-Cruncher (sets samples in one block!)

	lea	SmpStrt(PC),a0
	lea	SmpStrt(PC),a1
	lea	SampTab(PC),a2

	move.b	#$0c,Potgo(a5)

FormCmp	move.l	(a0)+,d0
	cmpi.l	#"EXIT",d0
	beq.b	StrInit

FormSet	move.l	(a0)+,d0
	move.l	(a0)+,d0
	move.l	(a0)+,d0
	move.l	(a0)+,-(a7)
	move.l	(a0),d0
	
	move.l	a1,(a2)+	;Set start address

	tst.l	$0004(a0)
	bne.b	RepSamp
	sub.l	#$02,d0
	addi.l	#$02,$0004(a0)

RepSamp	move.l	d0,d1
	add.l	a1,d1
	move.l	d1,(a2)+	;Set repeat address
	add.l	$0004(a0),d0
	move.l	d0,(a2)+	;Set repeat length
	adda.l	(a7)+,a0	
	move.l	(a0)+,d0
	adda.l	(a0)+,a0
	move.l	(a0)+,d0
	adda.l	(a0)+,a0
	move.l	(a0)+,d0
	move.l	(a0)+,d0	;Real length of Sample

CopySmp	move.b	(a0)+,(a1)+
	subi.l	#$00000001,d0
	bne.b	CopySmp

	bra.b	FormCmp	

;--------------------------IRQ-------------------------------------------------

StrInit	bsr.w	AudioCl

	moveq	#$0001,d6
	moveq	#$0000,d7
	bsr	AudioIn
	moveq	#$0002,d6
	moveq	#$0001,d7
	bsr	AudioIn
	moveq	#$0003,d6
	moveq	#$0002,d7
	bsr	AudioIn
	moveq	#$0000,d6
	moveq	#$0003,d7
	bsr	AudioIn

WaitLin	cmp.b	#$c0,Vhposr(a5)
	bne.s	WaitLin
Wait.02	cmp.b	#$c0,Vhposr(a5)
	beq.s	Wait.02
	
FastFF	move.w	#$000f,Color(a5)

	moveq	#$0000,d7
	bsr	AudioPl
	moveq	#$0001,d7
	bsr	AudioPl
	moveq	#$0002,d7
	bsr	AudioPl
	moveq	#$0003,d7
	bsr	AudioPl

	move.w	#$0000,Color(a5)

	btst	#$02,Potgor(a5)
	beq.b	FastFF

	btst	#$06,$bfe001
	bne.s	WaitLin

	move.w	#$000f,Dmacon(a5)

	movem.l	(a7)+,d0-d7/a0-a6

	rts

;---------------------- REAL START OF AUDIO-DRIVER ----------------------------

	bra.s	AudioCl
	bra.s	AudioIn
	bra.w	AudioPl
	bra.w	SetFade

;------------------------------------------------------------------------------

AudioCl	lea	DataMem(PC),a0
	lea	Custom,a5

	moveq	#$30,d0
Cl.02	move.w	#$0000,Aud0dat+$00(a5)
	subi.w	#$0010,d0
	bcc.s	Cl.02
	rts
;------------------------------------------------------------------------------

AudioIn	lea	Custom,a5
	move.w	d7,d0
	mulu.w	#LabelEx,d0
	lea	DataMem(PC),a0
	adda.l	d0,a0

	move.w	d6,d0
	asl.w	#$03,d0
	move.w	d0,SequNum(a0)
	lea	SequTab(PC),a1
	move.l	$0000(a1,d0.w),SequInd(a0)

	move.w	#$0040,MainVol(a0)
	clr.w	FadeWrd(a0)
	move.w	#$1000,FadeCnt(a0)

	clr.w	StepNum(a0)
	lea	stpexit(PC),a1
	move.l	a1,StepInd(a0)
	clr.b	TranByt(a0)
	clr.b	SfxTran(a0)
	clr.b	RepStep(a0)
	clr.b	VoicSts(a0)
	moveq	#$01,d0
	move.b	d0,VoicTst(a0)
	move.b	d0,LenCopy(a0)
	clr.w	SpdTest(a0)
	clr.w	SpdCoun(a0)
	rts
;------------------------------------------------------------------------------

SetFade	mulu.w	#LabelEx,d7
	lea	DataMem(PC),a0
	adda.l	d7,a0
	move.w	d6,FadeWrd(a0)
	rts
;------------------------------------------------------------------------------

AudioPl	lea	Custom,a5

	move.w	d7,d0
	mulu.w	#LabelEx,d0
	lea	DataMem(PC),a0
	adda.l	d0,a0

	tst.b	VoicTst(a0)
	beq.w	Play.Ex

	move.w	d7,d2
	asl.w	#4,d2		
	ext.l	d2
	move.l	a5,a4
	adda.l	d2,a4

	lea	SFX(PC),a1
	move.w	RealSnd(a0),d0
	move.b	$0004(a1,d0.w),d2
	neg.b	d2
	ext.w	d2
	add.w	FrqWord(a0),d2
	move.w	d2,Aud0per(a4)

	move.w	MainVol(a0),d0
	mulu.w	VoicVol(a0),d0
	lsr.w	#$06,d0
	move.w	d0,Aud0vol(a4)
	
	btst	#$01,VoicSts(a0)
	beq.s	AudP.01

	subq.b	#$01,VoicSts(a0)

	lea	VoicTab(PC),a1
	move.b	$0000(a1,d7.w),d0
	ext.w	d0
	ori.w	#$8000,d0
	move.w	d0,Dmacon(a5)
	bra.s	AudP.02

AudP.01	btst	#$00,VoicSts(a0)
	beq.s	AudP.02
	
	subq.b	#$01,VoicSts(a0)
	
	move.w	RealSmp(a0),d0
	lea	SampTab(PC),a1
	move.w	d7,d2
	asl.w	#4,d2		
	ext.l	d2
	move.l	a5,a4
	adda.l	d2,a4
	move.l	$0004(a1,d0.w),d1
	move.l	d1,Aud0lc(a4)
	sub.l	$0000(a1,d0.w),d1
	sub.l	$0008(a1,d0.w),d1
	neg.l	d1	
	lsr.w	#$01,d1
	move.w	d1,Aud0len(a4)

AudP.02	subq.w	#$0001,SpdCoun(a0)
	bcc.s	Play.02

	not.w	SpdTest(a0)
	move.w	SpdTest(a0),d0
	andi.w	#$02,d0

	add.w	SequNum(a0),d0
	lea	SequTab(PC),a1
	move.w	$0004(a1,d0.w),SpdCoun(a0)

	subq.b	#$01,LenCopy(a0)
	bne.s	Play.02

	bsr.s	StepHnd
	rts
	
Play.02	tst.b	RealNot(a0)
	bmi.s	Play.Ex

	bsr.w	EffHand	

Play.Ex	rts
;------------------------------------------------------------------------------

StepHnd	move.w	#$ffff,GldDlay(a0)

	clr.b	NotLink(a0)
	move.l	StepInd(a0),a1
	move.b	(a1)+,d0
	cmp	#$fb,d0
	beq.b	NoDmaEx

DmaExit	lea	VoicTab(PC),a2
	move.b	(a2,d7.w),d1
	ext.w	d1
	move.w	d1,Dmacon(a5)
	bra.b	DmaWasX

NoDmaEx	move.b	(a1)+,d0
DmaWasX	cmpi.b	#$ff,d0
	bne.b	StpH.02

	bsr.w	SequHnd			; Einde Step

	move.l	StepInd(a0),a1	
	move.b	(a1)+,d0

StpH.02	cmpi.b	#$fe,d0
	bne.b	StpH.03

	clr.b	VoicTst(a0)
	rts

StpH.03	cmpi.b	#$fd,d0
	bne.b	StpH.04

StpH.3b	move.b	(a1),d0			; Glide Init
	lsr.b	#$04,d0
	addq.b	#$01,d0
	move.b	d0,GldSpd(a0)
	move.b	(a1)+,d0
	andi.b	#$0f,d0
	neg.b	d0
	add.b	RealLen(a0),d0
	addq.b	#$01,d0
	ext.w	d0
	move.w	d0,GldDlay(a0)

	move.b	(a1)+,d0
	add.b	TranByt(a0),d0
	move.b	d0,RealNot(a0)

	move.b	(a1)+,d0
	add.b	TranByt(a0),d0
	move.b	d0,DestNot(a0)
	bra.w	StpH.09

StpH.04	clr.w	RealVol(a0)		;Volume
	cmp.b	#$fc,d0
	bne.b	StpH.4b

	move.b	(a1)+,d0
	ext.w	d0
	move.w	d0,RealVol(a0)
	move.b	(a1)+,d0
	cmpi.b	#$fd,d0
	beq.w	StpH.3b	
	cmpi.b	#$fb,d0
	bcc.w	NoNewNo
	
StpH.4b	cmpi.b	#$f0,d0
	bcs.b	StpH.05

	andi.b	#$0f,d0			; Pause
	move.b	d0,RealLen(a0)
	move.b	#$ff,RealNot(a0)
	move.l	a1,StepInd(a0)
	bra.w	StpH.Ex

StpH.05	cmpi.b	#$c0,d0
	bcs.b	StpH.06

	andi.b	#$3f,d0			; Sound Effect
	add.b	SfxTran(a0),d0
	ext.w	d0
	asl.w	#$03,d0
	move.w	d0,RealSnd(a0)

	move.b	(a1)+,d0
	cmpi.b	#$fd,d0
	beq.w	StpH.3b
	cmpi.b	#$c0,d0
	bcc.b	NoNewNo

StpH.06	cmpi.b	#$80,d0
	bcs.b	StpH.07

	andi.b	#$3f,d0			; Length Note
	move.b	d0,RealLen(a0)

	move.b	(a1)+,d0
	cmpi.b	#$fd,d0
	beq.w	StpH.3b
	cmpi.b	#$80,d0
	bcc.b	NoNewNo

StpH.07	cmpi.b	#$60,d0
	bcs.s	StpH.08

	andi.b	#$1f,d0			; Arpeggio Number
	lsl.b	#$02,d0
	move.b	d0,ArpNumb(a0)

	move.b	(a1)+,d0
	cmpi.b	#$60,d0
	bcc.b	NoNewNo

StpH.08	add.b	TranByt(a0),d0		; Note
	move.b	d0,RealNot(a0)
	
	bra.b	StpH.09

NoNewNo	suba.l	#$00000001,a1

StpH.09	move.l	a1,StepInd(a0)
	
	bsr.b	SfxInit

StpH.Ex	move.b	RealLen(a0),LenCopy(a0)
	rts

SfxInit	move.w	RealSnd(a0),d0		; Init Voice-Fx
	lea	SFX(PC),a1
	lea	SampTab(PC),a2
	move.w	d7,d2
	asl.w	#$04,d2		
	ext.l	d2
	move.l	a5,a4
	adda.l	d2,a4

	clr.w	d3
	move.b	$0007(a1,d0.w),d3
	asl.w	#$02,d3
	move.w	d3,d4
	asl.w	#$01,d3
	add.w	d4,d3
	move.w	d3,RealSmp(a0)
	
	move.l	$0000(a2,d3.w),d1
	move.l	d1,Aud0lc(a4)

	move.l	$0008(a2,d3.w),d1
	lsr.l	#$01,d1
	move.w	d1,Aud0len(a4)

	move.w	RealVol(a0),d1
	bne.b	NoSfxVl
	move.b	$0000(a1,d0.w),d1
	ext.w	d1
	move.w	d1,RealVol(a0)
NoSfxVl	move.w	d1,VoicVol(a0)

NoVoVol	move.b	RealNot(a0),d1
	ext.w	d1
	add.w	d1,d1
	lea	FreqTab(PC),a2

	move.w	(a2,d1.w),d2
	move.w	d2,FrqWord(a0)
	clr.w	FrqWord+$02(a0)

	move.b	#$02,VoicSts(a0)

LinkNot	clr.b	AttTest(a0)
	move.w	#$ffff,RlDelay(a0)
	clr.w	d1
	move.b	$0006(a1,d0.w),d1
	bpl.b	SetRLDl
	move.b	d1,AttTest(a0)
	clr.w	VoicVol(a0)
	bra.b	NoRLDel	
SetRLDl	beq.b	NoRLD.2
	addq.w	#$0001,d1
	move.w	d1,RLDelay(a0)

NoRLDel	move.w	#$0200,RLCount(a0)

NORLD.2	btst.b	#$07,$0003(a1,d0.w)
	beq.b	FiltOut

FiltOn	move.b	$bfe001,d0
	andi.b	#$fd,d0
	move.b	d0,$bfe001

FiltOut	move.b	$bfe001,d0
	ori.b	#$02,d0
	move.b	d0,$bfe001
	rts
;------------------------------------------------------------------------------
SequHnd	subq.b	#$01,RepStep(a0)
	bcs.b	SeqH.01

	move.w	StepNum(a0),d0
	bra.b	SeqH.06

SeqH.01	move.l	SequInd(a0),a1
	move.b	(a1)+,d0
	cmpi.b	#$ff,d0
	bne.b	SeqH.02
	moveq	#$00,d0
	move.b	(a1),d0
	move.w	SequNum(a0),d1
	lea	SequTab(PC),a2
	move.l	$00(a2,d1.w),a1
	adda.l	d0,a1

	move.b	(a1)+,d0	

SeqH.02	cmpi.b	#$80,d0
	bcs.b	SeqH.03
	andi.b	#$7f,d0
	move.b	d0,TranByt(a0)
	
	move.b	(a1)+,d0	
	
SeqH.03	cmpi.b	#$70,d0
	bcs.b	SeqH.04
	andi.b	#$0f,d0
	move.b	d0,SfxTran(a0)
	
	move.b	(a1)+,d0	
	
SeqH.04	clr.b	RepStep(a0)

	cmpi.b	#$60,d0
	bcs.b	SeqH.05
	andi.b	#$0f,d0
	move.b	d0,RepStep(a0)

	move.b	(a1)+,d0	
	
SeqH.05	ext.w	d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,StepNum(a0)

	move.l	a1,SequInd(a0)

SeqH.06	lea	StepTab(PC),a2
	move.l	$00(a2,d0.w),StepInd(a0)
	rts
;------------------------------------------------------------------------------

EffHand	btst.b	#$00,VoicSts(a0)
	beq	EffH.02

	lea	SFX(PC),a1
	move.w	RealSnd(a0),d0

	tst.b	$0001(a1,d0.w)		; Vibrato-Init
	beq.b	SfxI.01
	move.b	RealLen(a0),d1
	sub.b	$0002(a1,d0.w),d1
	add.b	#$01,d1
	ext.w	d1
	move.w	d1,VibDlay(a0)
	move.b	$0001(a1,d0.w),d1
	move.b	d1,d2
	lsr.b	#$04,d1
	move.b	d1,VibDep(a0)
	andi.b	#$0f,d2
	lsr.b	#$01,d2
	clr.b	d1
	addx.b	d1,d2
	move.b	d2,VibSpd(a0)
	move.b	#$00,VibDir(a0)
	bra.b	SfxI.02
SfxI.01	move.w	#$ffff,VibDlay(a0)

SfxI.02	move.b	$0003(a1,d0.w),SfxByte(a0)
	btst	#$06,SfxByte(a0)
	beq	SfxI.03
	move.b	ArpNumb(a0),d0
	ext.w	d0
	lea	ArpTab(PC),a2
	move.l	$0000(a2,d0.w),ArpIndx(a0)
SfxI.03
;------------------------------------------------------------------------------

EffH.02	clr.w	d6
	move.b	LenCopy(a0),d6

FadeRtn	move.w	FadeWrd(a0),d0			;FADE
	beq.b	Fade.Ex
	sub.w	d0,FadeCnt(a0)
	bcs.b	Fade.04
	move.w	FadeCnt(a0),d1
	mulu.w	#$40,d1
	lsr.l	#$08,d1
	lsr.w	#$04,d1
	move.w	d1,MainVol(a0)
	bra.b	Fade.Ex

Fade.04	clr.b	VoicTst(a0)
	clr.w	MainVol(a0)
Fade.Ex	

GlideRt	cmp.w	GldDlay(a0),d6			;GLIDE
	bgt.b	GldExit

	move.b	RealNot(a0),d1
	ext.w	d1
	add.w	d1,d1
	clr.l	d3
	lea	FreqTab(PC),a2
	move.w	$0000(a2,d1.w),d3
	move.b	DestNot(a0),d1
	ext.w	d1
	add.w	d1,d1
	sub.w	$0000(a2,d1.w),d3
	move.b	GldSpd(a0),d4
	ext.w	d4
	muls.w	d4,d3
	asl.l	#$08,d3
	asl.l	#$02,d3
	sub.l	d3,FrqWord(a0)
	bcs.b	Glid.02
	move.w	FrqWord(a0),d2
	cmp.w	$0000(a2,d1.w),d2
	bgt.b	Glid.04
	bra.b	Glid.03
Glid.02	move.w	FrqWord(a0),d2
	cmp.w	$0000(a2,d1.w),d2
	blt.b	Glid.04
Glid.03	move.w	$0000(a2,d1.w),FrqWord(a0)
	clr.w	FrqWord+$02(a0)
	move.b	DestNot(a0),RealNot(a0)
	move.w	#$ffff,GldDlay(a0)

	move.b	VibDep(a0),d2
	andi.b	#$0f,d2
	lsr.b	#$01,d2
	clr.b	d1
	addx.b	d1,d2
	move.b	d2,VibSpd(a0)
	move.b	#$00,VibDir(a0)
	
Glid.04	bra.b	VibExit
GldExit	

Vibrato cmp.w	VibDlay(a0),d6			;VIBRATO
	bpl.b	VibExit

	subq.b	#$01,VibSpd(a0)
	bpl.b	Vibo.03	
	not.b	VibDir(a0)	
	lea	SFX(PC),a2
	move.w	RealSnd(a0),d1
	move.b	$0001(a2,d1.w),d1
	andi.b	#$0f,d1
	move.b	d1,VibSpd(a0)	

Vibo.03	move.b	RealNot(a0),d1
	ext.w	d1
	add.w	d1,d1
	lea	FreqTab(PC),a2
	clr.l	d3
	move.w	$0000(a2,d1.w),d3
	sub.w	$0002(a2,d1.w),d3
	asl.w	#$01,d3
	swap	d3
	move.b	VibDep(a0),d4
	asr.l	d4,d3
	tst.b	VibDir(a0)
	bpl.b	Vibo.04
	neg.l	d3
Vibo.04	add.l	d3,FrqWord(a0)
VibExit	

Arprout	btst.b	#$06,SfxByte(a0)		;ARPEGGIO
	beq.b	Arps.Ex
	move.l	ArpIndx(a0),a1
	move.b	(a1)+,d0
	cmpi.b	#$ff,d0
	bne.b	Arps.02
	clr.l	d0
	move.b	(a1),d0
	move.b	ArpNumb(a0),d1
	ext.w	d1
	lea	ArpTab(PC),a2
	add.l	$0000(a2,d1.w),d0
	move.l	d0,a1
	move.b	(a1)+,d0

Arps.02	cmpi.b	#$fe,d0
	bne.b	Arps.03
	andi.b	#$bf,SfxByte(a0)
	bra.b	Arps.Ex

Arps.03	add.b	RealNot(a0),d0
	ext.w	d0
	add.w	d0,d0
	lea	FreqTab(PC),a2
	move.w	$0000(a2,d0.w),FrqWord(a0)
	clr.w	FrqWord+$02(a0)
	move.l	a1,ArpIndx(a0)
Arps.Ex	

Attack	btst.b	#$07,AttTest(a0)		;ATTACK
	beq.b	Atta.Ex

	bsr.b	RampVol
	bcs.b	Atta.02
	neg.w	d1
	addi.w	#$0200,d1
	bsr.b	CompVol
	bra.b	Rele.ex	

Atta.02	clr.b	AttTest(a0)
	move.w	RealVol(a0),VoicVol(a0)
Atta.ex


Release	cmp.w	RLDelay(a0),d6			;RELEASE!
	bpl.b	Rele.Ex

	bsr	RampVol
	bcs.b	Rele.02
	bsr	CompVol	
	bra.b	Rele.ex

Rele.02	move.w	#$ffff,RLDelay(a0)
	clr.w	VoicVol(a0)
Rele.Ex	rts

;-------

RampVol	lea	SFX(PC),a1
	move.w	RealSnd(a0),d0
	clr.w	d1
	move.b	$0005(a1,d0.w),d1
	addq.w	#$0001,d1
	sub.w	d1,RLCount(a0)
	bcs.b	Ramp.02
	move.w	RLCount(a0),d1
Ramp.02	rts

CompVol	move.w	RealVol(a0),d2
	mulu.w	d2,d1
	lsr.l	#$08,d1
	lsr.w	#$01,d1
	move.w	d1,VoicVol(a0)
	rts
;------------------------------------------------------------------------------

VoicTab	dc.b	$01,$02,$04,$08

FreqTab	dc.w	$7df5,$76e7,$7036,$69ea,$63f9,$5e5b
	dc.w	$5910,$5411,$4f59,$4ae4,$46b0,$42b9
	dc.w	$3efa,$3b73,$381b,$34f5,$31fd,$2f2e
	dc.w	$2c88,$2a08,$27ac,$2572,$2358,$215d
	dc.w	$1c0d,$1a7b,$18fe,$1797,$1644,$1504
	dc.w	$13d6,$12b9,$11ac,$10ae,$0fbf,$0edd
	dc.w	$0e07,$0d3d,$0c7f,$0bcb,$0b22,$0a82
	dc.w	$09eb,$095d,$08d6,$0857,$07df,$076e
	dc.w	$0703,$069f,$0640,$05e6,$0591,$0541
	dc.w	$04f6,$04ae,$046b,$042c,$03f0,$03b7
	dc.w	$0382,$034f,$0320,$02f3,$02c9,$02a1
	dc.w	$027b,$0257,$0236,$0216,$01f8,$01dc
	dc.w	$01c1,$01a8,$0190,$0179,$0164,$0150
	dc.w	$013d,$012c,$011b,$010b,$00fc,$00ee
	dc.w	$00e0,$00d4,$00c8,$00bd,$00b2,$00a8
	dc.w	$009f,$0096,$008d,$0085,$007e,$0077

	cnop	$00,$04
;------------------------------------------------------------------------------
SequTab	dc.l	sq00,$00000000	;VA Clearvoice
	dc.l	sq01,$00020002	;V1 Levelmusic
	dc.l	sq02,$00020002	;V2 Levelmusic
	dc.l	sq03,$00020002	;V3 Levelmusic
	dc.l	sq04,$00020002	;V1 Endoflevelmusic
	
StepTab	dc.l	s00,s01,s02,s03,s04,s05,s06,s07
	dc.l	s08,s09,s0a,s0b,s0c,s0d,s0e,s0f
	dc.l	s10,s11,s12,s13,s14,s15,s16,s17
	dc.l	s18,s19,s1a,s1b,s1c,s1d,s1e,s1f
	dc.l	s20,s21,s22,s23,s24,s25,s26,s27
	dc.l	s28,s29,s2a,s2b,s2c,s2d,s2e,s2f
	dc.l	s30,s31,s32,s33,s34,s35,s36,s37
	dc.l	s38,s39,s3a,s3b,s3c,s3d,s3e,s3f
	dc.l	s40,s41,s42,s43,s44,s45,s46,s47
	dc.l	s48,s49,s4a,s4b,s4c,s4d,s4e,s4f
	dc.l	s50,s51,s52,s53,s54,s55,s56,s57
	dc.l	s58,s59,s5a,s5b,s5c,s5d,s5e,s5f

ArpTab	dc.l	a00,a01,a02,a03,a04,a05,a06,a07
	dc.l	a08,a09,a0a,a0b,a0c,a0d,a0e,a0f
	dc.l	a10,a11,a12,a13,a14,a15,a16,a17
	dc.l	a18,a19,a1a,a1b,a1c,a1d,a1e,a1f

even
;------------------------------------------------------------------------------

a00	dc.b	12,10,11,9,10,8,9,7,8,6,7,5,6,4,5,3,4,2,3,1,2,0,$ff,$00
a01
a02
a03
a04
a05
a06
a07
a08
a09
a0a
a0b
a0c
a0d
a0e
a0f
a10
a11
a12
a13
a14
a15
a16
a17
a18
a19
a1a
a1b
a1c
a1d
a1e
a1f
;------------------------------------------------------------------------------

;VIBRATO TWICE C64 DEPTH!

SFX	

;c0 Synth1
		dc.b	$40,$54,$08,$00
		dc.b	$00,$00,$00,$00
;c1 Synth1-1
		dc.b	$18,$54,$08,$00
		dc.b	$00,$00,$00,$00
;c2 PanFlute1
		dc.b	$28,$53,$08,$00
		dc.b	$02,$00,$00,$01
;c3 PanFlute1-1
		dc.b	$10,$53,$08,$00
		dc.b	$02,$00,$00,$01
;c4 Chorus1
		dc.b	$40,$54,$08,$00
		dc.b	$00,$00,$00,$02
;c5 Chorus1-1
		dc.b	$20,$54,$08,$00
		dc.b	$00,$00,$00,$02
;c6 Xylofoon1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$03
;c7 Xylofoon1-1
		dc.b	$18,$00,$00,$00
		dc.b	$00,$00,$00,$03
;c8 Snare1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$04
;c9 Snare1-1
		dc.b	$18,$00,$00,$00
		dc.b	$00,$00,$00,$04
;ca SynthVib
		dc.b	$40,$54,$00,$00
		dc.b	$00,$00,$00,$00
;cb Shaker1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$05
;cc Shaker1-1
		dc.b	$18,$00,$00,$00
		dc.b	$00,$00,$00,$05
;cd PanRelease
		dc.b	$20,$53,$00,$00
		dc.b	$02,$02,$24,$01
;ce Synth1Zwel
		dc.b	$40,$47,$10,$00
		dc.b	$00,$02,$80,$00
;cf Megabass2
		dc.b	$40,$54,$04,$00
		dc.b	$00,$00,$00,$06
;d0 Megabas-1
		dc.b	$18,$00,$00,$00
		dc.b	$00,$00,$00,$06
;d1 PaukenReal
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$07
;d2 Timpanicho1
		dc.b	$40,$00,$00,$00
		dc.b	$fe,$00,$00,$08
;d3 Timpanych-1
		dc.b	$18,$00,$00,$00
		dc.b	$fe,$00,$00,$08
;d4 Chorus1rel
		dc.b	$40,$54,$08,$00
		dc.b	$00,$08,$10,$02
;d5 TimpaniZwel
		dc.b	$40,$00,$00,$00
		dc.b	$00,$18,$80,$08
;d6 PanFluArRel
		dc.b	$20,$00,$00,$40
		dc.b	$02,$08,$08,$01
;d7 Xylofoon1-2
		dc.b	$08,$00,$00,$00
		dc.b	$00,$00,$00,$03
;d8 PaukenRea-1
		dc.b	$2c,$00,$00,$00
		dc.b	$00,$00,$00,$07
;d9 Chorus1rel2
		dc.b	$40,$54,$08,$00
		dc.b	$00,$02,$38,$02
;da Synth1Real2
		dc.b	$40,$54,$08,$00
		dc.b	$00,$02,$38,$00
;--------------------------------------------LEVEL MUSIC-----------------------
sq01
	dc.b	$a5,$01						;L01
	dc.b	$9f,$03,$05,$07,$09				;S01
	dc.b	$9f,$0c,$0c					;L02
	dc.b	$9f,$0f,$0f,$a0,$0f,$0f,$a1,$0f,$0f		;S02
	dc.b	$a1,$12,$15,$18					;L03
	dc.b	$a3,$65,$1b,$24					;S03
	dc.b	$a1,$1e						;L04
	dc.b	$a3,$21						;S04
	dc.b	$a1,$26						;L05
	dc.b	$a1,$2a						;S05
	dc.b	$a1,$1e						;L06
	dc.b	$a1,$63,$2d					;S06
	dc.b	$a2,$30						;L07
	dc.b	$a1,$63,$2d,$a7,$34				;S07
	dc.b	$a1,$1e						;L08
	dc.b	$a7,$36						;S08
	dc.b	$a7,$3b,$aa,$3b,$ad,$3b				;L09
	dc.b	$a1,$3e						;S09
	dc.b	$a1,$40,$9e,$40,$a1,$40,$9e,$72,$40		;L10
	dc.b	$a1,$40,$9e,$40					;L10
	dc.b	$a7,$70,$64,$44,$a1,$47,$49			;S10
	dc.b	$ff,$00						
sq02
	dc.b	$a5,$02,$71,$01					;L01
	dc.b	$9f,$03,$05,$08,$70,$0a				;S01
	dc.b	$9f,$0d,$0d					;L02
	dc.b	$9f,$10,$10,$a0,$10,$10,$a1,$10,$10		;S02
	dc.b	$a1,$13,$16,$19					;L03
	dc.b	$ad,$1c						;S03
	dc.b	$a1,$1f						;L04
	dc.b	$a1,$22						;S04
	dc.b	$a1,$27						;L05
	dc.b	$a7,$2b						;S05
	dc.b	$a1,$1f						;L06
	dc.b	$a1,$63,$2e					;S06
	dc.b	$9c,$31,$9e,$31,$a0,$31,$a2,$31			;L07
	dc.b	$a1,$63,$2e,$35					;S07
	dc.b	$a1,$1f						;L08
	dc.b	$a0,$37						;S08
	dc.b	$a1,$3c,$a4,$3c,$a7,$3c				;L09
	dc.b	$a1,$3f						;S09
	dc.b	$a1,$41,$9e,$41,$a1,$72,$41,$9e,$41		;L10
	dc.b	$a1,$41,$9e,$41					;L10
	dc.b	$a1,$70,$65,$45,$4a				;S10
	dc.b	$ff,$00
sq03
	dc.b	$9f,$72,$01					;L01
	dc.b	$9f,$70,$04,$06,$0b				;S01
	dc.b	$9f,$0e,$0e					;L02
	dc.b	$9f,$11,$ab,$11,$a0,$11,$ac,$11,$a1,$11,$ad,$11	;S02
	dc.b	$a1,$14,$17,$1a					;L03
	dc.b	$9f,$65,$1d,$25					;S03
	dc.b	$a1,$20						;L04
	dc.b	$a1,$23						;S04
	dc.b	$a1,$28,$28,$29					;L05
	dc.b	$a1,$2c						;S05
	dc.b	$a1,$20						;L06
	dc.b	$a7,$2f						;S06
	dc.b	$9c,$32,$9e,$32,$a0,$32,$a2,$32			;L07
	dc.b	$a7,$2f,$33					;S07
	dc.b	$a1,$20						;L08
	dc.b	$a1,$38,$39,$a1,$38,$a2,$39			;S08
	dc.b	$a1,$38,$a3,$39,$a1,$38,$a4,$39			;S08
	dc.b	$a1,$38,$a5,$39,$a1,$38,$a6,$39			;S08
	dc.b	$a1,$38,$a7,$39,$a1,$38,$a8,$39			;S08
	dc.b	$a1,$38,$a9,$39,$a1,$38,$aa,$39			;S08
	dc.b	$a1,$38,$ab,$39,$a1,$38,$ac,$39			;S08
	dc.b	$a1,$3a,$3a					;S08
	dc.b	$a1,$62,$3d					;L09
	dc.b	$a0,$72,$3e					;S09
	dc.b	$a1,$70,$42,$9e,$42,$a1,$63,$43,$28		;L10
	dc.b	$a1,$46,$48,$48,$4b				;S10
	dc.b	$ff,$00
sq04
	dc.b	$00
	dc.b	$ff,$00

;Load01

s01
	dc.b	$c0,$b0,$24
	dc.b	$fb,$90,$2b
	dc.b	$fb,$82,$2a,$fb,$28,$fb,$be,$2a
	dc.b	$fb,$b0,$25
	dc.b	$fb,$90,$2e
	dc.b	$fb,$82,$2d,$fb,$2c,$fb,$9c,$2d
	dc.b	$fb,$84,$2c,$fb,$2b,$fb,$2a,$fb,$26
	dc.b	$fb,$29,$fb,$25,$fb,$22,$fb,$1f
	dc.b	$fb,$a0,$20
	dc.b	$ff
s02
	dc.b	$f6
	dc.b	$ff

;Sequ01

s03
	dc.b	$c2,$8c,$37
	dc.b	$fb,$84,$35
	dc.b	$fb,$88,$33
	dc.b	$fb,$88,$32
	dc.b	$fb,$88,$35
	dc.b	$fb,$88,$31
	dc.b	$fb,$88,$33
	dc.b	$fb,$88,$30
	dc.b	$fb,$8c,$37
	dc.b	$fb,$84,$35
	dc.b	$fb,$88,$37
	dc.b	$fb,$88,$32
	dc.b	$fb,$84,$33
	dc.b	$fb,$84,$32
	dc.b	$fb,$88,$30
	dc.b	$fb,$88,$2c
	dc.b	$fb,$88,$30
	dc.b	$fb,$84,$2b
	dc.b	$fb,$84,$2c
	dc.b	$fb,$84,$2b
	dc.b	$fb,$84,$29
	dc.b	$fb,$94,$2b
	dc.b	$fb,$84,$32
	dc.b	$fb,$84,$37
	dc.b	$fb,$84,$38
	dc.b	$fb,$84,$3a
	dc.b	$fb,$82,$38,$fb,$81,$3a,$fb,$38
	dc.b	$fb,$84,$37
	dc.b	$fb,$84,$35
	dc.b	$fb,$82,$37,$fb,$38
	dc.b	$fb,$bc,$37
	dc.b	$ff
s04
	dc.b	$c4,$98,$24
	dc.b	$fb,$88,$32,$fb,$35,$fb,$31,$fb,$33,$fb,$30
	dc.b	$fb,$98,$24
	dc.b	$fb,$88,$32
	dc.b	$fb,$84,$33,$fb,$32
	dc.b	$fb,$88,$30,$fb,$88,$2c,$fb,$20
	dc.b	$fb,$90,$1f,$fb,$26,$fb,$1f,$fb,$27
	dc.b	$fb,$90,$1f,$fb,$26,$fb,$94,$2b
	dc.b	$fb,$84,$26,$fb,$1f,$fb,$19
	dc.b	$ff	
s05
	dc.b	$c4,$84,$30
	dc.b	$fb,$37
	dc.b	$fb,$3c
	dc.b	$fb,$88,$38
	dc.b	$fb,$84,$30
	dc.b	$fb,$37
	dc.b	$fb,$3c
	dc.b	$fb,$88,$38
	dc.b	$fb,$86,$31,$fb,$81,$33,$fb,$31
	dc.b	$fb,$84,$30
	dc.b	$fb,$37
	dc.b	$fb,$3c
	dc.b	$fb,$88,$38
	dc.b	$fb,$84,$30
	dc.b	$fb,$37
	dc.b	$fb,$3c
	dc.b	$ff
s07
	dc.b	$c4,$90,$36
	dc.b	$ff
s08
	dc.b	$c4,$8a,$36
	dc.b	$ff
s06
	dc.b	$c4,$a0,$18
	dc.b	$fb,$90,$20
	dc.b	$fb,$a0,$18
	dc.b	$fb,$90,$1e
	dc.b	$ff
s09
	dc.b	$c6,$84,$30,$31,$30,$31,$30,$31,$30,$2e
	dc.b	$30,$31,$30,$31,$30,$31,$33,$35
	dc.b	$30,$31,$30,$31,$30,$31,$30,$2e
	dc.b	$30,$31,$30,$31,$33,$35,$36,$31
	dc.b	$ff	
s0a
	dc.b	$c6,$84,$37,$36,$37,$36,$37,$36,$37,$38
	dc.b	$37,$36,$37,$36,$37,$38,$3a,$3c
	dc.b	$37,$36,$37,$36,$37,$36,$37,$38
	dc.b	$37,$36,$37,$38,$3a,$3c,$3d,$38
	dc.b	$ff	
s0b
	dc.b	$c6,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$82,$24,$24
	dc.b	$c6,$84,$24,$25,$27,$29

	dc.b	$c6,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$82,$25,$25
	dc.b	$c6,$84,$27,$29,$2a,$25
	dc.b	$ff	

;Load02

s0c
	dc.b	$c6,$84,$37,$c7,$37
	dc.b	$c6,$84,$37,$36,$37,$c7,$36,$37,$36
	dc.b	$c4,$8c,$24,$25,$88,$29
	dc.b	$c6,$84,$37,$c7,$37
	dc.b	$c6,$84,$37,$36,$37,$c7,$36,$37,$36
	dc.b	$c4,$8c,$24,$27,$88,$2e

	dc.b	$c6,$84,$37,$c7,$37
	dc.b	$c6,$84,$37,$36,$37,$c7,$36,$37,$36
	dc.b	$c4,$8c,$24,$25,$88,$29
	dc.b	$c6,$84,$37,$c7,$37
	dc.b	$c6,$84,$37,$36,$37,$c7,$36,$37,$36
	dc.b	$c4,$88,$24,$29,$2e,$33

	dc.b	$c6,$84,$3c,$c7
	dc.b	$c6,$84,$3c,$c7
	dc.b	$c6,$84,$3c,$c7
	dc.b	$c6,$84,$3c,$c7
	dc.b	$c6,$85,$3c,$c7
	dc.b	$c6,$85,$3c,$c7
	dc.b	$c6,$85,$3c,$c7
	dc.b	$c6,$85,$3c,$c7
	dc.b	$ff
s0d
	dc.b	$c6,$84,$30,$c7,$30
	dc.b	$c6,$84,$30,$30,$30,$c7,$30,$30,$30
	dc.b	$c4,$8c,$2b,$2c,$88,$30
	dc.b	$c6,$84,$30,$c7,$30
	dc.b	$c6,$84,$30,$30,$30,$c7,$30,$30,$30
	dc.b	$c4,$8c,$2b,$2e,$88,$35

	dc.b	$c6,$84,$30,$c7,$30
	dc.b	$c6,$84,$30,$30,$30,$c7,$30,$30,$30
	dc.b	$c4,$8c,$2b,$2c,$88,$30
	dc.b	$c6,$84,$30,$c7,$30
	dc.b	$c6,$84,$30,$30,$30,$c7,$30,$30,$30
	dc.b	$c4,$88,$29,$2e,$33,$38

	dc.b	$c6,$84,$3a,$c7
	dc.b	$c6,$84,$38,$c7
	dc.b	$c6,$84,$36,$c7
	dc.b	$c6,$84,$34,$c7
	dc.b	$c6,$85,$32,$c7
	dc.b	$c6,$85,$30,$c7
	dc.b	$c6,$85,$2e,$c7
	dc.b	$c6,$85,$2c,$c7
	dc.b	$ff
s0e
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c6,$8c,$24,$84,$24,$8c,$24,$84,$24
	dc.b	$c4,$a0,$24,$fb,$a8,$18
	dc.b	$ff

;Sequ02

s0f
	dc.b	$c8,$84,$35
	dc.b	$c9,$81,$35,$35,$35,$35
	dc.b	$c8,$84,$35
	dc.b	$c8,$84,$35
	dc.b	$c0,$88,$2a,$fb,$2b
	dc.b	$c8,$84,$35
	dc.b	$c9,$81,$35,$35,$35,$35
	dc.b	$c9,$82,$35,$35
	dc.b	$c8,$84,$35
	dc.b	$c0,$88,$2f,$fb,$30

	dc.b	$c8,$84,$35
	dc.b	$c9,$81,$35,$35,$35,$35
	dc.b	$c8,$84,$35
	dc.b	$c8,$84,$35
	dc.b	$c0,$88,$31,$fb,$32
	dc.b	$c8,$84,$35
	dc.b	$c9,$81,$35,$35,$35,$35
	dc.b	$c9,$82,$35,$35
	dc.b	$c8,$84,$35
	dc.b	$c0,$88,$36,$fb,$37
	dc.b	$ff
s10
	dc.b	$ca,$a0,$2a,$fb,$2a,$fb,$2a,$fb,$2a
	dc.b	$ff
s11
	dc.b	$c2,$84,$24,$fb,$2a,$fb,$2b,$fb,$30
	dc.b	$fb,$2c,$fb,$2b,$fb,$2a,$fb,$2b
	dc.b	$fb,$24,$fb,$2a,$fb,$2b,$fb,$30
	dc.b	$fb,$2c,$fb,$2b,$fb,$2a,$fb,$2b
	dc.b	$fb,$24,$fb,$2a,$fb,$2b,$fb,$30
	dc.b	$fb,$2c,$fb,$2b,$fb,$2a,$fb,$2b
	dc.b	$fb,$24,$fb,$2a,$fb,$2b,$fb,$30
	dc.b	$fb,$2c,$fb,$2b,$fb,$2a,$fb,$2b
	dc.b	$ff

;Load03

s12
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c2,$82,$30,$fb,$31,$fb,$33,$fb,$35
	dc.b	$fb,$81,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$37,$fb,$38,$fb,$36,$fb,$37
	dc.b	$fb,$35,$fb,$36,$fb,$34,$fb,$35
	dc.b	$fb,$33,$fb,$34,$fb,$32,$fb,$33
	dc.b	$fb,$31,$fb,$32,$fb,$30,$fb,$31
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c2,$88,$3c,$fb,$3a,$fb,$35,$fb,$38,$fb,$31

	dc.b	$fb,$81,$30,$fb,$31,$fb,$30,$fb,$31
	dc.b	$fb,$82,$30,$fb,$31
	dc.b	$fb,$84,$30
	dc.b	$fb,$81,$30,$fb,$31,$fb,$30,$fb,$31
	dc.b	$fb,$82,$30,$fb,$31
	dc.b	$fb,$84,$30
	dc.b	$fb,$81,$30,$fb,$31,$fb,$30,$fb,$31
	dc.b	$fb,$82,$30,$fb,$31
	dc.b	$fb,$8c,$33

	dc.b	$c4,$84,$1f,$fb,$88,$20,$fb,$22

	dc.b	$c2,$81,$30,$fb,$31,$fb,$30,$fb,$31
	dc.b	$fb,$82,$30,$fb,$31
	dc.b	$fb,$84,$30
	dc.b	$fb,$81,$31,$fb,$33,$fb,$31,$fb,$33
	dc.b	$fb,$82,$31,$fb,$33
	dc.b	$fb,$84,$31
	dc.b	$fb,$81,$33,$fb,$35,$fb,$33,$fb,$35
	dc.b	$fb,$82,$33,$fb,$35
	dc.b	$fb,$8c,$36

	dc.b	$c4,$84,$1f,$fb,$88,$22,$fb,$20
	dc.b	$ff	
s13
	dc.b	$c6,$82,$2f,$30,$84,$31,$30
	dc.b	$c6,$82,$31,$30,$84,$2f,$30
	dc.b	$c2,$82,$2b,$fb,$2c,$fb,$2e,$fb,$30
	dc.b	$fb,$81,$32,$fb,$33,$fb,$32,$fb,$33
	dc.b	$fb,$32,$fb,$33,$fb,$32,$fb,$33
	dc.b	$fb,$31,$fb,$32,$fb,$31,$fb,$32
	dc.b	$fb,$31,$fb,$32,$fb,$31,$fb,$32
	dc.b	$fb,$30,$fb,$31,$fb,$2f,$fb,$30
	dc.b	$fb,$2e,$fb,$2f,$fb,$2d,$fb,$2e
	dc.b	$fb,$2c,$fb,$2d,$fb,$2b,$fb,$2c
	dc.b	$fb,$2a,$fb,$2b,$fb,$29,$fb,$2a
	dc.b	$c6,$82,$2f,$30,$84,$31,$30
	dc.b	$c6,$82,$31,$30,$84,$2f,$30
	dc.b	$c2,$88,$37,$fb,$35,$fb,$2e,$fb,$31,$fb,$2c

	dc.b	$fb,$81,$2b,$fb,$2c,$fb,$2b,$fb,$2c
	dc.b	$fb,$82,$2b,$fb,$2c
	dc.b	$fb,$84,$2b
	dc.b	$fb,$81,$2b,$fb,$2c,$fb,$2b,$fb,$2c
	dc.b	$fb,$82,$2b,$fb,$2c
	dc.b	$fb,$84,$2b
	dc.b	$fb,$81,$2b,$fb,$2c,$fb,$2b,$fb,$2c
	dc.b	$fb,$82,$2b,$fb,$2c
	dc.b	$fb,$8c,$2e

	dc.b	$c4,$84,$24,$fb,$88,$25,$fb,$27

	dc.b	$c2,$81,$2b,$fb,$2c,$fb,$2b,$fb,$2c
	dc.b	$fb,$82,$2b,$fb,$2c
	dc.b	$fb,$84,$2b
	dc.b	$fb,$81,$2c,$fb,$2e,$fb,$2c,$fb,$2e
	dc.b	$fb,$82,$2c,$fb,$2e
	dc.b	$fb,$84,$2c
	dc.b	$fb,$81,$2e,$fb,$30,$fb,$2e,$fb,$30
	dc.b	$fb,$82,$2e,$fb,$30
	dc.b	$fb,$8c,$31

	dc.b	$c4,$84,$24,$fb,$88,$27,$fb,$25
	dc.b	$ff
s14
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$84,$30,$cc,$30
	dc.b	$cb,$84,$30,$cc,$30
	dc.b	$cb,$84,$30,$cc,$30
	dc.b	$cb,$84,$30,$cc,$30
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$83,$37,$cc,$37
	dc.b	$cb,$83,$37,$cc,$37
	dc.b	$cb,$83,$37,$cc,$37
	dc.b	$cb,$83,$37,$cc,$37
	dc.b	$cb,$82,$37,$cc,$37
	dc.b	$cb,$82,$37,$cc,$37
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$81,$3c,$cc,$3c,$3c,$3c,$cb,$82,$3c,$cc
	dc.b	$cb,$81,$3c,$cc,$3c,$3c,$3c,$cb,$82,$3c,$cc
	dc.b	$cb,$81,$3c,$cc,$3c,$3c,$3c,$cb,$82,$3c,$cc
	dc.b	$cb,$81,$3c,$cc,$3c,$3c,$3c,$cb,$82,$3c,$cc
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$82,$3c,$cc,$3c,$3c,$3c
	dc.b	$cb,$81,$3c,$cc,$3b,$3a,$39,$cb,$82,$38,$cc
	dc.b	$cb,$81,$37,$cc,$38,$39,$3a,$cb,$82,$3b,$cc
	dc.b	$cb,$81,$3c,$cc,$3b,$3a,$39,$cb,$82,$38,$cc
	dc.b	$cb,$81,$37,$cc,$38,$39,$3a,$cb,$82,$3b,$cc
	dc.b	$ff

s15
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c6,$82,$36,$38,$84,$37,$36
	dc.b	$c6,$82,$37,$36,$84,$38,$36
	dc.b	$c7,$84,$36
	dc.b	$c2,$84,$30,$36,$3a	
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c6,$82,$38,$37,$84,$36,$37
	dc.b	$c6,$82,$36,$38,$84,$37,$36
	dc.b	$c6,$82,$38,$36,$84,$37,$38
	dc.b	$c7,$84,$38
	dc.b	$c2,$84,$30,$36,$3c	
	dc.b	$ff
s16
	dc.b	$c6,$82,$2f,$30,$84,$31,$30
	dc.b	$c6,$82,$31,$30,$84,$2f,$30
	dc.b	$c6,$82,$31,$2f,$84,$30,$31
	dc.b	$c6,$82,$30,$2f,$84,$31,$2f
	dc.b	$c7,$84,$2f
	dc.b	$c2,$84,$2c,$32,$36
	dc.b	$c6,$82,$2f,$30,$84,$31,$30
	dc.b	$c6,$82,$31,$30,$84,$2f,$30
	dc.b	$c6,$82,$31,$2f,$84,$30,$31
	dc.b	$c6,$82,$31,$2f,$84,$30,$31
	dc.b	$c7,$84,$31
	dc.b	$c2,$84,$2c,$32,$37
	dc.b	$ff
s17
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27
	dc.b	$c6,$82,$2a,$2b,$2a,$2b,$2c,$2b
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27,$25,$22
	dc.b	$c6,$82,$24,$27
	dc.b	$c6,$82,$2a,$2b,$2c,$30,$31,$33
	dc.b	$ff	
s18
	dc.b	$c2,$9c,$3d,$fb,$84,$3a,$fb,$94,$3c
	dc.b	$fb,$84,$30,$fb,$37,$fb,$3c
	dc.b	$c2,$9c,$3d,$fb,$84,$3a,$fb,$94,$3c
	dc.b	$fb,$85,$30,$fb,$37,$fb,$3c
	dc.b	$c2,$a3,$3d,$fb,$85,$3a,$fb,$99,$3c
	dc.b	$fb,$85,$30,$fb,$37,$fb,$3c
	dc.b	$c2,$a3,$3d
	dc.b	$fb,$86,$3b
	dc.b	$fb,$b0,$3c,$fb,$cd,$b1,$3c
	dc.b	$ce,$bf,$2a
	dc.b	$ff
s19
	dc.b	$c2,$9c,$36,$fb,$84,$35,$fb,$94,$37
	dc.b	$fb,$84,$2b,$fb,$30,$fb,$37
	dc.b	$c2,$9c,$36,$fb,$84,$35,$fb,$94,$37
	dc.b	$fb,$85,$2b,$fb,$30,$fb,$37
	dc.b	$c2,$a3,$36,$fb,$85,$35,$fb,$99,$37
	dc.b	$fb,$85,$2b,$fb,$30,$fb,$37
	dc.b	$c2,$a3,$36
	dc.b	$fb,$86,$32
	dc.b	$fb,$b0,$33,$fb,$cd,$b1,$33	
	dc.b	$ce,$bf,$30
	dc.b	$ff
s1a
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$36
	dc.b	$c6,$84,$3c
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$3c
	dc.b	$c6,$84,$36
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$37
	dc.b	$c6,$84,$3c
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$3c
	dc.b	$c6,$84,$37

	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$36
	dc.b	$c6,$84,$3c
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$3c
	dc.b	$c6,$84,$36
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$84,$30
	dc.b	$c6,$84,$37
	dc.b	$c6,$84,$3c
	dc.b	$c6,$82,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$3c
	dc.b	$c6,$85,$37

	dc.b	$c6,$83,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$36
	dc.b	$c6,$85,$3c
	dc.b	$c6,$83,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$3c
	dc.b	$c6,$85,$36
	dc.b	$c6,$83,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$37
	dc.b	$c6,$85,$3c
	dc.b	$c6,$83,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$3c
	dc.b	$c6,$85,$37

	dc.b	$c6,$83,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$36
	dc.b	$c6,$85,$3c
	dc.b	$c6,$83,$30,$c7,$81,$30,$30
	dc.b	$c6,$85,$30
	dc.b	$c6,$85,$3c
	dc.b	$c6,$86,$36
	dc.b	$c6,$84,$30,$c7,$81,$30,$30
	dc.b	$c6,$86,$30
	dc.b	$c6,$86,$37
	dc.b	$c6,$86,$3c
	dc.b	$c6,$84,$30,$c7,$81,$30,$30
	dc.b	$c6,$86,$30
	dc.b	$c6,$86,$3c
	dc.b	$c6,$86,$37
	dc.b	$c6,$84,$24,$c7,$81,$24,$24
	dc.b	$c6,$86,$24
	dc.b	$c6,$86,$2b
	dc.b	$c6,$86,$30
	dc.b	$c6,$84,$24,$c7,$81,$24,$24
	dc.b	$c6,$86,$24
	dc.b	$c6,$86,$2b
	dc.b	$c6,$86,$30

	dc.b	$c6,$8c,$24,$84,$2a
	dc.b	$c6,$8c,$24,$84,$2a
	dc.b	$c6,$8c,$24,$84,$2a
	dc.b	$c6,$8c,$24,$84,$2a
	dc.b	$ff

;Seq03

s1b
	dc.b	$cf,$82,$3c,$30,$3c,$3c,$3d,$3c,$3b,$30
	dc.b	$cf,$82,$3c,$30,$3c,$3c,$3d,$3c,$3b,$30
	dc.b	$cf,$82,$3c,$30,$3c,$3c,$3d,$3c,$36,$30
	dc.b	$cf,$82,$3c,$30,$3c,$3c,$3d,$3c,$36,$30
	dc.b	$ff
s24
	dc.b	$cf,$82,$3c,$30,$37,$3c,$37,$30,$37,$30
	dc.b	$cf,$82,$3c,$30,$37,$3c,$37,$30,$37,$30
	dc.b	$ff
s1c
	dc.b	$c4,$a0,$18
	dc.b	$90,$24
	dc.b	$90,$1f
	dc.b	$b0,$1e
	dc.b	$88,$22
	dc.b	$88,$25

	dc.b	$fb,$a0,$24
	dc.b	$8f,$2b,$fb,$81,$2f
	dc.b	$fb,$90,$30
	dc.b	$c4,$9c,$31,$fb,$81,$30,$fb,$2f,$fb,$2e,$fb,$2d

	dc.b	$d1,$88,$2b,$26,$2b,$26

	dc.b	$d2,$a0,$23
	dc.b	$d2,$90,$24,$26
	dc.b	$d2,$a0,$27
	dc.b	$d2,$90,$22,$24

	dc.b	$d2,$88,$26,$28,$26,$24	
	dc.b	$ff
s1d
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37
	dc.b	$c8,$82,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37
	dc.b	$c8,$82,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$81,$37,$c9,$37,$82,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37,$c9,$37
	dc.b	$c8,$82,$37
	dc.b	$c8,$82,$37
	dc.b	$c8,$82,$37,$c9
	dc.b	$c8,$81,$37,$c9,$37,$37,$37,$37,$37,$37,$37
	dc.b	$ff
s25
	dc.b	$c8,$82,$32,$c9,$32
	dc.b	$c8,$82,$32
	dc.b	$c8,$82,$32
	dc.b	$c8,$82,$32,$c9,$32
	dc.b	$c8,$82,$32,$c9,$32
	dc.b	$c8,$84,$32,$c9
	dc.b	$c8,$84,$32,$c9
	dc.b	$ff

;Load04

s1e
	dc.b	$c0,$a0,$2a
	dc.b	$fb,$90,$36
	dc.b	$fb,$90,$31
	dc.b	$fb,$82,$2f,$fb,$31
	dc.b	$fb,$8c,$32,$fb,$34,$fb,$36,$fb,$34,$fb,$32
	dc.b	$fb,$a0,$2a
	dc.b	$fb,$90,$36
	dc.b	$fb,$90,$31
	dc.b	$fb,$82,$2f,$fb,$31
	dc.b	$fb,$8c,$32,$fb,$31,$fb,$2f,$fb,$32,$fb,$34
	dc.b	$fb,$90,$2a
	dc.b	$fb,$8c,$36
	dc.b	$fb,$94,$35
	dc.b	$cc,$81,$3d,$3c,$3b,$3a,$39,$38,$37,$36
	dc.b	$cc,$82,$35,$34,$33,$32
	dc.b	$c0,$90,$2a
	dc.b	$fb,$8c,$36
	dc.b	$fb,$94,$34
	dc.b	$c2,$81,$3d,$fb,$38,$fb,$31,$fb,$2c
	dc.b	$fb,$25,$fb,$2c,$fb,$31,$fb,$38
	dc.b	$fb,$3d,$fb,$38,$fb,$31,$fb,$2c
	dc.b	$fb,$25,$fb,$2c,$fb,$31,$fb,$38
	dc.b	$c0,$90,$2a
	dc.b	$fb,$8c,$36
	dc.b	$fb,$94,$35
	dc.b	$c2,$81,$36,$fb,$35,$fb,$34,$fb,$33
	dc.b	$fb,$35,$fb,$34,$fb,$33,$fb,$32
	dc.b	$fb,$34,$fb,$33,$fb,$32,$fb,$31
	dc.b	$fb,$33,$fb,$32,$fb,$31,$fb,$30
	dc.b	$c0,$90,$2a
	dc.b	$fb,$8c,$36
	dc.b	$fb,$94,$34
	dc.b	$c6,$82,$30,$c7,$c6,$30,$30,$30,$31,$30,$2e

	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$2e,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$2e,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$31,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$31,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$82,$30,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$ff
s1f
	dc.b	$d1,$8c,$30,$84,$8c,$84,$8c,$84,$8c,$84
	dc.b	$8c,$84,$8c,$84,$8c,$84,$84
	dc.b	$c8,$82,$37,$37,$37,$c9,$c8,$c9
	dc.b	$d1,$8c,$30,$84,$8c,$84,$8c,$84,$8c,$84
	dc.b	$8c,$84,$8c,$84,$8c,$84,$84
	dc.b	$c8,$82,$37,$37,$37,$c9,$c8,$c9
	dc.b	$d1,$8c,$30,$84,$8c,$84,$8c,$84,$8c,$84
	dc.b	$8c,$84,$8c,$84,$8c,$84,$84
	dc.b	$c8,$82,$37,$37,$37,$c9,$c8,$c9
	dc.b	$d1,$8c,$30,$84,$8c,$84,$8c,$84,$8c,$84
	dc.b	$8c,$84,$8c,$84,$8c,$84,$84
	dc.b	$c8,$82,$37,$37,$37,$c9,$c8,$c9

	dc.b	$d1,$8c,$30,$84,$8c,$84,$8c,$84,$8c,$84
	dc.b	$d1,$8c,$30,$84,$8c,$84,$8c,$84,$8c,$84
	dc.b	$d1,$88,$30,$30,$30,$30,$30,$30,$30,$30
	dc.b	$ff
s20
	dc.b	$d2,$a0,$2f
	dc.b	$d2,$90,$34
	dc.b	$d2,$90,$2f
	dc.b	$fb,$82,$2d,$fb,$2f,$fb,$8c,$30
	dc.b	$d2,$8c,$32
	dc.b	$d2,$8c,$34
	dc.b	$d2,$8c,$32
	dc.b	$d2,$8c,$30

	dc.b	$d2,$a0,$2f
	dc.b	$d2,$90,$34
	dc.b	$d2,$90,$2f
	dc.b	$fb,$82,$2d,$fb,$2f,$fb,$8c,$30
	dc.b	$d2,$8c,$2f
	dc.b	$d2,$8c,$2d
	dc.b	$d2,$8c,$2b
	dc.b	$d2,$8c,$2d
	dc.b	$d2,$90,$2f
	dc.b	$d2,$8c,$34
	dc.b	$d2,$a4,$2e
	dc.b	$d2,$90,$2f
	dc.b	$d2,$8c,$34
	dc.b	$d2,$a4,$35
	dc.b	$d2,$90,$2f
	dc.b	$d2,$8c,$34
	dc.b	$d2,$a4,$2e
	dc.b	$d2,$90,$2f
	dc.b	$d2,$8c,$34
	dc.b	$d2,$a4,$35

	dc.b	$d2,$a0,$2f,$fb,$2d,$fb,$2f,$fb,$30
	dc.b	$fb,$2f,$fb,$2f
	dc.b	$ff

;Sequ04

s21
	dc.b	$c0,$88,$1c,$84,$23,$28,$88,$1c,$84,$23,$28
	dc.b	$88,$1d,$84,$24,$29,$88,$1d,$84,$24,$29
	dc.b	$88,$1c,$84,$23,$28,$88,$1c,$84,$23,$28
	dc.b	$88,$1d,$84,$24,$29,$88,$1d,$84,$24,$29
	dc.b	$88,$1c,$84,$23,$28,$88,$1c,$84,$23,$28
	dc.b	$88,$1a,$84,$21,$26,$1a,$1f,$21,$26
	dc.b	$88,$18,$84,$1f,$24,$88,$18,$84,$1f,$24
	dc.b	$88,$17,$84,$1e,$23,$88,$17,$84,$1e,$23
	dc.b	$88,$18,$84,$1f,$24,$88,$18,$84,$1f,$24
	dc.b	$88,$17,$84,$1e,$23,$88,$17,$84,$1e,$23
	dc.b	$ff	
s22
	dc.b	$c4,$84,$30,$37,$3c,$3d,$3a,$3c,$37,$30
	dc.b	$c4,$84,$31,$38,$3c,$3d,$3c,$37,$38,$31
	dc.b	$c4,$84,$30,$37,$3c,$3d,$3a,$3c,$37,$30
	dc.b	$c4,$84,$31,$38,$3c,$3d,$3c,$38,$37,$31
	dc.b	$c4,$84,$30,$37,$3c,$3d,$3a,$3c,$37,$30
	dc.b	$c4,$84,$2e,$35,$82,$3a,$fb,$3b,$fb,$3a,$fb,$38
	dc.b	$fb,$81,$3a,$fb,$3b,$fb,$3a,$fb,$38
	dc.b	$fb,$3a,$fb,$3b,$fb,$3a,$fb,$38
	dc.b	$fb,$3a,$fb,$3b,$fb,$3a,$fb,$38
	dc.b	$fb,$3a,$fb,$3b,$fb,$3a,$fb,$38

	dc.b	$c4,$84,$2c,$33,$37,$38,$3c,$38
	dc.b	$82,$37,$fb,$38,$fb,$33,$fb,$2c
	dc.b	$c4,$84,$2b,$32,$37,$38,$3a,$82,$38,$fb,$81,$3a,$fb,$38
	dc.b	$c4,$84,$37,$32
	dc.b	$c4,$84,$33,$2c,$37,$33,$38,$37,$3c,$38
	dc.b	$c4,$82,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$90,$37
	dc.b	$ff
s23
	dc.b	$d1,$8a,$33
	dc.b	$c6,$82,$3c,$84,$30
	dc.b	$30,$24,$c7,$30,$24
	dc.b	$d1,$8a,$33
	dc.b	$c6,$82,$3c,$84,$30
	dc.b	$30,$24,$c7,$30,$24
	dc.b	$d1,$8a,$33
	dc.b	$c6,$82,$3c,$84,$30
	dc.b	$30,$24,$c7,$30,$24
	dc.b	$d1,$8a,$33
	dc.b	$c6,$82,$3c,$84,$30
	dc.b	$30,$24,$c7,$30,$24
	dc.b	$d1,$8a,$33
	dc.b	$c6,$82,$3c,$84,$30
	dc.b	$30,$24,$c7,$30,$24
	dc.b	$d1,$8a,$33
	dc.b	$c6,$82,$3c,$84,$30
	dc.b	$30,$24,$c7,$30,$24

	dc.b	$d1,$86,$33
	dc.b	$c8,$82,$38,$c8,$c9,$c8,$c9
	dc.b	$c8,$81,$c9,$c9,$c9
	dc.b	$c8,$82,$c8,$c8,$c8,$c9,$c8
	dc.b	$d1,$86,$33
	dc.b	$c8,$82,$38,$c8,$c9,$c8,$c9
	dc.b	$c8,$81,$35,$c9,$c9,$c9
	dc.b	$c8,$82,$c8,$c8,$c9,$c8,$c9
	dc.b	$d1,$86,$33
	dc.b	$c8,$82,$38,$c8,$c8,$c9,$c8
	dc.b	$c8,$81,$c9,$c9,$c9
	dc.b	$c8,$82,$c8,$c8,$c8,$c8,$c9
	dc.b	$d1,$86,$33
	dc.b	$c8,$82,$38
	dc.b	$c8,$81,$38,$c9,$c9,$c9
	dc.b	$c8,$82,$c9
	dc.b	$c8,$81,$38,$c9,$c9,$c9
	dc.b	$c8,$82,$c9
	dc.b	$c8,$81,$38,$c9,$c9,$c9
	dc.b	$c8,$82,$c9
	dc.b	$ff

;Load05

s26
	dc.b	$d4,$90,$24
	dc.b	$d4,$90,$2a
	dc.b	$d4,$90,$25
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$27
	dc.b	$d4,$90,$2d
	dc.b	$d4,$90,$29
	dc.b	$d4,$90,$2f
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$31
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$32
	dc.b	$d4,$90,$2e
	dc.b	$d4,$90,$34
	dc.b	$d4,$90,$31
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$24
	dc.b	$d4,$90,$30
	dc.b	$d4,$90,$25
	dc.b	$d4,$90,$31
	dc.b	$d4,$90,$27
	dc.b	$d4,$90,$33
	dc.b	$d4,$90,$29
	dc.b	$d4,$90,$31
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$37
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$38
	dc.b	$d4,$90,$2e
	dc.b	$d4,$90,$3a
	dc.b	$d4,$90,$30
	dc.b	$d4,$90,$2b

	dc.b	$d4,$a0,$24
	dc.b	$ff
s27
	dc.b	$d4,$88,$18
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$24
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$25
	dc.b	$d4,$90,$2e
	dc.b	$d4,$90,$27
	dc.b	$d4,$90,$30
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$32
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$33
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$35
	dc.b	$d4,$90,$32
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$25
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$37
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$38
	dc.b	$d4,$90,$2e
	dc.b	$d4,$90,$3a
	dc.b	$d4,$90,$30
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$32
	dc.b	$d4,$90,$2b
	dc.b	$d4,$90,$33
	dc.b	$d4,$90,$2c
	dc.b	$d4,$90,$35
	dc.b	$d4,$90,$2f
	dc.b	$d4,$90,$2c
	dc.b	$d4,$88,$25

	dc.b	$d4,$a0,$18
	dc.b	$ff
s28
	dc.b	$d1,$88,$31
	dc.b	$cb,$81,$3d,$cc,$3c,$3b,$3c
	dc.b	$cb,$82,$3d,$3d
	dc.b	$c6,$82,$3c,$3c,$84,$30,$c7,$30
	dc.b	$d1,$84,$31
	dc.b	$d1,$88,$31
	dc.b	$cb,$82,$37,$cc,$cb,$cc
	dc.b	$c6,$82,$3c,$3c,$84,$30,$c7,$30
	dc.b	$d5,$84,$31

	dc.b	$d1,$88,$31
	dc.b	$cb,$82,$3d,$cc
	dc.b	$cb,$82,$3d,$cc
	dc.b	$c8,$82,$37,$37
	dc.b	$c6,$82,$30,$3c,$c7,$30,$3c
	dc.b	$d1,$84,$31
	dc.b	$d1,$88,$31
	dc.b	$cb,$82,$3d,$cc,$3d
	dc.b	$c8,$81,$3a,$c9,$c8,$c9
	dc.b	$c6,$82,$3c,$24,$30,$3c
	dc.b	$c8,$82,$36,$c9,$81,$c9
	dc.b	$c8,$82,$36,$c9,$81,$c9

	dc.b	$d1,$88,$31
	dc.b	$cb,$81,$3d,$cc,$3c,$3b,$3c
	dc.b	$cb,$82,$3d,$3d
	dc.b	$c6,$82,$3c,$3c,$84,$30,$c7,$30
	dc.b	$d1,$84,$31
	dc.b	$d1,$88,$31
	dc.b	$cb,$82,$37,$cc,$cb,$cc
	dc.b	$c6,$82,$3c,$3c,$84,$30
	dc.b	$d5,$88,$31

	dc.b	$d1,$88,$31
	dc.b	$cb,$82,$3d,$cc
	dc.b	$cb,$82,$3d,$cc
	dc.b	$c8,$82,$37,$c9,$81,$c9
	dc.b	$c8,$82,$37,$c9
	dc.b	$d6,$88,$60,$30
	dc.b	$d1,$88,$31
	dc.b	$cb,$82,$3d,$cc,$3d
	dc.b	$cb,$82,$3d,$cc,$3d
	dc.b	$c6,$82,$3c,$24,$30,$3c
	dc.b	$c8,$81,$3a,$c9,$38,$36,$34,$32,$34,$36,$38
	dc.b	$ff
s29
	dc.b	$c8,$84,$35,$c9,$c8,$c9,$c8,$c9,$c8,$c9
	dc.b	$ff

;Sequ05

s2a
	dc.b	$c2,$84,$3a,$fb,$3c,$fb,$37,$fb,$30
	dc.b	$fb,$88,$33
	dc.b	$fb,$84,$35,$fb,$37,$fb,$38,$fb,$35,$fb,$31
	dc.b	$fb,$82,$30,$fb,$81,$31,$fb,$30
	dc.b	$fb,$8c,$2e,$fb,$82,$30,$fb,$31
	dc.b	$fb,$88,$33
	dc.b	$fb,$84,$35,$fb,$37
	dc.b	$fb,$88,$31,$fb,$38
	dc.b	$fb,$84,$30,$fb,$32,$fb,$82,$33,$fb,$81,$32,$fb,$33
	dc.b	$fb,$84,$30
	dc.b	$fb,$90,$2a
	dc.b	$fb,$84,$2b,$fb,$82,$30,$fb,$81,$2f,$fb,$30
	dc.b	$fb,$84,$32,$fb,$33
	dc.b	$fb,$2c,$fb,$82,$30,$fb,$81,$2f,$fb,$30,$fb,$84,$32,$fb,$33
	dc.b	$fb,$2e,$fb,$30,$fb,$32,$fb,$33
	dc.b	$fb,$35,$fb,$37,$fb,$82,$38,$fb,$81,$37,$fb,$38,$fb,$84,$3a
	dc.b	$fb,$82,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$81,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$81,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$82,$37,$fb,$38,$fb,$37,$fb,$38
	dc.b	$fb,$81,$37,$fb,$38,$fb,$3a,$fb,$3b
	dc.b	$fb,$81,$3c,$fb,$3b,$fb,$3a,$fb,$38
	dc.b	$fb,$cd,$a0,$37

	dc.b	$fb,$98,$38,$fb,$82,$37,$fb,$81,$38,$fb,$37,$fb,$84,$35
	dc.b	$fb,$88,$38,$fb,$82,$37,$fb,$81,$38,$fb,$37,$fb,$84,$35
	dc.b	$fb,$88,$38,$fb,$82,$37,$fb,$81,$38,$fb,$37,$fb,$84,$35
	dc.b	$fb,$98,$33,$fb,$82,$32,$fb,$81,$33,$fb,$32,$fb,$84,$30
	dc.b	$fb,$88,$32,$fb,$33,$fb,$35,$fb,$37
	dc.b	$ff
s2b
	dc.b	$c0,$a0,$24,$fb,$8c,$25,$fb,$84,$24,$fb,$90,$22
	dc.b	$fb,$90,$27,$fb,$25,$fb,$90,$24
	dc.b	$fb,$84,$1e,$fb,$2a,$fb,$c1,$1e,$fb,$2a
	dc.b	$fb,$c0,$90,$24,$fb,$20,$fb,$22,$fb,$84,$24,$fb,$26
	dc.b	$fb,$27,$fb,$29
	dc.b	$fb,$8f,$2b,$fb,$81,$2c
	dc.b	$fb,$87,$2b,$fb,$81,$2c
	dc.b	$fb,$84,$2b
	
	dc.b	$fb,$82,$29,$fb,$26
	dc.b	$fb,$87,$1f,$fb,$81,$20
	dc.b	$fb,$87,$1f,$fb,$81,$20
	dc.b	$fb,$90,$1f

	dc.b	$fb,$98,$25,$fb,$88,$27
	dc.b	$fb,$90,$29,$fb,$88,$1d,$fb,$1f
	dc.b	$fb,$98,$20,$fb,$88,$1d
	dc.b	$fb,$84,$1f,$fb,$82,$26,$fb,$29
	dc.b	$fb,$84,$27,$fb,$82,$26,$fb,$24
	dc.b	$fb,$84,$29,$fb,$82,$2b,$fb,$2c
	dc.b	$fb,$88,$2b
	dc.b	$ff
s2c
	dc.b	$c5,$82,$30,$fb,$33,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$35,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$33,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$35,$fb,$37,$fb,$3c
 	dc.b	$31,$fb,$35,$fb,$38,$fb,$3d
	dc.b	$fb,$31,$fb,$37,$fb,$38,$fb,$3d
 	dc.b	$2e,$fb,$31,$fb,$35,$fb,$3a
	dc.b	$fb,$31,$fb,$33,$fb,$35,$fb,$3a

	dc.b	$33,$fb,$35,$fb,$37,$fb,$3a
	dc.b	$fb,$33,$fb,$37,$fb,$38,$fb,$3a
	dc.b	$31,$fb,$33,$fb,$35,$fb,$38
	dc.b	$31,$fb,$35,$fb,$37,$fb,$38
	dc.b	$30,$fb,$33,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$35,$fb,$37,$fb,$3c
	dc.b	$31,$fb,$35,$fb,$36,$fb,$3d
	dc.b	$fb,$31,$fb,$35,$fb,$36,$fb,$3d
	dc.b	$30,$fb,$33,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$35,$fb,$37,$fb,$3c
	dc.b	$30,$fb,$33,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$35,$fb,$37,$fb,$3c

	dc.b	$2e,$fb,$32,$fb,$35,$fb,$3a
	dc.b	$fb,$2e,$fb,$33,$fb,$35,$fb,$3a
	dc.b	$32,$fb,$33,$fb,$35,$fb,$3a
	dc.b	$fb,$32,$fb,$33,$fb,$35,$fb,$3a

	dc.b	$82,$30,$fb,$32,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$32,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$32,$fb,$37,$fb,$3c
	dc.b	$fb,$30,$fb,$32,$fb,$37,$fb,$3c
	dc.b	$2f,$fb,$32,$fb,$37,$fb,$3b
	dc.b	$fb,$2f,$fb,$32,$fb,$37,$fb,$3b
	dc.b	$fb,$2f,$fb,$32,$fb,$37,$fb,$3b
	dc.b	$fb,$2f,$fb,$32,$fb,$37,$fb,$3b

	dc.b	$c7,$82,$31,$31,$82,$31,$d7,$25,$c7,$31,$d7,$25
	dc.b	$d8,$84,$2f,$86,$2f,$2f,$c7,$82,$33,$d7,$27
	dc.b	$c7,$82,$35,$35,$82,$35,$d7,$29,$c7,$35,$d7,$29
	dc.b	$d8,$82,$31,$31,$86,$31,$31,$c7,$82,$37,$d7,$2b
	dc.b	$c7,$82,$38,$38,$82,$38,$d7,$2c,$c7,$38,$d7,$2c
	dc.b	$d8,$84,$34,$86,$34,$34,$c7,$82,$37,$35
	dc.b	$37,$35,$37,$38,$37,$d7,$2b
	dc.b	$c7,$37,$d7,$2b
	dc.b	$d1,$88,$31
	dc.b	$d5,$88,$2e
	dc.b	$ff
s2d
	dc.b	$d1,$86,$32
	dc.b	$d8,$86,$31
	dc.b	$d8,$84,$31
	dc.b	$d8,$84,$31
	dc.b	$d1,$88,$32
	dc.b	$d8,$84,$31
	dc.b	$d8,$88,$31
	dc.b	$d8,$84,$31
	dc.b	$d1,$88,$32
	dc.b	$d8,$88,$31
	dc.b	$d8,$88,$31
	dc.b	$d8,$88,$31
	dc.b	$d8,$88,$31
	dc.b	$d8,$84,$31
	dc.b	$ff	

;Sequ06

s2e
	dc.b	$d1,$84,$31
	dc.b	$d8,$84,$31
	dc.b	$d1,$86,$32
	dc.b	$d8,$84,$31
	dc.b	$d8,$86,$31
	dc.b	$d1,$86,$32
	dc.b	$d8,$86,$31
	dc.b	$d1,$86,$32
	dc.b	$d8,$86,$31
	dc.b	$d1,$88,$32
	dc.b	$d1,$88,$32
	dc.b	$d1,$88,$32
	dc.b	$d1,$88,$32
	dc.b	$d1,$88,$32
	dc.b	$ff
s2f
	dc.b	$c0,$b8,$24
	dc.b	$c3,$81,$30,$fb,$31,$fb,$32,$fb,$33
	dc.b	$fb,$34,$fb,$35,$fb,$36,$fb,$37
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$35
	dc.b	$fb,$34,$fb,$33,$fb,$32,$fb,$31
	dc.b	$fb,$30,$fb,$31,$fb,$32,$fb,$33
	dc.b	$fb,$34,$fb,$35,$fb,$36,$fb,$37
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$35
	dc.b	$fb,$34,$fb,$33,$fb,$32,$fb,$31

	dc.b	$c0,$88,$23,$24,$25,$24,$25,$27,$28
	dc.b	$c6,$82,$36,$36,$36,$36,$37,$c7,$c6,$35,$c7
	dc.b	$c6,$82,$36,$36,$36,$36,$37,$c7,$c6,$35,$c7

	dc.b	$c0,$88,$29,$28,$29,$2b,$2c,$2f,$30
	dc.b	$c3,$81,$38,$fb,$37,$fb,$36,$fb,$37

	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$37
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$37
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$37
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$35
	dc.b	$fb,$34,$fb,$33,$fb,$32,$fb,$31
	dc.b	$fb,$30,$fb,$2f,$fb,$2e,$fb,$2d
	dc.b	$fb,$2c,$fb,$2b,$fb,$2a,$fb,$29

	dc.b	$c0,$88,$30,$2f,$30,$31,$34,$35,$37
	dc.b	$c6,$82,$36,$36,$36,$36,$37,$c7,$32,$c6,$35,$c7,$30
	dc.b	$c6,$82,$36,$36,$36,$36,$36,$34,$36,$c7,$36
	dc.b	$ff

;Load07

s30
	dc.b	$c0,$b0,$24,$fb,$92,$25,$fb,$81,$27,$fb,$25
	dc.b	$fb,$b0,$24,$fb,$92,$25,$fb,$81,$24,$fb,$25
	dc.b	$fb,$b0,$26,$fb,$92,$27,$fb,$81,$29,$fb,$27
	dc.b	$fb,$b0,$26,$fb,$92,$27,$fb,$81,$26,$fb,$27
	dc.b	$fb,$b0,$28,$fb,$92,$29,$fb,$81,$2b,$fb,$29
	dc.b	$fb,$b0,$28,$fb,$92,$29,$fb,$81,$28,$fb,$29
	dc.b	$fb,$b0,$2a,$fb,$92,$2b,$fb,$81,$2d,$fb,$2b
	dc.b	$fb,$b0,$2a,$fb,$92,$2b,$fb,$81,$29,$fb,$25
	dc.b	$ff
s31
	dc.b	$c7,$82,$30,$30,$3c,$30,$3c,$30,$30,$30,$3c,$30,$3c,$30
	dc.b	$3b,$3c,$3d,$3b
	dc.b	$3c,$30,$3c,$30,$3c,$30,$30,$3c,$3b,$3c,$30,$3d,$3c,$37
	dc.b	$36,$33,$3d,$31
	dc.b	$82,$30,$30,$3c,$30,$3c,$30,$30,$30,$3c,$30,$3c,$30
	dc.b	$3b,$3c,$3d,$3b
	dc.b	$3c,$30,$3c,$30,$3c,$30,$30,$3c,$3b,$3c,$30,$3d,$3c,$37
	dc.b	$36,$33,$3d,$31
	dc.b	$ff
s32
	dc.b	$c6,$84,$24,$24,$24,$24,$23,$84,$25,$c7
	dc.b	$c6,$84,$24,$c7
	dc.b	$c6,$84,$24,$24,$24,$23,$25,$27,$c7,$c6,$25
	dc.b	$c6,$84,$24,$24,$24,$24,$23,$84,$25,$c7
	dc.b	$c6,$84,$24,$c7
	dc.b	$c6,$84,$24,$24,$24,$23,$25,$27,$c7,$c6,$25
	dc.b	$ff
s33	
	dc.b	$c0,$a0,$2a,$fb,$2c,$fb,$2e,$fb,$2f
	dc.b	$ff
s34
	dc.b	$ce,$bf,$30,$fb,$c0,$bf,$30,$fb,$82,$30
	dc.b	$ff
s35
	dc.b	$c6,$8c,$24,$84,$2a
	dc.b	$c6,$8c,$24,$84,$2a
	dc.b	$c6,$8c,$24,$84,$2c
	dc.b	$c6,$8c,$24,$84,$2c
	dc.b	$c6,$8c,$24,$84,$2e
	dc.b	$c6,$8c,$24,$84,$2e
	dc.b	$c6,$8c,$24,$84,$2f
	dc.b	$c6,$8c,$24,$84,$2f
	dc.b	$ff

;Sequ08

s36
	dc.b	$c0,$a0,$24,$20,$21,$90,$28,$27
	dc.b	$c0,$a0,$26,$22,$23,$90,$2a,$29
	dc.b	$c0,$a0,$28,$fb,$28,$fb,$29,$fb,$29
	dc.b	$c0,$b0,$2b,$fb,$2b
	dc.b	$ff
s37
	dc.b	$d2,$a0,$30,$2c,$2d,$90,$34,$33
	dc.b	$d2,$a0,$32,$2e,$2f,$90,$36,$35
	dc.b	$d2,$a0,$34,$fb,$34,$fb,$38,$fb,$38
	dc.b	$d2,$b0,$3a,$fb,$3a
	dc.b	$ff
s38
	dc.b	$c6,$82,$24,$c7,$c6,$30,$c7,$c8,$33,$c9,$c6,$30,$c7
	dc.b	$c6,$24,$c7
	dc.b	$ff
s39
	dc.b	$d3,$81,$2b,$fb,$2c,$fb,$2d,$fb,$2e
	dc.b	$fb,$2f,$fb,$30,$fb,$31,$fb,$30
	dc.b	$fb,$2f,$fb,$2e,$fb,$2d,$fb,$2c
	dc.b	$ff
s3a
	dc.b	$c6,$82,$24,$c7,$c6,$30,$c7
	dc.b	$c6,$24,$c7,$c6,$30,$c7
	dc.b	$c6,$24,$c7,$c6,$30,$c7
	dc.b	$c6,$24,$c7,$c6,$30,$c7
	dc.b	$c2,$81,$3c,$fb,$3d,$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3b,$fb,$38,$fb,$37
	dc.b	$fb,$35,$fb,$31,$fb,$30,$fb,$2e
	dc.b	$ff

;Load09

s3b
 	dc.b	$ca,$86,$24,$24,$24,$83,$24,$86,$24,$83,$24,$24,$25
	dc.b	$ca,$8c,$24
 	dc.b	$c4,$86,$1e,$1e,$1e,$83,$1c,$86,$1e,$83,$1f,$21,$23
	dc.b	$c4,$83,$21,$fb,$1f,$fb,$1e,$fb,$1c
 	dc.b	$ca,$86,$24,$24,$24,$83,$24,$86,$24,$83,$24,$24,$25
	dc.b	$ca,$8c,$24
 	dc.b	$c4,$86,$1e,$1e,$1e,$83,$1f,$8b,$21
 	dc.b	$d3,$81,$28,$fb,$2a,$fb,$2c,$fb,$2d
 	dc.b	$fb,$2e,$fb,$2f,$fb,$30,$fb,$31
	dc.b	$ff
s3c
	dc.b	$c6,$86,$24,$24,$24,$83,$24,$86,$24,$83,$24,$24,$25
	dc.b	$c6,$86,$24,$c7
	dc.b	$c6,$86,$24,$c7,$c6,$c7,$c6,$c7,$c6,$c7
	dc.b	$c6,$86,$24,$24,$24,$83,$24,$86,$24,$83,$24,$24,$25
	dc.b	$c6,$86,$24,$c7
	dc.b	$c6,$83,$24,$c7,$c6,$30,$c7
	dc.b	$c6,$2b,$c7,$c6,$24,$c7
	dc.b	$c6,$84,$24,$c7,$24
	dc.b	$c6,$84,$25,$c7,$25
	dc.b	$ff
s3d
	dc.b	$cb,$83,$3d,$3d,$3d,$3d,$38,$cc,$cb,$cc
	dc.b	$cb,$83,$3a,$3a,$3a,$3a,$3c,$cc,$cb,$cc
	dc.b	$c8,$83,$3d,$3d,$3d,$3d,$38,$c9,$c8,$c9
	dc.b	$c8,$83,$3a,$3a,$3a,$3a,$3c,$c9,$c8,$c9
	dc.b	$cb,$83,$3d,$3d,$3d,$3d,$38,$cc,$cb,$cc
	dc.b	$cb,$83,$3a,$3a,$3a,$3a,$3c,$cc,$cb,$cc
	dc.b	$d1,$86,$33,$d8,$d1,$2e,$d8
	dc.b	$d1,$88,$33,$d8,$33
	dc.b	$ff

;Sequ09		

s3e
	dc.b	$c2,$82,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3b,$fb,$3a,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$35

	dc.b	$fb,$34,$fb,$35,$fb,$34,$fb,$35
	dc.b	$fb,$34,$fb,$35,$fb,$34,$fb,$35
	dc.b	$fb,$34,$fb,$35,$fb,$34,$fb,$35
	dc.b	$fb,$34,$fb,$35,$fb,$36,$fb,$37

	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$3a,$fb,$3b

	dc.b	$fb,$81,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3b,$fb,$3a,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$37,$fb,$36,$fb,$35

	dc.b	$fb,$34,$fb,$35,$fb,$34,$fb,$35
	dc.b	$fb,$34,$fb,$35,$fb,$34,$fb,$35
	dc.b	$fb,$34,$fb,$35,$fb,$34,$fb,$35
	dc.b	$fb,$34,$fb,$35,$fb,$36,$fb,$37

	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$38,$fb,$39
	dc.b	$fb,$38,$fb,$39,$fb,$3a,$fb,$3b

	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$82,$3c,$fb,$3d,$fb,$3c,$fb,$3d
	dc.b	$fb,$84,$3c,$fb,$3d
	dc.b	$fb,$3c,$fb,$3d
	dc.b	$ff
s3f
	dc.b	$d1,$88,$35,$33,$35,$33,$35,$33,$35,$33
	dc.b	$d1,$88,$35,$33,$35,$33,$35,$33,$35,$33
	dc.b	$d1,$84,$35,$33,$35,$33,$35,$33,$35,$33
	dc.b	$d1,$84,$35,$33,$35,$33,$35,$33,$35,$33
	dc.b	$d1,$84,$35,$33,$35,$33,$35,$33,$35,$33
	dc.b	$ff

;Load10

s40
	dc.b	$c2,$84,$3c,$fb,$37,$fb,$38,$fb,$35
	dc.b	$fb,$37,$fb,$30,$fb,$37,$fb,$30
	dc.b	$fb,$37,$fb,$30,$fb,$37,$fb,$30
	dc.b	$fb,$38,$fb,$37,$fb,$38,$fb,$3d

	dc.b	$fb,$3c,$fb,$37,$fb,$38,$fb,$35
	dc.b	$fb,$37,$fb,$30,$fb,$37,$fb,$30
	dc.b	$fb,$37,$fb,$35,$fb,$37,$fb,$3c
	dc.b	$fb,$88,$36
	dc.b	$fb,$81,$35,$fb,$34,$fb,$33,$fb,$32
	dc.b	$fb,$31,$fb,$30,$fb,$2f,$fb,$2e
	dc.b	$ff
s41
	dc.b	$c2,$84,$37,$fb,$30,$fb,$31,$fb,$2e
	dc.b	$fb,$30,$fb,$2b,$fb,$30,$fb,$2b
	dc.b	$fb,$33,$fb,$2b,$fb,$33,$fb,$2b
	dc.b	$fb,$33,$fb,$32,$fb,$33,$fb,$38

	dc.b	$fb,$37,$fb,$30,$fb,$31,$fb,$2e
	dc.b	$fb,$30,$fb,$2b,$fb,$30,$fb,$2b
	dc.b	$fb,$33,$fb,$32,$fb,$33,$fb,$37
	dc.b	$fb,$88,$31
	dc.b	$fb,$81,$30,$fb,$2f,$fb,$2e,$fb,$2d
	dc.b	$fb,$2c,$fb,$2b,$fb,$2a,$fb,$29
	dc.b	$ff
s42
	dc.b	$c6,$84,$30,$c7,$82,$30,$24,$30,$24
	dc.b	$c6,$84,$3c,$37,$30,$c7,$24,$c6,$30,$c7,$24
	dc.b	$c7,$82,$30,$24,$c7,$30,$24
	dc.b	$c6,$84,$3a,$38,$c7,$2c,$c6,$3a,$c7,$2e

	dc.b	$c6,$84,$30,$c7,$82,$30,$24,$30,$24
	dc.b	$c6,$84,$3c,$37,$30,$c7,$24,$c6,$30,$c7,$24
	dc.b	$c7,$82,$30,$24,$c7,$30,$24
	dc.b	$c6,$84,$3c,$36,$c7,$2a,$c6,$3a,$c7,$2e
	dc.b	$ff	
s43
	dc.b	$d1,$84,$33,$d8,$d8
	dc.b	$c8,$82,$30,$c9,$30
	dc.b	$c8,$81,$30,$c9,$30,$30,$30
	dc.b	$c8,$82,$30,$c9,$30
	dc.b	$c8,$81,$30,$c9,$30,$30,$30
	dc.b	$c8,$82,$30,$c9,$30

	dc.b	$d1,$84,$35,$d8,$35
	dc.b	$d1,$84,$33,$d8,$33
	dc.b	$c8,$82,$31,$31
	dc.b	$c8,$81,$30,$c9,$30,$30,$30
	dc.b	$c8,$82,$c9,$c8,$c8
	dc.b	$ff

;Sequ10

s44
	dc.b	$c0,$84,$30,$fb,$24,$fb,$30,$fb,$2b
	dc.b	$fb,$30,$fb,$2c,$fb,$30,$fb,$2e
	dc.b	$fb,$30,$fb,$24,$fb,$30,$fb,$2b
	dc.b	$fb,$30,$fb,$2c,$fb,$30,$fb,$2e
	dc.b	$ff
s45
	dc.b	$d1,$84,$33,$35
	dc.b	$c8,$81,$2d,$c9,$c9,$82,$2d,$c8,$c9
	dc.b	$d1,$84,$33,$35,$36,$37

	dc.b	$d1,$84,$33,$35
	dc.b	$c8,$81,$2d,$c9,$c9,$82,$2d,$c8,$c9
	dc.b	$d1,$82,$33,$34,$84,$35,$84,$31,$32
	dc.b	$ff
s46
	dc.b	$c4,$a0,$24,$fb,$2b,$fb,$2c,$fb,$30
	dc.b	$c4,$a0,$24,$fb,$2b,$fb,$2c,$fb,$31
	dc.b	$ff
s47
	dc.b	$c6,$82,$37,$c7
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37,$c7
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$38
	dc.b	$c6,$82,$38,$c7
	dc.b	$c6,$82,$38,$c7
	dc.b	$c6,$82,$35,$c7
	dc.b	$c6,$82,$37,$c7
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37,$c7
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$37
	dc.b	$c6,$82,$38,$35
	dc.b	$c6,$82,$31,$2c,$29
	dc.b	$c6,$82,$2b,$2c,$2b
	dc.b	$ff
s48
	dc.b	$c6,$82,$3c,$c7
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c,$c7
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3d
	dc.b	$c6,$82,$3d,$c7
	dc.b	$c6,$82,$3d,$c7
	dc.b	$c6,$82,$3a,$c7
	dc.b	$c6,$82,$3c,$c7
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c,$c7
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3c
	dc.b	$c6,$82,$3d,$3a
	dc.b	$c6,$82,$36,$31,$2e
	dc.b	$c6,$82,$30,$31,$30
	dc.b	$ff
s49
	dc.b	$c7,$82,$2b
	dc.b	$c6,$82,$2b
	dc.b	$c7,$82,$2b
	dc.b	$c6,$82,$2b
	dc.b	$c7,$82,$2b
	dc.b	$c6,$82,$2b
	dc.b	$c7,$82,$2b
	dc.b	$c6,$82,$2b
	dc.b	$c6,$82,$2c
	dc.b	$c6,$82,$2c
	dc.b	$c6,$82,$2b,$c7
	dc.b	$c6,$82,$29,$c7
	dc.b	$c6,$82,$2b,$c7
	dc.b	$d9,$bf,$24
	dc.b	$fe
s4a
	dc.b	$d1,$84,$35,$33,$31,$33
	dc.b	$d1,$84,$35,$33,$31,$33
	dc.b	$d1,$90,$33,$d8,$33,$fc,$10,$33,$fc,$08,$33
	dc.b	$fe
	
s4b
	dc.b	$c7,$82,$30
	dc.b	$c6,$82,$30
	dc.b	$c7,$82,$30
	dc.b	$c6,$82,$30
	dc.b	$c7,$82,$30
	dc.b	$c6,$82,$30
	dc.b	$c7,$82,$30
	dc.b	$c6,$82,$30
	dc.b	$c6,$82,$31
	dc.b	$c6,$82,$31
	dc.b	$c6,$82,$30,$c7
	dc.b	$c6,$82,$2e,$c7
	dc.b	$c6,$82,$30,$c7
	dc.b	$da,$bf,$24
	dc.b	$fe
s4c
s4d
s4e
s4f
s50
s51
s52
s53
s54
s55
s56
s57
s58
s59
s5a
s5b
s5c
s5d
s5e
s5f	dc.b	$f8,$f8,$f8,$f8,$ff

sq00	dc.b	$00,$ff,$00

s00	dc.b	$f1,$ff

StpExit	dc.b	$ff
;------------------------------------------------------------------------------

	cnop	$00,$04

DataMem	ds.b	$04*LabelEx

SampTab	ds.l	$1f*$03

SmpStrt
	incbin	"df0:samplesI/synth1"		;00
	incbin	"df0:samplesI/panfluteagony1"	;01
	incbin	"df0:samplesI/chorus1"		;02
	incbin	"df0:samplesI/xylofoon1"	;03
	incbin	"df0:samplesI/snare1"		;04
	incbin	"df0:samplesI/shaker1"		;05
	incbin	"df0:samplesI/megabass2"	;06
	incbin	"df0:samplesI/paukenreal1"	;07
	incbin	"df0:samplesI/timpanichorus1"	;08

SmpExit	dc.b	"EXIT"	



