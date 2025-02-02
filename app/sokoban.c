/***************************************************************************************************/
/*                                                                                                 */
/* file:          main.c			                                                               */
/*                                                                                                 */
/* source:        2021-2025, written by Adrian Kundert (adrian.kundert@gmail.com)                  */
/*                                                                                                 */
/* description:   Sokoban game (C application for micro-c compiler)                                */
/*                                                                                                 */
/* This library is free software; you can redistribute it and/or modify it under the terms of the  */
/* GNU Lesser General Public License as published by the Free Software Foundation;                 */
/* either version 2.1 of the License, or (at your option) any later version.                       */
/*                                                                                                 */
/* This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;       */
/* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.       */
/* See the GNU Lesser General Public License for more details.                                     */
/*                                                                                                 */
/***************************************************************************************************/

// ! Micro-C variable max 14 characters, only the first 8 characters are considered
#define true 			1
#define false 			0

#define TileMemSize 	32
#define RAMcontCnt 		10
#define RAMtileoffset   0xE0

// APL PS2 keyboard
#define UPARROW			0x5e
#define LEFTARROW		0x09
#define DOWNARROW		0x12
#define RIGHTARROW		0x11

#define SCREEN_ROW		20
#define SCREEN_COL		21
#define MAP_SIZE		420 //SCREEN_ROW * SCREEN_COL

#define iEMPTY		0
#define iWALL		1
#define iSTORAGE	2
#define iBOX		3
#define iSTO_BOX	4
#define iMAN_STD	5
#define iPU1		6
#define iPU2_MAN	7
#define iPU2_MHB	8
#define iPU2_HB		9

#define offset_D  5

#define iSOUND 		5 // re-use iMAN_STD

#define PACE		35
 
