* micro-C(ver 0.4.1), 1981-1987 Masataka Ohta, Hiroshi Tezuka.
* /***************************************************************************************************/
* /*                                                                                                 */
* /* file:           main.c			                                                               */
* /*                                                                                                 */
* /* source:        2021, written by Adrian Kundert (adrian.kundert@gmail.com)                       */
* /*                                                                                                 */
* /* description:   Sokoban game (C application for micro-c compiler)                                */
* /*                                                                                                 */
* /* This library is free software; you can redistribute it and/or modify it under the terms of the  */
* /* GNU Lesser General Public License as published by the Free Software Foundation;                 */
* /* either version 2.1 of the License, or (at your option) any later version.                       */
* /*                                                                                                 */
* /* This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;       */
* /* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.       */
* /* See the GNU Lesser General Public License for more details.                                     */
* /*                                                                                                 */
* /***************************************************************************************************/
* 
* // ! Micro-C variable max 14 characters, only the first 8 characters are considered
* #define true 			1
* #define false 			0
* 
* #define TileMemSize 	32
* #define RAMcontCnt 		10
* #define RAMtileoffset   0xE0
* 
* // APL PS2 keyboard
* #define UPARROW			0x5e
* #define LEFTARROW		0x09
* #define DOWNARROW		0x12
* #define RIGHTARROW		0x11
* 
* #define SCREEN_ROW		20
* #define SCREEN_COL		21
* #define MAP_SIZE		420 //SCREEN_ROW * SCREEN_COL
* 
* #define iEMPTY		0
* #define iWALL		1
* #define iSTORAGE	2
* #define iBOX		3
* #define iSTO_BOX	4
* #define iMAN_STD	5
* #define iPU1		6
* #define iPU2_MAN	7
* #define iPU2_MHB	8
* #define iPU2_HB		9
* 
* #define offset_D  5
* 
* #define iSOUND 		5 // re-use iMAN_STD
* 
* #define PACE		35
*  
* updateRAMTile(heading, tileIndex) unsigned char heading; unsigned char tileIndex;
* {
* 	unsigned char value;	
* 	unsigned char RAM_Container_tmp[TileMemSize];
* 	unsigned char n;
* 	unsigned char* SOKOtile;
* 	SOKOtile = {
updateRA
	pshs	u
	leau	,s
	leas	-36,s
* 	
* 	// EMPTY
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 
* 	// WALL,
* 	0x14, 0xB4, 0x14, 0xB4,
* 	0x14, 0xB4, 0x14, 0xB4,
* 	0x0, 0x0, 0x0, 0x0,
* 	0xB4, 0xA0, 0xB4, 0xA0,
* 	0xB4, 0xA0, 0xB4, 0xA0,
* 	0x0, 0x0, 0x0, 0x0,
* 	0x14, 0xB4, 0x14, 0xB4,
* 	0x14, 0xB4, 0x14, 0xB4,
* 
* 	// STORAGE
* 	0x6C, 0x60, 0xC, 0x6C,
* 	0x6C, 0xC, 0x60, 0x6C,
* 	0x60, 0x6C, 0x6C, 0xC,
* 	0xC, 0x6C, 0x6C, 0x60,
* 	0xC, 0x6C, 0x6C, 0x60,
* 	0x60, 0x6C, 0x6C, 0xC,
* 	0x6C, 0xC, 0x60, 0x6C,
* 	0x6C, 0x60, 0xC, 0x6C,
* 
* 	// BOX
* 	0x0, 0x0, 0x0, 0x0,
* 	0x18, 0xD8, 0xD8, 0xC0,
* 	0x18, 0xD8, 0xD8, 0xC0,
* 	0x18, 0xD8, 0xD8, 0xC0,
* 	0x18, 0xD8, 0xD8, 0xC0,
* 	0x18, 0xD8, 0xD8, 0xC0,
* 	0x18, 0xD8, 0xD8, 0xC0,
* 	0x0, 0x0, 0x0, 0x0,
* 
* 	// STORED_BOX
* 	0xFC, 0xFC, 0xFC, 0xFC,
* 	0xF8, 0xD8, 0xD8, 0xDC,
* 	0xF8, 0xD8, 0xD8, 0xDC,
* 	0xF8, 0xD8, 0xD8, 0xDC,
* 	0xF8, 0xD8, 0xD8, 0xDC,
* 	0xF8, 0xD8, 0xD8, 0xDC,
* 	0xF8, 0xD8, 0xD8, 0xDC,
* 	0xFC, 0xFC, 0xFC, 0xFC,
* 
* 	// MAN_STANDING_RIGHT
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0xCC, 0x6C,
* 	0x6C, 0x74, 0xAC, 0x6C,
* 	0x6C, 0x70, 0x8C, 0x6C,
* 	0x6C, 0x70, 0x90, 0x6C,
* 	0x6C, 0x70, 0x8C, 0x6C,
* 	0x6C, 0x74, 0xAC, 0x6C,
* 	0x6C, 0x6C, 0xCC, 0x6C,
* 
* 	// PUSHINGtwo_RIGHT
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x74, 0xB8,
* 	0x6C, 0x6C, 0x74, 0x6C,
* 	0x6C, 0x60, 0xB0, 0x8C,
* 	0x6C, 0x6C, 0xB0, 0x90,
* 	0x6C, 0x6C, 0xB0, 0x80,
* 	0x6C, 0x6C, 0x74, 0x6C,
* 	0x6C, 0x6C, 0x74, 0xB8,
* 
* 	// PUSHINGtwo_MAN_ONLY_RIGHT
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0xB4, 0xCC, 0x6C,
* 	0x6C, 0xAC, 0x6C, 0x6C,
* 	0x74, 0x90, 0x0C, 0x6C,
* 	0x74, 0x90, 0x8C, 0x6C,
* 	0x14, 0x90, 0x6C, 0x6C,
* 	0x6C, 0xAC, 0x6C, 0x6C,
* 	0x6C, 0xB4, 0xCC, 0x6C,
* 
* 	// PUSHINGtwo_MAN_BOX_RIGHT
* 	0x6C, 0x6C, 0x60, 0x0, 	// pushing half box
* 	0x6C, 0xB4, 0xC0, 0xD8,
* 	0x6C, 0xAC, 0x60, 0xD8,
* 	0x74, 0x90, 0x00, 0xD8,
* 	0x74, 0x90, 0x80, 0xD8,
* 	0x14, 0x90, 0x60, 0xD8,
* 	0x6C, 0xAC, 0x60, 0xD8,
* 	0x6C, 0xB4, 0xC0, 0x0,
* 
* 	// PUSHINGtwo_HALF_BOX_RIGHT
* 	0x00, 0x00, 0xC, 0x6C,	// next tile second half box
* 	0xD8, 0xD8, 0xC, 0x6C,
* 	0xD8, 0xD8, 0xC, 0x6C,
* 	0xD8, 0xD8, 0xC, 0x6C,
* 	0xD8, 0xD8, 0xC, 0x6C,
* 	0xD8, 0xD8, 0xC, 0x6C,
* 	0xD8, 0xD8, 0xC, 0x6C,
* 	0x00, 0x00, 0xC, 0x6C,
* 
* 	//-------- rotated ----------//
* 	// iMAN_STANDING_Down
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0xB0, 0x90, 0xAC,
* 	0x78, 0xB0, 0x90, 0xB8,
* 	0x6C, 0x6C, 0x8C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 	0x6C, 0x6C, 0x6C, 0x6C,
* 
* 	// iPUSHINGone_Down
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x60, 0x6C, 0x6C,
*     0x6C, 0x74, 0xB4, 0x6C,
*     0x74, 0xB0, 0x90, 0xB4,
*     0x74, 0x70, 0x90, 0x74,
*     0x78, 0x6C, 0x80, 0x78,
* 	
* 	// iPUSHINGtwo_MAN_ONLY_Down
*     0x6C, 0x6C, 0x60, 0x6C,
*     0x6C, 0x74, 0xB4, 0x6C,
*     0x74, 0xB0, 0x90, 0xB4,
*     0x74, 0x70, 0x90, 0x74,
*     0x78, 0x60, 0x8C, 0x78,
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x6C, 0x6C, 0x6C,
* 	
* 	// iPUSHINGtwo_MAN_BOX_Down
*     0x6C, 0x6C, 0x60, 0x6C,
*     0x6C, 0x74, 0xB4, 0x6C,
*     0x74, 0xB0, 0x90, 0xB4,
*     0x74, 0x70, 0x90, 0x74,
*     0x78, 0x60, 0x8C, 0x78,
*     0x00, 0x00, 0x00, 0x00,
*     0x18, 0xD8, 0xD8, 0xC0,
*     0x18, 0xD8, 0xD8, 0xC0,
* 	
* 	// iPUSHINGtwo_HALF_BOX_Down
*     0x18, 0xD8, 0xD8, 0xC0,
*     0x18, 0xD8, 0xD8, 0xC0,
*     0x18, 0xD8, 0xD8, 0xC0,
*     0x18, 0xD8, 0xD8, 0xC0,
*     0x00, 0x00, 0x00, 0x00,
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x6C, 0x6C, 0x6C,
*     0x6C, 0x6C, 0x6C, 0x6C
* 	};  //  end of tile
	leax	_2_,pc
	lbra	_2
_2_
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$14, $ffffffb4, $14, $ffffffb4, $14, $ffffffb4, $14, $ffffffb4
	fcb	$0, $0, $0, $0, $ffffffb4, $ffffffa0, $ffffffb4, $ffffffa0
	fcb	$ffffffb4, $ffffffa0, $ffffffb4, $ffffffa0, $0, $0, $0, $0
	fcb	$14, $ffffffb4, $14, $ffffffb4, $14, $ffffffb4, $14, $ffffffb4
	fcb	$6c, $60, $c, $6c, $6c, $c, $60, $6c
	fcb	$60, $6c, $6c, $c, $c, $6c, $6c, $60
	fcb	$c, $6c, $6c, $60, $60, $6c, $6c, $c
	fcb	$6c, $c, $60, $6c, $6c, $60, $c, $6c
	fcb	$0, $0, $0, $0, $18, $ffffffd8, $ffffffd8, $ffffffc0
	fcb	$18, $ffffffd8, $ffffffd8, $ffffffc0, $18, $ffffffd8, $ffffffd8, $ffffffc0
	fcb	$18, $ffffffd8, $ffffffd8, $ffffffc0, $18, $ffffffd8, $ffffffd8, $ffffffc0
	fcb	$18, $ffffffd8, $ffffffd8, $ffffffc0, $0, $0, $0, $0
	fcb	$fffffffc, $fffffffc, $fffffffc, $fffffffc, $fffffff8, $ffffffd8, $ffffffd8, $ffffffdc
	fcb	$fffffff8, $ffffffd8, $ffffffd8, $ffffffdc, $fffffff8, $ffffffd8, $ffffffd8, $ffffffdc
	fcb	$fffffff8, $ffffffd8, $ffffffd8, $ffffffdc, $fffffff8, $ffffffd8, $ffffffd8, $ffffffdc
	fcb	$fffffff8, $ffffffd8, $ffffffd8, $ffffffdc, $fffffffc, $fffffffc, $fffffffc, $fffffffc
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $ffffffcc, $6c
	fcb	$6c, $74, $ffffffac, $6c, $6c, $70, $ffffff8c, $6c
	fcb	$6c, $70, $ffffff90, $6c, $6c, $70, $ffffff8c, $6c
	fcb	$6c, $74, $ffffffac, $6c, $6c, $6c, $ffffffcc, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $74, $ffffffb8
	fcb	$6c, $6c, $74, $6c, $6c, $60, $ffffffb0, $ffffff8c
	fcb	$6c, $6c, $ffffffb0, $ffffff90, $6c, $6c, $ffffffb0, $ffffff80
	fcb	$6c, $6c, $74, $6c, $6c, $6c, $74, $ffffffb8
	fcb	$6c, $6c, $6c, $6c, $6c, $ffffffb4, $ffffffcc, $6c
	fcb	$6c, $ffffffac, $6c, $6c, $74, $ffffff90, $c, $6c
	fcb	$74, $ffffff90, $ffffff8c, $6c, $14, $ffffff90, $6c, $6c
	fcb	$6c, $ffffffac, $6c, $6c, $6c, $ffffffb4, $ffffffcc, $6c
	fcb	$6c, $6c, $60, $0, $6c, $ffffffb4, $ffffffc0, $ffffffd8
	fcb	$6c, $ffffffac, $60, $ffffffd8, $74, $ffffff90, $0, $ffffffd8
	fcb	$74, $ffffff90, $ffffff80, $ffffffd8, $14, $ffffff90, $60, $ffffffd8
	fcb	$6c, $ffffffac, $60, $ffffffd8, $6c, $ffffffb4, $ffffffc0, $0
	fcb	$0, $0, $c, $6c, $ffffffd8, $ffffffd8, $c, $6c
	fcb	$ffffffd8, $ffffffd8, $c, $6c, $ffffffd8, $ffffffd8, $c, $6c
	fcb	$ffffffd8, $ffffffd8, $c, $6c, $ffffffd8, $ffffffd8, $c, $6c
	fcb	$ffffffd8, $ffffffd8, $c, $6c, $0, $0, $c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $ffffffb0, $ffffff90, $ffffffac
	fcb	$78, $ffffffb0, $ffffff90, $ffffffb8, $6c, $6c, $ffffff8c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $60, $6c, $6c
	fcb	$6c, $74, $ffffffb4, $6c, $74, $ffffffb0, $ffffff90, $ffffffb4
	fcb	$74, $70, $ffffff90, $74, $78, $6c, $ffffff80, $78
	fcb	$6c, $6c, $60, $6c, $6c, $74, $ffffffb4, $6c
	fcb	$74, $ffffffb0, $ffffff90, $ffffffb4, $74, $70, $ffffff90, $74
	fcb	$78, $60, $ffffff8c, $78, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $60, $6c, $6c, $74, $ffffffb4, $6c
	fcb	$74, $ffffffb0, $ffffff90, $ffffffb4, $74, $70, $ffffff90, $74
	fcb	$78, $60, $ffffff8c, $78, $0, $0, $0, $0
	fcb	$18, $ffffffd8, $ffffffd8, $ffffffc0, $18, $ffffffd8, $ffffffd8, $ffffffc0
	fcb	$18, $ffffffd8, $ffffffd8, $ffffffc0, $18, $ffffffd8, $ffffffd8, $ffffffc0
	fcb	$18, $ffffffd8, $ffffffd8, $ffffffc0, $18, $ffffffd8, $ffffffd8, $ffffffc0
	fcb	$0, $0, $0, $0, $6c, $6c, $6c, $6c
	fcb	$6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
_2
	tfr	x,d
	std	-36,u
* 		
* 	for (n = 0; n < TileMemSize; n++) {			
	clra
	clrb
	stb	-34,u
_4
	ldb	-34,u
	clra
	subd	#$20
	lbhs	_3
* 		if ((heading == RIGHTARROW) || (heading == LEFTARROW) || (tileIndex <= iSTO_BOX)) {			
	ldb	5,u
	clra
	subd	#$11
	lbeq	_7
	ldb	5,u
	clra
	subd	#$9
	lbeq	_7
	ldb	7,u
	clra
	subd	#$4
	lbhi	_6
_7
* 			// default tile (right heading)
* 				value = SOKOtile[TileMemSize * tileIndex + n];
	ldb	-34,u
	clra
	pshs	d
	ldd	#$20
	pshs	d
	ldb	7,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	ldx	-36,u
	ldb	d,x
	clra
	stb	-1,u
* 			if ((heading == LEFTARROW) && (tileIndex > iSTO_BOX)) {
	ldb	5,u
	clra
	subd	#$9
	lbne	_8
	ldb	7,u
	clra
	subd	#$4
	lbls	_8
* 				// invert the tile
* 				value = ((value << 3) & 0xe0) | ((value >> 3) & 0x1c); // swap RBGRGB00
	ldd	#$3
	pshs	d
	ldb	-1,u
	clra
	puls	x
	lbsr	_00009
	anda	#$0
	andb	#$1c
	pshs	d
	ldd	#$3
	pshs	d
	ldb	-1,u
	clra
	puls	x
	lbsr	_00007
	anda	#$0
	andb	#$e0
	ora	,s+
	orb	,s+
	stb	-1,u
* 				RAM_Container_tmp[TileMemSize-1 - n] = value;
	ldb	-34,u
	clra
	pshs	d
	ldd	#$1f
	subd	,s++
	leax	-33,u
	leax	d,x
	ldb	-1,u
	clra
	stb	0,x
* 			}
* 			else
	lbra	_9
_8
* 				RAM_Container_tmp[n] = value;				
	ldb	-34,u
	clra
	leax	-33,u
	leax	d,x
	ldb	-1,u
	clra
	stb	0,x
* 		}
_9
* 		else {
	lbra	_10
_6
* 			// 90� rotated tile (down heading)
* 				value = SOKOtile[TileMemSize * (tileIndex + offset_D) + n];
	ldb	-34,u
	clra
	pshs	d
	ldd	#$20
	pshs	d
	ldb	7,u
	clra
	addd	#$5
	puls	x
	lbsr	_00001
	addd	,s++
	ldx	-36,u
	ldb	d,x
	clra
	stb	-1,u
* 			if (heading == UPARROW) {
	ldb	5,u
	clra
	subd	#$5e
	lbne	_11
* 				// invert the tile
* 				value = ((value << 3) & 0xe0) | ((value >> 3) & 0x1c); // swap RBGRGB00
	ldd	#$3
	pshs	d
	ldb	-1,u
	clra
	puls	x
	lbsr	_00009
	anda	#$0
	andb	#$1c
	pshs	d
	ldd	#$3
	pshs	d
	ldb	-1,u
	clra
	puls	x
	lbsr	_00007
	anda	#$0
	andb	#$e0
	ora	,s+
	orb	,s+
	stb	-1,u
* 				RAM_Container_tmp[TileMemSize-1 - n] = value;
	ldb	-34,u
	clra
	pshs	d
	ldd	#$1f
	subd	,s++
	leax	-33,u
	leax	d,x
	ldb	-1,u
	clra
	stb	0,x
* 			}
* 			else
	lbra	_12
_11
* 				RAM_Container_tmp[n] = value;
	ldb	-34,u
	clra
	leax	-33,u
	leax	d,x
	ldb	-1,u
	clra
	stb	0,x
* 		}			
_12
* 	}
_10
* 	sendContainerData(tileIndex + RAMtileoffset -'0', RAM_Container_tmp);  //tmp hack
_5
	leax	-34,u
	ldb	,x
	inc	,x
	clra
	lbra	_4
_3
	leax	-33,u
	pshs	x
	ldb	7,u
	sex
	addd	#$e0
	subd	#$30
	pshs	d
	lbsr	sendCont
	leas	4,s
* }
	leas	,u
	puls	u,pc
