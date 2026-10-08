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












