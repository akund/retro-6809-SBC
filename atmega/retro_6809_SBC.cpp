/***************************************************************************************************/
/*                                                                                                 */
/* file:          retro_6809_SBC.ino                                                               */
/*                                                                                                 */
/* source:        2020, written by Adrian Kundert (adrian.kundert@gmail.com)                       */
/*                                                                                                 */
/* description:   Retro 6809 SBC application                                                       */
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

#include "config.h"
#include "APLcore.h"
#include "APLtile.h"
#ifdef ATMEL_STUDIO
	#include <avr/pgmspace.h>
	#include <avr/io.h>
	#include <avr/boot.h>
	#include <avr/interrupt.h>
#endif


#pragma GCC optimize ("-O3") // speed optimization gives more deterministic behavior

BOOTLOADER_SECTION void boot_program_page(unsigned long int page, unsigned char *buf); // declared as unrewritable section

const char SwVersion[] PROGMEM = "sw v1.2.0.0\r";

APLcore INSTANCE;
APLcore* pAPL = 0;

const uint8_t Container_Size = TileMemSize;

// programmable PGM tiles for custom rendering
const uint8_t PGM_Container_index_OFFSET = 0x80;
const uint8_t PGM_Container_COUNT = 32;
const unsigned char PGM_Container[PGM_Container_COUNT*Container_Size] __attribute__((aligned(SPM_PAGESIZE))) PROGMEM = {};

// programmable RAM tiles for custom rendering
const uint8_t RAM_Container_index_OFFSET = 0xE0;
const uint8_t RAM_Container_COUNT = 10;
uint8_t RAM_Container[RAM_Container_COUNT][Container_Size];

uint8_t  tileScroll, x, y, MAX_X, MAX_Y;
bool textMode;

// screen cursor state
#define CURSOR_BLINKING 'b'
#define CURSOR_ON       '1'
#define CURSOR_OFF      '0'

// keyboard data
#define KB_DATA 3
char kbStr[6];

// APL status
#define APL_RESET     '0'
#define APL_READY     '1'
#define APL_BUSY      '2'
#define APL_UNDEFINED '9'
#define APL_STATUS_BYTE 2
char statusStr[5];
unsigned long t;
    
/*
 * Protocol format
[Direction ][ body ][ end]
['D' or 'U' ]  [ body]  [ '\r' ]

Body [cmd] [len] [data ....]
video command(s)
  - Cursor blink/on/off -> 'c', ('b' or '1' or '0'), '\r'
  - Position xy         -> 'p', x+'0', y+'0', '\r'     
  - scRoll              -> 'r', n+'0', '\r'            
  - putFontchar         -> 'f', length, value0, value1, ... value_length-1, '\r'
  - cLearscreen         -> 'l', color+'0', '\r'
  - setTile             -> 't', length+'0', index0, index1, ... , index_length-1, '\r'	; PETSCII character set (index 0 to 0x7f) or programable tile (index >=0x80 for PGM, index >= 0xe0 for RAM)
  - containerData       -> 'd', length+'0', index, data0, data1, ... data_length-1, '\r'; programable 32 PGM tiles (index >=0x80) or 10 RAM tiles (index >= 0xe0) for video or sound.
  - piXelscrolling xy   -> 'x', x+'0', y+'0', '\r'										; Graphmode only. The x/y values are 0, 2, 4 or 6)
  
audio command(s)
  - tOne                -> 'o', tone, duration, '\r' (tone in f/4 Hz, duration in 1/10 Sec)
  - setSound            -> 's', index, '\r'												; activate the sound to the given data index

keyboard command(s)
  - Key pressed			->  'k', length, value(s) ....., '\r'

date and time commands
  - dAte                -> 'a', YY+'0, MM+'0, DD+'0, '\r'
  - tIme                -> 'i', HH+'0, MM+'0, SS+'0, '\r'
  - timestaMp			-> 'm', (7/4/5 bits, word for year-since-1980/month/day),		; Count of years from 1980 in range of from 0 to 127 (1980-2107), Month of year in range of from 1 to 12, Day of month in range of from 1 to 31.
							(5/6/5 bits, word for hour/minutes/doubleseconds), 			; Hours in range of from 0 to 23, Minutes in range from 0 to 59, 2 second count in range of form 0 to 29 (0-58 seconds).
						    '\r' 
  
APL status command(s)
  - stAtus				-> 'a', status (0:reset, 1:ready, 2:busy), '\r'
  
------------------------- Example -------------------------------------
To APL    ->  'D', cmd, len, data ..., '\r'
From APL  ->  'U', cmd, len, data ...  '\r'
-----------------------------------------------------------------------  
*/
#define ReceiveTimeOut 250

