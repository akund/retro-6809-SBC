* micro-C(ver 0.4.1), 1981-1987 Masataka Ohta, Hiroshi Tezuka.
* #define C_MaxPageSize_U16        512
* #include "../disk/stdutils.h"
* /***************************************************************************************************/
* /*                                                                                                 */
* /* file:          stdutils.h		                                                               */
* /*                                                                                                 */
* /* source:        2023, written by Adrian Kundert (adrian.kundert@gmail.com)                       */
* /*                                                                                                 */
* /* description:   read and write data from SD CARD (C application for micro-c compiler)            */
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
* /**----------char 8-bit--------
*      char (-128 to 127)
*      signed char (-128 to 127)
*      unsigned char (0 - 255)
* 	-----------------------------*/
* 
* /**---------int 16-bit----------
* 	 int (-32768 to 32767)
* 	 signed int (-32768 to 32767)
*      unsigned int (0 to 65535)
* 	 -----------------------------*/
* 
* /***************************************************************************************************/
* 
* 
* /***************************************************************************************************
*                            Port Direction configurations
*  ***************************************************************************************************/
* #define LOW                0x00
* #define HIGH               0x01
* /**************************************************************************************************/
* 
* /***************************************************************************************************
* ***************************************************************************************************
*                               Commonly used constants
* **************************************************************************************************/
* #define FALSE              0x00
* #define TRUE               0x01
* 
* /**************************************************************************************************
* 			32-bit variable and operation wrapper for 16-bit architecture (big-endian)
* ***************************************************************************************************/
* typedef struct _u32_t {
* 	unsigned int h;
* 	unsigned int l;
* }u32_t;
* 
* 
* /*
* void _u32_and(u32_t *a, u32_t *b, u32_t *out);
* void _u32_div2(u32_t *a, unsigned int b, u32_t *quot);
* void _u32_mul(unsigned int a, u32_t *b, u32_t *prod);
* void _u32_sub(u32_t *a, u32_t *b, u32_t *dif);
* void _u32_dec(u32_t *a);
* void _u32_add(u32_t *a, u32_t *b, u32_t *sum);
* void _u32_inc(u32_t *a);
* unsigned char _u32_lower(u32_t *a, u32_t *b);
* unsigned char _u32_equal(u32_t *a, u32_t *b);
* unsigned char _u32_higher(u32_t *a, u32_t *b); 
* */
* 
* /**************************************************************************************************/
* 
* 
* 
* 
* 
* 
* #include "../disk/fat32.h"
* /***************************************************************************************************/
* /*                                                                                                 */
* /* file:          fat32.h			                                                               */
* /*                                                                                                 */
* /* source:        2023, written by Adrian Kundert (adrian.kundert@gmail.com)                       */
* /*                                                                                                 */
* /* description:   read and write data from SD CARD (C application for micro-c compiler)            */
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
* #define C_8_3_FileNameSize    11	//Root Directory Entry Format (SFN) gives 11 bytes
* 
* //Structure to access Master Boot Record for getting info about partitions (Little Endian)
* typedef struct {
*     unsigned char	nothing[446];		//ignore, placed here to fill the gap in the structure
*     unsigned char	partitionData[64];	//partition records (16x4)
*     unsigned char	signature[2];		//0xaa55
* } LE_MBRinfo_Structure;
* 
* 
* 
* //Structure to access boot sector data (Little Endian)
* typedef struct {
*     unsigned char jumpBoot[3];			//00, default: 0x009000EB
*     unsigned char OEMName[8];			//03,
*     unsigned char bytesPerSector[2];	//11, default: 512
*     unsigned char secPrCluster; 		//13, "sectorPerCluster"
*     unsigned char rsvSectorCount[2];	//14, "reservedSectorCount[2]"
*     unsigned char nbofFATs;				//16, "numberofFATs"
*     unsigned char rootEntryCount[2];	//17,
*     unsigned char tSec_F16[2];			//19, "totalSectors_F16[2]" must be 0 for FAT32
*     unsigned char mediaType;			//21,
*     unsigned char FATsz_F16[2];			//22, "FATsize_F16[2]" must be 0 for FAT32
*     unsigned char sectorsPerTrack[2];	//24,
*     unsigned char nbofHeads[2];			//26, "numberofHeads[2]"
*     unsigned char hiddenSectors[4];		//28, 
*     unsigned char tSec_F32[4];			//32, "totalSectors_F32[4]"
*     unsigned char FATsz_F32[4];			//36, "unsigned char FATsize_F32[4]" count of sectors occupied by one FAT
*     unsigned char extFlags[2];
*     unsigned char FSversion[2]; //0x0000 (defines version 0.0)
*     unsigned char rootCluster[4]; //first cluster of root directory (=2)
*     unsigned char FSinfo[2]; //sector number of FSinfo structure (=1)
*     unsigned char BackupBootSector[2];
*     unsigned char rsved[12];//    unsigned char reserved[12];
*     unsigned char driveNumber;
*     unsigned char rsved1;//    unsigned char reserved1;
*     unsigned char bootSignature;
*     unsigned char volumeID[4];
*     unsigned char volumeLabel[11]; //"NO NAME "
*     unsigned char fileSystemType[8]; //"FAT32"
*     unsigned char bootData[420];
*     unsigned char bootEndSignature[2]; //0xaa55
* }LE_BS_Structure;
* 
* 
* //Structure to access FSinfo sector data (Little Endian)
* typedef struct {
*     unsigned char leadSignature[4]; //0x41615252
*     unsigned char rsved3[480];  //    unsigned char reserved1[480];
*     unsigned char structureSignature[4]; //0x61417272
*     unsigned char freeClusterCount[4]; //initial: 0xffffffff
*     unsigned char nextFreeCluster[4]; //initial: 0xffffffff
*     unsigned char rsved4[12];  //    unsigned char reserved2[12];
*     unsigned char trailSignature[4]; //0xaa550000
* }LE_FSinfo_Structure;
* 
* //Structure to access Directory Entry in the FAT (Little Endian)
* typedef struct{
*     unsigned char name[C_8_3_FileNameSize];
*     unsigned char attrib; //file attributes
*     unsigned char NTreserved; //always 0
*     unsigned char timeTenth; //tenths of seconds, set to 0 here
*     unsigned char createTime[2]; //time file was created
*     unsigned char createDate[2]; //date file was created
*     unsigned char lastAccessDate[2];
*     unsigned char fClsterHI[2]; //higher word of the first cluster number      unsigned int firstClusterHI;
*     unsigned char writeTime[2]; //time of last write
*     unsigned char writeDate[2]; //date of last write
*     unsigned char fClsterLO[2]; //lower word of the first cluster number      unsigned int firstClusterLO;
*     unsigned char fSize[4]; //size of file in bytes							  u32_t fileSize;
* }LE_dir_Structure;
* 
* 
* 
* 
* 
* 
* 
* //Attribute definitions for file/directory
* #define ATTR_READ_ONLY     0x01
* #define ATTR_HIDDEN        0x02
* #define ATTR_SYSTEM        0x04
* #define ATTR_VOLUME_ID     0x08
* #define ATTR_DIRECTORY     0x10
* #define ATTR_ARCHIVE       0x20
* #define ATTR_LONG_NAME     0x0f
* 
* 
* #define END_OF_CLUSTERS    0x0fffffff
* #define DIR_ENTRY_SIZE     0x32
* #define EMPTY              0x00
* #define DELETED            0xe5
* #define GET     0
* #define SET     1
* 
* #define READ	0
* #define VERIFY  1
* #define WRITE   2
* #define APPEND  3
* 
* #define ADD		0
* #define REMOVE	1
* 
* #define TOTAL_FREE   1
* #define NEXT_FREE    2
* 
* #define GET_LIST     0
* #define GET_FILE     1
* #define DELETE		 2
* 
* #define EOF     26
* 
* #define FOPEN_SUCCESSFUL                   0 //FAT32_FILE_OPEN_SUCCESSFUL
* #define FDELETED_OR_NOT_FOUND              1 //FAT32_FILE_DELETED_OR_NOT_FOUND
* #define FALREADY_EXISTS                    2 //FAT32_FILE_ALREADY_EXISTS
* #define VALID_FILE_NAME                    3
* #define INVALID_FILE_NAME                  4
* #define NO_FREE_CLUSTERS_FOUND             5
* #define FILE_OPENED_CANNOT_BE_DELETED      6
* #define TO_MANY_FILES_OPENED               7
* #define MORE_FILES_To_READ                 8
* #define END_OF_FILE_LIST                   9
* 
* #define CONTINUE_LOOP                   0x55
* 
* #define C_MaxFileNameSize     13 //(C_8_3_FileNameSize+2)	//8.3 format (SFN + '.') + NULL gives 13 bytes
* 
* 
* typedef struct
* {
*     u32_t firstSector;
*     u32_t cluster;
*     u32_t prevCluster;
*     u32_t appFSector;
*     unsigned int appFLocation;
*     u32_t fileSize;
*     u32_t byteCounter;
*     u32_t blockNumber_u32;
*     u32_t appendStartCluster;
*     unsigned int sectorIndex;
*     unsigned int bufferIndex_u16;
*     //unsigned int fClstrHigh;
*     //unsigned int fClstrLow;
*     unsigned char LE_fileBuffer[C_MaxPageSize_U16];
*     unsigned char fileOperation_u8;
*     unsigned char fileOpenedFlag;
*     unsigned char fileCreatedFlag;
*     unsigned char appendFileFlag;
*     unsigned char sectorEndFlag;
*     unsigned char endOfFileDetected;
*     char fName[C_MaxFileNameSize];
* }fileConfig_st;
* 
* typedef struct{
* 	u32_t FI_Size;	unsigned char FI_Attr;	char FI_Name[C_MaxFileNameSize];
* }fileInfo;
* 
* 
* 
* 
* 
* /* ! Micro-C compiler variable limited to 14 characters length, and only the first 8 characters are considered */
* 
* //---------------------------- list the files with size  -----------------------------------------//
* dir() { 
*     fileInfo fileList;
* 	while(FILE_List(&fileList) != END_OF_FILE_LIST) {
dir
	pshs	u
	leau	,s
	leas	-18,s
_3
	leax	-18,u
	pshs	x
	lbsr	FILE_Lis
	leas	2,s
	subd	#$9
	lbeq	_2
* 	    print_DebugMsg("\n");
	leax	_4_,pc
	bra	_4
_4_
	fcb	$a, $0
_4
	pshs	x
	lbsr	print_De
	leas	2,s
* 		print_DebugMsg(fileList.FI_Name); print_DebugMsg(" - "); 
	leax	-13,u
	pshs	x
	lbsr	print_De
	leas	2,s
	leax	_5_,pc
	bra	_5
_5_
	fcb	$20, $2d, $20, $0
_5
	pshs	x
	lbsr	print_De
	leas	2,s
* 		if((fileList.FI_Attr != ATTR_VOLUME_ID) && (fileList.FI_Attr != ATTR_DIRECTORY)) {
	ldb	-14,u
	clra
	subd	#$8
	lbeq	_6
	ldb	-14,u
	clra
	subd	#$10
	lbeq	_6
* 			if(fileList.FI_Size.h != 0) HEXWORD2(fileList.FI_Size.h); 
	ldd	-18,u
	subd	#$0
	lbeq	_7
	ldd	-18,u
	pshs	d
	lbsr	HEXWORD2
	leas	2,s
* 			HEXWORD2(fileList.FI_Size.l); print_DebugMsg(" bytes");
_7
	ldd	-16,u
	pshs	d
	lbsr	HEXWORD2
	leas	2,s
	leax	_8_,pc
	bra	_8
_8_
	fcb	$20, $62, $79, $74, $65, $73, $0
_8
	pshs	x
	lbsr	print_De
	leas	2,s
* 		}
*     }  
_6
* }
	lbra	_3