updateRAMTile(heading, tileIndex) unsigned char heading; unsigned char tileIndex;
{
	unsigned char value;	
	unsigned char RAM_Container_tmp[TileMemSize];
	unsigned char n;
	unsigned char* SOKOtile;
	SOKOtile = {
	
	// EMPTY
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,

	// WALL,
	0x14, 0xB4, 0x14, 0xB4,
	0x14, 0xB4, 0x14, 0xB4,
	0x0, 0x0, 0x0, 0x0,
	0xB4, 0xA0, 0xB4, 0xA0,
	0xB4, 0xA0, 0xB4, 0xA0,
	0x0, 0x0, 0x0, 0x0,
	0x14, 0xB4, 0x14, 0xB4,
	0x14, 0xB4, 0x14, 0xB4,

	// STORAGE
	0x6C, 0x60, 0xC, 0x6C,
	0x6C, 0xC, 0x60, 0x6C,
	0x60, 0x6C, 0x6C, 0xC,
	0xC, 0x6C, 0x6C, 0x60,
	0xC, 0x6C, 0x6C, 0x60,
	0x60, 0x6C, 0x6C, 0xC,
	0x6C, 0xC, 0x60, 0x6C,
	0x6C, 0x60, 0xC, 0x6C,

	// BOX
	0x0, 0x0, 0x0, 0x0,
	0x18, 0xD8, 0xD8, 0xC0,
	0x18, 0xD8, 0xD8, 0xC0,
	0x18, 0xD8, 0xD8, 0xC0,
	0x18, 0xD8, 0xD8, 0xC0,
	0x18, 0xD8, 0xD8, 0xC0,
	0x18, 0xD8, 0xD8, 0xC0,
	0x0, 0x0, 0x0, 0x0,

	// STORED_BOX
	0xFC, 0xFC, 0xFC, 0xFC,
	0xF8, 0xD8, 0xD8, 0xDC,
	0xF8, 0xD8, 0xD8, 0xDC,
	0xF8, 0xD8, 0xD8, 0xDC,
	0xF8, 0xD8, 0xD8, 0xDC,
	0xF8, 0xD8, 0xD8, 0xDC,
	0xF8, 0xD8, 0xD8, 0xDC,
	0xFC, 0xFC, 0xFC, 0xFC,

	// MAN_STANDING_RIGHT
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0xCC, 0x6C,
	0x6C, 0x74, 0xAC, 0x6C,
	0x6C, 0x70, 0x8C, 0x6C,
	0x6C, 0x70, 0x90, 0x6C,
	0x6C, 0x70, 0x8C, 0x6C,
	0x6C, 0x74, 0xAC, 0x6C,
	0x6C, 0x6C, 0xCC, 0x6C,

	// PUSHINGtwo_RIGHT
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x74, 0xB8,
	0x6C, 0x6C, 0x74, 0x6C,
	0x6C, 0x60, 0xB0, 0x8C,
	0x6C, 0x6C, 0xB0, 0x90,
	0x6C, 0x6C, 0xB0, 0x80,
	0x6C, 0x6C, 0x74, 0x6C,
	0x6C, 0x6C, 0x74, 0xB8,

	// PUSHINGtwo_MAN_ONLY_RIGHT
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0xB4, 0xCC, 0x6C,
	0x6C, 0xAC, 0x6C, 0x6C,
	0x74, 0x90, 0x0C, 0x6C,
	0x74, 0x90, 0x8C, 0x6C,
	0x14, 0x90, 0x6C, 0x6C,
	0x6C, 0xAC, 0x6C, 0x6C,
	0x6C, 0xB4, 0xCC, 0x6C,

	// PUSHINGtwo_MAN_BOX_RIGHT
	0x6C, 0x6C, 0x60, 0x0, 	// pushing half box
	0x6C, 0xB4, 0xC0, 0xD8,
	0x6C, 0xAC, 0x60, 0xD8,
	0x74, 0x90, 0x00, 0xD8,
	0x74, 0x90, 0x80, 0xD8,
	0x14, 0x90, 0x60, 0xD8,
	0x6C, 0xAC, 0x60, 0xD8,
	0x6C, 0xB4, 0xC0, 0x0,

	// PUSHINGtwo_HALF_BOX_RIGHT
	0x00, 0x00, 0xC, 0x6C,	// next tile second half box
	0xD8, 0xD8, 0xC, 0x6C,
	0xD8, 0xD8, 0xC, 0x6C,
	0xD8, 0xD8, 0xC, 0x6C,
	0xD8, 0xD8, 0xC, 0x6C,
	0xD8, 0xD8, 0xC, 0x6C,
	0xD8, 0xD8, 0xC, 0x6C,
	0x00, 0x00, 0xC, 0x6C,

	//-------- rotated ----------//
	// iMAN_STANDING_Down
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0xB0, 0x90, 0xAC,
	0x78, 0xB0, 0x90, 0xB8,
	0x6C, 0x6C, 0x8C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,
	0x6C, 0x6C, 0x6C, 0x6C,

	// iPUSHINGone_Down
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x60, 0x6C, 0x6C,
    0x6C, 0x74, 0xB4, 0x6C,
    0x74, 0xB0, 0x90, 0xB4,
    0x74, 0x70, 0x90, 0x74,
    0x78, 0x6C, 0x80, 0x78,
	
	// iPUSHINGtwo_MAN_ONLY_Down
    0x6C, 0x6C, 0x60, 0x6C,
    0x6C, 0x74, 0xB4, 0x6C,
    0x74, 0xB0, 0x90, 0xB4,
    0x74, 0x70, 0x90, 0x74,
    0x78, 0x60, 0x8C, 0x78,
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x6C, 0x6C, 0x6C,
	
	// iPUSHINGtwo_MAN_BOX_Down
    0x6C, 0x6C, 0x60, 0x6C,
    0x6C, 0x74, 0xB4, 0x6C,
    0x74, 0xB0, 0x90, 0xB4,
    0x74, 0x70, 0x90, 0x74,
    0x78, 0x60, 0x8C, 0x78,
    0x00, 0x00, 0x00, 0x00,
    0x18, 0xD8, 0xD8, 0xC0,
    0x18, 0xD8, 0xD8, 0xC0,
	
	// iPUSHINGtwo_HALF_BOX_Down
    0x18, 0xD8, 0xD8, 0xC0,
    0x18, 0xD8, 0xD8, 0xC0,
    0x18, 0xD8, 0xD8, 0xC0,
    0x18, 0xD8, 0xD8, 0xC0,
    0x00, 0x00, 0x00, 0x00,
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x6C, 0x6C, 0x6C,
    0x6C, 0x6C, 0x6C, 0x6C
	};  //  end of tile
		
	for (n = 0; n < TileMemSize; n++) {			
		if ((heading == RIGHTARROW) || (heading == LEFTARROW) || (tileIndex <= iSTO_BOX)) {			
			// default tile (right heading)
				value = SOKOtile[TileMemSize * tileIndex + n];
			if ((heading == LEFTARROW) && (tileIndex > iSTO_BOX)) {
				// invert the tile
				value = ((value << 3) & 0xe0) | ((value >> 3) & 0x1c); // swap RBGRGB00
				RAM_Container_tmp[TileMemSize-1 - n] = value;
			}
			else
				RAM_Container_tmp[n] = value;				
		}
		else {
			// 90° rotated tile (down heading)
				value = SOKOtile[TileMemSize * (tileIndex + offset_D) + n];
			if (heading == UPARROW) {
				// invert the tile
				value = ((value << 3) & 0xe0) | ((value >> 3) & 0x1c); // swap RBGRGB00
				RAM_Container_tmp[TileMemSize-1 - n] = value;
			}
			else
				RAM_Container_tmp[n] = value;
		}			
	}
	sendContainerData(tileIndex + RAMtileoffset -'0', RAM_Container_tmp);  //tmp hack
}

