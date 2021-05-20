# retro-6809-SBC
6809 based single board computer

COPYRIGHT (C) 2018-2021 Adrian Kundert  
[adrian.kundert@gmail.com](mailto:adrian.kundert@gmail.com)  

<img width='80%' src='doc/retro 6809 SBC overview.png'/>

# Introduction:

The retro 6809 SBC is a homebrew 8-bit computer running BASIC as made in the 80's but with more modern peripherals like PS/2 keyboard and VGA output.

# Features Overview:
<img width='80%' src='doc/retro 6809 SBC board.png'/>



# Demo

## BASIC commands

[<img width='50%' src='doc/basic.png'/>](https://www.youtube.com/watch?v=NazOm493rk8)

## Monitor usage with the Terminal

<img width='50%' src='doc/terminal.png'/>

A BASIC file can be send to the retro 6809 SBC with the command "L"
a message "send now the BAS file" is prompt before you can send the BASIC file.

1 REM pong demo
2 REM Author: Adrian Kundert, Jan 5,2021
5 REM X range[1-28], Y range [0-19],
10 CLS
12 SLOW=3
15 COUNT=0
20 X=14
25 Y=RND(10)+1
30 DX=1
35 DY=1
40 IT=0
60 PUP=8
70 PDN=12
80 PAD=58
90 REM
100 REM DRAW THE PADDLE AND BOARD
110 FOR A=32*PUP TO 32*PDN STEP 32
120 PRINT @A,CHR$(PAD);
140 NEXT A
150 PRINT @0,COUNT;
160 REM
200 REM ITERATION LOOP
210 REM FOR N=0 TO 200
300 REM BALL MOVEMENT
310 IF IT<SLOW THEN GOTO 450
320 PRINT @32*Y+X,CHR$(32);
330 X=X+DX
340 Y=Y+DY:
350 IT=0:
360 PRINT @32*Y+X,CHR$(2);
370 REM
400 REM BOUNCING
410 IF X<=0 AND (Y<PUP OR Y>PDN) THEN SOUND 50,5: GOTO 900
420 IF X<=1 AND (Y>=PUP AND Y<=PDN) THEN DX=-DX: SOUND 200,1: COUNT=COUNT+1: PRINT @0,COUNT;
430 IF X>=28 THEN DX=-DX: SOUND 200,1
440 IF Y<=1 OR Y>=19 THEN DY=-DY: SOUND 200,1
450 IT=IT+1
460 REM
500 REM PADDLE MOVEMENT
510 I$ = INKEY$
520 REM UP MOVEMENT
530 IF PUP<=1 THEN 550
540 IF I$ = CHR$(&H5E) THEN PRINT @32*PDN,CHR$(32);: PDN=PDN-1:PUP=PUP-1: PRINT @32*PUP,CHR$(PAD);
550 REM DOWN MOVEMENT
560 IF PDN>=19 THEN 580
570 IF I$ = CHR$(&H12) THEN PRINT @32*PUP,CHR$(32);: PDN=PDN+1:PUP=PUP+1: PRINT @32*PDN,CHR$(PAD);
580 GOTO 200
700 REM NEXT N
900 PRINT @32*19,"GAME OVER!";
1000 END
