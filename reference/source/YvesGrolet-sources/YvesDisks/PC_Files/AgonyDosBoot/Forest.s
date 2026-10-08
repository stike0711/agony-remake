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











MUSIC_INIT
	movem.l	d0-d7/a0-a6,-(a7)

	lea	Custom,a5
;....................................................................
; IFF-Sample-Header-Cruncher (sets samples in one block!)

	lea	SmpStrt(PC),a0
	lea	SmpStrt(PC),a1
	lea	SampTab(PC),a2

;	move.b	#$0c,Potgo(a5)

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
	moveq	#$0001,d7
	bsr	AudioIn
	moveq	#$0002,d6
	moveq	#$0002,d7
	bsr	AudioIn
	moveq	#$0003,d6
	moveq	#$0003,d7
	bsr	AudioIn
	movem.l	(a7)+,d0-d7/a0-a6
	rts









MUSIC_PLAY
	movem.l	d0-d7/a0-a6,-(a7)
	moveq	#$0001,d7
	bsr	AudioPl
	moveq	#$0002,d7
	bsr	AudioPl
	moveq	#$0003,d7
	bsr	AudioPl
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

a00	dc.b	2,1,0,$ff,$00
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

;c0 filmmegab1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$00
;c1 Paukenbass1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$01
;c2 Filmviolin1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$02
;c3 FilmDrum1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$03
;c4 FilmChord1
		dc.b	$40,$00,$00,$00
		dc.b	$00,$00,$00,$04
;c2 Fviolin1At
		dc.b	$40,$00,$00,$00
		dc.b	$00,$02,$80,$02
;--------------------------------------------LEVEL MUSIC-----------------------

sq01	dc.b	$a5,$01						;a
	dc.b	$a5,$04,$04					;b
	dc.b	$a5,$07,$07					;c
	dc.b	$a5,$0a						;d
	dc.b	$a5,$0d,$0d					;e
	dc.b	$a5,$10						;f
	dc.b	$ff,$00						

sq02	dc.b	$a5,$02						;a
	dc.b	$a5,$05						;b
	dc.b	$a5,$08,$08					;c
	dc.b	$a5,$0b						;d
	dc.b	$a5,$0e,$0e					;e
	dc.b	$a5,$11						;f
	dc.b	$ff,$00

sq03	dc.b	$a5,$03						;a
	dc.b	$a5,$06,$06					;b
	dc.b	$a5,$09,$09					;c
	dc.b	$a5,$0c						;d
	dc.b	$a5,$0f,$0f					;e
	dc.b	$a5,$12						;f
	dc.b	$ff,$00

sq04	dc.b	$98,$00						;a
	dc.b	$ff,$00

s01
	dc.b	$c0,$88,$2b
	dc.b	$c0,$88,$2c
	dc.b	$c0,$88,$2b
	dc.b	$c0,$90,$2c
	dc.b	$c2,$84,$25,$fb
	dc.b	$c2,$84,$2b,$fb
	dc.b	$c2,$84,$30,$fb
	dc.b	$c2,$84,$38,$fb,$fc,$10,$fb,$fc,$08,$38
	dc.b	$c0,$88,$2b
	dc.b	$c0,$88,$2c
	dc.b	$c0,$88,$2b
	dc.b	$c0,$90,$2c
	dc.b	$c2,$84,$25,$fb
	dc.b	$c2,$84,$2b,$fb
	dc.b	$c2,$84,$30,$fb
	dc.b	$c2,$84,$37,$fb,$fc,$10,$fb,$fc,$08,$37

	dc.b	$c0,$88,$2b
	dc.b	$c0,$84,$2b
	dc.b	$c0,$88,$2c
	dc.b	$c0,$88,$29
	dc.b	$c0,$88,$2b
	dc.b	$c0,$84,$2b
	dc.b	$c0,$88,$2e
	dc.b	$c0,$88,$2c
	dc.b	$c0,$88,$29
	dc.b	$c0,$84,$37
	dc.b	$c0,$84,$37
	dc.b	$c0,$84,$38
	dc.b	$c0,$88,$37
	dc.b	$c0,$88,$30
	dc.b	$c0,$88,$31
	dc.b	$c0,$88,$2e
	dc.b	$c0,$84,$30
	dc.b	$c0,$84,$31
	dc.b	$c0,$84,$2e
	dc.b	$c0,$88,$30
	dc.b	$ff
