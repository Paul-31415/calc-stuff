#!/usr/bin/env python3

#http://merthsoft.com/linkguide/ti83+/fformat.html

import argparse

parser = argparse.ArgumentParser(description='Wrap a binary as a minified assembly program.')
parser.add_argument('--input',"-i", metavar='inp', type=str,
                    help='input bin file',required = True)

parser.add_argument('--output',"-o", metavar='out', type=str,
                    help='output file name',required = True)

parser.add_argument('--name',"-n", metavar='name', type=str,
                    help='ti var name',required = True)

args = parser.parse_args()

header = b"**TI83F*\x1a\x0a\0"+b'\0'*42

vdata = open(args.input,'rb').read()

import struct

data = b'\x0d\0'+struct.pack("<H",len(vdata)+2)+b'\x06'+struct.pack("<8s",bytes(args.name,'ascii'))+b"\0\0"+\
    struct.pack("<H",len(vdata)+2)+struct.pack("<H",len(vdata))+vdata
chk = sum(data)

open(args.output,"wb").write(header + struct.pack("<H",len(data)) + data + struct.pack("<H",chk&0xffff))
