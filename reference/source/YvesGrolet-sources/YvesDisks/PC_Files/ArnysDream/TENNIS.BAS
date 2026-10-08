Deflist 0
Gosub Variables
Gosub Court
Hidem
While Inkey$<>"q"
  Gosub Main
Wend
Showm
Edit
'
Procedure Wait
  While Inkey$=""
  Wend
Return
'
Procedure Main
  Win%=Random(90)+45
  If Win%=90 Then
    Win%=89
  Endif
  Win%=65
  M%=Tan(Win%*Api)*256
  If Yst%<>0
    De%=12*Sgn(Yst%*-1)
  Else
    De%=12
  Endif
  St%=Yst%-((Dx%*M%)/256)
  Print At(1,3);Using "st% = #### dx% = #### de% = #### ",St%,Dx%,De%
  Print At(1,4);Using "ff% = ##### ff1% = ###### nei% = ######",Ff%,Ff1%,Nei%
  Repeat
    Yst%=Yst%+De%
    X%=((Yst%-St%)*256)/M%
    Z%=((Ff%*(Yst%^2))+(Nei%*Yst%))/32768+Zm1%
    Print At(1,1);Using "XYZ  ####   ####   ####",X%,Yst%,Z%
    Rem Gosub Wait
    Gosub Dreid(X%,Yst%,Z%)
    Gosub Movesprite
    Gosub Dreid(X%,Yst%,0)
    Gosub Movesprite
    Rem EXIT IF yst%<-ymax1% OR yst%>ymax1%
  Until Z%<=0 Or X%<-4*F% Or X%>4*F%
  '
  If Z%<=0 And X%>=-8*F% And X%<=8*F%
    Rem mxy%=-ff1%*yst%-(zm2%*(32768/yst%))
    Gosub Paras
    Print At(1,5);Using "mxy% = ######",Mxy%
    Repeat
      Exit If Yst%<-Ymax2% Or Yst%>Ymax2%
      Yst%=Yst%+De%
      X%=((Yst%-St%)*256)/M%
      Z%=Ff1*(Yst%^2)+Mxy*Yst%+Zmx%
      Print At(1,2);Using "XYZ  ####   ####   ####",X%,Yst%,Z%
      Rem GOSUB wait
      Gosub Dreid(X%,Yst%,Z%)
      Gosub Movesprite
      Gosub Dreid(X%,Yst%,0)
      Gosub Movesprite
    Until Z%<=0
    Nei%=-Ff%*Yst%-(Z%*(32768/Yst%))
  Endif
  Dx%=X%
Return
'
Procedure Paras
  Local A,B,C,Y1%,Y2%,Dy%,Ym,Sw
  Y1%=Yst%
  Y2%=Yst%+20*De%
  Dy%=Y1%+(Y2%-Y1%)/2
  Ym=((Y2%^2)-(Y1%^2))/(Y1%-Y2%)
  Sw=(Dy%^2)+Ym*Dy%-(Y1%^2)-Ym*Y1%
  A=40/Sw
  B=A*Ym
  C=-A*(Y1%^2+Ym*Y1%)
  Ff1=A
  Mxy=B
  Zmx%=C
  Print At(1,10);Int(A*32768),Int(B*32768),Int(C)
  Rem GOSUB wait
Return
'
Procedure Movesprite
  Sub Xs%,8
  Sub Ys%,8
  If Xs%>=1 And Xs%<=639 And Ys%>=1 And Ys%<=399
    Oldin%=In%
    If In%>5 Then
      In%=5
      Oldin%=5
    Endif
    In%=5-((Yst%+Ymax2%)/(2*Ymax2%/5))
    Vsync
    Sprite Ball$(Oldin%)
    Sprite Ball$(In%),Xs%,Ys%
  Endif
Return
'
Procedure Dreid(X1%,Y1%,Z1%)
  Local X%,Y%,Z%
  X%=X1%
  Y%=Y1%
  Z%=Z1%
  '
  Mmx%=Mx%+Xpo%
  Mmy%=My%-Vh%
  '
  A1=Ax1*X%
  A2=Ay1*X%
  A3=Az1*X%
  '
  Ax=A1+Ax2*Y%+Ax3*Z%
  Ay=A2+Ay2*Y%+Ay3*Z%
  Az=A3+Az2*Y%+Az3*Z%
  '
  If Dist-Az<>0
    Ax=Ax+(Rho-Az)/(Dist-Az)*(-Ax)
    Ay=Ay+(Rho-Az)/(Dist-Az)*(-Ay)
  Endif
  Xs%=Ax+Mmx%
  Ys%=Ay+Mmy%
  Zs%=Az
