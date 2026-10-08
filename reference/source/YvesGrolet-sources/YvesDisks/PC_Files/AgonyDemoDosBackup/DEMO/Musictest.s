
	section	chip,code_f

debug	set     0
asm_absolute	set	0

	include work:global/preset.s

	lea	Custom,a0
	move	#$7fff,d0
	move	d0,Dmacon(a0)
	move	d0,Intena(a0)
	move	d0,Intreq(a0)

	lea	dec,a0
	lea	$80,a1
reloc_d
	move.l	(a0)+,(a1)+
	cmp.l	#dec_end,a0
	blt	reloc_d

                  lea	$6b000,a0
	lea	table,a1
	moveq	#0,d0
	jsr	$80

	jsr     $6b000
	move.l	#$6b00c,$6c
	move	#%1100000000100000,Intena+Custom
                  move	#%1000001000000000,Dmacon+Custom

	WAIT_CLICK
	rts

table
	incbin  dh0:ag_demo_bin/music.crn
table_end

dec
                  incbin	work:agony/demo/decrunch.bin
dec_end