#pragma GCC push_options
#pragma GCC optimize ("O0") // avoid optimization to ensure volatile variable proprieties

bool waitReceived(uint8_t  cnt) {
	unsigned long t = pAPL->ms_elpased()+ReceiveTimeOut;
	uint8_t  receivedCnt;
	do {		
		receivedCnt = pAPL->UARTcountRX();
	} while ((receivedCnt < cnt) && (t > pAPL->ms_elpased()));
	return (receivedCnt >= cnt) ? true:false;
}

void updateRAM_Container(uint8_t* src, uint8_t* dst) {	// function to avoid gcc memcpy
	for (uint8_t  n = 0; n < Container_Size; n++) {   
		*dst++ = *src++;	// copy byte by byte to ensure atomic operation
	}
}
#pragma GCC pop_options

// draw the char on the screen (text mode only)
void printScreen(char c) {
    uint8_t  old_y = y;
    switch(c){
    case '\r':  	// carriage return 0x0d
         pAPL->setTileXYtext(x, y, ' '); // clear cursor
         x = 0; y++; //implicitly includes a LF
        break;
    case '\b':  	// backspace 0x08
        pAPL->setTileXYtext(x, y, ' '); // clear cursor
        if(x > 0) pAPL->setTileXYtext(--x, y, ' ');
        break;
    default:
        pAPL->setTileXYtext(x, y, c);  // overwrite cursor
        x++;
    }   
    
    // update the index
    if (x >= MAX_X) {x=0; y++;}
    if (y >= MAX_Y) {y=0; tileScroll=0;} // scrolling can begin

    // once the bottom reached, scroll when the line has changed
    if ((old_y != y) && (tileScroll != 0xff)) { 
        if (++tileScroll >= MAX_Y) tileScroll=0;
        pAPL->setTileScroll(tileScroll); // scroll y instead
        // delete the scrolled down line
        for (uint8_t  n = 0; n < MAX_X; n++) {    
            pAPL->setTileXYtext(n, y, ' ');
        }
    }
    pAPL->setCursorXY(x, y); // update the position
}

void sendTimeStamp() {
	
	pAPL->UARTwrite('U');
	pAPL->UARTwrite('m');
	unsigned int i = pAPL->GetDateF32();
	pAPL->UARTwrite(char(i >> 8));
	pAPL->UARTwrite(char(i & 0xff));
	i = pAPL->GetTimeF32();
	pAPL->UARTwrite(char(i >> 8));
	pAPL->UARTwrite(char(i & 0xff));
	pAPL->UARTwrite('\r');
}

