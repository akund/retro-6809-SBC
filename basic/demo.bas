1 REM -----keyboard reading test--------
10 CLS
20 PRINT "press a key"
30 I$ = INKEY$
40 IF I$ = "" THEN GOTO 30
50 PRINT I$
60 IF I$ = CHR$(94) THEN PRINT "got UP"
70 IF I$ = CHR$(18) THEN PRINT "got DOWN"
80 REM
100 REM ------------- MAZE ---------------
110 PRINT CHR$(47+45*(RND(2)-1));
120 GOTO 100
130 REM
1000 END