_2
	leas	,u
	puls	u,pc
* 
* //----------------------------------- read a file -----------------------------------------//
* readfile(filename) char* filename;
* {
* 	char c;
* 	fileConfig_st *srcFilePtr;
* 	
* 	srcFilePtr = FILE_Open(filename, READ, &c);
readfile
	pshs	u
	leau	,s
	leas	-3,s
	leax	-1,u
	pshs	x
	clra
	clrb
	pshs	d
	ldd	4,u
	pshs	d
	lbsr	FILE_Ope
	leas	6,s
	std	-3,u
* 	if(srcFilePtr == 0)	{
	ldd	-3,u
	subd	#$0
	lbne	_9
* 		print_DebugMsg("\nFile Opening Failed");
	leax	_10_,pc
	bra	_10
_10_
	fcb	$a, $46, $69, $6c, $65, $20, $4f, $70
	fcb	$65, $6e, $69, $6e, $67, $20, $46, $61
	fcb	$69, $6c, $65, $64, $0
_10
	pshs	x
	lbsr	print_De
	leas	2,s
* 	}
* 	else {
	lbra	_11
_9
* 		print_DebugMsg("\nFile Content: ");
	leax	_12_,pc
	bra	_12
_12_
	fcb	$a, $46, $69, $6c, $65, $20, $43, $6f
	fcb	$6e, $74, $65, $6e, $74, $3a, $20, $0
_12
	pshs	x
	lbsr	print_De
	leas	2,s
* 		while(1) {
_14
* 			c = FILE_GetCh(srcFilePtr);
	ldd	-3,u
	pshs	d
	lbsr	FILE_Get
	leas	2,s
	stb	-1,u
* 			if(c == EOF) break;
	ldb	-1,u
	sex
	subd	#$1a
	lbne	_15
	lbra	_13
* 			BYTE2MON(c);			
_15
	ldb	-1,u
	sex
	pshs	d
	lbsr	BYTE2MON
	leas	2,s
* 		}
* 		FILE_Close(srcFilePtr);
	lbra	_14
_13
	ldd	-3,u
	pshs	d
	lbsr	FILE_Clo
	leas	2,s
* 	}
* }
_11
	puls	a,x,u,pc
