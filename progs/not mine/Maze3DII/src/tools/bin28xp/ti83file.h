/*
ti83file.h - a convenient interface to TI's 8xp format
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
#ifndef _INC_TI83FILE_H
#define _INC_TI83FILE_H

#include <fstream>
#include <cstring>
#include <cctype>

using namespace std;

const int MAX_TIFILE_SIZE = 20480;

#ifdef _MSC_VER
#define PACK_STRUCT
#else	// _MSC_VER
// assume gcc
#define PACK_STRUCT __attribute__((packed))
#endif	// _MSC_VER

struct DataBuf {
	DataBuf() { Loc = 0; }
	int Loc;
	unsigned char Data[MAX_TIFILE_SIZE];
	unsigned short CheckSum(int Start) {
		return CheckSum(Start,Loc);
	}
	unsigned short CheckSum(int Start, int End) {
		unsigned short c=0;
		for(int i=Start;i<End;i++) c+=Data[i];
		return c;
	}
	void write(const void* pData,int Len) {
		if(Len+Loc<MAX_TIFILE_SIZE) {
			memcpy(Data+Loc,pData,Len);
			Loc+=Len;
		} else {
			memcpy(Data+Loc,pData,MAX_TIFILE_SIZE-Loc);
			Loc=MAX_TIFILE_SIZE;
		}
	}
	void put(const unsigned char c) {
		if(Loc<MAX_TIFILE_SIZE) Data[Loc++] = c;
	}
	void flush(ostream& File) {
		File.write((char*)Data,Loc);
	}
};

#ifdef _MSC_VER
#pragma pack(push)
#pragma pack(1)
#endif

struct TI8xpHdr {
	char ID[11];	// "**TI83F*",0x1A,0x0A,0x00
	char Comment[42];
	unsigned short DatLen1;
	char Stuff1[2];
	unsigned short DatLen2;
	char Type;
	char Name[8];
	char Stuff2[2];
	unsigned short DatLen3;
	unsigned short DatLen4;
	TI8xpHdr() {
		Init();
	};
	void Init() {
		memset(this,0,sizeof(TI8xpHdr));
		memcpy(ID,"**TI83F*",8);
		ID[8] = 0x1A; ID[9] = 0x0A; ID[10] = 0x00;
		strcpy(Comment,"This is a TI83File by Kevin Harness");
		Stuff1[0] = 13; Stuff1[1] = 0;
		Type = 6;	// protected program
	}
	void SetLen(unsigned short Len) {
		DatLen1 = Len+19;
		DatLen2 = Len+2;
		DatLen3 = Len+2;
		DatLen4 = Len;
	}
} PACK_STRUCT;

#ifdef _MSC_VER
#pragma pack(pop)
#endif

struct TI83File
{
	TI83File() {
		Init();
	}
	TI83File(const char* pName) {
		Init();
		SetName(pName);
	}
	void Init() {
		m_Head.Init();
		m_Dat.Loc = sizeof(TI8xpHdr);
	}
	void SetName(const char* pName) {
		for(int i=0;i<8;i++) {
			while((*pName)&&!(isalpha(*pName)||
					(isdigit(*pName)&&i)))
				pName++;
			m_Head.Name[i]=toupper(*pName);
			// if end of string, pName will stay
			// at '\0' to NULL-pack the title
			if(*pName) pName++;
		}
	}
	void SetComment(const char* pComment) {
		strncpy(m_Head.Comment,pComment,42);
	}
	void write(const void* pData,int Len) {
		m_Dat.write(pData,Len);
	}
	void put(unsigned char c) {
		m_Dat.put(c);
	}
	void flush(ostream& File) {
		m_Head.SetLen(m_Dat.Loc-sizeof(TI8xpHdr));
		memcpy(m_Dat.Data,&m_Head,sizeof(TI8xpHdr));
		unsigned short chk = m_Dat.CheckSum(55);
		m_Dat.flush(File);
		File.write((char*)&chk,2);
	}
	TI8xpHdr	m_Head;
	DataBuf		m_Dat;
};

#endif	//_INC_TI83FILE_H

