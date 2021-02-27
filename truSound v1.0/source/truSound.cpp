// truSound.cpp : Defines the entry point for the console application.
//


#include "stdafx.h"
#include <iostream>
#include <sstream>
#include <fstream>
#include <iomanip>
#include <algorithm>

using namespace std;


//int treeBuf[5000] = {0};
//int nEndOfData = 0;
//int prefix[512] = {0};
//int stack[32] = {0};
//int nStackPtr = 0;
//int nBytePos = 0;
//int nSrcLoc = 0;
//int nPutLoc = 0;
//int nMaxBits = 0;

//int Power(int nBase, int nPower);

//int transformAddr(int nAddress)
//{
//	int nNewAddress = 0;
//	nNewAddress+= (nAddress & 0x1000) / 0x1000;
//	nNewAddress*= 2;
//	nNewAddress+= (nAddress & 0x0800) / 0x0800;
//	nNewAddress*= 2;
//	nNewAddress+= (nAddress & 0x0004) / 0x0004;
//	nNewAddress*= 2;
//	nNewAddress+= (nAddress & 0x0002) / 0x0002;
//	nNewAddress*= 2;
//	for (int iii = 0; iii < 8; iii++)
//	{
//		nNewAddress+= (nAddress & Power(2, 10-iii)) / Power(2, 10-iii);
//		nNewAddress*=2;
//	}
//	return nNewAddress;
//}








//void putPrefix(int nNumber, char* buffer)
//{
//	int nPutting = prefix[nNumber * 2 + 1];
//	for (int iii = 0; iii < prefix[nNumber * 2]; iii++)
//	{
//		buffer[nPutLoc]+= (nPutting & 1) * Power(2, (7 - nBytePos));
//		nBytePos++;
//		if (nBytePos > 7)
//		{
//			nBytePos = 0;
//			nPutLoc++;
//		}
//		nPutting/= 2;
//	}
//}


//int getCurrentPrefix()
//{
//	int nPrefix = 0;
//	for (int iii = 0; iii < nStackPtr; iii++)
//	{
//		nPrefix*= 2;
//		nPrefix+= stack[nStackPtr - iii - 1];
//	}
//	return nPrefix;
//}




//int handleTree(int nStart)
//{
//	stack[nStackPtr] = 1;
//	nStackPtr++;
//	if (nStackPtr > nMaxBits)
//		nMaxBits = nStackPtr;
//	nStart+= 2;
//	for (int iii = 0; iii < 2; iii++)
//	{
//		if (treeBuf[nStart + 1] == 1)
//		{
//			prefix[treeBuf[nStart + 2] * 2] = nStackPtr;
//			prefix[treeBuf[nStart + 2] * 2 + 1] = getCurrentPrefix();
//			nStart+= 3;
//		}
//		else
//			nStart = handleTree(nStart);
//		stack[nStackPtr - 1] = 0;
//	}
//	nStackPtr--;
//	return nStart;
//}
			


//void insertMem(int nAmount, int nLocation)
//{
//	for (int iii = 0; iii < nEndOfData-nLocation; iii++)
//		treeBuf[nEndOfData + nAmount - iii - 1] = treeBuf[nEndOfData - iii - 1];
//	nEndOfData+= nAmount;
//	return;
//}

//void deleteMem(int nAmount, int nLocation)
//{
//	for (int iii = 0; iii < nEndOfData-nLocation-nAmount; iii++)
//		treeBuf[nLocation + iii] = treeBuf[nLocation + iii + nAmount];
//	nEndOfData-= nAmount;
//	return;
//}


//int moveMem(int nAmount, int nFrom, int nTo)
//{
///	insertMem(nAmount, nTo);
//	if (nTo < nFrom)
//		nFrom+= nAmount;
//	for (int iii = 0; iii < nAmount; iii++)
//		treeBuf[nTo + iii] = treeBuf[nFrom + iii];
//	deleteMem(nAmount, nFrom);
//	if (nFrom < nTo)
//		nTo-= nAmount;
//	return nTo;
//}

