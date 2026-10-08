*****************************************
* Great Courts¿                         *
* ------------------------------------- *
* Company:  ½Blue Byte                  *
* ------------------------------------- *
* Author:    Lothar Schmitt             *
* ------------------------------------- *
* Start:     05.03.1989                 *
* Ende:      02.06.1989                 *
* Letzte:    02.06.1989                 *
* ------------------------------------- *
*****************************************

                OPT W-
                PATH 'D:\TENNIS\INCLUDES'
                DEFAULT 7
TEST:           EQU 0                   ; Ausgabe von Daten
SAVESCREEN:     EQU 0                   ; Bildschirmdaten speichern
RECEIVE:        EQU 0                   ; Bewegung des Platzes aufnehmen
REPLAY:         EQU 0                   ; Aufzeichnung vom JoyStick
;* Colorvalues
BLUE:           EQU $0000000f
GREEN:          EQU $000000f0
RED:            EQU $00000f00
GREY:           EQU $00000888
WHITE:          EQU $00000fff
BLACK:          EQU $00
PINK:           EQU $00000a0a
YELLOW:         EQU $00000cc0

; Hard-REGS
CUSTOM:         EQU $00dff000
COLOR00:        EQU $00000180
DIWSTRT:        EQU $0000008e
DIWSTOP:        EQU $00000090
DDFSTRT:        EQU $00000092
DDFSTOP:        EQU $00000094
BPL1PTH:        EQU $000000e0
BPL1PTL:        EQU $000000e2
BPL2PTH:        EQU $000000e4
BPL2PTL:        EQU $000000e6
BPL3PTH:        EQU $000000e8
BPL3PTL:        EQU $000000ea
BPL4PTH:        EQU $000000ec
BPL4PTL:        EQU $000000ee
BPL5PTH:        EQU $000000f0
BPL5PTL:        EQU $000000f2
BPL6PTH:        EQU $000000f4
BPL6PTL:        EQU $000000f6
COP1LCH:        EQU $00000080
COP1LCL:        EQU $00000082
COPJMP1:        EQU $00000088
COP2LCH:        EQU $00000084
COP2LCL:        EQU $00000086
COPJMP2:        EQU $0000008a
BPLCON0:        EQU $00000100
BPLCON1:        EQU $00000102
BPLCON2:        EQU $00000104
BPL1MOD:        EQU $00000108
BPL2MOD:        EQU $0000010a
BLTCON0:        EQU $00000040
BLTCON1:        EQU $00000042
BLTCPTH:        EQU $00000048
BLTCPTL:        EQU $0000004a
BLTBPTH:        EQU $0000004c
BLTBPTL:        EQU $0000004e
BLTAPTH:        EQU $00000050
BLTAPTL:        EQU $00000052
BLTDPTH:        EQU $00000054
BLTDPTL:        EQU $00000056
BLTCMOD:        EQU $00000060
BLTBMOD:        EQU $00000062
BLTAMOD:        EQU $00000064
BLTDMOD:        EQU $00000066
BLTSIZE:        EQU $00000058
BLTADAT:        EQU $00000074
BLTBDAT:        EQU $00000072
BLTCDAT:        EQU $00000070
BLTAFWM:        EQU $00000044
BLTALWM:        EQU $00000046
DMACON:         EQU $00000096
DMACONR:        EQU 2
INTREQ:         EQU $0000009c
INTREQR:        EQU $0000001e
INTENA:         EQU $0000009a
INTENAR:        EQU $0000001c
CLXDAT:         EQU $0000000e
CLXCON:         EQU $00000098
VHPOSR:         EQU 4
ADKCON:         EQU $0000009e
ADKCONR:        EQU $00000010
AUD0LCH:        EQU $000000a0
AUD0LEN:        EQU $000000a4
AUD0PER:        EQU $000000a6
AUD0VOL:        EQU $000000a8
AUD0DAT:        EQU $000000aa
AUD1DAT:        EQU $000000ba
AUD2DAT:        EQU $000000ca
AUD3DAT:        EQU $000000da

; Input

JOY0DAT:        EQU $00dff00a
JOYTEST:        EQU $00000036
CIAAPRA:        EQU $00bfe001
KEYB:           EQU $00bfec01
CONT:           EQU $00bfee01
INTCON:         EQU $00bfed01
JOY1DAT:        EQU $00dff00c
POTGOR:         EQU $00dff016
DATLY:          EQU 10

;* Notwendigste Offsets fuer Amiga-Exec

ALLOCMEM:       EQU -198
FREEMEM:        EQU -210
AVAILMEM:       EQU -216
OPENLIBRARY:    EQU -552
CLOSELIBRARY:   EQU -414
DISABLE:        EQU -120
ENABLE:         EQU -126
FORBID:         EQU -132
PERMIT:         EQU -138

;* Offsets fuer dos.library
OPEN:           EQU -30
CLOSE:          EQU -36
READ:           EQU -42
WRITE:          EQU -48
LOCK:           EQU -84
UNLOCK:         EQU -90
EXAMINE:        EQU -102
EXNEXT:         EQU -108
EXIT:           EQU -144

;* Offsets fuer Graphics.Library
OWNBLITTER:     EQU -456
DISOWNBLITTER:  EQU -462

;* Konstantendefinitionen fuer Screen
BITPLANES:      EQU 5                   ; 5 Bitplanes bei 3D-Darstellung
MAXPLANES:      EQU 6                   ; Maximal darstellbare Planes

HORBEAM:        EQU 106                 ; Horizontale Austastluecke
VERTBEAM:       EQU 25                  ; Vertikale Austastluecke

WIDTH:          EQU 320                 ; Breite des Screens
HEIGHT:         EQU 200                 ; Hoehe des Screens

CLEARSIZE:      EQU $0000fa14           ; 20 Words*400 Lines ( Loeschen )
CLEARTERM:      EQU $00000100           ; Only D ( Loeschen )

LEFTX:          EQU 0                   ; Clip-Coordinates
RIGHTX:         EQU WIDTH-1
UPY:            EQU 0
DOWNY:          EQU HEIGHT-1

MEMSET:         EQU $00010003           ; Public+Chip+Clear
MEMSET1:        EQU $00010001           ; Only Public + Clear
MAXCHIP:        EQU $00080000           ; Obere Grenze des ChipRams

* Definitionen fuer 3 D-Berechnung

W1:             EQU 70
W2:             EQU 0
W3:             EQU 0
DIS:            EQU 0
VH:             EQU 0
XPO:            EQU 0
MX:             EQU 161
MY:             EQU 100
POINTS:         EQU 8
RHO:            EQU 1010
DIST:           EQU 340
MMX:            EQU MX+XPO
MMY:            EQU MY-VH

TURNVALUE:      EQU 1

* Definitionen der Blitterdaten beim LinieZeichnen

LINEMASK:       EQU $0000ffff
FULLSET:        REG d0-a6

; Offsettabelle fuer AMIGA Objekte.
;-------------------------------------
; Projekt : THEGTOOL
;  Ordner : D:\TENNIS\GRAFIK\
;     vom : 15.04.1989  02:18:10

RACKET1:        EQU $00000004           ; Racket-Dummy
RACKET2:        EQU $0000004a

; Offsettabelle fuer AMIGA Objekte.           ; Replay-Zeichen und Rep-Ball
;-------------------------------------
; Projekt : THEGTOOL
;  Ordner : D:\TENNIS\GRAFIK\
;     vom : 09.04.1989  10:36:50

REP1:           EQU $00000004
REP2:           EQU $00000064
REP3:           EQU $0000011c
REP4:           EQU $000001f4
REP5:           EQU $000002ec
BALLR1:         EQU $000003fc
BALLR2:         EQU $0000043a
BALLR3:         EQU $0000046e

; Offsettabelle fuer AMIGA Objekte.           ; Ball-Animationen
;-------------------------------------        ; Ball fuer Score
; Projekt : THEGTOOL                          ; SpielBall + Schatten
;  Ordner : D:\TENNIS\GRAFIK\ALLBALL\         ; BallAnim Ende
;     vom : 24.05.1989  19:46:06              ; BallMaschine !

BAEND1:         EQU $00000004
BAEND10:        EQU $000002b0
BAEND2:         EQU $0000055c
BAEND3:         EQU $00000808
BAEND4:         EQU $00000ab4
BAEND5:         EQU $00000d60
BAEND6:         EQU $0000100c
BAEND7:         EQU $000012b8
BAEND8:         EQU $00001564
BAEND9:         EQU $00001810
BAG11:          EQU $00001abc
BAG12:          EQU $00001b2a
BAG13:          EQU $00001b98
BAG14:          EQU $00001c06
BAG15:          EQU $00001c74
BAG16:          EQU $00001ce2
BAG17:          EQU $00001d50
BAG21:          EQU $00001dbe
BAG22:          EQU $00001e16
BAG23:          EQU $00001e6e
BAG24:          EQU $00001ec6
BAG25:          EQU $00001f1e
BAG26:          EQU $00001f76
BAG27:          EQU $00001fce
BAG31:          EQU $00002026
BAG32:          EQU $0000206a
BAG33:          EQU $000020ae
BAG34:          EQU $000020f2
BAG35:          EQU $00002136
BAG36:          EQU $0000217a
BAG37:          EQU $000021be
BSCR1:          EQU $00002202
BSCR10:         EQU $0000248a
BSCR11:         EQU $00002712
BSCR12:         EQU $0000299a
BSCR13:         EQU $00002c22
BSCR14:         EQU $00002eaa
BSCR15:         EQU $00003132
BSCR16:         EQU $000033ba
BSCR17:         EQU $00003642
BSCR18:         EQU $000038ca
BSCR2:          EQU $00003b52
BSCR3:          EQU $00003dda
BSCR4:          EQU $00004062
BSCR5:          EQU $000042ea
BSCR6:          EQU $00004572
BSCR7:          EQU $000047fa
BSCR8:          EQU $00004a82
BSCR9:          EQU $00004d0a
BSH1:           EQU $00004f92
BSH2:           EQU $00005000
BSH3:           EQU $00005058
FADENKR:        EQU $0000509c
L1REF:          EQU $00005126
L2REF:          EQU $00005372
LREF1:          EQU $000055be
LREF2:          EQU $000056a2
LREF3:          EQU $00005786
MASCHINE:       EQU $0000586a
MREF:           EQU $00005944
MREF1:          EQU $00005ed8
MREF2:          EQU $00005f62
MREF3:          EQU $00005fec
NREF:           EQU $00006076
NREF1:          EQU $00006326
NREF2:          EQU $00006388
NREF3:          EQU $000063ea

; Offsettabelle fuer AMIGA Objekte.           ; Aufschlag ( Spieler 1+2)
;-------------------------------------
; Projekt : THEGTOOL
;  Ordner : D:\TENNIS\GRAFIK\PLAYER\OBJECTS\
;     vom : 12.06.1989  20:55:58

AA1:            EQU $00000004
AA10:           EQU $000003c0
AA11:           EQU $0000094c
AA12:           EQU $00000ea8
AA13:           EQU $00001234
AA14:           EQU $000015c0
AA2:            EQU $0000194c
AA3:            EQU $00001d38
AA4:            EQU $000021b4
AA5:            EQU $00002920
AA6:            EQU $0000313c
AA7:            EQU $00003698
AA8:            EQU $00003bc4
AA9:            EQU $00003f50
AB1:            EQU $00004614
AB10:           EQU $00004740
AB2:            EQU $00004874
AB3:            EQU $00004ae0
AB4:            EQU $00004d6c
AB5:            EQU $00004ec0
AB6:            EQU $000050fc
AB7:            EQU $00005348
AB8:            EQU $000055c4
AB9:            EQU $00005750
DUPA1:          EQU $0000587c
DUPA2:          EQU $00005c28
DUPA3:          EQU $00005fd4
DUPA4:          EQU $00006380
DUPB1:          EQU $0000672c
DUPB2:          EQU $00006858
DUPB3:          EQU $00006984
DUPB4:          EQU $00006ab0

; Offsettabelle fuer AMIGA Objekte.
;-------------------------------------
; Projekt : THEGTOOL
;  Ordner : D:\TENNIS\GRAFIK\PLAYER\OBJS\
;     vom : 02.07.1989  17:55:56

LNA1:           EQU $00000004
LNA10:          EQU $000001c8
LNA11:          EQU $00000370
LNA12:          EQU $000004dc
LNA13:          EQU $00000660
LNA2:           EQU $000007cc
LNA3:           EQU $00000b68
LNA4:           EQU $00000d1c
LNA5:           EQU $00001098
LNA6:           EQU $0000123c
LNA7:           EQU $00001598
LNA8:           EQU $0000172c
LNA9:           EQU $00001a68
LNOA1:          EQU $00001bec
LNOA10:         EQU $00001f58
LNOA11:         EQU $00002274
LNOA12:         EQU $000023e8
LNOA13:         EQU $00002574
LNOA14:         EQU $000026f0
LNOA15:         EQU $000029fc
LNOA16:         EQU $00002b70
LNOA17:         EQU $00002ce4
LNOA18:         EQU $00002e58
LNOA19:         EQU $00003124
LNOA2:          EQU $00003290
LNOA3:          EQU $0000362c
LNOA4:          EQU $000037e0
LNOA5:          EQU $000039a4
LNOA6:          EQU $00003d00
LNOA7:          EQU $0000406c
LNOA8:          EQU $00004214
LNOA9:          EQU $000043c0
LNWA1:          EQU $000046ac
LNWA10:         EQU $00004a18
LNWA11:         EQU $00004d44
LNWA12:         EQU $00004eb8
LNWA13:         EQU $00005044
LNWA14:         EQU $00005320
LNWA15:         EQU $0000562c
LNWA16:         EQU $000057a0
LNWA17:         EQU $00005914
LNWA18:         EQU $00005be0
LNWA19:         EQU $00005eac
LNWA2:          EQU $00006018
LNWA3:          EQU $000063b4
LNWA4:          EQU $00006568
LNWA5:          EQU $0000673c
LNWA6:          EQU $00006a98
LNWA7:          EQU $00006e04
LNWA8:          EQU $00006fac
LNWA9:          EQU $00007158
LSB1:           EQU $00007444
LSB10:          EQU $00007578
LSB11:          EQU $000076cc
LSB12:          EQU $00007820
LSB13:          EQU $00007974
LSB2:           EQU $00007ac8
LSB3:           EQU $00007bf4
LSB4:           EQU $00007d28
LSB5:           EQU $00007e5c
LSB6:           EQU $00007f98
LSB7:           EQU $000080dc
LSB8:           EQU $00008220
LSB9:           EQU $00008364
LSOA1:          EQU $000084b0
LSOA10:         EQU $00008624
LSOA11:         EQU $000087b0
LSOA12:         EQU $00008acc
LSOA13:         EQU $00008c60
LSOA14:         EQU $00008df4
LSOA15:         EQU $00008f90
LSOA16:         EQU $000092dc
LSOA17:         EQU $00009488
LSOA18:         EQU $000097d4
LSOA19:         EQU $00009990
LSOA2:          EQU $00009d0c
LSOA3:          EQU $00009e78
LSOA4:          EQU $00009fec
LSOA5:          EQU $0000a158
LSOA6:          EQU $0000a2cc
LSOA7:          EQU $0000a440
LSOA8:          EQU $0000a72c
LSOA9:          EQU $0000a8b0
LSOB1:          EQU $0000aa3c
LSOB10:         EQU $0000ab78
LSOB11:         EQU $0000acc4
LSOB12:         EQU $0000ae18
LSOB13:         EQU $0000af64
LSOB14:         EQU $0000b0b0
LSOB15:         EQU $0000b204
LSOB16:         EQU $0000b36a
LSOB17:         EQU $0000b4be
LSOB18:         EQU $0000b60a
LSOB19:         EQU $0000b75e
LSOB2:          EQU $0000b8c4
LSOB20:         EQU $0000b9f8
LSOB3:          EQU $0000bb4c
LSOB4:          EQU $0000bc88
LSOB5:          EQU $0000bdbc
LSOB6:          EQU $0000bef0
LSOB7:          EQU $0000c02c
LSOB8:          EQU $0000c170
LSOB9:          EQU $0000c2ac
LSWA1:          EQU $0000c3f0
LSWA10:         EQU $0000c564
LSWA11:         EQU $0000c6f0
LSWA12:         EQU $0000ca0c
LSWA13:         EQU $0000cba0
LSWA14:         EQU $0000cd34
LSWA15:         EQU $0000ced0
LSWA16:         EQU $0000d21c
LSWA17:         EQU $0000d3c8
LSWA18:         EQU $0000d714
LSWA19:         EQU $0000d8d0
LSWA2:          EQU $0000dc4c
LSWA3:          EQU $0000ddb8
LSWA4:          EQU $0000df24
LSWA5:          EQU $0000e090
LSWA6:          EQU $0000e204
LSWA7:          EQU $0000e378
LSWA8:          EQU $0000e664
LSWA9:          EQU $0000e7e8
LSWB1:          EQU $0000e974
LSWB10:         EQU $0000eab0
LSWB11:         EQU $0000ebfc
LSWB12:         EQU $0000ed50
LSWB13:         EQU $0000ee9c
LSWB14:         EQU $0000efe8
LSWB15:         EQU $0000f13c
LSWB16:         EQU $0000f298
LSWB17:         EQU $0000f3ec
LSWB18:         EQU $0000f538
LSWB19:         EQU $0000f68c
LSWB2:          EQU $0000f7e8
LSWB20:         EQU $0000f91c
LSWB3:          EQU $0000fa70
LSWB4:          EQU $0000fbac
LSWB5:          EQU $0000fce0
LSWB6:          EQU $0000fe14
LSWB7:          EQU $0000ff50
LSWB8:          EQU $00010094
LSWB9:          EQU $000101d0
RA11:           EQU $00010314
RA12:           EQU $00010690
RA13:           EQU $00010bec
RA14:           EQU $00010fa4
RA21:           EQU $00011880
RA22:           EQU $00011bac
RA23:           EQU $00011ee8
RA24:           EQU $00012224
RA31:           EQU $00012858
RA32:           EQU $00012b54
RA33:           EQU $00012e60
RA34:           EQU $0001315c
RA41:           EQU $00013748
RA42:           EQU $00013a04
RA43:           EQU $00013cd0
RA44:           EQU $00013f8c
RB11:           EQU $000144d0
RB12:           EQU $0001474c
RB13:           EQU $000149d8
RB14:           EQU $00014c64
RB21:           EQU $000150e8
RB22:           EQU $00015344
RB23:           EQU $000155a0
RB24:           EQU $0001581c
RB31:           EQU $00015b18
RB32:           EQU $00015d44
RB33:           EQU $00015f80
RB34:           EQU $000161cc
SA11:           EQU $00016498
SA12:           EQU $00016834
SA13:           EQU $00016be0
SA14:           EQU $00016f7c
SA21:           EQU $00017308
SA22:           EQU $00017664
SA23:           EQU $000179d0
SA24:           EQU $00017d2c
SA31:           EQU $00018078
SA32:           EQU $00018384
SA33:           EQU $0001852c
SA34:           EQU $00018838
SA41:           EQU $00018b44
SA42:           EQU $00018ca8
SA43:           EQU $00018e14
SA44:           EQU $00018f78
SB11:           EQU $00019214
SB12:           EQU $00019490
SB13:           EQU $000195dc
SB14:           EQU $00019728
SB21:           EQU $00019874
SB22:           EQU $000199a8
SB23:           EQU $00019ae4
SB24:           EQU $00019c18
SB31:           EQU $00019d4c
SB32:           EQU $00019e80
SB33:           EQU $00019fb4
SB34:           EQU $0001a0e8
VA11:           EQU $0001a21c
VA12:           EQU $0001a5c8
VA13:           EQU $0001ab24
VA14:           EQU $0001aee0
VA21:           EQU $0001b29c
VA22:           EQU $0001b5e8
VA23:           EQU $0001bacc
VA24:           EQU $0001be28
VA31:           EQU $0001c194
VA32:           EQU $0001c4a0
VA33:           EQU $0001c924
VA34:           EQU $0001cc50
VA41:           EQU $0001cf7c
VA42:           EQU $0001d238
VA43:           EQU $0001d4f4
VA44:           EQU $0001d7d0
VB11:           EQU $0001da9c
VB12:           EQU $0001de48
VB13:           EQU $0001e0d4
VB14:           EQU $0001e23a
VB21:           EQU $0001e3be
VB22:           EQU $0001e62a
VB23:           EQU $0001e896
VB24:           EQU $0001e9e2
VB31:           EQU $0001eb46
VB32:           EQU $0001ed82
VB33:           EQU $0001efbe
VB34:           EQU $0001f0f2
WA11:           EQU $0001f23e
WA12:           EQU $0001f5aa
WA13:           EQU $0001f8e6
WA14:           EQU $0001fc42
WA15:           EQU $0001ff9e
WA16:           EQU $000202fa
WA21:           EQU $00020656
WA22:           EQU $00020982
WA23:           EQU $00020c7e
WA24:           EQU $00020f9a
WA25:           EQU $000212b6
WA26:           EQU $000215d2
WA31:           EQU $000218ee
WA32:           EQU $00021bca
WA33:           EQU $00021e86
WA34:           EQU $00022152
WA35:           EQU $0002241e
WA36:           EQU $000226ea
WA41:           EQU $000229b6
WA42:           EQU $00022b0a
WA43:           EQU $00022d66
WA44:           EQU $00022fe2
WA45:           EQU $0002325e
WA46:           EQU $000234da
WB11:           EQU $00023756
WB12:           EQU $000238b2
WB13:           EQU $00023a06
WB14:           EQU $00023c82
WB15:           EQU $00023efe
WB16:           EQU $0002417a
WB21:           EQU $000243f6
WB22:           EQU $00024532
WB23:           EQU $0002466e
WB24:           EQU $000247a2
WB25:           EQU $000248d6
WB26:           EQU $00024a0a
WB31:           EQU $00024b3e
WB32:           EQU $00024c72
WB33:           EQU $00024da6
WB34:           EQU $00024eda
WB35:           EQU $0002500e
WB36:           EQU $00025142

;* SpriteStructure
ATTACH:         EQU 0                   ; Attach on/off
HOEHE:          EQU 8                   ; Hoehe des Sprites
CONTROL:        EQU 10                  ; ControlWort

;* Objekt-Struktur
                RSRESET
OS_NAME:        RS.B 8                  ; Name des Objekts
OS_PLANE:       RS.W 1                  ; Planefilter
OS_IMGOFF:      RS.W 1                  ; Offset auf Image-Daten
OS_KOLLOFF:     RS.W 1                  ; Offset auf Kollisions-Daten
OS_XOFF:        RS.W 1                  ; X-Offset
OS_YOFF:        RS.W 1                  ; Y-Offset
OS_BREITE1:     RS.W 1                  ; Breite in Worten
OS_BREITE2:     RS.W 1                  ; Breite in Pixel
OS_HOEHE:       RS.W 1                  ; Hoehe
OS_MSKOFF:      RS.W 0                  ; Beginn der Maskendaten

;* Daten fuer TennisPlatz
NH:             EQU 32                  ; NetzHoehe
F:              EQU 48                  ; Vergroesserung der Werte

;* Daten fuer Ballbewegung
BALLANIS:       EQU 3                   ; Anzahl der Animationsstufen ( Ball )
YMAX1:          EQU 6*F                 ; Maximale Y-Koordinate ( Bewegung )
YMAX2:          EQU 8*F                 ; Maximale Y-Koordinate ( Sprung )
XMAX:           EQU 3*F                 ; Maximale X-Koordinate ( Bewegung )
ZMAX:           EQU 2*NH                ; Maximale Z-Koordinate ( allgemein )
ZM1:            EQU ZMAX                ; Maximale Z-Koordinate ( Bewegung )
ZM2:            EQU ZMAX/2              ; Maximale Z-Koordinate ( Sprung )

FF:             EQU -((ZM1*32768)/(YMAX1*YMAX1)) ; Parabel-Kruemmung (Bewegung)
FF1:            EQU -((ZM2*32768)/(YMAX2*YMAX2)) ; Parabel-Kruemmung (Sprung)
ANIDIVI:        EQU (2*YMAX2/(BALLANIS-1)) ; Dividend fuer Animationsstufe (Ball)

NETFLY:         EQU 120                 ; Andere Berechnung fuer nahe am Netz

;* Werte fuer 3D-Ball
BALLANIS1:      EQU 3
ANIDIVI1:       EQU (2*YMAX2/(BALLANIS1-1)) ; Dividend fuer Animationsstufe (Ball)

;* Daten fuer Rack-Ball-Kollision
ZV:             EQU 15                  ; ZToleranz -15 -> 15
YV:             EQU 20                  ; YToleranz -20 -> 20
XV:             EQU 10                  ; XToleranz -> -10 -> 10

;* Daten fuer Sound und FX
SOUND1LEN:      EQU 117548              ; Laenge des Titelsongs
SNDPER:         EQU 425                 ; Period fuer alle FX
SNDVOL:         EQU 64                  ; Volume fuer 1. FX
SERVEFX:        EQU 0                   ; FX Aufschlag
HITFX:          EQU 1                   ; FX Schlag
GROUNDFX:       EQU 2                   ; FX Ball-am-Boden
OUTFX:          EQU 3                   ; FX Ball-im-aus
NETFX:          EQU 4                   ; FX Net
TIMEFX:         EQU 5                   ; Ref says "TIME"
PIEPFX:         EQU 6                   ; Machine makes "PIEP"
AUDFX:          EQU 7                   ; FX Beifall

;* FX-OFFSETS des SamplePakets FX.DAT
BALL1:          EQU 0                   ; Ball 1
BALL2:          EQU BALL1+3044          ; Ball 2
BALL3:          EQU BALL2+4070          ; Ball 3
OUT:            EQU BALL3+4588          ; Out+Ball
NET:            EQU OUT+4850            ; Netz
TIME:           EQU NET+2564            ; Time
PIEP:           EQU TIME+5362           ; Maschinen-Piep
BEIFALL:        EQU PIEP+2846           ; Klatschen

;* Daten fuer Ballmaschine
BALLMACHX:      EQU 153                 ; X-Koordinate der Ballmaschine
BALLMACHY:      EQU 36                  ; Y-Koordinate der Ballmaschine

;* Daten fuer SpielPlatz ( Referees )
L1REFX:         EQU 81                  ; LinienRichter 1 X
L1REFY:         EQU 14                  ; LinienRichter 1 Y
L2REFX:         EQU 219                 ; LinienRichter 2 X
L2REFY:         EQU L1REFY              ; LinienRichter 2 Y
NREFX:          EQU 288                 ; NetzRichter X
NREFY:          EQU 75                  ; NetzRichter Y
MREFX:          EQU 0                   ; MainRichter X
MREFY:          EQU 43                  ; MainRichter Y

;* Daten fuer Menueauswahl
DECLIN:         EQU 4                   ; Decrementor ( Obere Linie )
INCLIN:         EQU 6                   ; Incrementor ( Untere Linie )

;* Daten fuer ScoreEinblendung
SHBOXCOL:       EQU 0                   ; Color fuer Schatten
BOXCOL:         EQU 13                  ; Color fuer Hauptbox
BACKMEMSIZE:    EQU (320/8)*50*4        ; 320 * 50 BackSaveBuffer
SCTB1:          EQU 146                 ; Kleinste Zeile Score ( Match )
BALLX:          EQU 2                   ; X-Koordinate Ball ( Animate )
BALLY:          EQU 10                  ; Y-Koordinate Ball ( Animate )
SCTG1:          EQU 162                 ; Y-Koordinate Score ( Game )

;* Konstanten fuer Turniertabelle
TEXTCOL:        EQU 0                   ; Color 0
PAPERCOL:       EQU 1                   ; Color 1
LIGHTCOL:       EQU 2                   ; Color 2
DARKCOL:        EQU 3                   ; Color 3

TBOXH:          EQU 11                  ; Hoehe einer Box
TBOXW:          EQU 96                  ; Breite einer Box

;* Daten fuer Ranking
MAXRANKS:       EQU 64                  ; Maximale Anzahl der Ranks
PAGESIZE:       EQU 7                   ; Eine Seite = 9 Eintraege

;* Daten fuer Netz ( Verdeckung )
NETY1:          EQU 79                  ; Obere Kante
NETY2:          EQU 100                 ; Untere Kante
;* Definitionen fuer Ballflug
BALLFLY:        EQU 0                   ; Ball-im-Flug = 0
BALLSPR:        EQU 1                   ; Ball-im-Springen = 1
BALLTIP:        EQU 2                   ; Ball-am-Tippen = 2
BALLTHR:        EQU 3                   ; Ball-im-Werfen = 3
BALLSER:        EQU 4                   ; Ball-im-Aufschlag = 4
BALLNET:        EQU 5                   ; Ball-im-Netz = 5

;* Bewegungsgrenzen fuer Spieler 1
PLRX:           EQU 136                 ; Rechte Grenze fuer Spieler
PLLX:           EQU -146                ; Linke Grenze fuer Spieler
PLUY:           EQU 16                  ; Obere Grenze fuer Spieler
PLDY:           EQU 328                 ; Untere Grenze fuer Spieler
;* BewegungsGrenzen  fuer Spieler 2
PL1UY:          EQU -328                ; Obere Grenze fuer Spieler
PL1DY:          EQU -16                 ; Untere Grenze fuer Spieler
PL1RX:          EQU 186                 ; Rechte Grenze fuer Spieler
PL1LX:          EQU -196                ; Linke Grenze fuer Spieler
;* Geschwindigkeit des Spielers
SX:             EQU 3                   ; Gescwindigkeit in X
SY:             EQU 5                   ; Geschwindigkeit in Y
SIX:            EQU 1                   ; Incrementor in X bei Step
SDX:            EQU 1                   ; Decrementor in X bei Bremsen
SDY:            EQU 2                   ; Decrementor in Y bei Bremsen
;-------------------------------------------------------------------------------
;===============================================================================
START:  move.w          VHPOSR+2+CUSTOM,RAND  ; RandomBase eintragen !
        bsr             OPENLIBS              ; Oeffne Libraries
                IF REPLAY=2
        bsr             LOADRECBUF            ; Lade JoyStick-Deltas
                ENDC
        bsr             INITSTICK             ; Initialisiere Joystickabfrage
        bsr             INITTAST              ; TastaturAbfrage !
        bsr             FIRSTDISPLAY          ; Eroeffne Schirm !
        bsr             INITAUDIO             ; Initialisiere Soundinterrupt !
        bsr             ALLIRQ                ; Normale IRQs
                IF RECEIVE=0
        bsr             GETMOTION             ; Lade Bewegungstabelle
                ENDC
                IFD  INTROSET
        bsr             INTRO                 ; Kurzer Start !
                ENDC
        bsr             GETDATAS              ; Daten von Diskette einlesen
        bsr             TASKOFF               ; Multitasking aus
        bsr             ONLYIRQ               ; Nur mein IRQ !
        bsr             DIMMEROFF             ; All Black !

        bsr             MAINMENU              ; Hauptteil

        bsr             ALLIRQ                ; Alle Irq's an !

                IF RECEIVE=1
        bsr             MOTIONTEST            ; Speicher Bewegungsdaten !
                ENDC
                IF REPLAY=1
        bsr             SAVERECBUF            ; Speichere JoyStick-Deltas !
                ENDC

        bsr             REMAUDIO              ; Remark-Audio !
        bsr             REMSTICK              ; Joystickabfrage entfernen
        bsr             REMTAST               ; TastaturIRQ entfernen !
        bsr             MEMBACK               ; Speicher zurckgeben
        bsr             TASKON                ; Multitasking an
        bsr             OLDDISPLAY            ; Alte Copperliste !
        bsr             CLOSELIBS             ; Schliesse Libraries
        moveq           #0,d0                 ;
        rts                                   ; Main Back !

                IF RECEIVE=0
* Routine laedt die Bewegungstabelle des Platzes
GETMOTION:
        movem.l         FULLSET,-(a7)
        lea             SAVENAME(pc),a0       ; Name to Save -> a0
        bsr             GETLENGTH             ; Hole Laenge des Files !
        move.l          d0,ACTLENGTH          ; Laenge sichern
        lea             SAVENAME(pc),a0       ; Name to Save -> a0
        move.l          a0,d1                 ; a0 -> d1
        move.l          #1005,d2              ; Mode_Old
        movea.l         DOSBASE(pc),a6        ; DosBase -> a6
        jsr             OPEN(a6)              ; Open It !
        move.l          d0,ACTHANDLE          ; Handle ablegen!
        move.l          d0,d1                 ; Handle -> d1
        lea             MOTIONPORT,a5         ; MotionPortBase -> a5
        move.l          a5,d2                 ; Buffer -> d2
        move.l          ACTLENGTH(pc),d3      ; Laenge -> d3
        jsr             READ(a6)              ; Read It!
        move.l          ACTHANDLE(pc),d1      ; Handle -> d1
        jsr             CLOSE(a6)             ; Close It!

        movem.l         (a7)+,FULLSET
        rts
                ENDC

                IF RECEIVE=1
MOTIONTEST:
        movem.l         FULLSET,-(a7)
        lea             SAVENAME(pc),a0       ; Name to Save -> a0
        move.l          a0,d1                 ; a0 -> d1
        move.l          #1006,d2              ; Mode_New
        movea.l         DOSBASE(pc),a6        ; DosBase -> a6
        jsr             OPEN(a6)              ; Open It !
        move.l          d0,ACTHANDLE          ; Handle ablegen!
        move.l          d0,d1                 ; Handle -> d1
        lea             MOTIONPORT(pc),a5     ; MotionPortBase -> a5
        move.l          a5,d2                 ; Buffer -> d2
        move.w          ACTMOTION(pc),d3      ; Anzahl der abgelegten Daten
        mulu            #RD_SIZEOF,d3         ; * Groesse eines Eintrags
        lea             0(a5,d3.w),a5         ; Endekennung der Daten setzen
        move.l          #-1,(a5)+             ; Endekennung = -1
        move.l          #-1,(a5)+             ; Endekennung = -1
        add.l           #$00000008,d3         ; Laenge = Laenge + Endekennung
        jsr             WRITE(a6)             ; Write It!
        move.l          ACTHANDLE(pc),d1      ; Handle -> d1
        jsr             CLOSE(a6)             ; Close It!

        movem.l         (a7)+,FULLSET
SCRTESTEND:
        rts
                ENDC

                IF REPLAY=1
* Routine speichert JoyStick-Deltas
SAVERECBUF:
        movem.l         FULLSET,-(a7)
        move.w          RECJOY,d0             ; Get RecJoy !
        lea             RECBUF,a0             ; RecBuf -> a0
        lsl.w           #2,d0                 ; Mal 4
        move.w          #$1234,0(a0,d0.w)     ; Setze EndeKennung !
        lea             RECNAME,a0            ; Name to Save -> a0
        move.l          a0,d1                 ; a0 -> d1
        move.l          #1006,d2              ; Mode_New
        movea.l         DOSBASE(pc),a6        ; DosBase -> a6
        jsr             OPEN(a6)              ; Open It !
        move.l          d0,ACTHANDLE          ; Handle ablegen!
        move.l          d0,d1                 ; Handle -> d1
        lea             RECBUF,a5             ; MotionPortBase -> a5
        move.l          a5,d2                 ; Buffer -> d2
        move.w          RECJOY,d3             ; Anzahl der abgelegten Daten
        lsl.w           #2,d3                 ; * Groesse eines Eintrags
        and.l           #$0000ffff,d3         ; LangWort
        add.l           #$00000004,d3         ; Laenge = Laenge + Endekennung
        jsr             WRITE(a6)             ; Write It!
        move.l          ACTHANDLE(pc),d1      ; Handle -> d1
        jsr             CLOSE(a6)             ; Close It!
        movem.l         (a7)+,FULLSET
        rts                                   ; All Saved !
                ENDC

                IF REPLAY=2
* Routine laedt den JoyStick-Delta-Buffer
LOADRECBUF:
        movem.l         FULLSET,-(a7)
        lea             RECNAME,a0            ; Name to Save -> a0
        bsr             GETLENGTH             ; Hole Laenge des Files !
        move.l          d0,ACTLENGTH          ; Laenge sichern
        lea             RECNAME,a0            ; Name to Save -> a0
        move.l          a0,d1                 ; a0 -> d1
        move.l          #1005,d2              ; Mode_Old
        movea.l         DOSBASE(pc),a6        ; DosBase -> a6
        jsr             OPEN(a6)              ; Open It !
        move.l          d0,ACTHANDLE          ; Handle ablegen!
        move.l          d0,d1                 ; Handle -> d1
        lea             RECBUF,a5             ; MotionPortBase -> a5
        move.l          a5,d2                 ; Buffer -> d2
        move.l          ACTLENGTH(pc),d3      ; Laenge -> d3
        jsr             READ(a6)              ; Read It!
        move.l          ACTHANDLE(pc),d1      ; Handle -> d1
        jsr             CLOSE(a6)             ; Close It!
        movem.l         (a7)+,FULLSET
        rts
                ENDC

                IFD  INTROSET
* Routine erstellt INTRO
INTRO:
        bsr             REMSPRITES            ; Keine Sprites !
        bsr             MAKEFOURPLANES        ; Only four Planes !
        bsr             READSONG              ; Lese SongDaten !
        jsr             INITSOUND             ; InitSound !
        lea             COURTSNAME(pc),a0     ; FileName -> a0
        bsr             GETINBUFFER           ; Lese Bilddaten in 2. Screen
        move.l          #COPSET4,COPSLOT      ; VBLSlot belegen
        bsr             COPYSPCNEO            ; Einblenden des NeoBildes
        bsr             ONLYIRQ               ; Nur mein IRQ!
        bsr             WAITS                 ; Warte JoyStick !

REMSONG:
        movea.l         4,a6
        movea.l         SONGPOINTER,a1
        move.l          #SOUND1LEN,d0
        jsr             FREEMEM(a6)
        clr.l           COPSLOT
        bsr             ALLIRQ
        move.w          #$000f,DMACON+CUSTOM
        move.w          #0,AUD0DAT+CUSTOM
        move.w          #0,AUD1DAT+CUSTOM
        move.w          #0,AUD2DAT+CUSTOM
        move.w          #0,AUD3DAT+CUSTOM
        rts
                ENDC

* Routine baut HauptMenue auf und regelt Abfrage der MenuePunkte
MAINMENU:
        lea             MAINMENUTXT(pc),a0    ; Adresse des Textes -> a0
        bsr             GENMENU               ; Generiere Menu
        bsr             DIMMEROFF             ; All Black !
        bra             POINTCHOOSEN          ; Verzweige aus Menue
        rts                                   ; Back !

* Routine fuer Ranking-Ausgabe
RANKING:
        bsr             GENERATEOFFS          ; Generiere Offset-Tabelle
        bsr             QSORT                 ; Sortiere Offsets ( QSort )
        bsr             SORTPLANES            ; Normale PlaneKonfig
        bsr             GETMENUBCK            ; MenuBackGround erstellen
        bsr             OUTPAGE               ; Gebe eine Seite aus !
        bsr             DIMMERON              ; Dim on !
        bsr             WAITLIST              ; Warte auf JoyStick !
        bsr             DIMMEROFF             ; All Black !
        bsr             SORTPLANES            ; Normale PlaneKonfig
        bsr             PLANEINIT             ; PlanePtr initialisieren !
        bra             MAINMENU              ; -> HauptMenue !

WAITLIST:
        lea             JOYPORT(pc),a4        ; JoyPort -> a4
        tst.b           JP_BUTTON(a4)         ; Is Button pressed ?
        bmi             WAITP                 ; Entprelle Button ?
        move.w          JP_UP(a4),d0          ; Hole Up-Down-Flags
        beq.s           WAITLIST              ; Weder noch -> Loop
        and.w           #$ff00,d0             ; Up or Down ?
        beq.s           LISTDOWN              ; -> ListDown
        move.w          RANKENTRIE,d0         ; Entrie -> d0
        subq.w          #PAGESIZE+1,d0        ; DEC Page
        bpl.s           PAGEFLIP              ; POS -> PageFlip
        moveq           #MAXRANKS-PAGESIZE-1,d0 ; Last Page -> d0
        bra.s           PAGEFLIP              ; -> PageFlip
LISTDOWN:
        move.w          RANKENTRIE,d0         ; Entrie -> d0
        addq.w          #PAGESIZE+1,d0        ; INC Page
        cmpi.w          #MAXRANKS-PAGESIZE,d0 ; Ist Ende erreicht
        ble.s           PAGEFLIP              ; Nein -> PageFlip
        moveq           #0,d0                 ; Page is Basepage

* Sammlung von Unterroutinen, die PageFlipping beim Ranking uebernehemn
PAGEFLIP:
        move.w          d0,RANKENTRIE         ; Entrie ablegen !
        bsr             SECPLANES             ; Like a DoubleBuffering !
        bsr             GETMENUBCK            ; MenuBackGround erstellen
        bsr             OUTPAGE               ; OutPage !
        bsr             RETHINKDIS            ; DisplayVars in Clist
        bra.s           WAITLIST              ; -> Loop

* Routine fuer StorageMenu
STORAGE:
        lea             STORAGETXT(pc),a0     ; Adresse des Textes -> a0
        bsr             GENMENU               ; Generiere Menu
        bsr             DIMMEROFF             ; All Black !
        bra             POINTCHOOSEN          ; Verzweige aus Menue

* Routine fuer PracticeMenu
PRACTICE:
        lea             PRACTICETXT(pc),a0    ; Adresse des Textes -> a0
        bsr             GENMENU               ; Generiere Menu
        bsr             DIMMEROFF             ; All Black !
        bra             POINTCHOOSEN          ; Verzweige aus Menue

* Baut Tournament-Menue auf !
TOURNAMENT:
        lea             TOURNTXT(pc),a0       ; Adresse des Textes -> a0
        bsr             GENMENU               ; Generiere Menu
        bsr             DIMMEROFF             ; All Black !
        bra             POINTCHOOSEN          ; Verzweige aus Menue

* Routine 2 Spieler ( Practice-Human )
HUMAN:
        bsr             BEFOREPLAY            ; -> BeforePlay !
        st              HUMANFL               ; Set HumanFlag = TRUE
PLAYLOOP:
        bsr             MAKESERVICE           ; -> Service
        bsr             MAINPART              ; -> Hauptteil ( the heart )
        tst.b           EXITFLAG              ; Teste ExitFlag !
        beq.s           PLAYLOOP              ; Nein -> Loop
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLAYEND               ; -> PlayEnde
        bra             PRACTICE              ; -> Practice

* Routine initialisiert Spiel-Modus
BEFOREPLAY:
        bsr             SETDREID              ; Setze 3D-Parameter auf Game
        bsr             INITBALLDAT           ; Initialisiere BallPort !
        bsr             FIRSTMASCHINE         ; Init Machine !
        bsr             FIRSTMANPORT          ; Init Man-Positions !
        bsr             MAKEFOURPLANES        ; Only four Planes !
        bsr             WAITBEAM              ; Warte Strahl !
        bsr             MAKEPLAYCOURT         ; Errichte Platz !
        bsr             DIMMERON              ; Dim on !
        sf              LASTTAST              ; Loesche Taste !
        move.l          #COPSETPLAY,COPSLOT   ; VBLSlot belegen !
        move.w          #$8008,INTENA+CUSTOM  ; Tastatur erlauben !
        rts                                   ; Back !

* Routine fuer Play
PLAY:
;        bsr             GENRESULTS            ; Errechne andere Ergebnisse !
;        cmpi.w          #1,TD_ROUND+TOURNPORT ; Erste Runde ?
;        beq             TOURNAMENT            ; Ja -> Tournament
        bsr             BEFOREPLAY            ; -> BeforePlay !
        sf              HUMANFL               ; Set HumanFlag = FALSE
PLAYEVER:
        bsr             MAKESERVICE           ; -> Service
        bsr             MAINPART              ; -> Hauptteil ( the heart )
        tst.b           EXITFLAG              ; Teste ExitFlag !
        beq.s           PLAYEVER              ; Nein -> Loop
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLAYEND               ; -> PlayEnde
        bra             TOURNAMENT            ; -> Tournament

* Routine beendet SpielModus
PLAYEND:
        move.w          #$0008,INTENA+CUSTOM  ; Tastatur verbieten !
        move.w          #$0008,INTREQ+CUSTOM  ; TastaturIRQ loeschen !
        move.l          #COPSET2,COPSLOT      ; VBLSlot belegen !
        move.l          BACKSTACK,BACKSTACKPT ; Clear BackStack
        clr.w           OBJNUM                ; ObjNum = 0
        bsr             DIMMEROFF             ; All Black !
        bra             CLEARSCORES           ; Scores = 0

MAINPART:
        sf              NOTPL1                ; NotPl1 = FALSE
        sf              NOTPL2                ; NotPl2 = FALSE
        sf              BS_MASCH+BALLPORT     ; No Maschine !
WAITSTUPID:
        bsr             CENTRALPLAY           ; -> Zentrale Routine
        cmpi.b          #$45,LASTTAST         ; ESC ?
        seq             EXITFLAG              ; Setze ExitFlag
        tst.b           EXITFLAG              ;
        bne             RETURN                ; -> Ende
        move.l          BS_OUT+BALLPORT,d0    ; Get FailedFlags !
        and.l           #$ffffff00,d0         ; BS_TYPE ausmaskieren !
        bne.s           SOMEFAILED            ; <> 0 -> SomeFailed !
        bra.s           WAITSTUPID            ; -> WaitStupid !

* Rouine fuer Fehler-Behandlung !
SOMEFAILED:
        move.l          BS_OUT+BALLPORT(pc),ERRORSAVE ; FailedFlags -> ErrorSave !
        move.b          BS_WHO+BALLPORT,WHO   ; Save BS_WHO -> WHO
        tst.b           ERRORSAVE+2           ; Nicht geschlagen ?
        bne             ISCORELOGIK           ; Ja -> ScoreLogik
WAITREADY:
        bsr             CENTRALPLAY           ; -> Zentrale Routine
        tst.b           BS_NEW+BALLPORT       ; Neue Parameter ?
        bne.s           WAITREADY             ; Warte bis Ende !
        move.b          WHO(pc),BS_WHO+BALLPORT ; Set BS_WHO
        tst.b           ERRORSAVE+3           ; Service in Progress ?
        bne.s           ONSERVEFAILED         ; Ja -> OnServeFailed !
        bra             SCORELOGIK            ; -> ScoreLogik !
ONSERVEFAILED:
        addq.b          #1,SERVEFAULT         ; INC ServeFault !
        cmpi.b          #2,SERVEFAULT         ; DoppelFehler ?
        blt             SECONDSERVE           ; Nein -> SecondServe !
        bra             SCORELOGIK            ; -> ScoreLogik !

SECONDSERVE:
        clr.l           BS_OUT+BALLPORT       ; Clear FailedFlags !
        rts                                   ; Back !

ISCORELOGIK:
        not.b           BS_WHO+BALLPORT       ; Invert BS_WHO
        bra             SCORELOGIK            ; -> ScoreLogik

SERVEFAULT:     DC.B 0                  ; DoppelFehler-Counter !
WHO:            DC.B 0                  ; Buffer fuer BS_WHO
ERRORSAVE:      DC.L 0                  ; Buffer fuer ErrorFlags !

MAINPART1:
        st              BS_MASCH+BALLPORT     ; Maschine = TRUE
        move.l          #COPSET3,COPSLOT      ; Belege VBLSlot !
WAITSTUPID1:
        bsr             CENTRALPLAY1          ; -> Zentrale Routine
        tst.b           JOYPORT+JP_MLBUTTON   ; Linker MausKnopf
        bne             RETURN                ; Ja -> Ende
        bra.s           WAITSTUPID1           ; Nein -> WaitStupid

* Zentrale Spielroutine ( PLAY )
CENTRALPLAY:
        cmpi.l          #MEGAA,PP_MEGA+PLAYPORT ; Wer ist am Aufschlag !
        seq             NOTPL1+1              ; PL1 -> Set Flag
        sne             NOTPL2+1              ; PL2 -> Set Flag

        cmpi.w          #-1,NOTPL1            ; Darf Player 1 ?
        beq.s           MAKEPLAYER2           ; Nein -> MakePlayer2
        movea.l         ACTANIM,a0            ; ActAnim -> a0
        bsr             ANIM                  ; -> AnimLogik
        movem.w         PL1PORT+P1_DX(pc),d0-d2 ; X-Y-Z-Koordinate -> d0-d2
        bsr             INOBJLIST             ; -> InObjList

MAKEPLAYER2:
        cmpi.w          #-1,NOTPL2            ; Darf Player 2 ?
        beq             DRAWOBJLIST           ; Nein -> DrawObjList

        movea.l         ACTANIM1,a0           ; ActAnim1 -> a0
        bsr             ANIM                  ; -> AnimLogik
        movem.w         PL2PORT+P1_DX(pc),d0-d2 ; X-Y-Z-Koordinate -> d0-d2
        bsr             INOBJLIST             ; -> InObjList
        bra             DRAWOBJLIST           ; -> DrawObjList

EXITFLAG:       DC.W 0                  ; ExitFlag
NOTPL1:         DC.W 0                  ; ServiceFlags PL1
NOTPL2:         DC.W 0                  ; ServiceFlags PL2

* Zentrale Spielroutine ( PRACTICE Machine )
CENTRALPLAY1:
        movea.l         ACTANIM,a0            ; ActAnim -> a0
        bsr             ANIM                  ; -> AnimLogik
        movem.w         PL1PORT+P1_DX(pc),d0-d2 ; X-Y-Z-Koordinate -> d0-d2
        bsr             INOBJLIST             ; -> InObjList
        bra             DRAWOBJLIST           ; -> DrawObjList

* Routine "errechnet" AnimationsPort fuer Spieler1
* Input:
*       Nothing
* Output:
*       a0 = AnimPortPtr
WHICHANIMPORT:
        cmpi.w          #-1,NOTPL1            ; Service in Progress ?
        beq             RETURN                ; Ja -> Ende
        clr.l           LNAFLAG               ; LNAFlag+LNSFlag = False
        clr.w           LSWAFLAG              ; Other Run-flags = FALSE
        lea             JOYPORT(pc),a1        ; JoyPortBase -> a1
        lea             JOYOLDPORT(pc),a2     ; JoyOldPortBase -> a2
        move.b          JP_BUTTON(a1),d0      ; Button -> d1
        add.b           JP_BUTTON(a2),d0      ; Sub OldButton
        tst.b           BS_HIT+BALLPORT       ; Im Schlag ?
        bne             MAKEHIT               ; Ja -> MakeHit
        cmp.b           #-1,d0                ; CMP -1
        beq.s           PRESSORREL            ; = -> PressOrRel
        bgt             MAKEWAIT              ; > -> MakeWait
        bra.s           STILLPRESSED          ; < -> StillPressed
;--------------------------------------
PRESSORREL:
        tst.b           JP_BUTTON(a1)         ; Test New Button
        beq             BRELEASED             ; = 0 -> BReleased
        move.w          #SX,MOVERX            ; Normal MoveX
        move.w          #SY,MOVERY            ; Normal MoveY
        bsr             INITWAITAPORT1        ; -> InitWaitAPort1
        move.w          PL1PORT+P1_X,d0       ; Player-X -> d0
        cmp.w           BALLPORT+BS_X,d0      ; CMP Ball-X
        ble.s           MAKEFOREHAND1         ; <= -> MakeForeHand1
MAKEBACKHAND1:
        st              BS_FORE+BALLPORT      ; Setze BackHand
        lea             RUEASPORT(pc),a0      ; RueASPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOYOLD                ; -> JoyOld
MAKEFOREHAND1:
        sf              BS_FORE+BALLPORT      ; Setze ForeHand
        lea             VORASPORT(pc),a0      ; VorASPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOYOLD                ; -> JoyOld
;--------------------------------------
STILLPRESSED:
        bsr             QUIETSCH              ; -> Bremse Spieler
        tst.b           BS_FORE+BALLPORT      ; Vor- oder Rueckhand ?
        beq.s           MAKEFOREHAND2         ; Vor -> MakeForeHand2
MAKEBACKHAND2:
        lea             RUEASPORT(pc),a0      ; RueASPort -> a0
        bra             JOYOLD                ; -> JoyOld
MAKEFOREHAND2:
        lea             VORASPORT(pc),a0      ; VorASPort -> a0
        bra             JOYOLD                ; -> JoyOld
;--------------------------------------
BRELEASED:
        bsr             INITSAWPORT           ; SawPort init !
        st              BS_HIT+BALLPORT       ; HitFlag = TRUE
        tst.b           BS_FORE+BALLPORT      ; BackHandFlag ?
        beq.s           MAKEFOREHAND3         ; Nein -> MakeForeHand3
MAKEBACKHAND3:
        lea             RUEAPORT(pc),a0       ; RueAPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOYOLD                ; -> JoyOld
MAKEFOREHAND3:
        lea             VORAPORT(pc),a0       ; VorAPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOYOLD                ; -> JoyOld
;--------------------------------------
MAKEHIT:
        bsr             QUIETSCH              ; -> Quietsch
        tst.b           BS_FORE+BALLPORT      ; BackHandFlag ?
        beq.s           MAKEFOREHAND4         ; Nein -> MakeForeHand4
MAKEBACKHAND4:
        lea             RUEAPORT(pc),a0       ; RueAPort -> a0
        move.w          AN_CNT(a0),d0         ; StepCount -> d0
        cmp.w           AN_STEPS(a0),d0       ; End of Animation ?
        blt             JOYOLD                ; Nein -> JoyOld
        move.w          AN_DELCNT(a0),d0      ; DelayCount -> d0
        cmp.w           AN_DEL(a0),d0         ; Delay erfuellt ?
        slt             BS_HIT+BALLPORT       ; Nein -> HitFlag = TRUE
        bra             JOYOLD                ; -> JoyOld
MAKEFOREHAND4:
        lea             VORAPORT(pc),a0       ; VorAPort -> a0
        move.w          AN_CNT(a0),d0         ; StepCount -> d0
        cmp.w           AN_STEPS(a0),d0       ; End of Animation ?
        blt             JOYOLD                ; Nein -> JoyOld
        move.w          AN_DELCNT(a0),d0      ; DelayCount -> d0
        cmp.w           AN_DEL(a0),d0         ; Delay erfuellt ?
        slt             BS_HIT+BALLPORT       ; Nein -> HitFlag = TRUE
        bra             JOYOLD                ; -> JoyOld
;--------------------------------------
MAKEWAIT:
        tst.b           BS_HIT+BALLPORT       ; Wirklich Wait ?
        bne.s           MAKEHIT               ; Nein -> MakeHit
        move.l          JP_LEFT(a1),d3        ; JoyFlags -> d3
        beq.s           REALWAIT              ; Keine Flags -> RealWait !

        moveq           #0,d4                 ; Clear D4 ( Packed JoyFlags )
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3

        lsl.w           #2,d4                 ; * 2 fuer Tabellenzugriff !
        lea             JOYTAB(pc),a3         ; JoyTabBase -> a3
        movea.l         0(a3,d4.w),a3         ; Base of Rout -> a3
        jmp             (a3)                  ; -> in Rout
;--------------------------------------
MAKESTEP:
        move.w          #SX,MOVERX            ; Normal MoveX
        move.w          #SY,MOVERY            ; Normal MoveY
        bsr             INITWAITAPORT1        ; -> InitWaitAPort1
        cmpi.w          #1,SAWPORT+AN_CNT     ; Beine geschlossen ?
        bne.s           NOFAST                ; Nein -> NoFast
        tst.w           SAWPORT+AN_DELCNT     ; Erste Stufe der Anim ?
        bne.s           NOFAST                ; Nein -> NoFast
        addq.w          #SIX,MOVERX           ; INC MoverX
NOFAST:
        lea             SAWPORT(pc),a0        ; SawPort -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
REALWAIT:
        bsr             INITSAWPORT           ; -> InitSawPort
        lea             WAITAPORT(pc),a0      ; WaitAPort -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
MAKENRUN:                                     ; Run A Nord
        bsr             STDYRUN               ; -> STDRun
        st              LNAFLAG               ; Set LNAFlag
        lea             LNAPORT(pc),a0        ; LNAPortBase -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
MAKENWRUN:                                    ; Run A Nord-West
        bsr             STDRUN                ; -> STDRun
        st              LNWAFLAG              ; Set LNWAFlag
        lea             LNWAPORT(pc),a0       ; LNWAPortBase -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
MAKENORUN:                                    ; Run A Nord-Ost
        bsr             STDRUN                ; -> STDRun
        st              LNOAFLAG              ; Set LNOAFlag
        lea             LNOAPORT(pc),a0       ; LNOAPortBase -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
MAKESRUN:                                     ; Run A South
        bsr             STDYRUN               ; -> STDRun
        st              LNSFLAG               ; Set LNSFlag
        lea             LSAPORT(pc),a0        ; LNSPortBase -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
MAKESWRUN:                                    ; Run A South-west
        bsr             STDRUN                ; -> STDRun
        st              LSWAFLAG              ; Set LSWAFlag
        lea             LSWAPORT(pc),a0       ; LSWAPortBase -> a0
        bra.s           JOYOLD                ; -> JoyOld
;--------------------------------------
MAKESORUN:                                    ; Run A South-east
        bsr             STDRUN                ; -> STDRun
        st              LSOAFLAG              ; Set LSOAFlag
        lea             LSOAPORT(pc),a0       ; LSOAPortBase -> a0
        bra.s           JOYOLD                ; -> JoyOld


LNAFLAG:        DC.B 0                  ; Laeuft-Nord-Flag
LNSFLAG:        DC.B 0                  ; Laeuft-Sued-Flag
LNWAFLAG:       DC.B 0                  ; Laeuft-Nord-West-Flag
LNOAFLAG:       DC.B 0                  ; Laeuft-Nord-Ost-Flag
LSWAFLAG:       DC.B 0                  ; Laeuft-Sued-West-Flag
LSOAFLAG:       DC.B 0                  ; Laeuft-Sued-Ost-Flag

JOYOLD:
        move.l          a0,ACTANIM            ; Anim -> ActAnim
        move.l          (a1)+,(a2)+           ; Copy JoyStick-U-D-L-R
        move.b          (a1),(a2)             ; Copy JoyStickButton
        rts                                   ; Back !

* Routine for Standard-Run-Init fuer schr„ges Laufen Player A
STDRUN:
        move.w          #SX,MOVERX            ; Normal MoveX
        move.w          #SY-1,MOVERY          ; Normal MoveY-1
        bra             INITWAITAPORT         ; -> InitWaitAPort

* Routine for Standard-Run-Init Player A
STDYRUN:
        move.w          #SX,MOVERX            ; Normal MoveX
        move.w          #SY,MOVERY            ; Normal MoveY
        bra             INITWAITAPORT         ; -> InitWaitAPort

* Kleine Bremsung
QUIETSCH:
        subq.w          #1,TDEL               ; DEC Delay
        bpl             RETURN                ; Pos -> Ende
        move.w          #8,TDEL               ; Init Delay
        subq.w          #SDX,MOVERX           ; DEC MoverX
        bpl.s           NOSMX                 ; >= 0 -> NoSMx
        clr.w           MOVERX                ; MoverX = 0
NOSMX:
        subq.w          #SDY,MOVERY           ; DEC MoverY
        bpl             RETURN                ; >= 0 -> Ende
        clr.w           MOVERY                ; MoverY = 0
        rts                                   ; Back
TDEL:           DC.W 8

* Routine initialisiert WaitAPort
INITWAITAPORT:
        lea             WAITAPORT(pc),a0      ; WaitAPortBase -> a0
        bra.s           INITANIM              ; -> InitAnim

* Routine initialisiert WaitAPort auf LoopPoint
INITWAITAPORT1:
        lea             WAITAPORT(pc),a0      ; WaitAPortBase -> a0
        clr.w           AN_DELCNT(a0)         ; Delay = 0
        move.w          #2,AN_CNT(a0)         ; StepCnt = 2
        rts                                   ; Back !
* Routine initialisert StepPort A
INITSAWPORT:
        lea             SAWPORT(pc),a0        ; SawPort -> a0
        bra.s           INITANIM              ; -> InitAnim

* Routine initialisiert einen AnimationsPort
* Input:
*       a0 = Pointer to AnimPort
INITANIM:
        clr.w           AN_DELCNT(a0)         ; Delay = 0
        clr.w           AN_CNT(a0)            ; StepCnt = 0
        rts                                   ; Back !

;==============================================================================
* Routine "errechnet" AnimationsPort fuer Spieler2
* Input:
*       Nothing
* Output:
*       a0 = AnimPortPtr -> ActAnim1
WHICH1ANIMPORT:
        cmpi.w          #-1,NOTPL2            ; Service in Progress ?
        beq             RETURN                ; Ja -> Ende
        clr.w           LNBFLAG               ; LNBFlag+LNSFlag = False
        lea             JOY1PORT(pc),a1       ; Joy1PortBase -> a1
        lea             JOY1OLDPORT(pc),a2    ; Joy1OldPortBase -> a2
        move.b          JP_BUTTON(a1),d0      ; Button -> d1
        add.b           JP_BUTTON(a2),d0      ; Sub OldButton
        tst.b           BS_HIT1+BALLPORT      ; Im Schlag ?
        bne             MAKEHIT1              ; Ja -> MakeHit1
        cmp.b           #-1,d0                ; CMP -1
        beq.s           PRESSORREL1           ; = -> PressOrRel1
        bgt             MAKEWAIT1             ; > -> MakeWait1
        bra.s           STILLPRESSED1         ; < -> StillPressed1
;--------------------------------------
PRESSORREL1:
        tst.b           JP_BUTTON(a1)         ; Test New Button
        beq             BRELEASED1            ; = 0 -> BReleased1
        move.w          #SX,MOVER1X           ; Normal Move1X
        move.w          #SY,MOVER1Y           ; Normal Move1Y
        bsr             INITWAITBPORT1        ; -> InitWaitbPort1
        move.w          PL2PORT+P1_X,d0       ; Player-X -> d0
        cmp.w           BALLPORT+BS_X,d0      ; CMP Ball-X
        bge.s           MAKEFOREHAND_1        ; <= -> MakeForeHand_1
MAKEBACKHAND_1:
        st              BS_FORE1+BALLPORT     ; Setze BackHand
        lea             RUEBSPORT(pc),a0      ; RueBSPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOY1OLD               ; -> Joy1Old
MAKEFOREHAND_1:
        sf              BS_FORE1+BALLPORT     ; Setze ForeHand
        lea             VORBSPORT(pc),a0      ; VorBSPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOY1OLD               ; -> Joy1Old
;--------------------------------------
STILLPRESSED1:
        bsr             QUIETSCH1             ; -> Bremse Spieler2
        tst.b           BS_FORE1+BALLPORT     ; Vor- oder Rueckhand ?
        beq.s           MAKEFOREHAND_2        ; Vor -> MakeForeHand_2
MAKEBACKHAND_2:
        lea             RUEBSPORT(pc),a0      ; RueBSPort -> a0
        bra             JOY1OLD               ; -> Joy1Old
MAKEFOREHAND_2:
        lea             VORBSPORT(pc),a0      ; VorBSPort -> a0
        bra             JOY1OLD               ; -> Joy1Old
;--------------------------------------
BRELEASED1:
        bsr             INITSBWPORT           ; SbwPort init !
        st              BS_HIT1+BALLPORT      ; Hit1Flag = TRUE
        tst.b           BS_FORE1+BALLPORT     ; BackHandFlag ?
        beq.s           MAKEFOREHAND_3        ; Nein -> MakeForeHand_3
MAKEBACKHAND_3:
        lea             RUEBPORT(pc),a0       ; RueBPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOY1OLD               ; -> Joy1Old
MAKEFOREHAND_3:
        lea             VORBPORT(pc),a0       ; VorBPort -> a0
        bsr             INITANIM              ; -> InitAnim
        bra             JOY1OLD               ; -> Joy1Old
;--------------------------------------
MAKEHIT1:
        bsr             QUIETSCH1             ; -> Quietsch
        tst.b           BS_FORE1+BALLPORT     ; BackHandFlag ?
        beq.s           MAKEFOREHAND_4        ; Nein -> MakeForeHand_4
MAKEBACKHAND_4:
        lea             RUEBPORT(pc),a0       ; RueBPort -> a0
        move.w          AN_CNT(a0),d0         ; StepCount -> d0
        cmp.w           AN_STEPS(a0),d0       ; End of Animation ?
        blt             JOY1OLD               ; Nein -> Joy1Old
        move.w          AN_DELCNT(a0),d0      ; DelayCount -> d0
        cmp.w           AN_DEL(a0),d0         ; Delay erfuellt ?
        slt             BS_HIT1+BALLPORT      ; Nein -> Hit1Flag = TRUE
        bra             JOY1OLD               ; -> Joy1Old
MAKEFOREHAND_4:
        lea             VORBPORT(pc),a0       ; VorBPort -> a0
        move.w          AN_CNT(a0),d0         ; StepCount -> d0
        cmp.w           AN_STEPS(a0),d0       ; End of Animation ?
        blt             JOY1OLD               ; Nein -> Joy1Old
        move.w          AN_DELCNT(a0),d0      ; DelayCount -> d0
        cmp.w           AN_DEL(a0),d0         ; Delay erfuellt ?
        slt             BS_HIT1+BALLPORT      ; Nein -> Hit1Flag = TRUE
        bra             JOY1OLD               ; -> Joy1Old
;--------------------------------------
MAKEWAIT1:
        tst.b           BS_HIT1+BALLPORT      ; Wirklich Wait ?
        bne.s           MAKEHIT1              ; Nein -> MakeHit1
        move.l          JP_LEFT(a1),d3        ; JoyFlags -> d3
        beq.s           REALWAIT1             ; Keine Flags -> RealWait !

        moveq           #0,d4                 ; Clear D4 ( Packed JoyFlags )
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3
        lsr.l           #8,d3                 ; >> 8
        roxl.w          #1,d4                 ; X-Flag -> d3

        lsl.w           #2,d4                 ; * 2 fuer Tabellenzugriff !
        lea             JOY1TAB(pc),a3        ; JoyTabBase -> a3
        movea.l         0(a3,d4.w),a3         ; Base of Rout -> a3
        jmp             (a3)                  ; -> in Rout
;--------------------------------------
MAKESTEP1:
        move.w          #SX,MOVER1X           ; Normal Move1X
        move.w          #SY,MOVER1Y           ; Normal Move1Y
        bsr             INITWAITBPORT1        ; -> InitWaitBPort1
        cmpi.w          #1,SBWPORT+AN_CNT     ; Beine geschlossen ?
        bne.s           NOFAST1               ; Nein -> NoFast
        tst.w           SBWPORT+AN_DELCNT     ; Erste Stufe der Anim ?
        bne.s           NOFAST1               ; Nein -> NoFast
        addq.w          #SIX,MOVER1X          ; INC MoverX
NOFAST1:
        lea             SBWPORT(pc),a0        ; SbwPort -> a0
        bra             JOY1OLD               ; -> Joy1Old
;--------------------------------------
REALWAIT1:
        bsr             INITSBWPORT           ; -> InitSbwPort
        lea             WAITBPORT(pc),a0      ; WaitBPort -> a0
        bra             JOY1OLD               ; -> Joy1Old
;--------------------------------------
MAKENRUN1:                                    ; Run B Nord
        bsr             STDRUN1               ; -> STDRun1
        st              LNBFLAG               ; Set LNBFlag
        lea             LNBPORT(pc),a0        ; LNBPortBase -> a0
        bra.s           JOY1OLD               ; -> JoyOld
;--------------------------------------
MAKENWRUN1:                                   ; Run B Nord-West
        bsr             STDRUN1               ; -> STDRun1
        st              LNWBFLAG              ; Set LNWBFlag
        lea             LNWBPORT(pc),a0       ; LNWBPortBase -> a0
        bra.s           JOY1OLD               ; -> JoyOld
;--------------------------------------
MAKENORUN1:                                   ; Run B Nord-Ost
        bsr             STDRUN1               ; -> STDRun1
        st              LNOBFLAG              ; Set LNOBFlag
        lea             LNOBPORT(pc),a0       ; LNOBPortBase -> a0
        bra.s           JOY1OLD               ; -> JoyOld
;--------------------------------------
MAKESRUN1:                                    ; Run B South
        bsr             STDRUN1               ; -> STDRun1
        st              LSBFLAG               ; Set LSBFlag
        lea             LSBPORT(pc),a0        ; LSBPortBase -> a0
        bra.s           JOY1OLD               ; -> JoyOld
;--------------------------------------
MAKESWRUN1:                                   ; Run B South-west
        bsr             STDRUN1               ; -> STDRun1
        st              LSWBFLAG              ; Set LSWBFlag
        lea             LSWBPORT(pc),a0       ; LSWBPortBase -> a0
        bra.s           JOY1OLD               ; -> JoyOld
;--------------------------------------
MAKESORUN1:                                   ; Run B South-east
        bsr             STDRUN1               ; -> STDRun1
        st              LSOBFLAG              ; Set LSOBFlag
        lea             LSOBPORT(pc),a0       ; LSOBPortBase -> a0
        bra.s           JOY1OLD               ; -> JoyOld

LNBFLAG:        DC.B 0                  ; Laeuft-Nord-Flag
LSBFLAG:        DC.B 0                  ; Laeuft-Sued-Flag
LNWBFLAG:       DC.B 0                  ; Laeuft-Nord-West-Flag
LNOBFLAG:       DC.B 0                  ; Laeuft-Nord-Ost-Flag
LSWBFLAG:       DC.B 0                  ; Laeuft-Sued-West-Flag
LSOBFLAG:       DC.B 0                  ; Laeuft-Sued-Ost-Flag

* Routine kopiert die JoyStickFlags in zweiten Buffer und setzt div. Flags
JOY1OLD:
        move.l          a0,ACTANIM1           ; Anim -> ActAnim1
        move.l          (a1)+,(a2)+           ; Copy JoyStick-U-D-L-R
        move.b          (a1),(a2)             ; Copy JoyStickButton
        rts                                   ; Back !

* Routine for Standard-Run-Init Player B
STDRUN1:
        move.w          #SX,MOVER1X           ; Normal MoveX
        move.w          #SY,MOVER1Y           ; Normal MoveY
        bra             INITWAITBPORT         ; -> InitWaitAPort

* Kleine Bremsung
QUIETSCH1:
        subq.w          #1,TDEL1              ; DEC Delay
        bpl             RETURN                ; Pos -> Ende
        move.w          #8,TDEL1              ; Init Delay
        subq.w          #SDX,MOVER1X          ; DEC Mover1X
        bpl.s           NOSMX1                ; >= 0 -> NoSMx1
        clr.w           MOVER1X               ; Mover1X = 0
NOSMX1:
        subq.w          #SDY,MOVER1Y          ; DEC Mover1Y
        bpl             RETURN                ; >= 0 -> Ende
        clr.w           MOVER1Y               ; Mover1Y = 0
        rts                                   ; Back
TDEL1:          DC.W 8

* Routine initialisiert WaitBPort
INITWAITBPORT:
        lea             WAITBPORT(pc),a0      ; WaitBPortBase -> a0
        bra             INITANIM              ; -> InitAnim

* Routine initialisiert WaitAPort auf LoopPoint
INITWAITBPORT1:
        lea             WAITBPORT(pc),a0      ; WaitBPortBase -> a0
        clr.w           AN_DELCNT(a0)         ; Delay = 0
        move.w          #0,AN_CNT(a0)         ; StepCnt = 2
        rts                                   ; Back !

* Routine initialisert StepPort B
INITSBWPORT:
        lea             SBWPORT(pc),a0        ; SbwPort -> a0
        bra             INITANIM              ; -> InitAnim

                IFD  INTROSET
* Routine blendet EndeSequence ein
THEEND:
;        bsr             GETENDANIM            ; Hole Animation von Disk !
        bsr             ALLIRQ                ; Alle IRQs an !
        bsr             GETENDSONG            ; Lade Schlussong !
        lea             ENDNAME(pc),a0        ; Name des Bildes -> a0
        bsr             GETINBUFFER           ; Lese Bilddaten in 2. Screen
        bsr             ONLYIRQ               ; Nur mein IRQ an !
        bsr             COPYSPCNEO            ; Einblenden des NeoBildes
        move.l          #COPSET4,COPSLOT      ; VBLSlot belegen
        bsr             ENDANIM               ; Regle Animation !
;        bsr             REMENDANIM            ; Animation aus Speicher !
        bsr             DIMMEROFF             ; All Black !
        bsr             REMENDSONG            ; Entferne Schlussong !
        bra             TOURNAMENT            ; -> Tournament

* Routine regelt die Animation der Baelle
ENDANIM:
        lea             BENDPORT(pc),a0       ; BendPortBase -> a0
        bsr             ANIMATION             ; AnimationsRoutine !
        lea             BENDPOS(pc),a3        ; PositionTable -> a3
        moveq           #9,d7                 ; Init LoopCounter !
        bsr             WAITBEAM              ; Warte auf Strahl !
ENDANIMLOOP:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         PLANES(a6),a1         ; ZielPlane -> a1
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Set ClipDown
        suba.w          a4,a4                 ; No BCKSave !
        movem.w         (a3)+,d0-d1           ; X-Y-Koordinate -> d0 - d1
        movem.l         d7/a2-a3,-(a7)        ; Save Regs on Stack !
        bsr             BOB                   ; Bob It!
        movem.l         (a7)+,d7/a2-a3        ; Get Regs from Stack !
        dbra            d7,ENDANIMLOOP        ; -> Loop
        tst.b           JP_BUTTON+JOYPORT     ; Button pressed ?
        beq.s           ENDANIM               ; Nein -> Loop !
        rts                                   ; Back !

* Routine laedt Ende-Sound
GETENDSONG:
        lea             ESNDNAME(pc),a0       ; Name to Load -> a0
        bsr             GETLENGTH             ; Hole Laenge des Files !
        move.l          d0,MEMSIZE            ; Laenge sichern
        move.l          d0,ESNDSIZE           ; Leange sichern
        move.l          #MEMSET,d1            ; CHIP_MEM
        movea.l         4,a6                  ; ExecBase -> a6
        jsr             ALLOCMEM(a6)          ; Get Memory !
        tst.l           d0                    ; Success ?
        beq             WRONG                 ; Nein -> Wrong
        move.l          d0,MEMPTR             ; Pointer ablegen !
        move.l          d0,SONGPOINTER        ; d0 -> SongPointer !
        move.l          d0,ESNDPTR            ; d0 -> ESndPtr !
        lea             ESNDNAME(pc),a0       ; Name to Load -> a0
        bsr             OPENFILE              ; Oeffne File !
        bsr             GETFILE               ; Lese File !
        bsr             CLOSEFILE             ; Schliesse Datei !
        jsr             INITSOUND             ; InitSound !
        rts

* Routine entfernt Ende-Song
REMENDSONG:
        move.l          #COPSET2,COPSLOT      ; Belege VBLSlot !
        movea.l         4,a6                  ; ExecBase -> a6
        movea.l         ESNDPTR(pc),a1        ; BasePointer -> a1
        move.l          ESNDSIZE(pc),d0       ; Groesse -> d0
        jsr             FREEMEM(a6)           ; Gebe Speicher frei !
        rts                                   ; Back !

* Routine laedt Animation fuer Ende ( Drehender Ball )
GETENDANIM:
        lea             BENDNAME(pc),a0       ; Name to Load -> a0
        bsr             GETLENGTH             ; Hole Laenge des Files !
        move.l          d0,MEMSIZE            ; Laenge sichern
        move.l          d0,BENDSIZE           ; Laenge sichern
        move.l          #MEMSET,d1            ; CHIP_MEM
        movea.l         4,a6                  ; ExecBase -> a6
        jsr             ALLOCMEM(a6)          ; Get Memory !
        tst.l           d0                    ; Success ?
        beq             WRONG                 ; Nein -> Wrong
        move.l          d0,MEMPTR             ; Pointer ablegen !
        lea             BENDNAME(pc),a0       ; Name to Load -> a0
        bsr             OPENFILE              ; Oeffne File !
        bsr             GETFILE               ; Lese File !
        bsr             CLOSEFILE             ; Schliesse Datei !
        move.l          d0,BENDPORT+AN_BASE   ; DatenBasis ablegen !
        rts
* Routine entfernt BallEnde-Animation aus Speicher
REMENDANIM:
        movea.l         4,a6                  ; ExecBase -> a6
        movea.l         BENDPORT+AN_BASE,a1   ; BasePointer -> a1
        move.l          BENDSIZE(pc),d0       ; Groesse -> d0
        jsr             FREEMEM(a6)           ; Gebe Speicher frei !
        rts                                   ; Back !
                ENDC

* Routine interpretiert Menueauswahl und verzweigt in entsprechende Routine
POINTCHOOSEN:
        lea             MENUPORT(pc),a5       ; MenuPortBase -> a5
        movea.l         MB_ROUTS(a5),a0       ; Zeiger auf Routinen -> a0
        move.w          MB_MENU(a5),d0        ; Nummer des gewaehlten Menues
        lsl.w           #2,d0                 ; * 4 fuer Langwortzugriff
        move.l          0(a0,d0.w),d0         ; ADR of Rout -> d0
        beq             RETURN                ; = 0 -> Return
        movea.l         d0,a0                 ; d0 -> a0
        jmp             (a0)                  ; -> Jump

* Routine baut Menue auf
* Input:
*       a0 = Pointer MenuStruct
GENMENU:
        move.l          a0,-(a7)              ; Rette Pointer auf Stack !
        move.l          #COPSET2,COPSLOT      ; VBLSlot belegen
        bsr             REMSPRITES            ; Keine Sprites
        bsr             MAKEFOURPLANES        ; Only 4 Planes on !
        bsr             INITMENUPORT          ; Initialisiere MenuPort
        bsr             GETMENUBCK            ; Kopiere MenueBackGround
        movea.l         (a7)+,a0              ; Hole Pointer vom Stack !
        bsr             MAKEPOINTS            ; Gebe MenuePunkte aus !
        bsr             INTERPRETMENU         ; Zentrale MenueRoutine !
        rts                                   ; Back to Call !

* Routine uebernimmt MenuAuswahl
INTERPRETMENU:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             MENUPORT(pc),a5       ; MenuPortBase -> a5
        move.w          MB_MENU(a5),d0        ; MenuNumber -> d0
        beq             ZEROMENU              ; Is 0 -> ZeroMenu
INTERMENUL:
        bsr             DIMMERON              ; Ziehe Farben hoch !
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             MENUPORT(pc),a5       ; MenuPortBase -> a5
        bsr             WAITJOYMOVE           ; Warte auf JoyStickBewegung !
        rts                                   ; Back

* Routine wartet auf Bewegung des JoySticks und entprellt
WAITJOYMOVE:
        lea             JOYPORT(pc),a4        ; JoyStickPortBase -> a4
        tst.b           JP_BUTTON(a4)         ; Ist Button gedrueckt !
        bmi.s           MENUCHOOSEN           ; Ja -> MenuChoosen
        move.w          JP_UP(a4),d0          ; Hole Flags !
        beq.s           WAITJOYMOVE           ; Keine Bewegung -> Loop
        and.w           #$ff00,d0             ; Oben oder Unten ?
        beq.s           MENUDOWN              ; Unten -> MenuDown

        move.w          MB_MENU(a5),d0        ; Hole aktuellen Punkt !
        move.w          d0,MB_OLDMENU(a5)     ; Als Alten Punkt ablegen !
        subq.w          #1,d0                 ; DEC Point
        bne.s           NOTMINPOINT           ; Nein -> NotMinPoint
        move.w          MB_COUNT(a5),d0       ; MaxPoint -> d0
NOTMINPOINT:
        move.w          d0,MB_MENU(a5)        ; Setze MenuPoint !
        bra.s           WAITJOYLOOP           ; -> WaitJoyLoop

MENUDOWN:
        move.w          MB_MENU(a5),d0        ; Hole aktuellen Punkt !
        move.w          d0,MB_OLDMENU(a5)     ; Als Alten Punkt ablegen !
        addq.w          #1,d0                 ; INC Point
        cmp.w           MB_COUNT(a5),d0       ; > MaxPoint ?
        ble.s           NOTMAXPOINT           ; Nein -> NotMaxPoint
        move.w          #1,d0                 ; d0 = 1
NOTMAXPOINT:
        move.w          d0,MB_MENU(a5)        ; Setze MenuPoint !
WAITJOYLOOP:
        bsr             NEWMENUPOINT          ; Neuen MenuePunkt einblenden !
JOYENTPRELL:
        lea             JOYPORT(pc),a4        ; JoyStickPortBase -> a4
        move.w          JP_UP(a4),d0          ; Hole Flags !
        bne.s           JOYENTPRELL           ; Entprelle JoyStick !
        bra.s           WAITJOYMOVE           ; -> Loop

MENUCHOOSEN:
        lea             JOYPORT(pc),a4        ; JoyStickPortBase -> a4
        tst.b           JP_BUTTON(a4)         ; Entprelle Button !
        bmi.s           MENUCHOOSEN           ; -> Loop
        rts                                   ; Back !

* Routine erledigt die AusWahl eines neuen MenuPunktes
NEWMENUPOINT:
        bsr             LOADLINE              ; Schreibe BackGround der alten
        bsr             RENDERMPOINT          ; Zeichne neuen Punkt
        rts                                   ; Back !

* Routine schreibt LineBackGround zurck
LOADLINE:
        move.w          MB_OLDMENU(a5),d0     ; Alten Menuepunkt -> d0
        mulu            #6,d0                 ; Haesslich !
        lea             MB_COORDS(a5,d0.w),a4 ; CoordBase -> a4
        movem.w         (a4),d0-d2            ; Coords -> d0 - d2
        exg             d1,d2                 ; Swap X2 mit Y
        subq.w          #DECLIN,d2            ; DEC Y
        bsr             LOAD1LINE             ; Schreibe 1. Zeile BCK
        movea.l         CHARPTR(a6),a4        ; Adresse der Charsetdaten -> a4
        add.w           CH_HEIGHT(a4),d2      ; ADD Zeichenhoehe
        addq.w          #INCLIN,d2            ; INC Y
        bsr             LOAD2LINE             ; Schreibe 2. Zeile BCK
        rts                                   ; Back !

LOAD2LINE:
        lea             PLANES(a6),a4         ; Zeiger auf PlanePtr -> a4
        lea             LINEPL2,a0            ; Zeiger auf BCK -> a0
        bra.s           LOADLI                ; -> LoadLi

LOAD1LINE:
        lea             PLANES(a6),a4         ; Zeiger auf PlanePtr -> a4
        lea             LINEPL1,a0            ; Zeiger auf BCK -> a0
LOADLI:
        move.w          d2,d3                 ; d2 -> d3
        add.w           d3,d3                 ; d3 * 2 fuer Wortzugriff
        move.w          MULU160(a6,d3.w),d1   ; Y-Offset -> d1
        moveq           #3,d0                 ; Init LoopCounter !
LOADLINELOOP:
        movea.l         (a4)+,a1              ; PlanePtr -> a1
        lea             0(a1,d1.w),a1         ; Offset addieren
        movem.l         (a0)+,d3-d7           ; Get BCKDatas -> d3 - d7
        movem.l         d3-d7,(a1)            ; Write Datas in Plane !
        lea             20(a1),a1             ; ADD Offset
        movem.l         (a0)+,d3-d7           ; Get BCKDatas -> d3 - d7
        movem.l         d3-d7,(a1)            ; Write Datas in Plane !
        dbra            d0,LOADLINELOOP       ; -> Loop
        rts                                   ; Back

* Routine setzt Menue auf ersten Punkt
* Input:
*       a5 = Pointer to MenuPort
*       a6 = Pointer to ScreenPort
ZEROMENU:
        move.w          #1,MB_MENU(a5)        ; MenuPunkt 1 = Aktueller Pkt.
        bsr             RENDERMPOINT          ; Umrahme Menuepunkt !
        bra             INTERMENUL            ; -> InterMenuL

* Routine zieht Rahmen um Menuepunkt der in MB_MENU steht und rettet zuvor
* Background
RENDERMPOINT:
        move.w          MB_MENU(a5),d0        ; Aktuellen Menuepunkt -> d0
        mulu            #6,d0                 ; Haesslich !
        lea             MB_COORDS(a5,d0.w),a4 ; CoordBase -> a4
        movem.w         (a4),d0-d2            ; Coords -> d0 - d2
        exg             d1,d2                 ; Swap X2 mit Y
        subq.w          #8,d0                 ; DEC X1
        addq.w          #8,d1                 ; INC X2
        subq.w          #DECLIN,d2            ; DEC Y
        move.w          #1,COLOR(a6)          ; Setze Farbe fuer Linie
        bsr             SAVE1LINE             ; Rette 1. Zeile BCK
        movem.w         d0-d2,-(a7)           ; Save Coords on Stack !
        bsr             HORLINE1              ; Ziehe horizontale Linie
        movem.w         (a7)+,d0-d2           ; Get Coords from Stack !
        movea.l         CHARPTR(a6),a4        ; Adresse der Charsetdaten -> a4
        add.w           CH_HEIGHT(a4),d2      ; ADD Zeichenhoehe
        addq.w          #INCLIN,d2            ; INC Y
        bsr             SAVE2LINE             ; Rette 2. Zeile BCK
        bsr             HORLINE1              ; Ziehe horizontale Linie
        rts                                   ; Back !

* Routine rettet Background der 2. Linie
SAVE2LINE:
        lea             PLANES(a6),a4         ; a4 Pointer auf Planes
        movem.l         (a4),a0-a3            ; Pointer auf Bitplanes -> a0-a3
        lea             LINEPL2,a4            ; Zeiger auf Buffer -> a4
        bra.s           SAVELINE              ; -> SaveLine

* Routine rettet Background der 1. Linie
SAVE1LINE:
        lea             PLANES(a6),a4         ; a4 Pointer auf Planes
        movem.l         (a4),a0-a3            ; Pointer auf Bitplanes -> a0-a3
        lea             LINEPL1,a4            ; Zeiger auf Buffer -> a4
SAVELINE:
        move.w          d2,d3                 ; d2 -> d3
        add.w           d3,d3                 ; d3 * 2 fuer Wortzugriff
        move.w          MULU160(a6,d3.w),d3   ; Y-Offset -> d3
        adda.w          d3,a0                 ; ADD Offset 1. Plane
        adda.w          d3,a1                 ; ADD Offset 2. Plane
        adda.w          d3,a2                 ; ADD Offset 3. Plane
        adda.w          d3,a3                 ; ADD Offset 4. Plane

        movem.l         (a0)+,d3-d7           ; Get 1. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset
        movem.l         (a0)+,d3-d7           ; Get 1. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset

        movem.l         (a1)+,d3-d7           ; Get 2. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset
        movem.l         (a1)+,d3-d7           ; Get 2. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset

        movem.l         (a2)+,d3-d7           ; Get 3. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset
        movem.l         (a2)+,d3-d7           ; Get 3. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset

        movem.l         (a3)+,d3-d7           ; Get 4. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer
        lea             20(a4),a4             ; ADD Offset
        movem.l         (a3)+,d3-d7           ; Get 4. PlaneDatas -> d3 - d7
        movem.l         d3-d7,(a4)            ; Put it in SaveBuffer

        rts                                   ; Back !

* Routine schreibt Menuepunkte in Bildschirm
* Input:
*       a0 = Pointer to Menutxt
MAKEPOINTS:
        lea             MENUPORT(pc),a5       ; MenuPortBase -> a5
        lea             MB_COORDS(a5),a6      ; MenuPortBase -> a6
        move.w          #1,SCRPORT+CHAREFF    ; Setze Effekt auf Outline !
        move.l          (a0)+,SCRPORT+CHARPTR ; Setze Zeichensatz
MAKEPLOOP:
        move.b          (a0)+,d0              ; Hole X-Koordinate
        move.b          (a0)+,d1              ; Hole Y-Koordinate
        cmp.b           #$ff,d1               ; Ist Ende ?
        beq.s           MAKEPOINTSENDE        ; Ja -> Ende
        and.w           #$00ff,d0             ; X Word erweitern
        and.w           #$00ff,d1             ; Y Word erweitern
        move.w          d0,(a6)+              ; X-Koordinate retten
        move.w          d1,(a6)+              ; Y-Koordinate retten
        addq.w          #1,MB_COUNT(a5)       ; INC MenuCount
        movem.l         a5-a6,-(a7)           ; Save Regs on Stack !
        bsr             PROPSTRING            ; Gebe Zeichen aus
        movem.l         (a7)+,a5-a6           ; Get Regs from Stack !
        move.w          d0,(a6)+              ; Ende X -> MenuPort
        bra.s           MAKEPLOOP             ; -> Loop
MAKEPOINTSENDE:
        subq.w          #1,MB_COUNT(a5)       ; DEC MenuCount
        move.l          a0,d0                 ; Zeiger auf Ende -> d0
        btst            #0,d0                 ; Is ODD ?
        beq.s           ENDNOTODD             ; Nein -> EndnotOdd
        addq.w          #1,a0                 ; INC EndAdr
ENDNOTODD:
        move.l          a0,MB_ROUTS(a5)       ; Zeiger auf Routinen ablegen !
        rts                                   ; Back

* Routine gibt eine Seite des Rankings aus
OUTPAGE:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             RANKOFFS,a1           ; RankOffsBase -> a1
        lea             TABLEMALE,a2          ; TableMaleBase -> a1
        move.w          #2,CHAREFF(a6)        ; Setze CharEffect
        move.l          CHARGAME(pc),CHARPTR(a6) ; Setze Zeichenssatz
        moveq           #16,d1                ; Init Y-Koordinate
        moveq           #0,d6                 ; Init PageCounter
        move.w          RANKENTRIE,d7         ; Start holen !
OUTPAGELOOP:
        bsr             RANKNUMBER            ; Gebe Plazierung aus !
        bsr             RANKNAME              ; Gebe Namen aus !
        bsr             RANKPOINTS            ; Gebe Punkte aus !
        cmp.w           #MAXRANKS-1,d7        ; Absolutes Ende erreicht ?
        bgt.s           OUTPAGEENDE           ; Ja -> Ende
        cmp.w           #PAGESIZE,d6          ; Ist eine Page ausgegeben ?
        bge.s           OUTPAGEENDE           ; Ja -> Ende
        addq.w          #1,d6                 ; INC PageCount
        addq.w          #1,d7                 ; INC AbsCount
        add.w           #22,d1                ; INC Y-Koordinate
        bra.s           OUTPAGELOOP           ; -> Loop
OUTPAGEENDE:
        rts                                   ; Back !

* Routine gibt die Punkte aus
RANKPOINTS:
        move.w          d7,d5                 ; AbsCount -> d5
        add.w           d5,d5                 ; * 2 fuer Wortzugriff
        move.w          0(a1,d5.w),d5         ; Get Offset !
        move.w          PL_RANK(a2,d5.w),d4   ; Hole Ranking !
        asr.w           #7,d4                 ; / 128
        movem.l         d1/a1,-(a7)           ; Save Regs on Stack !
        bsr             DECUMRECHNUNG         ; Wandle Zahl in DEC-ASCII
        movem.l         (a7)+,d1/a1           ; Get Regs from Stack !
        lea             OUBUFFER(pc),a0       ; Buffer -> a0
        bsr             PROPWIDTH             ; Get Width of String !
        move.w          d0,d5                 ; Breite des Str -> d5
        move.w          #316,d0               ; RechtsbundX -> d0
        sub.w           d5,d0                 ; SUB Width of Str
        bra.s           PAGESTROUT            ; Gebe String aus !

* Routine gibt den Namen aus !
RANKNAME:
        move.w          d7,d5                 ; AbsCount -> d5
        add.w           d5,d5                 ; * 2 fuer Wortzugriff
        move.w          0(a1,d5.w),d5         ; Get Offset !
        lea             PL_NAME(a2,d5.w),a0   ; Hole Ptr to Name !
        move.w          #40,d0                ; Set X = 40
        bra.s           PAGESTROUT            ; Gebe String aus !

* Routine gibt die Plazierung aus !
RANKNUMBER:
        move.w          d7,d4                 ; AbsCount -> d4
        addq.w          #1,d4                 ; INC Count
        ext.l           d4                    ; Oberes Wort null !
        movem.l         d1/a1,-(a7)           ; Save Regs on Stack !
        bsr             DECUMRECHNUNG         ; Wandle Zahl in DEC-ASCII
        movem.l         (a7)+,d1/a1           ; Get Regs from Stack !
        lea             OUBUFFER(pc),a0       ; OutBufferBase -> a0
        bsr             PROPWIDTH             ; Get Width of String !
        move.w          d0,d5                 ; Breite des Str -> d5
        moveq           #34,d0                ; RechtsbundX -> d0
        sub.w           d5,d0                 ; SUB Width of Str
PAGESTROUT:
        movem.l         d1/d6-d7/a1-a2,-(a7)  ; Save Regs on Stack
        bsr             PROPSTRING            ; Gebe Zeichen aus !
        movem.l         (a7)+,d1/d6-d7/a1-a2  ; Get Regs from Stack
        rts                                   ; Back !

* Routine initialisiert Menueport mit Null-Bytes
INITMENUPORT:
        move.l          #COPSET2,COPSLOT      ; VBLSlot belegen
        lea             MENUPORT(pc),a0       ; MenuPortBase -> a0
        move.w          #MB_SIZEOF/2-1,d7     ; Init LoopCounter
INITMENULOOP:
        move.w          #0,(a0)+              ; Zero it!
        dbra            d7,INITMENULOOP       ; -> Loop
        rts                                   ; Back !

* Routine kopiert MenueBackground in Bildschirmspeicher
GETMENUBCK:
        move.l          PLATTEPTR(pc),PACKBUFFER ; Pointer auf GFXDaten -> Pack
        bra             DISPLAYIFF            ; -> DisplayIFF

* Routine richtet Platz fuer Spiel ein
MAKEPLAYCOURT:
        bsr             MAKETRAINCOURT        ; -> MakeTrainCourt
        bra             COPYREFS              ; Kopiere Schiedsrichter ein !

* Routine richtet Platz fuer Training ein
MAKETRAINCOURT:
        move.l          PLATZPTR(pc),PACKBUFFER ; PTR GFXDaten -> PackBuffer

* Routine stellt IFF-Bild aus Buffer im Display dar
DISPLAYIFF:
        jmp             READIFF               ; -> ReadIFF

* Routine kopiert NeochromeBild im DoubleBuffer in Bildschirm
COPYSPCNEO:
        movea.l         DPPORT(pc),a5         ; Pointer auf GFXDaten -> a5
        bsr             COPYACTEFF            ; Kopiere aktuelle Pal. in CList
        bsr             COPYNEXEFF            ; Kopier kommende Pal. in CList
        bsr             COPYNEOE              ; Kopiere Neo in Bildschirm(EFF)!
        bsr             WAITBEAM              ; Warte Ende Display
        bsr             COPYNEOPAL            ; Kopiere Palette endgueltig !
        rts                                   ; Back !

COPYNEOE:
        moveq           #99,d6                ; Init LoopCounter !
        moveq           #100,d4               ; In the Middle !
        move.w          d4,d5                 ; In the Middle !
COPYEFFLOOP:
        bsr             WAITBEAM              ; Warte Ende Display
        move.w          d4,d1                 ; d4 -> d1
        bsr             COPSWITCH1            ; Generiere 1. Copperumschal.
        bsr             COPYNEOONE            ; Copiere eine Zeile !
        move.w          d5,d1                 ; d5 -> d1
        bsr             COPSWITCH2            ; Generiere 2. Copperumschal.
        bsr             COPYNEOONE            ; Copiere eine Zeile !
        subq.w          #1,d4                 ; DEC Y
        addq.w          #1,d5                 ; INC Y
        dbra            d6,COPYEFFLOOP        ; -> Loop
        moveq           #0,d1                 ; Zeile 0 noch kopieren
        bsr             COPYNEOONE            ; Copiere eine Zeile !
        bsr             WAITBEAM              ; Warte Ende Display
        movea.l         SCRPORT+COPPTR,a0     ; CopperPtr -> a0
        lea             COPEFF1OFF(a0),a0     ; Offset addieren
        move.l          #$fffffffe,-8(a0)     ; Ende wieder setzen !
        move.l          #$009c8010,-12(a0)    ; LogikWait wieder setzen !
        move.l          #$009ac010,-16(a0)    ; LogikWait wieder setzen !
        move.l          #$5011fffe,-20(a0)    ; LogikWait wieder setzen !
        rts                                   ; Back !

* Routine generiert ersten Farbumschaltung mit Copper !
* Input:
*       d1 = Zeile
COPSWITCH1:
        movea.l         SCRPORT+COPPTR,a0     ; CopperPtr -> a0
        lea             COPEFF1OFF(a0),a0     ; Offset addieren
        move.w          d1,d2                 ; Zeile -> d2
        move.l          (a0),-8(a0)           ; COLOR00
        move.l          (a0),-12(a0)          ; LogikWait entfernen !
        move.l          (a0),-16(a0)          ; LogikWait entfernen !
        move.l          (a0),-20(a0)          ; LogikWait entfernen !
        add.w           SCRPORT+DVY,d2        ; DisplayStart addieren
        lsl.w           #8,d2                 ; << 8
        or.w            #1,d2                 ; It is a Wait !
        move.w          d2,-4(a0)             ; Wait ablegen !
        move.w          #$fffe,-2(a0)         ; WaitMaske ablegen !
        rts

* Routine generiert zweite Farbumschaltung mit Copper !
* Input:
*       d1 = Zeile
COPSWITCH2:
        movea.l         SCRPORT+COPPTR,a0     ; CopperPtr -> a0
        lea             COPEFF2OFF(a0),a0     ; Offset addieren
        move.w          d1,d2                 ; Zeile -> d2
        addq.w          #1,d2                 ; INC Zeile
        add.w           SCRPORT+DVY,d2        ; DisplayStart addieren
        move.l          (a0),-8(a0)           ; COLOR00
        cmp.w           #255,d2               ; Groesser 255 ?
        ble.s           NOSECWAIT             ; Nein -> NoSecWait
        sub.w           #256,d2               ; SUB 255
        move.l          #$ffdffffe,-8(a0)     ; Wait 255
NOSECWAIT:
        lsl.w           #8,d2                 ; << 8
        or.w            #1,d2                 ; It is a Wait !
        move.w          d2,-4(a0)             ; Wait ablegen !
        move.w          #$fffe,-2(a0)         ; WaitMaske ablegen !
        rts

* Routine kopiert eine Zeile Neochrome-Format in gleiche Zeile vom Display
* Input:
*       d1 = Zeile
COPYNEOONE:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          d1,d2                 ; Zeile -> d2
        add.w           d1,d1                 ; * 2 fuer Wortzugriff
        move.w          MULU160(a6,d1.w),d1   ; Hole Offset !
        movem.l         PLANES(a6),a0-a3      ; Pointer to Plane -> a1
        lea             0(a0,d1.w),a0         ; Offset addieren 1. Plane
        lea             0(a1,d1.w),a1         ; Offset addieren 2. Plane
        lea             0(a2,d1.w),a2         ; Offset addieren 3. Plane
        lea             0(a3,d1.w),a3         ; Offset addieren 4. Plane
        mulu            #160,d2               ; * AtariRasterzeile
        lea             0(a5,d2.w),a4         ; Pointer -> a4
        adda.w          #128,a4               ; ADD Neo-Offset
        moveq           #19,d7                ; Init LoopCounter !
NEONELOOP:
        movem.w         (a4)+,d0-d3           ; GFXDaten -> d0 - d3
        move.w          d0,(a0)+              ; Kopiere Daten
        move.w          d1,(a1)+              ;
        move.w          d2,(a2)+              ;
        move.w          d3,(a3)+              ;
        dbra            d7,NEONELOOP          ; -> Loop
        rts

* Routine kopiert die erscheinende Palette in 1. Effektbuffer von Copper
COPYNEXEFF:
        lea             4(a5),a0              ; NeoPalBase -> a0
        movea.l         SCRPORT+COPPTR,a1     ; CopperPtr -> a1
        lea             COPEFF1OFF(a1),a1     ; 2. Effekt-Offset addieren
        moveq           #15,d7                ; Init LoopCounter !
COPYACTLOOP:
        addq.w          #2,a1                 ; INC a1
        move.w          (a0)+,d0              ; Hole NeoFarbWert !
        add.w           d0,d0                 ; << 1
        move.w          d0,(a1)+              ; Lege in Copperliste !
        dbra            d7,COPYACTLOOP        ; -> Loop
        rts

* Routine kopiert die aktuelle FarbPalette in 2. EffektBuffer von Copper
COPYACTEFF:
        lea             ACTCOLTABLE(pc),a0    ; ActColTableBase -> a0
        movea.l         SCRPORT+COPPTR,a1     ; CopperPtr -> a1
        lea             COPEFF2OFF(a1),a1     ; 2. Effekt-Offset addieren
        moveq           #15,d7                ; Init LoopCounter !
COPYACTELOOP:
        addq.w          #2,a1                 ; INC a1
        move.w          (a0)+,(a1)+           ; Copy ColorValues !
        dbra            d7,COPYACTELOOP       ; -> Loop
        rts                                   ; Back !

* Routine zieht alle Farben dunkel
DIMMEROFF:
        lea             ACTCOLTABLE(pc),a2    ; ActColTable -> a2
        lea             DIMCOLTABLE(pc),a3    ; DimColTable -> a3
        movea.l         a3,a4                 ; DimColTable -> a4
        moveq           #0,d5                 ; d5 = FLAG !
        moveq           #31,d7                ; Init LoopCounter
DIMMEROFFLOOP:
        move.w          (a2)+,d0              ; Hole FarbWert -> d0
        move.w          d0,d1                 ; Gwert -> d1
        move.w          d0,d2                 ; BWert -> d2
        and.w           #$0f00,d0             ; AND It!
        beq.s           SUBNRED               ; = 0 -> SubNRed
        sub.w           #$0100,d0             ; DEC Red
        moveq           #1,d5                 ; Set Flag !
SUBNRED:
        and.w           #$00f0,d1             ; AND GWert!
        beq.s           SUBNGREEN             ; = 0 -> SubNGreen
        sub.w           #$0010,d1             ; DEC Green
        moveq           #1,d5                 ; Set Flag !
SUBNGREEN:
        and.w           #$000f,d2             ; AND BWert!
        beq.s           SUBNBLUE              ; = 0 -> SubNBlue
        subq.w          #$01,d2               ; DEC Blue
        moveq           #1,d5                 ; Set Flag !
SUBNBLUE:
        or.w            d1,d0                 ; OR Green
        or.w            d2,d0                 ; OR Blue
        move.w          d0,(a3)+              ; Lege Wert in DimColTable ab !
        dbra            d7,DIMMEROFFLOOP      ; -> Loop
        movea.l         a4,a0                 ; DimColTable -> a0
        lea             CUSTOM+COLOR00,a1     ; Base of ColorHardRegs -> a1
        moveq           #31,d7                ; Init Counter!
        bsr             WAITBEAM              ; Warte auf Strahl
        bsr             CPUCOPY               ; -> CpuCopy
        tst.w           d5                    ; Test Flag !
        beq             RETURN                ; = 0 -> Ende
        moveq           #31,d7                ; Init LoopCounter
        movea.l         a4,a3                 ; DimColTable -> a3
        movea.l         a4,a2                 ; DimColTable jetzt auch Source !
        moveq           #0,d5                 ; Clear Flag !
        bra             DIMMEROFFLOOP         ; -> Loop

* Routine zieht alle Farben auf Destination
DIMMERON:
        lea             DIMCOLTABLE(pc),a2    ; DimColTable -> a2
        lea             ACTCOLTABLE(pc),a3    ; ActColTable -> a3
        movea.l         a2,a4                 ; DimColTable -> a4
        movea.l         a3,a5                 ; ActColTable -> a5
        movea.l         a2,a1                 ; DimColTable -> a4
        lea             ZEROTABLE(pc),a0      ; TeroTableBase -> a0
        moveq           #31,d7                ; Init LoopCounter
        bsr             CPUCOPY               ; -> CpuCopy
        moveq           #0,d6                 ; d6 = FLAG = 0 !
        moveq           #31,d7                ; Init LoopCounter
DIMMERONLOOP:
        move.w          (a2),d0               ; Hole FarbWert -> d0
        move.w          d0,d1                 ; Gwert -> d1
        move.w          d0,d2                 ; BWert -> d2
        move.w          (a3)+,d3              ; DestCol -> d3
        move.w          d3,d4                 ; GWert -> d4
        move.w          d3,d5                 ; BWert -> d5
        and.w           #$0f00,d0             ; AND Source !
        and.w           #$0f00,d3             ; AND Dest  !
        cmp.w           d0,d3                 ; CMP Source, Dest
        beq.s           ADDNRED               ; = 0 -> AddNRed
        add.w           #$0100,d0             ; INC Red
        moveq           #1,d6                 ; Set Flag !
ADDNRED:
        and.w           #$00f0,d1             ; AND Source !
        and.w           #$00f0,d4             ; AND Dest !
        cmp.w           d1,d4                 ; CMP Source, Dest
        beq.s           ADDNGREEN             ; = 0 -> addNGreen
        add.w           #$0010,d1             ; INC Green
        moveq           #1,d6                 ; Set Flag !
ADDNGREEN:
        and.w           #$000f,d2             ; AND Source !
        and.w           #$000f,d5             ; AND Dest !
        cmp.w           d2,d5                 ; CMP Source, Dest
        beq.s           ADDNBLUE              ; = 0 -> AddNBlue
        addq.w          #$01,d2               ; INC Blue
        moveq           #1,d6                 ; Set Flag !
ADDNBLUE:
        or.w            d1,d0                 ; OR Green
        or.w            d2,d0                 ; OR Blue
        move.w          d0,(a2)+              ; Lege Wert in DimColTable ab !
        dbra            d7,DIMMERONLOOP       ; -> Loop
        movea.l         a4,a0                 ; DimColTable -> a0
        lea             CUSTOM+COLOR00,a1     ; Base of ColorHardRegs -> a1
        moveq           #31,d7                ; Init Counter!
        bsr             WAITBEAM              ; Warte auf Strahl
        bsr             CPUCOPY               ; -> CpuCopy
        tst.w           d6                    ; Test Flag !
        beq             RETURN                ; = 0 -> Ende
        moveq           #31,d7                ; Init LoopCounter
        movea.l         a5,a3                 ; ActColTable -> a3
        movea.l         a4,a2                 ; DimColTable -> a2
        moveq           #0,d6                 ; Clear Flag !
        bra             DIMMERONLOOP          ; -> Loop

* Routine blendet Screen-Pixelweise aus
PIXOFF: lea             SCRPORT(pc),a6
        movem.l         PLANES(a6),a0-a3
        moveq           #0,d3
        move.w          #$b405,d4
        moveq           #-1,d7
        move.w          #63999,d5

LOOP3:  lsr.w           #1,d3
        bhi.s           LOOP1
LOOP4:  eor.w           d4,d3
LOOP1:  cmp.w           d5,d3
        bcc.s           LOOP3
LOOP2:  move.w          d3,d2
        lsr.w           #3,d2
        bclr            d3,0(a0,d2.w)
        bclr            d3,0(a1,d2.w)
        bclr            d3,0(a2,d2.w)
        bclr            d3,0(a3,d2.w)
        dbra            d7,LOOP3
        lea             ZEROTABLE(pc),a0
        lea             COLOR00+CUSTOM,a1
        moveq           #31,d7
        bra             CPUCOPY

* Routine kopiert FarbInformationen eines NeoBildes in ColorRegister
* Input:
*       a5 = Base of NeoPic
COPYNEOPAL:
        lea             4(a5),a0              ; Add ColorOffset
        lea             CUSTOM+COLOR00,a1     ; Base HardwareColorRegs -> a1
        lea             ACTCOLTABLE(pc),a2    ; AvtColTableBase  -> a2
        move.w          #15,d7                ; 16 Farben = LoopCounter
COPYPALL:
        move.w          (a0)+,d0              ; Hole Farbwert ( Neo )
        add.w           d0,d0                 ; < 1
        move.w          d0,(a1)+              ; New Value in ColorReg
        move.w          d0,(a2)+              ; Als aktuelle Palette ablegen !
        dbra            d7,COPYPALL           ; -> Loop
        rts                                   ; Back !

* Routine kopiert FarbInformationen eines NeoBildes in ActColTable
* Input:
*       a5 = Base of NeoPic
COPYNEOPALA:
        lea             4(a5),a0              ; Add ColorOffset
        lea             ACTCOLTABLE(pc),a1    ; AvtColTableBase  -> a1
        move.w          #15,d7                ; 16 Farben = LoopCounter
COPYPALAL:
        move.w          (a0)+,d0              ; Hole Farbwert ( Neo )
        add.w           d0,d0                 ; < 1
        move.w          d0,(a1)+              ; New Value in ColorReg
        dbra            d7,COPYPALAL          ; -> Loop
        rts                                   ; Back !

* Routine kopiert NeoPic in Bildschirmspeicher
* Input:
*        a5 = Base of NeoPic
COPYNEOPIC:
        movem.l         SCRPORT+PLANES,a0-a3  ; Hole PlanePointer -> a0 - a3
        lea             128(a5),a4            ; Add DataOffset auf a4
        move.w          #3999,d7              ; Init LoopCounter !
COPYNEOLOOP:
        movem.w         (a4)+,d0-d3           ; Bilddaten -> d0 - d3
        move.w          d0,(a0)+              ; In Bitplane 1
        move.w          d1,(a1)+              ; In Bitplane 2
        move.w          d2,(a2)+              ; In Bitplane 3
        move.w          d3,(a3)+              ; In Bitplane 4
        dbra            d7,COPYNEOLOOP        ; -> Loop
        rts                                   ; Back !

* Routine setzt Farben auf SGOS
SETSGOSPAL:
        lea             SGOSCOLOR(pc),a0      ; Base of Values -> a0
        lea             ACTCOLTABLE(pc),a1    ; Base of ActColTable -> a1
        moveq           #15,d7                ; Init LoopCounter
        bra             CPUCOPY               ; -> CpuCopy

* Routine uebernimmt TurnierLogik
TOURNLOGIK:
        lea             TOURNPORT,a5          ; TournPortBase -> a5
        move.w          TD_ROUND(a5),d0       ; Round -> d0
        addq.w          #1,d0                 ; INC Round
        cmp.w           #5,d0                 ; Is > MaxRound
        ble.s           NOTGMAXROUND          ; Nein -> NotGMaxRound
        bsr             BILANZ                ; -> Bilanz
        moveq           #1,d0                 ; 1. Runde -> d0
        addq.w          #1,TD_WHICH(a5)       ; INC Which !
        cmpi.w          #3,TD_WHICH(a5)       ; Letzes Turnier ?
        ble.s           NOTGMAXROUND          ; Nein -> NotGmaxGround
        addq.w          #1,TD_CIRCUIT(a5)     ; INC Circuit-Rounds
        clr.w           TD_WHICH(a5)          ; First Tournament !
NOTGMAXROUND:
        cmp.w           #1,d0                 ; Ist 1. Runde ?
        bne.s           NONEWTOURNAMENT       ; Nein -> NoNewTournament !
        bra             NEWTOURNAMENT         ; -> NewTournament
NONEWTOURNAMENT:
        move.w          d0,TD_ROUND(a5)       ; Lege Round ab !
        rts                                   ; Back !

* Alle Funktionen fuer neues Turnier
NEWTOURNAMENT:
        move.w          d0,TD_ROUND(a5)       ; Lege Round ab !
        bsr             CHOOSEOPPO            ; Hole 1. Gegner !
        bsr             CLEARSCREEN           ; Loesche Display
        move.w          TD_WHICH(a5),d1       ; Welches Turnier -> d1
        mulu            #12,d1                ; * 12 fuer TabellenZugriff
        lea             TOURNS,a1             ; TournsBase -> a1
        lea             0(a1,d1.w),a1         ; ADD Offset
        movea.l         (a1)+,a0              ; Name of Points -> a0
        move.l          a1,-(a7)              ; Save Reg on Stack !
        bsr             GENERATECOLS          ; FarbPaletten generieren !
        movea.l         (a7)+,a1              ; Get Reg from Stack
        movea.l         (a1)+,a0              ; Name of Points -> a0
        move.l          a1,-(a7)              ; Save Reg on Stack !
        bsr             MAKEPOINTS            ; Gebe Text aus !
        bsr             DIMMERON              ; Colors On !
        movea.l         (a7)+,a1              ; Get Reg from Stack
        movea.l         (a1),a0               ; Name -> a0
        bsr             ALLIRQ                ; Alle IRQs an !
        bsr             GETINBUFFER           ; Lese Bilddaten in 2. Screen
        bsr             ONLYIRQ               ; Nur mein IRQ !
        bsr             COPYSPCNEO            ; Einblenden des NeoBildes
        bsr             WAITS                 ; Warte auf Button !
        bra             PIXOFF                ; All Black !

* Routine erhoeht Rankingpunkte nach einem Turnier
BILANZ:
        lea             TOURNOPP32,a0         ; TournOffsetBase -> a0
        lea             TABLEMALE,a1          ; TableMaleBase -> a1
        moveq           #32,d5                ; 32 -> d5 = MasterLoopCounter
        moveq           #5,d6                 ; Init 1. LoopCounter
        moveq           #31,d7                ; Init 2. LoopCounter
BILANZLOOP:
        move.w          (a0)+,d4              ; Get Offset
        addi.w          #256,PL_RANK(a1,d4.w) ; INC Ranking
        dbra            d7,BILANZLOOP         ; -> Loop
        lsr.w           #1,d5                 ; MasterLoopCounter -> d5
        move.w          d5,d7                 ; d5 -> d7
        beq.s           NOSUBCNT              ; = 0 -> NoSubCnt
        subq.w          #1,d7                 ; DEC LoopCounter
NOSUBCNT:
        dbra            d6,BILANZLOOP         ; -> Loop
        rts                                   ; Back !

* Routine generiert Ergebnisse der uebrigen Spiele
GENRESULTS:
        bsr             TOURNLOGIK            ; -> TurnierLogik
        lea             TOURNOPPP,a1          ; TableBase -> a1
        lea             RESULTSPTR,a2         ; ResultTableBase -> a2
        lea             TABLEMALE,a3          ; Tabelle der Player -> a3
        move.w          TD_ROUND+TOURNPORT,d0 ; Hole aktuelle Runde
        subq.w          #1,d0                 ; DEC Round
        lsl.w           #3,d0                 ; * 8 fuer Tabellenzugriff
        move.l          0(a1,d0.w),d7         ; Hole Anzahl der Ergebnisse
        movea.l         12(a1,d0.w),a4        ; Hole Pointer auf WinnerAblage !
        movea.l         4(a1,d0.w),a1         ; Hole Pointer auf Offsets !
        lsr.w           #1,d0                 ; / 2 fuer Tabellenzugriff
        movea.l         0(a2,d0.w),a2         ; Hole Pointer auf Resultablage
        movea.l         a2,a5                 ; PTR to Results -> a5
        lsr.w           #1,d7                 ; LoopCounter / 2
        subq.w          #1,d7                 ; DEC LoopCounter
GENRESULTLOOP:
        bsr             WHOWINS               ; Wer gewinnt ueberhaupt ?
        bsr             HOWMANYSETS           ; In wieviel Saetzen ?
        bsr             HOWWINS               ; Und in Zahlen !
        adda.w          #PR_SIZEOF,a5         ; Ein Ergebnis weiter !
        movea.l         a5,a2                 ; a2 wieder Zeiger auf Ergebnis !
        dbra            d7,GENRESULTLOOP      ; -> Loop
        rts                                   ; Back !

* Routine legt nach Rankingpunkten und Zufall den Gewinner eines Spiels fest
WHOWINS:
        move.w          (a1)+,d5              ; Hole 1. Offset auf Rangliste
        move.w          (a1)+,d6              ; Hole 2. Offset auf Rangliste
        move.w          #-1,WHOFLAG           ; Loesche WhoFlag
        move.w          d5,d2                 ; 1. Offset -> d2
        move.w          d6,d3                 ; 2. Offset -> d3
        move.w          PL_RANK(a3,d5.w),d5   ; Hole 1. Ranking
        move.w          PL_RANK(a3,d6.w),d6   ; Hole 2. Ranking
        cmp.w           d5,d6                 ; Vergleiche Rankings
        bge.s           RNK2GRNK1             ; Kleiner -> RNK2gRNK1
        exg             d5,d6                 ; Vertausche Ranking !
        exg             d2,d3                 ; Vertausche Offsets !
        not.w           WHOFLAG               ; INV WhoFlag
RNK2GRNK1:
        bsr             RANDOM                ; Get RandomNumber !
        move.w          d6,d1                 ; RNK2 -> d1
        sub.w           d5,d1                 ; SUB RNK1
        move.w          d1,d4                 ; RNK2 - RNK1 -> d4
        asr.w           #1,d4                 ; / 2
        add.w           d4,d1                 ; ADD
        beq.s           NORANKDELTA           ; = 0 -> NoRankDelta
        ext.l           d0                    ; d0 LangWorterweitern !
        move.l          #32768,d4             ; 32768 -> d4
        divs            d1,d4                 ; 32768 / Sollwert
        divs            d4,d0                 ; RND / SollDividend
NORANKDELTA:
        move.w          d5,d4                 ; RNK1 -> d4
        add.w           d0,d4                 ; ADD RND-Value
        cmp.w           d4,d6                 ; Vergl. neuen Wert mit RNK2
        bge.s           RNK2IGRNK1            ; Kleiner -> RNK2igRNK1
        exg             d4,d6                 ; Vertausche Ranking !
        exg             d2,d3                 ; Vertausche Offsets !
        not.w           WHOFLAG               ; INV WhoFlag
RNK2IGRNK1:
        sub.w           d4,d6                 ; DeltaRanking bilden !
        move.w          d6,DELTARANK          ; Lege DeltaRanking ab !
        move.w          d3,(a4)+              ; SiegerOffset ablegen !
        rts                                   ; Back !

WHOFLAG:        DC.W 0                  ; Flag wer gewonnen hat
DELTARANK:      DC.W 0                  ; DeltaRanking
* Routine errechnet per Zufall, wieviele Saetze gespielt wurden !
* Input:
*       d1 = WinFlag ( 1 = 2. Spieler hat gewonnen )
* Output:
*       d4 = Verteilung der Saetze
*       d5 = Anzahl der Saetze
*       d6 = WinFlag
HOWMANYSETS:
        move.w          DELTARANK(pc),d0      ; DeltaRanking -> d0
        moveq           #0,d1                 ; d1 = 0
        cmp.w           #70,d0                ; DeltaRanking > 70
        ble.s           NOTHREESET            ; Nein -> NotThreeSet
        moveq           #3,d5                 ; SetBase -> d5
        lsr.w           #1,d0                 ; DeltaRank >> 1
        addx.w          d1,d5                 ; X-Flag addieren
        bra.s           NOTTOOMSET            ; -> NotToomSet
NOTHREESET:
        cmp.w           #20,d0                ; DeltaRanking > 20
        ble.s           NOFOURSET             ; Nein -> NoFourSet
        moveq           #4,d5                 ; SetBase -> d5
        lsr.w           #1,d0                 ; DeltaRank >> 1
        addx.w          d1,d5                 ; X-Flag addieren
        bra.s           NOTTOOMSET            ; -> NotToomSet
NOFOURSET:
        moveq           #5,d5                 ; SetBase -> d5
        lsr.w           #1,d0                 ; DeltaRank >> 1
        subx.w          d1,d5                 ; X-Flag addieren
NOTTOOMSET:
        cmp.w           #3,d5                 ; 3 Saetze ?
        bgt.s           FOURSETS              ; Nein -> FourSets
        move.b          #$07,d4               ; Satzverteilung -> d4 !
        rts                                   ; Back !
FOURSETS:
        cmp.w           #4,d5                 ; 4 Saetze ?
        bgt.s           FIVESETS              ; Nein -> FiveSets
        bsr             RANDOM                ; Hole RandomNumber !
        and.l           #$00007fff,d0         ; No Neg !
        divu            #18000,d0             ; / 18000
        lea             SETPOS1,a0            ; MoeglichkeitenTabelle -> a0
        move.b          0(a0,d0.w),d4         ; Satzverteilung -> d4
        rts                                   ; Back !
FIVESETS:
        bsr             RANDOM                ; Hole RandomNumber !
        and.l           #$00007fff,d0         ; No Neg !
        divu            #8000,d0              ; / 6000
        lea             SETPOS2,a0            ; MoeglichkeitenTabelle -> a0
        move.b          0(a0,d0.w),d4         ; Satzverteilung -> d4
        rts                                   ; Back !

* Routine generiert Ergebnis
* Input:
*       d4 = Verteilung der Saetze
*       d5 = Anzahl der Saetze
*       d6 = WinFlag
HOWWINS:
        lea             PR_RESULT(a2),a6      ; PTR to Results -> a6
        move.b          d5,(a2)+              ; Saetze ablegen !
        subq.w          #1,d5                 ; DEC LoopCounter
        move.w          d5,d2                 ; LoopCounter -> d2
        move.w          d4,d3                 ; Verteilung der Saetze -> d3
        not.w           d4                    ; VerliererVerteilung
        tst.w           WHOFLAG               ; Test Winflag !
        beq.s           STURBSTAYS            ; = 0 -> SturbStays
        exg             d3,d4                 ; EXG Gewinner- VerliererTeilung
STURBSTAYS:
        bsr             WINNERSETS            ; Generiere Gewinner-Ergebnis
        bsr             LOOSERSETS            ; Generiere Verlierer-Ergebnis
        rts                                   ; Back !

WINNERSETS:
        lsr.w           #1,d3                 ; SHIFT WinVerteilung
        bcs.s           SETWIN                ; Carry Set -> SetWin
        bsr             RANDOM                ; Hole ZufallsZahl
        and.l           #$00007fff,d0         ; RNDNumber not Neg !
        divu            #5000,d0              ; RND zwischen 0 - 6
        add.b           #"0",d0               ; Make it ASCII !
        move.b          d0,(a2)+              ; Ablegen !
WINNERLOOP:
        dbra            d5,WINNERSETS         ; -> Loop
        rts                                   ; Back !
SETWIN:
        bsr             RANDOM                ; Hole ZufallsZahl !
        and.w           #$0001,d0             ; Zufall zwischen 0 - 1
        add.b           #$36,d0               ; SatzWin und ASCII addieren
        move.b          d0,(a2)+              ; Ablegen !
        bra.s           WINNERLOOP            ; -> WinnerLoop

LOOSERSETS:
        lsr.w           #1,d4                 ; SHIFT WinVerteilung !
        bcs.s           SETWIN1               ; Carry Set -> SetWin1
        bsr             RANDOM                ; Hole ZufallsZahl
        and.l           #$00007fff,d0         ; RNDNumber not Neg !
        divu            #5000,d0              ; RND zwischen 0 - 6
        add.b           #"0",d0               ; Make it ASCII !
        cmpi.b          #"7",(a6)             ; WinnerSet < 7
        blt.s           LOWERSEVEN            ; Ja -> LowerSeven
        move.b          #"5",d0               ; Ergebnis = 5
        bra.s           RESOK                 ; -> ResOk
LOWERSEVEN:
        cmp.b           #"5",d0               ; Ist 6 ausreichend bei Gewinner?
        blt.s           RESOK                 ; Ja -> ResOk
        addq.b          #1,(a6)               ; INC WinnerResult
RESOK:
        move.b          d0,(a2)+              ; Ablegen !
        addq.w          #1,a6                 ; INC a6
LOOSERLOOP:
        dbra            d2,LOOSERSETS         ; -> Loop
        rts                                   ; Back !
SETWIN1:
        move.b          #"6",d0               ; "6" -> d0
        cmpi.b          #"5",(a6)+            ; Ist LooserSet < 5
        blt.s           LOWERFIVE             ; Ja -> LowerFive
        addq.b          #1,d0                 ; INC WinResult !
LOWERFIVE:
        move.b          d0,(a2)+              ; Ablegen !
        bra.s           LOOSERLOOP            ; -> LooserLoop

* Routine waehlt aus Weltrangliste Gegner aus
CHOOSEOPPO:
        bsr             GENERATEOFFS          ; Generiere Offsets !
        lea             TOURNOPP32,a1         ; Base of Table -> a1
        movea.l         a1,a3                 ; Base of Table -> a3
        moveq           #1,d7                 ; Init LoopCounter !
CHOOSEOPPL:
        bsr             RANDOM                ; Hole ZufallsZahl
        bpl.s           RNDNOTNEG             ; Nein -> RNDNotNeg
        neg.w           d0
RNDNOTNEG:
        moveq           #8,d1                 ; 9 -> d1
        asr.w           d1,d0                 ; Random >> 9
        cmp.w           #63,d0                ; > 63 ?
        ble.s           NOG63                 ; Nein -> Nog63
        asr.w           #1,d0                 ; RND / 2
NOG63:
        move.w          d7,d6                 ; InLoopCounter = OutLoopCounter
        subq.w          #1,d6                 ; DEC InLoopCounter
        movea.l         a3,a2                 ; Base of Table -> a2
CHOOSENOEQUAL:
        cmp.w           (a2)+,d0              ; Vergleiche errechnete mit Neuem
        beq             CHOOSEOPPL            ; = -> Loop
        dbra            d6,CHOOSENOEQUAL      ; -> Loop

        move.w          d0,(a1)+              ; Lege Random ab
        addq.w          #1,d7                 ; INC Counter
        cmp.w           #MAXRANKS/2,d7        ; Ende ?
        ble.s           CHOOSEOPPL            ; Nein -> Loop

        lea             RANKOFFS,a0           ; RankOffsetsBase -> a0
        moveq           #MAXRANKS/2-1,d7      ; Init LoopCounter !
OFFSINLOOP:
        move.w          (a3),d0               ; Hole abgelegte RND-Zahl
        add.w           d0,d0                 ; * 2 fuer Wortzugriff
        move.w          0(a0,d0.w),(a3)+      ; Lege Offset in Tabelle
        dbra            d7,OFFSINLOOP         ; -> Loop
        rts                                   ; Back !

* Routine baut Turniertabelle auf
MAKETOURNTABLE:
        bsr             SORTPLANES            ; Normale PlaneKonfig !
        bsr             MAKETWOPLANES         ; Only two Planes
        bsr             SETSCROLL             ; Bereite alles fuer Scrolling
        bsr             SETSGOSPAL            ; Setze SGOS-Farben
        bsr             GENPAPER              ; BackGround zeichnen !
        bsr             GENBOXES              ; Zeichne NamensBoxen und Rays
        subq.l          #2,PLANES+SCRPORT     ; PreDec PlanePtr 1
        subq.l          #2,PLANES+4+SCRPORT   ; PreDec PlanePtr 2
        bsr             RETHINKDIS            ; Setze neue Parameter in CList
        bsr             DIMMERON              ; Ziehe Farben hoch !
        bsr             WAITTABLEMOVE         ; Lasse Scrolling zu !
        bsr             DIMMEROFF             ; All Black !
        bsr             SETNOSCROLL           ; Stelle alten Zustand wieder her!
        bra             TOURNAMENT            ; Tournament

WAITTABLEMOVE:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             JOYPORT(pc),a4        ; JoyStickPortBase -> a4
        tst.b           JP_BUTTON(a4)         ; Ist Button gedrueckt !
        bmi             WAITP                 ; Ja -> Ende
        move.l          JP_LEFT(a4),d0        ; Hole Flags !
        beq.s           WAITTABLEMOVE         ; Keine Bewegung -> Loop
        moveq           #0,d0                 ; Clear d0
        moveq           #0,d1                 ; Clear d1
        tst.b           JP_RIGHT(a4)          ; Test ob rechts
        beq.s           RSTICKN               ; Nein -> RStickN
        moveq           #2,d0                 ; INC X
RSTICKN:
        tst.b           JP_LEFT(a4)           ; Test ob links
        beq.s           LSTICKN               ; Nein -> LStickN
        moveq           #-2,d0                ; DEC X
LSTICKN:
        tst.b           JP_UP(a4)             ; Test ob oben
        beq.s           USTICKN               ; Nein -> UStickN
        moveq           #-2,d1                ; DEC Y
USTICKN:
        tst.b           JP_DOWN(a4)           ; Test ob unten
        beq.s           DSTICKN               ; Nein -> DStickN
        moveq           #2,d1                 ; INC Y
DSTICKN:
        bsr             MAKESCROLL            ; Erledige Scrolling !
        bra             WAITTABLEMOVE         ; -> Loop

* Routine erledigt Scrolling
MAKESCROLL:
        movem.w         BSCROLL(a6),d2-d4     ; Hole BScroll Scroll-X u. -Y
        add.w           d0,d3                 ; INC SPOSX
        bpl.s           XISAVAIL              ; Is pos -> XIsAvail
        moveq           #0,d3                 ; SPOSX = 0
        bra.s           ISLIMITS              ; -> IsLimits
XISAVAIL:
        cmp.w           #480,d3               ; > MaxX ?
        ble.s           XISAVAIL1             ; Nein -> XIsAvail1
        move.w          #480,d3               ; SPOSX = 479
        bra.s           ISLIMITS              ; -> IsLimits
XISAVAIL1:
        neg.w           d0                    ; Neg d0
        add.w           d0,d2                 ; INC BScroll
        bmi.s           ISOFFLIMITS           ; Neg -> Is OffLimits !
        cmp.w           #$0010,d2             ; Is Off Limits?
        blt.s           ISLIMITS              ; Nein -> Is Limits !
        subq.l          #2,PLANES(a6)         ; DEC 1. PlanePtr
        subq.l          #2,PLANES+4(a6)       ; DEC 2. PlanePtr
        moveq           #0,d2                 ; BitScroll = 0
        bra.s           ISLIMITS              ; -> IsLimits
ISOFFLIMITS:
        addq.l          #2,PLANES(a6)         ; INC 1. PlanePtr
        addq.l          #2,PLANES+4(a6)       ; INC 2. PlanePtr
        moveq           #$0f,d2               ; BitScroll = $f
ISLIMITS:
        add.w           d1,d4                 ; INC SPOSY
        bpl.s           YISAVAIL              ; Is pos -> YIsAvail
        moveq           #0,d4                 ; SPOSY = 0
        bra.s           YENDE                 ; -> YEnde
YISAVAIL:
        cmp.w           #200,d4               ; > MaxY ?
        ble.s           YISAVAIL1             ; Nein -> YIsAvail1
        move.w          #200,d4               ; SPOSY = 199
        bra.s           YENDE                 ; -> YEnde
YISAVAIL1:
        muls            ONELINEB(a6),d1       ; * OneLineB
        add.l           d1,PLANES(a6)         ; DEC 1. PlanePtr
        add.l           d1,PLANES+4(a6)       ; DEC 2. PlanePtr
YENDE:
        movem.w         d2-d4,BSCROLL(a6)     ; Lege Werte ab !
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLANEINIT             ; Planes in CList
        bsr             PLAYFINIT             ; PlayFieldDaten setzen
        rts

* Routine zeichnet die Boxen einer Seite der TurnierTabelle
GENBOXES:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             TABLE32(pc),a0        ; Table 32 -> d6
        lea             RESULTS32,a4          ; ResultTableBase -> a4
        lea             TOURNOPP32,a5         ; TournOpp -> a5
        moveq           #1,d6                 ; Init 2. LoopCounter !
GENBOXOUTLOOP:
        movea.l         TT_PREV(a0),a1        ; Previous -> a1
        movea.l         TT_NEXT(a0),a2        ; Next -> a2
        move.w          TT_X(a0),d0           ; X-Koordinate -> d0
        move.w          TT_Y(a0),d1           ; Y-Offset -> d1
        move.w          TT_DIS(a0),d4         ; Distance -> d4
        move.w          d0,d2                 ; X1 -> X2
        add.w           #TBOXW,d2             ; ADD Breite
        moveq           #1,d7                 ; Init LoopCounter !
GENBOXLOOP:
        move.w          d1,d3                 ; Y1 -> Y2
        add.w           #TBOXH-1,d3           ; ADD Hoehe
        bsr             CONNECTION            ; Verbinde zwei Eintraege
        cmp.w           TD_ROUND+TOURNPORT,d6 ; Sollen Namen ausgegeben werden
        bgt.s           NONAME
        bsr             OUTNAMES
NONAME:
        movem.w         d0-d3,X_1(a6)         ; Trage Koordinaten ein !
        bsr             PLASTBOX              ; -> PlastBox
        add.w           d4,d1                 ; ADD Y1,DIS
        addq.w          #1,d7                 ; INC 1. Loopcounter
        cmp.w           TT_COUNT(a0),d7       ; Ist Ende ?
        ble.s           GENBOXLOOP            ; Nein -> Loop
        move.l          a2,d7                 ; Next Pointer -> d7
        beq.s           GENBOXESENDE          ; = 0 -> Ende
        movea.l         a2,a0                 ; Next Pointer -> a0
        addq.w          #1,d6                 ; INC Counter
        cmp.w           #5,d6                 ; Last Loop ?
        ble.s           GENBOXOUTLOOP         ; -> 2. Loop
GENBOXESENDE:
        rts                                   ; Back !

OUTNAMES:
        move.w          #TEXTCOL,COLOR(a6)    ; Setze Farbe !
        move.w          (a5)+,d5              ; Offset -> d4
        lea             TABLEMALE,a3          ; TableMaleBase -> a3
        lea             PL_NAME(a3,d5.w),a3   ; a3 now Pointer to Name
        bsr             STRLENGTH             ; Hole Laenge !
        move.w          d5,-(a7)              ; Save Width on Stack !
        moveq           #TBOXW,d5             ; Breite einer Box -> d5
        sub.w           (a7)+,d5              ; SUB StrBreite ( from Stack )
        lsr.w           #1,d5                 ; / 2 fuer Zentrierung
        movem.w         d0-d1,X_1(a6)         ; Trage Koordinaten ein !
        add.w           d5,X_1(a6)            ; ADD CenterX
        addq.w          #1,Y_1(a6)            ; INC Y1
        bsr             STRINGOUT             ; Gebe Namen aus !
        rts                                   ; Back !

* Routine verbindet die Eintraege mit Linien
CONNECTION:
        move.w          #TEXTCOL,COLOR(a6)
        tst.l           TT_NEXT(a0)           ; TT_NEXT ?
        beq             RETURN                ; Nein -> Ende
        move.w          d7,d5                 ; Number -> d5
        subq.w          #1,d5                 ; DEC Number
        asr.w           #1,d5                 ; / 2
        bcs.s           CONNECTDOWN           ; ODD -> ConnectDown
        mulu            TT_DIS(a2),d5         ; * DIS
        add.w           TT_Y(a2),d5           ; ADD Y-Offset
        move.w          d1,Y_1(a6)            ; SET Y1
        addq.w          #2,Y_1(a6)            ; INC Y1
        move.w          d5,Y_2(a6)            ; SET Y2
        move.w          TT_X(a2),X_1(a6)      ; SET X1
        addq.w          #4,X_1(a6)            ; INC X1
        bsr             VLINE                 ; -> VLine
        move.w          X_1(a6),X_2(a6)       ; X1 -> X2
        move.w          d2,X_1(a6)            ; SET X1
        addq.w          #1,X_1(a6)            ; INC X1
        bsr             OUTRESULT1            ; Gebe Ergebnis aus !
        bsr             HORLINE2              ; Horline2
        rts                                   ; Back !
CONNECTDOWN:
        mulu            TT_DIS(a2),d5         ; * DIS
        add.w           TT_Y(a2),d5           ; ADD Y-Offset
        add.w           #TBOXH,d5             ; INC d5
        move.w          d3,Y_2(a6)            ; SET Y2
        subi.w          #2,Y_2(a6)            ; DEC Y2
        move.w          d5,Y_1(a6)            ; SET Y1

        move.w          TT_X(a2),X_1(a6)      ; SET X1
        addq.w          #4,X_1(a6)            ; INC X1
        bsr             VLINE                 ; -> VLine
        move.w          X_1(a6),X_2(a6)       ; X1 -> X2
        move.w          Y_2(a6),Y_1(a6)       ; Y2 -> Y1
        move.w          d2,X_1(a6)            ; SET X1
        addq.w          #1,X_1(a6)            ; INC X1
        bsr             OUTRESULT2            ; Gebe Ergebnis aus !
        bsr             HORLINE2              ; Horline2
        rts                                   ; Back !

* Routine gibt Ergebnis aus ( oberer Name )
RESULTSET:      REG d0-d3
OUTRESULT1:
        cmp.w           TD_ROUND+TOURNPORT,d6 ; Sollen Erg. ausgegeben werden
        bge             RETURN                ; Nein -> Ende
        movem.l         RESULTSET,-(a7)       ; Save Regs on Stack !
        move.b          PR_SETS(a4),d5        ; Anzahl der Saetze -> d5
        and.w           #$00ff,d5             ; Unnoetiges weg !
        lea             PR_RESULT(a4),a3      ; Zeiger auf ResultatStr -> a3
        bsr.s           OUTRESULT             ; -> OutResult !
        movem.l         (a7)+,RESULTSET       ; Get Regs from Stack !
        rts                                   ; Back !

OUTRESULT:
        bsr.s           COPYRESULT            ; Kopiere Resultat in Buffer
        move.w          X_1(a6),d2            ; X1 -> d2
        add.w           d5,d5                 ; Laenge des Ergebnisses * 2
        subq.w          #1,d5                 ; Correct Laenge
        muls            #-6,d5                ; * 6 = ( CharacterWidth )
        add.w           #76,d5                ; ADD DeltaBoxX
        asr.w           #1,d5                 ; / 2 fuer Mitte
        add.w           d5,X_1(a6)            ; INC X1 ( fuer Zentrierung )
        lea             OUBUFFER(pc),a3       ; ZwischenBuffer -> a3
        bsr             STRINGOUT             ; Gebe Namen aus !
        move.w          d2,X_1(a6)            ; d2 -> X1
        rts                                   ; Back !

* Routine kopiert Resultat in Buffer
COPYRESULT:
        movem.l         d5/a0/a3,-(a7)        ; Save Regs on Stack !
        lea             OUBUFFER(pc),a0       ; ZwischenBuffer -> a0
        subq.w          #1,d5                 ; DEC LoopCounter
COPYRESLOOP:
        move.b          (a3)+,(a0)+           ; Kopiere Zeichen !
        tst.w           d5                    ; Was ist mit LoopCounter
        beq.s           NOSPACEIN             ; = 0 -> Kein Leerzeichen
        move.b          #" ",(a0)+            ; Space dazwischen !
NOSPACEIN:
        dbra            d5,COPYRESLOOP        ; -> Loop
        move.b          #0,(a0)               ; EndeKennung setzen !
        movem.l         (a7)+,d5/a0/a3        ; Get Regs from Stack !
        rts                                   ; Back !

* Routine gibt Ergebnis aus ( unterer Name )
OUTRESULT2:
        cmp.w           TD_ROUND+TOURNPORT,d6 ; Sollen Erg. ausgegeben werden
        bge             RETURN                ; Nein -> Ende
        movem.l         RESULTSET,-(a7)       ; Save Regs on Stack !
        move.b          PR_SETS(a4),d5        ; Anzahl der Saetze -> d5
        and.w           #$00ff,d5             ; Unnoetiges weg !
        lea             PR_RESULT(a4,d5.w),a3 ; Zeiger auf ResultatStr -> a3
        subq.w          #8,Y_1(a6)            ; DEC Y1
        bsr.s           OUTRESULT             ; -> OutResult !
        addq.w          #8,Y_1(a6)            ; Correct Y1
        adda.w          #PR_SIZEOF,a4         ; Zeiger auf naechstes Resultat
        movem.l         (a7)+,RESULTSET       ; Get Regs from Stack !
        rts                                   ; Back !

* Routine zeichnet BackGround fuer Turniertabelle
GENPAPER:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #PAPERCOL,COLOR(a6)   ; Setze Farbe
        moveq           #0,d0                 ; X1 = 0
        moveq           #0,d1                 ; Y1 = 0
        move.w          #799,d2               ; X2 = MaxX
        move.w          #399,d3               ; Y2 = MaxY
        movem.w         d0-d3,X_1(a6)         ; Setze fuer PlastBox
        bsr             FILLBOX               ; -> FillBox
        bra             PLASTBOX              ; -> PlastBox

* Routine initialisiert ReplayModus
INITREPLAY:
        bsr             INITREPDAT            ; Initialisiere Daten
        bsr             MAKEFIVEPLANES        ; Installiere 5 Bitplanes
        bsr             SORTPLANES            ; Restauriere PlanePtr
        bsr             CLEARSCREEN           ; Loesche Display !
        bsr             WAITBEAM              ; Warte auf Strahl !
        clr.w           RECJOY                ; RecJoy = 0
        move.l          #COPSET1,COPSLOT      ; Belege VBLSlot !

* Routine regelt komplettes 3D-Handling des Replay-Modes
MY3DCOURT:
                IF RECEIVE=0
        bsr             MAKEMOTION            ; Kamera an !
                ENDC
        bsr             DREID                 ; Errechne 3D-System
        bsr             OUTPUTCOURT           ; Zeichnne Court !
        bsr             DOUBLEBUFFER          ; DoubleBuffering !
        tst.b           REPLAYEXIT            ; Test ExitFlag !
        beq.s           MY3DCOURT             ; Nein -> Loop

        move.l          #0,COPSLOT            ; No CopSlot !
        bsr             DIMMEROFF             ; All Black !
        bsr             SORTPLANES            ; Restauriere PlanePtr
        bsr             PLANEINIT             ; Planes in Clist
        bsr             SETDREID              ; Setze 3D-Parameter auf Game
        bsr             MAKEFOURPLANES        ; Only four Planes !
        bsr             MAKEPLAYCOURT         ; Errichte Platz !
        bsr             DIMMERON              ; Dim on !
        bsr             WAITBEAM              ; Warte Strahl !
        move.l          #0,COPSLOT            ; No CopSlot !
        sf              REPLAYEXIT            ; ReplayExit = 0
        rts                                   ; Back !

REPLAYEXIT:     DC.B 0                  ; ExitFlag fuer 3D-Replay !
REPLAYPOS:      DC.B 0                  ; ReplayPosibble-Flag
REPLAYSLOT:     DC.L 0                  ; Zwischenspeicher fuer CopSlot

* Routine initialisiert BallMaschinen-Menue
MACHINE:
        lea             MACHINETXT(pc),a0     ; Adresse des Textes -> a0
        bsr             GENMENU               ; Generiere Menu
        bsr             DIMMEROFF             ; All Black !
        bra             POINTCHOOSEN          ; Verzweige aus Menue

* Program fuer Maschine nach Menu auswaehlen
PROGRAM:
        lea             MASCHINEPORT(pc),a0   ; MaschinePortBase -> a0
        lea             MENUPORT(pc),a1       ; MenuPortBase -> a1
        lea             PROGRAMTABLE(pc),a2   ; ProgramTableBase -> a2
        move.w          MB_MENU(a1),d0        ; Nummer des gewaehlten Menues
        subq.w          #1,d0                 ; DEC Number
        lsl.w           #2,d0                 ; * 4 fuer Tabellenzugriff
        move.l          0(a2,d0.w),BM_TABLE(a0) ; ADR of Program

* Spieler trainiert mit Ballmaschine
MAKEMACHINE:
        bsr             SETDREID              ; Setze 3D-Parameter auf Game
        bsr             INITBALLDAT           ; Initialisiere BallPort !
        bsr             FIRSTMANPORT          ; Racket initialisieren !
        bsr             FIRSTMASCHINE         ; Parameter in BallPort eintragen
        bsr             MAKEFOURPLANES        ; Only four Planes !
        bsr             WAITBEAM              ; Warte Strahl !
        bsr             INITSPRITES           ; Initialisiere Sprites !
        bsr             SETSPRCOLORS          ; Setze SpriteFarben !
        bsr             MAKETRAINCOURT        ; Errichte Platz
        bsr             COPYMASCHINE          ; Kopiere Ballmaschine ein !
        bsr             DIMMERON              ; Dim on !
        move.l          #COPSET3,COPSLOT      ; Belege VBLSlot !
        clr.w           GLDELAY
        clr.w           RECJOY
        bsr             MAINPART1             ; -> MainPart1
        move.l          #COPSET2,COPSLOT      ; Belege VBLSlot !
        bsr             DIMMEROFF             ; Ausblenden
        bsr             WAITBEAM              ; Warte auf Strahl !
        move.l          BACKSTACK(pc),BACKSTACKPT ; Clear BackStack
        clr.w           OBJNUM                ; ObjNum = 0
        bra             PRACTICE              ; -> PracticeMenu

MAKESCORE:
        move.l          SCPPORT(pc),d0        ; GameStand P1 -> d0 ( Oberes W. )
        move.w          SCEPORT(pc),d0        ; GameStand P2 -> d0 ( Unt. Word )
        tst.l           d0                    ; Beide 0 ?
        bne.s           NOFULLSCORE           ; Nein -> NoFullScore !
        move.l          COPSLOT(pc),-(a7)     ; Save CopSlot on Stack !
        move.l          #COPSET2,COPSLOT      ; Belege Slot !
        bsr             DESIGNSCORE           ; Gebe TestScore aus !
        move.l          (a7)+,COPSLOT         ; Alten Slot wieder eintragen !
        rts
NOFULLSCORE:
        move.l          COPSLOT(pc),-(a7)     ; Save CopSlot on Stack !
        move.l          #COPSET2,COPSLOT      ; Belege Slot !
        bsr             GAMESCORE             ; Gebe GameScore aus !
        move.l          (a7)+,COPSLOT         ; Alten Slot wieder eintragen !
        rts

* Routine initialisiert Service-Modus
SERVICE:
        bsr             SETDREID              ; Setze 3D-Parameter auf Game
        bsr             INITBALLDAT           ; Initialisiere BallPort !
        bsr             MAKEFOURPLANES        ; Only four Planes !
        bsr             MAKETRAINCOURT        ; Errichte Platz
        bsr             DIMMERON              ; Dim on !
        move.l          #COPSETSERVE,COPSLOT  ; Belege VBLSlot !
SERVFURTH:
        bclr            #1,PLAYPORT           ; Player 1 serves !
        bsr             MAKEPSERVICE          ; TrainingAufschlagLogik !
        bsr             WAITSERVEND           ; Warte auf Service-Ende
        tst.b           JOYPORT+JP_MLBUTTON   ; Linke Maustaste = Exit
        beq.s           SERVFURTH             ; Nein -> Servfurth !
        move.l          #COPSET2,COPSLOT      ; Slot belegen !
        bsr             DIMMEROFF             ; Ausblenden
        bsr             WAITBEAM              ; Warte auf Strahl !
        move.l          BACKSTACK(pc),BACKSTACKPT ; Clear BackStack
        clr.w           OBJNUM                ; ObjNum = 0
        bra             PRACTICE              ; -> PracticeMenu

WAITSERVEND:
        lea             WAITAPORT(pc),a0      ; WaitaPort -> a0
        bsr             INITANIM              ; -> InitAnim
WAITSEND:
        lea             WAITAPORT(pc),a0      ; WaitAPort -> a0
        bsr             ANIM                  ; -> Anim
        movem.w         PL1PORT+P1_DX(pc),d0-d2 ; X-Y-Z-Koordinate -> d0-d2
        bsr             INOBJLIST             ; -> InObjList
        bsr             DRAWOBJLIST           ; -> DrawObjList
        cmpi.b          #BALLFLY,BS_TYPE+BALLPORT ; Aufschlag-Ende ?
        bne.s           WAITSEND              ; Nein -> Loop
        tst.b           BS_NEW+BALLPORT       ; New Paras ?
        bne.s           WAITSEND              ; Nein -> Loop
        tst.w           BS_OUT+BALLPORT       ; Service failed ?
        bne.s           SERVEFAILED           ; Ja -> ServeFailed
        move.w          #2,SERVFAILED         ; Init ServFailed-CNT
        bchg            #0,PLAYPORT+PP_WHOWHERE ; Other Side ?
        rts                                   ; Back !
SERVEFAILED:
        subq.w          #1,SERVFAILED         ; DEC ServFailed !
        bne             RETURN                ; Second Serv m”glich !
        bchg            #0,PLAYPORT+PP_WHOWHERE ; Other Side ?
        move.w          #2,SERVFAILED         ; Init ServFailed-CNT
        rts                                   ; Back !

* Routine fuer Aufschlaglogik waehrend Spiel
MAKESERVICE:
;        bset            #1,PLAYPORT
        sf              BS_WHO+BALLPORT
        bsr             WHOWHEREWHY           ; Wer ? Wo ? Wieso ?
        bsr             FIRSTSERVICE          ; Aufschlag !
        bsr             PLAYERDREID           ; Spieler 1 Koordinaten !
        bsr             PLAYER1DREID          ; Spieler 2 Koordinaten !
        clr.w           RECJOY                ; Loesche RecJoy
        sf              REPLAYPOS             ; Replay moeglich !
SERVICELOOP1:
        bsr             MAKETIPP              ; Tippen
        bsr             CENTRALPLAY           ; Zentrale Spielroutine !
;        addq.b          #1,TIPPWAIT           ; INC TippCounter !
;        cmpi.b          #120,TIPPWAIT         ; Score anzeigen ?
;        ble.s           NOSCOREDIS            ; Nein -> NoScoreDis
;        tst.b           TIPPWAIT+1            ; Score schon mal da ?
;        bne.s           NOSCOREDIS            ; Ja -> NoScoreDis
;        clr.b           TIPPWAIT              ; TippWait = 0
;        st              TIPPWAIT+1            ; Score schon mal angezeigt !
;        bsr             MAKESCORE             ; Zeige Score an !
NOSCOREDIS:
        movea.l         PP_JPORT+PLAYPORT(pc),a0 ; JoyPortBase -> a0
        tst.b           JP_BUTTON(a0)         ; JoyButton ?
        beq.s           SERVICELOOP1          ; Nein -> ServiceLoop
        clr.w           TIPPWAIT              ; Tippwait = 0
        sf              BS_NEW+BALLPORT       ; New Para-Flag setzen !
SERVELOOP1:
        bsr             MAKESERVE             ; -> MakeServe
        bsr             CENTRALPLAY           ; Zentrale Spielroutine !
        movea.l         PP_MEGA+PLAYPORT,a0   ; MegaPortBase -> a0
        movea.l         MP_SERVE(a0),a0       ; ServePortBase -> a0
        move.w          AN_STEPS(a0),d0       ; Steps -> d0
        cmp.w           AN_CNT(a0),d0         ; CNT
        bgt.s           SERVELOOP1            ; -> Loop
        rts                                   ; Back !

TIPPWAIT:       DC.W 0
SERVFAILED:     DC.W 2

* Routine fuer Aufschlaglogik waehrend Aufschlaglogik
MAKEPSERVICE:
        bsr             WHOWHEREWHY           ; Wer ? Wo ? Wieso ?
        bsr             FIRSTSERVICE          ; Aufschlag !
        bsr             PLAYERDREID           ; Spieler 1 Koordinaten !
SERVICELOOP:
        bsr             MAKETIPP              ; Tippen
        bsr             DRAWOBJLIST           ; -> DrawObjList
        movea.l         PP_JPORT+PLAYPORT(pc),a0 ; JoyPortBase -> a0
        tst.b           JP_BUTTON(a0)         ; JoyButton ?
        beq.s           SERVICELOOP           ; Nein -> ServiceLoop
        sf              BS_NEW+BALLPORT       ; New Para-Flag setzen !
SERVELOOP:
        bsr             MAKESERVE             ; -> MakeServe
        bsr             DRAWOBJLIST           ; -> DrawObjList
        movea.l         PP_MEGA+PLAYPORT,a0   ; MegaPortBase -> a0
        movea.l         MP_SERVE(a0),a0       ; ServePortBase -> a0
        move.w          AN_STEPS(a0),d0       ; Steps -> d0
        cmp.w           AN_CNT(a0),d0         ; CNT
        bgt.s           SERVELOOP             ; -> Loop
        rts                                   ; Back !
        tst.w           BS_OUT+BALLPORT       ; Aufschlag failed ?
        beq             RETURN                ; Nein -> Ende
        subq.w          #1,SERVFAILED         ; DEC ServeFailed !
        beq             SCORELOGIK            ; Service-Failed -> ScoreLogik
        bra             MAKESERVICE           ; -> MakeService

* Routine holt sich SpielParameter aus PlayPort und richtet danach den Spieler
* beim Aufschlag aus
WHOWHEREWHY:
        lea             PLAYPORT(pc),a3       ; PlayPortBase -> a3
        move.b          PP_WHOWHERE(a3),d0    ; Hole ZweiBitValue !
        lea             BALLPORT+BS_BX1,a1    ; BoundsBase -> a1
        lea             PL1PORT(pc),a2        ; PL1PortBase -> a2
        btst            #1,d0                 ; 2. Spieler am Aufschlag ?
        beq.s           ITSFIRSTPL            ; Nein -> ItsFirstPl
        lea             PL2PORT(pc),a2        ; PL2PortBase -> a2
ITSFIRSTPL:
        move.l          a2,PP_PORT(a3)        ; PLxPortBase -> PP_Port
        ext.w           d0                    ; ZweiBitWert erweitern !
        mulu            #32,d0                ; * 32 fuer Tabellenzugriff !
        lea             SERVEDATS(pc),a0      ; ServeDatsBase -> a0
        adda.w          d0,a0                 ; ADD Offset !
        movem.w         (a0)+,d0-d7           ; Hole wichtige Werte !
        movem.w         d4-d7,(a1)            ; Bounds eintragen !
        movem.w         d0-d1,P1_X(a2)        ; ServicePoint eintragen !
        move.w          #NH,P1_Z(a2)          ; Z eintragen !
        movem.w         d2-d3,BSERVEX         ; BallKoordinaten eintragen !
        movem.l         (a0)+,d0-d1           ; TabellenPointer holen !
        movem.l         d0-d1,PP_MEGA(a3)     ; und ablegen
        movem.w         (a0)+,d0-d3           ; Delays und Serve-Col holen !
        movem.w         d0-d3,PP_DELS(a3)     ; und ablegen
        rts                                   ; Back !

* Routine setzt 3D-Parameter wieder auf Urwerte zurueck
SETDREID:
        move.w          #W1,W1REG             ; Setze Winkel 1
        move.w          #W2,W2REG             ; Setze Winkel 2
        move.w          #W3,W3REG             ; Setze Winkel 3
        move.w          #RHO,DISREG           ; Setze ZentralPkt.
        move.w          #DIST,DIS1REG         ; Setze Distance
        bra             GETROTATION           ; Errechne RotationsMatrix !

* Routine setzt Spritefarben
SETSPRCOLORS:
        lea             SPRCTABLE(pc),a0      ; SpriteColorTable -> a0
        lea             ACTCOLTABLE+$0020,a1  ; PseudoColorRegs -> a1
        moveq           #15,d7                ; Init LoopCounter !
        bsr             CPUCOPY               ; Copy It !
        rts                                   ; Back

* Routine kopiert den Spieler beim Auftippen ein
MAKETIPP:
        move.b          #BALLTIP,BS_TYPE+BALLPORT ; Ball ist am Tippen !
        movea.l         PP_MEGA+PLAYPORT,a0   ; MegaPortBase -> a0
        movea.l         MP_TIPP(a0),a0        ; TippportBase -> a0
        bsr             ANIMATION             ; Globale AnimationsRoutine !
        movea.l         PP_PORT+PLAYPORT,a0   ; Get PLxPort
        movem.w         P1_DX(a0),d0-d2       ; X-Y-Z-Koordinate -> d0-d2
        bsr             INOBJLIST             ; -> InObjList
        rts

* Routine kopiert den Spieler beim Aufschlag ein
MAKESERVE:
        cmpi.b          #BALLFLY,BS_TYPE+BALLPORT ; Ball in Curve ?
        beq.s           BALLINCURVE           ; Ja -> BallinCurve
        move.b          #BALLTHR,BS_TYPE+BALLPORT ; Player is on Serve-Throw !

BALLINCURVE:
        bsr             GENERATEDEL           ; Variables Delay !
        movea.l         PP_MEGA+PLAYPORT,a0   ; MegaPortBase -> a0
        movea.l         MP_SERVE(a0),a0       ; ServePortBase -> a0
        bsr             ANIMATION             ; Globale AnimationsRoutine !

        movea.l         PP_PORT+PLAYPORT,a0   ; Get PLxPort
        movem.w         P1_DX(a0),d0-d2       ; X-Y-Z-Koordinate -> d0-d2
        bsr             INOBJLIST             ; -> InObjList

        lea             PLAYPORT(pc),a5       ; PlayPortBase -> a5
        movea.l         PP_MEGA(a5),a0        ; MegaAnimPort -> a0
        movea.l         MP_SERVE(a0),a0       ; ServePortBase -> a0
        move.w          PP_DELS+6(a5),d0      ; Ball-Schlaeger-Col -> d0
        cmp.w           AN_CNT(a0),d0         ; Ball-Schlaeger-Collision !
        bne             RETURN                ; -> Ende

        tst.w           AN_DELCNT(a0)         ; Delay = 0 ?
        bne             RETURN                ; Nein -> Ende

        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.b          #BALLSER,BS_TYPE(a5)  ; -> Ball-in-Curve
        sf              BS_NEW(a5)            ; Neue Parameter !
        st              BS_SERVE(a5)          ; Service-in-Progress !
        st              BS_WHO(a5)            ; Erstmal setzen !
        cmpi.l          #MEGAA,PP_MEGA+PLAYPORT ; Wer ist Aufschlaeger ?
        beq             RETURN                ; 1 Spieler -> Ende
        sf              BS_WHO(a5)            ; BS_WHO loeschen !
        rts                                   ; Back !

NEWCURVE:
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             SERVETABY(pc),a3      ; ServeTabY -> a3
        move.w          SERVEPOS(pc),d0       ; ServePos -> d0
        move.w          0(a3,d0.w),d4         ; DestY. -> d4
        cmpi.l          #MEGAA,PP_MEGA+PLAYPORT ; Who is on Serve ?
        beq.s           ITISPL11              ; Player 1 -> ItIsPl11
        neg.w           d4                    ; NEG d4
ITISPL11:

        move.w          d4,BS_YM1(a5)         ; DestY = BS_YM1
        move.w          BSERVEY(pc),d5        ; BServeY -> d5
        sub.w           d4,d5                 ; SUB DestY.
        add.w           BSERVEY(pc),d5        ; ADD BserveY
        move.w          BSERVEY(pc),d6        ; MitteY -> d6
        move.w          BS_Z(a5),BS_ZM1(a5)   ; BS_ZM1 eintragen
        move.w          BS_Z(a5),BS_ZM2(a5)   ; BS_ZM2 eintragen
        bsr             NEWPARAS2             ; AufschlagParas errechnen

        move.w          d0,BS_ZM1(a5)         ; ZM1
        move.w          d6,BS_FF(a5)          ; Setze FF
        move.w          d3,BS_NEI(a5)         ; Setze Neigung

        move.w          BSERVEX(pc),BS_DX(a5) ; BS_DX  eintragen
        move.w          BSERVEY(pc),BS_Y(a5)  ; BS_Y   eintragen
        move.w          SERVETABW(pc),d0      ; SERVETABW -> d0
        move.w          d0,BS_WIN(a5)         ; BS_WIN eintragen
        sub.w           #90,d0                ; Sub StartWinkel !
        bpl.s           NONEGTAB              ; >= 0 -> NoNegTab !
        neg.w           d0                    ; ABS(d0)
NONEGTAB:
        lea             SERVESPEED(pc),a0     ; ServeSpeedBase -> a0
        move.b          0(a0,d0.w),d0         ; Get Speed -> d0
        ext.w           d0                    ; Wort erweitern !
        move.w          d0,BS_SP(a5)          ; BS_SP eintragen
        bsr             NEWPARAS              ; Neue Parameter !
        move.w          #34,BS_ZM2(a5)        ; ZM1
        move.b          #BALLFLY,BS_TYPE(a5)  ; Player has served !
        move.w          #SERVEFX,FXNUM        ; FX Serve -> FXNum
        rts                                   ; Back !

* Routine variert das Delay beim Aufschlag !
GENERATEDEL:
        lea             PLAYPORT(pc),a5       ; PlayPortBase -> a5
        movea.l         PP_MEGA(a5),a0        ; MegaPortBase -> a0
        movea.l         MP_SERVE(a0),a0       ; ServePortBase -> a0
        cmpi.w          #6,AN_CNT(a0)         ; Welche CounterStellung ?
        blt.s           SLOWSERVE             ; < -> SlowServe
        bgt.s           FASTSERVE             ; > -> FastServe
        movea.l         PP_JPORT+PLAYPORT(pc),a1 ; JoyPortBase -> a1
        tst.b           JP_BUTTON(a1)         ; Button gedrueckt ?
        bne.s           SERVE                 ; Ja -> Fuehre Aufschlag aus !
        move.w          PP_DELS(a5),AN_DEL(a0) ; Delay setzen !
        rts                                   ; Back
SLOWSERVE:
        move.w          PP_DELS+2(a5),AN_DEL(a0) ; Delay setzen !
        rts                                   ; Back !
FASTSERVE:
        move.w          PP_DELS+4(a5),AN_DEL(a0) ; Delay setzen !
        rts                                   ; Back !
SERVE:
        move.w          #0,AN_DEL(a0)         ; No Delay !
        rts                                   ; Back !

* Routine erledigt Steuerung des Aufschlags
SERVELOGIK:
        movea.l         PP_JPORT+PLAYPORT(pc),a0 ; JoyPortBase -> a0
        move.w          JP_LEFT(a0),d1        ; JoyStick-Stellung -> d1
        beq.s           SERVING               ; Keine Bewegung -> Serving
        and.w           #$ff00,d1             ; Links oder Rechts ?
        bne.s           SERVELEFT             ; Links -> ServeLeft !
        addq.w          #4,SERVETABX          ; Markierung -> rechts
        addq.w          #1,WXDEL1             ; INC WinkelDelay
        cmpi.w          #2,WXDEL1             ; Delay erfuellt ?
        bne.s           SERVING               ; Nein -> Serving !
        clr.w           WXDEL1                ; Clear WinkelDelay
        cmpi.l          #MEGAA,PP_MEGA+PLAYPORT ; Sub oder addieren !
        bne.s           SERVEVISE2            ; Addieren -> ServeVise1
SERVEVISE1:
        addq.w          #1,SERVETABW          ; Winkel -> rechts
        bra             SERVING               ; -> Serving
SERVELEFT:
        subq.w          #4,SERVETABX          ; Markierung -> links
        addq.w          #1,WXDEL2             ; INC WinkelDelay
        cmpi.w          #2,WXDEL2             ; Delay erfuellt ?
        bne.s           SERVING               ; Nein -> Serving !
        clr.w           WXDEL2                ; Clear WinkelDelay
        cmpi.l          #MEGAA,PP_MEGA+PLAYPORT ; Sub oder addieren !
        bne.s           SERVEVISE1            ; Addieren -> ServeVise1
SERVEVISE2:
        subq.w          #1,SERVETABW          ; Winkel -> links
SERVING:
        rts

* Routine zeichnet Fadenkreuz beim Aufschlag
DRAWCROSS:
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             SERVETABY(pc),a3      ; ServeTableY -> a3
        move.w          SERVEPOS(pc),d0       ; ServePos -> d0
        move.w          BS_X(a5),-(a7)        ; Save X on Stack
        move.w          BS_Y(a5),-(a7)        ; Save Y on Stack
        move.w          BS_Z(a5),-(a7)        ; Save Z on Stack

        clr.w           BS_Z(a5)              ; BS_Z = 0
        move.w          0(a3,d0.w),BS_Y(a5)   ; Set BS_Y
        cmpi.l          #MEGAA,PP_MEGA+PLAYPORT ; Who is on Serve ?
        beq.s           ITISPL1               ; Player 1 -> ItIsPl1
        neg.w           BS_Y(a5)              ; NEG BS_Y
ITISPL1:
        move.w          SERVETABX(pc),BS_X(a5) ; Set BS_X

        lea             BS_XXX(a5),a0         ; DestArray -> a0
        lea             BS_X(a5),a2           ; SourceArray -> a2
        lea             ROTTABLE(pc),a3       ; RotTable -> a3
        moveq           #0,d7                 ; 1. Koordinate umrechnen

        bsr             OUTLOOP               ; -> OutLoop

        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.w          (a7)+,BS_Z(a5)        ; Get Z from Stack
        move.w          (a7)+,BS_Y(a5)        ; Get Z from Stack
        move.w          (a7)+,BS_X(a5)        ; Get Z from Stack

        movea.l         BALLGPTR(pc),a2       ; BallGPtr -> a2
        adda.w          #FADENKR,a2           ; a2 now Base of Datas !
        move.l          a2,d3                 ; a2 -> d3
        neg.l           d3                    ; NEG DataBase
        movea.l         d3,a2                 ; d3 -> a1
        movem.w         BS_XXX+BALLPORT,d0-d2 ; X-Y-Z-Koordinate -> d0 - d2
        subq.w          #5,d0                 ; Correct X
        subq.w          #5,d1                 ; Correct Y
        bra             INOBJLIST             ; -> InObjList

* Routine verwaltet Score ( Game Set Match )
SCORELOGIK:
        move.l          COPSLOT(pc),REPLAYSLOT ; Save COPSLOT !
        move.l          #0,COPSLOT            ; No CopSlot !
        bsr             GOODPLAY              ; -> GoodPlay ?
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        clr.l           BS_OUT(a5)            ; Clear FailedFlags !
        clr.b           SERVEFAULT            ; Clear DoppelFehler-Counter !
        lea             SCPPORT(pc),a2        ; ScorePort ( Spieler ) -> a2
        lea             SCEPORT(pc),a3        ; ScorePort ( Gegner ) -> a3
        tst.b           BS_WHO(a5)            ; Wer hat Fehler gemacht ?
        beq.s           ENEMYFAULT            ; = 0 -> EnemyFault
        exg             a2,a3                 ; Swap PortPointers ( geil )
ENEMYFAULT:
        move.w          #2,SERVFAILED         ; Init ServFailed-Counter !
        bchg            #0,PLAYPORT           ; Toogle Aufschlag-Start !
        move.w          SL_GAME(a2),d0        ; Get Game-stand -> d0 ( Winner )
        addq.w          #1,d0                 ; INC Game-Stand !
        tst.b           TIEBREAK              ; TieBreak aktiv ?
        beq.s           NORMCOUNT             ; Nein -> NormCount !
        cmp.w           #6,d0                 ; Game-End ?
        ble             SCORELENDE            ; Nein -> Ende
NORMCOUNT:
        cmp.w           #3,d0                 ; Game-End ?
        ble             SCORELENDE            ; Nein -> Ende
        move.w          SL_GAME(a3),d1        ; Get Game-Stand -> d1 ( Fault )
        move.w          d0,d2                 ; Game-Stand ( Winner ) -> d1
        sub.w           d1,d2                 ; SUB GameStand ( Fault )
        bpl.s           GDIFNNEG              ; + -> GDifNNeg
        neg.w           d2                    ; ABS (GameDelta)
GDIFNNEG:
        cmp.w           #2,d2                 ; GameDelta >= 2
        blt             SCORELENDE            ; Nein -> Ende
        bclr            #0,PLAYPORT           ; Clear Aufschlag-Start !
        bchg            #1,PLAYPORT           ; Toogle Aufschlag-Player !
        moveq           #0,d0                 ; Game-Stand = 0 ( Winner )
        clr.w           SL_GAME(a3)           ; Game-Stand = 0 ( Fault )
        move.w          ACTSET(pc),d7         ; ActSet -> d7
        add.w           d7,d7                 ; ActSet * 2 fuer TabellenZugriff
        lea             SL_MATCH(a2,d7.w),a0  ; Ptr to Set-Stand (Win) -> a0
        addq.w          #1,(a0)               ; INC Set-Stand
        cmpi.w          #5,(a0)               ; Satz gewonnen ?
        ble             SCORELENDE            ; Nein -> Ende
        tst.b           TIEBREAK              ; TieBreak aktiv ?
        bne.s           SETEND                ; Ja -> SetEnd
        lea             SL_MATCH(a3,d7.w),a1  ; Ptr to Set-Stand (Fault) -> a1
        move.w          (a0),d2               ; Set-Stand ( Winner ) -> d2
        cmp.w           #6,d2                 ; Tie-Break ?
        bne.s           NOTIEBREAK            ; Nein -> NoTieBreak
        cmpi.w          #6,(a1)               ; Wirklich Tie-break ?
        bne.s           NOTIEBREAK            ; Nein -> NoTieBreak
        st              TIEBREAK              ; Setze TieBreak-Flag !
        bra.s           SCORELENDE            ; -> Ende
NOTIEBREAK:
        sub.w           (a1),d2               ; SUB Set-Stand ( Fault )
        bpl.s           SDIFNNEG              ; + -> SDifNNeg
        neg.w           d2                    ; ABS (SetDelta)
SDIFNNEG:
        cmp.w           #2,d2                 ; SetDelta >= 2
        blt             SCORELENDE            ; Nein -> Ende
SETEND:
        sf              TIEBREAK              ; Clear TieBreak-Flag !
        addq.w          #1,ACTSET             ; INC ActSet
        addq.w          #1,SL_SET(a2)         ; INC winned Sets
        cmpi.w          #3,SL_SET(a2)         ; Match ?
        blt             SCORELENDE            ; Nein -> ScoreLEnde
        bra             CLEARSCORES           ; Loesche ScoreEintraege !
SCORELENDE:
        move.w          d0,SL_GAME(a2)        ; Game-Stand ablegen !
        bsr             WAITBEAM              ; Wait on beam !
        move.l          REPLAYSLOT(pc),COPSLOT ; Copslot belegen !
        rts                                   ; Back

* Routine loescht s„mtiche ScoreEintraege
CLEARSCORES:
        clr.w           TIEBREAK              ; TieBreak = 0
        clr.w           ACTSET                ; ActSet = 0
        lea             ZEROTABLE(pc),a0      ; ZeroTableBase -> a0
        lea             SCPPORT(pc),a1        ; ScorePort ( Spieler ) -> a1
        move.w          #SL_SIZEOF-1,d7       ; Init LoopCounter !
        bra             CPUCOPY               ; -> CPUCopy

* Zentrale Animationsroutine die den Pointer auf die Daten ermittelt fuer
* Tabellen mit Wort-Offsets
* Input:
*       a0 = Pointer auf AnimPort
* Output:
*       a2 = Pointer auf Daten
ANIMATION:
        movea.l         AN_OFFS(a0),a1        ; Base of Offsets -> a1
        movea.l         AN_BASE(a0),a2        ; Base of Datas -> a2
        move.w          AN_DELCNT(a0),d0      ; DelayCounter -> d0
        addq.w          #1,d0                 ; INC DelayCounter
        cmp.w           AN_DEL(a0),d0         ; Ist Delay voll ?
        ble.s           FURTHERDEL            ; Nein -> FurtherDel !
        clr.w           AN_DELCNT(a0)         ; DelayCounter = 0
        move.w          AN_CNT(a0),d0         ; Counter -> d0
        add.w           d0,d0                 ; * 2 fuer TabellenZugriff
        move.w          0(a1,d0.w),d0         ; Hole Offset !
        lea             0(a2,d0.w),a2         ; ADD Offset to Base of Datas
ANIMLOGIK:
        move.w          AN_CNT(a0),d0         ; Counter -> d0
        add.w           AN_DEC(a0),d0         ; INC or DEC d0
        cmp.w           AN_LOOP(a0),d0        ; = Loop-Point
        beq.s           BUMPANIM1             ; Counter = 0 -> BumpAnim
        cmp.w           AN_STEPS(a0),d0       ; Last Step ?
        ble.s           NOTLASTSTEP           ; Nein -> NotLastStep
        tst.w           AN_MODE(a0)           ; Welcher Modus ? ( Bump or Loop )
        bne.s           BUMPANIM0             ; Bump -> BumpAnim0
        move.w          AN_LOOP(a0),d0        ; Counter = Loop-Point
        bra.s           NOTLASTSTEP           ; -> NotLastStep
BUMPANIM0:
        move.w          AN_STEPS(a0),d0       ; Steps -> d0
        subq.w          #1,d0                 ; DEC Steps = New Count
        neg.w           AN_DEC(a0)            ; Toogle DecInc!
        move.w          d0,AN_CNT(a0)         ; Counter ablegen !
        rts                                   ; Back !
BUMPANIM1:
        tst.w           AN_DEC(a0)            ; DEC = Negativ ?
        bpl.s           NOTLASTSTEP           ; Nein -> NotLastStep
        neg.w           AN_DEC(a0)            ; Toogle DecInc !
NOTLASTSTEP:
        move.w          d0,AN_CNT(a0)         ; Counter ablegen !
        rts                                   ; Back !
FURTHERDEL:
        move.w          d0,AN_DELCNT(a0)      ; Lege DelayCounter ab !
        move.w          AN_CNT(a0),d0         ; Counter -> d0
        add.w           d0,d0                 ; * 2 fuer TabellenZugriff
        move.w          0(a1,d0.w),d0         ; Hole Offset !
        lea             0(a2,d0.w),a2         ; ADD Offset to Base of Datas
        rts

FURTHERDEL1:
        move.w          d0,AN_DELCNT(a0)      ; Lege DelayCounter ab !
        move.w          AN_CNT(a0),d0         ; Counter -> d0
        asl.w           #2,d0                 ; * 4 fuer TabellenZugriff
        move.l          0(a1,d0.w),d0         ; Hole Offset !
        lea             0(a2,d0.l),a2         ; ADD Offset to Base of Datas
        rts

* Zentrale Animationsroutine die den Pointer auf die Daten ermittelt fuer
* Tabellen mit Langwort-Offsets
* Input:
*       a0 = Pointer auf AnimPort
* Output:
*       a2 = Pointer auf Daten
ANIM:
        movea.l         AN_OFFS(a0),a1        ; Base of Offsets -> a1
        movea.l         AN_BASE(a0),a2        ; Base of Datas -> a2
        move.w          AN_DELCNT(a0),d0      ; DelayCounter -> d0
        addq.w          #1,d0                 ; INC DelayCounter
        cmp.w           AN_DEL(a0),d0         ; Ist Delay voll ?
        ble.s           FURTHERDEL1           ; Nein -> FurtherDel !
        clr.w           AN_DELCNT(a0)         ; DelayCounter = 0
        move.w          AN_CNT(a0),d0         ; Counter -> d0
        asl.w           #2,d0                 ; * 4 fuer TabellenZugriff
        move.l          0(a1,d0.w),d0         ; Hole Offset !
        lea             0(a2,d0.l),a2         ; ADD Offset to Base of Datas
        bra             ANIMLOGIK             ; -> AnimLogik

* Routine traegt Objekt in Zeichenlist ein
* Input:
*       d0 = X
*       d1 = Y
*       d2 = Z ( optional )
*       a2 = Pointer to ObjektDaten
INOBJLIST:
        move.l          #$0000ffff,d3         ; d3 = ANDValue
        and.l           d3,d0                 ; AND X
        and.l           d3,d1                 ; AND Y
        and.l           d3,d2                 ; AND Z
        move.w          OBJNUM(pc),d3         ; Aktuelle Nummer -> d3
        lsl.w           #4,d3                 ; * One Input
        lea             OBJLIST(pc),a0        ; ObjListBase -> a0
        adda.w          d3,a0                 ; ADD Input-Offset
        move.l          d0,(a0)+              ; X-Koordinate ablegen
        move.l          d1,(a0)+              ; Y-Koordinate ablegen
        move.l          d2,(a0)+              ; Z-Koordinate ablegen
        move.l          a2,(a0)               ; ADR of Objekt ablegen
        addq.w          #1,OBJNUM             ; INC ObjNum
        rts                                   ; Back !

* Routine zeichnet alle Objekt, die in der ZeichenListe stehen
DRAWOBJLIST:
        tst.w           OBJNUM                ; ObjNum <> 0
        beq             RETURN                ; Nein -> Ende
        bsr             WAITBEAM              ; Warte auf Strahl !
;        move.w          #RED,$00dff180
        bsr             MYRESTBACK            ; Restauriere BackGround !
        bsr             SORTOBJS              ; Sortiere Objekte nach Tiefe !
        bsr             DRAWOBJS              ; Zeichne Objekte !
;        move.w          #BLACK,$00dff180
        clr.w           OBJNUM                ; ObjNum = 0
        rts                                   ; Back !

* Routine sortiert Objekte nach Z-Koordinate ( Verdeckung Spieler 1, Ball, Sp 2)
SORTOBJS:
        lea             OBJLIST(pc),a0        ; ObjListBase -> a0
        move.w          OBJNUM(pc),d7         ; ObjNum -> d7
        subq.w          #2,d7                 ; DEC LoopCounter !
        bmi             RETURN                ; Neg -> Ende
        move.w          d7,d6                 ; LoopCounter -> d6
        sf              MERKER                ; Clear Merker !
SORTOBJLOOP:
        move.l          8(a0),d5              ; Get Z-Koordinate !
        move.l          24(a0),d4             ; Get next Z-Koordinate
        cmp.w           d4,d5                 ; CMP with next Z-Koordinate
        bgt.s           SWAPLIST              ; > -> SwapList !
SORTIN:
        lea             16(a0),a0             ; Next Entry !
        dbra            d7,SORTOBJLOOP        ; -> Loop
        tst.b           MERKER                ; Wurde vertauscht ?
        beq             RETURN                ; Nein -> Ende
        move.w          d6,d7                 ; Init LoopCounter !
        lea             OBJLIST(pc),a0        ; ObjListBase -> a0
        sf              MERKER                ; Loesche Merker !
        bra.s           SORTOBJLOOP           ; -> SortObjLoop
SWAPLIST:
        movem.l         (a0),d0-d5/a1-a2      ; Get the Values
        exg             d0,d4                 ; Vertausche Werte
        exg             d1,d5                 ; Vertausche Werte
        exg             a1,d2                 ; Vertausche Werte
        exg             a2,d3                 ; Vertausche Werte
        movem.l         d0-d5/a1-a2,(a0)      ; Lege Werte wieder ab !
        st              MERKER                ; Setze Merker !
        bra.s           SORTIN                ; -> SortIn

* Routine zeichnet Objekte !
DRAWOBJS:
        lea             OBJLIST(pc),a0        ; ObjListBase -> a0
        move.w          OBJNUM(pc),d7         ; ObjNum -> d7
        subq.w          #1,d7                 ; Correct LoopCounter !
DRAWOBJSL:
        movem.l         (a0)+,d0-d2           ; X-Y-Z-Coordinate -> d0 - d2
        move.l          (a0)+,d3              ; Hole DatenPointer !
        bmi             DRAWIT                ; NEG -> DrawIt
        sub.w           #48,d0                ; Mitte-X
        sub.w           #64,d1                ; Mitte-Y
        st              PL3FL                 ; 3 Bitplane-Flag = True
        bra.s           DRAWITS               ; -> DrawIts
DRAWIT:
        neg.l           d3                    ; NEG d3
DRAWITS:
        movem.l         d0-d1/d3,NETREGS      ; Parameter -> NetRegs
        cmp.w           #5,d2                 ; Netz-Verdeckung ?
        slt             HIDEFLAG              ; Ja -> HideFlag
        movea.l         d3,a2                 ; DatenPointer -> a2
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         PLANES(a6),a1         ; ZielPlane -> a1
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Set ClipDown
        subq.w          #1,d5                 ; DEC Height
        movea.w         #1,a4                 ; BCKSave !
        movem.l         d7-a0,-(a7)           ; Save Regs on Stack
        bsr             BOB                   ; Bob It!
        movem.l         (a7)+,d7-a0           ; Get Regs from Stack !
        sf              PL3FL                 ; 3 Bitplane-Flag = False
        tst.b           HIDEFLAG              ; Verdeckung ?
        beq.s           NONETOVER             ; Nein -> NoNetOver
        bsr             NETOVER               ; -> NetOver
NONETOVER:
        dbra            d7,DRAWOBJSL          ; -> Loop
        rts                                   ; Back !

* Routine legt Netz im Fall von einer Verdeckung nochmal drber
NETOVER:
        movem.l         d7-a0,-(a7)           ; Save Regs on Stack !
        movea.l         NETIMG,a0             ; NetImgBase -> a0
        movea.l         NETMSK,a1             ; NetMskBase -> a1
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         PLANES(a6),a3         ; PlaneBase -> a3
        movem.l         NETREGS(pc),d0-d1/a2  ; Get ObjParameter !
        move.w          OS_BREITE1(a2),d4     ; Breite in Worten -> d4
        addq.w          #1,d4                 ; INC Breite
        add.w           OS_XOFF(a2),d0        ; ADD XOffset !
        add.w           OS_YOFF(a2),d1        ; ADD YOffset !
        move.w          d1,d2                 ; Y -> d2
        add.w           OS_HOEHE(a2),d2       ; ADD Hoehe
        sub.w           #NETY1,d1             ; SUB NetY1 Y1
        bpl.s           FULLHEIGHT1           ; POS -> FullHeight1
        moveq           #0,d1                 ; Y1 = 0
FULLHEIGHT1:
        sub.w           #NETY1,d2             ; SUB NetY1 Y2
        bmi             NETOVERENDE           ; NEG -> Ende ( OBJ not in Net )
        cmp.w           #21,d2                ; NetzEnde ?
        ble.s           FULLHEIGHT2           ; Nein -> FullHeight2
        moveq           #21,d2                ; Y2 = 32
FULLHEIGHT2:
        moveq           #0,d1                 ; Y1 = 0
        moveq           #21,d2                ; Y2 = 32
        andi.w          #$fff0,d0             ; X-WortOffset
        asr.w           #3,d0                 ; Wortoffset.
        adda.w          d0,a0                 ; ADD WortOffset ( IMG )
        adda.w          d0,a1                 ; ADD WortOffset ( MSK )
        adda.w          d0,a3                 ; ADD WortOffset ( Dest. )

        sub.w           d1,d2                 ; SUB Y1 Y2 ( Echte Hoehe )
        addq.w          #1,d2                 ; INC Height !
        lsl.w           #6,d2                 ; << 6 = ( BlitSize.Height )
        or.w            d4,d2                 ; OR WordWidth
        move.w          ONELINE(a6),d0        ; Eine Zeile in Words -> d0
        sub.w           d4,d0                 ; SUB WordWidth ( = Modulo SRC )
        add.w           d0,d0                 ; d0 = Modulo in Bytes
        add.w           d1,d1                 ; Y1 * 2 fuer TabellenZugriff
        move.w          MULU160(a6,d1.w),d6   ; Y-Offset -> d6

        adda.w          d6,a0                 ; ADD YWortOffset ( IMG )
        adda.w          d6,a1                 ; ADD YWortOffset ( MSK )
        add.w           #NETY1*2,d1           ; ADD NETY
        move.w          MULU160(a6,d1.w),d1   ; Y-Offset -> d1
        adda.w          d1,a3                 ; ADD YWortOffset ( Dest. )

        move.w          SCRPLANESC(a6),d7     ; Planes -> d7

        bsr             WAITBLIT              ; Wait on Blitter !
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #-1,BLTAFWM(a4)       ; FirstMask A setzen
        move.w          #-1,BLTALWM(a4)       ; LastMask A setzen
        move.w          d0,BLTAMOD(a4)        ; MODs setzen
        move.w          d0,BLTBMOD(a4)        ; MODs setzen
        move.w          d0,BLTCMOD(a4)        ; Modulo fuer SourceBitmap (C)
        move.w          d0,BLTDMOD(a4)        ; Modulo fuer DestBitmap (D)

        move.w          #0,BLTCON1(a4)        ; Only Copy
        move.w          #$0fca,BLTCON0(a4)    ; Miniterm

BLITNET:
        move.l          a0,BLTBPTH(a4)        ; Zeiger auf Daten (B)
        move.l          a1,BLTAPTH(a4)        ; Zeiger auf Maske (A)
        move.l          a3,BLTCPTH(a4)        ; Zeiger auf SourceBitmap (C)
        move.l          a3,BLTDPTH(a4)        ; Zeiger auf DestBitmap (D)
        move.w          d2,BLTSIZE(a4)        ; ab geht die Post
        dbra            d7,BLITNET_           ; -> Loop
NETOVERENDE:
        movem.l         (a7)+,d7-a0           ; Get Regs from Stack !
        rts

BLITNET_:
        lea             8000(a3),a3           ; Next Plane Destination
        lea             880(a0),a0            ; Next Plane Source
        bsr             WAITBLIT              ; are you ready?
        bra.s           BLITNET               ; -> Loop

NETREGS:        DS.L 3                  ; Buffer fuer 1 Satz ObjektParameter

* Routine restauriert Background der Objekte
MYRESTBACK:
        move.w          OBJNUM(pc),d7         ; ObjNum -> d7
        subq.w          #1,d7                 ; Correct LoopCounter !
MYRESTBACKL:
        move.w          d7,-(a7)              ; Save Regs on Stack
        bsr             OLDBACK               ; BackGround zurck !
        move.w          (a7)+,d7              ; Get Regs from Stack !
        dbra            d7,MYRESTBACKL        ; -> Loop
        rts                                   ; Back !

* Routine stellt die Ballmaschine in den Platz
COPYMASCHINE:
        movea.l         BALLSCRPORT+AN_BASE,a2 ; Pointer Base of Datas -> a2
        adda.w          #MASCHINE,a2          ; Offset auf Maschine !
        move.w          #BALLMACHX,d0         ; X-Koordinate -> d0
        move.w          #BALLMACHY,d1         ; Y-Koordinate -> d1
        bra             MYBOB                 ; Bob It!

; Routine kopiert Schiedsrichter fuer Spiel ein
COPYREFS:
        movea.l         BALLSCRPORT+AN_BASE,a2 ; Pointer Base of Datas -> a2
        adda.w          #MREF,a2              ; Offset auf Hauptschiedsrichter !
        move.w          #MREFX,d0             ; X-Koordinate -> d0
        move.w          #MREFY,d1             ; Y-Koordinate -> d1
        bsr             MYBOB                 ; Bob It !

        movea.l         BALLSCRPORT+AN_BASE,a2 ; Pointer Base of Datas -> a2
        adda.w          #L1REF,a2             ; Offset auf L. Linienrichter !
        move.w          #L1REFX,d0            ; X-Koordinate -> d0
        move.w          #L1REFY,d1            ; Y-Koordinate -> d1
        bsr             MYBOB                 ; Bob It !

        movea.l         BALLSCRPORT+AN_BASE,a2 ; Pointer Base of Datas -> a2
        adda.w          #L2REF,a2             ; Offset auf R. Linienrichter !
        move.w          #L2REFX,d0            ; X-Koordinate -> d0
        move.w          #L2REFY,d1            ; Y-Koordinate -> d1
        bsr             MYBOB                 ; Bob It !

        movea.l         BALLSCRPORT+AN_BASE,a2 ; Pointer Base of Datas -> a2
        adda.w          #NREF,a2              ; Offset auf Netzrichter !
        move.w          #NREFX,d0             ; X-Koordinate -> d0
        move.w          #NREFY,d1             ; Y-Koordinate -> d1
        bra.s           MYBOB                 ; Bob It !

* Standard BobRoutine fuer Kopieren
MYBOB:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         PLANES(a6),a1         ; ZielPlane -> a1
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Set ClipDown
        suba.w          a4,a4                 ; No BCKSave !
        bra             BOB                   ; Copy It !

* Routine gibt den Spielstand nach Saetzen aus
DESIGNSCORE:
        bsr             SAVESCRBCK            ; Sichere ScoreBackGround
        bsr             MANSCREEN             ; Aendere ScreenPort !
        bsr             COPYBALLSCR           ; Ball einkopieren !
        bsr             SHADOWBOX             ; Gebe Schatten aus !
        bsr             NORMBOX               ; Normale Box drueber !
        bsr             SCORENAMES            ; Namen ausgeben !
        bsr             SCORES                ; Spielstand ausgeben !
        bsr             REMANSCREEN           ; Schreibe ScrPortDaten zurueck !
        bsr             BLENDIN               ; Einblenden !
        bsr             ANIMBALL              ; Animiere Ball !
        bra             BLENDOUT              ; Ausblenden !

* Routine gibt den Spielstand inerhalb eines Games aus !
GAMESCORE:
        bsr             GENGAMESCORE          ; Generiere ASCII's
        bsr             GAMESCOREOUT          ; Gebe GameStand aus !
        bsr             WAITS                 ; Warte auf FeuerKnopf !
        bsr             WAITBEAM              ; Warte auf Strahl !
        bra             BCKLOAD               ; Restauriere BackGround !

* Routine wartet auf gnstige Position des Balles und des Schattens
WAITBALL:
        cmpi.w          #100,BS_YY+BALLPORT   ; Position Ball ?
        bge.s           WAITBALL              ; > -> WaitBall
        cmpi.w          #100,BS_YYY+BALLPORT  ; Position Schatten ?
        bge.s           WAITBALL              ; > -> WaitBall
        rts                                   ; Back !

* Routine gibt Spielstand ( Game ) aus
GAMESCOREOUT:
        lea             GSCRTXT(pc),a0        ; ASCII-Buffer -> a0
        move.l          CHARGAME(pc),CHARPTR+SCRPORT ; Saetze akt. Zeichensatz
        move.w          #1,CHAREFF+SCRPORT    ; Setze Effekt !
        bsr             PROPWIDTH             ; -> PropWidth
        move.w          d0,-(a7)              ; Save PropWidth on Stack !
        neg.w           d0                    ; NEG Breite in Pixel
        add.w           #320,d0               ; ADD Breite in Pixel ( Display )
        asr.w           #1,d0                 ; / 2 fuer Zentrierung
        move.w          #SCTG1-2,d1           ; Y-Coordinate -> d1
        move.w          d0,d2                 ; X-Coordinate -> d2
        add.w           (a7),d2               ; ADD PropWidth
        move.w          #SCTG1+24,d3          ; Y2-Coordinate -> d3
        bsr             BCKSAVE               ; BackGround sichern !

        move.w          #SCTG1,d1             ; Y-Coordinate -> d1
        move.w          d0,-(a7)              ; Save X-Coordinate on Stack !
        bsr             PROPSTRING            ; Gebe Score aus !
        move.w          (a7)+,d0              ; Get X-Coordinate from Stack !
        move.w          d0,d2                 ; X-Coordinate -> d2
        add.w           (a7)+,d2              ; ADD PropWidth ( From Stack )
        move.w          #SCTG1+18,d1          ; Y1-Coordinate -> d1
        move.w          #SCTG1+22,d3          ; Y2-Coordinate -> d3
        movem.w         d0/d2,-(a7)           ; Save X-Coordinates on Stack !
        move.w          #13,COLOR+SCRPORT     ; Setze Farbe
        addq.w          #2,d0                 ; INC X1 ( Schatten )
        addq.w          #2,d2                 ; INC X2 ( Schatten )
        bsr             FILLBOX               ; Unterstreichung ( Schatten )
        movem.w         (a7)+,d0/d2           ; Get X-Coordinates from Stack
        move.w          #SCTG1+20,d1          ; Y1-Coordinate -> d1
        move.w          #SCTG1+24,d3          ; Y2-Coordinate -> d3
        move.w          #12,COLOR+SCRPORT     ; Setze Farbe
        bsr             FILLBOX               ; Unterstreichung ( Normal )
        rts                                   ; Back !

* Routine generiert aus dem GameSpielstand ASCII's
GENGAMESCORE:
        move.w          SCPPORT(pc),d0        ; Standing ( Own Player ) -> d0
        move.w          SCEPORT(pc),d1        ; Standing ( Enemy ) -> d1
        tst.b           TIEBREAK              ; TieBreak ?
        bne.s           TIEBREAKOUT           ; Ja -> TieBreakOut
        cmp.w           #4,d0                 ; > Normaler Zahl ?
        blt.s           P1EQUNUM              ; Nein -> P1EQUNum
        cmp.w           #4,d1                 ; > Normaler Zahl ?
        blt.s           P1EQUNUM              ; Nein -> P1EQUNum
        cmp.w           d0,d1                 ; CMP GameStaanding
        beq             MAKEDEUCE             ; = -> MakeDeuce
        bgt             MAKEADVP2             ; > -> MakeAdvP2
        bra             MAKEADVP1             ; < -> MakeAdvP1
P1EQUNUM:
        move.w          d1,d2                 ; Standing P2 -> d2
        sub.w           d0,d2                 ; SUB Standing P1
        beq.s           EINSTAND              ; = -> Einstand
        bpl.s           SDIFPOS               ; + -> SDDifPos
        cmp.w           #3,d0                 ; Is PL1 = 40
        bgt             MAKEADVP1             ; > -> MakeAdvP1
        bra.s           NORMSCORE             ; -> NormScore
SDIFPOS:
        cmp.w           #3,d1                 ; Is PL2 = 40
        bgt             MAKEADVP2             ; > -> MakeAdvP2
        bra.s           NORMSCORE             ; -> NormScore
EINSTAND:
        cmp.w           #3,d0                 ; Is PL1 = 40
        bge             MAKEDEUCE             ; >= -> MakeDeuce
        bra.s           NORMSCORE             ; -> NormScore

TIEBREAKOUT:
        move.w          d0,d4                 ; d0 -> d4
        move.w          d1,-(a7)              ; d1 on Stack
        ext.w           d4                    ; d4 auf LangWort
        bsr             DECUMRECHNUNG         ; -> BininDec !
        lea             OUBUFFER(pc),a0       ; OuBuffer -> a0
        lea             GSCRTXT(pc),a1        ; GSCRTXT -> a1
        bsr             STRCOPY               ; -> StrCopy
        move.b          #"-",(a1)+            ; Trennung in ASCIIBuffer
        move.w          (a7)+,d4              ; Stack -> d4
        ext.l           d4                    ; d4 auf LangWort
        move.l          a1,-(a7)              ; Ptr to ASCIIBuffer on Stack
        bsr             DECUMRECHNUNG         ; -> BininDec !
        lea             OUBUFFER(pc),a0       ; OuBuffer -> a0
        movea.l         (a7)+,a1              ; Get Ptr to ASCIIBuffer from St.
        bsr             STRCOPY               ; -> StrCopy
        move.b          #0,(a1)               ; Endekennung setzen !
        rts                                   ; Back !

NORMSCORE:
        lea             SCORETAB(pc),a0       ; ScoreTabBase -> a0
        lea             GSCRTXT(pc),a1        ; GSCRTXT -> a1
        add.w           d0,d0                 ; Standing PL1 * 2 fuer Tabelle
        add.w           d1,d1                 ; Standing PL2 * 2 fuer Tabelle
        move.w          0(a0,d0.w),(a1)+      ; Score in ASCIIBuffer
        move.b          #"-",(a1)+            ; Trennung in ASCIIBuffer
        move.w          0(a0,d1.w),d1         ; Score -> d1
        rol.w           #8,d1                 ; <<< 8 ( No odd Address )
        move.b          d1,(a1)+              ; -> Unterer ASCII in ASCIIBuffer
        rol.w           #8,d1                 ; <<< 8 ( Oberen ASCII holen )
        move.b          d1,(a1)+              ; -> Oberer ASCII in ASCIIBuffer
        move.b          #0,(a1)               ; EndeKennung setzen !
        rts                                   ; Back !

MAKEADVP1:
        lea             ADVTXT(pc),a0         ; SourceStr -> a0
        lea             GSCRTXT(pc),a1        ; DestStr -> a1
        bsr             STRCOPY               ; -> StrCopy
        lea             ACTPLAY1(pc),a0       ; SourceStr -> a0
        bsr             STRCOPY               ; -> StrCopy
        move.b          #0,(a1)               ; Setze EndeKennung !
        rts                                   ; Back !
MAKEADVP2:
        lea             ADVTXT(pc),a0         ; SourceStr -> a0
        lea             GSCRTXT(pc),a1        ; DestStr -> a1
        bsr             STRCOPY               ; -> StrCopy
        lea             ACTPLAY2(pc),a0       ; SourceStr -> a0
        bsr             STRCOPY               ; -> StrCopy
        move.b          #0,(a1)               ; Setze EndeKennung !
        rts                                   ; Back !

MAKEDEUCE:
        lea             DEUCETXT(pc),a0       ; SourceStr -> a0
        lea             GSCRTXT(pc),a1        ; DestStr -> a1
        bsr             STRCOPY               ; -> StrCopy
        move.b          #0,(a1)               ; Setze EndeKennung !
        rts                                   ; Back !

* Routine setzt gesicherten Background wieder in Planes zurck
BCKLOADSET:     REG d4-a1/a6
BCKLOAD:
        movem.l         BCKLOADSET,-(a7)      ; Rette Regs

        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          BCKBSIZE(a6),d7       ; Hole BlitSize
        move.l          BCKOFFS(a6),d4        ; Hole Offset
        move.w          MODULO(a6),d6         ; Hole Modulo

        move.w          SCRPLANESC(a6),d5     ; Init LoopCounter
        lea             PLANES(a6),a1         ; Adressen der Planes -> a1

        bsr             WAITBLIT              ; Warte auf Blitter !
        move.l          BCKBACK1(pc),BLTAPTH(a4) ; Setze Source.Adresse
        clr.w           BLTCON1(a4)           ; Only Copy!

        move.w          #$09f0,BLTCON0(a4)    ; Term setzen

        move.w          #$ffff,BLTAFWM(a4)    ; Set FirstWordMask to All
        move.w          #$ffff,BLTALWM(a4)    ; Set LastWordMask to All
        move.w          #0,BLTAMOD(a4)        ; Modulo A auf 0 setzen
        move.w          d6,BLTDMOD(a4)        ; Modulo D setzen
BCKLOADLOOP:
        movea.l         (a1)+,a0              ; Offset vom Stack holen
        adda.l          d4,a0                 ; BPL-Offset addieren
        bsr             WAITBLIT              ; Wait on Blitter
        move.l          a0,BLTDPTH(a4)        ; Destination
        move.w          d7,BLTSIZE(a4)        ; Size
        dbra            d5,BCKLOADLOOP        ; Loop

        movem.l         (a7)+,BCKLOADSET      ; Regs wiederholen
        rts

* Routine sichert Background des angegebenen Rechtecks im GraphicPort auf
* Wortgrenze
* Input:
*       d0 - d3    = Rechteckkoordinaten ( X1,Y1,X2,Y2 )
BCKSAVESET:     REG d0-a1
BCKSAVE:
        movem.l         BCKSAVESET,-(a7)      ; Rette Register
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6

        move.w          d1,d4                 ; Y1 -> d4
        add.w           d4,d4                 ; Fuer Adresszugriff
        move.w          MULU160(a6,d4.w),d4   ; Hole y-Wert
        move.w          d0,d7                 ; x1 -> d4
        lsr.w           #3,d7                 ; x1 / 8
        add.w           d7,d4                 ;
        ext.l           d4                    ; d4 now Offset

        move.w          d2,d7                 ; x2 -> d7
        move.w          d0,d6                 ; X1 -> d6
        lsr.w           #4,d7                 ; / 16
        lsr.w           #4,d6
        sub.w           d6,d7                 ; Erechne HBlitsize
        addq.w          #1,d7

        move.w          ONELINE(a6),d6        ; Breite des Display in Words
        sub.w           d7,d6                 ; Sub HBlitsize
        lsl.w           #1,d6                 ; Modulo in Bytes

        sub.w           d1,d3                 ; Errechne VBlitsize
        addq.w          #1,d3                 ; INC BlitSize

        move.l          d4,BCKOFFS(a6)        ; Offset der Sources retten
        move.w          d6,MODULO(a6)         ; Modulo retten

        lsl.w           #6,d3                 ; Shift VBlitSize
        or.w            d3,d7                 ; d7 = BlitSize
        move.w          d7,BCKBSIZE(a6)       ; BlitSize ablegen
        move.w          SCRPLANESC(a6),d5     ; Init LoopCounter
        lea             PLANES(a6),a1         ; Adressen der Planes -> a1

        bsr             WAITBLIT              ; Wait on Blitter
        move.l          BCKBACK1(pc),BLTDPTH(a4) ; Destination
        move.w          #$09f0,BLTCON0(a4)    ; Term setzen

        move.w          #$ffff,BLTAFWM(a4)    ; Set FirstWordMask to All
        move.w          #$ffff,BLTALWM(a4)    ; Set LastWordMask to All
        move.w          d6,BLTAMOD(a4)        ; Modulo A setzen
        move.w          #0,BLTDMOD(a4)        ; Modulo D auf 0 setzen
        clr.w           BLTCON1(a4)           ; Only Copy!
BCKSAVELOOP:
        movea.l         (a1)+,a0              ; Offset vom Stack holen
        adda.l          d4,a0                 ; BPL-Offset addieren
        bsr             WAITBLIT              ; Wait on Blitter
        move.l          a0,BLTAPTH(a4)        ; Source
        move.w          d7,BLTSIZE(a4)        ; Size
        dbra            d5,BCKSAVELOOP        ; Loop

        movem.l         (a7)+,BCKSAVESET      ; Hole Register
        rts

* Routine blendet den Spielstand ein ( lalalalalala ..... )
BLENDIN:
        movea.l         BCKBACK1(pc),a0       ; BCKBackPtr -> a0
        bra             EFFECTCOPY            ; EffectCopy !

* Routine blendet den Spielstand aus ( lalalalalala ..... )
BLENDOUT:
        movea.l         BCKBACK2(pc),a0       ; BCKBackPtr -> a0
        bra             EFFECTCOPY            ; EffectCopy !

* EffectCopy ( speziell fuer Einblenden des Spielstandes )
EFFECTCOPY:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         PLANES(a6),a1         ; Zeiger auf Plane -> a1
        move.w          #SCTB1-2+25,d2        ; Start des Schreibens -> d2
        add.w           d2,d2                 ; d2 * 2 fuer Wortzugriff
        move.w          MULU160(a6,d2.w),d2   ; Y-Offset ( Dest ) -> d2
        lea             0(a1,d2.w),a1         ; Y-Offset addieren
        moveq           #50,d2                ; 25 = Mitte -> d2
        move.w          MULU160(a6,d2.w),d2   ; Y-Offset ( Source ) -> d2
        lea             0(a0,d2.w),a0         ; Y-Offset addieren
        move.l          a0,d2                 ; a0 -> d2
        move.l          a1,d3                 ; a1 -> d3

        moveq           #64,d6                ; Init Blitsize
        move.w          SCRPLANESC(a6),d0     ; Anzahl der Bitplanes
        moveq           #24,d1                ; Init SecLoopCounter !

REBLITBCK:
        move.w          d6,d7                 ; BlitSize -> d7
        or.w            #$0014,d7             ; OR Breite in Words
        bsr             WAITBLIT              ; Warte auf Blitter !
        move.w          #-1,BLTAFWM(a4)       ; Mask A setzen
        move.w          #-1,BLTALWM(a4)       ; Mask B setzen
        move.w          #0,BLTAMOD(a4)        ; MODs setzen
        move.w          #0,BLTBMOD(a4)        ; MODs setzen
        move.w          #0,BLTCMOD(a4)        ; MODs setzen
        move.w          #0,BLTDMOD(a4)        ; MODs setzen
        move.w          #0,BLTCON1(a4)        ; Only Copy !
        move.w          #$09f0,BLTCON0(a4)    ; Set Terms !

        move.l          a0,BLTAPTH(a4)        ; Zeiger auf Source (A)
        move.l          a1,BLTDPTH(a4)        ; Zeiger auf DestBitmap (D)

        move.w          d7,BLTSIZE(a4)        ; ab geht die Post
        adda.l          ONEPLANE(a6),a1       ; Eine Plane weiter ( Dest. )
        adda.w          #BACKMEMSIZE/4,a0     ; Eine Plane weiter ( Source )
        dbra            d0,REBLITBCK          ; -> Loop
        movea.l         d2,a0                 ; d2 -> a0
        movea.l         d3,a1                 ; d3 -> a1
        suba.w          ONELINEB(a6),a1       ; Eine Zeile weniger ( Dest. )
        suba.w          ONELINEB(a6),a0       ; Eine Zeile weniger ( Source )
        move.l          a1,d3                 ; a1 -> d3
        move.l          a0,d2                 ; a0 -> d2
        add.w           #128,d6               ; INC BlitSize!
        bsr             WAITBEAM              ; Wait
        move.w          SCRPLANESC(a6),d0     ; Anzahl der Bitplanes
        dbra            d1,REBLITBCK          ; -> Loop
        rts

* Routine schreibt die ScreenPortDaten zurueck
REMANSCREEN:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             PLANES(a6),a1         ; PTR to Planes -> a1
        lea             TEMPBUFFER(pc),a0     ; TempBufferBase -> a0
        move.l          (a0)+,ONEPLANE(a6)    ; OnePlane zurckschreiben !
        move.l          (a0)+,(a1)+           ; 1. PlanePtr schreiben
        move.l          (a0)+,(a1)+           ; 2. PlanePtr schreiben
        move.l          (a0)+,(a1)+           ; 3. PlanePtr schreiben
        move.l          (a0)+,(a1)+           ; 4. PlanePtr schreiben
        rts                                   ; Back !

* Routine manipuliert ScreenPort fuer Scoreausgabe
MANSCREEN:
        lea             PLANES(a6),a0         ; PTR to Planes -> a0
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             PLANES(a6),a0         ; PTR to Planes -> a0
        lea             TEMPBUFFER(pc),a1     ; TempBufferBase -> a1
        move.l          ONEPLANE(a6),(a1)+    ; ONEPLANE retten
        move.l          (a0)+,(a1)+           ; 1. PlanePtr retten
        move.l          (a0)+,(a1)+           ; 2. PlanePtr retten
        move.l          (a0)+,(a1)+           ; 3. PlanePtr retten
        move.l          (a0)+,(a1)+           ; 4. PlanePtr retten
        lea             PLANES(a6),a1         ; PTR to Planes -> a1
        move.l          BCKBACK1(pc),d0       ; BackBuffer -> d0
        move.l          d0,(a1)+              ; Neuen 1. PlanePtr eintragen
        add.l           #BACKMEMSIZE/4,d0     ; ONEPLANE addieren
        move.l          d0,(a1)+              ; Neuen 2. PlanePtr eintragen
        add.l           #BACKMEMSIZE/4,d0     ; ONEPLANE addieren
        move.l          d0,(a1)+              ; Neuen 3. PlanePtr eintragen
        add.l           #BACKMEMSIZE/4,d0     ; ONEPLANE addieren
        move.l          d0,(a1)+              ; Neuen 4. PlanePtr eintragen
        move.l          #BACKMEMSIZE/4,ONEPLANE(a6) ; ONEPLANE setzen
        rts                                   ; Back !

* Routine animiert den Ball waehrend Darstellung des Scores!
ANIMBALL:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             BALLSCRPORT(pc),a0    ; BallScrPort -> a0
        bsr             ANIMATION             ; Animation !
        movea.l         PLANES(a6),a1         ; ZielPlane -> a1
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Set ClipDown !
        bsr             WAITBEAM              ; Warte Auf Strahl !
        moveq           #BALLX,d0             ; X-Koordinate setzen
        move.w          #BALLY+SCTB1-2,d1     ; Y-Koordinate setzen
        suba.w          a4,a4                 ; No BckSave !
        bsr             BOB                   ; Bob It !
        tst.b           JOYPORT+JP_BUTTON     ; Teste Button
        beq.s           ANIMBALL              ; Nein -> Loop
        bra             WAITP                 ; Entprelle JoyStick !

* Routine kopiert den Ball zum ersten Mal ein und erzeugt Schatten
COPYBALLSCR:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         BALLSCRPORT+AN_BASE,a2 ; BallScrPtr -> a2
        adda.w          #BSCR1,a2             ; Ersten Offset addieren
        movea.l         a2,a0                 ; BallScrPtr -> a0
        movea.l         PLANES(a6),a1         ; ZielPlane -> a1
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Set ClipDown
        adda.w          OS_IMGOFF(a2),a0      ; a0 Zeiger auf Image
        move.w          OS_BREITE1(a2),d6     ; BREITE1 in Worten -> d6
        move.w          OS_HOEHE(a2),d7       ; HOEHE in Zeilen.
        lea             OS_MSKOFF(a2),a2      ; a2 Zeiger auf Maske
        moveq           #BALLX,d0             ; X-Koordinate setzen
        moveq           #BALLY,d1             ; Y-Koordinate setzen
        movem.l         d0-d2/d4-a1,-(a7)     ; Save Regs on Stack !
        addq.w          #2,d0                 ; INC X ( Schatten )
        subq.w          #2,d1                 ; DEC Y ( Schatten )
        bsr             CHARSHADOW            ; Charshadow !
        movem.l         (a7)+,d0-d2/d4-a1     ; Get Regs from Stack !
        suba.l          a4,a4                 ; No BackSave !
        bsr             BOB1                  ; Bob it !
        rts

* Routine speichert den Background des Scores zweimal ( SCTB - 2 )
SAVESCRBCK:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         PLANES(a6),a0         ; Zeiger auf Plane -> a0
        move.w          #SCTB1-2,d2           ; Start des Rettens -> d2
        add.w           d2,d2                 ; d2 * 2 fuer Wortzugriff
        move.w          MULU160(a6,d2.w),d2   ; Y-Offset -> d2
        lea             0(a0,d2.w),a0         ; Y-Offset addieren
        movea.l         BCKBACK1(pc),a1       ; 1. Destination -> a1
        move.l          a0,d2                 ; a0 -> d2

        move.w          SCRPLANESC(a6),d0     ; Anzahl der Bitplanes
        moveq           #1,d1                 ; Init SecLoopCounter !

BLITBCK:
        bsr             WAITBLIT              ; Warte auf Blitter !
        move.w          #-1,BLTAFWM(a4)       ; Mask A setzen
        move.w          #-1,BLTALWM(a4)       ; Mask B setzen
        move.w          #0,BLTAMOD(a4)        ; MODs setzen
        move.w          #0,BLTBMOD(a4)        ; MODs setzen
        move.w          #0,BLTCMOD(a4)        ; MODs setzen
        move.w          #0,BLTDMOD(a4)        ; MODs setzen
        move.w          #0,BLTCON1(a4)        ; Only Copy !
        move.w          #$09f0,BLTCON0(a4)    ; Set Terms !

        move.l          a0,BLTAPTH(a4)        ; Zeiger auf Source (A)
        move.l          a1,BLTDPTH(a4)        ; Zeiger auf DestBitmap (D)
        move.w          #$0c94,BLTSIZE(a4)    ; ab geht die Post
        lea             BACKMEMSIZE/4(a1),a1  ; Eine Plane weiter ( Dest. )
        adda.l          ONEPLANE(a6),a0       ; Eine Plane weiter ( Source )
        dbra            d0,BLITBCK            ; -> Loop
        move.w          SCRPLANESC(a6),d0     ; Anzahl der Bitplanes
        movea.l         BCKBACK2(pc),a1       ; 2. Destination -> a1
        movea.l         d2,a0                 ; Source wiederherstellen
        dbra            d1,BLITBCK            ; -> Loop
        rts

* Routine gibt Spielstand aus
SCORES:
        lea             SCORETXT1(pc),a5      ; Get KoordBase -> a5
        lea             SCPPORT+SL_MATCH,a0   ; Zeiger auf 1. Score -> a0
        move.w          ACTSET(pc),d6         ; Init LoopCounter ( ActSet) !
        bsr             SETSOUT               ; -> SetsOut !

        lea             SCORETXT2(pc),a5      ; Get KoordBase -> a5
        lea             SCEPORT+SL_MATCH,a0   ; Zeiger auf 2. Score -> a0
        move.w          ACTSET(pc),d6         ; Init LoopCounter ( ActSet) !

SETSOUT:
        movem.w         (a5)+,d0-d1           ; Hole Koordinaten !
        move.w          (a0)+,d7              ; Hole Zeichen -> d7
        add.b           #"0",d7               ; Make ASCII !
        ext.w           d7                    ; ASCII erweitern
        movem.l         d6/a0/a5,-(a7)        ; Save Regs on Stack !
        bsr             ONEPROP               ; Gebe Zeichen aus !
        movem.l         (a7)+,d6/a0/a5        ; Get Regs from Stack !
        dbra            d6,SETSOUT            ; -> Loop
        rts                                   ; Back

* Routine gibt Namen der beiden Spieler aus
SCORENAMES:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.l          CHARGAME,CHARPTR(a6)  ; Setze aktuellen Zeichen.
        move.w          #1,CHAREFF(a6)        ; Setze Effekt ( Schatten )
        lea             SCORETXT(pc),a5       ; Get KoordBase -> a5
        movem.w         (a5)+,d0-d1           ; Hole Koordinaten !
        lea             ACTPLAY1(pc),a0       ; Zeiger auf 1. Namen -> a0
        move.l          a5,-(a7)              ; Save a5 on Stack !
        bsr             PROPSTRING            ; Gebe Zeichen aus !
        movea.l         (a7)+,a5              ; Get a5 from Stack !
        movem.w         (a5)+,d0-d1           ; Hole Koordinaten !
        lea             ACTPLAY2(pc),a0       ; Zeiger auf 1. Namen -> a0
        bsr             PROPSTRING            ; Gebe Zeichen aus !
        rts                                   ; Back !

* Routine gibt den Schatten der Box aus
SHADOWBOX:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #SHBOXCOL,COLOR(a6)   ; Farbe setzen !
        lea             SCOREBOX(pc),a5       ; Base of Coords -> a5
        moveq           #5,d7                 ; Init LoopCounter !
SHADOWLOOP:
        movem.w         (a5)+,d0-d3           ; Hole Koordinaten !
        addq.w          #2,d0                 ; INC X1 ( Schatten )
        addq.w          #2,d2                 ; INC X2 ( Schatten )
        subq.w          #2,d1                 ; DEC Y1 ( Schatten )
        subq.w          #2,d3                 ; DEC Y2 ( Schatten )
        bsr             FILLBOX               ; Zeichne gefuellte Box !
        dbra            d7,SHADOWLOOP         ; -> Loop
        rts                                   ; Back !

* Routine gibt die normale Box fuer Score aus
NORMBOX:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #BOXCOL,COLOR(a6)     ; Farbe setzen !
        lea             SCOREBOX(pc),a5       ; Base of Coords -> a5
        moveq           #5,d7                 ; Init LoopCounter !
NORMBLOOP:
        movem.w         (a5)+,d0-d3           ; Hole Koordinaten !
        bsr             FILLBOX               ; Zeichne gefuellte Box !
        dbra            d7,NORMBLOOP          ; -> Loop
        rts                                   ; Back !


* Organisiere DoubleBuffering
DOUBLEBUFFER:
        bsr             WAITBEAM              ; Warte auf Strahl
        bsr             PLANEINIT             ; Anderen Schirm anzeigen
        bsr             SECPLANES             ; Kopiere 2. Planesset in SCRPORT
        rts                                   ; Back to Call !

WAITBEAM:
        move.l          CUSTOM+VHPOSR,d0
        and.l           #$0001ff00,d0
        cmp.l           #$0000f400,d0
        bne.s           WAITBEAM
        rts

STARTWAIT:
        move.w          #300,d1               ; 20000 -> d1
STWAL:  bsr             WAITBEAM
        move.w          #$0100,d2             ; Wieder COUNT
STWAL1: dbra            d2,STWAL1
        dbra            d1,STWAL
        rts

SECPLANES:
        lea             DPPORT(pc),a0         ; DoublePort -> a0
        lea             SCRPORT(pc),a1        ; ScreenPortBase -> a1
        move.w          SCRPLANESC(a1),d7     ; Init LoopCounter
        lea             PLANES(a1),a1         ; PlanesBase -> a1
SECPLANESLOOP:
        move.l          (a0),d0               ; PlanePointer -> d0
        move.l          (a1),(a0)+            ; PlanePointer vertauschen
        move.l          d0,(a1)+              ; PlanePointer eintragen
        dbra            d7,SECPLANESLOOP      ; -> Loop
        rts                                   ; Back to Call !

OUTPUTCOURT:
        bsr             CLEARSCREEN           ; Loesche Display !
        bsr             POLYGROUND            ; Gebe Platz als Polygon aus !
        bsr             OUTLINES              ; AussenLinien zeichnen
        bsr             POLYNET               ; Gebe Netz als Polygon aus !
        bsr             REPLAYOUT             ; Gebe Replay-Zeichen aus !
        bra             DRAWBALLS             ; Zeichne Ball !

* Routine organisiert die Bewegung des Platzes
MAKEMOTION:
        lea             MOTIONPORT(pc),a0     ; MotionPortBase -> a0
        move.w          ACTMOTION(pc),d0      ; Nummer des akt. Frames -> d0
        move.w          d0,d1                 ; Nummer des akt. Frames -> d1
        mulu            #RD_SIZEOF,d0         ; * Groesse eines Eintrags
        lea             0(a0,d0.w),a0         ; Offset addieren
        move.w          (a0)+,W1REG           ; Trage Daten ein !
        move.w          (a0)+,W2REG           ; Trage Daten ein !
        move.w          (a0)+,W3REG           ; Trage Daten ein !
        move.w          (a0)+,DISREG          ; Trage Daten ein !
        move.w          (a0)+,DIS1REG         ; Trage Daten ein !
        tst.l           (a0)                  ; Ist Ende erreicht ?
        bmi.s           LASTMOTION            ; Ja -> LastMotion
        add.w           MOTIONDEC(pc),d1      ; INC Actmotion
        bmi.s           MOTIONFORWARD         ; FrameNumber negativ -> Motionf
        move.w          d1,ACTMOTION          ; FrameNumber ablegen
        rts                                   ; Back !
MOTIONFORWARD:
        neg.w           MOTIONDEC             ; Set MotionDecrementor
        move.w          #1,ACTMOTION          ; Actmotion = 1
        rts                                   ; Back !
LASTMOTION:
        neg.w           MOTIONDEC             ; Set MotionDecrementor
        subi.w          #1,ACTMOTION          ; DEC Actmotion
        rts                                   ; Back to Call !

* Routine gibt Replay-Zeichen aus
REPLAYOUT:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             REPLAYPORT(pc),a0     ; AnimTableBase -> a0
        bsr             ANIMATION             ; Animations-Logik
        moveq           #5,d0                 ; X = 5
        moveq           #5,d1                 ; Y = 5
        movea.l         PLANES+8(a6),a1       ; a1 = ZielBitmap = 3. Plane
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Maximale Hoehe -> d5
        move.w          #0,SCRPLANESC(a6)     ; Only one Plane !
        suba.l          a4,a4                 ; No Backgroundsaving !
        bsr             BOB                   ; Zeichne Bob !
        move.w          #BITPLANES-1,SCRPLANESC+SCRPORT ; Wieder alle Planes
        rts                                   ; Back !

* Routine gibt die Aussenlinien des Platzes aus
OUTLINES:
        move.w          #1,SCRPORT            ; Setze Farbe ( weiss )
        lea             OUTCOURT(pc),a0       ; CoordBase -> a0
        move.w          #COURTSIZE/2-4,d7     ; d7 = LoopCounter
        sub.w           #1,d7                 ; DEC LoopCounter
OUTLINELOOP:
        lea             LINKSX(pc),a1         ; LinksX -> a1
        move.w          (a0)+,(a1)+           ; Koords. eintragen
        move.w          (a0)+,(a1)+           ; Koords. eintragen
        addq.w          #2,a0                 ; INC Adr ( Z ueberspringen )
        move.w          (a0)+,(a1)+           ; Koords. eintragen
        move.w          (a0)+,(a1)+           ; Koords. eintragen
        addq.w          #2,a0                 ; INC Adr ( Z ueberspringen )

        movem.l         d7-a0,-(a7)           ; Save Regs on Stack !
        bsr             CLIPLINE              ; Zeichne Linie !
        movem.l         (a7)+,d7-a0           ; Get Regs from Stack !

        dbra            d7,OUTLINELOOP        ; -> Loop
        rts                                   ; Back

* Routine gibt Boden als Polygon aus
POLYGROUND:
        lea             MYXARRAY(pc),a0       ; X-Liste -> a0
        lea             MYYARRAY(pc),a1       ; Y-Liste -> a1
        bsr             GETGROUND             ; Trage BodenCoordinaten ein

        move.l          PLANES+4+SCRPORT,ACTPLANE ; Boden in 2. Bitplane

        bsr             POLYGON               ; Output !
        rts                                   ; Back

* Routine gibt Netz als Polygon aus
POLYNET:
        lea             MYXARRAY(pc),a0       ; X-Liste -> a0
        lea             MYYARRAY(pc),a1       ; Y-Liste -> a1
        bsr             GETNET                ; Trage NetzCoordinaten ein
        move.l          PLANES+8+SCRPORT,ACTPLANE ; Netz in 3. Bitplane
        bsr             POLYGON               ; Output !
        rts                                   ; Back

* Routine traegt Netz-Koordinaten in Buffer ein
GETNET:
        lea             OUTCOURT(pc),a2       ; OutCourtBase -> a2
        lea             NETOFFSET(a2),a2      ; NET-Offset addieren
SORTPOLY:
        movea.l         a0,a3                 ; a0 -> a3
        movea.l         a1,a4                 ; a1 -> a4

        move.w          30(a2),(a0)+          ; X eintragen
        move.w          32(a2),(a1)+          ; Y eintragen

        move.w          18(a2),(a0)+          ; X eintragen
        move.w          20(a2),(a1)+          ; Y eintragen

        move.w          6(a2),(a0)+           ; X eintragen
        move.w          8(a2),(a1)+           ; Y eintragen

        move.w          0(a2),(a0)+           ; X eintragen
        move.w          2(a2),(a1)+           ; Y eintragen
        movem.w         (a3),d0-d7            ; Hole alle Koordinaten !

SORTY:  sf              MERKER                ; Merker = FALSE

        cmp.w           d4,d5                 ; Vergleiche Werte
        bge.s           NOSWAP1               ; >= -> NoSwap1
        exg             d0,d1                 ; Swap Regs
        exg             d4,d5                 ; Swap Regs
        st              MERKER                ; Merker = TRUE
NOSWAP1:
        cmp.w           d5,d6                 ; Vergleiche Werte
        bge.s           NOSWAP2               ; >= -> NoSwap2
        exg             d1,d2                 ; Swap Regs
        exg             d5,d6                 ; Swap Regs
        st              MERKER                ; Merker = TRUE
NOSWAP2:
        cmp.w           d6,d7                 ; Vergleiche Werte
        bge.s           NOSWAP3               ; >= -> NoSwap3
        exg             d2,d3                 ; Swap Regs
        exg             d6,d7                 ; Swap Regs
        st              MERKER                ; Merker = TRUE
NOSWAP3:
        tst.b           MERKER                ; Ist Sortierung fertig ?
        bne.s           SORTY                 ; Nein -> SortY

        exg             d3,d2                 ; EXG X3 X4
        exg             d7,d6                 ; EXG Y3 Y4

        cmp.w           d7,d6                 ; Y3 = Y4 ?
        bne.s           SORTENDE              ; Nein -> SortEnde
        cmp.w           d0,d1                 ; X1 CMP X2
        blt             X1GREATER             ; X1 > -> X1Greater
        cmp.w           d2,d3                 ; X3 CMP X4
        blt.s           SORTENDE              ; X3 > X4 -> Sortende
        exg             d3,d2                 ; EXG X3 X4
        exg             d7,d6                 ; EXG Y3 Y4
        bra.s           SORTENDE              ; -> SortEnde
X1GREATER:
        cmp.w           d2,d3                 ; X3 CMP X4
        bgt.s           SORTENDE              ; X4 > X3 -> SortEnde
        exg             d3,d2                 ; EXG X3 X4
        exg             d7,d6                 ; EXG Y3 Y4
SORTENDE:
        movem.w         d0-d7,(a3)            ; Schreibe sortierte Werte zurueck
        movea.l         a3,a0                 ; a0 wieder zurueckschreiben
        movea.l         a4,a1                 ; a1 wieder zurueckschreiben
        rts                                   ; Back !

* Routine traegt Bodenkoordinaten in Buffer ein
GETGROUND:
        lea             OUTCOURT(pc),a2       ; OutCourtBase -> a2
        bra             SORTPOLY              ; Polygon-Koordinaten sortieren

MEMBACK:
        movea.l         4,a6                  ; ExecBase -> a6
        lea             MYMEMTABLE(pc),a5     ; MyMemTableBase -> a5
        move.w          MT_INPUTS(a5),d7      ; Anzahl der Eintraege -> d7
        subq.w          #1,d7                 ; DEC LoopCounter
        lea             MT_TABLE(a5),a5       ; Offset addieren

MEMBACKLOOP:
        move.l          (a5)+,d0              ; Laenge des Bereichs -> d0
        movea.l         (a5)+,a1              ; ADR des Bereichs -> a1

        movem.l         d7/a5,-(a7)           ; Save Reg on Stack !

        jsr             FREEMEM(a6)           ; Free It !

        movem.l         (a7)+,d7/a5           ; Get Reg from Stack !
        dbra            d7,MEMBACKLOOP        ; -> Loop

        rts                                   ; Back to Call !

OPENLIBS:
        movea.l         4,a6                  ; Execbase -> a6

        moveq           #0,d0                 ; No Version !
        lea             DOSNAME(pc),a1        ; DosNamePtr -> a1
        jsr             OPENLIBRARY(a6)       ; Open It !
        move.l          d0,DOSBASE            ; Lege Pointer ab !

        moveq           #0,d0                 ; No Version !
        lea             GFXNAME(pc),a1        ; GFXNamePtr -> a1
        jsr             OPENLIBRARY(a6)       ; Open It !
        move.l          d0,GFXBASE            ; Lege Pointer ab !

        rts                                   ; Back to Call !

CLOSELIBS:
        movea.l         4,a6                  ; Execbase -> a6

        movea.l         DOSBASE(pc),a1        ; DosBase -> a1
        jsr             CLOSELIBRARY(a6)      ; Close It!

        movea.l         GFXBASE(pc),a1        ; GFXBase -> a1
        jsr             CLOSELIBRARY(a6)      ; Close It !

        rts                                   ; Back to Call !

* Routine engagiert alte Copperliste
OLDDISPLAY:
        movea.l         GFXBASE(pc),a3
        lea             CUSTOM,a4
        move.l          38(a3),COP1LCH(a4)
        clr.w           COPJMP1(a4)
        move.w          #$8060,$00dff096
        rts

* Routine konvertiert Netzimagedaten in AmigaPlane-Format
MAKENET:
        movea.l         NETIMG,a0             ; NetimageBase -> a0
;        lea             NETBUF,a1             ; NetBuf -> a1
        lea             880(a1),a2            ; Next Plane !
        lea             880(a2),a3            ; Next Plane !
        lea             880(a3),a4            ; Next Plane !
        move.w          #439,d7               ; LoopCounter !
CONVLOOP:
        movem.w         (a0)+,d0-d3           ; Convert it !
        move.w          d0,(a1)+
        move.w          d1,(a2)+
        move.w          d2,(a3)+
        move.w          d3,(a4)+
        dbra            d7,CONVLOOP           ; -> Loop

        movea.l         a4,a1                 ; a3 ->a1
        move.w          #439,d7               ; LoopCounter
        bsr             CPUCOPY               ; Maske dranhaengen !

        move.l          #NETNAME,d1
        move.l          #1006,d2
        movea.l         DOSBASE(pc),a6
        jsr             OPEN(a6)
        move.l          d0,-(a7)
        move.l          d0,d1
;        move.l          #NETBUF,d2
        move.l          #4400,d3
        jsr             WRITE(a6)
        move.l          (a7)+,d1
        jsr             CLOSE(a6)
        rts

* Routine liest wichtige Daten von Disk in CHIP-Ram
GETDATAS:
        lea             ALLANIMS(pc),a0       ; AllAnims -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),d0         ; Base of Datas -> d0
        move.l          d0,WAITAPORT+AN_BASE  ; Base of Datas ->
        move.l          d0,SAWPORT+AN_BASE    ; Base of Datas ->
        move.l          d0,LNAPORT+AN_BASE    ; Base of Datas ->
        move.l          d0,LNWAPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,LNOAPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,LSAPORT+AN_BASE    ; Base of Datas ->
        move.l          d0,LSWAPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,LSOAPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,VORAPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,VORASPORT+AN_BASE  ; Base of Datas ->
        move.l          d0,RUEAPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,RUEASPORT+AN_BASE  ; Base of Datas ->
        move.l          d0,WAITBPORT+AN_BASE  ; Base of Datas ->
        move.l          d0,SBWPORT+AN_BASE    ; Base of Datas ->
        move.l          d0,LNBPORT+AN_BASE    ; Base of Datas ->
        move.l          d0,LNWBPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,LNOBPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,LSBPORT+AN_BASE    ; Base of Datas ->
        move.l          d0,LSWBPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,LSOBPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,VORBPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,VORBSPORT+AN_BASE  ; Base of Datas ->
        move.l          d0,RUEBPORT+AN_BASE   ; Base of Datas ->
        move.l          d0,RUEBSPORT+AN_BASE  ; Base of Datas ->

        lea             FXNAME(pc),a0         ; FXName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),FXBASE     ; Base of Datas -> FXBase

        lea             PLATTENAME(pc),a0     ; FileName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),PLATTEPTR  ; Base of Datas -> PlattePtr

        lea             PLATZNAME(pc),a0      ; FileName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),PLATZPTR   ; Base of Datas -> PlattePtr

        lea             SERVICENAME(pc),a0    ; ServiceName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),SERVEAPORT+AN_BASE ; Base of Datas ->
        move.l          MEMPTR(pc),TIPPAPORT+AN_BASE ; Base of Datas ->
        move.l          MEMPTR(pc),SERVEBPORT+AN_BASE ; Base of Datas ->
        move.l          MEMPTR(pc),TIPPBPORT+AN_BASE ; Base of Datas ->

        lea             ALLBALLNAME(pc),a0    ; AllBallName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),BALLGPTR   ; Base of Datas -> BallGPtr
        move.l          MEMPTR(pc),BALLSCRPORT+AN_BASE ; Base of Datas ->
        move.l          MEMPTR(pc),BENDPORT+AN_BASE ; Base of Datas ->

        lea             CHARGAMENAME(pc),a0   ; CharName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),d0         ; Base of Datas -> d0
        move.l          d0,CHARGAME           ; d0 -> Chargame
;-------------------------------------------------------------
        move.l          d0,TAUSTRANAME        ; d0 -> TAustraName
        move.l          d0,TFRANCENAME        ; d0 -> TFranceName
        move.l          d0,TENGLANDNAME       ; d0 -> TEnglandName
        move.l          d0,TUSANAME           ; d0 -> TUSAName
        move.l          d0,MACHINETXT         ; Setze Zeichensatz fuer MachM.
;-------------------------------------------------------------
        lea             CHARTABNAME(pc),a0    ; CharName -> a0
        bsr             POWERLOAD             ; PowerLoad
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.l          MEMPTR(pc),d0         ; Base of Datas -> d0
        move.l          d0,CHARTAB            ; d0 -> Chartab
;-------------------------------------------------------------
        move.l          d0,MAINMENUTXT        ; Setze Zeichensatz fuer MainM.
        move.l          d0,STORAGETXT         ; Setze Zeichensatz fuer StorM.
        move.l          d0,PRACTICETXT        ; Setze Zeichensatz fuer PracM.
        move.l          d0,TOURNTXT           ; Setze Zeichensatz fuer TourM.
        move.l          d0,CHARPTR(a6)        ; Als aktuellen Zeichens. eint.
;-------------------------------------------------------------

        move.l          #5000,d0              ; 4000 Bytes = BackGroundstack
        bsr             GETCHIPMEM            ; Hole ChipMem
        move.l          d0,BACKSTACKPT        ; Pointer ablegen
        move.l          d0,BACKSTACK          ; Pointer ablegen

        lea             NETNAME(pc),a0        ; FileName -> a0
        bsr             POWERLOAD             ; -> PowerLoad
        move.l          MEMPTR(pc),d0         ; MemPtr -> d0
        move.l          d0,NETIMG             ; NetImgBase ablegen
        add.l           #3520,d0              ; ADD MaskOffset
        move.l          d0,NETMSK             ; NetMskBase ablegen

        lea             REPLAYNAME(pc),a0     ; ReplayName -> a0
        bsr             POWERLOAD             ; PowerLoad
        move.l          MEMPTR(pc),REPLAYPORT+AN_BASE ; Base of Datas ->

        rts                                   ; Back

* Initialisiere RacketPort
FIRSTMANPORT:
        move.l          #WAITAPORT,ACTANIM    ; Init ActAnim !
        move.l          #WAITBPORT,ACTANIM1   ; Init ActAnim1 !
        move.w          #8,TDEL               ; BremsDelay ( SP 1 )setzen !
        move.w          #8,TDEL1              ; BremsDelay ( SP 2 )setzen !
        clr.l           LNAFLAG               ; Alle Flags ( SP 1 ) loeschen !
        clr.l           LNBFLAG               ; Alle Flags ( SP 2 ) loeschen !
        clr.l           OLDJFLAGS             ; JoyRec-Flags loeschen !
        lea             PL1PORT(pc),a5        ; PL1PortBase -> a5
        move.w          #0,P1_X(a5)           ; X init
        move.w          #288,P1_Y(a5)         ; Y init
        move.w          #NH,P1_Z(a5)          ; Z init
        lea             PL2PORT(pc),a5        ; PL2PortBase -> a5
        move.w          #0,P1_X(a5)           ; X init
        move.w          #-288,P1_Y(a5)        ; Y init
        move.w          #NH,P1_Z(a5)          ; Z init
        bsr             PLAYERDREID           ; -> PlayerDreid
        bra             PLAYER1DREID          ; -> Player1Dreid

* Initialisiere Ballmaschine
FIRSTMASCHINE:
        lea             MASCHINEPORT(pc),a3   ; MaschinePortBase -> a3
        move.w          #0,BM_POSX(a3)        ; X-Pos setzen
        move.w          #-300,BM_POSY(a3)     ; Y-Pos setzen
        clr.w           BM_COUNTER(a3)        ; Counter loeschen
        clr.w           BM_SHOOT(a3)          ; Shoots loeschen
        bsr             BALLMASCHINE          ; Init Maschine
        lea             BALLPORT(pc),a3       ; BallPort init
        move.w          #YMAX2,BS_YM2(a3)     ; YM2 setzen !
        st              BS_MASCH(a3)          ; Maschine aktiv !
        rts

* Routine initialisiert Ballmaschine mit zuf„lligem Program
INITPLAYMACHINE:
        bsr             RANDOM                ; Hole ZufallsZahl
        tst.w           d0                    ; RND-Number negativ ?
        bpl.s           RNDMNNEG              ; Nein -> RndMNeg
        neg.w           d0                    ; Make d0 pos !
RNDMNNEG:
        divs            #6800,d0              ; RND Number ( 0 - 5 )
        lea             MASCHINEPORT(pc),a0   ; MaschinePortBase -> a0
        lea             MENUPORT(pc),a1       ; MenuPortBase -> a1
        lea             PROGRAMTABLE(pc),a2   ; ProgramTableBase -> a2
        move.w          #3,d0                 ; Init !
        lsl.w           #2,d0                 ; * 4 fuer Tabellenzugriff
        move.l          0(a2,d0.w),BM_TABLE(a0) ; ADR of Program
        st              BS_MASCH+BALLPORT     ; Maschine = TRUE
        rts                                   ; Back !

* Routine initialisiert TippPort und ServicePort ( Aufschlag )
FIRSTSERVICE:
        movea.l         PP_MEGA+PLAYPORT,a5   ; MegaPortBase -> a5
        movea.l         MP_SERVE(a5),a3       ; ServePortBase -> a3
        clr.w           AN_CNT(a3)            ; Counter = 0
        clr.w           AN_DELCNT(a3)         ; DelayCounter = 0
        movea.l         MP_TIPP(a5),a3        ; TippPortBase -> a3
        clr.w           AN_CNT(a3)            ; Counter = 0
        move.w          #1,AN_DEC(a3)         ; DecInc = 1
        clr.w           AN_DELCNT(a3)         ; DelayCounter = 0
        clr.w           ACTBALLG              ; Loesche ActBallG
        clr.l           BS_HIT+BALLPORT       ; No HitFlag is set !
        st              NOTPL1                ; NotPl1 = TRUE
        st              NOTPL2                ; NotPl2 = TRUE
        sf              BS_NEW+BALLPORT       ; Neue Parameter sind verlangt !
        move.b          #BALLTIP,BS_TYPE+BALLPORT ; BallMoveType setzen !
        rts                                   ; Back !

* Routine setzt Standard-Aus-Grenzen, wenn Spieler 1 am Schlag
STDBOUNDP1:
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.w          #-3*F,BS_BX1(a5)      ; Set X1
        move.w          #-6*F,BS_BY1(a5)      ; Set Y1
        move.w          #3*F,BS_BX2(a5)       ; Set X2
        move.w          #0,BS_BY2(a5)         ; Set Y2
        rts                                   ; Back !

* Routine setzt Standard-Aus-Grenzen, wenn Spieler 2 am Schlag
STDBOUNDP2:
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.w          #-3*F,BS_BX1(a5)      ; Set X1
        move.w          #0,BS_BY1(a5)         ; Set Y1
        move.w          #3*F,BS_BX2(a5)       ; Set X2
        move.w          #6*F,BS_BY2(a5)       ; Set Y2
        rts                                   ; Back !

* Routine initialisiert wichtige Daten fuer 3D-Replay
INITREPDAT:
        move.w          #1,MOTIONDEC          ; MotionDecrementor = +1
        clr.w           ACTMOTION             ; ActMotion = 0

        lea             RECBUF,a0             ; RecBufBase -> a0
        adda.w          -2(a0),a0             ; ADD BufferPointer
        move.l          #$ffffffff,(a0)       ; Setze EndeKennung !

        move.l          BACKSTACK,BACKSTACKPT ; Clear BackStack
        clr.w           OBJNUM                ; ObjNum = 0

        rts                                   ; Back !

* Routine initialisiert Balldaten
INITBALLDAT:
        clr.w           ACTBALLG              ; ActBallG = 0
        lea             BALLPORT(pc),a0       ; BallPortBase -> a0
        move.w          #BS_SIZEOF/2-1,d7     ; Init Loopcounter !
INITBDLOOP:
        move.w          #0,(a0)+              ; Clear It !
        dbra            d7,INITBDLOOP         ; -> Loop
        rts                                   ; Back

* Routine verwaltet die Ballmaschine
BALLMASCHINE:
        bsr             STDBOUNDP2            ; Setze Aus-Grenzen ( Spieler 2 )
;        bsr             SUCCESOUT             ; Statistik-Ausgabe !
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             MASCHINEPORT(pc),a3   ; MaschinePortBase -> a3
        movea.l         BM_TABLE(a3),a0       ; Adresse der Tabelle -> a0
        move.w          BM_COUNTER(a3),d0     ; Counter -> d0
        move.w          d0,d1                 ; Counter -> d1
        lsl.w           #2,d0                 ; Mal Groesse eines Eintrags
        tst.l           0(a0,d0.w)            ; Ende der Tabelle ?
        bpl.s           NOTTHEEND             ; Nein -> NottheEnd
        moveq           #0,d0                 ; Counter auf 0
        moveq           #0,d1                 ; Counter = -1
NOTTHEEND:
        movea.l         0(a0,d0.w),a0         ; Zeiger auf Schlag holen
        move.w          (a0)+,BS_ZM1(a5)      ; BS_ZM1 eintragen
        move.w          (a0)+,BS_ZM2(a5)      ; BS_ZM2 eintragen
        move.w          (a0)+,BS_YM1(a5)      ; BS_YM1 eintragen
        move.w          (a0)+,BS_YM2(a5)      ; BS_YM2 eintragen
        move.w          (a0)+,BS_WIN(a5)      ; BS_WIN eintragen
        move.w          (a0)+,BS_SP(a5)       ; BS_SP eintragen
        move.w          BM_POSX(a3),BS_DX(a5) ; BS_DX  eintragen
        move.w          BM_POSX(a3),BS_X(a5)  ; BS_X  eintragen
        move.w          BM_POSY(a3),BS_Y(a5)  ; BS_Y   eintragen
        move.w          #NH,BS_Z(a5)          ; BS_Z = NetzHoehe

        addq.w          #1,BM_SHOOT(a3)       ; INC Anzahl der abgeschossenen B.
        addq.w          #1,d1                 ; INC Counter
        move.w          d1,BM_COUNTER(a3)     ; Counter ablegen
        sf              BS_WHO(a5)            ; Setze SchlaegerFlag auf Gegner
        rts

* Routine gibt Statistik bei Ballmaschine aus
SUCCESOUT:
;        moveq           #122,d0               ; Set X1
;        moveq           #6,d1                 ; Set Y1
;        move.w          #197,d2               ; Set X2
;        moveq           #25,d3                ; Set Y2
        move.w          #8,COLOR+SCRPORT      ; Set Color
;        bsr             FILLBOX               ; -> Box

;        move.w          BM_SHOOT+MASCHINEPORT,d4 ; Anzahl der gesch. -> d4
        move.b          BS_TYPE+BALLPORT,d4
        ext.w           d4
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #124,X_1(a6)          ; X-Koordinate -> d0
        move.w          #8,Y_1(a6)            ; Y-Koordinate -> d1
        bsr             MAKESTAT              ; -> Ausgabe der Statistik
        rts
        move.w          BS_X+BALLPORT,d4      ; Anzahl der gesch. -> d4
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        addq.w          #6,X_1+SCRPORT        ; X-Koordinate addieren
        bsr             MAKESTAT              ; -> Ausgabe der Statistik

        addq.w          #6,X_1+SCRPORT        ; X-Koordinate addieren

        move.w          BS_OK+BALLPORT,d4     ; Anzahl der gesch. -> d4
        mulu            #100,d4               ; * 100
        move.w          BM_SHOOT+MASCHINEPORT,d3 ; Anzahl der gesch. -> d3
        bne.s           MAKEPERCENT           ; <> 0 -> MakePercent
        moveq           #0,d4                 ; d4 = 0 %
        bra             MAKESTAT              ; -> Percent
MAKEPERCENT:
        divs            d3,d4                 ; d4 = Statistik in Prozent
MAKESTAT:
        ext.l           d4                    ; LangwortErweitern
        bsr             DECUMRECHNUNG         ; BIN->DEC-Umrechnung
        move.w          #14,COLOR(a6)         ; Color setzen
        lea             OUBUFFER(pc),a3       ; StringBase -> a3
        bsr             STRINGOUT             ; Gebe String aus !
        rts                                   ; Back !

* Initialisiere Tastaturirq Level 2
INITTAST:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$0008,INTENA(a4)     ; Sperre IRQ 2
        move.l          $00000068,MYTASTEND   ; Alten IRQ 2 ans Ende meines IRQ
        move.l          #MYTAST,$00000068     ; Eigenen IRQ einhaengen
        move.w          #$c008,INTENA(a4)     ; IRQ 2 erlauben
        rts                                   ; Back to Call !

* Alten IRQ 2 wieder installieren
REMTAST:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$0008,INTENA(a4)     ; Sperre IRQ 2
        move.l          MYTASTEND(pc),$00000068 ; Alten IRQ einhaengen
        move.w          #$8008,INTENA(a4)     ; IRQ 2 erlauben
        rts                                   ; Back to Call !

* Initialisiere VBL-IRQ Level 3
INITSTICK:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$4010,INTENA(a4)     ; Sperre IRQ 3
        move.l          $0000006c,MYSTICKEND  ; Alten IRQ 3 ans Ende meines IRQ
        move.l          #MYSTICK,$0000006c    ; Eigenen IRQ einhaengen
        move.w          #$c010,INTENA(a4)     ; IRQ 3 erlauben
        move.w          INTENAR+CUSTOM,SAVINT ; Save Intena !
        ori.w           #$c000,SAVINT         ; Make Set !
        rts                                   ; Back to Call !

* Alten IRQ 3 wieder installieren
REMSTICK:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$0010,INTENA(a4)     ; Sperre IRQ 3
        move.l          MYSTICKEND(pc),$0000006c ; Alten IRQ einhaengen
        move.w          #$c010,INTENA(a4)     ;  IRQ 3 erlauben
        rts                                   ; Back to Call !

* Initialisiere AUDIO-IRQ Level 4
INITAUDIO:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$4780,INTENA(a4)     ; Sperre IRQ 4
        move.l          $00000070,MYAUDIOEND  ; Alten IRQ 4 ans Ende meines IRQ
        move.l          #MYAUDIO,$00000070    ; Eigenen IRQ einhaengen
        move.w          #$c000,INTENA(a4)     ; IRQ 4 erlauben
        rts                                   ; Back to Call !

* Alten IRQ 4 wieder installieren
REMAUDIO:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$0780,INTENA(a4)     ; Sperre IRQ 4
        move.l          MYAUDIOEND(pc),$00000070 ; Alten IRQ einhaengen
        move.w          #$000f,DMACON(a4)     ; No Audio-DMA !
        move.w          #$c000,INTENA(a4)     ; IRQ 4 erlauben
        rts                                   ; Back to Call !

* Routine schaltet alle Interrupts mit Ausnhame des VBL's aus
ONLYIRQ:
        movem.l         d0/a0,-(a7)           ; Save Regs on Stack !
        bsr             WAITBEAM              ; Warte auf Strahl !
        move.w          INTENAR+CUSTOM,SAVINT ; Save Intena !
        ori.w           #$c000,SAVINT         ; Make Set !
        move.w          #$1fef,INTENA+CUSTOM  ; Set INTENA ( Only COP )
        move.l          #MYSTICK,$0000006c    ; Set MYIRQ
        movea.l         COPPTR+SCRPORT,a0     ; Get CopperPtr -> a0
        adda.w          #COPEFF1OFF,a0        ; Offset addieren !
        move.l          #$5011fffe,-20(a0)    ; No CopperIRQ !
        movem.l         (a7)+,d0/a0           ; Get Regs from Stack !
        rts                                   ; Back

* Routine schaltet Interrupts des Systems wieder ein
ALLIRQ:
        movem.l         d0/a0,-(a7)           ; Save Regs on Stack !
        bsr             WAITBEAM              ; Warte auf Strahl !
        movea.l         COPPTR+SCRPORT,a0     ; Get CopperPtr -> a0
        adda.w          #COPEFF1OFF,a0        ; Offset addieren !
        move.l          #$fffffffe,-20(a0)    ; No CopperIRQ !
        move.l          MYSTICKEND(pc),$0000006c ; -> Alten Interrupt !
        move.w          SAVINT(pc),INTENA+CUSTOM ; Write Intena
        move.w          #$c050,INTENA+CUSTOM  ; Blitter ausdruecklich !
        movem.l         (a7)+,d0/a0           ; Get Regs from Stack !
        rts                                   ; Back !

TASKOFF:
        movem.l         FULLSET,-(a7)         ; Save Regs on Stack
        movea.l         4,a6                  ; ExecBase -> a6
        jsr             FORBID(a6)            ; Forbid
;        jsr             DISABLE(a6)           ; Disable
        movem.l         (a7)+,FULLSET         ; Get Regs from Stack
        rts                                   ; Back to Call !

TASKON:
        movem.l         FULLSET,-(a7)         ; Save Regs on Stack
        movea.l         4,a6                  ; ExecBase -> a6
        jsr             PERMIT(a6)            ; Permit
;        jsr             ENABLE(a6)            ; Enable
        movem.l         (a7)+,FULLSET         ; Get Regs from Stack
        rts                                   ; Back to Call !

* Schreibe Farbwerte in Hardware
MAKEMYCOL:
        lea             ZEROTABLE(pc),a0      ; ColorTableBase -> a0
        lea             COLOR00+CUSTOM,a1     ; COLOR00Base -> a1
        move.w          #31,d7                ; Init LoopCounter
        bsr             CPUCOPY               ; Copiere Daten

        rts

* Routine entfernt alle Sprites aus Liste
REMSPRITES:
        bsr             WAITBEAM              ; Warte auf Strahl !
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.l          NULLSPRITE(pc),d1     ; NullSpriteBase -> d1
        movea.l         COPPTR(a6),a0         ; CopperListAdr -> a0
        lea             COPPERSPROFF+6(a0),a0 ; Beginn der SpriteDaten der Liste
        moveq           #7,d7                 ; Init LoopCounter
REMSPRLOOP:
        move.w          d1,(a0)               ; Trage unteres Word in Clist
        swap            d1                    ; Swap it !
        move.w          d1,-4(a0)             ; Trage oberes Word in Clist
        swap            d1                    ; ReSwap it !
        addq.w          #8,a0                 ; Auf naechsten Eintrag !
        dbra            d7,REMSPRLOOP         ; -> Loop
        rts                                   ; Back to Call !

* Routine traegt Adressen in SpriteTabelle ein
* Input:
*       d0  = Zeiger auf Sprite
MAKESPRTABLE:
        lea             SPRTABLE(pc),a0       ; SpriteTableBase -> a0
        move.w          ST_USE(a0),d2         ; Used_Flags -> d2
        move.w          d2,d3                 ; Used_Flags -> d3
        moveq           #0,d7                 ; Clear LoopCounter
TABLELOOP:
        lsr.w           #1,d2                 ; >> d2
        bcc.s           GOTSPR                ; C clear -> GotSpr
        addq.w          #1,d7                 ; INC LoopCounter
        cmp.w           #8,d7                 ; > MaxSprites
        blt.s           TABLELOOP             ; Nein -> Loop
        moveq           #-1,d0                ; FailedFlag setzen
        rts                                   ; Back to Call !
GOTSPR:
        bset            d7,d3                 ; Sprite belegt
        move.w          d3,ST_USE(a0)         ; Used_Flags ablegen
        lsl.w           #2,d7                 ; * 4 da Langwoerter
        lea             ST_TAB(a0,d7.w),a0    ; Gefundenen Offset addieren
        move.l          d0,(a0)               ; Pointer ablegen
        rts

* Joystickabfrage und Ballbewegung ( IRQ Level 3 von Copper ausgeloest )
MYSTICK:
;        move.w          #YELLOW,$00dff180
        movem.l         FULLSET,-(a7)         ; Save Regs on Stack
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          INTREQR(a4),d0        ; INTREQR -> d0
        btst            #4,d0                 ; Is VBL-IRQ
        beq             MYSTICKENDE           ; Nein -> Ende
        move.w          #$4010,INTENA(a4)     ; Keine weiteren IRQ's
WAITPA:
        btst            #6,CIAAPRA
        bne.s           NOPAUSE
        btst            #10,$00dff016
        bne.s           NOPAUSE
        bra.s           WAITPA
NOPAUSE:
        addq.w          #1,GLDELAY            ; INC Receive-CNT

        move.l          COPSLOT(pc),d0        ; SlotAddress -> d0
        beq.s           NOSLOT                ; = 0 -> Ende
        movea.l         d0,a0                 ; Adresse -> a0
        jsr             (a0)                  ; Fuehre Slot aus !
NOSLOT:
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          #$0010,INTREQ(a4)     ; No Longer IRQ !
        move.w          #$c010,INTENA(a4)     ; IRQ erlauben !
MYSTICKENDE:
        movem.l         (a7)+,FULLSET         ; Get Regs from Stack !
;        move.w          #BLACK,$00dff180
                DC.W $4ef9              ; JMP-Opcode
MYSTICKEND:     DC.L 0

GLDELAY:        DC.W 0
HUMANFL:        DC.W 0                  ; Flag ob Mensch oder Computer

* Sammlung der UnterRoutinen die im VBL laufen muessen fuer 3D-Replay
COPSET1:
        bsr             REPLAYBALL            ; Bewege Ball !
        bsr             BALLDREID             ; Errechne 3D-Perspektive
        bsr             COLORCHOOSE           ; Waehle richtige Palette fuer 3D
        rts                                   ; Back !

* Sammlung der UnterRoutinen die im VBL laufen muessen fuer MenuAuswahl
COPSET2:
        bsr             STICKFLAGS            ; Frage RawJoystick ab !
        rts                                   ; Back !

* Sammlung der UnterRoutinen die im VBL laufen muessen fuer BallMaschine
COPSET3:
        bsr             STICKANDBALL          ; Kollisionstest
        bsr             STICKFLAGS            ; Setze Flags der Bewegung (SP 1)
        bsr             MOVING                ; Bewege Spieler 1
        bsr             PLAYERDREID           ; Spieler 1 3D errechnen !
        bsr             BALLMOVE              ; Bewege Ball !
        bsr             BALLDREID             ; Errechne 3D-Perspektive
        bsr             DRAWBALLS1            ; Zeichne Ball und Schatten !
        bsr             WHICHANIMPORT         ; Waehle Animation aus !
        bsr             MAKESOUND             ; Sound !
        rts                                   ; Back !

* Sammlung der Unterroutinen die im VBL laufen muessen fuer Spiel
COPSETPLAY:
        bsr             STICKANDBALL          ; Kollisionstest ( Spieler 1 )
        bsr             STICK1ANDBALL         ; Kollisionstest ( Spieler 2 )
        bsr             STICK                 ; Frage Joystick ab !
        bsr             BALLMOVE              ; Bewege Ball !
        bsr             BALLDREID             ; Errechne 3D-Perspektive
        bsr             DRAWBALLS1            ; Zeichne Ball und Schatten !
        bsr             WHICHANIMPORT         ; Waehle Animation aus !
        bsr             WHICH1ANIMPORT        ; Waehle Animation aus !
        bsr             RECBALL               ; Receive Ball-Motion ( Replay )
        bsr             MAKEREFS              ; Referees steuern !
        bsr             MAKESOUND             ; Sound !
        rts                                   ; Back !

* Sammlung der Unterroutinen die im VBL laufen muessen fuer Spiel
COPSETSERVE:
        bsr             STICKFLAGS            ; Frage Joystick ab ( Bewegung )!
        bsr             BALLMOVE              ; Bewege Ball !
        bsr             BALLDREID             ; Errechne 3D-Perspektive
        bsr             DRAWBALLS1            ; Zeichne Ball und Schatten !
        bsr             MAKESOUND             ; Sound !
        rts                                   ; Back !

                IFD  INTROSET
* Sammlung der UnterRoutinen die im VBL laufen muessen fuer Intro
COPSET4:
        bsr             STICKFLAGS            ; Frage RawJoystick ab !
        bsr             MAKESONG              ; Spiele Sound !
        rts                                   ; Back !
                ENDC

* Routine kopiert richtige FarbPalette ( Verdeckung ) in Register
COLORCHOOSE:
        lea             BALLPORT(pc),a6       ; BallPortBase -> a6
        lea             OUTCOURT(pc),a5       ; 3D-Output-Base -> a5
        lea             NETOFFSET(a5),a5      ; Offset auf Netz addieren !
        moveq           #0,d7                 ; Loesche d7
        move.w          BS_ZZ(a6),d0          ; Z-Koordinate Ball -> d0
        move.w          BS_ZZZ(a6),d1         ; Z-Koordinate Schatten -> d1
        move.w          4(a5),d2              ; Z-Koordinate Netz -> d2
        add.w           10(a5),d2             ; Addiere Z-Koordinate ( Netz )
        add.w           22(a5),d2             ; Addiere Z-Koordinate ( Netz )
        add.w           34(a5),d2             ; Addiere Z-Koordinate ( Netz )
        asr.w           #2,d2                 ; Mittleres Z
        cmp.w           d2,d0                 ; CMP Ball hinter Netz
        bgt.s           BALLNOTNET            ; Nein -> BallnotNet
        bset            #1,d7                 ; Setze Bit
BALLNOTNET:
        cmp.w           d2,d1                 ; CMP Schatten hinter Netz
        bgt.s           SHADOWNOTNET          ; Nein -> ShadownotNet
        bset            #0,d7                 ; Setze Bit
SHADOWNOTNET:
        lsl.w           #2,d7                 ; * 4 fuer Langwortzugriff
        lea             TABLECHOOSE(pc),a6    ; TabellenPointer -> a6
        movea.l         0(a6,d7.w),a6         ; a6 ist Base of ColorTable
        lea             CUSTOM+COLOR00,a5     ; Base of ColorRegs -> a5
        movea.l         a6,a0                 ; ColorTableBase -> a0
        lea             ACTCOLTABLE(pc),a1    ; ActColTable -> a1
        moveq           #31,d7                ; LoopCounter
        bsr             CPUCOPY               ; -> CpuCopy !
        movem.l         (a6)+,d0-a4           ; Get ColorValues -> d0 - a4
        movem.l         d0-a4,(a5)            ; Put it in ColorRegs
        lea             52(a5),a5             ; ADD Offset
        movem.l         (a6),d0-d2            ; Get next Values !
        movem.l         d0-d2,(a5)            ; Put it in ColorRegs
        rts

* Routine testet Kollision zwischen Schlaeger und Ball ( Spieler 1 )!
STICKANDBALL:
        lea             JOYPORT(pc),a2        ; JoyStickPortBase -> a2
        lea             BALLPORT(pc),a3       ; BallPortBase -> a3
        lea             PL1PORT(pc),a5        ; PL1Port -> a5

        tst.b           BS_HIT+BALLPORT       ; Ist Spieler am Schlag ?
        beq             NOSTICKANDBALL        ; Nein -> Ende

        tst.w           BS_DE(a3)
        bmi             NOSTICKANDBALL
        movem.w         BS_X(a3),d0-d2        ; Koordinaten des Balls ->d0 - d2
        movem.w         P1_X(a5),d3-d5        ; Koordinaten des Racks ->d3 - d5
        tst.b           BS_FORE+BALLPORT      ; Welcher Schlag ?
        bne.s           ITSBACKHAND           ; TRUE -> ItsBackHand
        add.w           #28,d3                ; ADD P1_X,20
        bra.s           STICKANDB             ; -> StickAndB
ITSBACKHAND:
        sub.w           #22,d3                ; ADD P1_X,20
STICKANDB:
        sub.w           d3,d0                 ; Bilde DeltaX
        sub.w           d4,d1                 ; Bilde DeltaY
        sub.w           d5,d2                 ; Bilde DeltaZ

        move.w          d1,d3                 ; DeltaY -> d3
        bpl.s           DYNOTNEG              ; ABS(DeltaY)
        neg.w           d3                    ; Negate it !
DYNOTNEG:
        move.w          d2,d4                 ; DeltaZ -> d4
        bpl.s           DZNOTNEG              ; ABS(DeltaZ)
        neg.w           d4                    ; Negate it !
DZNOTNEG:
        cmp.w           #-XV,d0               ; Ist Delta X im ToleranzBereich
        blt             NOSTICKANDBALL        ; Nein -> Ende
        cmp.w           #XV,d0                ; Ist Delta X im ToleranzBereich
        bgt             NOSTICKANDBALL        ; Nein -> Ende

        cmp.w           #-YV,d1               ; Ist Delta Y im ToleranzBereich
        blt             NOSTICKANDBALL        ; Nein -> Ende
        cmp.w           #YV,d1                ; Ist Delta Y im ToleranzBereich
        bgt             NOSTICKANDBALL        ; Nein -> Ende

        cmp.w           #-ZV,d2               ; Ist Delta Z im ToleranzBereich
        blt             NOSTICKANDBALL        ; Nein -> Ende
        cmp.w           #ZV,d2                ; Ist Delta Z im ToleranzBereich
        bgt             NOSTICKANDBALL        ; Nein -> Ende

        add.w           d0,d0                 ; DeltaX * 2 fuer Wortzugriff
        add.w           d1,d1                 ; DeltaY * 2 fuer Wortzugriff
        add.w           d2,d2                 ; DelatZ * 2 fuer Wortzugriff

        lea             MIDDLEX(pc),a0        ; MiddleXBase -> a0
        move.w          0(a0,d0.w),BS_WIN(a3) ; Winkel eintragen

        lea             MIDDLEY(pc),a0        ; MiddleYBase -> a0
        move.w          0(a0,d1.w),BS_YM1(a3) ; BS_YM1 eintragen
        neg.w           BS_YM1(a3)            ; NEG BS_YM1

;        lea             MIDDLEY1(pc),a0       ; MiddleY1Base -> a0
;        move.w          0(a0,d1.w),BS_YM2(a3) ; BS_YM2 eintragen

        lea             MIDDLEZ(pc),a0        ; MiddleZBase -> a0
        move.w          0(a0,d2.w),BS_ZM1(a3) ; BS_ZM1 eintragen

        lea             MIDDLEZ1(pc),a0       ; MiddleZ1Base -> a0
        move.w          0(a0,d2.w),BS_ZM2(a3) ; BS_ZM2 eintragen

        lea             SPEEDTABLE(pc),a0     ; SpeedTableBase -> a0
        lsl.w           #4,d3                 ; DeltaY * 16 = Laenge eines Speed

        add.w           d3,d4                 ; ADD Offsets
        move.b          0(a0,d4.w),d0         ; BS_SP holen
        ext.w           d0                    ; Wort erweitern !
        move.w          d0,BS_SP(a3)          ; BS_SP eintragen

        cmpi.w          #NETFLY,BS_Y(a3)      ; Naehe Netz ?
        bgt.s           NODOUBLE              ; Nein -> NoDouble
        addi.w          #2,BS_SP(a3)
NODOUBLE:
        addq.w          #1,BS_OK(a3)          ; INC BS_OK
        sf              BS_SERVE(a3)          ; No-Service-in-Progress !
        st              BS_WHO(a3)            ; Setze SchlaegerFlag auf Player
        sf              BS_NEW(a3)            ; Neue Bewegung fuer Ball
        move.w          BS_X(a3),BS_DX(a3)    ; Set DX !
        move.b          #BALLFLY,BS_TYPE(a3)  ; Set BallMoveType !
        bsr             STDBOUNDP1            ; Setze Aus-Grenzen ( Spieler 1 )
        move.w          #HITFX,FXNUM          ; FX Hit -> FXNum
NOSTICKANDBALL:
        rts

* Routine testet Kollision zwischen Schlaeger und Ball ( Spieler 2 )!
STICK1ANDBALL:
        lea             JOY1PORT(pc),a2       ; JoyStickPortBase -> a2
        lea             BALLPORT(pc),a3       ; BallPortBase -> a3
        lea             PL2PORT(pc),a5        ; PL2Port -> a5

        tst.b           BS_HIT1+BALLPORT      ; Ist Spieler am Schlag ?
        beq             NOSTICKANDBALL        ; Nein -> Ende

        tst.w           BS_DE(a3)             ; DoppelBerhrung !
        bpl             NOSTICKANDBALL        ; Ja -> Ende

        movem.w         BS_X(a3),d0-d2        ; Koordinaten des Balls ->d0 - d2
        movem.w         P1_X(a5),d3-d5        ; Koordinaten des Racks ->d3 - d5

        tst.b           BS_FORE1+BALLPORT     ; Welcher Schlag ?
        bne.s           ITSBACKHAND1          ; TRUE -> ItsBackHand1
        sub.w           #28,d3                ; ADD P1_X,20
        bra.s           STICKANDB1            ; -> StickAndB1
ITSBACKHAND1:
        add.w           #22,d3                ; ADD P1_X,20
STICKANDB1:
        sub.w           d3,d0                 ; Bilde DeltaX
        sub.w           d4,d1                 ; Bilde DeltaY
        sub.w           d5,d2                 ; Bilde DeltaZ

        move.w          d1,d3                 ; DeltaY -> d3
        bpl.s           DYNOTNEG1             ; ABS(DeltaY)
        neg.w           d3                    ; Negate it !
DYNOTNEG1:
        move.w          d2,d4                 ; DeltaZ -> d4
        bpl.s           DZNOTNEG1             ; ABS(DeltaZ)
        neg.w           d4                    ; Negate it !
DZNOTNEG1:
        cmp.w           #-XV,d0               ; Ist Delta X im ToleranzBereich
        blt             NOSTICKANDBALL        ; Nein -> Ende
        cmp.w           #XV,d0                ; Ist Delta X im ToleranzBereich
        bgt             NOSTICKANDBALL        ; Nein -> Ende

        cmp.w           #-YV,d1               ; Ist Delta Y im ToleranzBereich
        blt             NOSTICKANDBALL        ; Nein -> Ende
        cmp.w           #YV,d1                ; Ist Delta Y im ToleranzBereich
        bgt             NOSTICKANDBALL        ; Nein -> Ende

        cmp.w           #-ZV,d2               ; Ist Delta Z im ToleranzBereich
        blt             NOSTICKANDBALL        ; Nein -> Ende
        cmp.w           #ZV,d2                ; Ist Delta Z im ToleranzBereich
        bgt             NOSTICKANDBALL        ; Nein -> Ende

        add.w           d0,d0                 ; DeltaX * 2 fuer Wortzugriff
        add.w           d1,d1                 ; DeltaY * 2 fuer Wortzugriff
        add.w           d2,d2                 ; DelatZ * 2 fuer Wortzugriff

        lea             MIDDLEX(pc),a0        ; MiddleXBase -> a0
        move.w          0(a0,d0.w),BS_WIN(a3) ; Winkel eintragen

        lea             MIDDLEY(pc),a0        ; MiddleYBase -> a0
        move.w          0(a0,d1.w),BS_YM1(a3) ; BS_YM1 eintragen
        subi.w          #36,BS_YM1(a3)        ; DEC BS_YM1

        lea             MIDDLEZ(pc),a0        ; MiddleZBase -> a0
        move.w          0(a0,d2.w),BS_ZM1(a3) ; BS_ZM1 eintragen

        lea             MIDDLEZ1(pc),a0       ; MiddleZ1Base -> a0
        move.w          0(a0,d2.w),BS_ZM2(a3) ; BS_ZM2 eintragen


        lea             SPEEDTABLE(pc),a0     ; SpeedTableBase -> a0

        lsl.w           #4,d3                 ; DeltaY * 16 = Laenge eines Speed

        add.w           d3,d4                 ; ADD Offsets
        move.b          0(a0,d4.w),d0         ; BS_SP holen
        ext.w           d0                    ; Wort erweitern !
        move.w          d0,BS_SP(a3)          ; BS_SP eintragen

        cmpi.w          #-NETFLY,BS_Y(a3)     ; Naehe Netz ?
        blt.s           NODOUBLE1             ; Nein -> NoDouble1
        addi.w          #2,BS_SP(a3)
        subi.w          #60,BS_YM1(a3)        ; DEC BS_YM1
NODOUBLE1:
        sf              BS_SERVE(a3)          ; No-Service-in-Progress !
        sf              BS_WHO(a3)            ; Setze SchlaegerFlag auf Player2
        sf              BS_NEW(a3)            ; Neue Bewegung fuer Ball
        move.w          BS_X(a3),BS_DX(a3)    ; Set DX !
        move.w          BS_Y(a3),YSAVE        ; Y-Coord des Schlags sichern !
        move.b          #BALLFLY,BS_TYPE(a3)  ; Set BallMoveType !
        bsr             STDBOUNDP2            ; Setze Aus-Grenzen ( Spieler 2 )
        move.w          #HITFX,FXNUM          ; FX Hit -> FXNum
        rts                                   ; Back !

* Routine bewegt Ball nach Parabel- und Geraden-Funktionen ( Verteiler )
* RegisterUse:
*       d4 = BS_Y
*       d5 = BS_FF
*       d6 = BS_NEI
*       d7 = BS_ZM1
*
*       a5 = BallPortBase
BALLMOVE:
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             MOVETAB(pc),a0        ; MoveTabBase -> a0
        move.b          BS_TYPE(a5),d0        ; Type of Move -> d0
        ext.w           d0                    ; Wort erweitern
        asl.w           #3,d0                 ; * 8 fuer Tabellen-Zugriff
        lea             0(a0,d0.w),a0         ; Offset addieren
        movea.l         (a0)+,a1              ; BewegungsRoutAdr -> a1
        movea.l         (a0),a2               ; NewParaRoutAdr -> a2
        tst.b           BS_NEW(a5)            ; New Paras ?
        bne.s           NONEWPARAS            ; Nein -> NoNewParas
        st              BS_NEW(a5)            ; NewPara = TRUE
        move.l          a1,-(a7)              ; Save Reg on Stack !
        jsr             (a2)                  ; Hole neue Parameter !
        movea.l         (a7)+,a1              ; Get Reg from Stack !
NONEWPARAS:
        jmp             (a1)                  ; Regle BallBewegung

NEWFLY:
;        move.w          BS_X(a5),BS_DX(a5)    ; Setze DX
        bsr             NEWPARAS              ; -> NewParas
        bra             GETPARAB              ; -> GetParab

BALLMOVE1:
        bsr             GETINREGS             ; Hole Werte in Register
        bsr             GETX                  ; Errechne BS_X und lege ab
        bsr             GETZ                  ; Errechne BS_Z und lege ab
        bsr             KOLLTEST              ; Abbruch ?
        rts                                   ; Back to Call !

* Routine bewegt Ball beim Springen
BALLMOVE2:
        bsr             GETINREGS1            ; Hole Werte in Register !
        bsr             GETX                  ; Errechne BS_X und lege ab
        bsr             GETZ                  ; Errechne BS_Z und lege ab
        bra             KOLLTEST1             ; Abbruch ?

* Routine setzt Parameter neu fuer Tippen
NEWTIPP:
        clr.w           TIPPPOS               ; Loesche TippPos
        clr.w           TIPPDEL               ; Loesche TippDelay
        move.w          BSERVEX(pc),SERVETABX ; Set X
        move.w          #90,SERVETABW         ; Setze Winkel !
        rts                                   ; Back !

* Routine regelt Bewegung des Balles beim Tippen ( Service )
BALLMOVE3:
        lea             TIPPTAB(pc),a0        ; Tabelle der Z-Koordinaten -> a0
        move.w          TIPPPOS(pc),d0        ; ServePos -> d0
        move.w          0(a0,d0.w),BS_Z(a5)   ; Z-Koordinate -> BallPort !
        move.w          BSERVEX(pc),BS_X(a5)  ; X-Koordinate -> BallPort !
        move.w          BSERVEY(pc),BS_Y(a5)  ; y-Koordinate -> BallPort !
        addq.w          #1,TIPPDEL            ; INC Delay !
        cmpi.w          #5,TIPPDEL            ; Delay erfuellt ?
        ble             RETURN                ; Nein -> Ende !
        clr.w           TIPPDEL               ; Delay = 0
        move.w          TIPPDEC(pc),d0        ; Get INC or DEC
        add.w           d0,TIPPPOS            ; INC or DEC Position
        bmi.s           BUMPTUP               ; NEG -> BumpTUp
        cmpi.w          #6,TIPPPOS            ; Ende ?
        ble             RETURN                ; Nein -> Ende
        move.w          #4,TIPPPOS            ; TippPos = 6
        neg.w           TIPPDEC               ; TOOGLE TipDec !
        rts                                   ; Back !
BUMPTUP:
        move.w          #2,TIPPPOS            ; TippPos = 2
        neg.w           TIPPDEC               ; TOOGLE TipDec !
        rts                                   ; Back !

* Routine setzt Parameter neu wenn Ball geworfen
NEWTHROW:
        clr.w           SERVEPOS              ; Loesche ServicePos
        clr.w           WXDEL1                ; Loesche FadenKreuz-Bew-Del
        clr.w           WXDEL2                ; Loesche FadenKreuz-Bew-Del
        rts                                   ; Back

* Routine bewegt Ball, wenn Ball beim Aufschlag geworfen
BALLMOVE4:
        bsr             SERVELOGIK            ; -> ServeLogik
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             SERVETAB(pc),a0       ; Tabelle der Z-Koordinaten -> a0
        move.w          SERVEPOS(pc),d0       ; ServePos -> d0
        move.w          0(a0,d0.w),BS_Z(a5)   ; Z-Koordinate -> BallPort !
        move.w          BSERVEX(pc),BS_X(a5)  ; X-Koordinate -> BallPort !
        move.w          BSERVEY(pc),BS_Y(a5)  ; y-Koordinate -> BallPort !
        addq.w          #2,SERVEPOS           ; INC ServePos
        cmpi.w          #SERVELEN,SERVEPOS    ; Letzte Position ?
        ble             RETURN1               ; Nein -> Ende
        clr.w           SERVEPOS              ; Clear ServePos
RETURN1:
        rts                                   ; Back !

NEWNET:
        clr.w           NETPOS                ; NetPos = 0
        rts                                   ; Back !

* Routine bewegt den Ball, wenn er ins Netz gegangen ist
BALLMOVE5:
        tst.w           NETPOS                ; Erster Aufruf ?
        bne.s           NETIT                 ; Nein -> NetIt
        tst.b           BS_WHO(a5)            ; Wer hat ins Netz geballert ?
        bne.s           OWNPLAYER             ; Eigener Spieler -> OwnPlayer
        move.w          #-10,BS_Y(a5)         ; Set BS_Y
        bra.s           NETIT                 ; -> NetIt
OWNPLAYER:
        subq.w          #1,BS_OK(a5)          ; DEC BS_OK
        move.w          #10,BS_Y(a5)          ; Set BS_Y
NETIT:
        lea             NETTAB(pc),a0         ; NetTabBase -> a0
        move.w          NETPOS(pc),d0         ; NetPos -> d0
        move.b          0(a0,d0.w),d1         ; Get Z aus Tabelle
        and.w           #$00ff,d1             ; Make it word !
        move.w          d1,BS_Z(a5)           ; Set BS_Z
        addq.w          #1,d0                 ; INC NetPos
        cmp.w           #31,d0                ; Ende ?
        bgt.s           LASTMOVE2             ; Ja -> BallDreid
        move.w          d0,NETPOS             ; Lege Position ab !
        rts                                   ; Back !

* Routine testet, ob Abbruchbedingung fuer Sprung erfuellt
KOLLTEST1:
        bsr             NETZTEST              ; Test, ob Ball im Netz
        tst.w           BS_Z(a5)              ; Ist Ball am Boden ?
        beq.s           LASTMOVE1             ; Ja -> LastMove1
        bmi.s           LASTMOVE1             ; Ja -> LastMove1
        cmpi.w          #-YMAX2,BS_Y(a5)      ; Aus ?
        ble.s           LASTMOVE1             ; Ja -> LastMove1
        cmpi.w          #YMAX2,BS_Y(a5)       ; Aus ?
        bge.s           LASTMOVE1             ; Ja -> LastMove1
        rts                                   ; Back to Call !
LASTMOVE1:
        st              BS_NOT(a5)            ; Fehler ( Ball nicht geschlagen )
        move.b          #BALLFLY,BS_TYPE(a5)  ; Set Number for Move
        sf              BS_NEW(a5)            ; NewParaFlag = TRUE
        tst.b           BS_MASCH(a5)          ; Ist Ballmaschine aktiv ?
        beq             RETURN                ; Nein -> Ende
        bra             BALLMASCHINE          ; BallMaschine

LASTMOVE2:
        move.b          #BALLFLY,BS_TYPE(a5)  ; Set Number for Move
        sf              BS_NEW(a5)            ; NewParaFlag = TRUE
        tst.b           BS_MASCH(a5)          ; Ist Ballmaschine aktiv ?
        beq             RETURN                ; Nein -> Ende
        bra             BALLMASCHINE          ; -> BallMaschine

* Routine errechnet den Neigungswert fuer Bewegungs-Parabel
GETNEI:
        move.w          BS_Y(a5),d0           ; BS_Y -> d0
        move.w          BS_FF(a5),d1          ; BS_FF -> d1
        move.w          BS_Z(a5),d2           ; BS_Z -> d2
        move.l          #32768,d3             ; 32768 -> d3

        neg.w           d1                    ; - BS_FF
        divs            d0,d3                 ; BS_Z / BS_Y
        muls            d3,d2                 ;
        muls            d0,d1                 ; BS_FF * BS_Y
        sub.w           d2,d1                 ; SUB Values
        move.w          d1,BS_NEI(a5)         ; BS_NEI ablegen
        rts                                   ; Back to Call !

* Routine prueft, ob Abbruchbedingung fuer Ballbewegung erfuellt
KOLLTEST:
        bsr             NETZTEST              ; Test, ob Ball im Netz
        tst.w           BS_Z(a5)              ; Teste Hoehe des Balles
        ble.s           LASTMOVEZ             ; = 0 -> LastMove
        move.w          BS_Y(a5),BS_OY(a5)    ; Set OldY
        move.w          BS_Z(a5),BS_OZ(a5)    ; Set OldZ
        sf              BS_OUT(a5)            ; Set OutFlag !
        rts                                   ; Back to Call !

LASTMOVEZ:
        clr.w           BS_Z(a5)              ; BS_Z = 0
        movem.w         BS_X(a5),d0-d1        ; Get BS_X, BS_Y -> d0 - d1
        movem.w         BS_BX1(a5),d2-d5      ; Get Bounds -> d2-d5
        cmp.w           d0,d4                 ; Is Out (X1) ?
        blt.s           BALLINOUT             ; Ja -> BallInOut !
        cmp.w           d0,d2                 ; Is Out (X2) ?
        bgt.s           BALLINOUT             ; Ja -> BallInOut !
        cmp.w           d1,d5                 ; Is Out (Y1) ?
        blt.s           BALLINOUT             ; Ja -> BallInOut !
        cmp.w           d1,d3                 ; Is Out (Y2) ?
        bgt.s           BALLINOUT             ; Ja -> BallInOut !
        move.b          #BALLSPR,BS_TYPE(a5)  ; Setze Nummer fuer Sprung
        sf              BS_NEW(a5)            ; NewParaFlag = TRUE
        sf              BS_OUT(a5)            ; Set OutFlag !
        move.w          #GROUNDFX,FXNUM       ; FX Ground -> FXNum
        rts                                   ; Back !

BALLINOUT:
        tst.b           BS_WHO(a5)            ; Wer ist am Schlag gewesen ?
        beq.s           NOTOWNPL              ; = 0 -> NotOwnPlayer
        subq.w          #1,BS_OK(a5)          ; DEC BS_OK
NOTOWNPL:
        st              BS_OUT(a5)            ; Set OutFlag !
        move.b          #BALLSPR,BS_TYPE(a5)  ; Setze Nummer fuer Sprung
        sf              BS_NEW(a5)            ; NewParaFlag = TRUE
        move.w          #OUTFX,FXNUM          ; FX Ground -> FXNum
        rts                                   ; Back !

* Routine gibt FX aus entscheidet anhand von Ballposition Kanal !
* Input:
*       FXNum = SampleNumber ( NEG -> Kein Sample )
*
MAKESOUND:
        cmpi.l          #COPSET1,COPSLOT      ; Ist Replay ?
        beq             RETURN                ; Ja -> Ende
        move.w          FXNUM(pc),d0          ; FXNumber -> d0
        bmi             RETURN                ; Neg -> Ende
        move.w          #-1,FXNUM             ; FXNum = -1
        move.w          d0,d1                 ; FXNumber -> d1
        move.w          d0,d2                 ; FXNumber -> d2
        lsl.w           #2,d1                 ; FXNumber * 4 fuer TabellenZug.
        add.w           d2,d2                 ; FXNumber * 2 fuer TabellenZug.
        movea.l         FXBASE(pc),a0         ; Get Base of Datas -> a0
        lea             FXOFFS(pc),a1         ; FXOffsBase -> a1
        lea             FXLEN(pc),a2          ; FXLenBase -> a2
        lea             CHANNELS,a3           ; ChannelBase -> a3
        lea             CUSTOM+AUD0LCH,a4     ; CustomAudioBase -> a4
        lea             CUSTOM,a5             ; CustomBase -> a4
        adda.l          0(a1,d1.w),a0         ; a0 now Base of SampleDatas
        move.w          0(a2,d2.w),d2         ; d2 now Length of Sample
        tst.w           BS_Y+BALLPORT         ; Wo ist der Ball !
        bmi.s           LEFTCHANNEL           ; Neg -> Linker Kanal !
        moveq           #2,d1                 ; Kanal 2 -> d1
        cmp.w           #GROUNDFX,d0          ; Ball am Boden ?
        beq.s           SETSOUND              ; Ja -> SetSound !
        cmp.w           #OUTFX,d0             ; Ball am Boden und im aus ?
        beq.s           SETSOUND              ; Ja -> SetSound !
        moveq           #1,d1                 ; Kanal 1 -> d1
        bra.s           SETSOUND              ; -> SetSound
LEFTCHANNEL:
        moveq           #3,d1                 ; Kanal 3 -> d1
        cmp.w           #GROUNDFX,d0          ; Ball am Boden ?
        beq.s           SETSOUND              ; Ja -> SetSound !
        cmp.w           #OUTFX,d0             ; Ball am Boden und im aus ?
        beq.s           SETSOUND              ; Ja -> SetSound !
        moveq           #0,d1                 ; Kanal 0 -> d1
SETSOUND:
        st              0(a3,d1.w)            ; Kanal belegen !
        move.w          d1,d3                 ; Kanal -> d3
        lsl.w           #4,d3                 ; * 16 fuer ChannelBase
        adda.w          d3,a4                 ; a4 now Base of Dats !
        moveq           #1,d3                 ; KanalBit -> d3
        lsl.w           d1,d3                 ; << Kanal
        move.w          d3,d4                 ; KanalSelectBits -> d4
        move.w          BS_SP+BALLPORT,d5     ; BallSpeed -> d5
        lsl.w           #1,d5                 ; BallSpeed * 2
        add.w           #28,d5                ; ADD VolumeBase
        move.w          d3,DMACON(a5)         ; AudioDMA sperren ( Start )
        move.w          #SNDPER,6(a4)         ; Periode setzen
        move.w          d5,8(a4)              ; Lautstaerke setzen
        move.w          #$00ff,ADKCON(a5)     ; No Modulation !
;        move.w          #$0780,INTREQ(a5)     ; IRQRequests loeschen !
        lsl.w           #7,d4                 ; KanalSelectBits << 7
        or.w            #$8000,d4             ; Set/Clr-Bit setzen
        or.w            #$8000,d3             ; Set/Clr-Bit setzen
        move.w          d4,INTENA(a5)         ; AudioX erlauben
        move.l          a0,0(a4)              ; Pointer auf Daten
        move.w          d2,4(a4)              ; Laenge setzen
        move.w          #$0100,d7             ; Init LoopCounter !
WAITDMA:dbra            d7,WAITDMA
        move.w          d3,DMACON(a5)         ; AudioXDMA erlauben ( Start )
        rts                                   ; Back to Call !

* Routine gibt Sound-FX ueber alle Kanaele gleichzeitig aus !
MAKESOUND1:
        move.w          FXNUM(pc),d0          ; FXNumber -> d0
        move.w          #-1,FXNUM             ; FXNumber = -1
        move.w          d0,d1                 ; FXNumber -> d1
        move.w          d0,d2                 ; FXNumber -> d2
        lsl.w           #2,d1                 ; FXNumber * 4 fuer TabellenZug.
        add.w           d2,d2                 ; FXNumber * 2 fuer TabellenZug.
        movea.l         FXBASE(pc),a0         ; Get Base of Datas -> a0
        lea             FXOFFS(pc),a1         ; FXOffsBase -> a1
        lea             FXLEN(pc),a2          ; FXLenBase -> a2
        lea             CHANNELS,a3           ; ChannelBase -> a3
        lea             CUSTOM+AUD0LCH,a4     ; CustomAudioBase -> a4
        lea             CUSTOM,a5             ; CustomBase -> a4
        adda.l          0(a1,d1.w),a0         ; a0 now Base of SampleDatas
        move.w          0(a2,d2.w),d2         ; d2 now Length of Sample
        move.l          #-1,CHANNELS          ; All Channels set !
        move.w          #$000f,DMACON(a5)     ; AudioDMA lock ! ( Start )
        move.w          #$00ff,ADKCON(a5)     ; No Modulation !
        move.w          #$c780,INTENA(a5)     ; ALL AudioChanels enable !
        moveq           #3,d7                 ; Init Counter (Nr. of Channels)

SETCHAN:
        move.w          #SNDPER,6(a4)         ; Set Periode
        move.w          #SNDVOL,8(a4)         ; Volume set !
        move.l          a0,0(a4)              ; Set Pointer to Datas
        move.w          d2,4(a4)              ; Set Length !
        adda.w          #$0010,a4             ; Next CustomAudioBase !
        dbra            d7,SETCHAN            ; -> Loop

        move.w          #$0100,d7             ; Init LoopCounter !
WAITDMA1:dbra           d7,WAITDMA1           ; Wait on DMA !
        move.w          #$800f,DMACON(a5)     ; ALL AudioDMA enable ( Start )
        rts                                   ; Back to Call !

* Routine gibt die Animation der Schiedsrichter aus
* MainReferee anhand Ballstellung
* NetReferee anhand Ballstellung
* LineReferee anhand Out/In
MAKEREFS:
        lea             MREFTAB(pc),a3        ; MainRefTabBase -> a3
        lea             NREFTAB(pc),a4        ; NetRefTabBase -> a4
        movea.l         BALLGPTR(pc),a5       ; Base of Datas -> a5
        move.w          BALLPORT+BS_Y,d5      ; BS_Y -> d5
        ext.l           d5                    ; d5 on LongWord
        divs            #180,d5               ; / 180

        cmp.w           #-1,d5                ; < -1 ?
        bge.s           REFNOTLEFT            ; Nein -> RefNotLeft !
        moveq           #-1,d5                ; -1 -> d5
        bra.s           REFNOTRIGHT           ; -> RefnotRight
REFNOTLEFT:
        cmp.w           #1,d5                 ; > 1 ?
        ble.s           REFNOTRIGHT           ; Nein -> RefNotRight
        moveq           #1,d5                 ; 1 -> d5

REFNOTRIGHT:
        add.w           d5,d5                 ; * 2 fuer Tabellenzugriff
        move.w          0(a3,d5.w),d6         ; Offset MainRef -> d6
        move.w          0(a4,d5.w),d5         ; Offset NetRef -> d5
        lea             0(a5,d6.w),a2         ; Offset to Datas -> a2
        move.l          a2,d7                 ; NEG Offset
        neg.l           d7                    ; for
        movea.l         d7,a2                 ; DrawList
        move.w          #MREFX,d0             ; MRefx -> d0
        move.w          #MREFY,d1             ; MRefy -> d1
        moveq           #12,d2                ; Set Optional Z !
        bsr             INOBJLIST             ; -> InObjList !
        lea             0(a5,d5.w),a2         ; Offset to Datas -> a2
        move.l          a2,d7                 ; NEG Offset
        neg.l           d7                    ; for
        movea.l         d7,a2                 ; DrawList
        move.w          #NREFX,d0             ; NRefx -> d0
        move.w          #NREFY,d1             ; NRefy -> d1
        moveq           #10,d2                ; Set Optional Z !
        bra             INOBJLIST             ; -> InObjList !

* Routine entscheidet per Zufall fuer guten Ballwechsel und gibt Klatschen aus
* und initialisiert 3D-Replay !
GOODPLAY:
        rts
        move.w          #4096,d2              ; MaxRnd -> d2
        bsr             SPCRND                ; Get RNDNumber !
;        cmp.w           #3000,d0              ; Sound and Replay ?
;        ble             RETURN                ; Nein -> Ende !
        move.w          #AUDFX,FXNUM          ; AudienceFX -> FXNum
        bsr             MAKESOUND1            ; FX on all Channels !
        move.w          #80,d6                ; One second -> d6
WSD1:
        bsr             WAITBEAM              ; Wait on Beam !
        move.w          #$0100,d7             ; Short WaitLoop !
WSD:    dbra            d7,WSD                ; -> Loop
        dbra            d6,WSD1               ; -> Loop * Fames
        tst.b           REPLAYPOS             ; Replay moeglich ?
        bne             RETURN                ; Nein -> Ende
;        bsr             PIXOFF                ; Platz ausblenden !
        move.w          #$000f,DMACON+CUSTOM
        bsr             INITREPLAY            ; -> Replay !
        rts                                   ; Back !

* Routine testet ob Ball im Netz und setzt NetzFlag
NETZTEST:
        sf              BS_NET(a5)            ; Clear NET-Flag
        tst.b           BS_MASCH(a5)          ; Maschine aktive ?
        beq             MAKENETTEST           ; Ja -> MakeNetTest
        tst.b           BS_WHO(a5)            ; Wer ist am Schlag !
        beq             RETURN                ; Ballmaschine -> Ende
MAKENETTEST:
        tst.w           BS_Y(a5)              ; Test BS_Y
        bmi.s           LASTPOS               ; NEG -> LastPos
        beq.s           DIRECTCMP             ; = 0 -> DirectCmp
        tst.w           BS_OY(a5)             ; Test BS_OY
        bmi.s           INTPOLCMP             ; Positiv -> IntPolCmp
        rts                                   ; Back to Call !
LASTPOS:
        tst.w           BS_OY(a5)             ; Test, ob BS_OY positiv
        beq.s           LASTPOSE              ; = 0 -> LastPosE
        bpl.s           INTPOLCMP             ; Ja -> IntPolCmp
LASTPOSE:
        rts                                   ; Back to Call !

DIRECTCMP:
        cmpi.w          #NH,BS_Z(a5)          ; Vergleich BS_Z mit NetzHoehe
        bge             RETURN                ; >= -> Ende
ISNET:
        st              BS_NET(a5)            ; Set Net-Flag !
        move.b          #BALLNET,BS_TYPE(a5)  ; Set BallMoveType
        sf              BS_NEW(a5)            ; NewPara = True
        rts                                   ; Back to Call !
INTPOLCMP:
        move.w          BS_Z(a5),d0           ; BS_Z -> d0
        add.w           BS_OZ(a5),d0          ; ADD BS_OZ
        asr.l           #1,d0                 ; / 2
        cmpi.w          #NH,d0                ; Vergleich d0 mit NetzHoehe
        bge             RETURN                ; >= -> Ende
        bra.s           ISNET                 ; -> IsNet

* Zeichne Ball
DRAWBALLS:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             BALLRPORT(pc),a0      ; BallRepPortBase -> a0
        movea.l         REPLAYPORT+AN_BASE,a2 ; Base of Datas -> a2
        moveq           #BALLANIS1-1,d1       ; Anzahl der Anim.Stufen -> d1
        move.w          BS_ZZ(a5),d0          ; BS_Y -> d0
        add.w           #YMAX2,d0             ; + YMAX2
        ext.l           d0                    ; Erweitere auf Langwort
        divs            #ANIDIVI1,d0          ; / Anim.Dividend.
        sub.w           d0,d1                 ; d1 = Animationsstufe
        bpl.s           ANI1NOTNEG            ; Positiv -> Ani1NotNeg
        moveq           #0,d1                 ; Anim = 0
ANI1NOTNEG:
        cmp.w           #BALLANIS1-1,d1       ; Ist kleiner MaxAni ?
        ble.s           NOTMAXANI1            ; Ja -> NotMaxAni1
        moveq           #BALLANIS1-1,d1       ; Anim = MaxAnim
NOTMAXANI1:
        add.w           d1,d1                 ; * 2 fuer Wort-Zugriff
        move.w          0(a0,d1.w),d0         ; Offset des Balls -> a2
        lea             0(a2,d0.w),a2         ; ADD Offset to DataBase
        movea.l         PLANES+16(a6),a1      ; a1 = ZielBitmap = 5. Plane
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4
        move.w          SCRHEIGHT(a6),d5      ; Maximale Hoehe -> d5
        subq.w          #1,d5                 ; Hoehe = 199
        suba.w          a4,a4                 ; No BCKSave !
        move.w          BS_XX(a5),d0          ; X-Koordinate -> d0
        move.w          BS_YY(a5),d1          ; Y_Koordinate -> d1

        cmp.w           #LEFTX,d0             ; Test, ob links aussen
        ble.s           NOBALL                ; Ja -> NoBall
        cmp.w           #RIGHTX-10,d0         ; Test, ob rechts aussen
        bge.s           NOBALL                ; Ja -> NoBall
        move.w          #0,SCRPLANESC(a6)     ; Only one Plane !

        movem.l         d2/d4-d5/a2/a4/a6,-(a7) ; Save Regs on Stack !
        bsr             BOB                   ; Zeichne Ball !
        movem.l         (a7)+,d2/d4-d5/a2/a4/a6 ; Get Regs from Stack !

NOBALL:
        movea.l         PLANES+12(a6),a1      ; a1 = ZielBitmap = 4. Plane
        move.w          BS_XXX(a5),d0         ; X-Koordinate -> d0
        move.w          BS_YYY(a5),d1         ; Y_Koordinate -> d1

        cmp.w           #LEFTX,d0             ; Test, ob links aussen
        ble.s           NOSHADOW              ; Ja -> NoShadow
        cmp.w           #RIGHTX-10,d0         ; Test, ob rechts aussen
        bge.s           NOSHADOW              ; Ja -> NoShadow

        move.l          a6,-(a7)              ; Save Regs on Stack !
        bsr             BOB                   ; Zeichne Schatten !
        movea.l         (a7)+,a6              ; Get Regs from Stack !

NOSHADOW:
        move.w          #BITPLANES-1,SCRPLANESC(a6) ; Planes restaurieren
        rts                                   ; Back to Call!

* Zeichne Ball und Schatten incl. Netzverdeckung
DRAWBALLS1:
        bsr             WHICHANI              ; Welche Tiefe hat der Ball !

        addq.w          #1,ACTBALLD           ; INC Delay !
        cmpi.w          #10,ACTBALLD          ; Ist Delay erfuellt ?
        bne             RETURN                ; Nein -> Ende
        clr.w           ACTBALLD              ; Loesche Delay
        move.w          ACTBALLG(pc),d3       ; Nummer des Frames -> d3
        addq.w          #1,d3                 ; INC FrameNumber
        cmp.w           #6,d3                 ; Ist Ende erreicht ?
        ble.s           ACTBALLOK             ; Nein -> ActBallOk
        moveq           #0,d3                 ; FrameNumber = 0
ACTBALLOK:
        move.w          d3,ACTBALLG           ; Neue FrameNumber ablegen
        rts                                   ; Back !

WHICHANI:
        moveq           #BALLANIS-1,d1        ; Anzahl der Anim.Stufen -> d1
        move.w          BS_ZZ+BALLPORT,d0     ; BS_ZZ -> d0
        add.w           #YMAX2,d0             ; + YMAX2
        ext.l           d0                    ; Erweitere auf Langwort
        divs            #ANIDIVI,d0           ; / Anim.Dividend.
        sub.w           d0,d1                 ; d1 = Animationsstufe
        bpl.s           ANINOTNEG             ; Positiv -> AniNotNeg
        moveq           #0,d1                 ; Anim = 0
ANINOTNEG:
        cmp.w           #BALLANIS-1,d1        ; Ist kleiner MaxAni ?
        ble.s           NOTMAXANI             ; Ja -> NotMaxAni
        moveq           #BALLANIS-1,d1        ; Anim = MaxAnim
NOTMAXANI:
        move.l          d1,d7                 ; Animationsstufe -> d7
        mulu            #14,d1                ; * Groesse einer Animation !
        move.w          ACTBALLG(pc),d3       ; Nummer des Frames -> d3
        add.w           d3,d3                 ; * 2 fuer Wortzugriff

        add.w           d3,d1                 ; ADD Offset
        movea.l         BALLGPTR(pc),a2       ; Base of Datas -> a2
        lea             BALLGPORT(pc),a3      ; BallGportBase -> a3

        adda.w          0(a3,d1.w),a2         ; ADD Offset der Daten
        move.l          a2,d3                 ; a2 -> d3
        neg.l           d3
        movea.l         d3,a2

        movem.w         BS_XX+BALLPORT,d0-d2  ; X-Y-Z-Koordinate -> d0 - d2
        subq.w          #5,d0                 ; Correct X
        subq.w          #5,d1                 ; Correct Y
        bsr             INOBJLIST             ; -> InObjList

        cmpi.b          #BALLTHR,BS_TYPE+BALLPORT ; Service in progress ?
        beq             DRAWCROSS             ; Ja -> DrawCross !

        lea             SHADGPORT(pc),a3      ; ShadGPortBase -> a3
        addq.w          #1,d7                 ; INC AnimStep
        cmp.w           #BALLANIS-1,d7        ; > MaxAnis
        ble.s           NOTMAX2ANI            ; Nein -> NotMaxAni
        moveq           #BALLANIS-1,d7        ; Anim = MaxAnim
NOTMAX2ANI:
        add.w           d7,d7                 ; * 2 fuer WortZugriff
        movea.l         BALLGPTR(pc),a2       ; Base of Datas -> a2

        adda.w          0(a3,d7.w),a2         ; ADD Offset
        move.l          a2,d3                 ; a2 -> d3
        neg.l           d3
        movea.l         d3,a2

        movem.w         BS_XXX+BALLPORT,d0-d2 ; X-Y-Z-Koordinate -> d0 - d2
        subq.w          #5,d0                 ; Correct X
        subq.w          #5,d1                 ; Correct Y
        bsr             INOBJLIST             ; -> InObjList
        rts                                   ; Back !

HIDEFLAG:       DC.W 0                  ; Ball-Netz-Verdeckung-Flag

* Routine kopiert den Ball in Plane und beruecksichtigt Netzverdeckung
* Input:
*       a2 = Pointer auf ObjektStruktur
*       d0 = X
*       d1 = Y
*       a4 = BackGroundBuffer
*       a6 = Pointer auf ScreenPortBase
SPECBALL:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movea.l         BACKSTACKPT(pc),a4    ; BackStackPointer -> a4
        movea.l         a2,a1                 ; ObjectPtr -> a1
        add.w           OS_XOFF(a2),d0        ; ADD X-Offset
        bmi             RETURN                ; Clip -> Ende
        cmp.w           #310,d0               ; Clip ?
        bge             RETURN                ; Ja -> Ende
        add.w           OS_YOFF(a2),d1        ; ADD Y-Offset
        bmi             RETURN                ; Clip -> Ende
        cmp.w           #194,d1               ; Clip ?
        bge             RETURN                ; Ja -> Ende
        move.w          OS_HOEHE(a2),d6       ; HOEHE in Zeilen -> d6
        adda.w          OS_IMGOFF(a2),a1      ; Zeiger auf ImageDaten -> a1
        lea             OS_MSKOFF(a2),a2      ; Zeiger auf Maske -> a2
        move.w          d1,d2                 ; Y-Koordinate -> d2
        cmp.w           #NETY2,d2             ; Ist im Netz-Bereich ?
        bgt.s           NONETBALL             ; Nein -> NoNetBall !
        add.w           d6,d2                 ; Hoehe addieren !
        cmp.w           #NETY1,d2             ; Ist im Netz-Bereich ?
        blt.s           NONETBALL             ; Nein -> NoNetBall !
        bsr             NETBALL               ; -> NetBall ( Verdeckung )
NONETBALL:
        moveq           #3,d7                 ; Init LoopCounter ( Planes - 1 )
        movea.l         a2,a5                 ; Zeiger auf Maske -> a5
        movea.l         PLANEBASE(pc),a0      ; PlaneBase -> a0
        subq.w          #1,d6                 ; Correct LoopCounter
        move.w          d6,d3                 ; LoopCounter -> d3
        add.w           d1,d1                 ; Y * 2 fuer Tabellenzugriff
        move.w          MULU160(a6,d1.w),d5   ; Y-Offset -> d5
        move.w          d0,d4                 ; X -> d4
        andi.w          #$000f,d4             ; Shiftfaktor ausmaskieren
        andi.w          #$fff0,d0             ; Wort-Offset
        lsr.w           #3,d0                 ; Wortoffset
        add.w           d0,d5                 ; X-Offset ADD d5
        ext.l           d5                    ; d5 now Longword
        sub.w           #15,d4                ; Make Shift
        neg.w           d4                    ; NEG ShiftFaktor
        move.l          a0,(a4)               ; SourceBitmap in BCKBuffer
        add.l           d5,(a4)+              ; Offset addieren
        move.w          #36,(a4)+             ; Modulo fuer OLDBACK
        move.w          d6,d0                 ; Hoehe -> d0 !
        addq.w          #1,d0                 ; INC Height
        lsl.w           #6,d0                 ; * 64 ( BlitSize )
        addq.w          #$02,d0               ; Width 2 Woerter
        move.w          d0,(a4)+              ; BlitSize in BackStack
        move.w          #8000,(a4)+           ; BytesperPlane in BCKBuffer
SPECBALLOOP:
        lea             0(a0,d5.w),a3         ; a0 now Pointer to Langwort
SPECB1LOOP:
        moveq           #0,d0                 ; Clear d0
        move.l          d0,d1                 ; Clear d1
        move.w          (a1)+,d0              ; One ImageWord -> d0
        move.w          (a2)+,d1              ; One MaskWord -> d1
        move.l          (a3),d2               ; PlaneLongword -> d2
        move.l          d2,(a4)+              ; BackGround ablegen !
        lsl.l           d4,d0                 ; Shift ImageWord
        lsl.l           d4,d1                 ; Shift MaskWord
        and.l           d1,d0                 ; AND Image, Mask
        not.l           d1                    ; NOT Mask
        and.l           d1,d2                 ; AND Mask,Plane
        or.l            d0,d2                 ; OR Mask,Plane , Image
        move.l          d2,(a3)               ; Copy Image !
        lea             40(a3),a3             ; ADD OneLine in Bytes
        dbra            d6,SPECB1LOOP         ; -> Loop
        move.w          d3,d6                 ; Init LoopCounter !
        movea.l         a5,a2                 ; MaskenZeiger restaurieren !
        lea             8000(a0),a0           ; Eine Plane weiter !
        dbra            d7,SPECBALLOOP        ; -> Loop
        move.l          BACKSTACKPT(pc),(a4)+ ; Beginn der Daten in BackStack
        move.l          a4,BACKSTACKPT        ; neuer Stackpointer
        rts                                   ; Back !

* Routine generiert neue Maske im Buffer, wenn Netz vor Ball oder Schatten
NETBALL:
        tst.b           HIDEFLAG              ; Ball-Netz-Verdeckung ?
        beq             RETURN                ; Ja -> Ende
        lea             NETMSK(pc),a5         ; NetMaskBase -> a5
        lea             MASKBCK(pc),a0        ; MaskenBuffer -> a0
        move.w          d0,d2                 ; X-Koordinate -> d2
        move.w          d1,d3                 ; Y-Koordinate -> d3
        move.w          d0,d4                 ; X-Koordinate -> d4
        move.w          d6,d7                 ; Hoehe -> d7
        subq.w          #1,d7                 ; Correct LoopCounter !
        sub.w           #NETY1-9,d3           ; SUB NetY1
        add.w           d3,d3                 ; * 2 fuer Tabellenzugriff
        move.w          MULU160(a6,d3.w),d3   ; Y-Offset -> d3
        andi.w          #$fff0,d2             ; Wort-Offset
        and.w           #$000f,d4             ; Shiftwert ausmaskieren !
        sub.w           #15,d4                ; Make ShiftValue
        neg.w           d4                    ; Neg ShiftValue
        lsr.w           #3,d2                 ; Wortoffset
        add.w           d3,d2                 ; Y-Offset + WortOffset
        lea             0(a5,d2.w),a5         ; Offset addieren
NETBALLM:
        moveq           #0,d5                 ; Clear d5
        move.w          (a2)+,d5              ; MaskenWort ( Ball ) -> d5
        lsl.l           d4,d5                 ; Shift Mask !
        and.l           (a5),d5               ; AND NetMask
        lsr.l           d4,d5                 ; Shift Mask Back !
        move.w          d5,(a0)+              ; MaskenBuffer ablegen !
        lea             40(a5),a5             ; ADD OneLine
        dbra            d7,NETBALLM           ; -> Loop
        lea             MASKBCK(pc),a2        ; MaskenBufferBase -> a2
        rts                                   ; Back !

* Routine bernimmt die Berechnung der 3D-Koordinaten in 2D-Koordinaten
* fuer Ball und dessen Schatten
BALLDREID:
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        lea             BS_XX(a5),a0          ; DestArray -> a0
        lea             BS_X(a5),a2           ; SourceArray -> a2
        lea             ROTTABLE(pc),a3       ; RotTable -> a3
        moveq           #0,d7                 ; 1. Koordinate umrechnen

        bsr             OUTLOOP               ; -> OutLoop

        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.w          BS_Z(a5),-(a7)        ; -> BS_Z auf Stack retten
        clr.w           BS_Z(a5)              ; BS_Z = 0
        subq.w          #1,BS_Y(a5)           ; DEC Y (Ball-Schatten-Verdeckung)
        lea             BS_XXX(a5),a0         ; DestArray -> a0
        lea             BS_X(a5),a2           ; SourceArray -> a2
        lea             ROTTABLE(pc),a3       ; RotTable -> a3
        moveq           #0,d7                 ; 1. Koordinate umrechnen

        bsr             OUTLOOP               ; -> OutLoop

        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.w          (a7)+,BS_Z(a5)        ; Koord vom Stack -> BS_Z
        addq.w          #1,BS_Y(a5)           ; Correct Y
        rts                                   ; Back to Call !

* Routine errechnet Spieler 3D-Koordinaten ( Spieler 1 )
PLAYERDREID:
        lea             PL1PORT(pc),a5        ; PL1PortBase -> a5
        lea             P1_DX(a5),a0          ; DestArray -> a0
        lea             P1_X(a5),a2           ; SourceArray -> a2
        lea             ROTTABLE(pc),a3       ; RotTable -> a3
        moveq           #0,d7                 ; 1. Koordinate umrechnen
        bsr             OUTLOOP               ; -> OutLoop
        move.w          PL1PORT+P1_DZ,d0      ; Get Z -> d0
        ext.l           d0                    ; Langwort erweitern !
        divs            #94,d0                ; / 60
        bpl.s           STEPNOTZERO           ; >= 0 -> StepNotZero
        moveq           #0,d0                 ; Step = 0
STEPNOTZERO:
        cmp.w           #3,d0                 ; > MaxZoom ?
        ble.s           NOZOOMBOUND           ; Nein -> NoZoomBound
        moveq           #3,d0                 ; MaxZoom -> d0
NOZOOMBOUND:
        lsl.w           #2,d0                 ; * 4 fuer TabellenZugriff
        lea             WAOFFS(pc),a0         ; WaOffsetMasterTab -> a0
        move.l          0(a0,d0.w),WAITAPORT+AN_OFFS ; Offsets eintragen !

        lea             SAWOFFS(pc),a0        ; SawOffsetMasterTab -> a0
        move.l          0(a0,d0.w),SAWPORT+AN_OFFS ; Offsets eintragen !

        lea             VAOFFS(pc),a0         ; VaOffsetMasterTab -> a0
        move.l          0(a0,d0.w),VORAPORT+AN_OFFS ; Offsets eintragen !

        move.l          0(a0,d0.w),VORASPORT+AN_OFFS ; Offsets eintragen !

        lea             RAOFFS(pc),a0         ; RueOffsetMasterTab -> a0
        move.l          0(a0,d0.w),RUEAPORT+AN_OFFS ; Offsets eintragen !

        move.l          0(a0,d0.w),RUEASPORT+AN_OFFS ; Offsets eintragen !

        move.w          PL1PORT+P1_DZ,d0      ; Get Z -> d0
        ext.l           d0                    ; LangWort erweitern
        divs            #25,d0                ; / 25
        bpl.s           LNAZNOTZ              ; >= 0 -> LNAZnotZ
        moveq           #0,d0                 ; d0 = 0
LNAZNOTZ:
        cmp.w           #12,d0                ; > 12
        ble.s           LNAZNOTG              ; Nein -> LNAZnotG
        moveq           #12,d0                ; d0 = 12
LNAZNOTG:
        move.w          d0,d1                 ; d0 -> d1
        tst.b           LNAFLAG               ; Laeuft nord ?
        bne.s           TESTSUED              ; Ja -> TestSued
        neg.w           d0                    ; NEG d0
        add.w           #12,d0                ; ADD 12
        move.w          d0,LNAPORT+AN_CNT     ; d0 -> LNA_ANCNT
TESTSUED:
        tst.b           LNSFLAG               ; Laeuft sued ?
        bne.s           TESTHALFS             ; Ja -> TestHalfs
        move.w          d1,LSAPORT+AN_CNT     ; d1 -> LNs_ANCNT

TESTHALFS:
        move.w          PL1PORT+P1_DZ,d0      ; Get Z -> d0
        ext.l           d0                    ; LangWort erweitern
        divs            #16,d0                ; / 17
        bpl.s           LNWAZNOTZ             ; >= 0 -> LNWAZnotZ
        moveq           #0,d0                 ; d0 = 0
LNWAZNOTZ:
        cmp.w           #18,d0                ; > 18
        ble.s           LNWAZNOTG             ; Nein -> LNWAZnotG
        moveq           #18,d0                ; d0 = 18
LNWAZNOTG:
        move.w          d0,d1                 ; d0 -> d1
        tst.b           LNAFLAG               ; Laeuft nord ?
        bne.s           TESTHSUED             ; Ja -> TestHSued
        neg.w           d0                    ; NEG d0
        add.w           #18,d0                ; ADD 18
        tst.b           LNWAFLAG              ; Laeuft nord-west ?
        bne.s           TESTNOA               ; Ja -> TestNOA
        move.w          d0,LNWAPORT+AN_CNT    ; d0 -> LNWA_ANCNT
TESTNOA:
        tst.b           LNOAFLAG              ; Laeuft nord-ost ?
        bne.s           TESTHSUED             ; Ja -> TestHSued
        move.w          d0,LNOAPORT+AN_CNT    ; d0 -> LNOA_ANCNT

TESTHSUED:
        tst.b           LSWAFLAG              ; Laeuft sued-west ?
        bne.s           TESTSOA               ; Ja -> TestSOA
        move.w          d1,LSWAPORT+AN_CNT    ; d1 -> LSWA_ANCNT
TESTSOA:
        tst.b           LSOAFLAG              ; Laeuft sued-ost ?
        bne             RETURN                ; Ja -> Ende
        move.w          d1,LSOAPORT+AN_CNT    ; d1 -> LSOA_ANCNT

        rts                                   ; Back !

* Routine errechnet Spieler 3D-Koordinaten ( Spieler 2 )
PLAYER1DREID:
        lea             PL2PORT(pc),a5        ; PL2PortBase -> a5
        lea             P1_DX(a5),a0          ; DestArray -> a0
        lea             P1_X(a5),a2           ; SourceArray -> a2
        lea             ROTTABLE(pc),a3       ; RotTable -> a3
        moveq           #0,d7                 ; 1. Koordinate umrechnen
        bsr             OUTLOOP               ; -> OutLoop
        move.w          PL2PORT+P1_DZ,d0      ; Get Z -> d0
        ext.l           d0                    ; Langwort erweitern !
        divs            #154,d0               ; / 154
        neg.w           d0

        lsl.w           #2,d0                 ; * 4 fuer TabellenZugriff
        lea             WBOFFS(pc),a0         ; WBOffsetMasterTab -> a0
        move.l          0(a0,d0.w),WAITBPORT+AN_OFFS ; Offsets eintragen !

        lea             SBWOFFS(pc),a0        ; SbOffsetMasterTab -> a0
        move.l          0(a0,d0.w),SBWPORT+AN_OFFS ; Offsets eintragen !

        lea             VBOFFS(pc),a0         ; VbOffsetMasterTab -> a0
        move.l          0(a0,d0.w),VORBPORT+AN_OFFS ; Offsets eintragen !

        move.l          0(a0,d0.w),VORBSPORT+AN_OFFS ; Offsets eintragen !

        lea             RBOFFS(pc),a0         ; RueOffsetMasterTab -> a0
        move.l          0(a0,d0.w),RUEBPORT+AN_OFFS ; Offsets eintragen !

        move.l          0(a0,d0.w),RUEBSPORT+AN_OFFS ; Offsets eintragen !

        move.w          PL2PORT+P1_Y,d0       ; Get Z -> d0
        neg.w           d0
        ext.l           d0                    ; LangWort erweitern
        divs            #25,d0                ; / 25
        bpl.s           LNBZNOTZ              ; >= 0 -> LNBZnotZ
        moveq           #0,d0                 ; d0 = 0
LNBZNOTZ:
        cmp.w           #12,d0                ; > 12
        ble.s           LNBZNOTG              ; Nein -> LNBZnotG
        moveq           #12,d0                ; d0 = 12
LNBZNOTG:
        move.w          d0,d1                 ; d0 -> d1
        tst.b           LNBFLAG               ; Laeuft nord ?
        bne.s           TESTBSUED             ; Ja -> TestBSued
        neg.w           d0                    ; NEG d0
        add.w           #12,d0                ; ADD 12
        move.w          d0,LNBPORT+AN_CNT     ; d0 -> LNB_ANCNT
TESTBSUED:
        tst.b           LNBFLAG               ; Laeuft sued ?
        bne             RETURN                ; Ja -> Ende
        move.w          d1,LSBPORT+AN_CNT     ; d1 -> LNs_ANCNT

        tst.b           LSWBFLAG              ; Laeuft sued-west ?
        bne.s           TESTSOB               ; Ja -> TestSOB
        move.w          d1,LSWBPORT+AN_CNT    ; d1 -> LSWB_ANCNT
TESTSOB:
        tst.b           LSOBFLAG              ; Laeuft sued-ost ?
        bne             RETURN                ; Ja -> Ende
        move.w          d1,LSOBPORT+AN_CNT    ; d1 -> LSOB_ANCNT

        rts                                   ; Back !

* Routine errechnet BS_Z
* Input:
*       d4 = BS_Y
*       d5 = BS_FF
*       d6 = BS_NEI
*       d7 = BS_ZM1
*       a5 = BallPortBase
GETZ:
        move.w          d4,d2                 ; BS_Y -> d2
        muls            d2,d2                 ; BS_Yý
        neg.w           d5
        ext.l           d5
        bsr             MULU32                ; BS_Yý * BS_FF
        neg.l           d0                    ; Ergebnis negativ !
        muls            d4,d6                 ; BS_Y * BS_NEI
        add.l           d6,d0                 ; BS_FF*BS_Yý + BS_NEI*BS_Y
        add.l           d0,d0                 ; * 2
        swap            d0                    ; / 32768
        add.w           d7,d0                 ; ADD BS_ZM1
        move.w          d0,BS_Z(a5)           ; BS_Z in BallPort ablegen
        rts

* Routine dividiert 2 * 32-Bit Zahlen nicht vorzeichenbehaftet
* Input:
*       d0 = Dividend
*       d1 = Divisor
* Output:
*       d0 = Ergebnis
DIVU32SET:      REG d2-d3
DIVU32:
        movem.l         DIVU32SET,-(a7)       ; Save Regs on Stack
        moveq           #$0020-1,d3           ; 32-Bit-Ergebnis
        moveq           #0,d2                 ; ZwischenErgebnis = 0
DIVU32LOOP:
        asl.l           #1,d0                 ; << Dividend
        roxl.l          #1,d2                 ; Extend -> d2
        cmp.l           d1,d2                 ; Vergleich mit Divisor
        bcs             DIVU32L               ; < -> Divu32L
        sub.l           d1,d2                 ; SUB Divisor
        addq.l          #1,d0                 ; INC Dividend
DIVU32L:dbra            d3,DIVU32LOOP         ; -> Loop
        movem.l         (a7)+,DIVU32SET       ; Get Regs from Stack
        rts                                   ; Back to Call !

* Routine multipliziert 2 * 32-Bit Zahlen nicht vorzeichenbehaftet
* Input:
*       d2/d3 = Multiplikant/Multiplikator
* Output:
*       d0/d1 = Untere/Obere 32 Bit des Ergebnisses
MULU32SET:      REG d3-d7
MULU32:
        movem.l         MULU32SET,-(a7)       ; Save Regs on Stack
        move.l          d5,d3                 ; Multiplikant -> d3
        move.l          d5,d4                 ; Multiplikant -> d4
        move.l          d2,d1                 ; Multiplikator -> d1

        swap            d3                    ; Vorbereitung fuer
        swap            d1                    ; Teilmultiplikationen
        mulu            d1,d5                 ; Teil 3  C*B
        mulu            d3,d1                 ; Teil 1  A*C
        mulu            d2,d4                 ; Teil 4  B*D
        mulu            d3,d2                 ; Teil 2  A*D
        move.l          d4,d0                 ; Umlegen der Werte
        clr.w           d4                    ;
        swap            d4                    ; Teil 3 & 4 zusammen
        add.l           d4,d5
        moveq           #0,d3                 ; d3 = 0
        moveq           #0,d7                 ; d7 = 0
        addx.l          d7,d3                 ; Uebertrag -> d3
        add.l           d2,d5                 ; Teil 2 und 3 & 4
        addx.l          d7,d3                 ; Uebertrag -> d3
        move.l          d5,d6                 ; d5 -> d6
        clr.w           d5                    ;
        swap            d5                    ;
        add.l           d5,d1                 ; Teil 2,3,4 zu U1

        swap            d0                    ; Richtige Reihenfolge
        clr.w           d0                    ; festlegen
        swap            d0
        swap            d6
        clr.w           d6
        add.l           d6,d0
        swap            d1
        add.w           d3,d1
        swap            d1
        movem.l         (a7)+,MULU32SET       ; Get Regs from Stack
        rts

* Routine erechnet Zufallszahl
RANDOM:
        lea             RAND(pc),a0           ; RandomBase -> a0
        move.w          (a0),d0               ;
        move.w          d0,4(a0)
        move.w          2(a0),d1
        eor.w           d1,d0
        roxl.w          6(a0)
        roxr.w          #1,d0
        roxr.w          6(a0)
        move.w          d0,(a0)
        move.w          4(a0),d0
        move.w          d0,2(a0)
        rts                                   ; Back !
RAND:           DC.W $1234,$fedc,0,0

* Routine errechnet positive Zufallszahl in bestimmtem Bereich
* Input:
*       d2 = Obere Grenze des Bereichs !
* Output:
*       d0 = ZufallsZahl
SPCRND:
        movem.l         d1-d3/a0,-(a7)        ; Save Regs on Stack !
        bsr             RANDOM                ; Hole ZufallsZahl !
        move.l          #32768,d3             ; 32768 -> d3
        divs            d2,d3                 ; / Obere Grenze !
        move.l          d3,d2                 ; d3 -> d2
        swap            d2                    ; Rest in unteres Wort
        asr.w           #2,d2                 ; / 4
        add.w           d2,d3                 ; ADD d3
        tst.w           d0                    ; RND pos or neg ?
        bpl.s           RNDISPOS              ; POS -> RNDisPos
        neg.w           d0                    ; NEG d0
RNDISPOS:
        ext.l           d0                    ; Langwort erweitern !
        divs            d3,d0                 ; / d3
        movem.l         (a7)+,d1-d3/a0        ; Get Regs from Stack !
        rts                                   ; Back !

WAITS:  tst.b           JOYPORT+JP_BUTTON
        beq.s           WAITS
WAITP:  tst.b           JOYPORT+JP_BUTTON
        bmi.s           WAITP
        rts

WAITR:  tst.w           JP_MRBUTTON+JOYPORT
        bmi.s           WAITR
        rts

WAS:    btst            #10,$00dff016
        bne.s           WAS
WAP:
        btst            #10,$00dff016
        beq.s           WAP
        rts

CLEAR:
        movem.l         FULLSET,-(a7)
        lea             SCRPORT(pc),a6
        movea.l         PLANES(a6),a0
OFF:            SET 0
                REPT 8
        move.l          #0,OFF(a0)
        move.l          #0,OFF+4(a0)
OFF:            SET OFF+40
                ENDR
        lea             OUBUFFER(pc),a3
        move.l          #0,(a3)+
        move.l          #0,(a3)+
        move.w          #0,(a3)+
        movem.l         (a7)+,FULLSET
        rts

* Routine errechnet BS_X
* Input:
*       d4 = BS_Y
*       a5 = BallPortBase
GETX:
        move.w          d4,d3                 ; BS_Y -> d3
        sub.w           BS_ST(a5),d3          ; BS_Y - BS_ST
        ext.l           d3                    ; LangWort erweitern
        asl.l           #8,d3                 ; * 256
        divs            BS_M(a5),d3           ; BS_X = (BS_Y-BS_ST)*256)/BS_M
        move.w          d3,BS_X(a5)           ; BS_X in BallPort ablegen
        rts                                   ; Back to Call !

* Routine errechnet verschiedene Parameter fuer die Ball-Bewegung
NEWPARAS:
; Steigung m aus Winkel win errechnen
        move.w          BS_WIN(a5),d0         ; Winkel holen
        bsr             TANGENS               ; Tangens = Steigung holen
        move.w          d0,BS_M(a5)           ; Steigung ablegen

; Y-Decrementor aus Y und Schlagstaerke errechnen

        move.w          BS_SP(a5),d1          ; BS_SP -> d1
        move.w          BS_Y(a5),d2           ; BS_Y -> d2
        beq.s           ISDEFAULT             ; = 0 -> IsDefault
        bpl.s           ISNEGDEFAULT          ;
ISDEFAULT:
        move.w          d1,BS_DE(a5)          ; Decrementor ablegen
        bra.s           DEYENDE               ; -> DeYEnde
ISNEGDEFAULT:
        neg.w           d1                    ; - BS_SP
        move.w          d1,BS_DE(a5)          ; Decrementor ablegen
DEYENDE:
; Schnittpunkt der Geraden mit Y-Achse
        muls            BS_DX(a5),d0          ; BS_DX * BS_M
        asr.l           #8,d0                 ; / 256
        sub.w           d0,d2                 ; BS_Y - (BS_DX * BS_M) / 256
        move.w          d2,BS_ST(a5)          ; BS_ST in BallPort ablegen
        rts                                   ; Back !

* Errechne Parabel-Parameter fuer BallBewegung
GETPARAB:
        cmpi.w          #NETFLY,BS_Y(a5)      ; Which Algorithm ?
        bgt             NOTNEARNET            ; > T-line -> NotNearNet
        tst.w           BS_Y(a5)              ; Neg or Pos ?
        bpl.s           NEARNET               ; POS -> NearNet
NOTNEARNET:
        cmpi.w          #-NETFLY,BS_Y(a5)     ; Which Algorithm ?
        blt             NOTNEARNET1           ; > T-line -> NotNearNet1
        tst.w           BS_Y(a5)              ; Neg or Pos ?
        bmi.s           NEARNET               ; NEG -> NearNet
NOTNEARNET1:
        bsr             GETFF                 ; Hole Kruemmungs-Parameter
        bsr             GETNEI                ; Hole Neigungs-Parameter
        rts                                   ; Back to Call !

* Routine errechnet ParabelParameter, wenn Ball n„he des Netzes geschlagen wird
NEARNET:
        move.w          BS_YM1(a5),d4         ; DestY. -> d4
        move.w          BS_Y(a5),d5           ; SourceY -> d5
        sub.w           d4,d5                 ; SUB DestY.
        add.w           BS_Y(a5),d5           ; ADD SourceY
        move.w          BS_Y(a5),d6           ; MitteY = SourceY -> d6
        move.w          BS_ZM2(a5),-(a7)      ; BS_ZM2 on Stack !
        move.w          BS_Z(a5),BS_ZM2(a5)   ; SchlagHoehe = MaxHoehe
        addq.w          #4,BS_ZM2(a5)
        bsr             NEWPARAS2             ; AufschlagParas errechnen
        move.w          (a7)+,BS_ZM2(a5)      ; BS_ZM2 from Stack !

        move.w          d0,BS_ZM1(a5)         ; ZM1
        move.w          d6,BS_FF(a5)          ; Setze FF
        move.w          d3,BS_NEI(a5)         ; Setze Neigung
        rts                                   ; Back !

* Routine errechnet Kruemmungs-Parameter ( Bewegung )
GETFF:
        move.w          BS_ZM1(a5),d0         ; BS_ZM1 -> d0
        move.w          BS_YM1(a5),d1         ; BS_YM1 -> d1
        muls            d1,d1                 ; BS_YM1ý
        mulu            #32768,d0             ; BS_ZM1 * 32768
        bsr             DIVU32                ; 32/32-Bit-Division
        neg.w           d0
        move.w          d0,BS_FF(a5)          ; BS_FF ablegen
        rts

* Routine errechnet Parameter fuer Sprung
NEWSPR:
        move.w          BS_Y(a5),d4           ; BS_Y -> d4
        move.w          BS_DE(a5),d6          ; BS_DE -> d6
        move.w          d4,d5
;        move.w          BS_YM2(a5),d5         ; BS_YM2 -> d5
        muls            #40,d6                ; BS_DE * 32
        add.w           d6,d5                 ; Y2 = BS_Y + 32* BS_DE
        move.w          d5,d6                 ; Y2 -> d6
        sub.w           d4,d6                 ; Y2 - Y1
        asr.w           #1,d6                 ; / 2
        add.w           d4,d6                 ; + Y1 = DY ( Mitte der Werte )
NEWPARAS2:
        move.w          d4,d7                 ; Y1 -> d7
        move.w          d5,d3                 ; Y2 -> d3
        muls            d3,d3                 ; Y2ý
        muls            d7,d7                 ; Y1ý
        sub.l           d7,d3                 ; Y2ý - Y1ý
        move.w          d4,d2                 ; Y1 -> d2
        sub.w           d5,d2                 ; Y1 - Y2
        divs            d2,d3                 ; d3 now YM
        move.w          d6,d2                 ; DY -> d2
        muls            d2,d2                 ; DYý
        move.w          d3,d1                 ; YM -> d1
        muls            d6,d1                 ; YM * DY
        move.w          d3,d0                 ; YM -> d0
        muls            d4,d0                 ; YM * Y1
        add.l           d1,d2                 ; DYý + YM*DY
        sub.l           d7,d2                 ; SUB Y1ý
        sub.l           d0,d2                 ; SUB YM * Y1

        move.l          d0,d4                 ; Rette d0 -> d4
        move.w          BS_ZM2(a5),d0         ; BS_ZM2 -> d0
        mulu            #32768,d0             ; * 32768
        move.l          d2,d1                 ; d2 -> d1
        spl             D2FLAG                ; Setze Pos/Neg-Flag
        bpl.s           D2NOTNEG              ; POS -> d2NotNeg
        neg.l           d1                    ; Negiere Devisor
D2NOTNEG:
        bsr             DIVU32                ; 32/32-Bit-Division
        move.l          d0,d1                 ; Ergebnis -> d1
        tst.b           D2FLAG                ; Teste Pos/Neg-Flag
        bne.s           DIVNOTNEG             ; POS -> DIVNotNeg
        neg.w           d1                    ; NEG Result
DIVNOTNEG:
;        move.l          d4,d0                 ; d0 restaurieren !
;        divs            d2,d1                 ; ZM / SW
        muls            d1,d3                 ; B = A * YM
        move.w          d1,d6                 ; A -> d6
        move.w          d1,d5                 ; A -> d5
        neg.w           d5                    ; NEG A
        ext.l           d5                    ; Erweitere A
        move.l          d7,d2                 ; Y1ý -> d2
        add.l           d4,d2                 ; ADD YM * Y1 !!!!!

        bsr             MULU32                ; 32 * 32 BIT
        add.l           d0,d0                 ; d0 * 2
        swap            d0                    ; / 32768

        move.w          d0,BS_ZM2(a5)
        move.w          d6,BS_FF1(a5)
        move.w          d3,BS_MXY(a5)
        rts
D2FLAG:         DC.W 0                  ; Pos/Neg-Flag

* Routine holt wichtige Werte aus BallPort in Register ( Bewegung )
GETINREGS:
        move.w          BS_Y(a5),d4           ; 3D-Y -> d4
        add.w           BS_DE(a5),d4          ; BS_Y = BS_Y + BS_DE
        move.w          d4,BS_Y(a5)           ; Setze BS_Y
        move.w          BS_FF(a5),d5          ; BS_FF -> d5
        move.w          BS_NEI(a5),d6         ; BS_NEI -> d6
        move.w          BS_ZM1(a5),d7         ; BS_ZM1 -> d7
        rts                                   ; Back to Call !

* Routine holt wichtige Werte aus BallPort in Register ( Sprung )
GETINREGS1:
        move.w          BS_Y(a5),d4           ; 3D-Y -> d4
        add.w           BS_DE(a5),d4          ; BS_Y = BS_Y + BS_DE
        move.w          d4,BS_Y(a5)           ; Setze BS_Y
        move.w          BS_FF1(a5),d5         ; BS_FF1 -> d5
        move.w          BS_MXY(a5),d6         ; BS_MXY -> d6
        move.w          BS_ZM2(a5),d7         ; BS_ZM2 -> d7
        rts                                   ; Back to Call !

* Bewege den Schlaeger mit Joystick
STICK:
        bsr             STICKFLAGS            ; Setze Flags der Bewegung (SP 1)
        bsr             STICK1FLAGS           ; Setze Flags der Bewegung (SP 2)
        bsr             MOVING                ; Bewege Spieler 1
        bsr             MOVING1               ; Bewege Spieler 2
        bsr             PLAYERDREID           ; Spieler 1 3D errechnen !
        bsr             PLAYER1DREID          ; Spieler 2 3D errechnen !
        rts                                   ; Back to Call !
NLPLAY:         DC.W 0

* Routine testet Hardware-Regs auf Joystick-Bewegung und Button
STICKFLAGS:
                IF REPLAY=2
        tst.b           NLPLAY
        bne.s           NORMALPL
        btst            #7,CIAAPRA
        seq             NLPLAY
        bra             PLAYJOY               ; Setze JoyStick !
NORMALPL:
                ENDC
        lea             JOYPORT(pc),a5        ; JoyStickPortBase -> a5

        btst            #7,CIAAPRA            ; Is Button pressed !
        seq             JP_BUTTON(a5)         ; Setze ButtonFlag !

        btst            #6,CIAAPRA            ; Ist linker MausKnopf ?
        seq             JP_MLBUTTON(a5)       ; Setze MLButton-Flag !

        btst            #10,$00dff016         ; Ist rechter MausKnopf ?
        seq             JP_MRBUTTON(a5)       ; Setze MRButton-Flag !

        move.w          JOY1DAT,d0            ; Hole Joystick-Stellung
        bsr             JOYSTICK              ; JoyStickFlags setzen !

                IF REPLAY=1
        bra             RECEIVEJOY            ; Nehme JoyStick auf !
                ENDC
        rts

* Routine setzte JoyStickFlags Port 1
STICK1FLAGS:
        tst.b           HUMANFL               ; 2. Spieler Mensch ?
        bne.s           TESTJOY               ; Ja -> TestJoy
        cmpi.w          #-1,NOTPL2            ; Serves Player2 ?
        beq             SIMULATSERVE          ; Simuliere JoystickFlags (Serv)!
        bra             SIMULATMOVE           ; Simuliere JoyStickFlags (Move)!
TESTJOY:
        lea             JOY1PORT(pc),a5       ; JoyStickPortBase -> a5
        btst            #6,CIAAPRA            ; Ist linker MausKnopf ?
        seq             JP_BUTTON(a5)         ; Setze Button-Flag !
        move.w          JOY0DAT,d0            ; Hole Joystick-Stellung

* Routine setzt JoyStick Flags ( links-rechts-oben-unten )
* Input:
*       d0 = JOYDAT-Inhalt
*       a5 = Pointer to JoyPort
JOYSTICK:
        move.w          d0,d1                 ; Stellung -> d1
        lsr.w           #1,d1                 ; >> d1
        eor.w           d0,d1                 ; EOR fuer Bit-Abfrage

        btst            #1,d0                 ; Teste rechts
        sne             JP_RIGHT(a5)          ; Setze Flag fuer rechts
        btst            #9,d0                 ; Teste links
        sne             JP_LEFT(a5)           ; Setze Flag fuer links
        btst            #0,d1                 ; Teste unten
        sne             JP_DOWN(a5)           ; Setze Flag fuer unten
        btst            #8,d1                 ; Teste oben
        sne             JP_UP(a5)             ; Setze Flag fuer oben
        rts                                   ; Back !

* Routine steuert Gegner global !
SIMULATMOVE:
        tst.b           BS_WHO+BALLPORT       ; Wer ist am Schlag !
        bne             FOLLOWBALL            ; Gegner -> FollowBall
GOMIDDLE:
        sf              FIRSTBFLAG            ; Clear FirstBFlag !
        clr.b           JOY1PORT+JP_BUTTON    ; Clear JoyStick !
        bsr             BUILTDELTAM           ; Bilde Deltas zum Mittelpunkt !
        cmpi.b          #BALLTIP,BS_TYPE+BALLPORT ; Ball am Tippen ?
        beq.s           MAKEFLAGS             ; Ja -> MakeFlags
        cmpi.b          #BALLTHR,BS_TYPE+BALLPORT ; Ball am Werfen ?
        beq.s           MAKEFLAGS             ; Ja -> MakeFlags
MAKEFLAGS:
        cmpi.w          #-100,BS_Y+BALLPORT   ; Ball ber Grenze ?
        blt             RETURN                ; Nein -> Ende
        bsr             GENFLAGS              ; Generiere anhand Deltas Flags !
        rts                                   ; Back !
FOLLOWBALL:
        tst.b           BS_NEW+BALLPORT       ; Hat 2. Spieler gerade geschl. ?
        beq.s           GOMIDDLE              ; Ja -> GoMiddle
        cmpi.b          #BALLSPR,BS_TYPE+BALLPORT ; Ball-im-Sprung !
        bne.s           DELTASTAYS            ; Nein -> Delta-Stays
        move.w          BS_X+BALLPORT,DESTX   ; Ball = DeltaX
        move.w          BS_Y+BALLPORT,DESTY   ; Ball = DeltaY
DELTASTAYS:
        bsr             BUILTDELTAB           ; Bilde Deltas zum Ball !
        bsr             HITBALL               ; Ball nah genug ?
        cmpi.w          #100,BS_Y+BALLPORT    ; Ball ber Grenze ?
        bgt             RETURN                ; Nein -> Ende
        bsr             GENFLAGS              ; Generiere anhand Deltas Flags !
        rts                                   ; Back !

* Routine schaut ob Deltas im ToleranzBereich und drckt Feuerknopf
HITBALL:
        clr.l           HITX                  ; Clear HitFlags !
        clr.l           HITEX                 ; Clear HitFlags !
        cmp.w           #-12,d0
        blt             TESTDY
        cmp.w           #12,d0
        slt             HITX
TESTDY:
        move.w          PL2PORT+P1_Y,d5       ; PlayerY -> d5
        sub.w           BS_Y+BALLPORT,d5      ; DeltaY
        cmp.w           #-52,d5               ; Ist Delta Y im ToleranzBereich
        blt.s           ALLHITTEST            ; Nein -> TestDZ
        cmp.w           #52,d5                ; Ist Delta Y im ToleranzBereich
        slt             HITY                  ; Ja -> Set HitY
ALLHITTEST:
        cmp.w           #-14,d5               ; Ist Delta Y im ToleranzBereich
        blt.s           BUTTONTEST            ; Nein -> ButtonTest
        cmp.w           #14,d5                ; Ist Delta Y im ToleranzBereich
        sle             HITEY                 ; Ja -> Set HitY
BUTTONTEST:
        move.l          HITX(pc),d3           ; HitX -> d3
        cmp.l           #$ffff0000,d3         ; Alle in Toleranz !
        bne             RETURN
        st              JOY1PORT+JP_BUTTON    ; Ja -> Druecke Feuerknopf !
        tst.b           HITEY                 ; Test DeltaY
        beq             RETURN
        sf              JOY1PORT+JP_BUTTON    ; Ja -> Loese Feuerknopf !
        rts

HITX:           DC.B 0                  ; HitFlag X-Toleranz
HITY:           DC.B 0                  ; HitFlag Y-Toleranz
HITZ:           DC.W 0                  ; HitFlag Z-Toleranz

HITEX:          DC.B 0                  ; HitFlag DX = 0
HITEY:          DC.B 0                  ; HitFlag DY = 0
HITEZ:          DC.W 0                  ; HitFlag DZ = 0

* Routine bildet Deltas Player 2 X-Y   Mitte X-Y
BUILTDELTAM:
        clr.l           JOY1PORT              ; Clear all JoyFlags !
        bsr             WHEREISMIDDLE         ; Errechne "MittelPunkt" ?
        movem.w         PL2PORT+P1_X,d0-d1    ; Player X-Y -> d0-d1
        sub.w           MIDDLEXM(pc),d0       ; DeltaX
        sub.w           MIDDLEYM(pc),d1       ; DeltaY
        ext.l           d0                    ; DeltaX = LangWort
        ext.l           d1                    ; DeltaY = LangWort
        move.w          MOVER1X(pc),d2        ; Mover1X -> d2
        beq.s           NONORMALX             ; = 0 -> NoNormalX
        divs            d2,d0                 ; DeltaX normalisieren !
NONORMALX:
        move.w          MOVER1Y(pc),d2        ; Mover1Y -> d2
        beq             RETURN                ; = 0 -> Ende
        divs            d2,d1                 ; DeltaY normalisieren !
        rts                                   ; Back !

* Routine errechnet Mittel-Punkt
WHEREISMIDDLE:
        tst.w           NOTPL1                ; Player 1 is on Serve !
        bpl.s           GETSTDMIDDLE          ; Ja -> GetStdMiddle
        btst            #0,PLAYPORT           ; Von welcher Seite ?
        bne.s           FROMLEFT              ; -> FromLeft
        move.w          SERVETABX(pc),MIDDLEXM ; Set MiddleXM
        subi.w          #86,MIDDLEXM
        move.w          #-280,MIDDLEYM        ; Set MiddleYM
        bra             RETURN                ; -> Ende
FROMLEFT:
        move.w          SERVETABX(pc),MIDDLEXM ; Set MiddleXM
;        move.w          #104,MIDDLEXM         ; Set MiddleXM
        addi.w          #62,MIDDLEXM
        move.w          #-280,MIDDLEYM        ; Set MiddleYM
        rts                                   ; Back !
GETSTDMIDDLE:
        cmpi.w          #-250,YSAVE           ; Ans Netz ?
        blt.s           NONETPOS              ; Nein -> NotNetPos
        move.w          #2048,d2              ; MaxRnd -> d2
        bsr             SPCRND                ; Get SpcRnd !
        cmp.w           #2030,d0              ; Netz oder Grundlinie ?
        bgt.s           ISONNET               ; Netz -> IsOnNet !
        tst.b           ISONNETFL             ; Ist am Netz ?
        bne.s           ISONNET               ; Ja -> IsOnNet !
NONETPOS:
        move.w          #0,MIDDLEXM           ; Set MiddleXM
        move.w          #-320,MIDDLEYM        ; Set MiddleYM
        rts                                   ; Back !
ISONNET:
        st              ISONNETFL             ; Setze OnNetFlag !
        move.w          #0,MIDDLEXM           ; Set MiddleXM
        move.w          #-30,MIDDLEYM         ; Set MiddleYM
        rts                                   ; Back !

* Routine bildet Deltas Player 2 X-Y   Ball X-Y
BUILTDELTAB:
        clr.l           JOY1PORT              ; Clear all JoyFlags !
        tst.b           FIRSTBFLAG            ; Erster Aufruf ?
        bne.s           MAKEDELTAS            ; Nein -> MakeDeltas
        bsr             GETDESTINATIONS       ; Errechne EndX und EndY
MAKEDELTAS:
        sf              ISONNETFL             ; Clear NetzFlag !
        movem.w         PL2PORT+P1_X,d0-d1    ; Player X-Y -> d0-d1
        add.w           RACKOFF(pc),d0        ; ADD RackOff
        sub.w           DESTX(pc),d0          ; d0 now DeltaX
        move.w          MOVER1X(pc),d2        ; Mover1X -> d2
        beq.s           NONORMALX1            ; = 0 -> NoNormalX1
        ext.l           d0                    ; DeltaX Langwort
        divs            d2,d0                 ; Koordinaten-Normalisieren
NONORMALX1:
        sub.w           DESTY(pc),d1          ; DeltaY
        move.w          MOVER1Y(pc),d2        ; Mover1Y -> d2
        beq             RETURN                ; = 0 -> Ende
        ext.l           d1                    ; DeltaY LangWort
        divs            d2,d1                 ; Koordinaten-Normalisieren !
        rts                                   ; Back !

RACKOFF:        DC.W 0                  ; Offset zum Racket
MIDDLEXM:       DC.W 0                  ; MitteX
MIDDLEYM:       DC.W 0                  ; MitteY
DESTX:          DC.W 0                  ; Destination X
DESTY:          DC.W 0                  ; Destination Y
FIRSTBFLAG:     DC.B 0                  ; FirstBFlag
ISONNETFL:      DC.B 0                  ; IsOnNetFl
YSAVE:          DC.W 0                  ; Save fuer Y-Schlag ( Ans Netz )

* Routine errechnet den Auftreffpunkt des Balles und ideale SchlagPosition
GETDESTINATIONS:
        st              FIRSTBFLAG            ; Set FirstBFlag !
        lea             BALLPORT(pc),a5       ; BallPortBase -> a5
        move.w          BS_YM1(a5),d3         ; BS_YM1 -> d3
        add.w           #-30,d3               ; d3 now DestY
        tst.w           MIDDLEXM              ; Aufschlag ?
        beq.s           NOSERVEHIT            ; Nein -> NoServeHit
        add.w           #-115,d3
NOSERVEHIT:
        tst.b           ISONNETFL             ; Steht Spieler am Netz ?
        beq.s           NOTONNET              ; Nein -> NotOnNet
        move.w          MIDDLEYM(pc),d3       ; NetPos -> d3
NOTONNET:
        move.w          d3,DESTY              ; Ablegen !
        sub.w           BS_ST(a5),d3          ; BS_Y - BS_ST
        ext.l           d3                    ; LangWort erweitern
        asl.l           #8,d3                 ; * 256
        divs            BS_M(a5),d3           ; BS_X = (BS_Y-BS_ST)*256)/BS_M
        cmp.w           PL2PORT+P1_X,d3       ; Left or right side ?
        bgt.s           TRYBACKHAND           ; BS_X POS -> TryBackHand
        move.w          #-28,RACKOFF          ; -28 -> RackOff
        bra.s           MAKEDESTX             ; -> MakeDestX
TRYBACKHAND:
        move.w          #22,RACKOFF           ; 22 -> RackOff
MAKEDESTX:
        move.w          d3,DESTX              ; DestX ablegen !
        rts                                   ; Back !

* Routine generiert anhand von DeltaX und DeltaY JoyStickFlags !
GENFLAGS:
        tst.w           d0                    ; DeltaX POS oder NEG
        beq.s           TESTDELTAY            ; = 0 -> TestDeltaY
        bpl.s           MAKELEFTFL            ; -> LeftFlag !
        move.w          #$00ff,JOY1PORT+JP_LEFT ; Make right !
        bra.s           TESTDELTAY            ; -> TestDeltaY
MAKELEFTFL:
        move.w          #$ff00,JOY1PORT+JP_LEFT ; Make left !
TESTDELTAY:
        tst.w           d1                    ; DeltaY POS oder NEG
        beq             RETURN                ; = 0 -> Ende
        bpl.s           MAKEDOWNFL            ; -> DownFlag !
        move.w          #$00ff,JOY1PORT+JP_UP ; Make Up !
        rts                                   ; Back !
MAKEDOWNFL:
        move.w          #$ff00,JOY1PORT+JP_UP ; Make down !
        rts                                   ; Back !

* Routine steuert Gegner beim Aufschlag !
SIMULATSERVE:
        cmpi.b          #BALLTIP,BS_TYPE+BALLPORT ; Tippen oder Werfen aktiv ?
        beq             LETSTHROW             ; Werfe Ball !
        sf              JOY1PORT+JP_BUTTON    ; Make Button unpressed !
        tst.b           FIRSTTHR              ; Erstes mal Wurf ?
        beq.s           NOTFIRSTTHR           ; Nein -> NotFirstThr !
        bsr             LETSMOVECROSS         ; -> LetsMoveCross
        sf              FIRSTTHR              ; Clear FirstThr !
NOTFIRSTTHR:
        move.w          CMOVER(pc),JOY1PORT   ; Make JoyStick left or right ?
        lea             SERVETABY(pc),a3      ; ServeTabY -> a3
        move.w          SERVEPOS(pc),d0       ; ServePos -> d0
        move.w          0(a3,d0.w),d5         ; DestY. -> d5
        neg.w           d5                    ; NEG It !
        move.w          SERVETABX(pc),d4      ; ServeTabX -> d5
        movem.w         BS_BX1+BALLPORT,d0-d3 ; Get OutBounds -> d0 - d3
        cmp.w           d0,d4                 ; OutX1 mit X-Cross
        ble             RETURN                ; Nein -> Ende
        cmp.w           d2,d4                 ; OutX2 mit X-Cross
        bge             RETURN                ; Nein -> Ende
        move.w          #2048,d2
        bsr             SPCRND
        cmp.w           #1800,d0
        blt.s           FURTHERMOVE1
        clr.w           CMOVER                ; No longer CrossMove !
FURTHERMOVE1:
        cmp.w           d1,d5                 ; OutY1 mit Y-Cross
        blt             RETURN                ; Nein -> Ende
        cmp.w           d3,d5                 ; OutY2 mit Y-Cross
        bgt             RETURN                ; Nein -> Ende
        st              JP_BUTTON+JOY1PORT
        rts                                   ; Back !

* Routine errechnet JoyStickbewegung fuer Fadenkreuz !
LETSMOVECROSS:
        btst            #0,PLAYPORT           ; Von welcher Seite ?
        bne.s           FROMLEFTSIDE          ; Links -> FromLeftSide
        move.w          #$00ff,CMOVER         ; Joy rechts -> Cmover !
        rts                                   ; Back !
FROMLEFTSIDE:
        move.w          #$ff00,CMOVER         ; Joy links -> Cmover !
        rts                                   ; Back !

* Routine steuert zweiten Spieler beim Tippen
LETSTHROW:
        tst.b           FIRSTTIPP             ; Erster Tipp ?
        bne.s           NOTFIRSTTIPP          ; Nein -> NotFirstTipp
        move.w          #100,d2               ; Obere RND-Grenze -> d2
        bsr             SPCRND                ; Get RND-Number
        add.w           #20,d0                ; ADD 1 second
        move.w          d0,DUPDEL             ; RND-Number -> TippDel
        sf              JOY1PORT+JP_BUTTON    ; Make Button unpressed !
        st              FIRSTTIPP             ; Set FirstTipp !
NOTFIRSTTIPP:
        addq.w          #1,DUPDELC            ; INC DupDelC
        move.w          DUPDEL(pc),d0         ; DupDel -> d0
        cmp.w           DUPDELC,d0            ; Delay erfuellt ?
        bgt             RETURN                ; Nein -> Ende ( weiter Tippen )
        st              JOY1PORT+JP_BUTTON    ; Make Button pressed !
        sf              FIRSTTIPP             ; Clear FirstTipp !
        st              FIRSTTHR              ; Set FirstThr !
        clr.w           DUPDELC               ; Clear DupDelC
        rts                                   ; Back !

FIRSTTIPP:      DC.B 0                  ; FirstTipp-Flag !
FIRSTTHR:       DC.B 0                  ; FirstThrow !
DUPDEL:         DC.W 0                  ; Wie lange wartet Spieler ?
DUPDELC:        DC.W 0                  ; Counter fuer TippWait !
CMOVER:         DC.W 0                  ; Bewegung fuer Kreuz

REPLAYBALL:
        lea             RECBUF,a0             ; RecBuf -> a0
        adda.w          -2(a0),a0             ; ADD RecJoy
        cmpi.l          #-1,(a0)              ; Ende des Replay !
        seq             REPLAYEXIT            ; ReplayEndeFlag setzen !
        beq             RETURN                ; Ja -> Ende
        movem.l         (a0),d0-d2            ; Get Coords from Buffer !
        movem.l         d0-d2,BS_X+BALLPORT   ; Coords in Ballport !
        addq.w          #6,RECJOY             ; INC BufferPointer !
        rts                                   ; Back !

RECBALL:
        lea             RECBUF,a0             ; RecBuf -> a0
        adda.w          -2(a0),a0             ; ADD RecJoy
        movem.l         BS_X+BALLPORT,d0-d2   ; Get X-Y-Z-Coordinates of Ball
        movem.l         d0-d2,(a0)            ; Save Coordinates !
        addq.w          #6,RECJOY             ; INC RecJoy !
        cmpi.w          #6000,RECJOY          ; End of Buffer ?
        blt             RETURN                ; Nein -> Ende
        clr.w           RECJOY                ; Make Start of Buffer !
        st              REPLAYPOS             ; Replay nicht mehr moeglich !
        rts                                   ; Back !

;                IF REPLAY=2
* Routine spielt Joystick-Deltas ab
PLAYJOY:
        move.w          RECJOY(pc),d1         ; RecJoy -> d1
        lea             RECBUF(pc),a5         ; Buffer -> a5
        mulu            #6,d1                 ; 1 Eintrag = 6 Bytes
;        cmpi.w          #$1234,0(a5,d1.w)     ; Ende ?
;        bne.s           NORECEND              ; Nein -> NoRecEnd
;        moveq           #0,d1                 ; Clear Eintrag
;        clr.w           GLDELAY               ; Loesche DelayCnt
;        clr.w           RECJOY                ; Loesche Eintrag !
NORECEND:
        move.w          GLDELAY(pc),d2        ; GLDelay -> d2
        cmp.w           0(a5,d1.w),d2         ; GL-Delay = DeltaDelay ?
        bne             RETURN                ; Nein -> Ende
        move.w          2(a5,d1.w),d0         ; Flags holen !
        addq.w          #1,RECJOY             ; INC RecJoy
        lea             JOYPORT(pc),a5        ; JoyStickPortBase -> a5
        btst            #1,d0                 ; Teste rechts
        sne             JP_RIGHT(a5)          ; Setze Flag fuer rechts
        btst            #0,d0                 ; Teste links
        sne             JP_LEFT(a5)           ; Setze Flag fuer links
        btst            #3,d0                 ; Teste unten
        sne             JP_DOWN(a5)           ; Setze Flag fuer unten
        btst            #2,d0                 ; Teste oben
        sne             JP_UP(a5)             ; Setze Flag fuer oben
        btst            #4,d0                 ; Button ?
        sne             JP_BUTTON(a5)         ; Setze Flag fuer Button !
        btst            #5,d0                 ; Ist linker MausKnopf ?
        sne             JP_MLBUTTON(a5)       ; Setze MLButton-Flag !
        btst            #6,d0                 ; Ist rechter MausKnopf ?
        sne             JP_MRBUTTON(a5)       ; Setze MRButton-Flag !
* Routine entpackt die RepFlags
DEPACKREPFLAGS:
        lea             RECBUF(pc),a5         ; Buffer -> a5
        lea             BALLPORT+BS_NEW,a0    ; FlagsBase -> a0
        move.w          4(a5,d1.w),d0         ; Flags -> d0
        move.b          d0,BS_TYPE+BALLPORT   ; Set BallMoveType
        lsr.w           #8,d0                 ; >> 8 d3
        moveq           #4,d7                 ; Init LoopCounter !
DEPACKLOOP:
        lsr.w           #1,d0                 ; >> 1 ( Flags )
        scs             (a0)+                 ; Carry-Set -> Flag Set
        dbra            d7,DEPACKLOOP         ; -> Loop
        rts                                   ; Back !
;                ENDC

;                IF REPLAY=1
* Routine nimmt Joystick-Deltas auf
RECEIVEJOY:
        bsr             PACKREPFLAGS          ; Packe ReplayFlags auf Wort
        lea             JOYPORT(pc),a5        ; JoyPortBase -> a5
        moveq           #0,d0                 ; GlobalFlags = 0
        tst.b           JP_LEFT(a5)           ; Test Flag !
        beq.s           NOJLEFT               ; Nein -> NoJLeft !
        bset            #0,d0                 ; Set Bit !
NOJLEFT:
        tst.b           JP_RIGHT(a5)          ; Test Flag !
        beq.s           NOJRIGHT              ; Nein -> NoJLeft !
        bset            #1,d0                 ; Set Bit !
NOJRIGHT:
        tst.b           JP_UP(a5)             ; Test Flag !
        beq.s           NOJUP                 ; Nein -> NoJLeft !
        bset            #2,d0                 ; Set Bit !
NOJUP:
        tst.b           JP_DOWN(a5)           ; Test Flag !
        beq.s           NOJDOWN               ; Nein -> NoJLeft !
        bset            #3,d0                 ; Set Bit !
NOJDOWN:
        tst.b           JP_BUTTON(a5)         ; Test Flag !
        beq.s           NOJBUTTON             ; Nein -> NoJLeft !
        bset            #4,d0                 ; Set Bit !
NOJBUTTON:
        tst.b           JP_MLBUTTON(a5)       ; Test Flag !
        beq.s           NOMLBUTTON            ; Nein -> NoMLButton !
        bset            #5,d0                 ; Set Bit !
NOMLBUTTON:
        tst.b           JP_MRBUTTON(a5)       ; Test Flag !
        beq.s           NOMRBUTTON            ; Nein -> NoMLButton !
        bset            #6,d0                 ; Set Bit !
NOMRBUTTON:
        cmp.w           OLDJFLAGS,d0          ; Is DeltaFlag ?
        beq.s           NODELTAJOY            ; Nein -> NoDeltaJoy !
MAKEJOYREC:
        move.w          RECJOY(pc),d1         ; RecJoy -> d1
        lea             RECBUF(pc),a5         ; Buffer -> a5
        mulu            #6,d1                 ; 1 Eintrag = 4 Bytes
        move.w          GLDELAY(pc),0(a5,d1.w) ; Delay ablegen !
        move.w          d0,2(a5,d1.w)         ; JoyFlags ablegen !
        move.w          d3,4(a5,d1.w)         ; RepJoyFlags ablegen !
        move.w          d0,OLDJFLAGS          ; JoyOldFlags ablegen !
        move.w          d3,OLDRFLAGS          ; RepOldFlags ablegen !
        addq.w          #1,RECJOY             ; INC RecJoy
        cmpi.w          #332,RECJOY           ; Buffer-Ende ?
        ble             RETURN                ; Nein -> Ende
        clr.w           RECJOY                ; RecJoy = 0
        clr.w           GLDELAY               ; GLDelay = 0
        rts                                   ; Back !
NODELTAJOY:
        cmp.w           OLDRFLAGS,d3          ; Auch keine RepFlags-Ver. ?
        bne             MAKEJOYREC            ; Ja -> MakeJoyRec
        rts                                   ; Back to Call !

OLDJFLAGS:      DS.W 1
OLDRFLAGS:      DS.W 1

* Routine packt die ReplayFlags auf ein Wort zusammen
PACKREPFLAGS:
        moveq           #0,d3                 ; Clear d3
        move.l          BS_FORE+BALLPORT,d0   ; Get FlagsSet !
        bsr             MAKEBITS              ; -> MakeBits
        move.l          BS_NEW+BALLPORT,d0    ; Get FlagsSet !
        bsr             MAKEBITS              ; -> MakeBits
        lsl.w           #8,d3                 ; << 8 d3
        or.b            BS_TYPE+BALLPORT,d3   ; OR BallMoveType
        rts                                   ; Back !
MAKEBITS:
        lsr.l           #8,d0                 ; >> 8
        roxl.w          #1,d3                 ; X-Flag -> d3
        lsr.l           #8,d0                 ; >> 8
        roxl.w          #1,d3                 ; X-Flag -> d3
        lsr.l           #8,d0                 ; >> 8
        roxl.w          #1,d3                 ; X-Flag -> d3
        lsr.l           #8,d0                 ; >> 8
        roxl.w          #1,d3                 ; X-Flag -> d3
        rts                                   ; Back !
;                ENDC

* Routine bewegt Sprite ( Spieler 1 )
MOVING:
        cmpi.w          #-1,NOTPL1            ; Service in Progress ?
        beq             RETURN                ; Ja -> Ende
        lea             JOYPORT(pc),a5        ; JoyPortBase -> a5
        lea             PL1PORT(pc),a3        ; Pl1PortBase -> a3
        movem.w         MOVERX(pc),d0-d1      ; Get X-Y INC -> d0-d1
        tst.b           JP_RIGHT(a5)          ; Test ob rechts
        beq.s           NORSTICK              ; Nein -> NoRStick
        add.w           d0,P1_X(a3)           ; INC X
        cmpi.w          #PLRX,P1_X(a3)        ; Bound Right ?
        ble.s           NORSTICK              ; Nein -> NoRStick
        move.w          #PLRX,P1_X(a3)        ; Set right Bound !
        sf              JP_RIGHT(a5)          ; Right = False !
NORSTICK:
        tst.b           JP_LEFT(a5)           ; Test ob links
        beq.s           NOLSTICK              ; Nein -> NoLStick
        sub.w           d0,P1_X(a3)           ; DEC X
        cmpi.w          #PLLX,P1_X(a3)        ; Bound Left ?
        bge.s           NOLSTICK              ; Nein -> NoLStick
        move.w          #PLLX,P1_X(a3)        ; Set left Bound !
        sf              JP_LEFT(a5)           ; Left = False !
NOLSTICK:
        tst.b           JP_UP(a5)             ; Test ob oben
        beq.s           NOUSTICK              ; Nein -> NoUStick
        sub.w           d1,P1_Y(a3)           ; DEC Y
        cmpi.w          #PLUY,P1_Y(a3)        ; Bound Up ?
        bge.s           NOUSTICK              ; Nein -> NoUStick
        move.w          #PLUY,P1_Y(a3)        ; Set up Bound !
        sf              JP_UP(a5)             ; Up = False !
NOUSTICK:
        tst.b           JP_DOWN(a5)           ; Test ob unten
        beq.s           NODSTICK              ; Nein -> NoDStick
        add.w           d1,P1_Y(a3)           ; INC Y
        cmpi.w          #PLDY,P1_Y(a3)        ; Bound Down ?
        ble.s           NODSTICK              ; Nein -> NoDStick
        move.w          #PLDY,P1_Y(a3)        ; Set down Bound !
        sf              JP_DOWN(a5)           ; Down = False !
NODSTICK:
        rts                                   ; Back !

* Routine bewegt Sprite ( Spieler 2 )
MOVING1:
        cmpi.w          #-1,NOTPL2            ; Service in Progress ?
        beq             RETURN                ; Ja -> Ende
        lea             JOY1PORT(pc),a5       ; JoyPortBase -> a5
        lea             PL2PORT(pc),a3        ; Pl2PortBase -> a3
        movem.w         MOVER1X(pc),d0-d1     ; Get X-Y INC -> d0-d1
        tst.b           JP_RIGHT(a5)          ; Test ob rechts
        beq.s           NORSTICK1             ; Nein -> NoRStick1
        add.w           d0,P1_X(a3)           ; INC X
        cmpi.w          #PL1RX,P1_X(a3)       ; Bound Right ?
        ble.s           NORSTICK1             ; Nein -> NoRStick1
        move.w          #PL1RX,P1_X(a3)       ; Set right Bound !
        sf              JP_RIGHT(a5)          ; Right = FALSE !
NORSTICK1:
        tst.b           JP_LEFT(a5)           ; Test ob links
        beq.s           NOLSTICK1             ; Nein -> NoLStick1
        sub.w           d0,P1_X(a3)           ; DEC X
        cmpi.w          #PL1LX,P1_X(a3)       ; Bound Left ?
        bge.s           NOLSTICK1             ; Nein -> NoLStick1
        move.w          #PL1LX,P1_X(a3)       ; Set left Bound !
        sf              JP_LEFT(a5)           ; Left = FALSE !
NOLSTICK1:
        tst.b           JP_UP(a5)             ; Test ob oben
        beq.s           NOUSTICK1             ; Nein -> NoUStick1
        sub.w           d1,P1_Y(a3)           ; DEC Y
        cmpi.w          #PL1UY,P1_Y(a3)       ; Bound Up ?
        bge.s           NOUSTICK1             ; Nein -> NoUStick1
        move.w          #PL1UY,P1_Y(a3)       ; Set up Bound !
        sf              JP_UP(a5)             ; Up = FALSE !
NOUSTICK1:
        tst.b           JP_DOWN(a5)           ; Test ob unten
        beq.s           NODSTICK1             ; Nein -> NoDStick1
        add.w           d1,P1_Y(a3)           ; INC Y
        cmpi.w          #PL1DY,P1_Y(a3)       ; Bound Down ?
        ble.s           NODSTICK1             ; Nein -> NoDStick1
        move.w          #PL1DY,P1_Y(a3)       ; Set down Bound !
        sf              JP_DOWN(a5)           ; Down = FALSE !
NODSTICK1:
        rts                                   ; Back !

                IFD  INTROSET
* Routine spielt Sound
MAKESONG:
        addi.w          #1,TIMER
        cmpi.w          #6,TIMER
        bne             NOPLAY
        clr.w           TIMER
        bsr             PLAYSOUND
NOPLAY: rts
                ENDC

* Audio-Interrupt-Routine ( IRQ Level 4 )
MYAUDIO:
;        move.w          #PINK,$00dff180
        movem.l         FULLSET,-(a7)         ; Save Regs on Stack !
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.w          INTREQR(a4),d0        ; INTREQ -> d0
        btst            #7,d0                 ; CHANNEL 0 ?
        beq.s           CHANNEL1              ; Nein -> Channel1
        move.w          #$0080,INTENA(a4)     ; Keine weiteren IRQ's mehr
        move.w          #$0080,INTREQ(a4)     ; CLEAR IRQREQ
        move.l          NULLSPRITE(pc),AUD0LCH(a4) ; PTR auf Nulldaten
        move.w          #2,AUD0LEN(a4)        ; Laenge auf 2 setzen
        sf              CHANNELS+0            ; Kanal nicht belegt !
CHANNEL1:
        btst            #8,d0                 ; CHANNEL 1 ?
        beq.s           CHANNEL2              ; Nein -> Channel2
        move.w          #$0100,INTENA(a4)     ; Keine weiteren IRQ's mehr
        move.w          #$0100,INTREQ(a4)     ; CLEAR IRQREQ
        move.l          NULLSPRITE(pc),AUD0LCH+$0010(a4) ; PTR auf Nulldaten
        move.w          #2,AUD0LEN+$0010(a4)  ; Laenge auf 2 setzen
        sf              CHANNELS+1            ; Kanal nicht belegt !
CHANNEL2:
        btst            #9,d0                 ; CHANNEL 2 ?
        beq.s           CHANNEL3              ; Nein -> Channel3
        move.w          #$0200,INTENA(a4)     ; Keine weiteren IRQ's mehr
        move.w          #$0200,INTREQ(a4)     ; CLEAR IRQREQ
        move.l          NULLSPRITE(pc),AUD0LCH+$0020(a4) ; PTR auf Nulldaten
        move.w          #2,AUD0LEN+$0020(a4)  ; Laenge auf 2 setzen
        sf              CHANNELS+2            ; Kanal nicht belegt !
CHANNEL3:
        btst            #10,d0                ; CHANNEL 3 ?
        beq.s           MYAUDIOE              ; Nein -> Ende
        move.w          #$0400,INTENA(a4)     ; Keine weiteren IRQ's mehr
        move.w          #$0400,INTREQ(a4)     ; CLEAR IRQREQ
        move.l          NULLSPRITE(pc),AUD0LCH+$0030(a4) ; PTR auf Nulldaten
        move.w          #2,AUD0LEN+$0030(a4)  ; Laenge auf 2 setzen
        sf              CHANNELS+3            ; Kanal nicht belegt !
MYAUDIOE:
        movem.l         (a7)+,FULLSET         ; Get Regs from Stack !
;        move.w          #BLACK,$00dff180
        rte

;                DC.W $4ef9              ; JMP-Opcode
MYAUDIOEND:
                DC.L 0

* Tastaturabfrage ( IRQ Level 2 )
MYTAST:
        move.w          #$0f00,$00dff180
        movem.l         FULLSET,-(a7)         ; Save Regs on Stack
        moveq           #0,d0
        move.b          $00bfec01,d0          ; Hole Tastencode
        not.b           d0                    ; Invertiere Code
        ror.b           #1,d0                 ; Rotiere
;        btst            #7,d0                 ; Test ob gedrckt
;        bne.s           NOTPRESSED            ; Nein -> NotPressed
;        andi.b          #$7f,d0               ; Loesche Pressed-Bit
;        ext.w           d0                    ; Word erweitern
;        bsr             KEYQUEST              ; Abfrage !
        move.b          d0,LASTTAST           ; Taste ablegen !
NOTPRESSED:
        movem.l         (a7)+,FULLSET         ; Get Regs from Stack !
        move.w          #$00,$00dff180
                DC.W $4ef9              ; JMP-Opcode
MYTASTEND:      DC.L 0

LASTTAST:       DC.W 0                  ; Taste

KEYQUEST:
        lea             KEYFUNC(pc),a0        ; Funktionstabelle -> a0

        cmp.w           #$0010,d0             ; Is > RawCode (Q)
        blt.s           NOFUNC                ; Nein -> NoFunc
        cmp.w           #$0014,d0             ; Is < RawCode (T)
        ble.s           WINKEL1               ; Ja -> Winkel1
        cmp.w           #$004c,d0             ; Is > RawCode (^)
        blt.s           NOFUNC                ; Nein -> NoFunc
        cmp.w           #$004f,d0             ; Is < RawCode (Down)
        ble.s           WINKEL2               ; Ja -> Winkel2
NOFUNC: rts                                   ; Back to Call !

WINKEL1:
        sub.w           #$0010,d0             ; SUB RawCode (Q)
        lsl.w           #2,d0                 ; * 2 fuer Langwort-Zugriff
        movea.l         16(a0,d0.w),a0        ; ADR of Rout -> a0
        jsr             (a0)                  ; -> Function
        rts

WINKEL2:
        sub.w           #$004c,d0             ; SUB RawCode (^)
        lsl.w           #2,d0                 ; * 2 fuer Langwort-Zugriff
        movea.l         0(a0,d0.w),a0         ; ADR of Rout -> a0
        jsr             (a0)                  ; -> Function
        rts

;                                Keyfunctions
;===============================================================================
CUP:
        subi.w          #10,DISREG            ; Regle Distance
        subi.w          #10,DIS1REG           ; & Center
        rts

CDOWN:
        addi.w          #10,DISREG            ; Regle Distance
        addi.w          #10,DIS1REG           ; & Center
        rts

CRIGHT: addi.w          #TURNVALUE,W1REG      ; Regle Winkel1 (-)
        cmpi.w          #360,W1REG
        ble.s           WK1
        subi.w          #360,W1REG
WK1:    rts

CLEFT:  subi.w          #TURNVALUE,W1REG      ; Regle Winkel1 (+)
        cmpi.w          #0,W1REG
        bge.s           WK3
        addi.w          #360,W1REG
WK3:    rts

CTQ:    subi.w          #TURNVALUE,W3REG      ; Regle Winkel3 (+)
        cmpi.w          #0,W3REG
        bge.s           WK6
        addi.w          #360,W3REG
WK6:    rts

CTW:    addi.w          #TURNVALUE,W3REG      ; Regle Winkel3 (-)
        cmpi.w          #360,W3REG
        ble.s           WK5
        subi.w          #360,W3REG
WK5:    rts

CTE:    addi.w          #TURNVALUE,W2REG      ; Regle Winkel2 (-)
        cmpi.w          #360,W2REG
        ble.s           WK2
        subi.w          #360,W2REG
WK2:    rts

CTR:    subi.w          #TURNVALUE,W2REG      ; Regle Winkel2 (+)
        cmpi.w          #0,W2REG
        bge.s           WK4
        addi.w          #360,W2REG
WK4:    rts
;===============================================================================

* Routine nimmt die Platzbewegungen in Buffer auf
                RSRESET
RD_W1:          RS.W 1                  ; W1 einer Bewegung
RD_W2:          RS.W 1                  ; W2 einer Bewegung
RD_W3:          RS.W 1                  ; W3 einer Bewegung
RD_RHO:         RS.W 1                  ; ZentralPunktPer. einer Bewegung
RD_DIS:         RS.W 1                  ; Distance einer Bewegung
RD_SIZEOF:      RS.W 0                  ; Groesse einer Definition

RECEIVEMOTION:
                IF RECEIVE=0
        rts
                ENDC
        movem.l         FULLSET,-(a7)
        lea             MOTIONPORT(pc),a0     ; MotionPortBase -> a0
        move.w          ACTMOTION(pc),d0      ; Nummer des Frames -> d0
        mulu            #RD_SIZEOF,d0         ; * Groesse eines Eintrags
        lea             0(a0,d0.w),a0         ; Offset addieren
        move.w          W1REG(pc),(a0)+       ; Trage Daten ein !
        move.w          W2REG(pc),(a0)+       ; Trage Daten ein !
        move.w          W3REG(pc),(a0)+       ; Trage Daten ein !
        move.w          DISREG(pc),(a0)+      ; Trage Daten ein !
        move.w          DIS1REG(pc),(a0)+     ; Trage Daten ein !
        addq.w          #1,ACTMOTION          ; INC Frame !
        movem.l         (a7)+,FULLSET
        rts                                   ; Back !

* Routine initialisiert fuenf Planes
MAKEFIVEPLANES:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #$5000,BITMODUL(a6)   ; Bitmodul = 5 Planes ( Lo-Res )
        move.w          #5,SCRPLANES(a6)      ; Bitplanes = 5
        move.w          #4,SCRPLANESC(a6)     ; Bitplanes - 1 = 4
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLAYFINIT             ; Like RethinkDisplay !
        rts                                   ; Back

* Routine initialisiert vier Planes
MAKEFOURPLANES:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #$4000,BITMODUL(a6)   ; Bitmodul = 4 Planes ( Lo-Res )
        move.w          #4,SCRPLANES(a6)      ; Bitplanes = 4
        move.w          #3,SCRPLANESC(a6)     ; Bitplanes - 1 = 3
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLAYFINIT             ; Like RethinkDisplay !
        rts                                   ; Back

* Routine initialisiert zwei Planes
MAKETWOPLANES:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #$2000,BITMODUL(a6)   ; Bitmodul = 2 Planes ( Lo-Res )
        move.w          #2,SCRPLANES(a6)      ; Bitplanes = 2
        move.w          #1,SCRPLANESC(a6)     ; Bitplanes - 1 = 1
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLAYFINIT             ; Like RethinkDisplay !
        rts                                   ; Back

* Routine bereitet alles fuer Scrolling vor
SETSCROLL:
        lea             SCRPORT(pc),a0        ; ScreenPortBase -> a0
        lea             SCRWIDTH(a0),a0       ; ADD Offset
        lea             TEMPBUFFER(pc),a1     ; TempBufferBase -> a1
        move.w          #(SPOSY-SCRWIDTH)/2-1,d7 ; Init LoopCounter !
        bsr             CPUCOPY               ; -> CpuCopy
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #58,BMODULO(a6)       ; Setze BitPlaneModulo !
        clr.w           SPOSX(a6)             ; ScrollX = 0
        clr.w           SPOSY(a6)             ; ScrollY = 0
        move.l          PLANES(a6),d0         ; Hole 1. PlanePtr
        move.l          d0,PLANES(a6)         ; Lege 1. PlanePtr ab
        add.l           #40000,d0             ; ADD 2. Plane-Offset
        move.l          d0,PLANES+4(a6)       ; Lege 2. PlanePtr ab
        move.w          #100,ONELINEB(a6)     ; OneLineB = 100
        move.w          #50,ONELINE(a6)       ; OneLine = 50
        move.l          #40000,ONEPLANE(a6)   ; OnePlane = 40000
        move.w          #400,SCRHEIGHT(a6)    ; Hoehe = 400 Zeilen
        subi.w          #$0008,DISFSTART(a6)  ; DEC DataFetchStart !
        move.w          #$00,BSCROLL(a6)      ; Set BitScroll !
        bsr             GENERATEMUL           ; MakeMultiTable
        rts                                   ; Back !

* Routine stellt vom ScrollZustand den alten Zustand wieder her
SETNOSCROLL:
        lea             SCRPORT(pc),a1        ; ScreenPortBase -> a1
        lea             SCRWIDTH(a1),a1       ; ADD Offset
        lea             TEMPBUFFER(pc),a0     ; TempBufferBase -> a0
        move.w          #(SPOSY-SCRWIDTH)/2-1,d7 ; Init LoopCounter !
        bsr             CPUCOPY               ; -> CpuCopy
        bsr             GENERATEMUL           ; MultiTable erstellen !

* Routine setzt Parameter in Clist ein
RETHINKDIS:
        bsr             WAITBEAM              ; Warte auf Strahl !
        bsr             PLANEINIT             ; PlanePtr in Clist
        bra             PLAYFINIT             ; HardwareDaten in Clist

* Routine eroeffnet 1. Schirm
FIRSTDISPLAY:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          #WIDTH,SCRWIDTH(a6)   ; Breite setzen
        move.w          #HEIGHT,SCRHEIGHT(a6) ; Hoehe setzen
        move.w          #BITPLANES,SCRPLANES(a6) ; Tiefe setzen
        bsr             MAKEMYCOL             ; MakeMyColors

        bsr             MAKESCREEN            ; Errechne ScreenDaten
        bsr             GETSCREENMEM          ; Hole Speicher fuer Bildschirm
        bsr             GENERATEMUL           ; Generiere MultiplikationsTab.
        bsr             CLISTINCHIP           ; CopperList 100%ig in Chip
        bsr             FILLCLIST             ; Fuelle Clist aus
        bsr             OPENSCREEN            ; Install Screen !
        rts                                   ; Back to Call !

* Kopiere CopperListe in ChipRam falls n”tig
CLISTINCHIP:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             COPPERSTART(pc),a0    ; CopperEnde -> a0
        move.l          #COPPERSIZE,d7        ; Size -> d7
        bsr             INCHIP                ; Lege Daten ins ChipRam
        move.l          d0,COPPTR(a6)         ; Lege Daten ab !

        rts                                   ; Back to Call !

* Routine kopiert Daten Word-orientiert
* Input:
*       a0  =  Zeiger auf Source
*       a1  =  Zeiger auf Destination
*       d7  =  Laenge-1 = LoopCounter
CPUCOPY:
        move.w          (a0)+,(a1)+           ; Copy Data
        dbra            d7,CPUCOPY            ; -> Loop
        rts
* Routine allociert ChipMem und kopiert, falls noetig
* Input:
*       a0 =  Adresse des Blocks
*       d7 =  Laenge des Blocks
* Output:
*       d0 =  Adresse des Blocks (neu o. alt)
INCHIP:
        cmpa.l          #MAXCHIP,a0           ; Is in Chip ?
        bge.s           NOTINCHIP             ; Nein -> NotInChip
        move.l          a0,d0                 ; OldAdr -> d0
        rts                                   ; Back to Call !
NOTINCHIP:
        move.l          d7,d0                 ; Laenge -> d0
        bsr             GETCHIPMEM            ; Hole ChipMem
        movea.l         d0,a1                 ; BaseAdr -> a1
        lsr.w           #1,d7                 ; / 2 fuer Wortweises Kopieren
        subq.w          #1,d7                 ; DEC LoopCounter
        bsr             CPUCOPY               ; Copy Block !
        rts                                   ; Back to Call !

* Routine installiert CopperListe
OPENSCREEN:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.l          COPPTR(a6),COP1LCH(a4) ; Setze CopperPointer
        move.w          #$8380,$0096(a4)      ; DMA on
        move.w          a0,COPJMP1(a4)        ; Start Copper !
        rts                                   ; Back

* Trage wichtige Daten in Copperliste ein
FILLCLIST:
        bsr             PLANEINIT             ; PlanePtr eintragen
        bsr             PLAYFINIT             ; Init PlayFieldDatas
        bsr             INITSPRITES           ; Sprites initialisieren
        rts

* Routine generiert die Multiplikations-Tabelle der RasterZeilen
GENERATEMUL:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6

        lea             MULU160(a6),a5        ; Offset auf Tabelle
        moveq           #0,d0                 ; Clear d0
        move.w          SCRHEIGHT(a6),d7      ; Hoehe -> d7 = LoopCounter
        subq.w          #1,d7                 ; DEC LoopCounter
        move.w          ONELINEB(a6),d1       ; Breite in Bytes -> d1
        ext.l           d1                    ; LangWort erweitern !
MULLOOP:
        move.w          d0,(a5)+              ; Generiere Tabelle
        add.l           d1,d0                 ; Add OnelineB
        dbra            d7,MULLOOP
        rts

* Routine generiert die Offset-Tabelle der Weltrangliste
GENERATEOFFS:
        lea             RANKOFFS(pc),a0       ; RankOffsBase -> a0
        moveq           #0,d0                 ; Clear OffsetMark
        moveq           #MAXRANKS-1,d7        ; Anzahl der Maximalen Eintrage
GENOFFSLOOP:
        move.w          d0,(a0)+              ; Offset ablegen !
        add.w           #PL_SIZEOF,d0         ; INC Offset
        dbra            d7,GENOFFSLOOP        ; -> Loop
        rts                                   ; Back !

* Routine generiert neue Farbpaletten fuer Replay und Platz
* Input:
*       a0 = Pointer to Colorvalues
GENERATECOLS:
        lea             BS00(pc),a1           ; Base of ColorTables -> a1
        lea             REPCOLS(pc),a2        ; RepColsBase -> a2
        moveq           #5,d7                 ; Init LoopCounter ( 5 Col.Change)
        moveq           #127,d6               ; Init LoopCounter ( 128 Values )
GENCOLSALOOP:
        move.w          (a2),d0               ; DestColor -> d0
        move.w          (a0)+,d1              ; SourceColor -> d1
GENCOLSILOOP:
        cmp.w           (a1)+,d0              ; Is DestColor in Table ?
        bne.s           GENMAKECOL            ; Nein -> GenMakeCol
        move.w          d1,-2(a1)             ; Ja -> SourceColor eintragen
GENMAKECOL:
        dbra            d6,GENCOLSILOOP       ; -> Loop
        moveq           #127,d6               ; Init LoopCounter ( 128 Values )
        move.w          d1,(a2)+              ; SourceCol = New DestCol.
        lea             BS00(pc),a1           ; Base of ColorTables -> a1
        dbra            d7,GENCOLSALOOP       ; -> Loop
        rts                                   ; Back !

* Routine holt Speicher fuer Playfield
GETSCREENMEM:
        lea             SCRPORT(pc),a5        ; ScreenPortBase -> a5
        tst.l           PLANEBASE             ; Ist PlaneBase allociert ?
        bne.s           PLANEAVAIL            ; Ja -> PlaneAvail
        move.l          ALLPLANES(a5),d0      ; AllPlanes -> d0
        add.l           d0,d0                 ; AllPlanes * 2 fuer DOUBLE
        bsr             GETCHIPMEM            ; Hole ChipMem !
        move.l          d0,PLANEBASE          ; PlaneBase ablegen
PLANEAVAIL:
        move.l          PLANEBASE(pc),d0      ; PlaneBase holen
        move.w          SCRPLANESC(a5),d7     ; d7 = LoopCounter
        lea             PLANES(a5),a0         ; PlanePort -> a0
SCRPORTLOOP:
        move.l          d0,(a0)+              ; Pointer ablegen
        add.l           ONEPLANE(a5),d0       ; Groesse einer Plane addieren
        dbra            d7,SCRPORTLOOP        ; -> Loop

        sub.l           ONEPLANE(a5),d0       ; DEC OnePlane
        move.l          d0,BCKBACK1           ; 5. Plane = BCKBuffer 1

        add.l           ONEPLANE(a5),d0       ; INC OnePlane
        move.w          SCRPLANESC(a5),d7     ; d7 = LoopCounter
        lea             DPPORT(pc),a0         ; DoublePlanePort -> a0
SCRPORTLOOP1:
        move.l          d0,(a0)+              ; Pointer ablegen
        add.l           ONEPLANE(a5),d0       ; Groesse einer Plane addieren
        dbra            d7,SCRPORTLOOP1       ; -> Loop

        sub.l           ONEPLANE(a5),d0       ; DEC OnePlane
        move.l          d0,BCKBACK2           ; 5. DoublePlane = BCKBuffer 2
        rts                                   ; Back to Call !
* Routine sortiert PlanePointer wieder
SORTPLANES:
        lea             SCRPORT(pc),a5        ; ScreenPortBase -> a5
        move.l          PLANEBASE(pc),d0      ; PlaneBase holen
        moveq           #BITPLANES-1,d7       ; d7 = LoopCounter
        lea             PLANES(a5),a0         ; PlanePort -> a0
SORTPLLOOP1:
        move.l          d0,(a0)+              ; Pointer ablegen
        add.l           #8000,d0              ; Groesse einer Plane addieren
        dbra            d7,SORTPLLOOP1        ; -> Loop

        moveq           #BITPLANES-1,d7       ; d7 = LoopCounter
        lea             DPPORT(pc),a0         ; DoublePlanePort -> a0
SORTPLLOOP2:
        move.l          d0,(a0)+              ; Pointer ablegen
        add.l           #8000,d0              ; Groesse einer Plane addieren
        dbra            d7,SORTPLLOOP2        ; -> Loop
        rts                                   ; Back !

* Routine initialisiert die PlanePointer
PLANEINIT:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             PLANES(a6),a0         ; PortBase -> a0
        move.w          SCRPLANESC(a6),d7     ; Anzahl der Planes-1 -> d7
        movea.l         COPPTR(a6),a1         ; ADR der CopperListe -> a1
        addq.w          #6,a1                 ; Offset fuer ersten Eintrag

COPPERPLANELOOP:
        move.l          (a0)+,d0              ; Planesadr -> d0
        move.w          d0,(a1)               ; CopperEintraege generieren
        swap            d0
        move.w          d0,-4(a1)
        addq.w          #8,a1                 ; Add an Offset !
        dbra            d7,COPPERPLANELOOP    ; -> Loop

        rts

* Routine initialisiert Daten fuer Playfield in CopperList
PLAYFINIT:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6

        movea.l         COPPTR(a6),a0         ; Basis der Daten in CopperList
        lea             COPPERSCROFF(a0),a0   ; Beginn der ScreenDaten addieren

        move.w          BITMODUL(a6),2(a0)    ; BPLCON0 - INPUT
        move.w          DISSTART(a6),6(a0)    ; DIWSTRT - INPUT
        move.w          DISSTOP(a6),10(a0)    ; DIWSTOP - INPUT
        move.w          DISFSTART(a6),14(a0)  ; DDFSTRT - INPUT
        move.w          DISFSTOP(a6),18(a0)   ; DDFSTOP - INPUT
        move.w          BMODULO(a6),30(a0)    ; Setze Modulo !
        move.w          BMODULO(a6),34(a0)    ; Setze Modulo !
        move.w          BSCROLL(a6),d0        ; BitScoller -> d0
        move.w          d0,d1                 ; BitScroller -> d1
        lsl.w           #4,d1                 ; BitScroller Even d1
        or.w            d1,d0                 ; OR d1 d0
        move.w          d0,22(a0)             ; Set BitScroll!
        rts

* Routine initialisiert Spritepointer in CopperListe
INITSPRITES:
        tst.l           NULLSPRITE            ; Ist bereits Speicher allociert ?
        bne.s           GOTNULLSPRITE         ; Ja -> GotNullSprite
        moveq           #8,d0                 ; 8 Bytes Null-Sprite
        bsr             GETCHIPMEM            ; Hole ChipMemory
        move.l          d0,NULLSPRITE         ; Allocierter Speicher -> NullSpr.
GOTNULLSPRITE:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        lea             SPRTABLE(pc),a5       ; SpriteTableBase -> a5
        lea             ST_TAB(a5),a1         ; Base of Table -> a1
        move.l          NULLSPRITE(pc),d1     ; NullSpriteBase -> d1
        movea.l         COPPTR(a6),a0         ; CopperListAdr -> a0
        lea             COPPERSPROFF+6(a0),a0 ; Beginn der SpriteDaten der Liste
        move.w          ST_USE(a5),d2         ; Used_Flags -> d2
        moveq           #0,d7                 ; Clear LoopCounter
INITSPRLOOP:
        lsr.w           #1,d2                 ; >> d2
        bcc.s           ONZERO                ; C clear -> OnZero

        move.l          0(a1,d7.w),d0         ; Pointer auf SprDatas -> d0
        add.l           #CONTROL,d0           ; Offset auf ControlWort addieren

        move.w          d0,(a0)               ; Trage unteres Word in Clist
        swap            d0                    ; Swap it !
        move.w          d0,-4(a0)             ; Trage oberes Word in Clist
        bra.s           MAKELOOP              ; -> MakeLoop
ONZERO:
        move.w          d1,(a0)               ; Trage unteres Word in Clist
        swap            d1                    ; Swap it !
        move.w          d1,-4(a0)             ; Trage oberes Word in Clist
        swap            d1                    ; ReSwap it !
MAKELOOP:
        addq.w          #8,a0                 ; Addiere Offset auf n. Clist.Ein.
        addq.w          #4,d7                 ; +4 da Langwoerter
        cmp.w           #32,d7                ; Is Ende erreicht !
        blt.s           INITSPRLOOP           ; Nein -> Loop

        rts                                   ; Back to Call !

* Routine errechnet aus der Breite und Hoehenangabe im GrafikPort die Werte
* fuer die AmigaHardWare
MAKESCREEN:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        move.w          SCRWIDTH(a6),d0       ; Breite -> d0
        move.w          SCRHEIGHT(a6),d1      ; Hoehe -> d1
        move.w          d0,d2                 ; Breite -> d2
        lsr.w           #4,d2                 ; d2 now Breite in Words
        move.w          d2,ONELINE(a6)        ; Breite in Words eintragen
        add.w           d2,d2                 ; * 2 Breite in Bytes
        move.w          d2,ONELINEB(a6)       ; Zeile in Bytes
        mulu            d1,d2                 ; * Hoehe = OnePlane
        move.l          d2,ONEPLANE(a6)       ; OnePlane ablegen
        mulu            SCRPLANES(a6),d2      ; * Tiefe = AllPlanes
        move.l          d2,ALLPLANES(a6)      ; AllPlanes ablegen !
        move.w          SCRPLANES(a6),d0      ; Planes -> d0
        subq.w          #1,d0                 ; DEC Planes
        move.w          d0,SCRPLANESC(a6)     ; Planes - 1 ablegen
        move.w          #$2c81,DISSTART(a6)   ; DisplayStart ablegen
        move.w          #$f4c1,DISSTOP(a6)    ; DisplayStop ablegen
        move.w          #56,DISFSTART(a6)     ; FetchStart ablegen
        move.w          #208,DISFSTOP(a6)     ; FetchStop ablegen
        move.w          #44,DVY(a6)           ; Display-Offset Y ablegen
        move.w          #129,DHX(a6)          ; Display-Offset X ablegen
        move.w          #$5000,BITMODUL(a6)   ; BitModul ablegen
        rts                                   ; Back

* Kleine ErrorBehandlung
WRONG:
        trap            #0                    ; Trap
        rts                                   ; Sollte nicht vorkommen

* Routine holt Dateilaenge und laedt diese ins ChipMem
POWERLOAD:
        move.l          a0,-(a7)              ; FileNamePointer -> Stack
        bsr             GETLENGTH             ; Hole Laenge des Files
        tst.l           d0                    ; Test d0
        bmi             WRONG                 ; Is neg -> Wrong
        move.l          d0,MEMSIZE            ; Rette Size
        bsr             GETCHIPMEM            ; Hole Speicher !
        move.l          d0,MEMPTR             ; Rette Base of Mem

        movea.l         (a7)+,a0              ; FileName -> a0
        bsr             OPENFILE              ; Open File
        bsr             GETFILE               ; Read File
        bsr             CLOSEFILE             ; Close File
        rts                                   ; Back to Call !

* Routine liest Neochrome-Bild in Bildschrim des Doublebuffers ein
GETINBUFFER:
        move.l          DPPORT,MEMPTR         ; Buffer -> MemPtr
        move.l          #32128,MEMSIZE        ; Laenge = 32128
        bsr             OPENFILE              ; Open File
        bsr             GETFILE               ; Read File
        bra             CLOSEFILE             ; Close File

                IFD  INTROSET
* Routine liest Sound fuer Intro ein
READSONG:
        movea.l         4,a6                  ; ExecBase -> a6
        move.l          #SOUND1LEN,d0         ; 100 KB CHIP
        move.l          #MEMSET,d1            ; Brauche CHIP
        jsr             ALLOCMEM(a6)          ; Alloc It !
        tst.l           d0                    ; Habe ich es bekommen ?
        beq.s           QWRONG                ; Nein -> Wrong
        move.l          d0,SONGPOINTER        ; d0 -> SongPointer !
        move.l          d0,MEMPTR             ; Buffer -> MemPtr
        move.l          #SOUND1LEN,MEMSIZE    ; Laenge = 32128
        lea             SONGNAME(pc),a0       ; FileName -> a0
        bsr             OPENFILE              ; Open File
        bsr             GETFILE               ; Read File
        bsr             CLOSEFILE             ; Close File
        rts                                   ; Back to Call !

QWRONG:
                DC.W 1111
                ENDC
* Routine liest File
* Input:
*       Handle = ActHandle
*       Buffer = MemPtr
*       Length = MemSize
* Output:
GETFILESET:     REG d0-a6
GETFILE:
        movem.l         GETFILESET,-(a7)      ; Save Regs on Stack

        movea.l         DOSBASE(pc),a6        ; DosBase -> a6

        move.l          ACTHANDLE(pc),d1      ; Handle -> d1
        move.l          MEMPTR(pc),d2         ; Buffer -> d2
        move.l          MEMSIZE(pc),d3        ; Size -> d3

        jsr             READ(a6)              ; Read It!

        move.l          MEMSIZE(pc),d1        ; Size -> d1
        cmp.l           d0,d1                 ; Is Readed Length = Requ. Length
        bne             WRONG                 ; Nein -> Wrong

        movem.l         (a7)+,GETFILESET      ; Get Regs from Stack
        rts                                   ; Back to Call !


* Routine schliežt File
* Input:
*       Handle = ActHandle
CLOSEFILESET:   REG d0-a6
CLOSEFILE:
        movem.l         CLOSEFILESET,-(a7)    ; Save Regs on Stack

        movea.l         DOSBASE(pc),a6        ; DosBase -> a6

        move.l          ACTHANDLE(pc),d1      ; Handle -> d1
        jsr             CLOSE(a6)             ; Close It!

        movem.l         (a7)+,CLOSEFILESET    ; Get Regs from Stack
        rts

* Routine oeffnet File
* Input:
*       a0 = Pointer to Filename
* Output:
*       Handle -> Acthandle
*       Handle -> d0
OPENFILESET:    REG d1-a6
OPENFILE:
        movem.l         OPENFILESET,-(a7)     ; Save Regs on Stack

        movea.l         DOSBASE(pc),a6        ; DosBase -> a6

        move.l          a0,d1                 ; Name of File -> d1
        move.l          #1005,d2              ; Mode_Old -> d2
        jsr             OPEN(a6)              ; Open It!
        tst.l           d0                    ; Test, ob erfolgreich
        beq             WRONG                 ; Nein -> Wrong

        lea             ACTHANDLE(pc),a0      ; ActHandle -> a0
        move.l          d0,(a0)               ; Lege Handle ab

        movem.l         (a7)+,OPENFILESET     ; Get Regs from Stack
        rts                                   ; Back to Call !


* Routine holt Laenge eines Files
GETLENGTH:
        movea.l         DOSBASE(pc),a6        ; DosBase -> a6

        move.l          a0,d1                 ; Pointer -> d1
        moveq           #-2,d2                ; Modu fuer Lock -> d2
        jsr             LOCK(a6)              ; Get Lock !
        tst.l           d0                    ; Test ob erfolgreich
        beq             LENGTHERROR           ; Nein -> Lengtherror
        move.l          d0,LOCKPTR            ; Rette Lock -> LockPtr

        move.l          d0,d1                 ; Lock -> d1
        lea             FILEINFODATA(pc),a0   ; FileInfoDataBase -> a0
        move.l          a0,d2                 ; Base (a0) -> d2

        jsr             EXAMINE(a6)           ; Examine It !
        tst.l           d0                    ; Test, ob erfolgreich
        beq             LENGTHERROR           ; Nein -> Lengtherror

        move.l          LOCKPTR(pc),d1        ; Lock -> d1
        jsr             UNLOCK(a6)            ; UnLock It!

        lea             FILEINFODATA(pc),a0   ; FileInfoDataBase -> a0
        move.l          124(a0),d0            ; Laenge des File -> d0

        rts                                   ; Back to Call !

LENGTHERROR:
        moveq           #-1,d0                ; Set ErrorFlag !
        rts                                   ; Back to Call

* Routine allociert ChipMemory
GETCHIPMEMSET:  REG d1-a6
GETCHIPMEM:
        movem.l         GETCHIPMEMSET,-(a7)   ; Save Regs on Stack

        move.l          d0,-(a7)              ; Rette Laenge auf Stack

        move.l          #MEMSET,d1            ; MemType = (CHIP+CLEAR+PUBLIC)
        movea.l         4,a6                  ; Execbase -> a6
        jsr             ALLOCMEM(a6)          ; Get Memory for File !
        tst.l           d0                    ; Test ob erfolgreich
        beq             WRONG                 ; Nein -> Wrong

        move.l          (a7)+,d1              ; Hole Laenge vom Stack !

        lea             MYMEMTABLE(pc),a0     ; MemTableBase -> a0
        move.l          a0,0                  ; Pointer fuer MPAR ablegen !
        move.w          MT_INPUTS(a0),d2      ; Anzahl der Eintraege -> d2
        addq.w          #1,MT_INPUTS(a0)      ; INC Eintraege

        lsl.w           #3,d2                 ; Eintraege * 8 fuer Offset
        lea             MT_TABLE(a0,d2.w),a0  ; Addiere Offset

        move.l          d1,(a0)+              ; Laenge ablegen !
        move.l          d0,(a0)+              ; ADR ablegen !

        movem.l         (a7)+,GETCHIPMEMSET   ; Get Reg from Stack
        rts                                   ; Back to Call !

* Routine allociert beliebigen Speicher
GETANYMEMSET:   REG d1-a6
GETANYMEM:
        movem.l         GETANYMEMSET,-(a7)    ; Save Regs on Stack

        move.l          d0,-(a7)              ; Rette Laenge auf Stack

        move.l          #MEMSET1,d1           ; MemType = (CLEAR+PUBLIC)
        movea.l         4,a6                  ; Execbase -> a6
        jsr             ALLOCMEM(a6)          ; Get Memory for File !
        tst.l           d0                    ; Test ob erfolgreich
        beq             WRONG                 ; Nein -> Wrong

        move.l          (a7)+,d1              ; Hole Laenge vom Stack !

        lea             MYMEMTABLE(pc),a0     ; MemTableBase -> a0
        move.l          a0,0                  ; Pointer fuer MPAR ablegen !
        move.w          MT_INPUTS(a0),d2      ; Anzahl der Eintraege -> d2
        addq.w          #1,MT_INPUTS(a0)      ; INC Eintraege

        lsl.w           #3,d2                 ; Eintraege * 8 fuer Offset
        lea             MT_TABLE(a0,d2.w),a0  ; Addiere Offset

        move.l          d1,(a0)+              ; Laenge ablegen !
        move.l          d0,(a0)+              ; ADR ablegen !

        movem.l         (a7)+,GETANYMEMSET    ; Get Reg from Stack
        rts                                   ; Back to Call !

* Routine errechnet Breite eines Proportionalstrings
* Input:
*       a0 = Zeiger auf String
* Output:
*       d0 = Exakte Breite der Zeichenkette in Pixel
PROPWIDTHSET:   REG d3-d5/a0/a5
PROPWIDTH:
        movem.l         PROPWIDTHSET,-(a7)    ; Save Regs on Stack !
        movea.l         SCRPORT+CHARPTR,a5    ; CharPointer -> a5
        move.b          CH_LOWEST(a5),d4      ; Lowest ASCII -> d4
        adda.w          CH_SPACE(a5),a5       ; Addiere BreitenOffset
        moveq           #0,d0                 ; Rueckgabe = 0
PROPWLOOP:
        move.b          (a0)+,d5              ; ASCII -> d5
        beq.s           PROPWENDE             ; = Ende -> Ende
        cmp.b           #" ",d5               ; Is Space ?
        beq.s           ADDLASTWIDTH          ; Ja -> AddLastWidth
        sub.b           d4,d5                 ; SUB Lowest ASCII
        ext.w           d5                    ; Bits ausmaskieren
        add.w           d5,d5                 ; * 2 fuer Wortzugriff
        move.w          0(a5,d5.w),d3         ; Breite -> d3
ADDLASTWIDTH:
        add.w           d3,d0                 ; Breite addieren
        bra.s           PROPWLOOP             ; -> Loop
PROPWENDE:
        movem.l         (a7)+,PROPWIDTHSET    ; Get Regs from Stack !
        rts                                   ; Back !

* Gibt String mit Proportional-Zeichensatz aus
* Input:
*       d0 = X
*       d1 = Y
*       a0 = Pointer auf nullterminierten String
PROPSTRING:
        move.b          (a0)+,d7              ; Hole Zeichen!
        beq.s           PROPSTREND            ; Ende des Strings -> Ende
        cmp.b           #" ",d7               ; Ist Leerzeichen ?
        beq.s           ISSPACE               ; Ja -> IsSpace
        ext.w           d7                    ; Wort erweitern !
        movem.l         d0-d1/a0,-(a7)        ; Save Regs on Stack !
        bsr.s           ONEPROP               ; Gebe Zeichen aus
        movem.l         (a7)+,d0-d1/a0        ; Get Regs from Stack !
        add.w           d6,d0                 ; ADD Breite des letzten Zeichens!
        bra.s           PROPSTRING            ; -> Loop
PROPSTREND:
        rts                                   ; Back !

ISSPACE:
        add.w           d6,d0                 ; ADD 16
        bra.s           PROPSTRING            ; -> PropString!

* Routine gibt ein Zeichen des Proportional-Zeichensatzes aus
* Input:
*       d7.w = ASCII
*       d2.w = Style  ( d6 <> 0, shadowed )
* Output:
*       d6.w = Breite des letzten Zeichens
ONEPROP:
        lea             SCRPORT(pc),a6        ; ScreePortBase -> a6
        movea.l         CHARPTR(a6),a5        ; CharacterBase -> a5

        move.w          CH_HEIGHT(a5),d5      ; Hoehe eines Chars -> d5
        sub.b           CH_LOWEST(a5),d7      ; SUB Lowest ASCII
        move.w          d7,d3                 ; ASCII -> d3

        movea.l         a5,a0                 ; CharGameBase -> a0
        movea.l         a5,a2                 ; CharGameBase -> a2
        movea.l         a5,a3                 ; CharGameBase -> a3
        movea.l         a5,a4                 ; CharGameBase -> a4

        adda.l          CH_DATAS(a5),a0       ; a0 Pointer to Base of Datas
        adda.l          CH_MASKS(a5),a2       ; a2 now Pointer to Masks
        adda.w          CH_ILOCK(a5),a3       ; a3 now Base of ILocks
        adda.w          CH_MLOCK(a5),a4       ; a4 now Base of MLocks
        adda.w          CH_SPACE(a5),a5       ; a5 now Base of Spaces

        lsl.w           #2,d3                 ; ASCII * 4 fuer Langwortzugriff
        add.w           d7,d7                 ; ASCII * 2 fuer Wortzugriff
        adda.l          0(a3,d3.w),a0         ; a0 now Pointer to Image
        adda.l          0(a4,d3.w),a2         ; a2 now Pointer to Mask
        move.w          0(a5,d7.w),d6         ; Breite in Pixel -> d6
        move.w          d6,-(a7)              ; Breite on Stack
        subq.w          #1,d6                 ; Breite - 1
        lsr.w           #4,d6                 ; Breite in Pixel / 16 = WORDS
        addq.w          #1,d6

        move.w          d5,d7                 ; Hoehe eines Zeichens -> d7
        movea.l         PLANES(a6),a1         ; ZielPlane -> a1
        move.w          ONELINEB(a6),d2       ; Bytes per Line -> d2
        move.l          ONEPLANE(a6),d4       ; Bytes per Plane -> d4

        bsr             CHAREFFECT            ; CharacterEffekte

        move.w          #DOWNY,d5             ; Set ClipDown
        suba.l          a4,a4                 ; No BackSave !
        bsr             BOB1                  ; Bob It !

        move.w          (a7)+,d6              ; Breite vom Stack
        rts                                   ; Back to Call !

* Routine zeichnet Effekt fuer Zeichensatz
CHAREFFECT:
        move.w          CHAREFF(a6),d5        ; EffectNumber -> d5
        beq             RETURN                ; = 0 Kein Effekt -> Ende
        cmp.w           #1,d5                 ; Ist Schatten ?
        bne.s           CHAROUTLINE           ; Nein -> Outline
        movem.l         d0-d2/d4-a1,-(a7)     ; Save Regs on Stack !
        addq.w          #2,d0                 ; INC Y fuer Schatten
        subq.w          #2,d1                 ; DEC Y fuer Schatten
        bsr             CHARSHADOW            ; Shadow Character !
        movem.l         (a7)+,d0-d2/d4-a1     ; Get Regs from Stack !
        rts                                   ; Back !
CHAROUTLINE:
        movem.l         d0-d2/d4-a1,-(a7)     ; Save Regs on Stack !
        subq.w          #1,d0                 ; INC Y fuer Schatten
        subq.w          #1,d1                 ; DEC Y fuer Schatten
        bsr             CHARSHADOW            ; Shadow Character !
        movem.l         (a7)+,d0-d2/d4-a1     ; Get Regs from Stack !

        movem.l         d0-d2/d4-a1,-(a7)     ; Save Regs on Stack !
        addq.w          #1,d0                 ; INC Y fuer Schatten
        subq.w          #1,d1                 ; DEC Y fuer Schatten
        bsr             CHARSHADOW            ; Shadow Character !
        movem.l         (a7)+,d0-d2/d4-a1     ; Get Regs from Stack !

        movem.l         d0-d2/d4-a1,-(a7)     ; Save Regs on Stack !
        addq.w          #1,d0                 ; INC Y fuer Schatten
        addq.w          #1,d1                 ; DEC Y fuer Schatten
        bsr             CHARSHADOW            ; Shadow Character !
        movem.l         (a7)+,d0-d2/d4-a1     ; Get Regs from Stack !

        movem.l         d0-d2/d4-a1,-(a7)     ; Save Regs on Stack !
        subq.w          #1,d0                 ; INC Y fuer Schatten
        addq.w          #1,d1                 ; DEC Y fuer Schatten
        bsr             CHARSHADOW            ; Shadow Character !
        movem.l         (a7)+,d0-d2/d4-a1     ; Get Regs from Stack !
        rts                                   ; Back !

* Routine legt Schatten fuer Zeichen
CHARSHADOW:
        move.w          d0,d3                 ; X -> d3
        mulu            d2,d1                 ; BytesperPlane * Y
        and.w           #$fff0,d0             ; AND X
        lsr.w           #3,d0                 ; d0 X-Byte-Offset
        lea             0(a1,d0.w),a1         ; X-Offset auf Destination
        lea             0(a1,d1.w),a1         ; Y-Offset auf Destination

        addq.w          #1,d6                 ; INC Breite
        lsl.w           #6,d7                 ; Hoehe * 64 fuer Blitsize
        or.w            d6,d7                 ; OR Breite in Worten
        and.w           #$000f,d3             ; d3 ist ShiftValue
        ror.w           #4,d3                 ; Oberste Nibble = ShiftValue
        or.w            #$0d0c,d3             ; OR DMAChannels & Minterm

        sub.w           d6,d2                 ; SUB Breite des Objekts
        sub.w           d6,d2                 ; SUB Breite des Objekts

        bsr             WAITBLIT
        lea             CUSTOM,a6
        move.w          #-1,BLTAFWM(a6)       ; Masks setzen
        move.w          #0,BLTALWM(a6)        ;
        move.w          #-2,BLTAMOD(a6)       ; MODs setzen

        move.w          d2,BLTBMOD(a6)        ; Modulo fuer SourceBitmap (C)
        move.w          d2,BLTDMOD(a6)        ; Modulo fuer DestBitmap (D)

        move.w          #0,BLTCON1(a6)
        move.w          d3,BLTCON0(a6)

        move.w          SCRPORT+SCRPLANESC,d0 ; Anzahl der Bitplanes
BLITPLANE1:
        move.l          a1,BLTBPTH(a6)        ; Zeiger auf Daten (B)
        move.l          a2,BLTAPTH(a6)        ; Zeiger auf Maske (A)
        move.l          a1,BLTDPTH(a6)        ; Zeiger auf DestBitmap (D)
        move.w          d7,BLTSIZE(a6)        ; ab geht die Post
        dbra            d0,BLITPLANE1_
        rts
BLITPLANE1_:
        adda.l          d4,a1
        bsr             WAITBLIT              ; are you ready?
        bra.s           BLITPLANE1

;-----------------------------------
; Bobroutine
; a2.l: Zeiger auf Datenblock
; a1.l: Zielbitmap
; d2.w: Bytes per Line
; d4.l: Bytes per Plane
; d5.w: hoechste Zeile
; d0.w: X-Koordinate, d1.w: Y-Koordinate
; a4.w: BackFlag
BOB:
        movea.l         a2,a0                 ; Zeiger fr Image.

        adda.w          OS_IMGOFF(a2),a0
        add.w           OS_XOFF(a2),d0
        add.w           OS_YOFF(a2),d1
        move.w          OS_BREITE1(a2),d6     ; BREITE1 in Worten.
        move.w          OS_HOEHE(a2),d7       ; HOEHE in Zeilen.
        lea             OS_MSKOFF(a2),a2
BOB1:
        move.w          d0,d3
        andi.w          #$000f,d3             ; Shiftfaktor.
        andi.w          #$fff0,d0
        asr.w           #3,d0                 ; Wortoffset.
        adda.w          d0,a1

        cmp.w           d5,d1                 ; ? out of bounds
        bgt             RETURN                ; ! ja

        move.w          d1,d0                 ; ? Clipping oben
        bmi.s           UPPERCLIPP            ; ! ja
        mulu            d2,d1                 ; Y * BPZ
        adda.l          d1,a1                 ; Zeilenoffset
        moveq           #0,d1                 ; kein Clipping
        add.w           d7,d0                 ; Y + Hoehe
        cmp.w           d5,d0                 ; ? Clipping unten
        ble.s           BLITSIZE              ; ! nein

        move.w          d7,d1                 ; ! ja
        mulu            d6,d1
        add.w           d1,d1                 ; BPP fr Image
        sub.w           d5,d0
        subq.w          #1,d0
        sub.w           d0,d7                 ; neue Hoehe
        bra.s           BLITSIZE

UPPERCLIPP:
        add.w           d7,d0                 ; ? out of bounds
        beq             RETURN                ; ! ja
        bmi             RETURN                ; ! ja

        neg.w           d1                    ; ! nein
        mulu            d6,d1
        add.w           d1,d1
        adda.w          d1,a0                 ; neuer Zeiger Daten
        adda.w          d1,a2                 ; neuer Zeiger Maske
        move.w          d7,d1
        add.w           d1,d1
        mulu            d6,d1                 ; BPP fr Image
        move.w          d0,d7                 ; neue Hoehe

BLITSIZE:
        addq.w          #1,d6
        move.w          d7,d5
        lsl.w           #6,d7
        or.w            d6,d7                 ; BLTSIZE

        sub.w           d6,d2
        sub.w           d6,d2                 ; Modulo Bitmap

        movea.l         a1,a3

        bsr             BACKSAVE
        bsr             DRAWBOB

        rts

;-----------------------------------
; wie DrawBob +
; d5.w: Hoehe in Zeilen

BACKSAVE:
        move.w          a4,d0
        beq             RETURN
        bsr             WAITBLIT
        lea             CUSTOM,a6
        movea.l         BACKSTACKPT(pc),a5
        move.l          a3,(a5)+              ; Sourcebitmap retten
        move.w          d2,(a5)+              ; Modulo retten
        move.w          d7,(a5)+              ; BLTSIZE retten
        move.w          d4,(a5)+              ; BPP retten

        move.w          d2,BLTCMOD(a6)        ; Modulo fuer Bitmap (C)
        move.w          #0,BLTDMOD(a6)        ; Modulo fuer BackStack (D)

        move.w          #0,BLTCON1(a6)
        move.w          #$03aa,BLTCON0(a6)    ; Kopiere C nach D
        move.l          a5,BLTDPTH(a6)        ; Zeiger auf BackStack (D)

        lsl.w           #3,d6                 ; Zeiger auf neuen
        mulu            d6,d5                 ; Datenblock
        adda.l          d5,a5

        move.w          SCRPORT+SCRPLANESC,d0 ; Anzahl der Bitplanes
SAVEPLANE:
        move.l          a3,BLTCPTH(a6)        ; Zeiger auf SourceBitmap (C)
        move.w          d7,BLTSIZE(a6)        ; ab geht die Post
        dbra            d0,SAVEPLANE_
        move.l          BACKSTACKPT(pc),(a5)+ ; Beginn der Daten
        move.l          a5,BACKSTACKPT        ; neuer Stackpointer
        rts
SAVEPLANE_:
        adda.l          d4,a3
        bsr             WAITBLIT              ; are you ready?
        bra.s           SAVEPLANE

;-----------------------------------
; DrawBob kopiert ein Objekt in eine Bitmap.
; Bitmap = Daten or Maske and Bitmap
; a0.l: Daten, a2.l: Maske, a1.l: Bitmap
; d2.l: Modulo Bitmaps
; d3.w: Shiftfaktor
; d4.l: Bytes per Plane
; d7.w: BLTSIZE
;-----------------------------------

DRAWBOB:
        bsr             WAITBLIT
        lea             CUSTOM,a6
        move.w          #-1,BLTAFWM(a6)       ; Masks setzen
        move.w          #0,BLTALWM(a6)        ;
        move.w          #-2,BLTAMOD(a6)       ; MODs setzen
        move.w          #-2,BLTBMOD(a6)       ; MODs setzen

        move.w          d2,BLTCMOD(a6)        ; Modulo fuer SourceBitmap (C)
        move.w          d2,BLTDMOD(a6)        ; Modulo fuer DestBitmap (D)

        ror.w           #4,d3                 ; Shiftfaktor
        move.w          d3,BLTCON1(a6)
        move.w          d3,d2                 ; Shift-Value -> d2
;        ori.w           #$0fca,d3             ; Miniterm
;        move.w          d3,BLTCON0(a6)

        move.w          SCRPORT+SCRPLANESC,d0 ; Anzahl der Bitplanes
        tst.w           d1
        bne.s           CLIPPBLIT
        move.l          a0,BLTBPTH(a6)        ; Zeiger auf Daten (B)
BLITPLANE:
        move.w          d2,d3                 ; ShiftValue -> d3
        tst.b           PL3FL                 ; Only 3 Planes ?
        beq.s           NOT3PL                ; Nein -> Not3Pl
        tst.w           d0                    ; 4. Plane ?
        bne.s           NOT3PL                ; Nein -> Not3Pl
        or.w            #$0b0a,d3             ; OR MinTerm + DMAChannels
        bra.s           BLITIT                ; -> BlitIt
NOT3PL:
        or.w            #$0fca,d3             ; OR MinTerm + DMAChannels
BLITIT:
        move.w          d3,BLTCON0(a6)        ; Set MinTerm + DMA + Shift ( A )
        move.l          a2,BLTAPTH(a6)        ; Zeiger auf Maske (A)
        move.l          a1,BLTCPTH(a6)        ; Zeiger auf SourceBitmap (C)
        move.l          a1,BLTDPTH(a6)        ; Zeiger auf DestBitmap (D)
        move.w          d7,BLTSIZE(a6)        ; ab geht die Post
        dbra            d0,BLITPLANE_
        rts
BLITPLANE_:
        adda.l          d4,a1
        bsr             WAITBLIT              ; are you ready?
        bra.s           BLITPLANE

CLIPPBLIT:
        move.w          d2,d3                 ; ShiftValue -> d3
        tst.b           PL3FL                 ; Only 3 Planes ?
        beq.s           NOT3PL1               ; Nein -> Not3Pl1
        tst.w           d0                    ; 4. Plane ?
        bne.s           NOT3PL1               ; Nein -> Not3Pl1
        or.w            #$0b0a,d3             ; OR MinTerm + DMAChannels
        bra.s           CLIPIT                ; -> ClipIt
NOT3PL1:
        or.w            #$0fca,d3             ; OR MinTerm + DMAChannels
CLIPIT:
        move.w          d3,BLTCON0(a6)        ; Set MinTerm + DMA + Shift ( A )
        move.l          a2,BLTAPTH(a6)        ; Zeiger auf Maske (A)
        move.l          a0,BLTBPTH(a6)        ; Zeiger auf Daten (B)
        move.l          a1,BLTCPTH(a6)        ; Zeiger auf SourceBitmap (C)
        move.l          a1,BLTDPTH(a6)        ; Zeiger auf DestBitmap (D)
        move.w          d7,BLTSIZE(a6)        ; ab geht die Post
        dbra            d0,CLIPPBLIT_
        rts
CLIPPBLIT_:
        adda.w          d1,a0
        adda.l          d4,a1
        bsr             WAITBLIT              ; are you ready?
        bra.s           CLIPPBLIT

RETURN: rts

PL3FL:          DC.W 0                  ; Flag fuer 3 BitPlanes

;============================================================================
; Hintergrund der Bobs restaurieren
; Nach einem Algorythmus von Klein-Thomas
OLDBACK:
        lea             CUSTOM,a6
        bsr             WAITBLIT

        move.w          #0,BLTCMOD(a6)
        move.l          #$03aa0000,BLTCON0(a6) ; kopiere C nach D
        movea.l         BACKSTACKPT(pc),a5
OLDBACKLOOP:
        cmpa.l          BACKSTACK(pc),a5
        beq.s           OLDBACKEND

        movea.l         -(a5),a5              ; Zeiger auf n„chsten Background.
        movea.l         a5,a3
        movea.l         (a3)+,a0              ; Zeiger auf Bitmap.
        bsr             WAITBLIT
        move.w          (a3)+,BLTDMOD(a6)     ; Modulo fr Bitmap (D).
        move.w          (a3)+,d7              ; BLTSIZE.
        move.w          (a3)+,d4              ; Bytes per Plane.

        move.l          a3,BLTCPTH(a6)        ; Zeiger auf Backgrounddaten (C)

        moveq           #4-1,d0               ; Anzahl der Bitplanes
BLITOLDPLANE:
        move.l          a0,BLTDPTH(a6)        ; Zeiger auf Bitmap (D)
        move.w          d7,BLTSIZE(a6)        ; ab geht die Post
        dbra            d0,BLITOLDPLANE_
        bra.s           OLDBACKLOOP
BLITOLDPLANE_:
        adda.w          d4,a0
        bsr             WAITBLIT              ; are you ready?
        bra.s           BLITOLDPLANE

OLDBACKEND:
        move.l          BACKSTACK(pc),BACKSTACKPT
        rts

*       Die Funktion DrawLine erhaelt folgende Parameter
*       d0.w            =       x1
*       d1.w            =       y1
*       d2.w            =       x2
*       d3.w            =       y2
*
DRAWLINESET:    REG d0-a2/a5-a6
DRAWLINE:
        movem.l         DRAWLINESET,-(a7)     ; Save Regs

        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6

        cmp.w           d0,d2                 ; Is X1=X2
        bne.s           X1NOTX2               ; Nein -> Ziehe Linie
        cmp.w           d1,d3                 ; Is Y1=Y2
        bne.s           X1NOTX2               ; Ziehe Linie
        movem.l         (a7)+,DRAWLINESET     ; Hole Register vom Stack
        rts
X1NOTX2:
        lea             CUSTOM,a4             ; CustomBase -> a4
        lea             OKTTABLE(pc),a5       ; OktantenTabelle
        lea             PLANES(a6),a0         ; Adressen der Planes -> a0
        move.w          d0,d4                 ; x1 in WorkReg d4
        move.w          d1,d5                 ; y1 in WorkReg d5
        lsr.w           #3,d4                 ; d4/8
        add.w           d5,d5                 ; * 2 fuer DatenFetch
        add.w           MULU160(a6,d5.w),d4   ; Y-Offset aus Tabelle addieren

*       Berechnung des Oktanten und der SteigungsDeltas
*
OKTANT:
        moveq           #0,d5                 ; Clear d5
        sub.w           d1,d3                 ; Berechne Deltay
        roxl.b          #1,d5                 ; Extend nach d5
        tst.w           d3                    ; Is lower?
        bge.s           Y2GY1                 ; Nein -> BRA
        neg.w           d3                    ; d3 = Positiv

Y2GY1:

        sub.w           d0,d2                 ; Berechne Deltax
        roxl.b          #1,d5                 ; Extend nach d5
        tst.w           d2                    ; Is lower?
        bge.s           X2GX1                 ; Nein -> BRA
        neg.w           d2                    ; d2 = Positiv

X2GX1:

        move.w          d3,d1                 ; Deltay -> y1
        sub.w           d2,d1                 ; Bilde GDelta u. KDelta
        bge.s           DYGDX                 ; Is Deltay > Deltax
        exg             d2,d3                 ; Swap REGS

DYGDX:

        roxl.b          #1,d5                 ; Letzter Test fuer Okt.
        move.b          0(a5,d5.w),d5         ; Hole Oktant-Code
        add.w           d2,d2                 ; d2*2

SETFORLINE:
        move.w          d2,d6                 ; d6 now Reg for BLTBMOD
        sub.w           d3,d2                 ; Test ob SIGN
        bge.s           SIGNNL
        ori.b           #$40,d5

SIGNNL:
        movea.w         d2,a2                 ; a2 now Reg for BLTAPTL
        sub.w           d3,d2                 ; d2 now Reg for BLTAMOD

STARTLINE:

        andi.w          #$000f,d0
        ror.w           #4,d0
        ori.w           #$0bca,d0             ; Set LineMode -> Normal

        addq.w          #1,d3                 ; INC BlitSize
        lsl.w           #6,d3                 ; d3 * 64 (BlitSize berechnen)
        addq.w          #2,d3                 ; WIDTH must be 2 (d3 = BlitSize)

        move.w          SCRPLANESC(a6),d7     ; LoopCounter -> d7

        move.w          COLOR(a6),d1          ; Color -> d1
DRAWLINELOOP:
        movea.l         (a0)+,a1              ; BitPlaneBasis -> a1
        lea             0(a1,d4.w),a1         ; ADD Offset

        lsr.w           #1,d1                 ; Shift Farbwert
        bcs.s           NOLINECLEAR           ; ClearMinTerm nicht installieren
        move.b          #$0a,d0               ; Set ClearMinTerm
NOLINECLEAR:
        bsr             WAITBLIT
        move.l          a1,BLTCPTH(a4)        ; Address in BlitRegs
        move.l          a1,BLTDPTH(a4)        ; Address in BlitRegs
        move.w          ONELINEB(a6),BLTCMOD(a4) ; Breite des Display in Bytes
        move.w          ONELINEB(a6),BLTDMOD(a4) ; Breite des Display in Bytes
        move.w          #$8000,BLTADAT(a4)    ; Fuer LINE-MODE must be $8000
        move.w          #LINEMASK,BLTBDAT(a4) ; Maske fuer Line ($ffff)
        move.w          #$ffff,BLTAFWM(a4)    ; Fuer LINE-MODE

        move.w          d0,BLTCON0(a4)        ; Set BLTCON0
        move.w          d5,BLTCON1(a4)        ; Set BLTCON1

        move.w          d2,BLTAMOD(a4)        ; d2 now Reg for BLTAMOD
        move.w          d6,BLTBMOD(a4)        ; Gdelta*2 -> Bltbmod
        move.w          a2,BLTAPTL(a4)        ; SteigungsWert

        move.w          d3,BLTSIZE(a4)        ; Draw the Line!

        move.b          #$ca,d0               ; Set NormalMinTerm

;        dbra            d7,DRAWLINELOOP       ; Loop to draw!

        movem.l         (a7)+,DRAWLINESET     ; Get Regs from Stack
        rts                                   ; Back to roots!

* Routine loescht den Bildschirm ( unter Beruecksichtigung der Planes )
CLEARSCREEN:
        bsr             WAITBLIT              ; Warte auf Blitter
        move.w          SCRPORT+SCRPLANES,d1  ; Anzahl der Bitplanes -> d1
        mulu            #200,d1               ; * Hoehe einer Plane
        lsl.w           #6,d1                 ; * 64
        or.w            #$0014,d1             ; d1 now ClearSize
        move.w          #0,BLTDMOD(a4)        ; No Modulo!
        move.w          #0,BLTCON1(a4)        ; Only Copy!
        move.w          #CLEARTERM,BLTCON0(a4) ; Term
        move.l          SCRPORT+PLANES,BLTDPTH(a4) ; Dest. Adr.
        move.w          d1,BLTSIZE(a4)        ; Start It
        rts

* Routine um gefuelltes Rechteck mit Blitter zu zeichnen
*
FILLBOXSET:     REG d0-a1
FILLBOX:
        movem.l         FILLBOXSET,-(a7)      ; Rette Regs
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6

        addq.w          #1,d2                 ; INC X2
        cmp.w           d0,d2                 ; Vergleiche X1 X2
        bge.s           NOCHANGEX             ; Nicht vertauschen
        exg             d0,d2
NOCHANGEX:
        cmp.w           d1,d3                 ; Vergleiche Y1 Y2
        bge.s           NOCHANGEY             ; Nicht vertauschen
        exg             d1,d3
NOCHANGEY:
        moveq           #0,d7
        move.w          d1,d4                 ; Y1 -> d4
* Berechne BLTDPTH
        add.w           d4,d4                 ; Fuer Adresszugriff
        move.w          MULU160(a6,d4.w),d4   ; Hole y-Wert
        move.w          d0,d7                 ; x1 -> d4
        lsr.w           #3,d7                 ; x1 / 8
        add.w           d7,d4                 ;
        ext.l           d4                    ; d4 now Offset

        move.l          d4,-(a7)              ; Offset auf Stack ablegen
        move.w          d2,d7                 ; x2 -> d7
        move.w          d0,d6                 ; X1 -> d6
        lsr.w           #4,d7                 ; / 16
        lsr.w           #4,d6
        sub.w           d6,d7                 ; Erechne HBlitsize
        addq.w          #1,d7

        move.w          ONELINE(a6),d6        ; Breite des Display in Words
        sub.w           d7,d6                 ; Sub HBlitsize
        add.w           d6,d6                 ; Modulo in Bytes

        sub.w           d1,d3                 ; Errechne VBlitsize
        addq.w          #1,d3
        lsl.w           #6,d3                 ; Shift Wert

* Berechne FWM und LWM
        andi.w          #$000f,d0             ; AND x1 with $f
        andi.w          #$000f,d2             ; AND x2 with $f
        bne.s           FBMUSTSHIFT
        subq.w          #1,d7                 ; Blitsize korrigieren
        addq.w          #2,d6                 ; Modulo korrigieren
        moveq           #$10,d2
FBMUSTSHIFT:
        add.w           d0,d0                 ; SHIFT LWM
        add.w           d2,d2                 ; SHIFT FWM
        lea             PLANES(a6),a1         ; BPLPORT -> a1
        lea             MASKTAB(pc),a0        ; MaskTab -> a0
        move.w          0(a0,d0.w),d0         ; FWM nach d0
        move.w          0(a0,d2.w),d2         ; LWM nach d2
        not.w           d2                    ; NOT It!

        or.w            d3,d7                 ; d7 = BlitSize

        move.w          #$03fa,d4             ; NormalTerm
        move.w          SCRPLANESC(a6),d5     ; Init LoopCounter
        move.w          COLOR(a6),d3          ; Color -> d3
FBOXCOLOR:
        lsr.w           #1,d3                 ; ColorWert in Carry schieben
        bcs.s           FBBPLSET              ; BPL nicht aendern
        move.w          #$030a,d4             ; Clear-MinTerm
FBBPLSET:
        movea.l         (a1)+,a0              ; Offset vom Stack holen
        adda.l          (a7),a0               ; BPL-Offset addieren
        bsr             WAITBLIT              ; Wait on Blitter
        lea             CUSTOM,a4             ; CustomBase -> a4
        move.l          a0,BLTDPTH(a4)        ; Dest.Adr.
        move.l          a0,BLTCPTH(a4)        ; C = D fuer Minterm
        clr.w           BLTCON1(a4)           ; Only Copy!

        move.w          d4,BLTCON0(a4)        ; Term setzen

        move.w          #$ffff,BLTADAT(a4)    ; ADATA = LinePattern
        move.w          d0,BLTAFWM(a4)        ; Set FirstWordMask
        move.w          d2,BLTALWM(a4)        ; Set LastWordMask
        move.w          d6,BLTCMOD(a4)        ; Modulo C setzen
        move.w          d6,BLTDMOD(a4)        ; Modulo D setzen
        move.w          d7,BLTSIZE(a4)        ; Size
NFBOXLOOP:
        move.w          #$03fa,d4             ; MinTerm = Norm
        dbra            d5,FBOXCOLOR          ; Loop
        movea.l         (a7)+,a0              ; Offset vom Stack

        movem.l         (a7)+,FILLBOXSET      ; Hole Regs
        rts

WAITBLIT:
        lea             CUSTOM,a4             ; Custom -> a4
WAITBLOOP:
        btst            #14,DMACONR+CUSTOM
        bne.s           WAITBLOOP
        rts

* Routine um gefuelltes Polygon zu erzeugen
* Nach einem Algorythmus von Peter Sabath
* šbergabeParameter:
*                       a0  = Zeiger auf X-Koordinaten
*                       a1  = Zeiger auf Y-Koordinaten
* RegisterUse:
*                       d0 = X
*                       d1 = Y
*                       d2 = ST
*                       d3 = E
*                       d4 = DX
*                       d5 = DY
*                       D6 = P
*                       D7 = C
*                       a0 = Zeiger auf X-Koordinaten
*                       a1 = Zeiger auf Y-Koordinaten
*                       a2 = Zeiger auf X-Koordinaten-Ablage
*                       a3 = YMax
*                       a5 = SaveReg

POLYGON:
        move.w          (a1),d0               ; Hole Y(0)
        cmp.w           2(a1),d0              ; Vergleiche d0 Y(1)
        bge.s           NOTFIRST              ; Bra
        move.w          2(a1),d0              ; d0 = Y(1)
NOTFIRST:
        cmp.w           4(a1),d0              ; Vergleiche d0 Y(2)
        bge.s           NOTSECOND             ; Bra
        move.w          4(a1),d0              ; d0 = Y(2)
NOTSECOND:
        cmp.w           6(a1),d0              ; Vergleiche d0 Y(3)
        bge.s           NOTTHIRD              ; Bra
        move.w          6(a1),d0              ; d0 = Y(3)
; D0 = YMAX
NOTTHIRD:
        movea.w         d0,a3                 ; a3 = YMax
; Beginn der eigentlichen Hauptroutine
POLYBEGIN:
        lea             XP0ARRAY(pc),a2       ; Ablage der errechneten X-Coord
        move.w          (a0),d0               ; d0 = X(0)
        move.w          (a1),d1               ; d1 = Y(0)
        moveq           #0,d6                 ; d6 = P = 0

        bsr             GETPAR1               ; LinienParameter errechnen
        subq.w          #1,d7                 ; DEC C

        movea.l         d2,a5                 ; Rette St
        asr.w           #1,d2                 ; St DIV 2
        add.w           d2,d0                 ; ADD X,(St DIV 2)
        move.l          a5,d2                 ; St wiederholen

POLY1LOOP:
        move.w          d0,(a2)+              ; Lege X in Array ab
        add.w           d2,d0                 ; ADD X,St
        sub.w           d4,d3                 ; SUB E,DX
        bpl.s           NOCORRECT1            ; Is E < 0
        add.w           d5,d3                 ; ADD E,DY
        add.w           a6,d0                 ; Selbstmodifikation
NOCORRECT1:
        addq.w          #1,d1                 ; INC Y

        dbra            d7,POLY1LOOP          ; -> PolyLoop

        cmpa.w          d1,a3                 ; Is Y < Ymax
        ble.s           NEXTLOOP1             ; Nein -> NextLoop1

POLY2LOOP:
        addq.w          #2,d6                 ; d6 = P + A
        move.w          0(a0,d6.w),d0         ; X = X(P + A)
        bsr             GETPAR1               ; - > Getpar2
        subq.w          #1,d7                 ; DEC C

        movea.l         d2,a5                 ; Rette St
        asr.w           #1,d2                 ; St DIV 2
        add.w           d2,d0                 ; ADD X,(St DIV 2)
        move.l          a5,d2                 ; St wiederholen

POLY3LOOP:
        move.w          d0,(a2)+              ; Lege X in Array ab
        add.w           d2,d0                 ; ADD X,St
        sub.w           d4,d3                 ; SUB E,DX
        bpl.s           NOCORRECT2            ; Is E < 0

        add.w           d5,d3                 ; ADD E,DY
        add.w           a6,d0                 ; Selbstmodifikation von Getpar2

NOCORRECT2:
        addq.w          #1,d1                 ; INC Y

        dbra            d7,POLY3LOOP          ; - > PolyLoop

        cmpa.w          d1,a3                 ; IS Y >= Ymax
        bgt.s           POLY2LOOP             ; Nein -> Polyloop

NEXTLOOP1:
        lea             XP1ARRAY(pc),a2       ; Ablage der errechneten X-Coord
        move.w          (a0),d0               ; X = X(0)
        move.w          (a1),d1               ; Y = Y(0)
        moveq           #8,d6                 ; P = 8
        bsr             GETPAR2               ; - > Getpar3
        subq.w          #1,d7

        movea.l         d2,a5                 ; Rette St
        asr.w           #1,d2                 ; St DIV 2
        add.w           d2,d0                 ; ADD X,(St DIV 2)
        move.l          a5,d2                 ; St wiederholen

POLY4LOOP:

        move.w          d0,(a2)+              ; Lege X in Array ab
        add.w           d2,d0                 ; ADD X,St
        sub.w           d4,d3                 ; SUB E,DX
        bpl.s           NOCORRECT3            ; Is E < 0
        add.w           d5,d3                 ; ADD E,DY
        add.w           a6,d0                 ; Selbstmodi von Getpar3
NOCORRECT3:
        addq.w          #1,d1                 ; INC Y
        dbra            d7,POLY4LOOP          ; - > PolyLoop

        cmpa.w          d1,a3                 ; IS Y < Ymax
        ble.s           NEXTLOOP2             ; Nein -> Nextloop2

POLY5LOOP:

        subq.w          #2,d6                 ; d6 = P + A
        move.w          0(a0,d6.w),d0         ; Hole X aus Array
        bsr             GETPAR2               ; - > Getpar4
        subq.w          #1,d7                 ; DEC C

        movea.l         d2,a5                 ; Rette St
        asr.w           #1,d2                 ; St DIV 2
        add.w           d2,d0                 ; ADD X,(St DIV 2)
        move.l          a5,d2                 ; St wiederholen

POLY6LOOP:
        move.w          d0,(a2)+              ; Lege X in Array ab
        add.w           d2,d0                 ; ADD X,St
        sub.w           d4,d3                 ; SUB E,DX
        bpl.s           NOCORRECT4            ; Is E < 0
        add.w           d5,d3                 ; ADD E,DY
        add.w           a6,d0                 ; Selbstmodi von Getpar4
NOCORRECT4:
        addq.w          #1,d1                 ; INC Y
        dbra            d7,POLY6LOOP          ; - > PolyLoop

        cmpa.w          d1,a3                 ; Is Y >= Ymax
        bgt.s           POLY5LOOP             ; - > PolyLoop

NEXTLOOP2:
; Jetzt werden horizontale Linien gezogen
        move.w          a3,d4                 ; Ymax -> d4
        sub.w           (a1),d4               ; SUB Y(0)
        subq.w          #1,d4                 ; d4 now Loopendecounter
        moveq           #0,d3                 ; d3 = MainCounter
        move.w          (a1),d5               ; Y(0) -> d5
        lea             XP0ARRAY(pc),a2       ; XP0Array -> a2
        lea             XP1ARRAY(pc),a3       ; XP0Array -> a3
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
DRAWLOOP:
        move.w          (a2)+,d0              ; X1 -> d0
        move.w          (a3)+,d1              ; X2 -> d1
        move.w          d3,d2                 ; Counter nach d2 = Y
        add.w           d5,d2                 ; ADD Y(0)
        bsr             HORLINE
        addq.w          #1,d3                 ; INC d3
        cmp.w           d4,d3                 ; Is Ende?
        ble.s           DRAWLOOP              ; Nein -> Loop

        rts

GETPAR1:
        movea.w         #1,a6                 ; Init a6
        move.w          2(a0,d6.w),d4         ; X-Coord aus Array holen
        move.w          2(a1,d6.w),d5         ; Y-Coord aus Array holen

        sub.w           d0,d4                 ; DX bilden
        sub.w           d1,d5                 ; DY bilden
        move.w          d4,d2                 ; DX -> St
        ext.l           d2                    ; LangWort erweitern
        tst.w           d5                    ; Ist DY = 0
        beq.s           NODIV                 ; Ja -> NoDiv
        divs            d5,d2                 ; St = DX DIV DY

        move.l          d2,d4                 ; St -> DX
        swap            d4                    ; DX = DX MOD DY
        tst.w           d4                    ; Vorzeichentest
NODIVI:

        bpl.s           PARASTAYS1            ; Positiv -> Parastays
        movea.w         #-1,a6                ; A6 = SGN(DX)
        neg.w           d4                    ; ABS(DX)
PARASTAYS1:
        move.w          d5,d3                 ; E = DY DIV 2
        asr.w           #1,d3                 ;
        move.w          d5,d7                 ; C = DY
        rts
NODIV:
        move.w          2(a0,d6.w),d0         ; X-Coord aus Array holen
        moveq           #1,d5                 ; DY = 1
        moveq           #0,d2                 ; ST = 0
        moveq           #0,d4                 ; DX = 0
        bra.s           NODIVI

GETPAR2:
        movea.w         #1,a6                 ; Init a6
        move.w          -2(a0,d6.w),d4        ; X-Coord aus Array holen
        move.w          -2(a1,d6.w),d5        ; Y-Coord aus Array holen

        sub.w           d0,d4                 ; DX bilden
        sub.w           d1,d5                 ; DY bilden
        move.w          d4,d2                 ; DX -> St
        ext.l           d2                    ; LangWort erweitern
        tst.w           d5                    ; Ist DY = 0
        beq.s           NODIV1                ; Ja -> NoDiv1
        divs            d5,d2                 ; St = DX DIV DY

        move.l          d2,d4                 ; St -> DX
        swap            d4                    ; DX = DX MOD DY
        tst.w           d4                    ; Vorzeichentest
NODIVI1:

        bpl.s           PARASTAYS2            ; Positiv -> Parastays
        movea.w         #-1,a6                ; A6 = SGN(DX)
        neg.w           d4                    ; ABS(DX)
PARASTAYS2:
        move.w          d5,d3                 ; E = DY DIV 2
        asr.w           #1,d3                 ;
        move.w          d5,d7                 ; C = DY
        rts
NODIV1:
        move.w          -2(a0,d6.w),d0        ; X-Coord aus Array holen
        moveq           #1,d5                 ; DY = 1
        moveq           #0,d2                 ; ST = 0
        moveq           #0,d4                 ; DX = 0
        bra.s           NODIVI1               ; -> NoDivi1

* Zieht horizontale Linie mit Blitter ohne LineMode ( fuer 3D-Ausgabe )
* Parameter:
*               d0      =       x1
*               d1      =       x2
*               d2      =       ya
* RegisterUse:
*               d0      =       FWM
*               d1      =       LWM
*               d2      =       BLTDPTH
*               d3      =       Color
*               d4      =       MinTerm
*               d6      =       BitPlaneZaehler
*               d7      =       BlitSize
*               a0      =       Pointer to Maskentabelle
*               a1      =       Pointer to Bitplaneport
* HORLINESET:     REG d0-d4/d6-a1
; HORLINESET:     REG d3-d4
HORLINE:
        cmp.w           d0,d1
        bgt.s           NCHANGE
        exg             d0,d1
NCHANGE:
;------------------------------------------------------------
        cmp.w           #DOWNY,d2             ; Clipping Test! Y1
        ble.s           HY1NOT1
        rts
HY1NOT1:
        cmp.w           #RIGHTX,d0            ; Clipping Test! X1
        ble.s           HX0NOT
        rts
HX0NOT:
        cmp.w           #LEFTX,d1             ; Clipping Test! X2
        bge.s           HX0NOT1
        rts
HX0NOT1:
        cmp.w           #LEFTX,d0             ; Clipping Test! X1
        bge.s           HX1NOT
        move.w          #LEFTX,d0
HX1NOT:
        cmp.w           #RIGHTX,d1            ; Clipping Test! X2
        ble.s           HX2NOT1
        move.w          #RIGHTX,d1
HX2NOT1:
;------------------------------------------------------------

        addq.w          #1,d1                 ; INC X2
        moveq           #0,d7                 ; Clear d7
        add.w           d2,d2                 ; Fuer Adresszugriff
        move.w          MULU160(a6,d2.w),d2   ; Hole y-Wert
        move.w          d0,d7                 ; x1 -> d3
        lsr.w           #3,d7                 ; x1 / 8
        add.w           d7,d2                 ;

        move.w          d1,d7                 ; x2 -> d7
        move.w          d0,d6                 ; x1 -> d6
        lsr.w           #4,d7                 ; / 16
        lsr.w           #4,d6                 ; / 16
        sub.w           d6,d7                 ; Get BlitSize
        addq.w          #1,d7                 ; INC BlitSize

* Berechne FWM und LWM
        andi.w          #$000f,d0             ; AND x1 with $f
        andi.w          #$000f,d1             ; AND x2 with $f
        bne.s           MUSTSHIFT
        subq.w          #1,d7
        moveq           #$10,d1
MUSTSHIFT:
        add.w           d0,d0                 ; SHIFT LWM
        add.w           d1,d1                 ; SHIFT FWM
        lea             MASKTAB(pc),a0        ; MaskTab -> a0
        move.w          0(a0,d0.w),d0         ; FWM nach d6
        move.w          0(a0,d1.w),d1         ; LWM nach d7
        not.w           d1                    ; NOT It!

        ori.w           #$0040,d7             ; Set BlitSize !

        movea.l         ACTPLANE(pc),a0       ; BPL-Basis -> a0
        lea             0(a0,d2.w),a0         ; Offset addieren
        bsr             WAITBLIT              ; Wait on Blitter
        move.l          a0,BLTDPTH(a4)        ; Dest.Adr.
        move.l          a0,BLTCPTH(a4)        ; C = D fuer Minterm
        clr.w           BLTCON1(a4)           ; Only Copy!

        move.w          #$03fa,BLTCON0(a4)    ; Term setzen

        move.w          #$ffff,BLTADAT(a4)    ; ADATA = LinePattern
        move.w          d0,BLTAFWM(a4)        ; Set FirstWordMask
        move.w          d1,BLTALWM(a4)        ; Set LastWordMask
        move.w          d7,BLTSIZE(a4)        ; Size
HORLINEENDE:
        rts

* Routine erledigt Clipping fr Horizontale LinienFunktion
HORLINECLIP1:
        cmp.w           #DOWNY,d2             ; Clipping Test! Y1
        ble.s           GHY1NOT1
        moveq           #-1,d2                ; Set FailedFlag!
        rts
GHY1NOT1:
        cmp.w           #RIGHTX,d0            ; Clipping Test! X1
        ble.s           GHX0NOT
        moveq           #-1,d2
        rts
GHX0NOT:
        cmp.w           #LEFTX,d1             ; Clipping Test! X2
        bge.s           GHX0NOT1
        moveq           #-1,d2
        rts
GHX0NOT1:
        cmp.w           #LEFTX,d0             ; Clipping Test! X1
        bge.s           GHX1NOT
        move.w          #LEFTX,d0
GHX1NOT:
        cmp.w           #RIGHTX,d1            ; Clipping Test! X2
        ble.s           GHX2NOT1
        move.w          #RIGHTX,d1
GHX2NOT1:
;        cmp.w           #UPY,d2               ; Clipping Test! Y1
;        bge.s           HY1NOT
;        moveq           #-1,d2                ; Set FailedFlag!
        rts                                   ; Back to Call!

* Zieht horizontale Linie mit Blitter ohne LineMode
* Parameter:
*               d0      =       x1
*               d1      =       x2
*               d2      =       ya
* RegisterUse:
*               d0      =       FWM
*               d1      =       LWM
*               d2      =       BLTDPTH
*               d3      =       Color
*               d4      =       MinTerm
*               d6      =       BitPlaneZaehler
*               d7      =       BlitSize
*               a0      =       Pointer to Maskentabelle
*               a1      =       Pointer to Bitplaneport
HORLINE1:
        cmp.w           d0,d1
        bgt.s           NOCHANGE
        exg             d0,d1
NOCHANGE:
;        tst.w           CLIP(a6)              ; Teste ob Clipping noetig
;        beq.s           NOHORLINECLIP         ; Nein -> NoHorlineClip
;        bsr             HORLINECLIP1          ; Clip It!
;        tst.w           d2                    ; Teste FailedFlag
;        bmi             HORLINE1ENDE          ; Neg -> Ende !

        addq.w          #1,d1                 ; INC X2
        moveq           #0,d7                 ; Clear d7
        add.w           d2,d2                 ; Fuer Adresszugriff
        move.w          MULU160(a6,d2.w),d2   ; Hole y-Wert
        move.w          d0,d7                 ; x1 -> d3
        lsr.w           #3,d7                 ; x1 / 8
        add.w           d7,d2                 ;
        and.l           #$0000ffff,d2         ; Oben = 0

        move.w          d1,d7                 ; x2 -> d7
        move.w          d0,d6                 ; x1 -> d6
        lsr.w           #4,d7                 ; / 16
        lsr.w           #4,d6                 ; / 16
        sub.w           d6,d7                 ; Get BlitSize
        addq.w          #1,d7                 ; INC BlitSize

* Berechne FWM und LWM
        andi.w          #$000f,d0             ; AND x1 with $f
        andi.w          #$000f,d1             ; AND x2 with $f
        bne.s           MUSTSHIFT1
        subq.w          #1,d7
        moveq           #$10,d1
MUSTSHIFT1:
        add.w           d0,d0                 ; SHIFT LWM
        add.w           d1,d1                 ; SHIFT FWM
        lea             MASKTAB(pc),a0        ; MaskTab -> a0
        move.w          0(a0,d0.w),d0         ; FWM nach d6
        move.w          0(a0,d1.w),d1         ; LWM nach d7
        not.w           d1                    ; NOT It!

        ori.w           #$0040,d7             ; Set BlitSize !

        lea             PLANES(a6),a1         ; BPLPORT -> a1
        move.w          COLOR(a6),d3          ; COLOR -> d3
        move.w          #$03fa,d4             ; NormalTerm -> d4
        move.w          SCRPLANESC(a6),d6     ; Init LoopCounter
HLINE1COLOR:
        lsr.w           #1,d3                 ; ColorWert in Carry schieben
        bcs.s           BITPLSET              ; BPL nicht aendern
        move.w          #$030a,d4             ; Clear-MinTerm
BITPLSET:
        movea.l         (a1)+,a0              ; BPL-Basis -> a0
;        lea             0(a0,d2.l),a0         ; Offset addieren
        adda.l          d2,a0
        bsr             WAITBLIT              ; Wait on Blitter
        move.l          a0,BLTDPTH(a4)        ; Dest.Adr.
        move.l          a0,BLTCPTH(a4)        ; C = D fuer Minterm
        clr.w           BLTCON1(a4)           ; Only Copy!

        move.w          d4,BLTCON0(a4)        ; Term setzen

        move.w          #$ffff,BLTADAT(a4)    ; ADATA = LinePattern
        move.w          d0,BLTAFWM(a4)        ; Set FirstWordMask
        move.w          d1,BLTALWM(a4)        ; Set LastWordMask
        move.w          d7,BLTSIZE(a4)        ; Size

        move.w          #$03fa,d4             ; MinTerm = Norm
        dbra            d6,HLINE1COLOR        ; Loop

HORLINE1ENDE:
        rts


* Routine um Linien zu Clippen (nach Cohen-SutherLand)
* ParameterUebergabe:
*               a1      = Zeiger auf CoordinatenTabelle
*               a6      = CodeTable

CLIPLINE:
        lea             CODETABLE(pc),a6      ; ADR der LageCodes
        lea             LINKSX(pc),a1         ; ADR des LineArrays
        move.w          (a1),d2               ; d2 = x1
        move.w          2(a1),d3              ; d3 = y1
        movea.w         4(a1),a2              ; a2 = x2
        movea.w         6(a1),a3              ; a3 = y2
        move.w          a2,-(a7)              ; Rette x2 auf Stack
        move.w          a3,-(a7)              ; Rette y2 auf Stack

        moveq           #0,d1                 ; Loesche d1
        cmp.w           #LEFTX,d2             ; Vergleiche mit LeftBound
        bge.s           NOTLEFT1              ; Nein -> .NotLeft
        addq.w          #1,d1                 ; Ja -> d1 = 1
        bra.s           NOTRIGHT1
NOTLEFT1:
        cmp.w           #RIGHTX,d2            ; Vergleiche mit RightBound
        ble.s           NOTRIGHT1             ; Nein -> .NotRight
        addq.w          #2,d1                 ; Ja -> d1 = d1 + 2
NOTRIGHT1:
        cmp.w           #UPY,d3               ; Vergleiche mit UpBound
        bpl.s           NOTUP1                ; Nein -> .NotUp
        addq.w          #4,d1                 ; Ja -> d1 = d1 + 4
        bra.s           NEXTTEST1
NOTUP1:
        cmp.w           #DOWNY,d3             ; Vergleiche mit DownBound
        ble.s           NEXTTEST1             ; Nein -> NextTest
        addq.w          #8,d1                 ; Ja -> d1 = d1 + 8
NEXTTEST1:
        move.w          d1,(a6)               ; Erhaltenen Wert speichern

        moveq           #0,d1                 ; Loesche d1
        cmpa.w          #LEFTX,a2             ; Vergleiche mit LeftBound
        bge.s           NOTLEFT2              ; Nein -> .NotLeft
        addq.w          #1,d1                 ; Ja -> d1 = 1
        bra.s           NOTRIGHT2
NOTLEFT2:
        cmpa.w          #RIGHTX,a2            ; Vergleiche mit RightBound
        ble.s           NOTRIGHT2             ; Nein -> .NotRight
        addq.w          #2,d1                 ; Ja -> d1 = d1 + 2
NOTRIGHT2:
        cmpa.w          #UPY,a3               ; Vergleiche mit UpBound
        bge.s           NOTUP2                ; Nein -> .NotUp
        addq.w          #4,d1                 ; Ja -> d1 = d1 + 4
        bra.s           NEXTTEST2
NOTUP2:
        cmpa.w          #DOWNY,a3             ; Vergleiche mit DownBound
        ble.s           NEXTTEST2             ; Nein -> NextTest
        addq.w          #8,d1                 ; Ja -> d1 = d1 + 8
NEXTTEST2:
        move.w          d1,2(a6)              ; Wert speichern
        tst.w           d1                    ; Is Zero?
        bne.s           TESTW1                ; Nein -> testw1
        tst.w           (a6)                  ; Teste 2.Wert
        beq             DRAWIT2

TESTW1:
        move.w          d1,d0                 ; Test, ob sichtbar
        and.w           (a6),d0
        bne             DRAWEND1

        movea.w         d2,a0                 ; Rette LineCoords
        movea.w         d3,a1
        movea.w         a2,a4
        movea.w         a3,a5

        tst.w           2(a6)                 ; Test ob Lage2 = 0
        bne.s           TESTW2                ; Nein -> testw2
        move.w          a2,RECHTSX            ; x2 speichern
        move.w          a3,RECHTSY            ; y2 speichern
        bra.s           TESTW3                ; -> testw3

TESTW2:
        move.w          (a6),4(a6)            ; Lage1 -> PLage1
        move.w          2(a6),6(a6)           ; Lage2 -> PLage2
        bsr             FINDPOINT             ; Sub FindPoint
        tst.w           4(a6)                 ; Teste SchnittPunkt
        bne             DRAWEND1              ; Nein -> DrawEnd

        move.w          d2,RECHTSX            ; x1 = rx
        move.w          d3,RECHTSY            ; y1 = ry

TESTW3:

        move.w          a4,d2
        move.w          a5,d3
        movea.w         a0,a2
        movea.w         a1,a3
        move.w          2(a6),4(a6)
        move.w          (a6),6(a6)

        tst.w           6(a6)
        bne.s           TESTW4
        move.w          a2,LINKSX
        move.w          a3,LINKSY
        bra.s           DRAWIT1

TESTW4:
        bsr             FINDPOINT
        move.w          d2,LINKSX
        move.w          d3,LINKSY

DRAWIT1:
        lea             LINKSX(pc),a1
        move.w          (a1),d2
        move.w          2(a1),d3
        suba.l          a2,a2
        movea.l         a2,a3
        movea.w         4(a1),a2
        movea.w         6(a1),a3
DRAWIT2:
        lea             LINKSX(pc),a1
        move.w          d2,(a1)
        move.w          d3,2(a1)
        move.w          a2,4(a1)
        move.w          a3,6(a1)

DRAWEND:
        lea             LINKSX(pc),a1

        movem.w         (a1),d0-d3            ; Setzte Regs fuer
;        move.w          2(a1),d1              ; Draw-Line
;        move.w          4(a1),d2
;        move.w          6(a1),d3

* Test ob dx = 0 ob dy = 0
ISEQUAL:
        cmp.w           d0,d2
        bne.s           DRAWS
        cmp.w           d1,d3
        beq.s           DRAWEND1

DRAWS:
        bsr             DRAWLINE
        lea             LINKSX(pc),a1
        move.w          (a7)+,2(a1)           ; OldCursor-Pos
        move.w          (a7)+,(a1)            ;

        rts
* Wird gerufen, wenn Linie nicht sichtbar
DRAWEND1:

        lea             LINKSX(pc),a1
        move.w          (a7)+,2(a1)           ; OldCursor-Pos
        move.w          (a7)+,(a1)            ;

        rts

* Routine um SchnittPunkt mit FensterRand zu ermitteln (rekursiv)

FINDPOINT:
        move.w          d2,d4
        move.w          d3,d5
        add.w           a2,d4
        ext.l           d4

        lsr.l           #1,d4
        add.w           a3,d5
        ext.l           d5
        lsr.l           #1,d5

        moveq           #0,d1                 ; Loesche d1
        cmp.w           #LEFTX,d4             ; Vergleiche mit LeftBound
        bge.s           NOTLEFT3              ; Nein -> .NotLeft
        addq.w          #1,d1                 ; Ja -> d1 = 1
        bra.s           NOTRIGHT3
NOTLEFT3:
        cmp.w           #RIGHTX,d4            ; Vergleiche mit RightBound
        ble.s           NOTRIGHT3             ; Nein -> .NotRight
        addq.w          #2,d1                 ; Ja -> d1 = d1 + 2
NOTRIGHT3:
        cmp.w           #UPY,d5               ; Vergleiche mit UpBound
        bge.s           NOTUP3                ; Nein -> .NotUp
        addq.w          #4,d1                 ; Ja -> d1 = d1 + 4
        bra.s           NEXTTEST3
NOTUP3:
        cmp.w           #DOWNY,d5             ; Vergleiche mit DownBound
        ble.s           NEXTTEST3             ; Nein -> NextTest
        addq.w          #8,d1                 ; Ja -> d1 = d1 + 8
NEXTTEST3:
        move.w          6(a6),d6
        and.w           d1,d6
        bne.s           FANDERS

        cmp.w           d4,d2
        bne.s           FINDW1
        cmp.w           d5,d3
        beq.s           FENDE

FINDW1:
        cmpa.w          d4,a2
        bne.s           FINDW2
        cmpa.w          d5,a3
        bne.s           FINDW2
        bra.s           FENDE

FINDW2:
        move.w          d4,d2
        move.w          d5,d3
        move.w          d1,4(a6)
        bra.s           FINDPOINT

FANDERS:
        cmpa.w          d4,a2
        bne.s           FANDERS1
        cmpa.w          d5,a3
        beq.s           FENDE

FANDERS1:
        cmp.w           d4,d2
        bne.s           FANDERS2
        cmp.w           d5,d3
        beq.s           FENDE

FANDERS2:
        tst.w           4(a6)
        beq.s           FANDERS3
        move.w          d1,d7
        and.w           4(a6),d7
        bne.s           FEXIT

FANDERS3:
        movea.w         d4,a2
        movea.w         d5,a3
        move.w          d1,6(a6)
        bra             FINDPOINT

FEXIT:
        move.w          #1,4(a6)
FENDE:
        rts

* Routine zieht Horline mit Daten aus ScreenPort
HORLINESET:     REG d0-d4/d6-a1/a4
HORLINE2:
        movem.l         HORLINESET,-(a7)      ; Save Regs on Stack !
        move.w          X_1(a6),d0            ; X1 -> d0
        move.w          X_2(a6),d1            ; X2 -> d1
        move.w          Y_1(a6),d2            ; Y1 -> d2
        bsr             HORLINE1              ; Ziehe Linie
        movem.l         (a7)+,HORLINESET      ; Get Regs from Stack !
        rts

* Routine zeichnet Plastizitaets-Rahmen
*
PLASTSET:       REG d5-d7
PLASTBOX:
        movem.l         PLASTSET,-(a7)        ; Regs retten

        move.w          Y_1(a6),d5            ; Fetch Y1
        move.w          X_2(a6),d6            ; Fetch X2
        move.w          Y_2(a6),d7            ; Fetch Y2
        subq.w          #1,X_2(a6)            ; DEC X2

        move.w          #DARKCOL,COLOR(a6)    ; SET Color
        bsr             HORLINE2              ; Oberen Rand zeichnen

        addq.w          #1,X_2(a6)            ; INC X2 ( Correct )
        addq.w          #1,X_1(a6)            ; INC X1

        move.w          #LIGHTCOL,COLOR(a6)   ; SET Color
        move.w          d7,Y_1(a6)            ; Y2 = Y1 fuer unteren Rand

        bsr             HORLINE2              ; Draw HorLine

        subq.w          #1,X_1(a6)            ; DEC X1 ( Correct )
        subq.w          #1,Y_2(a6)            ; DEC Y2

        move.w          #DARKCOL,COLOR(a6)    ; SET Color
        move.w          d5,Y_1(a6)            ; SET Y1
        bsr             VLINE                 ; Linke Linie zeichnen

        addq.w          #1,Y_1(a6)            ; INC Y1
        move.w          #LIGHTCOL,COLOR(a6)   ; SET Color
        move.w          d6,X_1(a6)            ; SET X1 fuer rechte Linie
        bsr             VLINE                 ; Draw VLine
        movem.l         (a7)+,PLASTSET        ; Regs holen
        rts

* Routine kopiert String
* Input:
*       a0 = SourceStr
*       a1 = DestStr
STRCOPY:
        move.b          (a0)+,d7              ; SourceASCII -> d7
        beq.s           STRCOPYEND            ; = 0 -> Ende
        move.b          d7,(a1)+              ; ASCII -> Dest.
        bra.s           STRCOPY               ; -> Loop
STRCOPYEND:
        rts                                   ; Back

* Routine errechnet Stringlaenge fuer 6x6-Zeichensatz
* Input:
*       a3 = PTR to String
* Output:
*       d5 = Laenge
STRLENGTH:
        move.l          a3,-(a7)              ; Save Reg on Stack !
        moveq           #0,d5                 ; Laenge = 0
STRLLOOP:
        tst.b           (a3)+                 ; Ist Ende ?
        beq.s           STRLLENDE             ; Ja -> Ende
        addq.w          #6,d5                 ; INC Length
        bra.s           STRLLOOP              ; -> Loop
STRLLENDE:
        movea.l         (a7)+,a3              ; Get Reg from Stack !
        rts                                   ; Back !

* Routine gibt nullterminierten String aus
* UebergabeParameter:
*       a3 = Zeiger auf String
*       X und Y Koordinate werden aus Grafik-Port geholt
CHAROUTSET:     REG d0-a2
STRINGOUT:
        movem.l         CHAROUTSET,-(a7)
STRINGOUTLOOP:
        move.b          (a3)+,d7              ; Hole ASCII-Zeichen
        and.w           #$00ff,d7
        beq.s           STRINGOUTENDE
        bsr.s           CHAROUT               ; gib es aus
        addi.w          #6,X_1(a6)            ; 1 Character weiter
        bra.s           STRINGOUTLOOP         ; Loop
STRINGOUTENDE:
        movem.l         (a7)+,CHAROUTSET
        rts

* Routine gib 6x6 Zeichensatz an beliebiger Stelle aus
* UebergabeParameter:
*           d7          = ASCII-Code
* RegisterUse:
*           d0          = X
*           d1          = Y
*           d2          = ShiftValue
*           d3          = ShiftValue
*           d4          = Color
*           d5          = LoopCounter
*           d6          = Left Image
*           d7          = Right Image
*           a0          = Zeiger auf CharDefinition
*           a1          = Zeiger auf BPLPORT
*           a2          = Bitplaneoffset
CHAROUT:
        move.w          COLOR(a6),d4          ; COLOR -> d4
        lea             PLANES(a6),a1         ; a1 now Bildschirmoffset
        lea             STDCHARS(pc),a0       ; A0 now Base of Images
        lsl.w           #3,d7                 ; ASCII mal 8 = Offset
        lea             0(a0,d7.w),a0         ; ADD Offset a0 = IMAGE

        move.w          X_1(a6),d0            ; Fetch X
        move.w          Y_1(a6),d1            ; Fetch Y
        add.w           d1,d1                 ; Mal 2 fuer Datenfetch
        move.w          MULU160(a6,d1.w),d1   ; d1 now Y-Offset
        and.l           #$0000ffff,d1         ; Oberes Wort = 0
        move.w          d0,d2                 ; X-Coord retten
        lsr.w           #3,d0                 ; X-Coord / 8 = Byte
        ext.l           d0                    ; LangWort erweitern !
        add.l           d0,d1                 ; d1 now Complete Offset
        move.l          d1,-(a7)              ; Offset auf Stack
        and.w           #7,d2                 ; d2 Shift-Value
        moveq           #8,d3                 ; Zweiten Shiftwert initialisieren
        sub.w           d2,d3                 ; Init
        move.w          SCRPLANESC(a6),d5     ; Init LoopCounter

CHAROUTLOOP:
        movea.l         (a1)+,a2              ; BITPLANEoffset holen
        adda.l          (a7),a2               ; Offset addieren
        lsr.w           #1,d4                 ; COLOR shiften
        bcc             IMAGECLEAR            ; -> Clear Plane
                REPT 8
        move.b          (a0),d6               ; BITMAP in d6
        move.b          (a0)+,d7              ; und d7
        lsr.b           d2,d6                 ; d6 now LeftImage
        lsl.b           d3,d7                 ; d7 now RightImage
        move.b          d6,d0                 ; Left Image duplizieren
        move.b          d7,d1                 ; Right Image duplizieren
        not.b           d0                    ; Not it
        not.b           d1                    ; Not it
        and.b           d0,(a2)
        and.b           d1,1(a2)
        or.b            d6,(a2)               ; Left Image
        or.b            d7,1(a2)              ; Right Image
        adda.w          ONELINEB(a6),a2       ; Add one Line
                ENDR
        subq.w          #8,a0                 ; Imagepointer korrigieren
        dbra            d5,CHAROUTLOOP        ; Loop
        move.l          (a7)+,d0
        rts

IMAGECLEAR:
                REPT 8
        move.b          (a0),d6               ; BITMAP in d6
        move.b          (a0)+,d7              ; und d7
        lsr.b           d2,d6                 ; d6 now LeftImage
        lsl.b           d3,d7                 ; d7 now RightImage
        move.b          d6,d0                 ; Left Image duplizieren
        move.b          d7,d1                 ; Right Image duplizieren
        not.b           d0                    ; Not it
        not.b           d1                    ; Not it
        and.b           d0,(a2)
        and.b           d1,1(a2)
        adda.w          ONELINEB(a6),a2       ; Add one Line
                ENDR
        subq.w          #8,a0                 ; Imagepointer korrigieren
        dbra            d5,CHAROUTLOOP        ; Loop
        move.l          (a7)+,d0
        rts


* Routine zieht vertikale Linie
* RegisterUse:
*       d0              =                 Y1
*       d1              =                 Y2
*       d2              =                 X1
*       d3              =                 COLOR
*       d4              =                 BufferReg
*       d5              =                 BufferReg
*       d6              =                 LoopCounter
*       a1              =                 ADR of BPLport
VLINESET:       REG d0-d6/a0-a1
VLINE:
        movem.l         VLINESET,-(a7)
        move.w          Y_1(a6),d0            ; Hole Y1
        move.w          Y_2(a6),d1            ; Hole Y2
        cmp.w           d0,d1                 ; Is Y2 < Y1
        bge.s           Y2NOTGY1              ; Nein -> Kein RegisterTausch
        exg             d0,d1                 ; Vertausche Y2 Y1
Y2NOTGY1:
        sub.w           d0,d1                 ; d1 now DY = LoopCounter
        move.w          X_1(a6),d2            ; Hole X1
        move.w          COLOR(a6),d3          ; COLOR -> d3

        add.w           d0,d0                 ; MAL 2 fuer DatenFetch
        move.w          MULU160(a6,d0.w),d0   ; d0 = FirstOffset
        and.l           #$0000ffff,d0         ; Oberes Word loeschen
        move.w          d2,d4                 ; Rette X1
        lsr.w           #3,d4                 ; / 8
        ext.l           d4                    ; LangWort erweitern
        add.l           d4,d0                 ; d0 now Offset
        move.l          d0,-(a7)              ; Offset auf Stack
        and.w           #$0007,d2             ; Bits ausmaskieren
        not.w           d2
        move.w          d1,d5                 ; Rette DY = 2. LoopCounter
        lea             PLANES(a6),a1         ; ADR des BPLPORTS
        move.w          SCRPLANESC(a6),d6     ; Init LoopCounter

VLINELOOP:
        movea.l         (a7),a0               ; Offset -> a0
        adda.l          (a1)+,a0              ; BPL addieren
        lsr.w           #1,d3                 ; Shift ColorWert
        bcs.s           LOOPSTVLINE           ; Bit wird gesetzt

LOOPCLVLINE:
        bclr            d2,(a0)               ; Loesche Bit
        adda.w          ONELINEB(a6),a0       ; Addiere 1 RasterZeile
        dbra            d1,LOOPCLVLINE        ; -> LoopCLVline
        move.w          d5,d1                 ; DY restaurieren
        dbra            d6,VLINELOOP          ; -> Vlineloop
        move.l          (a7)+,d0              ; Offset vom Stack holen
        movem.l         (a7)+,VLINESET        ; Regs holen
        rts

LOOPSTVLINE:
        bset            d2,(a0)               ; Setze BIT
        adda.w          ONELINEB(a6),a0       ; Addiere 1 RasterZeile
        dbra            d1,LOOPSTVLINE        ; -> LoopSTVline
        move.w          d5,d1                 ; DY restaurieren
        dbra            d6,VLINELOOP          ; -> Vlineloop
        move.l          (a7)+,d0              ; Offset vom Stack holen
        movem.l         (a7)+,VLINESET        ; Regs holen
        rts

* Sinus-Routine fuer Scape-Flight
* Beginn 3.10.1988 11.15
* ENDE   7.10.1988 20.00

* 3D-Berechnung samt Zentral-Punkt-Perspektive
*

DREID:
        bsr             GETROTATION           ; Errechne Rotations-Matrix

*==========================================*
* Hier beginnt die Schleife zur Berechnung *
*==========================================*

* Zunaechst Adress-Register festlegen

        lea             OUTCOURT(pc),a0       ; DestArray -> a0
        lea             COURT(pc),a2          ; SourceArray -> a2
        lea             ROTTABLE(pc),a3       ; RotTable -> a3

* SchleifenZaehler  =   d7

        move.w          #COURTSIZE,d7         ; CourtSize = LoopCounter
        subq.w          #1,d7                 ; DEC LoopCounter

* RegisterUse:          d0      =       x
*                       d1      =       y
*                       d2      =       z
*                       a4      =       a1
*                       a5      =       a2
*                       a6      =       a3

OUTLOOP:

* X-Berechnung
        move.w          (a2)+,d0              ; X -> d0
;        subq.w          #DG,d0                ; Sub Distance
;        muls            #AGX,d0               ; Mult. agx
        move.l          d0,d1                 ; x -> d1
        muls            (a3),d1               ; a1 = ax1 * x
        movea.l         d1,a4                 ; d6 = a1
        move.w          d0,d1                 ; x -> d1
        muls            6(a3),d1              ; a2 = ay1 * x
        movea.l         d1,a5                 ; a4 = a2
        move.w          d0,d1                 ; x -> d1
        muls            12(a3),d1             ; a3 = az1 * x
        movea.l         d1,a6                 ; a5 = a3

INLOOP:

* Y-Berechnung

        move.w          (a2)+,d1              ; Y -> d1
;        subq.w          #DG,d1                ; Sub Distance
;        muls            #AGY,d1               ; Mult. agy

* Z-Berechnung

        move.w          (a2)+,d2              ; Z -> d2
;        muls            #AGZ,d2               ; MAL agz

*======================*
* HauptTerme errechnen *
*======================*

*       ax = a1 + ax2*y + ax3*z
*       d3 = (a4 + 2(a3)*d1 + 4(a3)*d2) / 32767

        move.w          d1,d3                 ; y -> d3
        move.w          d2,d4                 ; z -> d4
        muls            2(a3),d3              ; ax2 * y
        muls            4(a3),d4              ; ax3 * z
        add.l           d4,d3                 ; Add Terms
        add.l           a4,d3                 ; Add a1 to Term
        add.l           d3,d3                 ; SHIFT 1
        swap            d3                    ; Divide
* d3 now ax

*       ay = a2 + ay2*y + ay3*z
*       d4 = (a5 + 8(a3)*d1 + 10(a3)*d2) / 32767

        move.w          d1,d4                 ; y -> d4
        move.w          d2,d5                 ; z -> d5
        muls            8(a3),d4              ; ay2 * y
        muls            10(a3),d5             ; ay3 * z
        add.l           d5,d4                 ; Add Terms
        add.l           a5,d4                 ; Add a2 to Term
        add.l           d4,d4                 ; SHIFT 1
        swap            d4                    ; Divide
* d4 now ay

*       az = a3 + az2*y + az3*z
*       d5 = (a6 + 14(a3)*d1 + 16(a3)*d2) / 32767

        muls            14(a3),d1             ; az2 * y
        muls            16(a3),d2             ; az3 * z
        add.l           d2,d1                 ; Add Terms
        add.l           a6,d1                 ; Add a3 to Term
        add.l           d1,d1                 ; SHIFT 1
        swap            d1                    ; Divide
        move.w          d1,d5                 ; d5 now az

* Berechne af fuer Zentral-Punkt-Per.
*       af = az+rho
* Errechnen der Zentral-Punktperspektive

        ext.l           d5
        move.w          DIS1REG(pc),d2        ; DIST -> d2
        sub.w           d5,d2                 ; SUB az von DIST
        ext.l           d2                    ; Erweitern
        asl.l           #8,d2                 ; Werteanpassung
        move.w          DISREG(pc),d1         ; BeobachtungsPkt.
        ext.l           d1                    ; Erweitern
        sub.l           d5,d1                 ; Minus z-Koordinate
        beq.s           STORECOORDS           ; Null abfangen
        divs            d1,d2                 ; Faktor errechnen

        move.w          d2,d1
        move.w          d3,d0                 ; x-Coord. -> d0
        neg.w           d3
        muls            d3,d1
        asr.l           #8,d1
        add.w           d1,d0                 ; ADD to x-Coord

        move.w          d0,d3                 ; d3 now x-Coord

* Jetzt fuer y-Coordinate

        move.w          d4,d0
        neg.w           d4
        muls            d4,d2
        asr.l           #8,d2
        add.w           d2,d0
        move.w          d0,d4

* Free Regs:            d2,d6,d7

*       ax = ax+mmx     ay = ay+mmy

        addi.w          #MMX,d3               ; ADD mmx zu ax
        addi.w          #MMY,d4               ; ADD mmy zu ay

* Traegt ax und ay in XArray und YArray
STORECOORDS:
        movem.w         d3-d5,(a0)            ; Ablegen ax,ay,az in Array
        addq.w          #6,a0                 ; INC a0

* Jetzt wird geloopt, dass die CPU qualmt

LOOPTERMS:
        dbra            d7,OUTLOOP            ; -> Loop

        rts                                   ; Back to Call


**********************************************
* Routine zum Errechnen der Rotations-Matrix *
**********************************************

GETROTATION:
        lea             ROTTABLE(pc),a2       ; RMatrix -> a2
        lea             ROTMATR(pc),a1        ; ADR -> a1
        move.w          W1REG(pc),d0          ; Winkel -> d0
        bsr             SICO                  ; Get SiCo
        move.w          d1,(a1)               ; Save Sinus
        move.w          d2,2(a1)              ; Save Cosinus
        move.w          W2REG(pc),d0          ; Same Way for w2
        bsr             SICO
        move.w          d1,4(a1)
        move.w          d2,6(a1)
        move.w          W3REG(pc),d0          ; Same Way for w3
        bsr             SICO
        move.w          d1,8(a1)
        move.w          d2,10(a1)

* Berechne ax1 = b2 * b3 -> (a2) = 6(a1)*10(a1) / 32767

        move.w          d2,d4                 ; d4 = Erg.Reg.
        muls            6(a1),d4              ; Multiply It!
        add.l           d4,d4                 ; SHIFT 1
        swap            d4                    ; DIVIDE
        move.w          d4,(a2)+              ; Save Term!

* Berechne ax2 = -b2 * a3 -> 2(a2) = -(6(a1))*8(a1) / 32767

        move.w          6(a1),d3              ; Get Term to Neg!
        move.w          8(a1),d4              ; Get a3
        neg.w           d3                    ; d3 = -b2
        muls            d3,d4                 ; Multiply It!
        add.l           d4,d4                 ; SHIFT 1
        swap            d4                    ; Divide
        move.w          d4,(a2)+              ; Save Term!

* Berechne ax3 = a2 -> 4(a2) = 4(a1)

        move.w          4(a1),(a2)+           ; Thats All!

* Berechne ay1 = b1 * a3 + a1 * a2 * b3
* Zerlegung:    t1 = b1 * a3 / 32767 -> t1 = 2(a1) *  8(a1) / 32767
*               t2 = a1 * a2 / 32767 -> t2 =  (a1) *  4(a1) / 32767
*               t3 = t2 * b3 / 32767 -> t3 =   t2  * 10(a1) / 32767
*          ay1 = t1 + t3 -> 6(a2) = t1 + t3

        move.w          8(a1),d4              ; Berechne t1
        muls            2(a1),d4              ; d4 = t1
        move.w          4(a1),d5              ; Berechne t2
        muls            (a1),d5
        add.l           d4,d4                 ; SHIFT 1
        add.l           d5,d5
        swap            d4                    ; Divide
        swap            d5                    ;
        muls            10(a1),d5             ; Berechne t3
        add.l           d5,d5                 ; SHIFT 1
        swap            d5                    ; Divide
        add.w           d5,d4                 ; t1 + t3 =
        move.w          d4,(a2)+              ; = ay1

* Berechne ay2 = b1 * b3 - a1 * a2 * a3
* Zerlegung:    t1 = b1 * b3 / 32767 -> t1 = 2(a1) * 10(a1) / 32767
*               t2 = a1 * a2 / 32767 -> t2 =  (a1) *  4(a1) / 32767
*               t3 = t2 * a3 / 32767 -> t3 =   t2  *  8(a1) / 32767
*          ay2 = t1 - t3 -> 8(a2) = t1 - t3

        move.w          10(a1),d4             ; Berechne t1
        muls            2(a1),d4              ; d4 = t1
        move.w          4(a1),d5              ; Berechne t2
        muls            (a1),d5               ; d5 = t2
        add.l           d4,d4                 ; SHIFT 1
        add.l           d5,d5                 ; SHIFT 1
        swap            d4                    ; Divide
        swap            d5                    ;
        muls            8(a1),d5              ; d5 = t3
        add.l           d5,d5                 ; SHIFT 1
        swap            d5                    ; Divide
        sub.w           d5,d4                 ; t1 - t3 =
        move.w          d4,(a2)+              ; = ay2

* Berechne ay3 = -a1 * b2  -> 10(a2) = -((a1)) * 6(a1) / 32767

        move.w          (a1),d4               ; d4 = a1
        neg.w           d4                    ; NEG It!
        muls            6(a1),d4              ; Multi.
        add.l           d4,d4                 ; SHIFT 1
        swap            d4
        move.w          d4,(a2)+              ; Store ay3

* Berechne az1 = a1 * a3 - b1 * a2 * b3
* Zerlegung:    t1 = a1 * a3 / 32767 -> t1 =  (a1) *  8(a1) / 32767
*               t2 = b1 * a2 / 32767 -> t2 = 2(a1) *  4(a1) / 32767
*               t3 = t2 * b3 / 32767 -> t3 =   t2  * 10(a1) / 32767
*          az1 = t1 - t3 -> 12(a2) = t1 - t3

        move.w          (a1),d4               ; Berechne t1
        muls            8(a1),d4              ; Mult.
        move.w          2(a1),d5              ; Berechne t2
        muls            4(a1),d5              ; Mult.
        add.l           d4,d4                 ; SHIFT 1
        add.l           d5,d5                 ;
        swap            d4                    ; Divide
        swap            d5                    ;
        muls            10(a1),d5             ; d5 = t3
        add.l           d5,d5                 ; SHIFT 1
        swap            d5                    ; Divide
        sub.w           d5,d4                 ; t1 - t3 =
        move.w          d4,(a2)+              ; = az1

* Berechne az2 = a1 * b3 + b1 * a2 * a3
* Zerlegung:    t1 = a1 * b3 / 32767 -> t1 =  (a1) * 10(a1) / 32767
*               t2 = b1 * a2 / 32767 -> t2 = 2(a1) *  4(a1) / 32767
*               t3 = t2 * a3 / 32767 -> t3 =   t2  *  8(a1) / 32767
*          az2 = t1 + t3 -> 14(a2) = t1 + t3

        move.w          (a1),d4               ; Berechne t1
        muls            10(a1),d4             ; Mult.
        move.w          2(a1),d5              ; Berechne t2
        muls            4(a1),d5              ; Mult.
        add.l           d4,d4                 ; SHIFT 1
        add.l           d5,d5                 ; SHIFT 1
        swap            d4                    ; Divide
        swap            d5                    ;
        muls            8(a1),d5              ; Berechne t3
        add.l           d5,d5                 ; SHIFT 1
        add.w           d5,d4                 ; t1 + t3 =
        move.w          d4,(a2)+              ; = az2

* Berechne az3 = b1 * b2 -> 16(a2) = 2(a1) * 6(a1)

        move.w          2(a1),d4              ; Wert -> d4
        muls            6(a1),d4              ; Mult.
        add.l           d4,d4                 ; SHIFT 1
        swap            d4                    ; Divide
        move.w          d4,(a2)+              ; Store It!

        rts                                   ; Back to the Roots!

* Uebergabe-Parameter
* d0    =       Winkel im Bogenmass
* Rueckgabe
* d1    =       Sinus
* d2    =       Cosinus

SICO:
        tst.w           d0                    ; Winkel negativ?
        bpl.s           NOROUNDUP             ; Nicht add!
        addi.w          #360,d0

NOROUNDUP:

        lea             SINTAB(pc),a0         ; ADR der SinusTab.
        move.l          d0,d2                 ; Wert retten
        add.w           d0,d0                 ; d0=2*d0
        move.w          0(a0,d0.w),d1         ; Get Value!

        cmp.w           #270,d2               ; Winkel<270
        blt.s           PLUS90                ; Ja->plus90
        subi.w          #270,d2
        bra.s           GETCOS
PLUS90:
        addi.w          #90,d2
GETCOS:
        add.w           d2,d2
        move.w          0(a0,d2.w),d2         ; COS in d2
        rts                                   ; Back

* Routine errechnet Tangens eines Winkels zwischen 45 und 135 Grad aus Tabelle
* Input:
*       d0  =  Winkel
* Output:
*       d0  =  Tangens
TANGENS:
        lea             TANTAB(pc),a0         ; TanTabBase -> a0
        sub.w           #45,d0                ; Tabelle faengt bei 45 Grad an
        add.w           d0,d0                 ; * 2 fuer Wort-Zugriff
        move.w          0(a0,d0.w),d0         ; Hole Wert aus Tabelle
        rts                                   ; Back to Call !

* Routine sortiert die RangListe bzw. die Offsets
* QuickSort nach Algorithms and DataStructures in Modula 2
*        (N. Wirth) S. 96
*        LeftIndex        =        d6
*        RightIndex       =        d7
*        MitteWert        =        d5
*        Feld              =        a0
QSORT:
        moveq           #0,d6                 ; Linker Rand = 0
        move.w          #63*2,d7              ; Anzahl der SortObj -> d7
        lea             RANKOFFS(pc),a0       ; OffsetFeld -> a0
        lea             TABLEMALE(pc),a1      ; TabelleBase -> a1
SORTIT:
        move.w          d6,d5                 ; Linken Rand -> d5
        add.w           d7,d5                 ; ADD rechten Rand -> d5
        lsr.w           #1,d5                 ; Berechne Mitte
        andi.w          #$fffe,d5             ; No odd Address
        move.w          0(a0,d5.w),d5         ; Mittlerer Wert -> d5
        move.w          PL_RANK(a1,d5.w),d5   ; Hole Ranglistenpunkte
        move.w          d6,d0                 ; Linken Rand -> d0
        move.w          d7,d1                 ; Rechten Rand -> d1

LEFTWHILE:
        move.w          0(a0,d0.w),d4         ; Hole Offset !
        move.w          PL_RANK(a1,d4.w),d4   ; Hole Ranglistenpunkte
        cmp.w           d4,d5                 ; Vergl. [d0] mit Mitte
        bge.s           RIGHTWHILE            ; Mitte <= [d0] -> RightWhile
        addq.w          #2,d0                 ; INC d0
        bra.s           LEFTWHILE             ; -> LeftWhile

RIGHTWHILE:
        move.w          0(a0,d1.w),d4         ; Hole Offset !
        move.w          PL_RANK(a1,d4.w),d4   ; Hole Ranglistenpunkte
        cmp.w           d4,d5                 ; Vergl. [d0] mit Mitte
        ble.s           CHANGE                ; Mitte >= [d1] -> Change
        subq.w          #2,d1                 ; DEC d1
        bra.s           RIGHTWHILE            ; -> RightWhile

CHANGE:

        cmp.w           d1,d0                 ; Vergl. [d1] [d0]
        bgt.s           REPEAT                ; [d0] > [d1] -> Repeat

        move.w          0(a0,d0.w),d2         ; Hole Offset !
        move.w          0(a0,d1.w),0(a0,d0.w) ; Swap Offsets
        move.w          d2,0(a0,d1.w)         ; Lege Offset ab !

        addq.w          #2,d0                 ; INC d0
        subq.w          #2,d1                 ; DEC d1

REPEAT:

        cmp.w           d1,d0                 ; Vergl. [d1] [d0]
        bgt.s           REKURSIV1             ; [d0] > [d1] -> Rekursiv1
        bra.s           LEFTWHILE             ; -> LeftWhile

REKURSIV1:

        cmp.w           d1,d6                 ; Vergl. Linken Rand [d1]
        bge.s           REKURSIV2             ; LR >= [d1] -> Rekursiv2
        movem.w         d0/d7,-(a7)           ; Werte auf Stack
        move.w          d1,d7                 ; Rechter Rand = Rechter Index
        bsr.s           SORTIT                ; Rekursion
        movem.w         (a7)+,d0/d7           ; Hole Werte vom Stack

REKURSIV2:

        cmp.w           d0,d7                 ; Vergl. Rechten Rand [d0]
        ble.s           BACK                  ; RR <= [d0] -> RTS
        movem.w         d1/d6,-(a7)           ; Werte auf Stack
        move.w          d0,d6                 ; Linker Rand = Linker Index
        bsr             SORTIT                ; Rekursion
        movem.w         (a7)+,d1/d6           ; Hole Werte vom Stack
BACK:
        rts                                   ; Back to Call!


; Routine gibt Registerinhalt von d4 aus
; Parameter:
;                       d5 = Register
;                       d6 = Spalte
;                       d7 = Zeile
; RegisterUse: ( Werden gerettet )
;                       a1 = Zeiger auf Character-Definitionen
;                       a2 = Zeiger auf Screen

DECUMRECHNUNG:
        lea             OUBUFFER(pc),a3       ; OutBufferBase -> a3
        tst.l           d4
        beq.s           ISZERO
        bmi.s           ISNEG
        neg.l           d4
        bra.s           MAINCONVERT
ISNEG:
        move.b          #"9"+7,(a3)+
MAINCONVERT:
        lea             POTENZTABLE(pc),a1
        moveq           #0,d1
CONVERTLOOP:
        move.l          (a1)+,d2
        beq.s           ISZERO
        moveq           #-1,d0
ADDPOT:
        add.l           d2,d4
        dbgt            d0,ADDPOT
        sub.l           d2,d4
        addq.w          #1,d0
        bne.s           NOTONEADD
        tst.w           d1
        beq.s           CONVERTLOOP

NOTONEADD:
        moveq           #-1,d1
        neg.b           d0
        addi.b          #"0",d0
        move.b          d0,(a3)+
        bra.s           CONVERTLOOP
ISZERO:
        neg.b           d4
        addi.b          #"0",d4
        move.b          d4,(a3)+
        move.b          #0,(a3)+
        rts                                   ; Back !

********************************************************************************
*                                Datenbereich                                  *
********************************************************************************
                EVEN
OKTTABLE:       DC.B 0*4+1
                DC.B 4*4+1
                DC.B 2*4+1
                DC.B 5*4+1
                DC.B 1*4+1
                DC.B 6*4+1
                DC.B 3*4+1
                DC.B 7*4+1
                EVEN
MASKTAB:        DC.W $ffff,$7fff,$3fff,$1fff,$0fff,$07ff,$03ff
                DC.W $01ff,$00ff,$007f,$003f,$001f,$000f
                DC.W 7,3,1,0
                EVEN
KEYFUNC:        DC.L CUP,CDOWN,CRIGHT,CLEFT,CTQ,CTW,CTE,CTR,RECEIVEMOTION
                EVEN
OUBUFFER:       DS.B 12
********************************************************************************
*                       FarbTabellen fuer 3D-Verdeckung                        *
********************************************************************************
FBCK:           EQU $00                 ; BackGroundColor ( black )
FGL:            EQU $00000fff           ; GrundlinienFarbe ( weiss )
FGR:            EQU $00000070           ; Bodenfarbe ( Green )
FNET:           EQU $00000fff           ; NetzFarbe ( Weiss )
FBS:            EQU $00000040           ; BallSchattenFarbe ( DK. Green )
FBB:            EQU $00000ee0           ; BallFarbe ( Yellow )
FSG:            EQU $00000060           ; SpecialFarbe ( LDK. Green )
;--------------------------------------
FGL1:           EQU $00000fff           ; GrundlinienFarbe ( weiss )
FGR1:           EQU $00000b50           ; Bodenfarbe ( Orange )
FNET1:          EQU $00000fff           ; NetzFarbe ( Weiss )
FBS1:           EQU $00000820           ; BallSchattenFarbe ( DK. Orange )
FBB1:           EQU $00000ee0           ; BallFarbe ( Yellow )
FSG1:           EQU $00000a40           ; SpecialFarbe ( LDK. Orange )
;--------------------------------------
FGL2:           EQU $00000fff           ; GrundlinienFarbe ( weiss )
FGR2:           EQU $00000007           ; Bodenfarbe ( Blue )
FNET2:          EQU $00000fff           ; NetzFarbe ( Weiss )
FBS2:           EQU $00000004           ; BallSchattenFarbe ( DK. Blue )
FBB2:           EQU $00000ee0           ; BallFarbe ( Yellow )
FSG2:           EQU $00000006           ; SpecialFarbe ( LDK. Blue )
;--------------------------------------
                EVEN
BS00:           DC.W FBCK,FGL,FGR,FGL,FNET,FNET,FNET,FNET
                DC.W FBS,FSG,FBS,FSG,FBS,FBS,FBS,FBS
                DC.W FBB,FBB,FBB,FBB,FBB,FBB,FBB,FBB
                DC.W FBB,FBB,FBB,FBB,FBB,FBB,FBB,FBB
;--------------------------------------
BS01:           DC.W FBCK,FGL,FGR,FGL,FNET,FNET,FNET,FNET
                DC.W FBS,FSG,FBS,FSG,FNET,FNET,FNET,FNET
                DC.W FBB,FBB,FBB,FBB,FBB,FBB,FBB,FBB
                DC.W FBB,FBB,FBB,FBB,FBB,FBB,FBB,FBB
;--------------------------------------
BS10:           DC.W FBCK,FGL,FGR,FGL,FNET,FNET,FNET,FNET
                DC.W FBS,FSG,FBS,FSG,FBS,FBS,FBS,FBS
                DC.W FBB,FBB,FBB,FBB,FNET,FNET,FNET,FNET
                DC.W FBB,FBB,FBB,FBB,FBS,FBS,FBS,FBS ; ????
;--------------------------------------
BS11:           DC.W FBCK,FGL,FGR,FGL,FNET,FNET,FNET,FNET
                DC.W FBS,FSG,FBS,FSG,FNET,FNET,FNET,FNET
                DC.W FBB,FBB,FBB,FBB,FNET,FNET,FNET,FNET
                DC.W FBB,FBB,FBB,FBB,FNET,FNET,FNET,FNET
;--------------------------------------
TABLECHOOSE:    DC.L BS00,BS01,BS10,BS11 ; Welche Tabelle
;--------------------------------------
REPCOLS:        DC.W FGL,FGR,FNET,FBS,FBB,FSG ; Buffer der akt. RepCols
;--------------------------------------
AUSTRACOLS:     DC.W FGL,FGR,FNET,FBS,FBB,FSG ; Buffer der RepCols (Australien)
;--------------------------------------
FRANCECOLS:     DC.W FGL1,FGR1,FNET1,FBS1,FBB1,FSG1 ; Buffer der RepCols(France)
;--------------------------------------
USACOLS:        DC.W FGL2,FGR2,FNET2,FBS2,FBB2,FSG2 ; Buffer der RepCols( USA )
;--------------------------------------
SPRCTABLE:      DC.W $0fff,$0999,$011c,$0811,$ffff,$0a80,$0ca0,$0864
                DC.W $ffff,$0f00,$000f,$0aaa,$ffff,$0ff0,$0aa0,$0660
;--------------------------------------
SGOSCOLOR:      DC.W $00,$0876,$0432,$0cba
                DS.W 12
ACTCOLTABLE:    DS.W 32                 ; Buffer fuer aktuelle Farbpalette
DIMCOLTABLE:    DS.W 32                 ; Buffer fuer FarbEffekt
ZEROTABLE:      DS.W 32                 ; 0-Woerter
********************************************************************************
*                                 CopperListe                                  *
********************************************************************************
                EVEN
COPPERSTART:
                DC.W BPL1PTH,0
                DC.W BPL1PTL,0
                DC.W BPL2PTH,0
                DC.W BPL2PTL,0
                DC.W BPL3PTH,0
                DC.W BPL3PTL,0
                DC.W BPL4PTH,0
                DC.W BPL4PTL,0
                DC.W BPL5PTH,0
                DC.W BPL5PTL,0
COPPERSCREEN:   DC.W BPLCON0,0          ; Wichtige ScreenDaten
                DC.W DIWSTRT,0
                DC.W DIWSTOP,0
                DC.W DDFSTRT,0
                DC.W DDFSTOP,0
                DC.W BPLCON1,0
                DC.W BPLCON2,$0012
                DC.W BPL1MOD,0
                DC.W BPL2MOD,0
                DC.W DMACON,$8020
COPPERSPRITES:  DC.W $0120,0            ; sprite-pointer
                DC.W $0122,0
                DC.W $0124,0
                DC.W $0126,0
                DC.W $0128,0
                DC.W $012a,0
                DC.W $012c,0
                DC.W $012e,0
                DC.W $0130,0
                DC.W $0132,0
                DC.W $0134,0
                DC.W $0136,0
                DC.W $0138,0
                DC.W $013a,0
                DC.W $013c,0
                DC.W $013e,0
                DC.W $5011,$fffe        ; Warte auf Zeile 100
                DC.W INTENA,$c010       ; CopperIrq erlauben
                DC.W INTREQ,$8010       ; CopperIrq ausloesen
                DC.W $ffff,$fffe        ; Eigtl. Ende der CopperListe
                DC.W $ff01,$fffe
COPEFFECT1:     DC.W COLOR00,0
                DC.W COLOR00+2,0
                DC.W COLOR00+4,0
                DC.W COLOR00+6,0
                DC.W COLOR00+8,0
                DC.W COLOR00+10,0
                DC.W COLOR00+12,0
                DC.W COLOR00+14,0
                DC.W COLOR00+16,0
                DC.W COLOR00+18,0
                DC.W COLOR00+20,0
                DC.W COLOR00+22,0
                DC.W COLOR00+24,0
                DC.W COLOR00+26,0
                DC.W COLOR00+28,0
                DC.W COLOR00+30,0
                DC.W $ff01,$fffe        ; Buffer fuer Strahl 255
                DC.W $ff01,$fffe
COPEFFECT2:     DC.W COLOR00,0
                DC.W COLOR00+2,0
                DC.W COLOR00+4,0
                DC.W COLOR00+6,0
                DC.W COLOR00+8,0
                DC.W COLOR00+10,0
                DC.W COLOR00+12,0
                DC.W COLOR00+14,0
                DC.W COLOR00+16,0
                DC.W COLOR00+18,0
                DC.W COLOR00+20,0
                DC.W COLOR00+22,0
                DC.W COLOR00+24,0
                DC.W COLOR00+26,0
                DC.W COLOR00+28,0
                DC.W COLOR00+30,0
                DC.W $ffff,$fffe
COPPERENDE:
COPPERSIZE:     EQU COPPERENDE-COPPERSTART
COPPERSPROFF:   EQU COPPERSPRITES-COPPERSTART
COPPERSCROFF:   EQU COPPERSCREEN-COPPERSTART
COPEFF1OFF:     EQU COPEFFECT1-COPPERSTART
COPEFF2OFF:     EQU COPEFFECT2-COPPERSTART

********************************************************************************
*                                 LibraryNamen                                 *
********************************************************************************
                EVEN
GFXNAME:        DC.B "graphics.library",0
                EVEN
DOSNAME:        DC.B "dos.library",0
                EVEN
SAVENAME:       DC.B "TENNIS.MOT",0
********************************************************************************
*                                LibraryPointer                                *
********************************************************************************
                EVEN
DOSBASE:        DC.L 0                  ; DosBase
GFXBASE:        DC.L 0                  ; GraphicsBase
********************************************************************************
*                               Daten fuer DOS                                 *
********************************************************************************
MEMPTR:         DC.L 0                  ; Pointer auf allocierten Speicher
MEMSIZE:        DC.L 0                  ; Groesse des Speichers
ACTHANDLE:      DC.L 0                  ; Handle des zu ladenden Files
ACTLENGTH:      DC.L 0                  ; Laenge des zu ladenden Files
LOCKPTR:        DC.L 0                  ; Pointer to a Lock
;----------------------------------------------
                CNOP 0,4
FILEINFODATA:   DS.B 260                ; Block fuer FileInfoDaten
;----------------------------------------------
********************************************************************************
*                       SpeicherPointer und Tabellen                           *
********************************************************************************
                RSRESET                 ; Struct of MemTable
MT_INPUTS:      RS.W 1                  ; Wieviele Eintraege ?
MT_TABLE:       RS.L 50                 ; Eintrags-Tabelle
MT_SIZEOF:      RS.W 0                  ; Groesse der Struktur
;----------------------------------------------
                RSRESET                 ; Struct of ScreenPort
COLOR:          RS.W 1                  ; ZeichenFarbe
X_1:            RS.W 1                  ; X_1
Y_1:            RS.W 1                  ; Y_1
X_2:            RS.W 1                  ; X_2
Y_2:            RS.W 1                  ; Y_2
MULU160:        RS.W 400                ; Maximale Hoehe = 400
COPPTR:         RS.L 1                  ; Pointer to CopperList
CHARPTR:        RS.L 1                  ; Pointer to Character-Daten
CHAREFF:        RS.W 1                  ; Nummer des Character-Effects
SCRWIDTH:       RS.W 1                  ; Breite des Displays
SCRHEIGHT:      RS.W 1                  ; Hoehe des Displays
SCRPLANES:      RS.W 1                  ; Anzahl der Bitplanes
SCRPLANESC:     RS.W 1                  ; Anzahl der Bitplanes-1
ONELINE:        RS.W 1                  ; Breite des Displays in Worten
ONELINEB:       RS.W 1                  ; Breite des Displays in Bytes
ONEPLANE:       RS.L 1                  ; Bytes fuer eine Plane
ALLPLANES:      RS.L 1                  ; Bytes fuer alle Planes
BITMODUL:       RS.W 1                  ; Register fuer BPLCON0
DHX:            RS.W 1                  ; Horizontaler Offset fuer Sprite
DVY:            RS.W 1                  ; Vertikaler Offset fuer Sprite
DISSTART:       RS.W 1                  ; Wert fuer DisplayStart
DISSTOP:        RS.W 1                  ; Wert fuer DisplayStop
DISFSTART:      RS.W 1                  ; Wert fuer DataFetchStart
DISFSTOP:       RS.W 1                  ; Wert fuer DataFetchStop
PLANES:         RS.L MAXPLANES          ; Pointer auf Planes MaxPlanes = 6
BMODULO:        RS.W 1                  ; Modulo-Wert
BSCROLL:        RS.W 1                  ; BitScrollValue
SPOSX:          RS.W 1                  ; Scrolling X
SPOSY:          RS.W 1                  ; Scrolling Y
BCKBSIZE:       RS.W 1                  ; BlitSize des aktuellen BackBuffers
MODULO:         RS.W 1                  ; Modulo des akt. Backgrounds
BCKOFFS:        RS.L 1                  ; PlaneOffset des aktuellen Backgrounds
SP_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Double-Buffer-Package
DP_PLANES:      RS.L MAXPLANES          ; PlanePointer
DP_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                EVEN
SCRPORT:        DS.B SP_SIZEOF
;----------------------------------------------
                EVEN
DPPORT:         DS.B DP_SIZEOF          ; PlanePtr fuer DoubleBuffering
;----------------------------------------------
                EVEN
                DC.B "LOTH"             ; Memory-Kennung
MYMEMTABLE:     DS.B MT_SIZEOF          ; DC.L Laenge DC.L ADR
;----------------------------------------------
                EVEN
ACTPLANE:       DC.L 0                  ; Adresse der Plane ( Horline 3D )
;----------------------------------------------
CODETABLE:      DS.W 4                  ; Buffer fuer LageCodes beim Clippen
LINKSX:         DC.W 0                  ; Saves fuer LineClipping
LINKSY:         DC.W 0
RECHTSX:        DC.W 0
RECHTSY:        DC.W 0
********************************************************************************
*                                3D-Daten                                      *
********************************************************************************
                EVEN
ROTMATR:        DS.W 6                  ; Rotations-Matrix
ROTTABLE:       DS.W 9                  ; Zwischenbuffer fuer Rot. Matrix
;----------------------------------------------
W1REG:          DC.W W1                 ; Winkel 1
W2REG:          DC.W W2                 ; Winkel 2
W3REG:          DC.W W3                 ; Winkel 3
DISREG:         DC.W RHO                ; ZentralPunktPer. 1
DIS1REG:        DC.W DIST               ; ZentralPunktPer. 2
********************************************************************************
*                               3D-Koordinaten                                 *
********************************************************************************
                EVEN
COURT:
                DC.W -4*F,-6*F,0*F,-4*F,6*F,0*F ; Linke Aussenlinie
                DC.W -4*F,6*F,0*F,4*F,6*F,0*F ; Obere Aussenlinie
                DC.W 4*F,6*F,0*F,4*F,-6*F,0*F ; Rechte Aussenlinie
                DC.W 4*F,-6*F,0*F,-4*F,-6*F,0*F ; Untere Aussenlinie

                DC.W -3*F,-6*F,0*F,-3*F,6*F,0*F ; Linke Doppellinie
                DC.W 3*F,-6*F,0*F,3*F,6*F,0*F ; Rechte Doppellinie

                DC.W -3*F,-3*F,0*F,3*F,-3*F,0*F ; Untere T-Linie
                DC.W -3*F,3*F,0*F,3*F,3*F,0*F ; Obere T-Linie

                DC.W 0*F,-3*F,0*F,0*F,3*F,0*F ; Mitte-Linie

NET3D:          DC.W -4*F,0*F,0*F,4*F,0*F,0*F ; Netz-BaseLine
                DC.W 4*F,0*F,0*F,4*F,0*F,NH ; Rechter Pfosten
                DC.W 4*F,0*F,NH,-4*F,0,NH ; Netzkante
                DC.W -4*F,0*F,NH,-4*F,0*F,0*F ; Linker Pfosten

COURTENDE:
COURTSIZE:      EQU (COURTENDE-COURT)/6
NETOFFSET:      EQU NET3D-COURT
                EVEN
OUTCOURT:       DS.B COURTSIZE*6

********************************************************************************
*                                 Objekt-Liste                                 *
********************************************************************************
                EVEN
OBJNUM:         DC.W 0                  ; Nummer des letzten Eintrags !
OBJLIST:        DS.L 30                 ; Buffer fuer zu zeichnende Objekte
********************************************************************************
*                              Sinus-Tabelle                                   *
********************************************************************************
;----------------------------------------------
                EVEN
SINTAB:         DC.W 0,572,1144,1715,2286,2856,3425,3993
                DC.W 4560,5126,5690,6252,6813,7371,7927,8481
                DC.W 9032,9580,10126,10668,11207,11743,12275,12803
                DC.W 13328,13848,14364,14876,15383,15886,16383,16876
                DC.W 17364,17846,18323,18794,19260,19720,20173,20621
                DC.W 21062,21497,21925,22347,22762,23170,23571,23964
                DC.W 24351,24730,25101,25465,25821,26169,26509,26841
                DC.W 27165,27481,27788,28087,28377,28659,28932,29196
                DC.W 29451,29697,29934,30162,30381,30591,30791,30982
                DC.W 31163,31335,31498,31650,31794,31927,32051,32165
                DC.W 32269,32364,32448,32523,32587,32642,32687,32722
                DC.W 32747,32762,32767,32762,32747,32722,32687,32642
                DC.W 32588,32523,32448,32364,32269,32165,32051,31927
                DC.W 31794,31650,31498,31335,31163,30982,30791,30591
                DC.W 30381,30162,29934,29697,29451,29196,28932,28659
                DC.W 28377,28087,27788,27481,27165,26841,26509,26169
                DC.W 25821,25465,25101,24730,24351,23964,23571,23170
                DC.W 22762,22347,21925,21497,21062,20621,20173,19720
                DC.W 19260,18794,18323,17846,17364,16876,16384,15886
                DC.W 15383,14876,14364,13848,13328,12803,12275,11743
                DC.W 11207,10668,10126,9580,9032,8481,7927,7371
                DC.W 6813,6252,5690,5126,4560,3993,3425,2856
                DC.W 2286,1715,1144,572,0,-572,-1143,-1715
                DC.W -2286,-2856,-3425,-3993,-4560,-5126,-5690,-6252
                DC.W -6813,-7371,-7927,-8481,-9032,-9580,-10126,-10668
                DC.W -11207,-11743,-12275,-12803,-13327,-13848,-14364,-14876
                DC.W -15383,-15886,-16383,-16876,-17364,-17846,-18323,-18794
                DC.W -19260,-19720,-20173,-20621,-21062,-21497,-21925,-22347
                DC.W -22762,-23170,-23571,-23964,-24351,-24730,-25101,-25465
                DC.W -25821,-26169,-26509,-26841,-27165,-27481,-27788,-28087
                DC.W -28377,-28659,-28932,-29196,-29451,-29697,-29934,-30162
                DC.W -30381,-30591,-30791,-30982,-31163,-31335,-31498,-31650
                DC.W -31794,-31927,-32051,-32165,-32269,-32364,-32448,-32523
                DC.W -32587,-32642,-32687,-32722,-32747,-32762,-32767,-32762
                DC.W -32747,-32722,-32687,-32642,-32588,-32523,-32448,-32364
                DC.W -32269,-32165,-32051,-31927,-31794,-31651,-31498,-31335
                DC.W -31163,-30982,-30791,-30591,-30381,-30162,-29934,-29697
                DC.W -29451,-29196,-28932,-28659,-28377,-28087,-27788,-27481
                DC.W -27165,-26841,-26509,-26169,-25821,-25465,-25101,-24730
                DC.W -24351,-23964,-23571,-23170,-22762,-22347,-21925,-21497
                DC.W -21062,-20621,-20173,-19720,-19260,-18794,-18323,-17846
                DC.W -17364,-16876,-16384,-15886,-15383,-14876,-14364,-13848
                DC.W -13328,-12803,-12275,-11743,-11207,-10668,-10126,-9580
                DC.W -9032,-8481,-7927,-7371,-6813,-6252,-5690,-5126
                DC.W -4560,-3993,-3425,-2856,-2286,-1715,-1144,-572
                DC.W 0
;----------------------------------------------
TANTAB:         DC.W 255,265,274
                DC.W 284,294,305
                DC.W 316,327,339
                DC.W 352,365,379
                DC.W 394,409,426
                DC.W 443,461,481
                DC.W 502,524,548
                DC.W 574,603,633
                DC.W 666,703,743
                DC.W 787,837,892
                DC.W 955,1026,1108
                DC.W 1204,1317,1451
                DC.W 1616,1821,2084
                DC.W 2435,2926,3660
                DC.W 4884,7330,14666
                DC.W 32768,-14666,-7330
                DC.W -4884,-3660,-2926
                DC.W -2435,-2084,-1821
                DC.W -1616,-1451,-1317
                DC.W -1204,-1108,-1026
                DC.W -955,-892,-837
                DC.W -787,-743,-703
                DC.W -666,-633,-603
                DC.W -574,-548,-524
                DC.W -502,-481,-461
                DC.W -443,-426,-409
                DC.W -394,-379,-365
                DC.W -352,-339,-327
                DC.W -316,-305,-294
                DC.W -284,-274,-265
;----------------------------------------------
POTENZTABLE:    DC.L 100000000
                DC.L 10000000
                DC.L 1000000
                DC.L 100000
                DC.L 10000
                DC.L 1000
                DC.L 100
                DC.L 10
                DC.L 0
;----------------------------------------------
SCORETAB:       DC.W "00","15","30","40" ; Spielstand-Tabelle
;----------------------------------------------
SERVEPOS:       DC.W 0                  ; Position in der Tabelle
;* Tabelle fuer Ballbewegung beim Aufschlag
SERVETAB:
                DC.W 30,31,32,34,36,38,40
                DC.W 42,44,48,52,56,60,64,70
                DC.W 76,82,88
                DC.W 94,100,106,112
                DC.W 112,116,120,124,128
                DC.W 132,134,136,138,139,140,141,142,142,141,140
                DC.W 139,138,136,134,132,130,128,126,124,120,116,112
                DC.W 108,104,100,96,90,84,78,72,66,60,54,48,42,36,30
SERVETABENDE:
SERVELEN:       EQU SERVETABENDE-SERVETAB-2
;----------------------------------------------
TIPPPOS:        DC.W 0                  ; Position in der Tabelle
TIPPDEL:        DC.W 0                  ; DelayCounter
TIPPDEC:        DC.W 2                  ; Dec-Inc
TIPPTAB:        DC.W 31,26,10,0

SERVETABY:      DC.W 100,90,80,70,60,40,20,0,-20,-40,-60,-80,-100,-120,-140
                DC.W -160,-180,-200,-220,-240,-260,-270,-278,-286,-294
                DC.W -300,-300,-300,-300,-300,-300,-296,-290,-284,-278,-272
                DC.W -264,-256,-248,-240,-230,-220,-210,-200,-186,-172,-158
                DC.W -140,-120,-100,-80,-60,-40,-20,0,20,40,60,80,100,120
                DC.W 140,160,180
SERVETABY1:     DC.W -100,-80,-60,-20,20,60,100,140
                DC.W 180,220,260,280,300,300,300,280
                DC.W 240,200,160,120,80,40,0,-20
                DC.W -60,-100,-140,-180
SERVETABX:      DC.W -28                ; X-Koordinate der Markierung
SERVETABW:      DC.W 0                  ; Winkel des Aufschlags
WXDEL1:         DC.W 0                  ; Delay fuer WinkelVeraenderung
WXDEL2:         DC.W 0                  ; Delay fuer WinkelVeraenderung
;----------------------------------------------
NULLSPRITE:     DC.L 0                  ; Zeiger auf NullSpriteDaten
********************************************************************************
*                             GameLogikDaten                                   *
********************************************************************************
;----------------------------------------------
                RSRESET                 ; Port fuer BallBewegung
BS_X:           RS.W 1                  ; 3D-Koordinate X
BS_Y:           RS.W 1                  ; 3D-Koordinate Y
BS_Z:           RS.W 1                  ; 3D-Koordinate Z
BS_XX:          RS.W 1                  ; 2D-Koordinate X
BS_YY:          RS.W 1                  ; 2D-Koordinate Y
BS_ZZ:          RS.W 1                  ; 2D-Koordinate Z
BS_XXX:         RS.W 1                  ; 2D-Koordinate X ( Sprung )
BS_YYY:         RS.W 1                  ; 2D-Koordinate Y ( Sprung )
BS_ZZZ:         RS.W 1                  ; 2D-Koordinate Z ( Sprung )
BS_OY:          RS.W 1                  ; Letzte Y-Koordinate ( Netz ? )
BS_OZ:          RS.W 1                  ; Letzte Z-Koordinate ( Netz ? )
BS_WIN:         RS.W 1                  ; Winkel der Geraden
BS_M:           RS.W 1                  ; Daraus resultierende Steigung
BS_FF:          RS.W 1                  ; Aktuelle Parabel-Zerrung fuer Bewegung
BS_FF1:         RS.W 1                  ; Aktuelle Parabel-Zerrung fuer Sprung
BS_NEI:         RS.W 1                  ; Wert fuer Parabel-Spitze ( Bew. )
BS_MXY:         RS.W 1                  ; Wert fuer Parabel-Spitze ( Sprung )
BS_ST:          RS.W 1                  ; Schnittpunkt der Geraden
BS_ZM1:         RS.W 1                  ; Maximale Hoehe des Balles ( Bew. )
BS_ZM2:         RS.W 1                  ; Maximale Hoehe des Balles ( Sprung )
BS_YM1:         RS.W 1                  ; Maximale Y-Koord. des Balls (Bew.)
BS_YM2:         RS.W 1                  ; Maximale Y-Koord. des Balls (Sprung)
BS_DX:          RS.W 1                  ; Letzter X-Wert vor Schlag
BS_DE:          RS.W 1                  ; Decrementor fuer Y-3D
BS_SP:          RS.W 1                  ; Geschwindigkeit des Balls
BS_OK:          RS.W 1                  ; Anzahl der erfolgreichen B„lle
BS_BX1:         RS.W 1                  ; OUT X1
BS_BY1:         RS.W 1                  ; OUT Y1
BS_BX2:         RS.W 1                  ; OUT X2
BS_BY2:         RS.W 1                  ; OUT Y2
BS_OUT:         RS.B 1                  ; Ball-im-Aus Flag
BS_NET:         RS.B 1                  ; Ball-im-Netz Flag
BS_NOT:         RS.B 1                  ; Ball-nicht-geschlagen Flag
BS_SERVE:       RS.B 1                  ; Service-in-Progress Flag !
BS_TYPE:        RS.B 1                  ; Typ des aktuellen Schlags
                RSEVEN
BS_NEW:         RS.B 1                  ; Neue-Parameter-Flag
BS_WHO:         RS.B 1                  ; Wer-ist-Schlaeger-Flag
BS_MASCH:       RS.B 1                  ; Maschine-Flag
                RSEVEN
BS_HIT:         RS.B 1                  ; Ball wurde geschlagen !
BS_FORE:        RS.B 1                  ; BackHand or ForeHand
BS_HIT1:        RS.B 1                  ; Ball wurde geschlagen ( Spieler 2 )
BS_FORE1:       RS.B 1                  ; BackHand or ForeHand ( Spieler 2 )
                RSEVEN
BS_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Play-Port-Struktur
PP_WHOWHERE:    RS.B 1                  ; Wer schlaegt auf ?
PP_FILL:        RS.B 1                  ; Fuell-Byte
PP_MEGA:        RS.L 1                  ; AnimPort
PP_JPORT:       RS.L 1                  ; JoyStickPort fuer Aufschlag
PP_DELS:        RS.W 4                  ; Variable Delays bei Serve
PP_PORT:        RS.L 1                  ; SpielerPort fuer Aufschlag
PP_SKILL:       RS.W 1                  ; Wie gut ist anderer Spieler ?
PP_SIZEOF:      RS.W 0                  ; Groesse des Ports !
;----------------------------------------------
                RSRESET                 ; Port fuer Ballmaschine
BM_TABLE:       RS.L 1                  ; Zeiger auf Ballmaschinen-Modus
BM_COUNTER:     RS.W 1                  ; Counter innerhalb Tabelle
BM_POSX:        RS.W 1                  ; Position der Maschine X
BM_POSY:        RS.W 1                  ; Position der Maschine Y
BM_SHOOT:       RS.W 1                  ; Anzahl der abgeschossenen Baelle
BM_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Port fuer ScoreLogik
SL_GAME:        RS.W 1                  ; Spielstand  ( Game )
SL_SET:         RS.W 1                  ; Gewonnene Saetze ( Set )
SL_MATCH:       RS.W 5                  ; Spielstand ( Match )
SL_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Port fuer Joystick
JP_LEFT:        RS.B 1                  ; Flag fuer JoyStick links
JP_RIGHT:       RS.B 1                  ; Flag fuer JoyStick rechts
JP_UP:          RS.B 1                  ; Flag fuer JoyStick oben
JP_DOWN:        RS.B 1                  ; Flag fuer JoyStick unten
JP_BUTTON:      RS.B 1                  ; Flag fuer Button pressed/released
JP_MLBUTTON:    RS.B 1                  ; Flag fuer linken MausKnopf
JP_MRBUTTON:    RS.B 1                  ; Flag fuer rechten MouseButton
JP_FILL:        RS.B 1                  ; FuellByte
JP_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Port der Sprites
ST_USE:         RS.W 1                  ; Flags fr freie und belegt SPR's
ST_TAB:         RS.L 8                  ; 8 Langwoerter fuer Datenzeiger
ST_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Port fuer 1. SpielerSprite
P1_X:           RS.W 1                  ; X-Koordinate des 1. Spielers
P1_Y:           RS.W 1                  ; Y-Koordinate des 1. Spielers
P1_Z:           RS.W 1                  ; Z-Koordinate des 1. Spielers
P1_DX:          RS.W 1                  ; 3D-Koordinate des 1. Spielers
P1_DY:          RS.W 1                  ; 3D-Koordinate des 1. Spielers
P1_DZ:          RS.W 1                  ; 3D-Koordinate des 1. Spielers
P1_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                EVEN
BALLPORT:       DS.B BS_SIZEOF          ; BallPort ( Daten )
                DS.B 20
;----------------------------------------------
                EVEN
MASCHINEPORT:   DS.B BM_SIZEOF          ; Maschine-Port
;----------------------------------------------
                EVEN
SPRTABLE:       DS.B ST_SIZEOF          ; SpritePointer-Table
;----------------------------------------------
                EVEN
PL1PORT:        DS.B P1_SIZEOF          ; Spieler1-Port
                EVEN
PL2PORT:        DS.B P1_SIZEOF          ; Spieler2-Port
;----------------------------------------------
                EVEN
JOYPORT:        DS.B JP_SIZEOF          ; Joystick-Flags ( Port 0 )
                EVEN
JOYOLDPORT:     DS.B JP_SIZEOF          ; Joystick-Flags ( Port 0 )
                EVEN
;--------------------------------------
JOY1PORT:       DS.B JP_MLBUTTON        ; Joystick-Flags ( Port 1 )
                EVEN
JOY1OLDPORT:    DS.B JP_MLBUTTON        ; Joystick-Flags ( Port 1 )
                EVEN
;----------------------------------------------
PLAYPORT:       DS.B PP_SIZEOF          ; Play-Port
;----------------------------------------------
                EVEN
SCPPORT:        DS.B SL_SIZEOF          ; Score-Port ( Eigener Spieler )
SCEPORT:        DS.B SL_SIZEOF          ; Score-Port ( Gegner )
ACTSET:         DC.W 0                  ; Aktueller Satz
TIEBREAK:       DC.W 0                  ; TieBreak-Flag
ACTPLAY1:       DC.B "PRIME-89",0       ; DS.B 14
ACTPLAY2:       DC.B "INTERN",0         ; DS.B 14
SCTPLAY1:       DC.B "35763",0          ; DS.B 6
SCTPLAY2:       DC.B "67643",0          ; DS.B 6
ADVTXT:         DC.B "ADV. ",0          ; Text fuer ADVANTAGE
DEUCETXT:       DC.B "DEUCE",0          ; Text fuer Einstand
                EVEN
GSCRTXT:        DS.B 20                 ; Buffer fuer GameScore-ASCII
                EVEN
********************************************************************************
*                          Tabellen fuer Ballbewegung                          *
********************************************************************************
;----------------------------------------------
                DC.W 70,72,74,76,78,80,82,84,86,88
MIDDLEX:        DC.W 90
                DC.W 92,94,96,98,100,102,104,106,108,110
;----------------------------------------------
YF:             EQU 2
ME:             EQU 260
                DC.W ME+0*YF,ME+1*YF,ME+2*YF,ME+3*YF,ME+4*YF
                DC.W ME+5*YF,ME+6*YF,ME+7*YF,ME+8*YF,ME+9*YF
                DC.W ME+10*YF,ME+11*YF,ME+12*YF,ME+13*YF,ME+14*YF
                DC.W ME+15*YF,ME+16*YF,ME+17*YF,ME+18*YF,ME+19*YF
MIDDLEY:        DC.W ME+20*YF
                DC.W ME+21*YF,ME+22*YF,ME+23*YF,ME+24*YF,ME+25*YF
                DC.W ME+26*YF,ME+27*YF,ME+28*YF,ME+29*YF,ME+30*YF
                DC.W ME+31*YF,ME+32*YF,ME+33*YF,ME+34*YF,ME+35*YF
                DC.W ME+36*YF,ME+37*YF,ME+38*YF,ME+39*YF,ME+40*YF
;----------------------------------------------
;YF1:            EQU 6
;ME1:            EQU 320
;                DC.W ME1+0*YF1,ME1+1*YF1,ME1+2*YF1,ME1+3*YF1,ME1+4*YF1
;                DC.W ME1+5*YF1,ME1+6*YF1,ME1+7*YF1,ME1+8*YF1,ME1+9*YF1
;                DC.W ME1+10*YF1,ME1+11*YF1,ME1+12*YF1,ME1+13*YF1,ME1+14*YF1
;                DC.W ME1+15*YF1,ME1+16*YF1,ME1+17*YF1,ME1+18*YF1,ME1+19*YF1
MIDDLEY1:
;                DC.W ME1+20*YF1
;                DC.W ME1+21*YF1,ME1+22*YF1,ME1+23*YF1,ME1+24*YF1,ME1+25*YF1
;                DC.W ME1+26*YF1,ME1+27*YF1,ME1+28*YF1,ME1+29*YF1,ME1+30*YF1
;                DC.W ME1+31*YF1,ME1+32*YF1,ME1+33*YF1,ME1+34*YF1,ME1+35*YF1
;                DC.W ME1+36*YF1,ME1+37*YF1,ME1+38*YF1,ME1+39*YF1,ME1+40*YF1
;----------------------------------------------
                DC.W 32,40,44,46,46,48,48,50,52,56,60,64,66,68,70
MIDDLEZ:        DC.W 70
                DC.W 70,70,70,72,72,72,72,76,76,76,80,80,80,84,84
;----------------------------------------------
                DC.W 28,28,28,28,28,30,30,30,30,30,30,30,30,30,30
MIDDLEZ1:       DC.W 30
                DC.W 30,30,30,30,30,30,30,30,30,32,32,32,32,34,34
;----------------------------------------------
SPEEDTABLE:     DC.B 12,12,11,11,11,11,10,10,10,10,10,10,10,10,10,10
                DC.B 12,12,11,11,11,11,10,10,10,10,10,10,10,10,10,10
                DC.B 12,12,11,11,11,11,10,10,10,10,10,10,10,10,10,10
                DC.B 12,12,11,11,11,11,10,10,10,10,10,10,10,10,10,10
                DC.B 12,12,11,11,11,11,10,10,10,10,10,10,10,10,10,10

                DC.B 10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9
                DC.B 10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9
                DC.B 10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9
                DC.B 10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9
                DC.B 10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9

                DC.B 9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8
                DC.B 9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8
                DC.B 9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8
                DC.B 9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8
                DC.B 9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8

                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
;----------------------------------------------
SERVESPEED:     DC.B 18,18,18,16,16,16,16,16 ; Serve-Speeds
                DC.B 16,16,16,14,14,14,14,14 ; Serve-Speeds
                DC.B 14,12,12,12,12,12,12,10 ; Serve-Speeds
                DC.B 10,10,10,10,10,8,8,8 ; Serve-Speeds
;----------------------------------------------
NETPOS:         DC.W 0                  ; Position in Tabelle
NETTAB:         DC.B 30,29,28,27,25,23  ; Z-Koordinaten ( Ball im Netz)
                DC.B 20,17,14,10,6,4,0  ;
                DC.B 2,4,8,10,10,8      ;
                DC.B 6,4,2,0,2,4,5,6,5,4 ;
                DC.B 2,0                ;
;--------------------------------------
MOVETAB:        DC.L BALLMOVE1,NEWFLY,BALLMOVE2,NEWSPR
                DC.L BALLMOVE3,NEWTIPP,BALLMOVE4,NEWTHROW
                DC.L BALLMOVE1,NEWCURVE,BALLMOVE5,NEWNET
JOYTAB:         DC.L REALWAIT,MAKESTEP,MAKESTEP,MAKESTEP
                DC.L MAKENRUN,MAKENWRUN,MAKENORUN,MAKENORUN
                DC.L MAKESRUN,MAKESWRUN,MAKESORUN,MAKESORUN
                DC.L MAKESORUN,MAKESORUN,MAKESORUN,MAKESORUN
JOY1TAB:        DC.L REALWAIT1,MAKESTEP1,MAKESTEP1,MAKESTEP1
                DC.L MAKENRUN1,MAKENWRUN1,MAKENORUN1,MAKENORUN1
                DC.L MAKESRUN1,MAKESWRUN1,MAKESORUN1,MAKESORUN1
                DC.L MAKESORUN1,MAKESORUN1,MAKESORUN1,MAKESORUN1
********************************************************************************
*                          Tabellen fuer Ballmaschine                          *
********************************************************************************
                RSRESET
BT_STYPE:       RS.L 1                  ; Zeiger auf Schlagtabelle
BT_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Aufbau der Tabelle
SA_ZM1:         RS.W 1                  ; Hoehe des Balles
SA_ZM2:         RS.W 1                  ; Hoehe des Aufsprungs
SA_YM1:         RS.W 1                  ; Weite des Balles
SA_YM2:         RS.W 1                  ; Weite des Sprungs
SA_WIN:         RS.W 1                  ; Winkel des Balles
SA_SP:          RS.W 1                  ; Geschwindigkeit des Balls
SA_SIZEOF:      RS.W 0                  ; Groesse einer Definition
;----------------------------------------------
EMARK:          EQU $ffffffff
BMPRG1:         DC.L STY1,STY2,STY3,STY4,STY6,STY7,STY5,STY8,EMARK
BMPRG2:         DC.L STY1,STY5,STY2,STY3,STY6,STY4,STY7,STY8,EMARK
BMPRG3:         DC.L STY5,STY6,STY7,STY8,STY7,STY6,STY5,STY8,EMARK
BMPRG4:         DC.L STY1,STY2,STY3,STY4,STY1,STY2,STY3,STY4,EMARK
BMPRG5:         DC.L STY2,STY5,STY1,STY4,STY6,STY3,STY7,STY8,EMARK
BMPRG6:         DC.L STY3,STY1,STY4,STY2,STY3,STY1,STY4,STY2,EMARK
;----------------------------------------------
STY1:           DC.W 65,30,276,400,80,9 ; rechts, lang, spin
STY2:           DC.W 50,25,276,400,80,8 ; rechts, lang, slice
STY3:           DC.W 65,30,276,400,100,9 ; links, lang, spin
STY4:           DC.W 50,25,276,400,100,8 ; links, lang, slice
STY5:           DC.W 45,20,180,360,75,6 ; rechts, kurz, normal
STY6:           DC.W 45,20,180,360,105,6 ; links, kurz, normal
STY7:           DC.W 45,20,180,360,90,6 ; mitte, kurz, normal
STY8:           DC.W 100,34,288,460,90,9 ; Lop, lang, normal
;----------------------------------------------
PROGRAMTABLE:   DC.L BMPRG1,BMPRG2,BMPRG3 ; Tabelle der Programme
                DC.L BMPRG4,BMPRG5,BMPRG6
********************************************************************************
*                            Zeichensatz ( Game )                              *
********************************************************************************
                RSRESET
;* Struktur der eigenen ZeichenDatei
CH_NAME:        RS.B 8                  ; 8 Bytes Name
CH_PLPICK:      RS.B 1                  ; PlanePick
CH_PLOFF:       RS.B 1                  ; PlaneOnOff
CH_LOWEST:      RS.B 1                  ; Kleinster ASCII-Wert
CH_HIGHEST:     RS.B 1                  ; Groesster ASCII-Wert
CH_HEIGHT:      RS.W 1                  ; Hoehe eines Characters
CH_DATAS:       RS.L 1                  ; Offset auf Image-Daten
CH_MASKS:       RS.L 1                  ; Offset auf Masken-Daten
CH_ILOCK:       RS.W 1                  ; Offset auf Image-Lock
CH_MLOCK:       RS.W 1                  ; Offset auf Mask-Lock
CH_SPACE:       RS.W 1                  ; Offset auf Breiten-Tabelle
CH_SIZEOF:      RS.W 0                  ; Groesse des Headers
;----------------------------------------------
                EVEN
CHARGAME:       DC.L 0                  ; Pointer to CHARGAME-DATAS
CHARGAMENAME:   DC.B "CHARGAME",0       ; Name des Zeichensatzes
;----------------------------------------------
                EVEN
CHARTAB:        DC.L 0                  ; Pointer to CHARTAB-DATAS
CHARTABNAME:    DC.B "CHARTAB",0        ; Name des Zeichensates
********************************************************************************
*                           Daten fuer Bilder                                  *
********************************************************************************
;----------------------------------------------
                EVEN
PLATTEPTR:      DC.L 0                  ; Pointer auf Daten der Platte
PLATTENAME:     DC.B "PLATTE.IFF",0     ; FileName der Platte
;----------------------------------------------
                EVEN
PLATZPTR:       DC.L 0                  ; Pointer auf Daten des Platzes
PLATZNAME:      DC.B "PLATZ.IFF",0      ; FileName des Platzes
;----------------------------------------------
                EVEN
AUSTRANAME:     DC.B "SIDNEY",0         ; Name Australien
;----------------------------------------------
                EVEN
FRANCENAME:     DC.B "PARIS",0          ; Name Frankreich
;----------------------------------------------
                EVEN
ENGLANDNAME:    DC.B "LONDON",0         ; Name London
;----------------------------------------------
                EVEN
USANAME:        DC.B "NEWYORK",0        ; Name Amerika
;----------------------------------------------
                EVEN
COURTSNAME:     DC.B "COURTS",0         ; Name des Titels
;----------------------------------------------
                EVEN
SONGNAME:       DC.B "TDS",0            ; Name des TitelSounds
********************************************************************************
*                            Namen der Turniere                                *
********************************************************************************
TAUSTRANAME:    DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 25,10              ; X,Y
                DC.B "NEXT TOURNAMENT",0 ; Header
                DC.B 20,84              ; X,Y
                DC.B "AUSTRALIAN",0     ; 1. Menuepunkt
                DC.B 204,106            ; X,Y
                DC.B "OPEN",0           ; 2. Menuepunkt
                DC.B 70,134             ; X,Y
                DC.B "IN",0             ; 3. Menuepunkt
                DC.B 60,156             ; X,Y
                DC.B "MELBOURNE",0      ; 4. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
;----------------------------------------------
TFRANCENAME:
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 25,10              ; X,Y
                DC.B "NEXT TOURNAMENT",0 ; Header
                DC.B 70,84              ; X,Y
                DC.B "FRENCH",0         ; 1. Menuepunkt
                DC.B 180,106            ; X,Y
                DC.B "OPEN",0           ; 2. Menuepunkt
                DC.B 40,134             ; X,Y
                DC.B "IN",0             ; 3. Menuepunkt
                DC.B 60,156             ; X,Y
                DC.B "PARIS",0          ; 4. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
;----------------------------------------------
TENGLANDNAME:
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 25,10              ; X,Y
                DC.B "NEXT TOURNAMENT",0 ; Header
                DC.B 6,84               ; X,Y
                DC.B "ALL ENGLAND",0    ; 1. Menuepunkt
                DC.B 50,106             ; X,Y
                DC.B "CHAMPIONSHIP",0   ; 2. Menuepunkt
                DC.B 100,134            ; X,Y
                DC.B "IN",0             ; 3. Menuepunkt
                DC.B 140,156            ; X,Y
                DC.B "WIMBLEDON",0      ; 4. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
;----------------------------------------------
TUSANAME:
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 25,10              ; X,Y
                DC.B "NEXT TOURNAMENT",0 ; Header
                DC.B 90,78              ; X,Y
                DC.B "U.S. OPEN",0      ; 1. Menuepunkt
                DC.B 142,134            ; X,Y
                DC.B "IN",0             ; 2. Menuepunkt
                DC.B 25,156             ; X,Y
                DC.B "FLUSHING MEADOW",0 ; 3. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
                DC.L 0                  ; Routine ( Dummy )
********************************************************************************
*                               Daten fuer Menues                              *
********************************************************************************
* Aufbau eines Menues
* RS.L    CharSet         Zeiger auf Zeichensatzdaten
* RS.B    X,Y             X,Y Koodinate 2 Bytes
* RS.B    ASCII-Text mit 0-Endekennung
* RS.B    X,Y oder -1 wenn letztes Menu
* EVEN
* RS.L Zeiger auf Routine die ausgefuehrt werden
                EVEN
MAINMENUTXT:                                  ; Text des Hauptmenues
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 52,10              ; X,Y
                DC.B "GREAT COURTS",0   ; Header
                DC.B 70,70              ; X,Y
                DC.B "TOURNAMENT",0     ; 1. Menuepunkt
                DC.B 88,94              ; X,Y
                DC.B "PRACTICE",0       ; 2. Menuepunkt
                DC.B 97,118             ; X,Y
                DC.B "RANKING",0        ; 3. Menuepunkt
                DC.B 98,142             ; X,Y
                DC.B "STORAGE",0        ; 4. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L TOURNAMENT         ; Routine ( Tournament )
                DC.L PRACTICE           ; Routine ( Practice )
                DC.L RANKING            ; Routine ( Ranking )
                DC.L 0                  ; Routine ( Storage )
;----------------------------------------------
STORAGETXT:                                   ; Text des Storagemenues
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 98,10              ; X,Y
                DC.B "STORAGE",0        ; Header
                DC.B 79,78              ; X,Y
                DC.B "LOAD GAME",0      ; 1. Menuepunkt
                DC.B 79,100             ; X,Y
                DC.B "SAVE GAME",0      ; 2. Menuepunkt
                DC.B 79,122             ; X,Y
                DC.B "MAIN MENU",0      ; 3. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L MAINMENU           ; Routine ( Load Game )
                DC.L MAINMENU           ; Routine ( Save Game )
                DC.L MAINMENU           ; Routine ( Main Menu )
;----------------------------------------------
PRACTICETXT:                                  ; Text des Practicemenues
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 88,10              ; X,Y
                DC.B "PRACTICE",0       ; Header
                DC.B 115,70             ; X,Y
                DC.B "HUMAN",0          ; 1. Menuepunkt
                DC.B 97,94              ; X,Y
                DC.B "MACHINE",0        ; 2. Menuepunkt
                DC.B 97,118             ; X,Y
                DC.B "SERVICE",0        ; 3. Menuepunkt
                DC.B 79,142             ; X,Y
                DC.B "MAIN MENU",0      ; 4. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L HUMAN              ; Routine ( Human )
                DC.L MACHINE            ; Routine ( Machine )
                DC.L SERVICE            ; Routine ( Service )
                DC.L MAINMENU           ; Routine ( Main Menu )
;----------------------------------------------
MACHINETXT:                                   ; Text des Practicemenues
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 97,8               ; X,Y
                DC.B "MACHINE",0        ; Header
                DC.B 79,32              ; X,Y
                DC.B "PROGRAM 1",0      ; 1. Menuepunkt
                DC.B 79,56              ; X,Y
                DC.B "PROGRAM 2",0      ; 2. Menuepunkt
                DC.B 79,80              ; X,Y
                DC.B "PROGRAM 3",0      ; 3. Menuepunkt
                DC.B 79,104             ; X,Y
                DC.B "PROGRAM 4",0      ; 4. Menuepunkt
                DC.B 79,128             ; X,Y
                DC.B "PROGRAM 5",0      ; 5. Menuepunkt
                DC.B 79,152             ; X,Y
                DC.B "PROGRAM 6",0      ; 6. Menuepunkt
                DC.B 79,176             ; X,Y
                DC.B "MAIN MENU",0      ; 8. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L PROGRAM            ; Routine ( Program )
                DC.L PROGRAM            ; Routine ( Program )
                DC.L PROGRAM            ; Routine ( Program )
                DC.L PROGRAM            ; Routine ( Program )
                DC.L PROGRAM            ; Routine ( Program )
                DC.L PROGRAM            ; Routine ( Program )
                DC.L MAINMENU           ; Routine ( MainMenu )
;----------------------------------------------
TOURNTXT:                                     ; Text des Tournamentmenues
                DC.L 0                  ; Zeiger auf Zeichensatz
                DC.B 70,10              ; X,Y
                DC.B "TOURNAMENT",0     ; Header
                DC.B 115,68             ; X,Y
                DC.B "TABLE",0          ; 1. Menuepunkt
                DC.B 124,90             ; X,Y
                DC.B "PLAY",0           ; 2. Menuepunkt
                DC.B 106,112            ; X,Y
                DC.B "GIVEUP",0         ; 3. Menuepunkt
                DC.B 79,134             ; X,Y
                DC.B "MAIN MENU",0      ; 5. Menuepunkt
                DC.B $ff,$ff            ; EndeKennung
                EVEN
                DC.L 0                  ; Routine ( Dummy )
                DC.L MAKETOURNTABLE     ; Routine ( Tabelle )
                DC.L PLAY               ; Routine ( Spielen )
                DC.L MAINMENU           ; Routine ( Aufgabe )
                DC.L MAINMENU           ; Routine ( Main Menu )
;----------------------------------------------
* Buffer fuer Zwischenspeicherung der Menuepunktkoordinaten
                RSRESET
MB_MENU:        RS.W 1                  ; Nummer des aktuellen Menuepunktes
MB_OLDMENU:     RS.W 1                  ; Nummer des alten Menuepunktes
MB_COUNT:       RS.W 1                  ; Anzahl der Menuepunkte
MB_ROUTS:       RS.L 1                  ; Zeiger auf Routinen
MB_COORDS:      RS.W 24                 ; Buffer fuer X,Y
MB_SIZEOF:      RS.W 0                  ; Groesse des Ports
                EVEN
MENUPORT:       DS.B MB_SIZEOF
********************************************************************************
*                   Daten zur Ausgabe eines Polygons                           *
********************************************************************************
                EVEN
MYXARRAY:       DS.W 4                  ; Koordinaten X Polygon
MYYARRAY:       DS.W 4                  ; Koordinaten Y Polygon
XP0ARRAY:       DS.W 400                ; Buffer X0 fuer PolygonRoutine
XP1ARRAY:       DS.W 400                ; Buffer X1 fuer PolygonRoutine
********************************************************************************
*                           Daten fuer EndeSequence                            *
********************************************************************************
;----------------------------------------------
ENDNAME:        DC.B "ENDE",0           ; Name des Bildes
;----------------------------------------------
                EVEN
BENDNAME:       DC.B "BALLENDE.DAT",0   ; Name der Animation
;----------------------------------------------
                EVEN
ESNDNAME:       DC.B "TDE",0            ; Name des Songs
;----------------------------------------------
                EVEN
BENDSIZE:       DC.L 0                  ; Groesse der Anim-Daten
ESNDPTR:        DC.L 0                  ; Pointer auf Song
ESNDSIZE:       DC.L 0                  ; Groesse des Songs
;----------------------------------------
BENDPORT:       DC.L BENDOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 6                  ; DelayCnt
                DC.W 9                  ; Steps
                DC.W 0                  ; Loop-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
BENDOFFS:       DC.W BAEND1,BAEND2,BAEND3,BAEND4,BAEND5
                DC.W BAEND6,BAEND7,BAEND8,BAEND9,BAEND10
;----------------------------------------
BENDPOS:        DC.W 208,23             ; Koordinaten der Ball-Pyramide
                DC.W 192,52,224,52      ; Koordinaten der Ball-Pyramide
                DC.W 176,81,208,81,240,81 ; Koordinaten der Ball-Pyramide
                DC.W 160,110,192,110,224,110,256,110 ; Koordinaten der Pyramide
********************************************************************************
*                         Animations-Tabellen                                  *
********************************************************************************
;----------------------------------------
                RSRESET                 ; AnimationsStruktur
AN_OFFS:        RS.L 1                  ; Zeiger auf Offsets
AN_BASE:        RS.L 1                  ; Zeiger auf Basis der Daten
AN_DEL:         RS.W 1                  ; Delay der Animation
AN_STEPS:       RS.W 1                  ; Wieviele Stufen
AN_MODE:        RS.W 1                  ; Modus der Animation ( Bump or Loop )
AN_DELCNT:      RS.W 1                  ; DelayCounter
AN_CNT:         RS.W 1                  ; Aktuelle Stufe
AN_DEC:         RS.W 1                  ; DEC or INC Counter
AN_LOOP:        RS.W 1                  ; WendePunkt ( Loop-Point )
AN_SIZEOF:      RS.W 0                  ; Size of Port
;----------------------------------------
;* Replay-Zeichen 3D-Replay
REPLAYPORT:     DC.L REPLAYOFFS         ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 0                  ; DelayCnt
                DC.W 4                  ; Steps-1
                DC.W 1                  ; Bump-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; LoopPoint
;----------------------------------------
REPLAYNAME:     DC.B "REPLAY.DAT",0     ; Name der Daten
                EVEN
REPLAYOFFS:     DC.W REP1,REP2,REP3,REP4,REP5 ; Offset-Tabelle
;----------------------------------------
;* Ball 3D-Replay
BALLRPORT:      DC.W BALLR1,BALLR2,BALLR3 ; Offset-Tabelle fuer Ball-OBJ
;----------------------------------------
;* Animierter Ball ( ScoreAusgabe )
ALLBALLNAME:    DC.B "ALLBALL.DAT",0    ; BallAnimDaten
                EVEN
;----------------------------------------
BALLSCRPORT:    DC.L BALLSCROFFS        ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 2                  ; DelayCnt
                DC.W 17                 ; Steps
                DC.W 0                  ; Loop-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
BALLSCROFFS:    DC.W BSCR1,BSCR2,BSCR3,BSCR4,BSCR5,BSCR6
                DC.W BSCR7,BSCR8,BSCR9,BSCR10,BSCR11,BSCR12
                DC.W BSCR13,BSCR14,BSCR15,BSCR16,BSCR17,BSCR18
;----------------------------------------
;* Animierter Spieler ( Service )
SERVICENAME:    DC.B "SERVICE.DAT",0    ; Name der Service-Daten
                EVEN
ALLANIMS:       DC.B "ALLPLAY.DAT",0    ; Name der Animations-Daten
                EVEN
BALLGPTR:       DC.L 0                  ; Zeiger auf Basis der Daten
ACTBALLG:       DC.W 0                  ; AnimCounter
ACTBALLD:       DC.W 0                  ; Delay
;----------------------------------------
BALLGPORT:      DC.W BAG11,BAG12,BAG13,BAG14,BAG15,BAG16,BAG17
BALL1GPORT:     DC.W BAG21,BAG22,BAG23,BAG24,BAG25,BAG26,BAG27
                DC.W BAG31,BAG32,BAG33,BAG34,BAG35,BAG36,BAG37
;----------------------------------------
SHADGPORT:      DC.W BSH1,BSH2,BSH3     ; Anim.Table fuer Schatten
;----------------------------------------
SERVEAPORT:     DC.L SERVEAOFFS         ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 13                 ; Steps
                DC.W 0                  ; Loop-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
TIPPAPORT:      DC.L TIPPAOFFS          ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 5                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 1                  ; Bump-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
SERVEBPORT:     DC.L SERVEBOFFS         ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 9                  ; Steps
                DC.W 0                  ; Loop-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
TIPPBPORT:      DC.L TIPPBOFFS          ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 5                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 1                  ; Bump-Mode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
WAITAPORT:      DC.L WA1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 10                 ; DelayCnt
                DC.W 5                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 2                  ; Loop-Point
;----------------------------------------
WAITBPORT:      DC.L WB1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 8                  ; DelayCnt
                DC.W 5                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 2                  ; Loop-Point
;----------------------------------------
SAWPORT:        DC.L SAW1OFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 6                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
SBWPORT:        DC.L SBW1OFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 6                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LNAPORT:        DC.L LNAOFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 5                  ; DelayCnt
                DC.W 12                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LNWAPORT:       DC.L LNWAOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 18                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LNOAPORT:       DC.L LNOAOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 18                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LSAPORT:        DC.L LNSOFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 5                  ; DelayCnt
                DC.W 12                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LSWAPORT:       DC.L LSWAOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 18                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LSOAPORT:       DC.L LSOAOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 18                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LNBPORT:        DC.L LNBOFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 12                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LNWBPORT:       DC.L LNWBOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 19                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LNOBPORT:       DC.L LNOBOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 19                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LSBPORT:        DC.L LSBOFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 12                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LSWBPORT:       DC.L LSWBOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 19                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
LSOBPORT:       DC.L LSOBOFFS           ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 19                 ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
VORAPORT:       DC.L VA1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 3                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
RUEAPORT:       DC.L RA1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 3                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
VORASPORT:      DC.L VA1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 0                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
RUEASPORT:      DC.L RA1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 0                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;======================================
VORBPORT:       DC.L VB1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 3                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
RUEBPORT:       DC.L RB1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 3                  ; DelayCnt
                DC.W 3                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
VORBSPORT:      DC.L VB1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 0                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
RUEBSPORT:      DC.L RB1OFFS            ; Zeiger auf Offsets
                DC.L 0                  ; Zeiger auf DatenBasis
                DC.W 4                  ; DelayCnt
                DC.W 0                  ; Steps
                DC.W 0                  ; LoopMode
                DC.W 0                  ; DelayCounter
                DC.W 0                  ; Counter
                DC.W 1                  ; INC Cnt
                DC.W 0                  ; Loop-Point
;----------------------------------------
TIPPAOFFS:      DC.W DUPA1,DUPA2,DUPA3,DUPA4 ; Offsets ( Tippen 1. Spieler )
;----------------------------------------
SERVEAOFFS:     DC.W AA1,AA2,AA3,AA4    ; Offsets ( Service 1. Spieler )
                DC.W AA5,AA6,AA7,AA8
                DC.W AA9,AA10,AA11,AA12
                DC.W AA13,AA14
;----------------------------------------
TIPPBOFFS:      DC.W DUPB1,DUPB2,DUPB3,DUPB4 ; Offsets ( Tippen 2. Spieler )
TIPPB1OFFS:     DC.L DUPB1,DUPB2,DUPB3,DUPB4 ; Offsets ( Tippen 2. Spieler )
;----------------------------------------
SERVEBOFFS:     DC.W AB1,AB2,AB3,AB4    ; Offsets ( Service 2. Spieler )
                DC.W AB5,AB6,AB7,AB8
                DC.W AB9,AB10
;----------------------------------------
WA1OFFS:        DC.L WA11,WA12,WA13,WA14,WA15,WA16 ; Offset Wait-Position
WA2OFFS:        DC.L WA21,WA22,WA23,WA24,WA25,WA26 ; Offset Wait-Position
WA3OFFS:        DC.L WA31,WA32,WA33,WA34,WA35,WA36 ; Offset Wait-Position
WA4OFFS:        DC.L WA41,WA42,WA43,WA44,WA45,WA46 ; Offset Wait-Position
WAOFFS:         DC.L WA4OFFS,WA3OFFS,WA2OFFS,WA1OFFS ; Zeiger auf OffsetTabellen
;----------------------------------------
SAW1OFFS:       DC.L SA11,SA12,SA13,SA14 ; Offset Step A
SAW2OFFS:       DC.L SA21,SA22,SA23,SA24 ; Offset Step A
SAW3OFFS:       DC.L SA31,SA32,SA33,SA34 ; Offset Step A
SAW4OFFS:       DC.L SA41,SA42,SA43,SA44 ; Offset Step A
SAWOFFS:        DC.L SAW4OFFS,SAW3OFFS,SAW2OFFS,SAW1OFFS ; Zeiger auf Offsets
;----------------------------------------
VA1OFFS:        DC.L VA11,VA12,VA13,VA14 ; Offset Vorhand
VA2OFFS:        DC.L VA21,VA22,VA23,VA24 ; Offset Vorhand
VA3OFFS:        DC.L VA31,VA32,VA33,VA34 ; Offset Vorhand
VA4OFFS:        DC.L VA41,VA42,VA43,VA44 ; Offset Vorhand
VAOFFS:         DC.L VA4OFFS,VA3OFFS,VA2OFFS,VA1OFFS ; Zeiger auf Offsets
;----------------------------------------
RA1OFFS:        DC.L RA11,RA12,RA13,RA14 ; Offset Rueckhand
RA2OFFS:        DC.L RA21,RA22,RA23,RA24 ; Offset Rueckhand
RA3OFFS:        DC.L RA31,RA32,RA33,RA34 ; Offset Rueckhand
RA4OFFS:        DC.L RA41,RA42,RA43,RA44 ; Offset Rueckhand
RAOFFS:         DC.L RA4OFFS,RA3OFFS,RA2OFFS,RA1OFFS ; Zeiger auf Offsets
;======================================
WB1OFFS:        DC.L WB11,WB12,WB13,WB14,WB15,WB16 ; Offset Wait-Position
WB2OFFS:        DC.L WB21,WB22,WB23,WB24,WB25,WB26 ; Offset Wait-Position
WB3OFFS:        DC.L WB31,WB32,WB33,WB34,WB35,WB36 ; Offset Wait-Position
WBOFFS:         DC.L WB3OFFS,WB2OFFS,WB1OFFS ; Zeiger auf OffsetTabellen
;----------------------------------------
SBW1OFFS:       DC.L SB11,SB12,SB13,SB14 ; Offset Step B
SBW2OFFS:       DC.L SB21,SB22,SB23,SB24 ; Offset Step B
SBW3OFFS:       DC.L SB31,SB32,SB33,SB34 ; Offset Step B
SBWOFFS:        DC.L SBW3OFFS,SBW2OFFS,SBW1OFFS ; Zeiger auf Offsets
;----------------------------------------
VB1OFFS:        DC.L VB11,VB12,VB13,VB14 ; Offset Vorhand ( Spieler 2 )
VB2OFFS:        DC.L VB21,VB22,VB23,VB24 ; Offset Vorhand
VB3OFFS:        DC.L VB31,VB32,VB33,VB34 ; Offset Vorhand
VBOFFS:         DC.L VB1OFFS,VB2OFFS,VB3OFFS ; Zeiger auf Offsets
;----------------------------------------
RB1OFFS:        DC.L RB11,RB12,RB13,RB14 ; Offset Rueckhand ( Spieler 2 )
RB2OFFS:        DC.L RB21,RB22,RB23,RB24 ; Offset Rueckhand
RB3OFFS:        DC.L RB31,RB32,RB33,RB34 ; Offset Rueckhand
RBOFFS:         DC.L RB1OFFS,RB2OFFS,RB3OFFS ; Zeiger auf Offsets
;----------------------------------------
LNBOFFS:        DC.L LSB1,LSB2,LSB3,LSB4 ; Offsets Lauf-Nord-B
                DC.L LSB5,LSB6,LSB7,LSB8
                DC.L LSB9,LSB10,LSB11,LSB12,LSB13
;----------------------------------------
LNWBOFFS:       DC.L LSOB1,LSOB2,LSOB3,LSOB4 ; Offsets Lauf-Nord-Ost B
                DC.L LSOB5,LSOB6,LSOB7,LSOB8
                DC.L LSOB9,LSOB10,LSOB11,LSOB12,LSOB13
                DC.L LSOB14,LSOB15,LSOB16,LSOB17,LSOB18,LSOB19,LSOB20
;----------------------------------------
LNOBOFFS:       DC.L LSWB1,LSWB2,LSWB3,LSWB4 ; Offsets Lauf-Nord-West B
                DC.L LSWB5,LSWB6,LSWB7,LSWB8
                DC.L LSWB9,LSWB10,LSWB11,LSWB12,LSWB13
                DC.L LSWB14,LSWB15,LSWB16,LSWB17,LSWB18,LSWB19,LSWB20
;----------------------------------------
LSBOFFS:        DC.L LSB13,LSB12,LSB11,LSB10 ; Offsets Lauf-Sued-B
                DC.L LSB9,LSB8,LSB7,LSB6
                DC.L LSB5,LSB4,LSB3,LSB2,LSB1
;--------------------------------------
LSOBOFFS:       DC.L LSOB20,LSOB19,LSOB18,LSOB17,LSOB16 ; Offsets Lauf-Sued-West B
                DC.L LSOB15,LSOB14,LSOB13,LSOB12
                DC.L LSOB11,LSOB10,LSOB9,LSOB8,LSOB7
                DC.L LSOB6,LSOB5,LSOB4,LSOB3,LSOB2,LSOB1
;--------------------------------------
LSWBOFFS:       DC.L LSWB20,LSWB19,LSWB18,LSWB17,LSWB16 ; Offsets Lauf-Sued-Ost B
                DC.L LSWB15,LSWB14,LSWB13,LSWB12
                DC.L LSWB11,LSWB10,LSWB9,LSWB8,LSWB7
                DC.L LSWB6,LSWB5,LSWB4,LSWB3,LSWB2,LSWB1
;======================================
LNAOFFS:        DC.L LNA1,LNA2,LNA3,LNA4 ; Offsets Lauf-Nord-A
                DC.L LNA5,LNA6,LNA7,LNA8
                DC.L LNA9,LNA10,LNA11,LNA12,LNA13
;----------------------------------------
LNWAOFFS:       DC.L LNWA1,LNWA2,LNWA3,LNWA4 ; Offsets Lauf-Nord-West A
                DC.L LNWA5,LNWA6,LNWA7,LNWA8
                DC.L LNWA9,LNWA10,LNWA11,LNWA12,LNWA13
                DC.L LNWA14,LNWA15,LNWA16,LNWA17,LNWA18,LNWA19
;----------------------------------------
LNOAOFFS:       DC.L LNOA1,LNOA2,LNOA3,LNOA4 ; Offsets Lauf-Nord-Ost A
                DC.L LNOA5,LNOA6,LNOA7,LNOA8
                DC.L LNOA9,LNOA10,LNOA11,LNOA12,LNOA13
                DC.L LNOA14,LNOA15,LNOA16,LNOA17,LNOA18,LNOA19
;----------------------------------------
LNSOFFS:        DC.L LNA13,LNA12,LNA11,LNA10 ; Offsets Lauf-Sued-A
                DC.L LNA9,LNA8,LNA7,LNA6
                DC.L LNA5,LNA4,LNA3,LNA2,LNA1
;----------------------------------------
LSWAOFFS:       DC.L LSWA1,LSWA2,LSWA3,LSWA4 ; Offsets Lauf-Sued-West A
                DC.L LSWA5,LSWA6,LSWA7,LSWA8
                DC.L LSWA9,LSWA10,LSWA11,LSWA12
                DC.L LSWA13,LSWA14,LSWA15,LSWA16
                DC.L LSWA17,LSWA18,LSWA19
;--------------------------------------
LSOAOFFS:       DC.L LSOA1,LSOA2,LSOA3,LSOA4 ; Offsets Lauf-Sued-Ost A
                DC.L LSOA5,LSOA6,LSOA7,LSOA8
                DC.L LSOA9,LSOA10,LSOA11,LSOA12
                DC.L LSOA13,LSOA14,LSOA15,LSOA16
                DC.L LSOA17,LSOA18,LSOA19
;--------------------------------------
ACTANIM:        DC.L 0                  ; Aktuelle/letzte Anim ( Spieler 1 )
ACTANIM1:       DC.L 0                  ; Aktuelle/letzte Anim ( Spieler 2 )
;======================================
                DC.W MREF3              ; Offset fr MainRefAnim
MREFTAB:        DC.W MREF1
                DC.W MREF2
                DC.W NREF3              ; Offsets fuer NetRefAnim
NREFTAB:        DC.W NREF1
                DC.W NREF2
;--------------------------------------
********************************************************************************
*                 Tabelle aller Animationsports fuer beide Spieler             *
********************************************************************************
* Aufbau der Tabelle
* TIPPPORT,SERVEPORT,VORPORT,RUECKPORT,WAITPORT,STEPPORT,LNPORT,LSPORT,LNOPORT
* LNWPORT,LSWPORT,LSOPORT
                RSRESET
MP_TIPP:        RS.L 1                  ; AnimPort bei Tippen
MP_SERVE:       RS.L 1                  ; AnimPort bei Service
MP_VOR:         RS.L 1                  ; AnimPort bei Vorhand
MP_RUECK:       RS.L 1                  ; AnimPort bei Rueck
MP_WAIT:        RS.L 1                  ; AnimPort bei Warten
MP_STEP:        RS.L 1                  ; AnimPort bei SideStep
MP_LN:          RS.L 1                  ; AnimPort bei Lauf-Nord
MP_LS:          RS.L 1                  ; AnimPort bei Lauf-Sued
MP_LNO:         RS.L 1                  ; AnimPort bei Lauf-Nord-Ost
MP_LNW:         RS.L 1                  ; AnimPort bei Lauf-Nord-West
MP_LSW:         RS.L 1                  ; AnimPort bei Lauf-Sued-West
MP_LSO:         RS.L 1                  ; AnimPort bei Lauf-Sued-Ost
;--------------------------------------
MEGAA:          DC.L TIPPAPORT,SERVEAPORT
MEGAB:          DC.L TIPPBPORT,SERVEBPORT
********************************************************************************
*                            Daten fuer Aufschlag                              *
********************************************************************************
SERVEDATS:      DC.W 60,293,74,288      ; Parameter fuer Service ( 1 rechts )
                DC.W -3*F,-3*F,0,0      ; Bounds ( Aus-Grenzen dafuer )
                DC.L MEGAA              ; BaseTabPort fuer  v. Spieler
                DC.L JOYPORT            ; JoyStickPort
                DC.W 11,4,2             ; Delays fuer ServeAnim
                DC.W 11                 ; Aufschlag-Anim
;--------------------------------------
                DC.W -50,293,-36,288    ; Parameter fuer Service ( 1 links )
                DC.W 0,-3*F,3*F,0       ; Bounds ( Aus-Grenzen dafuer )
                DC.L MEGAA              ; BaseTabPort fuer  v. Spieler
                DC.L JOYPORT            ; JoyStickPort
                DC.W 11,4,2             ; Delays fuer ServeAnim
                DC.W 11                 ; Aufschlag-Anim
;--------------------------------------
                DC.W -20,-272,-28,-292  ; Parameter fuer Service ( 2 links )
                DC.W 0,0,3*F,3*F        ; Bounds ( Aus-Grenzen dafuer )
                DC.L MEGAB              ; BaseTabPort fuer  h. Spieler
                DC.L JOY1PORT           ; JoyStickPort
                DC.W 10,5,3             ; Delays fuer ServeAnim
                DC.W 8                  ; Aufschlag-Anim
;--------------------------------------
                DC.W 72,-272,65,-292    ; Parameter fuer Service ( 2 rechts )
                DC.W -3*F,0,0,3*F       ; Bounds ( Aus-Grenzen dafuer )
                DC.L MEGAB              ; BaseTabPort fuer  h. Spieler
                DC.L JOY1PORT           ; JoyStickPort
                DC.W 10,5,3             ; Delays fuer ServeAnim
                DC.W 8                  ; Aufschlag-Anim
;======================================
SERVEX:         DC.W 76                 ; X-Koordinate des Spielers
SERVEY:         DC.W 100                ; Y-Koordinate des Spielers
BSERVEX:        DC.W -28                ; X-Koordinate des Balles beim Werfen
BSERVEY:        DC.W 288                ; Y-Koordinate des Balles beim Werfen
MOVERX:         DC.W 3                  ; Bewegungs-INC X ( Spieler 1 )
MOVERY:         DC.W 5                  ; Bewegungs-INC Y ( Spieler 1 )
MOVER1X:        DC.W 3                  ; Bewegungs-INC X ( Spieler 2 )
MOVER1Y:        DC.W 5                  ; Bewegungs-INC Y ( Spieler 2 )
********************************************************************************
*                       Bewegung des Platzes 3D-Replay                         *
********************************************************************************
;* Bewegung 3D-Replay
MOTIONDEC:      DC.W 1                  ; INC or DEC ( -1 or +1 for Bump )
ACTMOTION:      DC.W 0                  ; Nummer des aktuellen Frames
MOTIONPORT:     DS.B 224*RD_SIZEOF      ; Daten der Frames
;----------------------------------------
                EVEN
BACKSTACKPT:    DC.L 0                  ; BackGround-Buffer
BACKSTACK:      DC.L 0                  ; BackGround-Buffer
COPSLOT:        DC.L 0                  ; VBLSlotADR
SAVINT:         DC.W 0                  ; Save fuer IntenaR
********************************************************************************
*                   Tabellen und Daten fuer ScoreEinblendung                   *
********************************************************************************
;----------------------------------------------
SCTB:           EQU 146-144
SCTBE:          EQU 192-144
SCOREBOX:       DC.W 37,167-144,317,170-144 ; Daten fuer Boxen
                DC.W 181,SCTB,184,SCTBE
                DC.W 209,SCTB,212,SCTBE
                DC.W 237,SCTB,240,SCTBE
                DC.W 265,SCTB,268,SCTBE
                DC.W 293,SCTB,296,SCTBE
;----------------------------------------------
SCTY1:          EQU 147-144             ; Y-Koordinate ( Obere Reihe )
SCTY2:          EQU 175-144             ; Y-Koordinate ( Untere Reihe )
SCORETXT:       DC.W 37,148-144,37,174-144 ; Daten fuer Text
SCORETXT1:      DC.W 191,SCTY1
                DC.W 219,SCTY1
                DC.W 247,SCTY1
                DC.W 275,SCTY1
                DC.W 303,SCTY1
SCORETXT2:      DC.W 191,SCTY2
                DC.W 219,SCTY2
                DC.W 247,SCTY2
                DC.W 275,SCTY2
                DC.W 303,SCTY2
;----------------------------------------------
BCKBACK1:       DC.L 0                  ; Pointer auf 1. BCKBuffer
BCKBACK2:       DC.L 0                  ; Pointer auf 2. BCKBuffer
;----------------------------------------------
********************************************************************************
*                     Tabellen und Daten fuer Sound+FX                         *
********************************************************************************
                EVEN
FXNAME:         DC.B "FX.DAT",0         ; Name der FX
                EVEN
FXBASE:         DC.L 0                  ; Basis der Samples
FXOFFS:         DC.L BALL1,BALL2,BALL3,OUT,NET,TIME,PIEP,BEIFALL
FXLEN:          DC.W 1522,2035,2294,2425,1282,2681,1423,4580
FXNUM:          DC.W -1                 ; Nummer des aktuellen FX
CHANNELS:       DC.L 0                  ; Channels belegt oder frei
********************************************************************************
*                             Sonstiges                                        *
********************************************************************************
MERKER:         DS.B 1                  ; Merker fuer Sortierung
                EVEN
LINEPL1:        DS.W 80                 ; Save Plane fuer 1. Linie ( Menu )
LINEPL2:        DS.W 80                 ; Save Plane fuer 2. Linie ( Menu )
TEMPBUFFER:     DS.W 40                 ; Temporaerer Buffer ( 80 Bytes )
MASKBCK:        DS.L 10                 ; Maske ( Verdeckung Netz )
********************************************************************************
*                          Daten fuer TurnierTabelle                           *
********************************************************************************
                RSRESET                 ; BoxStruct TurnierTabelle
TT_PREV:        RS.L 1                  ; Zeiger auf vorhergehende Tabelle
TT_NEXT:        RS.L 1                  ; Zeiger auf naechste Tabelle
TT_X:           RS.W 1                  ; X-Koordinate der Reihe
TT_Y:           RS.W 1                  ; Y-Offset der Reihe
TT_DIS:         RS.W 1                  ; Distance zwischen den Boxen
TT_COUNT:       RS.W 1                  ; Anzahl der Boxen pro Page !
TT_SIZEOF:      RS.W 0                  ; Groesse
;----------------------------------------------
;* Daten fuer 1. Reihe ( 16 Eintrage per Page )
TABLE32:        DC.L 0                  ; Zeiger auf vorhergehende = 0
                DC.L TABLE16            ; Zeiger auf naechste = Table16
                DC.W 22                 ; X-Koordinate
                DC.W 8                  ; Y-Offset
                DC.W 12                 ; Y-Distance
                DC.W 32                 ; Anzahl der Boxen pro Page
;----------------------------------------------
;* Daten fuer 2. Reihe ( 8 Eintrage per Page )
TABLE16:        DC.L TABLE32            ; Zeiger auf vorhergehende = Table32
                DC.L TABLE8             ; Zeiger auf naechste = Table8
                DC.W 194                ; X-Koordinate
                DC.W 14                 ; Y-Offset
                DC.W 24                 ; Y-Distance
                DC.W 16                 ; Anzahl der Boxen pro Page
;----------------------------------------------
;* Daten fuer 3. Reihe ( 4 Eintrage per Page )
TABLE8:         DC.L TABLE16            ; Zeiger auf vorhergehende = Table16
                DC.L TABLE4             ; Zeiger auf naechste = Table4
                DC.W 356                ; X-Koordinate
                DC.W 26                 ; Y-Offset
                DC.W 48                 ; Y-Distance
                DC.W 8                  ; Anzahl der Boxen pro Page
;----------------------------------------------
;* Daten fuer 4. Reihe ( 2 Eintrage per Page )
TABLE4:         DC.L TABLE8             ; Zeiger auf vorhergehende = Table8
                DC.L TABLE2             ; Zeiger auf naechste = Table2
                DC.W 518                ; X-Koordinate
                DC.W 52                 ; Y-Offset
                DC.W 94                 ; Y-Distance
                DC.W 4                  ; Anzahl der Boxen pro Page
;----------------------------------------------
;* Daten fuer 5. Reihe ( 1 Eintrag per Page )
TABLE2:         DC.L TABLE4             ; Zeiger auf vorhergehende = Table4
                DC.L 0                  ; Zeiger auf naechste = 0
                DC.W 682                ; X-Koordinate
                DC.W 97                 ; Y-Offset
                DC.W 186                ; Y-Distance
                DC.W 2                  ; Anzahl der Boxen pro Page
PLANEBASE:      DC.L 0                  ; PlaneBase
********************************************************************************
*                             SpielerDaten                                     *
********************************************************************************
                RSRESET
PL_NAME:        RS.B 14                 ; 14 Bytes fuer Namen
PL_RANK:        RS.W 1                  ; 1 Word fuer Ranglisten-Punkte
PL_SIZEOF:      RS.W 0                  ; Groesse eines Eintrags

RANKENTRIE:     DC.W 0
STDCHARS:       IBYTES 'CHAR6.DAT'
TABLEMALE:      IBYTES 'TABELLEM.DAT'
********************************************************************************
*                             TurnierDaten                                     *
********************************************************************************
                RSRESET                 ; Port fuer Turnierdaten
TD_WHICH:       RS.W 1                  ; Nummer des aktuellen Turniers
TD_ROUND:       RS.W 1                  ; Wievielte Runde ?
TD_CIRCUIT:     RS.W 1                  ; Anzahl der grossen Schleife !
TD_SIZEOF:      RS.W 0                  ; Groesse des Ports
;----------------------------------------------
                RSRESET                 ; Struktur eines Ergebnisses
PR_SETS:        RS.B 1                  ; Wieviele Saetze wurden gespielt
PR_RESULT:      RS.B 10                 ; 10 Bytes = 5 Saetze * 2
PR_SIZEOF:      RS.W 0                  ; Groesse eines Ergebnisses
;----------------------------------------------
                EVEN
TOURNS:         DC.L AUSTRACOLS,TAUSTRANAME,AUSTRANAME
                DC.L FRANCECOLS,TFRANCENAME,FRANCENAME
                DC.L AUSTRACOLS,TENGLANDNAME,ENGLANDNAME
                DC.L USACOLS,TUSANAME,USANAME
;----------------------------------------------
TOURNPORT:      DS.B TD_SIZEOF          ; TurnierDaten
;----------------------------------------------
                EVEN
TOURNOPPP:      DC.L 32,TOURNOPP32      ; Pointer auf Offsets ( T. Teilnehmer )
                DC.L 16,TOURNOPP16      ; Pointer auf Offsets
                DC.L 8,TOURNOPP8        ; Pointer auf Offsets
                DC.L 4,TOURNOPP4        ; Pointer auf Offsets
                DC.L 2,TOURNOPP2        ; Pointer auf Offsets
                DC.L 1,TOURNOPP1        ; Pointer auf Ofset
;----------------------------------------------
RESULTSPTR:     DC.L RESULTS32          ; PTR auf Results
                DC.L RESULTS16
                DC.L RESULTS8
                DC.L RESULTS4
                DC.L RESULTS2
;----------------------------------------------
SETPOS1:        DC.B $0b,$0d,$0e        ; Bei 4 Saetzen
SETPOS2:        DC.B $1c,$19,$16,$15    ; Bei 5 Saetzen
                DC.B $1a
;----------------------------------------------
RANKOFFS:       DS.W MAXRANKS           ; Platz fuer Offsets
TOURNOPP32:     DS.W MAXRANKS/2         ; Offsets der Turnierteilnehmer ( 32 )
TOURNOPP16:     DS.W MAXRANKS/4         ; Offsets der Turnierteilnehmer ( 16 )
TOURNOPP8:      DS.W MAXRANKS/8         ; Offsets der Turnierteilnehmer ( 8 )
TOURNOPP4:      DS.W MAXRANKS/16        ; Offsets der Turnierteilnehmer ( 4 )
TOURNOPP2:      DS.W MAXRANKS/32        ; Offsets der Turnierteilnehmer ( 2 )
TOURNOPP1:      DS.W MAXRANKS/64        ; Offsets der Turnierteilnehmer ( 1 )
;----------------------------------------------
;* Buffer der Ergebnisse
RESULTS32:      DS.B PR_SIZEOF*16       ; Ergebnisse der 1. Runde ( 16 )
RESULTS16:      DS.B PR_SIZEOF*8        ; Ergebnisse der 2. Runde (  8 )
RESULTS8:       DS.B PR_SIZEOF*4        ; Ergebnisse der 3. Runde (  4 )
RESULTS4:       DS.B PR_SIZEOF*2        ; Ergebnisse der 4. Runde (  2 )
RESULTS2:       DS.B PR_SIZEOF*1        ; Ergebnisse der 5. Runde (  1 )
********************************************************************************
*                       Daten fuer Ball-Netz-Verdeckung                        *
********************************************************************************
NETMSK:         DC.L 0                  ; Zeiger auf Netzmaske
NETIMG:         DC.L 0                  ; Zeiger auf Netzimage
NETNAME:        DC.B "NET.DAT",0        ; Name der Daten
********************************************************************************
*                       Daten fuer JoyStick_Receive                            *
********************************************************************************
;                IF REPLAY<>0
                EVEN
RECNAME:        DC.B "JOY.DAT",0
                EVEN
RECJOY:         DS.W 1

RECBUF:         DS.W 3000
;                ENDC
;                END

BMHDCHUNK:      DS.L 1
CMAPCHUNK:      DS.L 1
BODYCHUNK:      DS.L 1
PICPLANES:      DS.L 6
PACKBUFFER:     DS.L 1

;======================================
; IFF from PackBuffer in Screen

READIFF:
        movea.l         PACKBUFFER(pc),a0     ; hier stehen die IFF-Daten.
        bsr             GETIFFPOINTER         ; Chunks bestimmen.
        bsr             GETIFFPALETTE         ; Palette setzen.
        bra.s           UNPACKIFF             ; entpacken.

;--------------------------------------
;-----------------------------------

GETIFFPOINTER:
        move.l          #"BMHD",d0            ; Suche BitMapHeader.
        bsr             SEARCHCHUNK
        tst.w           d7                    ; ? Suchbereich berschritten
        bmi             RETURN                ; ! ja
        move.l          a0,BMHDCHUNK

        move.l          #"CMAP",d0
        bsr             SEARCHCHUNK
        tst.w           d7
        bmi             RETURN
        move.l          a0,CMAPCHUNK

        move.l          #"BODY",d0
        bsr             SEARCHCHUNK
        tst.w           d7
        bmi             RETURN
        move.l          a0,BODYCHUNK
        movea.l         BMHDCHUNK(pc),a0
        moveq           #0,d7
        rts

;--------------------------------------
; a0.l: Zeiger auf Suchbereich
; d0.l: ASCII des Chunks

SEARCHCHUNK:
        move.w          #$7fff,d7             ; nur #Bytes absuchen.
SEARCHCHUNKLOOP:
        cmp.l           (a0),d0               ; Wortweise vergleichen
        addq.w          #2,a0                 ; ein Wort weiter.
        dbeq            d7,SEARCHCHUNKLOOP    ; abbrechen wenn d7=-1 oder Chunk gefunden.
        addq.w          #2,a0                 ; Zeiger auf Adresse nach ASCII.
        rts

;--------------------------------------
; IFF entpacken und nach PicPlanes schreiben.
; a0.l: Zeiger auf Destination

UNPACKIFF:
        lea             SCRPORT(pc),a6        ; ScreenPortBase -> a6
        movem.l         PLANES(a6),a0-a3      ; Zeiger auf Planes
        movem.l         a0-a3,PICPLANES

        movea.l         BODYCHUNK(pc),a0
        addq.w          #4,a0
        move.w          SCRHEIGHT(a6),d7
        subq.w          #1,d7

UNPACKLOOP:
        lea             PICPLANES(pc),a2
        move.w          SCRPLANESC(a6),d6

UNPACKPLANE:
        movea.l         (a2),a5
        bsr             UNPACKIFFROW          ; eine Zeile entpacken.
        move.l          a5,(a2)+
        dbra            d6,UNPACKPLANE
        dbra            d7,UNPACKLOOP
        rts

;--------------------------------------

UNPACKIFFROW:
        move.w          ONELINEB(a6),d4       ; Breite in Bytes.
UNPLOOP1:
        tst.w           d4                    ; ? Ende der Zeile
        beq             RETURN                ; ! T
        bmi             RETURN                ; ! T

        moveq           #0,d0
;        tst.b           COMPFLAG              ; ? Daten gepackt
        bra.s           UNPCOMP               ; ! T: Daten Entpacken

        move.w          d4,d0                 ; ! F: Daten 1:1 uebertragen
        subq.w          #1,d0
        bra.s           UNPLOOP2

UNPCOMP:
        move.b          (a0)+,d0              ; ? Header >= 128
        bmi.s           PACKED                ; ! ja: gepackte Bytefolge
UNPLOOP2:
        move.b          (a0)+,(a5)+           ; ! nein: d0 Bytes bertragen
        subq.w          #1,d4
        dbra            d0,UNPLOOP2
        bra.s           UNPLOOP1

PACKED:
        neg.b           d0                    ; Wiederholfaktor aus Header
        move.b          (a0)+,d1              ; d1.b wird d0 mal bertragen
UNPLOOP3:
        move.b          d1,(a5)+
        subq.w          #1,d4
        dbra            d0,UNPLOOP3

        bra.s           UNPLOOP1

;--------------------------------------

GETIFFPALETTE:

        movea.l         CMAPCHUNK(pc),a0
        move.l          (a0)+,d7
        divu            #3,d7
        subq.w          #1,d7
        lea             ACTCOLTABLE(pc),a1
COLOOP:
        moveq           #0,d1
        move.b          (a0)+,d0              ; R
        lsr.b           #4,d0
        or.b            d0,d1
        rol.w           #4,d1
        move.b          (a0)+,d0              ; G
        lsr.b           #4,d0
        or.b            d0,d1
        rol.w           #4,d1
        move.b          (a0)+,d0              ; B
        lsr.b           #4,d0
        or.b            d0,d1
        move.w          d1,(a1)+
        dbra            d7,COLOOP

        rts