* 
* sendstepSound() {
* 		
* 	// re-use the standing data container for the sound
* 	unsigned char* step_sound;
* 	step_sound = {1, 200, 0};
sendstep
	pshs	u
	leau	,s
	leas	-2,s
	leax	_13_,pc
	bra	_13
_13_
	fcb	$1, $ffffffc8, $0
_13
	tfr	x,d
	std	-2,u
* 	sendContainerData(iSOUND + RAMtileoffset - '0', step_sound);	//tmp hack
	ldd	-2,u
	pshs	d
	ldd	#$b5
	pshs	d
	lbsr	sendCont
	leas	4,s
* }
	puls	d,u,pc
* 
* updateMap(pMap, x, y, tileIndex) unsigned char* pMap; unsigned char x; unsigned char y; unsigned char tileIndex;
* {
* 	
* 	pMap[y*SCREEN_COL + x] = tileIndex;
updateMa
	pshs	u
	leau	,s
	ldb	7,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	9,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	ldx	4,u
	leax	d,x
	ldb	11,u
	clra
	stb	0,x
* 	
* 	setpointXY(x, y); setTile(tileIndex + RAMtileoffset);
	ldb	9,u
	clra
	pshs	d
	ldb	7,u
	clra
	pshs	d
	lbsr	setpoint
	leas	4,s
	ldb	11,u
	clra
	addd	#$e0
	pshs	d
	lbsr	setTile
	leas	2,s
* }
	puls	u,pc