int Power(int nBase, int nPower);

int FindString(int nStart, const char achString[4], char* achBuf)
{
	int nMatches = 0;
	while (nMatches < 4)
	{
		if (achBuf[nStart] == achString[nMatches])
			nMatches++;
		else
			nMatches = 0;
		nStart++;
	}
	return nStart;
}

int GetValue(int &nStart, int nBytes, char* achBuf)
{
	int nTotal = 0;
	for (int iii = 0; iii < nBytes; iii++)
	{
		nTotal+= (unsigned char)achBuf[nStart] * Power(2, 8*iii);
		nStart++;
	}
	return nTotal;
}


int Power(int nBase, int nPower)
{
	int nResult = 1;
	for (int iii = 0; iii < nPower; iii++)
		nResult*= nBase;
	return nResult;
}






int main(int argc, char *argv[ ])
{	
	if (argc != 3)
	{
		cout << "Proper command syntax is:  truSound song.wav output.bin" << endl;
		exit(1);
	}
	ifstream fSongFile (argv[1], ios::_Nocreate | ios::binary | ios::ate | ios::out);

	if (!fSongFile)
	{
		cerr << "File Not Found!" << endl;
		exit(1); 
	}
	cout << "File Found!" << endl;
	
	int nFileSize;
	nFileSize = fSongFile.tellg();
	int nCurrentByte = 0;
	char *srcBlock = new char [nFileSize];
	char *putBlock = new char [nFileSize];
	fSongFile.seekg(0, ios::beg);
	fSongFile.read(srcBlock, nFileSize);
	fSongFile.close();

	nCurrentByte = FindString(0, "fmt ", srcBlock) + 4;
	if (GetValue(nCurrentByte, 2, srcBlock) != 1)
	{
		cout << "Error: Compressed" << endl;
		delete[] srcBlock;
		delete[] putBlock;
		exit(1);
	}

	int nChannels = GetValue(nCurrentByte, 2, srcBlock);
	cout << "Channels: " << nChannels << endl;
	if (nChannels > 2)
	{
		cout << "Error: Too many channels" << endl;
		delete[] srcBlock;
		delete[] putBlock;
		exit(1);
	}

	int nSampleRate = GetValue(nCurrentByte, 4, srcBlock);
	cout << "Sample rate: " << nSampleRate << endl;

	nCurrentByte+= 6;
	int nBitsPerSample = GetValue(nCurrentByte, 2, srcBlock);
	cout << "Bits per sample: " << nBitsPerSample << endl;
	if (nBitsPerSample != 8 && nBitsPerSample != 16)
	{
		cout << "Error: Invalid bits per sample" << endl;
		delete[] srcBlock;
		delete[] putBlock;
		exit(1);
	}

	int nExtraBytes = FindString(0, "data", srcBlock) + 4;

	for (int iii = 0; iii < nFileSize - nExtraBytes; iii++)
		srcBlock[iii] = srcBlock[iii + nExtraBytes];

	nFileSize-= nExtraBytes;

	if (nBitsPerSample == 16)
	{
		cout << "Converting to 8 bit..." << endl;
		for (int iii = 0; iii < nFileSize / 2; iii++)
			srcBlock[iii] = (signed char)(((unsigned char)srcBlock[iii*2 + 1] + 0x80) & 0xFF);
		nFileSize/=2;
	}

	if (nChannels == 2)
	{
		cout << "Converting to one channel..." << endl;
		for (int iii = 0; iii < nFileSize / 2; iii++)
			srcBlock[iii] = (signed char)(((unsigned char)srcBlock[iii*2] + (unsigned char)srcBlock[iii*2 + 1]) / 2);
		nFileSize/=2;
	}

	cout << "Eliminating 0x00's and 0xFF's" << endl;
	for (int iii = 0; iii < nFileSize; iii++)
	{
		if (!srcBlock[iii])
			srcBlock[iii] = 1;
		if ((unsigned char)srcBlock[iii] == 0xFF)
			srcBlock[iii] = (signed char)0xFE;
	}


	cout << "Compressing..." << endl;
	cout << "Initial File Size " << nFileSize << endl;

	
	nCurrentByte = 0;
	int nPutPtr = 0;
	int nPercent = 0;

	while (nCurrentByte < nFileSize)
	{
		int	nValids = 0;
		while (((unsigned char)srcBlock[nCurrentByte + nValids] > 0x78) && ((unsigned char)srcBlock[nCurrentByte + nValids] < 0x88) && (nValids + nCurrentByte < nFileSize))
			nValids++;
		if (nValids %2)
			nValids--;
		if (nValids > 5)
		{
			putBlock[nPutPtr] = 0x00;
			for (int iii = 0; iii < nValids/2; iii++)
				putBlock[nPutPtr + iii + 1] = (signed char)((((unsigned char)srcBlock[nCurrentByte + 2*iii]) - 0x78) * 0x10 + (((unsigned char)srcBlock[nCurrentByte + 2*iii +1]) - 0x78));
			putBlock[nPutPtr + nValids/2 + 1] = 0x00;

			nPutPtr+= nValids/2 + 2;
			nCurrentByte+= nValids;
		}
		else
		{
			putBlock[nPutPtr] = srcBlock[nCurrentByte];
			nPutPtr++;
			nCurrentByte++;
		}


//		if ((int)((((float)nCurrentByte) / ((float)nFileSize))*100.0) /10 > nPercent /25)
//		{
//			nPercent = (int)((float)(nCurrentByte / (float)nFileSize)*100.0);
//			cout << nPercent << '%' << endl;
//		}

	}


	ifstream iPlayCode ("playCode.bin", ios::_Nocreate | ios::binary | ios::ate | ios::out);

	if (!iPlayCode)
	{
		cerr << "playCode.bin not found!" << endl;
		delete[] srcBlock;
		delete[] putBlock;
		exit(1); 
	}
	
	int nPlaySize;
	nPlaySize = iPlayCode.tellg();
	char *playBlock = new char [nPlaySize];
	iPlayCode.seekg(0, ios::beg);
	iPlayCode.read(playBlock, nPlaySize);
	iPlayCode.close();


	fstream newFile(argv[2], ios::trunc | ios::in | ios::out | ios::binary);
	if (!newFile)
	{
		cout << "Open error on new file!" << endl;
		exit(1);
	}
	newFile.write(playBlock, nPlaySize);
	newFile.write(putBlock, nPutPtr);
	newFile.put(0xFF);
	newFile.close();

	delete[] srcBlock;
	delete[] putBlock;

	cout << "New size  " << nPutPtr << endl;
	cout << "Ratio  " << (float)(100.0-100.0*((float)nPutPtr)/((float)nFileSize)) << "% of file compressed" << endl;



		return(0);
}