* 
* //-------------------------------- write into a file -----------------------------------------//
* writefile(filename, data) char* filename; char* data;
* {	
* 	char c;
* 	fileConfig_st *srcFilePtr;
* 	unsigned int cnt;
* 	
* 	print_DebugMsg("\nOpening");
writefil
	pshs	u
	leau	,s
	leas	-5,s
	leax	_16_,pc
	bra	_16
_16_
	fcb	$a, $4f, $70, $65, $6e, $69, $6e, $67
	fcb	$0
_16
	pshs	x
	lbsr	print_De
	leas	2,s
* 	srcFilePtr = FILE_Open(filename, WRITE, &c);
	leax	-1,u
	pshs	x
	ldd	#$2
	pshs	d
	ldd	4,u
	pshs	d
	lbsr	FILE_Ope
	leas	6,s
	std	-3,u
* 	if(srcFilePtr == 0)	{
	ldd	-3,u
	subd	#$0
	lbne	_17
* 		print_DebugMsg("\nFile Opening Failed!"); HEXBYTE2(c);
	leax	_18_,pc
	bra	_18
_18_
	fcb	$a, $46, $69, $6c, $65, $20, $4f, $70
	fcb	$65, $6e, $69, $6e, $67, $20, $46, $61
	fcb	$69, $6c, $65, $64, $21, $0
_18
	pshs	x
	lbsr	print_De
	leas	2,s
	ldb	-1,u
	sex
	pshs	d
	lbsr	HEXBYTE2
	leas	2,s
* 	}
* 	else {
	lbra	_19
_17
* 		print_DebugMsg("\nFile Open");
	leax	_20_,pc
	bra	_20
_20_
	fcb	$a, $46, $69, $6c, $65, $20, $4f, $70
	fcb	$65, $6e, $0
_20
	pshs	x
	lbsr	print_De
	leas	2,s
* 		cnt=0;		
	clra
	clrb
	std	-5,u
* 		while(data[cnt]) {
_22
	ldd	-5,u
	ldx	6,u
	ldb	d,x
	sex
	lbeq	_21
* 			FILE_PutCh(srcFilePtr, data[cnt++]);
	ldd	-5,u
	addd	#$1
	std	-5,u
	subd	#$1
	ldx	6,u
	ldb	d,x
	sex
	pshs	d
	ldd	-3,u
	pshs	d
	lbsr	FILE_Put
	leas	4,s
* 			HEXBYTE2(cnt);
	ldd	-5,u
	pshs	d
	lbsr	HEXBYTE2
	leas	2,s
* 		}
* 				
* 		FILE_PutCh(srcFilePtr, EOF);
	lbra	_22
_21
	ldd	#$1a
	pshs	d
	ldd	-3,u
	pshs	d
	lbsr	FILE_Put
	leas	4,s
* 		FILE_Close(srcFilePtr); print_DebugMsg("\nFile closed"); //the slowest operation
	ldd	-3,u
	pshs	d
	lbsr	FILE_Clo
	leas	2,s
	leax	_23_,pc
	bra	_23
_23_
	fcb	$a, $46, $69, $6c, $65, $20, $63, $6c
	fcb	$6f, $73, $65, $64, $0
_23
	pshs	x
	lbsr	print_De
	leas	2,s
* 	}
* }
_19
	leas	,u
	puls	u,pc