* 
* getMapTileIndex(pMap, x, y) unsigned char* pMap; unsigned char x; unsigned char y;
* {	
* 	return pMap[y*SCREEN_COL + x];
getMapTi
	pshs	u
	leau	,s
	ldb	7,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	9,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	ldx	4,u
	ldb	d,x
	clra
* }
	puls	u,pc
* 
* sendString(x, y, str) unsigned char x; unsigned char y; char* str;
* {
* 	unsigned char n,c;
* 	n = 0;
sendStri
	pshs	u
	leau	,s
	leas	-2,s
	clra
	clrb
	stb	-1,u
* 	setpointXY(x, y); 
	ldb	7,u
	clra
	pshs	d
	ldb	5,u
	clra
	pshs	d
	lbsr	setpoint
	leas	4,s
* 	while(1) {
_15
* 		c = str[n];
	ldb	-1,u
	clra
	ldx	8,u
	ldb	d,x
	clra
	stb	-2,u
* 		if (c == 0) break;
	ldb	-2,u
	clra
	subd	#$0
	lbne	_16
	lbra	_14
* 		if (c >= 'A') c -= '@';	// re-mapping ASCII to PETSCII
_16
	ldb	-2,u
	clra
	subd	#$41
	lblo	_17
	ldb	-2,u
	clra
	subd	#$40
	stb	-2,u
* 		setTile(c);
_17
	ldb	-2,u
	clra
	pshs	d
	lbsr	setTile
	leas	2,s
* 		n++;
	leax	-1,u
	ldb	,x
	inc	,x
	clra
* 	}
* }
	lbra	_15
