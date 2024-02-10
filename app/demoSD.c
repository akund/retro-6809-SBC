#define C_MaxPageSize_U16        512
#include "../disk/stdutils.h"
#include "../disk/fat32.h"

/* ! Micro-C compiler variable limited to 14 characters length, and only the first 8 characters are considered */

//---------------------------- list the files with size  -----------------------------------------//
dir() { 
    fileInfo fileList;
	while(FILE_List(&fileList) != END_OF_FILE_LIST) {
	    print_DebugMsg("\n");
		print_DebugMsg(fileList.FI_Name); print_DebugMsg(" - "); 
		if((fileList.FI_Attr != ATTR_VOLUME_ID) && (fileList.FI_Attr != ATTR_DIRECTORY)) {
			if(fileList.FI_Size.h != 0) HEXWORD2(fileList.FI_Size.h); 
			HEXWORD2(fileList.FI_Size.l); print_DebugMsg(" bytes");
		}
    }  
}

//----------------------------------- read a file -----------------------------------------//
readfile(filename) char* filename;
{
	char c;
	fileConfig_st *srcFilePtr;
	
	srcFilePtr = FILE_Open(filename, READ, &c);
	if(srcFilePtr == 0)	{
		print_DebugMsg("\nFile Opening Failed");
	}
	else {
		print_DebugMsg("\nFile Content: ");
		while(1) {
			c = FILE_GetCh(srcFilePtr);
			if(c == EOF) break;
			BYTE2MON(c);			
		}
		FILE_Close(srcFilePtr);
	}
}

//-------------------------------- write into a file -----------------------------------------//
writefile(filename, data) char* filename; char* data;
{	
	char c;
	fileConfig_st *srcFilePtr;
	unsigned int cnt;
	
	print_DebugMsg("\nOpening");
	srcFilePtr = FILE_Open(filename, WRITE, &c);
	if(srcFilePtr == 0)	{
		print_DebugMsg("\nFile Opening Failed!"); HEXBYTE2(c);
	}
	else {
		print_DebugMsg("\nFile Open");
		cnt=0;		
		while(data[cnt]) {
			FILE_PutCh(srcFilePtr, data[cnt++]);
			HEXBYTE2(cnt);
		}
				
		FILE_PutCh(srcFilePtr, EOF);
		FILE_Close(srcFilePtr); print_DebugMsg("\nFile closed"); //the slowest operation
	}
}

//-------------------------------- delete a file -----------------------------------------//
deletefile(filename) char* filename;
{	
 	print_DebugMsg("\nDeleting");	
	if(FILE_Delete(filename) == FILE_OPENED_CANNOT_BE_DELETED) print_DebugMsg("\nFile is open cannot be deleted");
	else print_DebugMsg("\nDone, file deleted");
}

/***********************************************************************************************/
/*	main program
/***********************************************************************************************/

main() {
	char cnt;
	char* pData;
	char* filename;

	if(initDISK() != 0) return;
	
	print_DebugMsg("\n\nListing the files");
	dir();
	
	filename = "FILE02.TXT";	
	print_DebugMsg("\n\nCreating the file "); print_DebugMsg(filename);
	pData = "hello SDcard";
	writefile(filename, pData);	//append the data when the file is already existing

	print_DebugMsg("\n\nListing the change");
	dir();

	print_DebugMsg("\n\nRead again the file");
	readfile(filename);

	print_DebugMsg("\n\ndelete the file");
	deletefile(filename);
	
	print_DebugMsg("\n\nListing the remaining files");
	dir();
	
	print_DebugMsg("\n\nback to prompt\n\n");
}

// LF CR to end the file requested by the Micro-C compiler