//	int nCutOff;
//
//	stringstream ssStart(argv[3]);
//	ssStart >> nCutOff;
//
//	int freq[256] = {0};
//	bool bAllGood = false;
//
//	while (!bAllGood)
//	{
//		bAllGood = true;
//		for (int iii = 0; iii < 256; iii++)
//			freq[iii] = 0;
//		for (int iii = 0; iii < nFileSize; iii++)
//			freq[(unsigned char)srcBlock[iii]]++;
//		for (int iii = 1; iii < 256; iii++)
//		{
//			if (freq[iii] < nCutOff && freq[iii])
//			{
//				bAllGood = false;
//				if (iii < 0x80)
//				{
//					for (int jjj = 0; jjj < nFileSize; jjj++)
//						if (((unsigned char)srcBlock[jjj]) == iii)
//							srcBlock[jjj]++;
//				}
//				else
//				{
//					for (int jjj = 0; jjj < nFileSize; jjj++)
//						if ((unsigned char)srcBlock[jjj] == iii)
//							srcBlock[jjj]--;
//				}
//			}
//		}
//
//
//	
//	}
//
//
//	int order[512] = {0};
//
//	int nCurrentPos = 0;
//
//	int nLowest = 0;
//	int nLowestByte = 0;
//	int nRealNums = 0;
//
//	while (nLowest != 10000000)
//	{
//
//		nLowest = 10000000;
//		nLowestByte = 0;
//		for (int iii = 0; iii < 256; iii++)
//		{
//			if (freq[iii] < nLowest && freq[iii])
//			{
//				nLowest = freq[iii];
//				nLowestByte = iii;
//			}
//		}
//		order[nCurrentPos] = nLowest;
//		order[nCurrentPos + 1] = nLowestByte;
//		freq[nLowestByte] = 0;
//		nCurrentPos+=2;
//		nRealNums++;
//	}
//
//
//
//
//
//	nRealNums--;
//
//	int nNumsPtr = 0;
//	nLowest = 10000000;
//	int nLowestLoc = 0;
//	int n2ndLowest = 10000000;
//	int n2ndLowestLoc = 0;
//
//
//
//	while (1==1)
//	{
//		nLowest = 10000000;
//		nLowestLoc = 0;
//		n2ndLowest = 10000000;
//		n2ndLowestLoc = 0;
//		nCurrentPos = 0;
//		while (nCurrentPos < nEndOfData)
//		{
//			if (treeBuf[nCurrentPos] < n2ndLowest)
//			{
//				if (treeBuf[nCurrentPos] < nLowest)
//				{
//					n2ndLowest = nLowest;
//					n2ndLowestLoc = nLowestLoc;
//					nLowest = treeBuf[nCurrentPos];
//					nLowestLoc = nCurrentPos;
//				}
//				else
//				{
//					n2ndLowest = treeBuf[nCurrentPos];
//					nLowestLoc = nCurrentPos;
//				}
//			}
//			nCurrentPos++;
//			nCurrentPos+= treeBuf[nCurrentPos] + 1;
//		}
//		int nLowestNum = 10000000;
//		int n2ndLowestNum = 10000000;
//		if (nNumsPtr < nRealNums * 2)
//			nLowestNum = order[nNumsPtr];
//		if (nNumsPtr + 2 < nRealNums * 2)
//			n2ndLowestNum = order[nNumsPtr + 2];
//
//		if (nNumsPtr == nRealNums * 2 && n2ndLowest == 10000000)
//			goto treeMade;
//
//		if (nLowestNum <= nLowest)
//		{
//			if (n2ndLowestNum <= nLowest)
//			{
//				insertMem(8, 0);
//				treeBuf[0] = nLowestNum + n2ndLowestNum;
//				treeBuf[1] = 6;
//				treeBuf[2] = nLowestNum;
//				treeBuf[3] = 1;
//				treeBuf[4] = order[nNumsPtr + 1];
//				treeBuf[5] = n2ndLowestNum;
//				treeBuf[6] = 1;
//				treeBuf[7] = order[nNumsPtr + 3];
//
//				nNumsPtr+= 4;
//			}
//			else
//			{
//				moveMem(treeBuf[nLowestLoc + 1] + 2, nLowestLoc, 0);
//				insertMem(5, 0);
//				treeBuf[0] = nLowestNum + nLowest;
//				treeBuf[1] = 3 + treeBuf[6] + 2;
//				treeBuf[2] = nLowestNum;
//				treeBuf[3] = 1;
//				treeBuf[4] = order[nNumsPtr + 1];
//				nNumsPtr+= 2;
//			}
//		}
//		else
//		{
///			if (n2ndLowest < nLowestNum)
//			{
//				if (nLowestLoc < n2ndLowestLoc)
///				{
//					moveMem(treeBuf[nLowestLoc +1 ] + 2, nLowestLoc, 0);
//					moveMem(treeBuf[n2ndLowestLoc + 1] + 2, n2ndLowestLoc, 0);
//				}
//				else
//				{
//					moveMem(treeBuf[n2ndLowestLoc + 1] + 2, n2ndLowestLoc, 0);
//					moveMem(treeBuf[nLowestLoc +1 ] + 2, nLowestLoc, 0);
//				}
//				insertMem(2, 0);
//				treeBuf[0] = nLowest + n2ndLowest;
//				treeBuf[1] = treeBuf[3] + 2 + treeBuf[2 + 2 + treeBuf[3] + 1] + 2;
//			}
//			else
//			{
//				moveMem(treeBuf[nLowestLoc + 1] + 2, nLowestLoc, 0);
//				insertMem(5, 0);
//				treeBuf[0] = nLowestNum + nLowest;
//				treeBuf[1] = 3 + treeBuf[6] + 2;
//				treeBuf[2] = nLowestNum;
//				treeBuf[3] = 1;
//				treeBuf[4] = order[nNumsPtr + 1];
//				nNumsPtr+= 2;
//			}
//		}
//	}
//treeMade:
//
//	nStackPtr = 0;
//
//	handleTree(0);
//	
//	
//
//	nBytePos = 0;
//	nSrcLoc = 0;
//	nPutLoc = 0;
//
//
//	while (nSrcLoc < nFileSize)
//	{
//		putPrefix((unsigned char)srcBlock[nSrcLoc], putBlock);
//		nSrcLoc++;
//	}
//
//	if (!nBytePos)
//		nPutLoc++;
//
//	char lookup1[0x2000] = {0};
//	char lookup2[0x2000] = {0};
//
//	for (int iii = 0; iii < 256; iii++)
//	{
//		if (prefix[iii * 2])
//		{
//			int nThisAddress = 0;
//			int nThisPrefix = prefix[iii * 2 + 1];
//			for (int jjj = 0; jjj < 13; jjj++)
//			{
//				nThisAddress*= 2;
//				nThisAddress+= nThisPrefix & 1;
//				nThisPrefix/= 2;
//			}
//			for (int jjj = 0; jjj < Power(2, 12 - prefix[iii * 2]); jjj++)
//			{
//				lookup1[nThisAddress + jjj * 2] = 4 * prefix[iii * 2];
///				lookup1[nThisAddress + jjj * 2 + 1] = (unsigned char)iii;
//				lookup2[transformAddr(nThisAddress + jjj * 2)] = 4 * prefix[iii * 2];
//				lookup2[transformAddr(nThisAddress + jjj * 2) + 1] = (unsigned char)iii;
//			}
//		}
//	}
//
//
//	




