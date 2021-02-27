class var:
    def __init__(self,name,value=None):
        self.name = name
        self.val = value

class instruction:
    def __init__(self,dat=(lambda args: []),args=[]):
        self.dat = dat
        self.args = args
        
    def __len__(self):
        return len(self.dat(self.args))

import re

opcodes = {'nop':instruction(lambda a: [0])}


def matchOpcodes(s,i):
    for o in opcodes:
        m = re.match(o,s[i:])
        if m:
            return opcodes[o](s[i:i+m.end()]),i+m.end()
    return None,i

def assemble(s):
    i = 0
    addr = 0
    def skip_to_next_line():
        while i < len(s) and s[i] != '\n':
            i += 1
        return
    
    while i < len(s):
        
