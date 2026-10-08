
	section	chip,code_c

debug	set     0
asm_absolute	set	0

	include work:global/preset.s

	lea	Custom,a6

	move	#$7fff,d0
	move	d0,Intena(a6)
	move	d0,Intreq(a6)
	move	d0,Dmacon(a6)

	jsr	mt_init
	st	mt_Enable
	move	#64,Master_Vol

	move.l	#Int3,$6c
	move	#%1100000000100000,Intena+Custom
                  move	#%1000001000000000,Dmacon+Custom

	WAIT_CLICK
	rts


Int3
                  movem.l	d0-d7/a0-a6,-(sp)

	jsr     mt_music

	move	#%0000000000100000,Intreq+Custom
                  movem.l	(sp)+,d0-d7/a0-a6
	rte


	INCLUDE	Work:Agony/Ag_Music.s
Pt_Module
	INCBIN	Work:Agony/ST_Module/mod.loading_sea