_14
	puls	d,u,pc
* 
* #define stringSize 	4
* printScoreboard(moveStr, pushStr) unsigned char* moveStr; unsigned char* pushStr;
* {
* 	unsigned char n;
* 	for (n = 0; n < stringSize-1; n++) {
printSco
	pshs	u
	leau	,s
	leas	-1,s
	clra
	clrb
	stb	-1,u
_19
	ldb	-1,u
	clra
	subd	#$3
	lbhs	_18
* 		if (moveStr[n] > '9') {
	ldb	-1,u
	clra
	ldx	4,u
	ldb	d,x
	clra
	subd	#$39
	lbls	_21
* 			moveStr[n] = '0';
	ldb	-1,u
	clra
	ldx	4,u
	leax	d,x
	ldd	#$30
	stb	0,x
* 			moveStr[n+1]++;
	ldb	-1,u
	clra
	addd	#$1
	ldx	4,u
	leax	d,x
	ldb	,x
	inc	,x
	clra
* 		}
* 	}	
_21
* 	for (n = 0; n < stringSize; n++) {
_20
	leax	-1,u
	ldb	,x
	inc	,x
	clra
	lbra	_19
_18
	clra
	clrb
	stb	-1,u
_23
	ldb	-1,u
	clra
	subd	#$4
	lbhs	_22
* 		setpointXY(n+5, 19); setTile(moveStr[stringSize-1-n]);		
	ldd	#$13
	pshs	d
	ldb	-1,u
	clra
	addd	#$5
	pshs	d
	lbsr	setpoint
	leas	4,s
	ldb	-1,u
	clra
	pshs	d
	ldd	#$3
	subd	,s++
	ldx	4,u
	ldb	d,x
	clra
	pshs	d
	lbsr	setTile
	leas	2,s
* 	}
* 
* 
* 	for (n = 0; n < stringSize-1; n++) {
_24
	leax	-1,u
	ldb	,x
	inc	,x
	clra
	lbra	_23
_22
	clra
	clrb
	stb	-1,u
_26
	ldb	-1,u
	clra
	subd	#$3
	lbhs	_25
* 		if (pushStr[n] > '9') {
	ldb	-1,u
	clra
	ldx	6,u
	ldb	d,x
	clra
	subd	#$39
	lbls	_28
* 			pushStr[n] = '0';
	ldb	-1,u
	clra
	ldx	6,u
	leax	d,x
	ldd	#$30
	stb	0,x
* 			pushStr[n+1]++;
	ldb	-1,u
	clra
	addd	#$1
	ldx	6,u
	leax	d,x
	ldb	,x
	inc	,x
	clra
* 		}
* 	}
_28
* 	for (n = 0; n < stringSize; n++) {
_27
	leax	-1,u
	ldb	,x
	inc	,x
	clra
	lbra	_26
_25
	clra
	clrb
	stb	-1,u
_30
	ldb	-1,u
	clra
	subd	#$4
	lbhs	_29
* 		setpointXY(n+15, 19); setTile(pushStr[stringSize-1-n]);		
	ldd	#$13
	pshs	d
	ldb	-1,u
	clra
	addd	#$f
	pshs	d
	lbsr	setpoint
	leas	4,s
	ldb	-1,u
	clra
	pshs	d
	ldd	#$3
	subd	,s++
	ldx	6,u
	ldb	d,x
	clra
	pshs	d
	lbsr	setTile
	leas	2,s
* 	}	
* }		
_31
	leax	-1,u
	ldb	,x
	inc	,x
	clra
	lbra	_30
_29
	puls	a,u,pc
