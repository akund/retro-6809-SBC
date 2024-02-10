mc sokoban.c -s -o sokoban.s

del sokobanC.a09
type start.a09 >> sokobanC.a09
type sokoban.s >> sokobanC.a09
type clib.s >> sokobanC.a09
type symbol.a09 >> sokobanC.a09

cd ..
rem no optimization '-n' to keep the code re-localizable
as09 app/sokobanC.a09 -nstl
cd app