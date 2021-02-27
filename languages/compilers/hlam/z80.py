class byte:
    def __init__(self,v=0):
        self.v = v & 0xff;
    def __repr__(self):
        return "byte("+self.v")"
    def __str__(self,mode='hex'):
        if mode == 'hex':
            return hex(0x100+self.v)[3:]
        elif mode == 'dec':
            return str(self.v)
        elif mode == 'sdec':
            return str((self.v&0x80)*-0x100+self.v)
        elif mode == 'bin':
            return bin(0x100+self.v)[3:]
        elif mode == 'ascii':
            return chr(self.v)
        else:
            return repr(self)
    def set(self,v):
        self.v = v&0xff
    def b(self,n):
        return self.v&(1<<n)

    
                 
    
class z80:
    def __init__(self):
        self.time = 0
        self.ram = [byte(0) for i in range(65536)]
        self.a = byte(0)
        self.b = byte(0)
        self.c = byte(0)
        self.d = byte(0)
        self.e = byte(0)
        self.f = byte(0)
        self.h = byte(0)
        self.l = byte(0)
        self.a = byte(0)
        self.r = byte(0)
        self.i = byte(0)
        self.ixh = byte(0)
        self.ixl = byte(0)
        self.iyh = byte(0)
        self.iyl = byte(0)
        self.sp = (byte(0),byte(0))
        self.pc = (byte(0),byte(0))
    def fetch_reg(self,thing):
        regs = {'a':self.a,
                'b':self.b,
                'c':self.c,
                'd':self.d,
                'e':self.e,
                'f':self.f,
                'h':self.h,
                'l':self.l,
                'ixh':self.ixh,
                'ixl':self.ixl,
                'iyh':self.iyh,
                'iyl':self.iyl,
                'r':self.r,
                'i':self.i,
                'af':(self.a,self.f),
                'bc':(self.b,self.c),
                'de':(self.d,self.e),
                'hl':(self.h,self.l),
                'ix':(self.ixh,self.ixl),
                'iy':(self.iyh,self.iyl),
                'sp':self.sp,
                'pc':self.pc}
        return reg.get(thing,());
    def fetch_mem(self,addr):
        return this.ram[addr%65536]
        
    def incR(self):
        self.r.v = (self.r.v+1)&0x7f | self.r.b(7)


def add(a,b):
    r = a.v+b.v
    return (byte(r),
            {'s':0!=(r&0x80),
             'z':0==(r&0xff),
             'f5':0!=(r&0x20),
             'h':0!=((a.v&0xf+b.v&0xf)&0x10),
             'f3':0!=(r&0x8),
             'p/v':(a.b(7)==b.b(7)) and (r&0x80 != a.b(7)),
             'n':False,
             'c':0!=(r&0x100)})
def sub(a,b):
    r = a.v-b.v
    return (byte(r),
            {'s':0!=(r&0x80),
             'z':0==(r&0xff),
             'f5':0!=(r&0x20),
             'h':0!=((a.v&0xf+b.v&0xf)&0x10),
             'f3':0!=(r&0x8),
             'p/v':(a.b(7)==b.b(7)) and (r&0x80 != a.b(7)),
             'n':False,
             'c':0!=(r&0x100)})