* 
* /***********************************************************************************************/
* /*	main program
* /***********************************************************************************************/
* 
* // states definition
* #define standing 	0
* #define push1 		1
* #define push2_empty 2
* #define push2_box 	3
* main() {
* 	char* gameLevel;					//-2,u
* 	char* scoreBoard;					//-4,u
* 	char* gameEnded;					//-6,u
* 	unsigned char* SOKOmap_L1;			//-8,u
* 	unsigned char map[MAP_SIZE]; 		//-428,u
* 	unsigned char state;				//-429,u
* 	unsigned char xPos, yPos, heading;	//-430,u ...
* 	unsigned char key;					//-433,u
* 	unsigned char undo;					//-434,u
* 	unsigned char pushStr[stringSize]; 	//-435,u
* 	unsigned char moveStr[stringSize]; 	//-436,u
* 	
* 	// inner loops variables
* 	unsigned int i;						//-438,u
* 	unsigned char y, x;					//-439,u ...
* 	unsigned char tile;					//-441,u
* 	unsigned char nextxPos, nextyPos, next2xPos, next2yPos;		//u,-442,u   ....
* 	unsigned char nextTile, next2Tile;	//-446,u   -447,u
* 	
* 	gameLevel  = "LEVEL 01             ";
main
	pshs	u
	leau	,s
	leas	-453,s
	leax	_32_,pc
	bra	_32
_32_
	fcb	$4c, $45, $56, $45, $4c, $20, $30, $31
	fcb	$20, $20, $20, $20, $20, $20, $20, $20
	fcb	$20, $20, $20, $20, $20, $0
_32
	tfr	x,d
	std	-2,u
* 	scoreBoard = "MOVE:0000 PUSH:0000  ";
	leax	_33_,pc
	bra	_33
_33_
	fcb	$4d, $4f, $56, $45, $3a, $30, $30, $30
	fcb	$30, $20, $50, $55, $53, $48, $3a, $30
	fcb	$30, $30, $30, $20, $20, $0
_33
	tfr	x,d
	std	-4,u
* 	gameEnded = "WELL DONE!";
	leax	_34_,pc
	bra	_34
_34_
	fcb	$57, $45, $4c, $4c, $20, $44, $4f, $4e
	fcb	$45, $21, $0
_34
	tfr	x,d
	std	-6,u
* 	state = standing;
	clra
	clrb
	stb	-429,u
* 	undo = false;	
	clra
	clrb
	stb	-434,u
* 
* 	key = 0;
	clra
	clrb
	stb	-433,u
* 	xPos=12; yPos=11; heading = RIGHTARROW;
	ldd	#$c
	stb	-430,u
	ldd	#$b
	stb	-431,u
	ldd	#$11
	stb	-432,u
* 		
* 	// map (width 21, height 20) populated with tile indexes
* 	SOKOmap_L1 = {
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x3, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x3, 0x0, 0x3, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0,
* 	0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x2, 0x2, 0x1, 0x0,
* 	0x0, 0x1, 0x0, 0x3, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2, 0x2, 0x1, 0x0,
* 	0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x0, 0x2, 0x2, 0x1, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
* 	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
* 	};  //  end of map
	leax	_35_,pc
	lbra	_35
_35_
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $1, $1, $1, $1
	fcb	$1, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $1, $0, $0, $0, $1, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $1, $3
	fcb	$0, $0, $1, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $1, $1, $1, $0, $0, $3, $1
	fcb	$1, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $1, $0
	fcb	$0, $3, $0, $3, $0, $1, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $1, $1, $1, $0, $1, $0, $1
	fcb	$1, $0, $1, $0, $0, $0, $1, $1
	fcb	$1, $1, $1, $1, $0, $0, $1, $0
	fcb	$0, $0, $1, $0, $1, $1, $0, $1
	fcb	$1, $1, $1, $1, $0, $0, $2, $2
	fcb	$1, $0, $0, $1, $0, $3, $0, $0
	fcb	$3, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $2, $2, $1, $0, $0
	fcb	$1, $1, $1, $1, $1, $0, $1, $1
	fcb	$1, $0, $1, $0, $1, $1, $0, $0
	fcb	$2, $2, $1, $0, $0, $0, $0, $0
	fcb	$0, $1, $0, $0, $0, $0, $0, $1
	fcb	$1, $1, $1, $1, $1, $1, $1, $1
	fcb	$0, $0, $0, $0, $0, $0, $1, $1
	fcb	$1, $1, $1, $1, $1, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0, $0, $0, $0, $0
	fcb	$0, $0, $0, $0
_35
	tfr	x,d
	std	-8,u
* 	
* 	// init the RAM Tiles
* 	for (x = 0; x < RAMcontCnt; x++) {
	clra
	clrb
	stb	-446,u
_37
	ldb	-446,u
	clra
	subd	#$a
	lbhs	_36
* 		updateRAMTile(heading, x);
	ldb	-446,u
	clra
	pshs	d
	ldb	-432,u
	clra
	pshs	d
	lbsr	updateRA
	leas	4,s
* 	}
* 
* 	// get the the ROM map
* 	for (y=0; y<SCREEN_ROW; y++) {
_38
	leax	-446,u
	ldb	,x
	inc	,x
	clra
	lbra	_37
_36
	clra
	clrb
	stb	-445,u
_40
	ldb	-445,u
	clra
	subd	#$14
	lbhs	_39
* 		for (x=0; x<SCREEN_COL; x++) {
	clra
	clrb
	stb	-446,u
_43
	ldb	-446,u
	clra
	subd	#$15
	lbhs	_42
* 			i = y*SCREEN_COL + x;
	ldb	-446,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-445,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 			updateMap(map, x, y, SOKOmap_L1[i]);
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	pshs	d
	ldb	-445,u
	clra
	pshs	d
	ldb	-446,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 		}
* 	}
_44
	leax	-446,u
	ldb	,x
	inc	,x
	clra
	lbra	_43
_42
* 	
* 	// add the man
* 	updateMap(map, xPos, yPos, iMAN_STD);
_41
	leax	-445,u
	ldb	,x
	inc	,x
	clra
	lbra	_40
_39
	ldd	#$5
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 		
* 	// init score board
* 	sendString(0, 0, gameLevel);
	ldd	-2,u
	pshs	d
	clra
	clrb
	pshs	d
	clra
	clrb
	pshs	d
	lbsr	sendStri
	leas	6,s
* 	sendString(0, 19, scoreBoard);
	ldd	-4,u
	pshs	d
	ldd	#$13
	pshs	d
	clra
	clrb
	pshs	d
	lbsr	sendStri
	leas	6,s
* 	for (x = 0; x < stringSize; x++) {
	clra
	clrb
	stb	-446,u
_46
	ldb	-446,u
	clra
	subd	#$4
	lbhs	_45
* 		pushStr[x] = moveStr[x] = '0';
	ldb	-446,u
	clra
	leax	-442,u
	leax	d,x
	ldd	#$30
	stb	0,x
	pshs	d
	ldb	-446,u
	clra
	leax	-438,u
	leax	d,x
	puls	d
	stb	0,x
* 	}
* 	printScoreboard(moveStr, pushStr);
_47
	leax	-446,u
	ldb	,x
	inc	,x
	clra
	lbra	_46
_45
	leax	-438,u
	pshs	x
	leax	-442,u
	pshs	x
	lbsr	printSco
	leas	4,s
* 	
* 	while(1) {			
_49
* 		// keyboard handling		
* 		APL_OutputStream();
	lbsr	APL_Outp
* 		if((key == 0) && (isKeyboardData() != 0)){
	ldb	-433,u
	sex
	subd	#$0
	lbne	_50
	lbsr	isKeyboa
	subd	#$0
	lbeq	_50
* 			key = getKeyboard();
	lbsr	getKeybo
	stb	-433,u
* 			
* 			if ((state != standing) && (key != heading)) key = 0; // don't allow other directions when still in move
	ldb	-429,u
	clra
	subd	#$0
	lbeq	_51
	ldb	-432,u
	clra
	pshs	d
	ldb	-433,u
	clra
	subd	,s++
	lbeq	_51
	clra
	clrb
	stb	-433,u
* 			
* 			// undo command
* 			if(((key == 'u') || (key == 'U')) && (undo == true)) {
_51
	ldb	-433,u
	clra
	subd	#$75
	lbeq	_53
	ldb	-433,u
	clra
	subd	#$55
	lbne	_52
_53
	ldb	-434,u
	clra
	subd	#$1
	lbne	_52
* 				i=0;
	clra
	clrb
	std	-444,u
* 				tile=0;
	clra
	clrb
	stb	-447,u
* 				switch(heading) {
	ldb	-432,u
	clra
* 					case LEFTARROW :
* 						updateMap(map, xPos+1, yPos, getMapTileIndex(map, xPos, yPos)); // move man						
	cmpd	#$9
	lbne	_56
_55
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	addd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						tile = getMapTileIndex(map, xPos-1, yPos); // move box						
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	subd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-447,u
* 						if ((tile == iBOX) || (tile == iSTO_BOX)) {
	ldb	-447,u
	clra
	subd	#$3
	lbeq	_58
	ldb	-447,u
	clra
	subd	#$4
	lbne	_57
_58
* 							i = yPos*SCREEN_COL + (xPos);
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_59
	ldd	#$4
	stb	-447,u
* 							else tile = iBOX;
	lbra	_60
_59
	ldd	#$3
	stb	-447,u
* 						}
_60
* 						updateMap(map, xPos, yPos, tile);
_57
	ldb	-447,u
	clra
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						i = yPos*SCREEN_COL + (xPos-1);
	ldb	-430,u
	clra
	subd	#$1
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos-1, yPos, iSTORAGE); // get back initial
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_61
	ldd	#$2
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	subd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						else updateMap(map, xPos-1, yPos, iEMPTY);
	lbra	_62
_61
	clra
	clrb
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	subd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						xPos++;		
_62
	leax	-430,u
	ldb	,x
	inc	,x
	clra
* 						break;					
	lbra	_54
* 					case RIGHTARROW :
* 						updateMap(map, xPos-1, yPos, getMapTileIndex(map, xPos, yPos)); // move man
_56
	cmpd	#$11
	lbne	_64
_63
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	subd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						tile = getMapTileIndex(map, xPos+1, yPos); // move box
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	addd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-447,u
* 						if ((tile == iBOX) || (tile == iSTO_BOX)) {
	ldb	-447,u
	clra
	subd	#$3
	lbeq	_66
	ldb	-447,u
	clra
	subd	#$4
	lbne	_65
_66
* 							i = yPos*SCREEN_COL + (xPos);
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_67
	ldd	#$4
	stb	-447,u
* 							else tile = iBOX;
	lbra	_68
_67
	ldd	#$3
	stb	-447,u
* 						}						
_68
* 						updateMap(map, xPos, yPos, tile);
_65
	ldb	-447,u
	clra
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						i = yPos*SCREEN_COL + (xPos+1);
	ldb	-430,u
	clra
	addd	#$1
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos+1, yPos, iSTORAGE); // get back initial
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_69
	ldd	#$2
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	addd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						else updateMap(map, xPos+1, yPos, iEMPTY);
	lbra	_70
_69
	clra
	clrb
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	addd	#$1
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						xPos--;
_70
	leax	-430,u
	ldb	,x
	dec	,x
	clra
* 						break;
	lbra	_54
* 					case UPARROW :
* 						updateMap(map, xPos, yPos+1, getMapTileIndex(map, xPos, yPos)); // move man
_64
	cmpd	#$5e
	lbne	_72
_71
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	pshs	d
	ldb	-431,u
	clra
	addd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						tile = getMapTileIndex(map, xPos, yPos-1); // move box
	ldb	-431,u
	clra
	subd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-447,u
* 						if ((tile == iBOX) || (tile == iSTO_BOX)) {
	ldb	-447,u
	clra
	subd	#$3
	lbeq	_74
	ldb	-447,u
	clra
	subd	#$4
	lbne	_73
_74
* 							i = yPos*SCREEN_COL + (xPos);
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_75
	ldd	#$4
	stb	-447,u
* 							else tile = iBOX;
	lbra	_76
_75
	ldd	#$3
	stb	-447,u
* 						}
_76
* 						updateMap(map, xPos, yPos, tile);						
_73
	ldb	-447,u
	clra
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						i = (yPos-1)*SCREEN_COL + xPos;
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	subd	#$1
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos-1, iSTORAGE); // get back initial
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_77
	ldd	#$2
	pshs	d
	ldb	-431,u
	clra
	subd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						else updateMap(map, xPos, yPos-1, iEMPTY);
	lbra	_78
_77
	clra
	clrb
	pshs	d
	ldb	-431,u
	clra
	subd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						yPos++;
_78
	leax	-431,u
	ldb	,x
	inc	,x
	clra
* 						break;
	lbra	_54
* 					break;
	lbra	_54
* 					case DOWNARROW :
* 						updateMap(map, xPos, yPos-1, getMapTileIndex(map, xPos, yPos)); // move man
_72
	cmpd	#$12
	lbne	_80
_79
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	pshs	d
	ldb	-431,u
	clra
	subd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						tile = getMapTileIndex(map, xPos, yPos+1); // move box
	ldb	-431,u
	clra
	addd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-447,u
* 						if ((tile == iBOX) || (tile == iSTO_BOX)) {
	ldb	-447,u
	clra
	subd	#$3
	lbeq	_82
	ldb	-447,u
	clra
	subd	#$4
	lbne	_81
_82
* 							i = yPos*SCREEN_COL + (xPos);
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_83
	ldd	#$4
	stb	-447,u
* 							else tile = iBOX;
	lbra	_84
_83
	ldd	#$3
	stb	-447,u
* 						}
_84
* 						updateMap(map, xPos, yPos, tile);
_81
	ldb	-447,u
	clra
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						i = (yPos+1)*SCREEN_COL + xPos;
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	addd	#$1
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos+1, iSTORAGE); // get back initial
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_85
	ldd	#$2
	pshs	d
	ldb	-431,u
	clra
	addd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						else updateMap(map, xPos, yPos+1, iEMPTY);
	lbra	_86
_85
	clra
	clrb
	pshs	d
	ldb	-431,u
	clra
	addd	#$1
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						yPos--;
_86
	leax	-431,u
	ldb	,x
	dec	,x
	clra
* 						break;
	lbra	_54
* 				}
* 				undo = false;
_80
_54
	clra
	clrb
	stb	-434,u
