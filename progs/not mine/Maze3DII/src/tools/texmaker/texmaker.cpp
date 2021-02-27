/*
texmaker - an image processor for making textures for the Mach3D engine
Copyright (C) 2006 Kevin Harness

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

#include <unistd.h>
using namespace std;

char Buffer[256];

struct ppm {
	unsigned char* data;
	int width;
	int height;
};

ppm ppmload(istream& is);

void byteout(int b) {
	static int pos=0;
	if(pos) cout << ',';
	else cout << " .db ";
	sprintf(Buffer,"$%02X",b);
	cout << Buffer;
	pos = (pos+1)&0x0F;
	if(!pos) cout << endl;
}

int main(int argc, char* argv[])
{
	int opt,transparent=0;
	int x,x2,y,y2,o,n;

	while(0<=(opt=getopt(argc,argv,"t"))) {
		switch(opt) {
			case 't':
				transparent=1;
				break;
			default:
				// TODO: show usage
				break;
		}
	}
	
	ppm img=ppmload(cin);
	if(!img.data) {
		cerr << "error reading ppm from cin\n";
		return 1;
	}
	if(img.width%8) {
		cerr << "image width must be a multiple of 8\n";
		return 1;
	}
#define AT(x,y) ((x)+img.width*(y))
	for(x=0;x<img.width;x+=8) {
		if(transparent) {
			for(y=0;y<img.height;y++) {
				for(x2=o=0;x2<8;x2++)
					if(img.data[AT(x+x2,y)]<192&&
						img.data[AT(x+x2,y)]>=64)
						o|=1<<(7-x2);
				byteout(o);
			}
		}
		for(y=0;y<img.height;y++) {
			for(x2=o=0;x2<8;x2++)
				if(img.data[AT(x+x2,y)]<128)
					o|=1<<(7-x2);
			byteout(o);
		}
	}
	delete[] img.data;
	return 0;
}

int ppmint(istream& is) {
	int c,r=0;
	char state='w';
	while(EOF!=(c=is.get())) {
		switch(state) {
			case 'w':	// whitespace
				switch(c) {
					case ' ':
					case '\t':
					case '\r':
					case '\n':
						continue;
					case '#':
						state='c';
						continue;
				}
				if(!isdigit(c)) return -1;
				state='i';
			case 'i':	// integer
				if(isdigit(c)) {
					r=10*r+c-'0';
					continue;
				}
				is.unget();
				return r;
			case 'c':	// comment
				if('\n'==c) state='w';
				continue;
		}
	}
	return -1;
}

ppm ppmload(istream& is) {
	int x,y,i;
	ppm img;
	img.data = NULL;
	is.read(Buffer,2);
	if(memcmp(Buffer,"P6",2)) return img;
	img.width=ppmint(is);
	img.height=ppmint(is);
	if(img.width<0 || img.height<0) return img;
	int depth=ppmint(is);
	if(depth!=255) return img;
	img.data = new unsigned char[img.width*img.height];
	if(!img.data) return img;
	is.get();	// blank before data
	for(y=0;y<img.height;y++) {
		for(x=0;x<img.width;x++) {
			i = (255&is.get());
			i += (255&is.get());
			i += (255&is.get());
			img.data[x+y*img.width]=(unsigned char)(i/3);
		}
	}
	return img;
}