int main() {
  
	tileScroll = 0xff;  // disabled value
	t = x = y = 0;
	kbStr[0]='U';     kbStr[1]='k';       kbStr[2]='1';   kbStr[KB_DATA]=' ';   kbStr[4]='\r';     kbStr[5]=0;
	statusStr[0]='U'; statusStr[1]='a';   statusStr[APL_STATUS_BYTE]=APL_RESET; statusStr[3]='\r'; statusStr[4]=0;
	pAPL = &INSTANCE; //APLcore::instance();  
	pAPL->coreInit();	// default initialization in text mode
	textMode = true;
	MAX_X = pAPL->getscrViewWidthInTile();
	MAX_Y = pAPL->getscrViewHeightInTile();
	pAPL->UARTsetBaudrate(57600); //baud rate for the APL UART
	pAPL->UARTwrite((PGM_P)SwVersion);
	
	// send first APL status after booting-up
	pAPL->UARTwrite(statusStr);
	statusStr[APL_STATUS_BYTE] = APL_READY;
	pAPL->UARTwrite(statusStr);

	while(1) {
		//-------------------------------------- INPUTS PROCESSING ------------------------------------------------//
		if (pAPL->UARTavailableRX() == true) {
			// read the next key  
			char c = pAPL->UARTread();
			//pAPL->UARTwrite(c);  

			// protocol handling  
			if (c == 'D') {
				// download msg found
				if (waitReceived(1) == true) {
					// get the command	
					switch (pAPL->UARTread()) {
					case 'c':   // cursor on screen state command
					{
						if (waitReceived(1) == false) break;
						uint8_t  sts = pAPL->UARTread(); // extract the status
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') { // get the CR
							//if((sts == CURSOR_BLINKING) || (sts == CURSOR_ON) || (sts == CURSOR_OFF)) cursorState = sts;
							pAPL->setCursor(x,y,(sts == CURSOR_BLINKING)?true:false);
							//pAPL->UARTwrite("cursor");
						}						
					}
					break;
					case 'f':   // print char on screen command
					{
						if (waitReceived(1) == false) break;
						uint8_t  len = pAPL->UARTread() - '0'; // extract the len
						if((len >= 1) && (len <= 16)) {
							char c[16];
							for (uint8_t  n = 0; n < len; n++) {   
								if (waitReceived(1) == false) break;
								c[n] = pAPL->UARTread(); // extract the char
							}
							if (waitReceived(1) == false) break;
							if(pAPL->UARTread() == '\r') {// get the CR              
								if (textMode != true) {
									textMode = true;
									pAPL->initScreenBuffer(TextMode);
									MAX_X = pAPL->getscrViewWidthInTile();
									MAX_Y = pAPL->getscrViewHeightInTile();
									tileScroll = 0xff;  // disabled value
									x = y = 0;
								}
								for (uint8_t  n = 0; n < len; n++) {
									printScreen(c[n]); 
								}
							}
						}						
					}
					break;
					case 't':   // print tile on screen command
					{
						if (waitReceived(1) == false) break;
						uint8_t  len = pAPL->UARTread() - '0'; // extract the len
						if((len >= 1) && (len <= TileMemSize)) {							
							uint8_t tmp_data[TileMemSize];
							for (uint8_t  n = 0; n < len; n++) {   
								if (waitReceived(1) == false) break;
								tmp_data[n] = pAPL->UARTread(); // extract the char
							}
							if (waitReceived(1) == false) break;
							if(pAPL->UARTread() == '\r') {// get the CR              
								if (textMode == true) {
									textMode = false; pAPL->initScreenBuffer(GraphMode);
									MAX_X = pAPL->getscrViewWidthInTile();
									MAX_Y = pAPL->getscrViewHeightInTile();
									pAPL->setTileScroll(0); tileScroll = 0xff; // tile scrolling back to 0 and disabled
									x = y = 0;
								}
								for (uint8_t  n = 0; n < len; n++) {
									uint8_t  tileIndex = tmp_data[n];
									if (tileIndex < PGM_Container_index_OFFSET) pAPL->setTileXY(x++, y, (uint8_t*)&PETtile4B[TileMemSize * tileIndex]);
									else {
										if (tileIndex < RAM_Container_index_OFFSET) {
											tileIndex -= PGM_Container_index_OFFSET;	// remove the offset
											if (tileIndex < PGM_Container_COUNT) pAPL->setTileXY(x++, y, (uint8_t*)&PGM_Container[TileMemSize * tileIndex]);											
										}									
										else {
											tileIndex -= RAM_Container_index_OFFSET;	// remove the offset
											if (tileIndex < RAM_Container_COUNT) pAPL->setRAMTileXY(x++, y, RAM_Container[tileIndex]);
										}
									}
									// update the index
									if (x >= MAX_X) {x=0; y++;}
									if (y >= MAX_Y) {y=0;}
								}
							}
						}						
					}
					break;
					case 'd':   // container data command
					{
						if (waitReceived(1) == false) break;
						uint8_t  len = pAPL->UARTread() - '0'; // extract the len					
						if (waitReceived(1) == false) break;						
						uint8_t tileIndex = pAPL->UARTread(); // extract the container index					
						if((len >= 1) && (len <= Container_Size)) {
							uint8_t tmp_data[TileMemSize];
							for (uint8_t n = 0; n < len; n++) {   
								if (waitReceived(1) == false) break;
								tmp_data[n] = pAPL->UARTread(); // extract the values								
							}
							if (waitReceived(1) == false) break;
							if(pAPL->UARTread() == '\r') {// get the CR              
								if (tileIndex >= PGM_Container_index_OFFSET) {
									if (tileIndex < RAM_Container_index_OFFSET) {
										tileIndex -= PGM_Container_index_OFFSET;
										if (tileIndex < PGM_Container_COUNT) {
											// write in PGM memory (slow)							
											uint8_t data[SPM_PAGESIZE];
											unsigned int offset = (unsigned int)Container_Size * (unsigned int)tileIndex;
											uint8_t* addr = (uint8_t*)PGM_Container + offset;										
											addr = (unsigned char*)((unsigned int)addr & 0xff80); // page base addr										
											for(uint8_t n=0; n < SPM_PAGESIZE; n++) { // Load a full data page current value
												data[n] = pgm_read_byte(addr++);
											}
											offset = offset & 0x7f;
											for(uint8_t n=0; n < Container_Size; n++) {
												data[offset++] = tmp_data[n];	// change wall tile value
											}																			
											boot_program_page((uint32_t)PGM_Container, data); // the flash write blocks the APL engine (approx 1 sec VGA screen off)									
										}
									}
									else {										
										tileIndex -= RAM_Container_index_OFFSET;
										if (tileIndex < RAM_Container_COUNT) updateRAM_Container(tmp_data, RAM_Container[tileIndex]);										
									}
								}
							}						
						}
					}
					break;
					case 'l':   // cLear screen command
					{
						if (waitReceived(1) == false) break;
						pAPL->UARTread() - '0'; // extract the color value
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') { // get the CR
							pAPL->initScreenBuffer();							
							x = y = 0;
							if(tileScroll != 0xff) {
								pAPL->setTileScroll(0); tileScroll = 0xff; // tile scrolling back to 0 and disabled
							}
							//pAPL->UARTwrite("cls");
						}
					}
					break;
					case 'p':   // position x,y command
					{
						if (waitReceived(1) == false) break;
						uint8_t  xPos = pAPL->UARTread(); // extract the x value
						if (waitReceived(1) == false) break;
						uint8_t  yPos = pAPL->UARTread(); // extract the y value						
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') { // get the CR
							if((xPos >= '0') && (xPos-'0' < MAX_X) && (yPos >= '0') && (yPos-'0' < MAX_Y)) {
								x = xPos-'0'; y = yPos-'0';
								if(tileScroll != 0xff) {
									y += tileScroll;	// consider the scrolling when enabled
									if (y >= MAX_Y) y -= MAX_Y;
								}
							}
						}						
					}
					break;
					case 'r':   // scRoll screen command
					{
						if (waitReceived(1) == false) break;
						uint8_t  nLine = pAPL->UARTread(); // extract the value
						if (waitReceived(1) == false) break;
						if((nLine >= '0') && (pAPL->UARTread() == '\r')) { // get the CR
							tileScroll = nLine - '0';
							pAPL->setTileScroll(tileScroll);  //TBD full height
							//pAPL->UARTwrite(nLine);						
						}
					}
					break;
					case 'o':   // tOne command
					{
						if (waitReceived(1) == false) break;
						uint8_t  pitch = pAPL->UARTread(); // extract the value
						if (waitReceived(1) == false) break;
						uint8_t  duration = pAPL->UARTread(); // extract the value
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') {
							while(pAPL->setTone(pitch, duration) == false);
						}
					}
					break; 
					case 's':   // Sound command
					{
						if (waitReceived(1) == false) break;
						uint8_t  index = pAPL->UARTread() - '0'; // extract the RAM container index
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') {// get the CR              
							if (index < RAM_Container_COUNT) {
								while(pAPL->setRAMSound(RAM_Container[index]) == false);                                
								//pAPL->UARTwrite("snd");                                
							}
						}
					}
					break;
					case 'x':   // pixel scrolling x,y command
					{
						if (waitReceived(1) == false) break;
						uint8_t  xPos = pAPL->UARTread(); // extract the x value
						if (waitReceived(1) == false) break;
						uint8_t  yPos = pAPL->UARTread(); // extract the y value
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') { // get the CR
							if((xPos >= '0') && (xPos-'0' < TileMemHeight) && (yPos >= '0') && (yPos-'0' < TileMemHeight)) {
								pAPL->setXScroll((xPos-'0') & 0b110);  // only even values
								pAPL->setYScroll(yPos-'0');
							}
						}
					}
					break;
					case 'a':   // date command
					{
						if (waitReceived(1) == false) break;
						uint8_t yy = pAPL->UARTread() - '0'; // extract the year value
						if (waitReceived(1) == false) break;
						uint8_t mm = pAPL->UARTread() - '0'; // extract the month value
						if (waitReceived(1) == false) break;
						uint8_t dd = pAPL->UARTread() - '0'; // extract the day value
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') {		 // get the CR
							if((mm != 0) && (dd != 0)) pAPL->setDate(yy, mm, dd);  // validate (only month and day cannot be 0) because a setdate all zero values is to trigger the timestamp without changes.
							sendTimeStamp(); // send back the timestamp as confirmation
							//pAPL->UARTwrite("date");
						}
					}
					break;
					case 'i':   // time command
					{
						if (waitReceived(1) == false) break;
						uint8_t hh = pAPL->UARTread() - '0'; // extract the hour value
						if (waitReceived(1) == false) break;
						uint8_t mm = pAPL->UARTread() - '0'; // extract the minute value
						if (waitReceived(1) == false) break;
						uint8_t ss = pAPL->UARTread() - '0'; // extract the second value
						if (waitReceived(1) == false) break;
						if(pAPL->UARTread() == '\r') {		 // get the CR
							pAPL->setTime(hh, mm, ss);
							sendTimeStamp(); // send back the timestamp as confirmation
							//pAPL->UARTwrite("time");
						}
					}
					default: break;
					}
				}
			}
		}

		//-------------------------------------- OUTPUTS PROCESSING ------------------------------------------------//
		// keyboard handling
		if (pAPL->keyPressed() == true) {        
			kbStr[KB_DATA] = pAPL->keyRead();
			pAPL->UARTwrite(kbStr);
		}
	  
		// status (heart beat)  
		{
			unsigned long t_now = pAPL->ms_elpased();    
			if(t < t_now) {
				statusStr[APL_STATUS_BYTE] = APL_READY; //sts;
				pAPL->UARTwrite(statusStr);
				t = t_now + 1000; // default 1000 ms periodic refresh
			}
		}
	}
}