Return
'
' ----------------------------'
Procedure Sico
  A1=Sin(W1)
  A2=Sin(W2)
  A3=Sin(W3)
  B1=Cos(W1)
  B2=Cos(W2)
  B3=Cos(W3)
  Ax1=B2*B3
  Ax2=-B2*A3
  Ax3=A2
  Ay1=B1*A3+A1*A2*B3
  Ay2=B1*B3-A1*A2*A3
  Ay3=-A1*B2
  Az1=A1*A3-B1*A2*B3
  Az2=A1*B3+B1*A2*A3
  Az3=B1*B2
Return
'
Procedure Court
  For I%=0 To Cou%-1 Step 3
    Read Co%(I%),Co%(I%+1),Co%(I%+2)
    Mul Co%(I%),F%
    Mul Co%(I%+1),F%
    Mul Co%(I%+2),F%
    Gosub Dreid(Co%(I%),Co%(I%+1),Co%(I%+2))
    Cos%(I%)=Xs%
    Cos%(I%+1)=Ys%
    Cos%(I%+2)=Zs%
  Next I%
  For I%=0 To Cou%-1 Step 6
    Draw Cos%(I%),Cos%(I%+1) To Cos%(I%+3),Cos%(I%+4)
  Next I%
Return
'
Procedure Variables
  Nei%=-5977
  Mxy%=-3742
  F%=48
  Zmax%=72
  Zm1%=Zmax%
  Zm2%=Zmax%/2
  Ymax1%=F%*6
  Ymax2%=F%*6+F%
  Api=Pi/180
  Yst%=0
  Ff%=-((Zm1%/(Ymax1%^2))*32768)
  Ff1%=-((Zm2%/(Ymax2%^2))*32768)
  Mx%=320
  My%=200
  Xpo%=0
  Vh%=0
  Rho=50
  Dist=800
  W1=72*Api
  W2=0*Api
  W3=0*Api
  Gosub Sico
  Cou%=78
  Dim Co%(Cou%)
  Dim Cos%(Cou%)
  Dim Ball$(5)
  Gosub Getsprites
Return
'
Procedure Getsprites
  For O%=0 To 5
    Ball$(O%)=Mki$(0)+Mki$(0)+Mki$(0)+Mki$(0)+Mki$(1)
    For I%=0 To 15
      Read D%
      Ball$(O%)=Ball$(O%)+Mki$(D%)+Mki$(D%)
    Next I%
  Next O%
Return
'
Data 0,0,16380,16380,16380,16380,16380,16380
Data 16380,16380,16380,16380,16380,16380,0,0
'
Data 0,0,0,8184,8184,8184,8184,8184
Data 8184,8184,8184,8184,8184,0,0,0
'
Data 0,0,0,0,4080,4080,4080,4080
Data 4080,4080,4080,4080,0,0,0,0
'
Data 0,0,0,0,0,2016,2016,2016
Data 2016,2016,2016,0,0,0,0,0
'
Data 0,0,0,0,0,0,960,960
Data 960,960,0,0,0,0,0,0
'
Data 0,0,0,0,0,0,0,384
Data 384,0,0,0,0,0,0,0
'
Data -4 ,-6 ,0 ,-4 ,6 ,0
Data -4 ,6 ,0 ,4 ,6 ,0
Data 4 ,6 ,0 ,4 ,-6 ,0
Data 4 ,-6 ,0 ,-4 ,-6 ,0
Data -3 ,-6 ,0 ,-3 ,6 ,0
Data 3 ,-6 ,0 ,3 ,6 ,0
Data -3 ,-3 ,0 ,3 ,-3 ,0
Data -3 ,3 ,0 ,3 ,3 ,0
Data 0 ,-3 ,0 ,0 ,3 ,0
Data -4 ,0 ,0 ,4 ,0 ,0
Data 4 ,0 ,0 ,4 ,0 ,1
Data 4 ,0 ,1,-4 ,0,1
Data -4 ,0 ,1,-4 ,0 ,0