sendstepSound() {
		
	// re-use the standing data container for the sound
	unsigned char* step_sound;
	step_sound = {1, 200, 0};
	sendContainerData(iSOUND + RAMtileoffset - '0', step_sound);	//tmp hack
}

updateMap(pMap, x, y, tileIndex) unsigned char* pMap; unsigned char x; unsigned char y; unsigned char tileIndex;
{
	
	pMap[y*SCREEN_COL + x] = tileIndex;						// internal map
	
	setpointXY(x, y); setTile(tileIndex + RAMtileoffset);  // displayed map
}

getMapTileIndex(pMap, x, y) unsigned char* pMap; unsigned char x; unsigned char y;
{	
	return pMap[y*SCREEN_COL + x];
}

sendString(x, y, str) unsigned char x; unsigned char y; char* str;
{
	unsigned char n,c;
	n = 0;
	setpointXY(x, y); 
	while(1) {
		c = str[n];
		if (c == 0) break;
		if (c >= 'A') c -= '@';	// re-mapping ASCII to PETSCII
		setTile(c);
		n++;
	}
}

#define stringSize 	4
printScoreboard(moveStr, pushStr) unsigned char* moveStr; unsigned char* pushStr;
{
	unsigned char n;
	for (n = 0; n < stringSize-1; n++) {
		if (moveStr[n] > '9') {
			moveStr[n] = '0';
			moveStr[n+1]++;
		}
	}	
	for (n = 0; n < stringSize; n++) {
		setpointXY(n+5, 19); setTile(moveStr[stringSize-1-n]);		
	}


	for (n = 0; n < stringSize-1; n++) {
		if (pushStr[n] > '9') {
			pushStr[n] = '0';
			pushStr[n+1]++;
		}
	}
	for (n = 0; n < stringSize; n++) {
		setpointXY(n+15, 19); setTile(pushStr[stringSize-1-n]);		
	}	
}		

/***********************************************************************************************/
/*	main program
/***********************************************************************************************/

