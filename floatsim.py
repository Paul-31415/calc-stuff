

class sfloat():

    def __init__(self,num):
        self.s = ((num & 0x80000000) == 0)*2-1
        self.e = (num>>23)&0xff
        self.m = num & 0x007fffff | (self.e != 0)<<23
        self.b = 0x01000000 >> (self.e == 0)
        self.o = 0x7f
        
    def __repr__(self):
        res = ''
        if self.s == -1:
            res += '-'
        res += bin(self.b + self.m)[3]+'.'+bin(self.b + self.m)[4:]+' '
        res += 'b'+str(self.e-self.o)
        return res

    def __add__(self,other): #lazy so only add with other floats
        if self.e-self.o < other.e-other.o:
            return other.__add__(self)
        r = sfloat(0)
        r.m = (((other.b*self.s*self.m) << (self.e-self.o-(other.e-other.o))) + self.b*other.s*other.m)//min(self.b,other.b)
        if r.m < 0:
            r.m = -r.m
            r.s = -1
        r.b = (max(self.b,other.b)<<(self.e-self.o-(other.e-other.o)))
        r.e = self.e
        r.o = self.o
        if r.m & r.b:
            r.e += 1
            r.b <<= 1
        r.normalize()
        return r

    def __neg__(self):
        r = sfloat(0)
        r.o = self.o
        r.e = self.e
        r.m = self.m
        r.b = self.b
        r.s = -self.s
        return r
    def __sub__(self,other):
        return self+(-other)

    def __hex__(self): #returns the input number
        b = -(-self)
        b.round(self.b.bit_length()-25)
        b.e -= b.o - 127
        b.o += 127 - b.o
        n = (b.m & ((b.b-1)>>1))|((b.e & 0xff)<<23)|(0x80000000 * (b.s != 1))
        return '0x'+hex(0x100000000+n)[3:]
        

    
    def normalize(self):
        if self.m == 0:
            self.e = 0
        while self.e > 0 and (((self.b>>1) & self.m) == 0):
            self.e -= 1
            self.b >>=1
            
    def truncate(self,n):
        self.b >>=n
        self.m >>=n
        return self
    def round(self,n):
        if n > 0:
            r = self.m & ((1<<n)-1)
            s = self.truncate(n)
            tr = r>>(n-1)
            r = r - (tr<<(n-1))
            if tr:
                if r:
                    self.m += 1
                if self.m&1:
                    self.m += 1
            if self.m & self.b:
                self.e += 1
                self.b <<= 1
            return self
        else:
            if n == 0:
                return self
            self.b <<= -n
            self.m <<= -n
            return self
            
        
        
    def __mul__(self,other):
        r = sfloat(0)
        r.s = self.s*other.s
        r.e = self.e + other.e
        r.o = self.o + other.o
        r.m = self.m * other.m
        r.b = self.b * other.b >> 1
        if r.m & r.b:
            r.e += 1
            r.b <<= 1
        return r
        