* 
* //-------------------------------- delete a file -----------------------------------------//
* deletefile(filename) char* filename;
* {	
*  	print_DebugMsg("\nDeleting");	
deletefi
	pshs	u
	leau	,s
	leax	_24_,pc
	bra	_24
_24_
	fcb	$a, $44, $65, $6c, $65, $74, $69, $6e
	fcb	$67, $0
_24
	pshs	x
	lbsr	print_De
	leas	2,s
* 	if(FILE_Delete(filename) == FILE_OPENED_CANNOT_BE_DELETED) print_DebugMsg("\nFile is open cannot be deleted");
	ldd	4,u
	pshs	d
	lbsr	FILE_Del
	leas	2,s
	subd	#$6
	lbne	_25
	leax	_26_,pc
	bra	_26
_26_
	fcb	$a, $46, $69, $6c, $65, $20, $69, $73
	fcb	$20, $6f, $70, $65, $6e, $20, $63, $61
	fcb	$6e, $6e, $6f, $74, $20, $62, $65, $20
	fcb	$64, $65, $6c, $65, $74, $65, $64, $0
_26
	pshs	x
	lbsr	print_De
	leas	2,s
* 	else print_DebugMsg("\nDone, file deleted");
	lbra	_27
_25
	leax	_28_,pc
	bra	_28
_28_
	fcb	$a, $44, $6f, $6e, $65, $2c, $20, $66
	fcb	$69, $6c, $65, $20, $64, $65, $6c, $65
	fcb	$74, $65, $64, $0
_28
	pshs	x
	lbsr	print_De
	leas	2,s
* }
_27
	puls	u,pc