s02
	dc.b	$c0,$88,$1f
	dc.b	$c0,$88,$20
	dc.b	$c0,$88,$1f
	dc.b	$c0,$92,$20
	dc.b	$c2,$84,$29,$fb
	dc.b	$c2,$84,$2c,$fb
	dc.b	$c2,$84,$31,$fb
	dc.b	$c2,$84,$3a,$fb,$fc,$10,$fb,$fc,$08,$82,$3a
	dc.b	$c0,$88,$1f
	dc.b	$c0,$88,$20
	dc.b	$c0,$88,$1f
	dc.b	$c0,$92,$20
	dc.b	$c2,$84,$29,$fb
	dc.b	$c2,$84,$2c,$fb
	dc.b	$c2,$84,$31,$fb
	dc.b	$c2,$84,$38,$fb,$fc,$10,$fb,$fc,$08,$82,$38

	dc.b	$c1,$84,$30,$fc,$20,$30
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$31,$fc,$20,$31
	dc.b	$c1,$84,$2e,$fc,$20,$2e
	dc.b	$c1,$84,$30,$fc,$20,$30
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$33,$fc,$20,$33
	dc.b	$c1,$84,$31,$fc,$20,$31
	dc.b	$c1,$84,$2e,$fc,$20,$2e
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$31
	dc.b	$c1,$84,$30,$fc,$20,$30
	dc.b	$c1,$84,$29,$fc,$20,$29
	dc.b	$c1,$84,$2a,$fc,$20,$2a
	dc.b	$c1,$84,$27,$fc,$20,$27
	dc.b	$c1,$84,$29
	dc.b	$c1,$84,$2a
	dc.b	$c1,$84,$27
	dc.b	$c1,$84,$29,$fc,$20,$29
	dc.b	$ff
s03
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$24
	dc.b	$c1,$84,$31
	dc.b	$c1,$84,$25
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$24
	dc.b	$c1,$84,$31
	dc.b	$c1,$84,$25
	dc.b	$fc,$10,$84,$31
	dc.b	$fc,$10,$84,$25
	dc.b	$c1,$98,$19
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$24
	dc.b	$c1,$84,$31
	dc.b	$c1,$84,$25
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$24
	dc.b	$c1,$84,$31
	dc.b	$c1,$84,$25
	dc.b	$fc,$10,$84,$31
	dc.b	$fc,$10,$84,$25
	dc.b	$c0,$8c,$27
	dc.b	$c0,$8c,$29

	dc.b	$c0,$88,$32
	dc.b	$c0,$84,$32
	dc.b	$c0,$88,$33
	dc.b	$c0,$88,$30
	dc.b	$c0,$88,$32
	dc.b	$c0,$84,$32
	dc.b	$c0,$88,$35
	dc.b	$c0,$88,$33
	dc.b	$c0,$88,$30
	dc.b	$c0,$84,$32
	dc.b	$c0,$84,$32
	dc.b	$c0,$84,$33
	dc.b	$c0,$88,$32
	dc.b	$c1,$88,$30
	dc.b	$c1,$88,$31
	dc.b	$c1,$88,$2e
	dc.b	$c1,$84,$30
	dc.b	$c1,$84,$31
	dc.b	$c1,$84,$2e
	dc.b	$c1,$88,$30
	dc.b	$ff
s04
	dc.b	$c3,$8c,$30
	dc.b	$c3,$86,$30
	dc.b	$fc,$20,$82,$30
	dc.b	$c3,$86,$30
	dc.b	$c3,$86,$30
	dc.b	$c3,$8c,$30
	dc.b	$c3,$84,$30
	dc.b	$c3,$84,$30
	dc.b	$c3,$84,$30
	dc.b	$c3,$88,$30
	dc.b	$ff
