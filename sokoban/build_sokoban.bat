mc main.c -s -o main.s

del sokobanC.a09
type start.a09 >> sokobanC.a09
type main.s >> sokobanC.a09
type clib.s >> sokobanC.a09
type symbol.a09 >> sokobanC.a09

cd ..
as09 sokoban/sokobanC.a09 -nstl
cd sokoban