#pragma GCC push_options
#pragma GCC optimize ("O0")		// otherwise the bootloader section is removed

// avr/boot.h documentation example
BOOTLOADER_SECTION void boot_program_page(uint32_t page, uint8_t *buf)
{
	uint16_t i;
	uint8_t sreg;
				
	// Disable interrupts.
	sreg = SREG;
	cli();
	bool b = (PORTC & 0x08) ? true:false; // wait until CTS_n cleared by APL ISR
	if(b == false) PORTC |= 0x08;  // CTS_n set	
	
	eeprom_busy_wait ();
	boot_page_erase (page);
	boot_spm_busy_wait (); // Wait until the memory is erased.
	for (i=0; i<SPM_PAGESIZE; i+=2)
	{
		// Set up little-endian word.
		uint16_t w = *buf++;
		w += (*buf++) << 8;
		boot_page_fill (page + i, w);
	}
	boot_page_write (page); // Store buffer in flash page.
	boot_spm_busy_wait(); // Wait until the memory is written.
	// Reenable RWW-section again. We need this if we want to jump back
	// to the application after bootloading.
	boot_rww_enable ();
	if(b == false) PORTC &= 0xf7;  // CTS_n cleared
	sei();
	// Re-enable interrupts (if they were ever enabled).
	SREG = sreg;
}
// -- LSS file (assembled code)----------------------------------------------------
//  Idx Name          Size      VMA       LMA       File off  Algn
//  1 .bootloader   00000196  00007c00  00007c00  00004d0a  2**0
// --------------------------------------------------------------------------------
// is less than the 512 bytes bootloader space
#pragma GCC pop_options
