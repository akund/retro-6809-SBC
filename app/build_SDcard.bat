mc demoSD.c -s -o demoSD.s

del demoSD_C.a09
type start.a09 >> demoSD_C.a09
type demoSD.s >> demoSD_C.a09
type clib.s >> demoSD_C.a09
type symbol.a09 >> demoSD_C.a09

cd ..
rem no optimization '-n' to keep the code re-localizable
as09 app/demoSD_C.a09 -nstl
cd app