* 			}
* 			
* 			if((key != LEFTARROW) && (key != UPARROW) && (key != DOWNARROW) && (key != RIGHTARROW)) key = 0;
_52
	ldb	-433,u
	clra
	subd	#$9
	lbeq	_87
	ldb	-433,u
	clra
	subd	#$5e
	lbeq	_87
	ldb	-433,u
	clra
	subd	#$12
	lbeq	_87
	ldb	-433,u
	clra
	subd	#$11
	lbeq	_87
	clra
	clrb
	stb	-433,u
* 			else {
	lbra	_88
_87
* 				if (key != heading) { // change direction when push completed
	ldb	-432,u
	clra
	pshs	d
	ldb	-433,u
	clra
	subd	,s++
	lbeq	_89
* 					heading = key;	// new direction
	ldb	-433,u
	clra
	stb	-432,u
* 					for (x = 0; x < RAMcontCnt; x++) {
	clra
	clrb
	stb	-446,u
_91
	ldb	-446,u
	clra
	subd	#$a
	lbhs	_90
* 						updateRAMTile(heading, x);
	ldb	-446,u
	clra
	pshs	d
	ldb	-432,u
	clra
	pshs	d
	lbsr	updateRA
	leas	4,s
* 					}
* 				}
_92
	leax	-446,u
	ldb	,x
	inc	,x
	clra
	lbra	_91
_90
* 			}
_89
* 		}		
_88
* 		
* 		nextxPos = nextyPos = next2xPos = next2yPos = 0;
_50
	clra
	clrb
	stb	-451,u
	stb	-450,u
	stb	-449,u
	stb	-448,u