* 
* /***********************************************************************************************/
* /*	main program
* /***********************************************************************************************/
* 
* main() {
* 	char cnt;
* 	char* pData;
* 	char* filename;
* 
* 	if(initDISK() != 0) return;
main
	pshs	u
	leau	,s
	leas	-5,s
	lbsr	initDISK
	subd	#$0
	lbeq	_29
* 	
* 	print_DebugMsg("\n\nListing the files");
	leas	,u
	puls	u,pc
_29
	leax	_30_,pc
	bra	_30
_30_
	fcb	$a, $a, $4c, $69, $73, $74, $69, $6e
	fcb	$67, $20, $74, $68, $65, $20, $66, $69
	fcb	$6c, $65, $73, $0
_30
	pshs	x
	lbsr	print_De
	leas	2,s
* 	dir();
	lbsr	dir
* 	
* 	filename = "FILE02.TXT";	
	leax	_31_,pc
	bra	_31
_31_
	fcb	$46, $49, $4c, $45, $30, $32, $2e, $54
	fcb	$58, $54, $0
_31
	tfr	x,d
	std	-5,u
* 	print_DebugMsg("\n\nCreating the file "); print_DebugMsg(filename);
	leax	_32_,pc
	bra	_32
_32_
	fcb	$a, $a, $43, $72, $65, $61, $74, $69
	fcb	$6e, $67, $20, $74, $68, $65, $20, $66
	fcb	$69, $6c, $65, $20, $0
_32
	pshs	x
	lbsr	print_De
	leas	2,s
	ldd	-5,u
	pshs	d
	lbsr	print_De
	leas	2,s
* 	pData = "hello SDcard";
	leax	_33_,pc
	bra	_33
_33_
	fcb	$68, $65, $6c, $6c, $6f, $20, $53, $44
	fcb	$63, $61, $72, $64, $0
_33
	tfr	x,d
	std	-3,u
* 	writefile(filename, pData);	//append the data when the file is already existing
	ldd	-3,u
	pshs	d
	ldd	-5,u
	pshs	d
	lbsr	writefil
	leas	4,s
* 
* 	print_DebugMsg("\n\nListing the change");
	leax	_34_,pc
	bra	_34
_34_
	fcb	$a, $a, $4c, $69, $73, $74, $69, $6e
	fcb	$67, $20, $74, $68, $65, $20, $63, $68
	fcb	$61, $6e, $67, $65, $0
_34
	pshs	x
	lbsr	print_De
	leas	2,s
* 	dir();
	lbsr	dir
* 
* 	print_DebugMsg("\n\nRead again the file");
	leax	_35_,pc
	bra	_35
_35_
	fcb	$a, $a, $52, $65, $61, $64, $20, $61
	fcb	$67, $61, $69, $6e, $20, $74, $68, $65
	fcb	$20, $66, $69, $6c, $65, $0
_35
	pshs	x
	lbsr	print_De
	leas	2,s
* 	readfile(filename);
	ldd	-5,u
	pshs	d
	lbsr	readfile
	leas	2,s
* 
* 	print_DebugMsg("\n\ndelete the file");
	leax	_36_,pc
	bra	_36
_36_
	fcb	$a, $a, $64, $65, $6c, $65, $74, $65
	fcb	$20, $74, $68, $65, $20, $66, $69, $6c
	fcb	$65, $0
_36
	pshs	x
	lbsr	print_De
	leas	2,s
* 	deletefile(filename);
	ldd	-5,u
	pshs	d
	lbsr	deletefi
	leas	2,s
* 	
* 	print_DebugMsg("\n\nListing the remaining files");
	leax	_37_,pc
	bra	_37
_37_
	fcb	$a, $a, $4c, $69, $73, $74, $69, $6e
	fcb	$67, $20, $74, $68, $65, $20, $72, $65
	fcb	$6d, $61, $69, $6e, $69, $6e, $67, $20
	fcb	$66, $69, $6c, $65, $73, $0
_37
	pshs	x
	lbsr	print_De
	leas	2,s
* 	dir();
	lbsr	dir
* 	
* 	print_DebugMsg("\n\nback to prompt\n\n");
	leax	_38_,pc
	bra	_38
_38_
	fcb	$a, $a, $62, $61, $63, $6b, $20, $74
	fcb	$6f, $20, $70, $72, $6f, $6d, $70, $74
	fcb	$a, $a, $0
_38
	pshs	x
	lbsr	print_De
	leas	2,s
* }
	leas	,u
	puls	u,pc
* 
* // LF CR to end the file requested by the Micro-C compiler
_GLOBALS	equ	0