//	int nCurrentByte = 0;
//	int nPutPtr = 0;
//	int nPercent = 0;
//
//	while (nCurrentByte < nFileSize)
//	{
//		int	nValids = 0;
//		while (((unsigned char)srcBlock[nCurrentByte + nValids] > 0x78) && ((unsigned char)srcBlock[nCurrentByte + nValids] < 0x88))
//			nValids++;
//		if (nValids %2)
//			nValids--;
//		if (nValids > 5)
//		{
//			putBlock[nPutPtr] = 0x00;
//			for (int iii = 0; iii < nValids/2; iii++)
//				putBlock[nPutPtr + iii + 1] = (srcBlock[nCurrentByte + 2*iii] - 0x78) * 0x10 + (srcBlock[nCurrentByte + 2*iii +1] - 0x78);
//			putBlock[nPutPtr + nValids/2 + 1] = 0x00;
//
//			nPutPtr+= nValids/2 + 2;
//			nCurrentByte+= nValids;
//		}
//		else
//		{
//			putBlock[nPutPtr] = srcBlock[nCurrentByte];
//			nPutPtr++;
//			nCurrentByte++;
//		}
//
//
//		if ((int)((((float)nCurrentByte) / ((float)nFileSize))*100.0) > nPercent)
//		{
//			nPercent = (int)((float)(nCurrentByte / (float)nFileSize)*100.0);
//			cout << nPercent << '%' << endl;
//		}
//
//	}