* 		switch(heading) {
	ldb	-432,u
	clra
* 		case LEFTARROW : 
* 			nextxPos = xPos-1; nextyPos = yPos;
	cmpd	#$9
	lbne	_95
_94
	ldb	-430,u
	clra
	subd	#$1
	stb	-448,u
	ldb	-431,u
	clra
	stb	-449,u
* 			next2xPos = xPos-2; next2yPos = yPos;
	ldb	-430,u
	clra
	subd	#$2
	stb	-450,u
	ldb	-431,u
	clra
	stb	-451,u
* 			break;
	lbra	_93
* 		case RIGHTARROW :
* 			nextxPos = xPos+1; nextyPos = yPos;
_95
	cmpd	#$11
	lbne	_97
_96
	ldb	-430,u
	clra
	addd	#$1
	stb	-448,u
	ldb	-431,u
	clra
	stb	-449,u
* 			next2xPos = xPos+2; next2yPos = yPos;
	ldb	-430,u
	clra
	addd	#$2
	stb	-450,u
	ldb	-431,u
	clra
	stb	-451,u
* 			break;
	lbra	_93
* 		case UPARROW :
* 			nextxPos = xPos; nextyPos = yPos-1;
_97
	cmpd	#$5e
	lbne	_99
_98
	ldb	-430,u
	clra
	stb	-448,u
	ldb	-431,u
	clra
	subd	#$1
	stb	-449,u
* 			next2xPos = xPos; next2yPos = yPos-2;
	ldb	-430,u
	clra
	stb	-450,u
	ldb	-431,u
	clra
	subd	#$2
	stb	-451,u
* 			break;
	lbra	_93
* 		case DOWNARROW :
* 			nextxPos = xPos; nextyPos = yPos+1;
_99
	cmpd	#$12
	lbne	_101
_100
	ldb	-430,u
	clra
	stb	-448,u
	ldb	-431,u
	clra
	addd	#$1
	stb	-449,u
* 			next2xPos = xPos; next2yPos = yPos+2;
	ldb	-430,u
	clra
	stb	-450,u
	ldb	-431,u
	clra
	addd	#$2
	stb	-451,u
* 			break;
	lbra	_93
* 		}
* 
* 		switch(state) {
_101
_93
	ldb	-429,u
	clra
* 		case standing:
* 			{
	cmpd	#$0
	lbne	_104
_103
* 				nextTile = getMapTileIndex(map, nextxPos, nextyPos);
	ldb	-449,u
	clra
	pshs	d
	ldb	-448,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-452,u
* 				next2Tile = getMapTileIndex(map, next2xPos, next2yPos);
	ldb	-451,u
	clra
	pshs	d
	ldb	-450,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-453,u
* 				if ((key != 0) && ((nextTile == iEMPTY) || (nextTile == iSTORAGE) || (((nextTile == iBOX) || (nextTile == iSTO_BOX)) && ((next2Tile == iSTORAGE) || (next2Tile == iEMPTY)))) ) {
	ldb	-433,u
	clra
	subd	#$0
	lbeq	_105
	ldb	-452,u
	clra
	subd	#$0
	lbeq	_106
	ldb	-452,u
	clra
	subd	#$2
	lbeq	_106
	ldb	-452,u
	clra
	subd	#$3
	lbeq	_107
	ldb	-452,u
	clra
	subd	#$4
	lbne	_105
_107
	ldb	-453,u
	clra
	subd	#$2
	lbeq	_108
	ldb	-453,u
	clra
	subd	#$0
	lbne	_105
_108
_106
* 					state = push1;		// begin to move				
	ldd	#$1
	stb	-429,u
* 					updateMap(map, xPos, yPos, iPU1);
	ldd	#$6
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 					sendstepSound();	// update the data container
	lbsr	sendstep
* 					msDelay(PACE);	// execution sync
	ldd	#$23
	pshs	d
	lbsr	msDelay
	leas	2,s
* 				}
* 				else key = 0;
	lbra	_109
_105
	clra
	clrb
	stb	-433,u
* 			}			
_109
* 			break;
	lbra	_102
* 		case push1:
* 			{
_104
	cmpd	#$1
	lbne	_111
_110
* 				nextTile = getMapTileIndex(map, nextxPos, nextyPos);
	ldb	-449,u
	clra
	pshs	d
	ldb	-448,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-452,u
* 				if(nextTile == iWALL) {
	ldb	-452,u
	clra
	subd	#$1
	lbne	_112
* 					state = standing;					// stop pushing
	clra
	clrb
	stb	-429,u
* 					updateRAMTile(heading, iMAN_STD);	// data container back to standing
	ldd	#$5
	pshs	d
	ldb	-432,u
	clra
	pshs	d
	lbsr	updateRA
	leas	4,s
* 					updateMap(map, xPos, yPos, iMAN_STD);
	ldd	#$5
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 				}			
* 				if((nextTile == iBOX) || (nextTile == iSTO_BOX)) {
_112
	ldb	-452,u
	clra
	subd	#$3
	lbeq	_114
	ldb	-452,u
	clra
	subd	#$4
	lbne	_113
_114
* 					next2Tile = getMapTileIndex(map, next2xPos, next2yPos);
	ldb	-451,u
	clra
	pshs	d
	ldb	-450,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	getMapTi
	leas	6,s
	stb	-453,u
* 					if((next2Tile == iEMPTY) || (next2Tile == iSTORAGE)) {
	ldb	-453,u
	clra
	subd	#$0
	lbeq	_116
	ldb	-453,u
	clra
	subd	#$2
	lbne	_115
_116
* 						state = push2_box;	// push the box
	ldd	#$3
	stb	-429,u
* 						setSound(iSOUND);
	ldd	#$5
	pshs	d
	lbsr	setSound
	leas	2,s
* 						i = yPos*SCREEN_COL + xPos;
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos, iSTORAGE); // get back initial
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_117
	ldd	#$2
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						else updateMap(map, xPos, yPos, iEMPTY);						
	lbra	_118
_117
	clra
	clrb
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						xPos = nextxPos; yPos = nextyPos; // move to next field with half box
_118
	ldb	-448,u
	clra
	stb	-430,u
	ldb	-449,u
	clra
	stb	-431,u
* 						updateMap(map, xPos, yPos, iPU2_MHB);
	ldd	#$8
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 						updateMap(map, next2xPos, next2yPos, iPU2_HB);	// second half box at next field					
	ldd	#$9
	pshs	d
	ldb	-451,u
	clra
	pshs	d
	ldb	-450,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 					}
* 					else {
	lbra	_119
_115
* 						state = standing;					// cannot push anymore
	clra
	clrb
	stb	-429,u
* 						updateRAMTile(heading, iMAN_STD);	// data container back to standing
	ldd	#$5
	pshs	d
	ldb	-432,u
	clra
	pshs	d
	lbsr	updateRA
	leas	4,s
* 						updateMap(map, xPos, yPos, iMAN_STD);
	ldd	#$5
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 					}
* 				}
_119
* 				if((nextTile == iEMPTY) || (nextTile == iSTORAGE)) {
_113
	ldb	-452,u
	clra
	subd	#$0
	lbeq	_121
	ldb	-452,u
	clra
	subd	#$2
	lbne	_120
_121
* 					state = push2_empty;	// push the box
	ldd	#$2
	stb	-429,u
* 					setSound(iSOUND);
	ldd	#$5
	pshs	d
	lbsr	setSound
	leas	2,s
* 					i = yPos*SCREEN_COL + xPos;
	ldb	-430,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-431,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 					if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos, iSTORAGE); // get back initial
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_122
	ldd	#$2
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 					else updateMap(map, xPos, yPos, iEMPTY);
	lbra	_123
_122
	clra
	clrb
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 					xPos = nextxPos; yPos = nextyPos; // move to next field
_123
	ldb	-448,u
	clra
	stb	-430,u
	ldb	-449,u
	clra
	stb	-431,u
* 					updateMap(map, xPos, yPos, iPU2_MAN);				
	ldd	#$7
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 				}				
* 				key = 0;	// move lock end				
_120
	clra
	clrb
	stb	-433,u