// states definition
#define standing 	0
#define push1 		1
#define push2_empty 2
#define push2_box 	3
main() {
	char* gameLevel;					//-2,u
	char* scoreBoard;					//-4,u
	char* gameEnded;					//-6,u
	unsigned char* SOKOmap_L1;			//-8,u
	unsigned char map[MAP_SIZE]; 		//-428,u
	unsigned char state;				//-429,u
	unsigned char xPos, yPos, heading;	//-430,u ...
	unsigned char key;					//-433,u
	unsigned char undo;					//-434,u
	unsigned char pushStr[stringSize]; 	//-435,u
	unsigned char moveStr[stringSize]; 	//-436,u
	
	// inner loops variables
	unsigned int i;						//-438,u
	unsigned char y, x;					//-439,u ...
	unsigned char tile;					//-441,u
	unsigned char nextxPos, nextyPos, next2xPos, next2yPos;		//u,-442,u   ....
	unsigned char nextTile, next2Tile;	//-446,u   -447,u
	
	gameLevel  = "LEVEL 01             ";
	scoreBoard = "MOVE:0000 PUSH:0000  ";
	gameEnded = "WELL DONE!";
	state = standing;
	undo = false;	

	key = 0;
	xPos=12; yPos=11; heading = RIGHTARROW;
		
	// map (width 21, height 20) populated with tile indexes
	SOKOmap_L1 = {
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x3, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x3, 0x0, 0x3, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0,
	0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x2, 0x2, 0x1, 0x0,
	0x0, 0x1, 0x0, 0x3, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2, 0x2, 0x1, 0x0,
	0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x0, 0x2, 0x2, 0x1, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	};  //  end of map
	
	// init the RAM Tiles
	for (x = 0; x < RAMcontCnt; x++) {
		updateRAMTile(heading, x);
	}

	// init the screen with the ROM map
	for (y=0; y<SCREEN_ROW; y++) {
		for (x=0; x<SCREEN_COL; x++) {
			i = y*SCREEN_COL + x;
			updateMap(map, x, y, SOKOmap_L1[i]);
		}
	}
	
	// add the man
	updateMap(map, xPos, yPos, iMAN_STD);
		
	// init score board
	sendString(0, 0, gameLevel);
	sendString(0, 19, scoreBoard);
	for (x = 0; x < stringSize; x++) {
		pushStr[x] = moveStr[x] = '0';
	}
	printScoreboard(moveStr, pushStr);
	
	while(1) {			
		// keyboard handling		
		APL_OutputStream();
		if((key == 0) && (isKeyboardData() != 0)){
			key = getKeyboard();
			
			if ((state != standing) && (key != heading)) key = 0; // don't allow other directions when still in move
			
			// undo command
			if(((key == 'u') || (key == 'U')) && (undo == true)) {
				i=0;
				tile=0;
				switch(heading) {
					case LEFTARROW :
						updateMap(map, xPos+1, yPos, getMapTileIndex(map, xPos, yPos)); // move man						
						tile = getMapTileIndex(map, xPos-1, yPos); // move box						
						if ((tile == iBOX) || (tile == iSTO_BOX)) {
							i = yPos*SCREEN_COL + (xPos);
							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
							else tile = iBOX;
						}
						updateMap(map, xPos, yPos, tile);
						i = yPos*SCREEN_COL + (xPos-1);
						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos-1, yPos, iSTORAGE); // get back initial
						else updateMap(map, xPos-1, yPos, iEMPTY);
						xPos++;		
						break;					
					case RIGHTARROW :
						updateMap(map, xPos-1, yPos, getMapTileIndex(map, xPos, yPos)); // move man
						tile = getMapTileIndex(map, xPos+1, yPos); // move box
						if ((tile == iBOX) || (tile == iSTO_BOX)) {
							i = yPos*SCREEN_COL + (xPos);
							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
							else tile = iBOX;
						}						
						updateMap(map, xPos, yPos, tile);
						i = yPos*SCREEN_COL + (xPos+1);
						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos+1, yPos, iSTORAGE); // get back initial
						else updateMap(map, xPos+1, yPos, iEMPTY);
						xPos--;
						break;
					case UPARROW :
						updateMap(map, xPos, yPos+1, getMapTileIndex(map, xPos, yPos)); // move man
						tile = getMapTileIndex(map, xPos, yPos-1); // move box
						if ((tile == iBOX) || (tile == iSTO_BOX)) {
							i = yPos*SCREEN_COL + (xPos);
							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
							else tile = iBOX;
						}
						updateMap(map, xPos, yPos, tile);						
						i = (yPos-1)*SCREEN_COL + xPos;
						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos-1, iSTORAGE); // get back initial
						else updateMap(map, xPos, yPos-1, iEMPTY);
						yPos++;
						break;
					break;
					case DOWNARROW :
						updateMap(map, xPos, yPos-1, getMapTileIndex(map, xPos, yPos)); // move man
						tile = getMapTileIndex(map, xPos, yPos+1); // move box
						if ((tile == iBOX) || (tile == iSTO_BOX)) {
							i = yPos*SCREEN_COL + (xPos);
							if (SOKOmap_L1[i] == iSTORAGE) tile = iSTO_BOX;
							else tile = iBOX;
						}
						updateMap(map, xPos, yPos, tile);
						i = (yPos+1)*SCREEN_COL + xPos;
						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos+1, iSTORAGE); // get back initial
						else updateMap(map, xPos, yPos+1, iEMPTY);
						yPos--;
						break;
				}
				undo = false;
			}
			
			if((key != LEFTARROW) && (key != UPARROW) && (key != DOWNARROW) && (key != RIGHTARROW)) key = 0;
			else {
				if (key != heading) { // change direction when push completed
					heading = key;	// new direction
					for (x = 0; x < RAMcontCnt; x++) {
						updateRAMTile(heading, x);
					}
				}
			}
		}		
		
		nextxPos = nextyPos = next2xPos = next2yPos = 0;
		switch(heading) {
		case LEFTARROW : 
			nextxPos = xPos-1; nextyPos = yPos;
			next2xPos = xPos-2; next2yPos = yPos;
			break;
		case RIGHTARROW :
			nextxPos = xPos+1; nextyPos = yPos;
			next2xPos = xPos+2; next2yPos = yPos;
			break;
		case UPARROW :
			nextxPos = xPos; nextyPos = yPos-1;
			next2xPos = xPos; next2yPos = yPos-2;
			break;
		case DOWNARROW :
			nextxPos = xPos; nextyPos = yPos+1;
			next2xPos = xPos; next2yPos = yPos+2;
			break;
		}

		switch(state) {
		case standing:
			{
				nextTile = getMapTileIndex(map, nextxPos, nextyPos);
				next2Tile = getMapTileIndex(map, next2xPos, next2yPos);
				if ((key != 0) && ((nextTile == iEMPTY) || (nextTile == iSTORAGE) || (((nextTile == iBOX) || (nextTile == iSTO_BOX)) && ((next2Tile == iSTORAGE) || (next2Tile == iEMPTY)))) ) {
					state = push1;		// begin to move				
					updateMap(map, xPos, yPos, iPU1);
					sendstepSound();	// update the data container
					msDelay(PACE);	// execution sync
				}
				else key = 0;
			}			
			break;
		case push1:
			{
				nextTile = getMapTileIndex(map, nextxPos, nextyPos);
				if(nextTile == iWALL) {
					state = standing;					// stop pushing
					updateRAMTile(heading, iMAN_STD);	// data container back to standing
					updateMap(map, xPos, yPos, iMAN_STD);
				}			
				if((nextTile == iBOX) || (nextTile == iSTO_BOX)) {
					next2Tile = getMapTileIndex(map, next2xPos, next2yPos);
					if((next2Tile == iEMPTY) || (next2Tile == iSTORAGE)) {
						state = push2_box;	// push the box
						setSound(iSOUND);
						i = yPos*SCREEN_COL + xPos;
						if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos, iSTORAGE); // get back initial
						else updateMap(map, xPos, yPos, iEMPTY);						
						xPos = nextxPos; yPos = nextyPos; // move to next field with half box
						updateMap(map, xPos, yPos, iPU2_MHB);
						updateMap(map, next2xPos, next2yPos, iPU2_HB);	// second half box at next field					
					}
					else {
						state = standing;					// cannot push anymore
						updateRAMTile(heading, iMAN_STD);	// data container back to standing
						updateMap(map, xPos, yPos, iMAN_STD);
					}
				}
				if((nextTile == iEMPTY) || (nextTile == iSTORAGE)) {
					state = push2_empty;	// push the box
					setSound(iSOUND);
					i = yPos*SCREEN_COL + xPos;
					if (SOKOmap_L1[i] == iSTORAGE) updateMap(map, xPos, yPos, iSTORAGE); // get back initial
					else updateMap(map, xPos, yPos, iEMPTY);
					xPos = nextxPos; yPos = nextyPos; // move to next field
					updateMap(map, xPos, yPos, iPU2_MAN);				
				}				
				key = 0;	// move lock end				
				msDelay(PACE);	// execution sync
				break;
			}
		case push2_empty:
			if (key != 0) {
				state = push1;	// prepare to move to the next field
				updateMap(map, xPos, yPos, iPU1);				
			}
			else {
				state = standing;	// stop moving
				updateRAMTile(heading, iMAN_STD);	// data container back to standing
				updateMap(map, xPos, yPos, iMAN_STD);
			}
			moveStr[0]++; printScoreboard(moveStr, pushStr);
			undo = false;
			msDelay(PACE);	// execution sync			
			break;
		case push2_box:
			if (key != 0) {
				state = push1;	// keep pushing box through next field
				updateMap(map, xPos, yPos, iPU1);
			}
			else {
				updateRAMTile(heading, iMAN_STD);	// data container back to standing
				state = standing;
				updateMap(map, xPos, yPos, iMAN_STD);
			}
			i = nextyPos*SCREEN_COL + nextxPos;
			if (SOKOmap_L1[i] == iSTORAGE) {
				updateMap(map, nextxPos, nextyPos, iSTO_BOX); // get back initial
				// check if all boxes are stored
				i = 0;
				while ((i < MAP_SIZE) && (map[i] != iBOX)) { i++;};
				if (i == MAP_SIZE) {
					sendString(6, 10, gameEnded);
					while(1); // stop here
				}
			}
			else updateMap(map, nextxPos, nextyPos, iBOX);
			moveStr[0]++; pushStr[0]++; printScoreboard(moveStr, pushStr);
			undo = true;			
			msDelay(PACE);	// execution sync			
			break;
		}
	}
}

// LF CR to end the file