s05
	dc.b	$c0,$90,$2b
	dc.b	$c5,$bc,$30,$fb
	dc.b	$c2,$94,$30,$fb
	dc.b	$c2,$a0,$30
	dc.b	$ff
s06
	dc.b	$c3,$88,$31
	dc.b	$fc,$10,$88,$30
	dc.b	$fc,$10,$88,$30
	dc.b	$c3,$84,$30
	dc.b	$c3,$84,$30
	dc.b	$c3,$88,$31
	dc.b	$fc,$10,$88,$30
	dc.b	$c3,$84,$31
	dc.b	$c3,$84,$31
	dc.b	$c3,$88,$31
	dc.b	$ff
s07
	dc.b	$c4,$88,$30
	dc.b	$c4,$84,$30
	dc.b	$c4,$88,$31
	dc.b	$c4,$84,$30
	dc.b	$c4,$84,$31
	dc.b	$c4,$84,$34
	dc.b	$c4,$84,$35
	dc.b	$c4,$84,$34
	dc.b	$c4,$84,$31
	dc.b	$c4,$88,$30
	dc.b	$c4,$84,$30
	dc.b	$c4,$84,$31
	dc.b	$c4,$84,$34
	dc.b	$c4,$84,$35
	dc.b	$c4,$84,$38
	dc.b	$c4,$84,$35
	dc.b	$c4,$84,$34
	dc.b	$c4,$84,$30
	dc.b	$c4,$84,$31
	dc.b	$fc,$10,$30
	dc.b	$fc,$20,$30
	dc.b	$fc,$20,$31
	dc.b	$fc,$08,$30
	dc.b	$fc,$10,$30
	dc.b	$fc,$10,$31
	dc.b	$fc,$04,$30
	dc.b	$fc,$08,$30
	dc.b	$fc,$08,$31
	dc.b	$fc,$02,$30
	dc.b	$ff	
s08
	dc.b	$c2,$a0,$30,$fb
	dc.b	$c2,$a0,$30,$fb
	dc.b	$c2,$a0,$30,$fb
	dc.b	$c2,$a0,$30
	dc.b	$ff
s09
	dc.b	$c1,$88,$30,$30,$30,$84,$30,$31
	dc.b	$c1,$88,$30,$30,$30,$84,$30,$2f
	dc.b	$c1,$88,$30,$30,$30,$84,$30,$31
	dc.b	$c1,$88,$30,$30,$30,$84,$30,$2e
	dc.b	$ff
s0a
	dc.b	$c1,$84,$30,$2f,$31,$2f
	dc.b	$c1,$84,$30,$2f,$31,$2f
	dc.b	$c1,$84,$30,$2f,$31,$2f
	dc.b	$c1,$84,$30,$2f,$31,$2f
	dc.b	$c1,$84,$30,$2f,$31,$2f
	dc.b	$c1,$84,$30,$2f,$31,$2f
	dc.b	$c1,$86,$30
	dc.b	$c0,$86,$30
	dc.b	$c0,$84,$32
	dc.b	$c0,$84,$33
	dc.b	$c0,$84,$30
	dc.b	$c0,$88,$32
	dc.b	$ff	
s0b
	dc.b	$c0,$88,$2b,$2b,$2b,$84,$2b,$2a
	dc.b	$c0,$88,$2b,$2b,$2b,$84,$2b,$2c
	dc.b	$c0,$88,$2b,$2b,$2b,$84,$2b,$2a
	dc.b	$c0,$86,$2b
	dc.b	$c3,$86,$30,$84,$30,$30,$30,$88,$30
	dc.b	$ff
