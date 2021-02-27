/*
mapmaker - a tool for making maps for Mach3D-based programs
Copyright (c) 2006 Kevin Harness
 
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
#include <cstdlib>
#include <fstream>
#include <cctype>
using namespace std;

const int _MAX_PATH = 256;

unsigned char Map[64][64];
unsigned char XLat[256];
int i,x,y;
char Buffer[_MAX_PATH];

int w=16;
int h=16;

int ProcFile(istream& fIn, int Depth);

int main(int argc, char* argv[])
{
	memset(Map,0,64*64*sizeof(unsigned char));
	memset(XLat,0,256*sizeof(unsigned char));
	x=0;
	y=0;

	if(ProcFile(cin,0)) return 2;

	for(y=0;y<h;y++) {
		for(x=0;x<w;x++) {
			if(!(x&0x0F))
				cout << " .db ";
			sprintf(Buffer,"$%02X",Map[x][y]);
			cout << Buffer;
			if((x&0x0F)!=0x0F) cout << ",";
			else cout << "\n";
		}
	}
	return 0;
}

int ProcFile(istream& fIn, int Depth)
{
	if(Depth>10) return 1;

	while(!fIn.eof())
	{
		int c = fIn.get();
		if(c==EOF) break;
		if(c=='.')
		{
			c=fIn.get();
			if(c==EOF) break;
			switch(toupper(c))
			{
			case 'I':	//include file
				i=0;
				do {
					Buffer[i++]=c=fIn.get();
				} while((c!=EOF)&&(c!='\n')&&(i<_MAX_PATH-8));
				Buffer[i-1] = '\0';
				{
					ifstream is(Buffer);
					if(!is) return 1;
					if(ProcFile(is,Depth+1)) return 1;
					is.close();
				}
				break;
			case 'X':	// set X
				x=0;
				do {
					c=fIn.get();
					if(isdigit(c)) x=x*10+c-'0';
				} while((c!=EOF)&&(c!='\n'));
				x&=31;
				break;
			case 'Y':	// set Y
				y=0;
				do {
					c=fIn.get();
					if(isdigit(c)) y=y*10+c-'0';
				} while((c!=EOF)&&(c!='\n'));
				y&=31;
				break;
			case '.':	// comment
				do {
					c=fIn.get();
				} while((c!=EOF)&&(c!='\n'));
				break;
			case 'D':	// define symbol
				{
					c = 0xFF & fIn.get();
					int n=c;
					XLat[n] = 0;
					do {
						c=fIn.get();
						if(isdigit(c)) XLat[n]=XLat[n]*10+c-'0';
					} while((c!=EOF)&&(c!='\n'));
				} break;
			case 'W':	// set width
				{
					w=0;
					do {
						c=fIn.get();
						if(isdigit(c)) w=w*10+c-'0';
					} while((c!=EOF)&&(c!='\n'));
					if(w>64) w=64;
					if(0==w) w=1;
				} break;
			case 'H':	// set height
				{
					h=0;
					do {
						c=fIn.get();
						if(isdigit(c)) h=h*10+c-'0';
					} while((c!=EOF)&&(c!='\n'));
					if(h>64) h=64;
					if(0==h) h=1;
				} break;
			}
		} else if (c!='\n') {
			Map[x%w][y%h] = XLat[c&0xFF];
			if(++x>=w) y=(y+1)%h;
			x %= w;
		}
	}
	return 0;
}
