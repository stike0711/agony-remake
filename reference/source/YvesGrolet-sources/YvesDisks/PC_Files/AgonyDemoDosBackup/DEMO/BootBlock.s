
*****************************************************************************
;                 Unreal Boot Block
*****************************************************************************

debug	set	0

	include	work:global/preset.s

compute_checksum
	lea	bbstart,a0
	lea	4(a0),a1
	clr.l	(a1)
	move	#$ff,d1
	moveq	#0,d0
cs_loop
	add.l	(a0)+,d0
	bcc	cs_cont
	addq.l	#1,d0
cs_cont
	dbra	d1,cs_loop
	not.l	d0
	move.l	d0,(a1)
	rts


BBSTART
	DC.B	'DOS',0		;DISK ID
	DC.L	0		;CHECKSUM
	DC.L	880		;ROOTBLOCK

;-------------------------------------------------------
;	START OF ROUTINE
;-------------------------------------------------------

	move	#$666,$dff180
	move	#$2,$1c(a1)
	move.l	#$40000-$200,$28(a1)
	move.l	#$2c00,$24(a1)
                  clr.l	$2c(a1)
	move.l	4,a6
	jsr	-456(a6)
	lea	Custom,a0
	move	#$7fff,d0
	move	d0,Dmacon(a0)
	move	d0,Intena(a0)
	move	d0,Intreq(a0)
	move	d0,Adkcon(a0)
	clr.l	Cop1lc(a0)
	move	d0,Copjmp1(a0)
                  lea     $400,sp
	lea	sup(pc),a0
	move.l	a0,$20.w
sup
	move.w	#$2700,sr
                  lea     $300,sp
	lea	$80,a0
	lea	decruncher(pc),a1
	lea	decend(pc),a2
loop
	move.l	(a1)+,(a0)+
	cmp.l	a2,a1
	blt	loop
	move.l	#bootend-bbend,d0
	lea	$40000,a1
	lea	$60000,a0
	jsr	$80
	jmp	$60000
DECRUNCHER
	incbin	work:agony/demo/decrunch.bin
DECEND
	ifne	(decend-bbstart)>$200
	fail	"no mem"
	ENDC
	ds.b	$200-(decend-bbstart)
BBEND
	incbin	work:agony/demo/boot.crn
BOOTEND