s0c
	dc.b	$c4,$88,$30,$30,$30,$84,$30,$31
	dc.b	$c4,$88,$30,$30,$30,$84,$30,$2f
	dc.b	$c4,$88,$30,$30,$30,$84,$30,$31
	dc.b	$c4,$86,$30
	dc.b	$c3,$86,$31,$84,$31,$31,$31,$88,$31
	dc.b	$ff
s0d
	dc.b	$c0,$88,$2b,$fc,$20,$fc,$10,$fc,$08,$2b
	dc.b	$c2,$a0,$28,$27,$8c,$28
	dc.b	$c0,$84,$2b,$86,$2b,$29,$84,$2c
	dc.b	$ff
s0e
	dc.b	$c2,$a2,$2b,$a0,$2c,$2d,$9e,$2c
	dc.b	$ff
s0f
	dc.b	$c3,$8c,$30,$84,$30,$8c,$30,$84,$30,$8c,$30,$84,$30
	dc.b	$c3,$88,$30,$31
	dc.b	$c3,$8c,$30,$84,$30,$8c,$30,$84,$30,$8c,$30,$84,$30
	dc.b	$c3,$86,$30,$2e,$84,$31
	dc.b	$ff
s10
	dc.b	$c0,$8c,$2b,$2c,$88,$2e,$8c,$2c,$2b,$88,$29
	dc.b	$c0,$88,$2b,$2a,$2c,$2a
	dc.b	$c0,$84,$2b,$2a,$2c,$2a
	dc.b	$c0,$84,$37,$36,$38,$36
	dc.b	$ff
s11
	dc.b	$c2,$a0,$30,$fb
	dc.b	$c2,$9a,$30
	dc.b	$c2,$82,$31,$35,$36
	dc.b	$c2,$88,$37,$36,$38,$36
	dc.b	$c2,$84,$37,$36,$38,$36
	dc.b	$c2,$82,$30,$37,$36,$37,$38,$37,$36,$37
	dc.b	$ff
s12
	dc.b	$c0,$8c,$1f,$20,$88,$22,$8c,$20,$1f,$88,$1d
	dc.b	$c0,$88,$1f,$1e,$20,$1e
	dc.b	$c0,$88,$1f,$20,$2b,$2c
	dc.b	$ff
s13
s14
s15
s16
s17
s18
s19
s1a
s1b
s1c
s1d
s1e
s1f
s20
s21
s22
s23
s24
s25
s26
s27
s28
s29
s2a
s2b
s2c
s2d
s2e
s2f
s30
s31
s32
s33
s34
s35
s36
s37
s38
s39
s3a
s3b
s3c
s3d
s3e
s3f
s40
s41
s42
s43
s44
s45
s46
s47
s48
s49
s4a
s4b
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

SampTab	ds.l	$02*$03

SmpStrt
	incbin	"Work:Agony/Muzack/samples2/l1.filmmegabass1"		;00
	incbin	"Work:Agony/Muzack/samples2/l1.paukenbass1"		;01
	incbin	"Work:Agony/Muzack/samples2/l1.filmviolin1"		;02
	incbin	"Work:Agony/Muzack/samples2/l1.filmdrum1"		;03
	incbin	"Work:Agony/Muzack/samples2/l1.filmchord1"		;04
;	incbin	"Work:Agony/Muzack/samples2/        "		;05
;	incbin	"Work:Agony/Muzack/samples2/        "		;06
;	incbin	"Work:Agony/Muzack/samples2/        "		;07
;	incbin	"Work:Agony/Muzack/samples2/        "		;08
;	incbin	"Work:Agony/Muzack/samples2/        "		;09
;	incbin	"Work:Agony/Muzack/samples2/        "		;0a
;	incbin	"Work:Agony/Muzack/samples2/        "		;0b
;	incbin	"Work:Agony/Muzack/samples2/        "		;0c
;	incbin	"Work:Agony/Muzack/samples2/        "		;0d
;	incbin	"Work:Agony/Muzack/samples2/        "		;0e
;	incbin	"Work:Agony/Muzack/samples2/        "		;0f

SmpExit	dc.b	"EXIT"	



