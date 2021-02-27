


def define_operation(




















#ehh, just make a modified BNF matcher that returns payloads
#that way :
def ind(v,arr):
    if v in arr:
        return arr.index(v)+1
    return False
# (` quotes python lambda that is run on the input)
# <r8> ::= `lambda x: ind(x,('b','c','d','e','h','l','(hl)','a'))`
# <r16> ::= `lambda x: ind(x,('bc','de','hl','sp'))`

"""

def repr(*o):
    return o[0].__repr__(*o[1:])
def str(*o):
    return o[0].__str__(*o[1:])
def asm(o):
    return o.asm()
class arg:
    def __init__(self):
        pass
    def __repr__(self):
        return "<abstract arg>"
    def __str__(self):
        return ";<abstract arg>"
    def asm(self):
        raise Exception("abstract arg assembled")
        return -1
    
class imm(arg):
    def __init__(self,val,bits=8):
        self.val = val
        self.bits=8
    def __repr__(self):
        return "imm"+str(self.bits)+":"+repr(self.val)
    def __str__(self):
        return str(self.val)
    def asm(self):
        def f(v):
            return (v%(1<<self.bits))
        if type(self.val) == int:
            return f(self.val)
        else:
            return f(asm(self.val))
reg8s = ["b","c","d","e","h","l","(hl)","a","(bc)","(de)",None,"(**)","ixh","ixl","iyh","iyl","i","r"]
class r8(arg):
    def __init__(self,which):
        self.r = reg8s[which]
        self.rid = which
    def normal(self):
        return self.rid<8
    def decontext(self):
        if self.contexted():
            return r8((self.rid%2)+4)
        else:
            return self
    def ix(self):
        return (self.rid&-2) == 12
    def iy(self):
        return (self.rid&-2) == 14
    def contexted(self):
        return (self.rid&-4) == 12
    def context(self):
        return ((self.rid//2)-5)*self.contexted()
    def __repr__(self,context="",offs=imm(0)):
        if self.r == "(hl)" and len(context):
            return "r8:("+context+"+"+repr(offs)")"
        else:
            return "r8:"+context+self.r
    def __str__(self,context="",offs=imm(0)):
        if self.r == "(hl)" and len(context):
            return "("+context+"+"+str(offs)+")"
        else:
            return context+self.r
    def asm(self):
        return self.rid
    def __eq__(self,other):
        if type(other) == r8:
            return self.r == other.r
        elif type(other) == int:
            return self.rid == other
        else:
            return self.r == other

reg16s = ["bc","de","hl","sp"]
class r16(arg):
    def __init__(self,which):
        self.r = reg16s[which]
        self.rid = which
    def __repr__(self,context=""):
        if self.r == "hl" and len(context):
            return "r16:"+context
        else:
            return "r16:"+self.r
    def __str__(self,context=""):
        if self.r == "hl" and len(context):
            return context
        else:
            return self.r
    def asm(self):
        return self.rid
    
class op:
    def __init__(self,):
        pass
    def __repr__(self):
        return "<abstract opcode>"
    def __str__(self):
        return ";<abstract opcode>"
    def asm(self):
        raise Exception("err: tried to asm abstract opcode")
        return -1
ld_defs = \"""
#ld {r8:dest},{r8:src}
dest.normal() and src.normal() and not (src == dest and src == '(hl)') : 
    0x40 + asm(dest)*8 + asm(src);
src == 'a' and dest in ('(bc)','(de)','(**)'):
    0x02 + 16*(asm(dest)-8);
dest == 'a' and src in ('(bc)','(de)','(**)'):
    0x0a + 16*(asm(dest)-8);
src == 'a' and dest in ('i','r'):
    0xED47 + 8*(dest == 'r');
dest == 'a' and src in ('i','r'):
    0xED57 + 8*(dest == 'r');
(src.contexted() ^ dest.contexted()) or (src.context() == dest.context()):
    (0xDD + ((src.context() | dest.context())-1)*0x20<<8) + `ld 

"""

