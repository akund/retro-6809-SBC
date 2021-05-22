
*
* micro-c driver under flex
*
*	12-dec-81	m.ohta,h.tezuka
*

_00001	pshs	d,x,y		;multiply	
		lda	,s
		ldb	3,s
		mul
		stb	4,s		
		ldd	1,s
		mul
		stb	5,s		
		lda	1,s
		ldb	3,s
		mul
		adda	4,s
		adda	5,s		
		leas	6,s
		rts

_00002	clr	,-s				; signed divide	
		cmpx	#0
		bpl	_02000		
		com	,s		
		exg	d,x
		lbsr	_00020
		exg	d,x
_02000	tsta
		bpl	_02001		
		com	,s		
		lbsr	_00020	
_02001	lbsr	_00010
		tfr	x,d
		tst	,s+
		bpl	_02002		
		lbsr	_00020	
_02002	rts

_00003	lbsr	_00010		; unsigned divide
		tfr	x,d
		rts

_00004	clr	,-s				; signed modulous	
		cmpx	#0
		bpl	_04000		
		exg	d,x
		bsr	_00020
		exg	d,x
_04000	tsta
		bpl	_04001		
		com	,s
		bsr	_00020	
_04001	bsr	_00010	
		tst	,s+
		bpl	_04002		
		bsr	_00020	
_04002	rts

_00005	bsr	_00010		; unsigned modulous
		rts

_00006	cmpx	#0		; signed left shift
		bmi	_06001 
_06000	beq	_06009
		lslb
		rola
		leax	-1,x
		bra	_06000	
_06001	beq	_06009
		asra
		rorb
		leax	1,x
		bra	_06001	
_06009	rts

_00007	cmpx	#0		; unsined left shift
		bmi	_07001	
_07000	beq	_07009
		lslb
		rola
		leax	-1,x
		bra	_07000	
_07001	beq	_07009
		lsra
		rorb
		leax	1,x
		bra	_07001	
_07009	rts

_00008	cmpx	#0		; signed right shift
		bmi	_08001	
_08000	beq	_08009
		asra
		rorb
		leax	-1,x
		bra	_08000
	
_08001	beq	_08009
		lslb
		rola
		leax	1,x
		bra	_08001	
_08009	rts

_00009	cmpx	#0		; unsined right shift
		bmi	_09001	
_09000	beq	_09009
		lsra
		rorb
		leax	-1,x
		bra	_09000	
_09001	beq	_09009
		lslb
		rola
		leax	1,x
		bra	_09001	
_09009	rts

_00020	nega			;negate d reg
		negb
		sbca	#0
		rts

_00010	pshs	d,x		;divide subroutine	
		clra
		clrb	
		ldx	#17
	
_00011	subd	2,s
		bcc	_00012	
		addd	2,s
	
_00012	rol	1,s
		rol	,s
		rolb
		rola	
		leax	-1,x
		bne	_00011	
		rora
		rorb	
		com	1,s
		com	,s
		puls	x	
		leas	2,s
		rts


