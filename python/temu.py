def siemu(code,regs = [0,0,0,0,0,0,0,0],rk = "abcdefhl"):
    carry = 0
    ins = [l for l in code.split("\n")]
    labels = dict()
    for i in range(len(ins)):
        l = ins[i]
        if ":" in l:
            labels[l.split(":")[0]] = i
    pc = 0

    def pa(a):
        if a[0] in "#$":
            return eval("0x"+a[1:])
        elif a[0] in rk:
            r = 0
            for rg in a:
                r <<= 8
                r += regs[rk.index(rg)]
            return r
        else:
            return int(a)
    def sto(a,p):
        for r in a[::-1]:
            regs[rk.index(r)] = p&0xff
            p >>= 8
            
    while 1:
        l = ins[pc]
        pc += 1
        cd = l.split(";")[0]
        ignore = input(" ".join([f"{rk[i]}={bs(regs[i],8)}" for i in range(len(rk))])+f" {[' ','c'][carry]} |{str(10000+pc)[1:]}| {l}")
        if len(cd):
            if cd[0] == " ":
                while cd[0] == " ":
                    cd = cd[1:]
                o = cd.split(" ")
                if o[0] == "ld":
                    a = o[1].split(",")
                    sto(a[0],pa(a[1]))
                elif o[0] == 'or':
                    carry = 0
                    regs[rk.index("a")] |= pa(o[1])&0xff
                elif o[0] == "sbc":
                    a = o[1].split(",")
                    r = pa(a[0])-(pa(a[1])+carry)
                    carry = (r&0x10000) != 0
                    sto(a[0],r)
                elif o[0] == "add":
                    a = o[1].split(",")
                    r = pa(a[0])+pa(a[1])
                    carry = (r&(1<<(8*len(a[0])))) != 0
                    sto(a[0],r)
                elif o[0] == "adc":
                    a = o[1].split(",")
                    r = pa(a[0])+pa(a[1])+carry
                    carry = (r&(1<<(8*len(a[0])))) != 0
                    sto(a[0],r)
                elif o[0] == "ccf":
                    carry = not carry
                elif o[0] == "rl":
                    r = (pa(o[1])<<1) + carry
                    carry = r>>8
                    sto(o[1],r)
                elif o[0] == "jr":
                    c,l = o[1].split(",")
                    if carry^([0,1][c == "nc"]):
                        pc = labels[l]
                elif o[0] == "djnz":
                    sto('b',(pa('b')-1)&0xff)
                    if pa('b'):
                        pc = labels[o[1]]
                elif o[0] == "ret":
                    return regs
                else:
                    print("unknown",o)
                    
        

code = """
;
; Square root of 16-bit value
; In:  HL = value
; Out:  D = result (rounded down)
;
Sqr16:
    ld de,#0040
    ld a,l
    ld l,h
    ld h,d
    or a
    ld b,8
Sqr16_Loop:
    sbc hl,de
    jr nc,Sqr16_Skip
    add hl,de
Sqr16_Skip:
    ccf
    rl d
    add a,a
    adc hl,hl
    add a,a
    adc hl,hl
    djnz Sqr16_Loop
    ret
"""



def bs(b,l=8):
    m = 1<<l
    return bin(b&(m-1)|m)[3:]
def hs(n,l=2):
    m = 1<<(l*4)
    return hex(n&(m-1)|m)[3:]
class uint8:
    def __init__(self,v):
        self.v = int(v)&0xff
    def __repr__(self):
        return f"u8 {hs(self.v)} {bs(self.v)} {self.v}"
    def __int__(self):
        return self.v
    def __add__(self,o):
        return uint8(self.v+int(o))
    def __sub__(self,o):
        return uint8(self.v-int(o))
    def __neg__(self,o):
        return uint8(-self.v)
    def __not__(self,o):
        return uint8(~self.v)
    def __and__(self,o):
        return uint8(self.v&int(o))
    def __or__(self,o):
        return uint8(self.v|int(o))
    def __xor__(self,o):
        return uint8(self.v^int(o))
    def rr(self):
        return uint8((self.v>>1) | (self.v<<7))
    def rl(self):
        return uint8((self.v<<1) | (self.v>>7))
    def sra(self):
        return uint8((self.v>>1) | (self.v&0x80))
    def sla(self):
        return uint8(self.v<<1)
    def sll(self):
        return uint8((self.v<<1)|1)
    def srl(self):
        return uint8(self.v>>1)
    