* 				msDelay(PACE);	// execution sync
	ldd	#$23
	pshs	d
	lbsr	msDelay
	leas	2,s
* 				break;
	lbra	_102
* 			}
* 		case push2_empty:
* 			if (key != 0) {
_111
	cmpd	#$2
	lbne	_125
_124
	ldb	-433,u
	clra
	subd	#$0
	lbeq	_126
* 				state = push1;	// prepare to move to the next field
	ldd	#$1
	stb	-429,u
* 				updateMap(map, xPos, yPos, iPU1);				
	ldd	#$6
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 			}
* 			else {
	lbra	_127
_126
* 				state = standing;	// stop moving
	clra
	clrb
	stb	-429,u
* 				updateRAMTile(heading, iMAN_STD);	// data container back to standing
	ldd	#$5
	pshs	d
	ldb	-432,u
	clra
	pshs	d
	lbsr	updateRA
	leas	4,s
* 				updateMap(map, xPos, yPos, iMAN_STD);
	ldd	#$5
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 			}
* 			moveStr[0]++; printScoreboard(moveStr, pushStr);
_127
	leax	-442,u
	ldb	,x
	inc	,x
	clra
	leax	-438,u
	pshs	x
	leax	-442,u
	pshs	x
	lbsr	printSco
	leas	4,s
* 			undo = false;
	clra
	clrb
	stb	-434,u
* 			msDelay(PACE);	// execution sync			
	ldd	#$23
	pshs	d
	lbsr	msDelay
	leas	2,s
* 			break;
	lbra	_102
* 		case push2_box:
* 			if (key != 0) {
_125
	cmpd	#$3
	lbne	_129
_128
	ldb	-433,u
	clra
	subd	#$0
	lbeq	_130
* 				state = push1;	// keep pushing box through next field
	ldd	#$1
	stb	-429,u
* 				updateMap(map, xPos, yPos, iPU1);
	ldd	#$6
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 			}
* 			else {
	lbra	_131
_130
* 				updateRAMTile(heading, iMAN_STD);	// data container back to standing
	ldd	#$5
	pshs	d
	ldb	-432,u
	clra
	pshs	d
	lbsr	updateRA
	leas	4,s
* 				state = standing;
	clra
	clrb
	stb	-429,u
* 				updateMap(map, xPos, yPos, iMAN_STD);
	ldd	#$5
	pshs	d
	ldb	-431,u
	clra
	pshs	d
	ldb	-430,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 			}
* 			i = nextyPos*SCREEN_COL + nextxPos;
_131
	ldb	-448,u
	clra
	pshs	d
	ldd	#$15
	pshs	d
	ldb	-449,u
	clra
	puls	x
	lbsr	_00001
	addd	,s++
	std	-444,u
* 			if (SOKOmap_L1[i] == iSTORAGE) {
	ldd	-444,u
	ldx	-8,u
	ldb	d,x
	clra
	subd	#$2
	lbne	_132
* 				updateMap(map, nextxPos, nextyPos, iSTO_BOX); // get back initial
	ldd	#$4
	pshs	d
	ldb	-449,u
	clra
	pshs	d
	ldb	-448,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 				// check if all boxes are stored
* 				i = 0;
	clra
	clrb
	std	-444,u
* 				while ((i < MAP_SIZE) && (map[i] != iBOX)) { i++;};
_134
	ldd	-444,u
	subd	#$1a4
	lbhs	_133
	ldd	-444,u
	leax	-428,u
	ldb	d,x
	clra
	subd	#$3
	lbeq	_133
	ldd	-444,u
	addd	#$1
	std	-444,u
	subd	#$1
	lbra	_134
_133
* 				if (i == MAP_SIZE) {
	ldd	-444,u
	subd	#$1a4
	lbne	_135
* 					sendString(6, 10, gameEnded);
	ldd	-6,u
	pshs	d
	ldd	#$a
	pshs	d
	ldd	#$6
	pshs	d
	lbsr	sendStri
	leas	6,s
* 					while(1); // stop here
_137
	lbra	_137
* 				}
_136
* 			}
_135
* 			else updateMap(map, nextxPos, nextyPos, iBOX);
	lbra	_138
_132
	ldd	#$3
	pshs	d
	ldb	-449,u
	clra
	pshs	d
	ldb	-448,u
	clra
	pshs	d
	leax	-428,u
	pshs	x
	lbsr	updateMa
	leas	8,s
* 			moveStr[0]++; pushStr[0]++; printScoreboard(moveStr, pushStr);
_138
	leax	-442,u
	ldb	,x
	inc	,x
	clra
	leax	-438,u
	ldb	,x
	inc	,x
	clra
	leax	-438,u
	pshs	x
	leax	-442,u
	pshs	x
	lbsr	printSco
	leas	4,s
* 			undo = true;			
	ldd	#$1
	stb	-434,u
* 			msDelay(PACE);	// execution sync			
	ldd	#$23
	pshs	d
	lbsr	msDelay
	leas	2,s
* 			break;
	lbra	_102
* 		}
* 	}
_129
_102
* }
	lbra	_49
_48
	leas	,u
	puls	u,pc
* 
_GLOBALS	equ	0
