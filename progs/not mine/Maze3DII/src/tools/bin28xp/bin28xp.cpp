/*
bin28xp - a program to pack binary data into TI's 8xp format
Copyright (C) 2006  Kevin Harness

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/
#include <iostream>
#include <cstring>
#include <cctype>
#include "ti83file.h"

using namespace std;

int PrintUsage(const char* ProgName) {
	cerr << "Usage:\n" << ProgName
		<< " [-c comment] [-n name] [[-i] in.bin] [[-o] out.8xp]\n\n";
	cerr << "Input file name can be `stdin' or missing\n";
	cerr << "Output file name can be `stdout' or missing\n";
	return 1;
}

void GenFile(istream& fIn, ostream& fOut,
		const char* pName, const char* pComment) {
	int c;
	TI83File file(pName);
	if(pComment) file.SetComment(pComment);
	while(fIn) {
		c=fIn.get();
		if(EOF==c) break;
		file.put((unsigned char)c);
	}
	file.flush(fOut);
}

int main(int argc, char* argv[]) {
	ifstream fIn;
	ofstream fOut;
	istream* pIn = &cin;
	ostream* pOut = &cout;
	char *pName=NULL,*pComment=NULL,*iName=NULL,*oName=NULL,*pTmp=NULL;
	int i,j,c='i';
	char Buffer[12];
	for(i=1;i<argc;i++) {
		if('-'==argv[i][0]) {
			for(j=1;argv[i][j];j++) {
				switch(tolower(argv[i][j])) {
					case 'c':
					case 'i':
					case 'o':
					case 'n':
						c=tolower(argv[i][j]);
						break;
					default:
						return PrintUsage(argv[0]);
				}
			}
		} else {
			switch(c) {
				case 'c':
					pComment = argv[i];
					if(!iName) c='i';
					else if(!oName) c='o';
					else c=0;
					break;
				case 'n':
					pName = argv[i];
					if(!iName) c='i';
					else if(!oName) c='o';
					else c=0;
					break;
				case 'i':
					iName = argv[i];
					if(!oName) c='o';
					else c=0;
					break;
				case 'o':
					oName = argv[i];
					c=0;
					break;
				defualt:
					return PrintUsage(argv[0]);
			}
		}
	}
	if(!iName) iName="stdin";
	if(!oName) oName="stdout";
	if(strcasecmp(iName,"stdin")) {
		fIn.open(iName,ios::in|ios::binary);
		if(!fIn) {
			cerr << "Error: could not open "
			<< iName << " for input\n";
			return 2;
		}
		pIn = &fIn;
	}
	if(strcasecmp(oName,"stdout")) {
		fOut.open(oName,ios::out|ios::binary);
		if(!fOut) {
			cerr << "Error: could not open "
			<< oName << " for output\n";
			return 2;
		}
		pOut = &fOut;
	}
	if(!pName) {
		pName = oName;
		if(!strcasecmp(oName,"stdout")) pName=iName;
		pTmp = pName;
		while(*pName) pName++;
		while(pName>=pTmp&&pName[0]!='\\'&&pName[0]!='/') pName--;
		pName++;
		for(i=0;i<8&&pName[i]&&'.'!=pName[i];i++)
			Buffer[i]=pName[i];
		Buffer[i]='\0';
		pName=Buffer;
	}
	GenFile(*pIn,*pOut,pName,pComment);
	return 0;
}

