/*
tablemaker - generates tables for internal use in the Mach3D engine
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
#include <stdio.h>
#include <math.h>

typedef unsigned char BYTE;

const double MOVEMENT_SPEED = 0.2;	// gridlines per frame

unsigned char table[256];
const double PI=acos(-1);

int clamp(double d, int hi=255, int lo=0) {
	if(d<lo) return lo;
	if(d>hi) return hi;
	return int(d+0.5);
}

double fnSin(double t) {
	return 256*sin(t*PI/2);
}

BYTE fnFullSin(BYTE t) {
	return 0xFF&clamp(MOVEMENT_SPEED*256*sin(t/128.0*PI),127,-128);
}

BYTE fnDiv64(BYTE d) {
	if(!d) return 0;
	return 0xFF&(64*256/d);
}

void dump_table(const char* lbl) {
	int x,y;
	if(lbl) printf("%s:\n",lbl);
	for(y=0;y<16;y++) {
		printf(" .db ");
		for(x=0;x<16;x++) {
			if(x) printf(",");
			printf("$%02X",table[y*16+x]);
		}
		printf("\n");
	}
}

void gen8(double (*fn)(double), const char* lbl) {
	int i;
	for(i=0;i<256;i++)
		table[i] = clamp(fn(i/256.0));
	dump_table(lbl);
}

void gen8i(BYTE (*fn)(BYTE), const char* lbl) {
	int i;
	for(i=0;i<256;i++)
		table[i] = fn(i);
	dump_table(lbl);
}

void gentan() {
	int i;
	unsigned short tbl[256];
	for(i=0;i<=128;i++)
		tbl[i] = clamp(256*tan((i+0.0)*PI/512.0),65535);
	for(;i<256;i++) {
		if(tbl[256-i])
			tbl[i] = clamp(65536.0/tbl[256-i],65535);
		else
			tbl[i] = 0xFFFF;
	}
	for(i=0;i<256;i++)
		table[i]=tbl[i]&255;
	dump_table("tblTan");
	for(i=0;i<256;i++)
		table[i]=tbl[i]>>8;
	dump_table(NULL);
}

int main() {
	puts("ALIGN256");
	gen8(fnSin,"tblSin");
	gentan();
	gen8i(fnDiv64,"tbl64Div");
	return 0;
}

