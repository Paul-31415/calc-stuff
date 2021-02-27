
def h(s):
    t = 0
    for c in s:
        t ^= ord(c)
        t = ((t << 1) | ((t&0xff) >> 7))&0xff
    return t

class htest():
    def __init__(self,h,mod):
        self.l = [None for i in range(mod)]
        self.h = h
    def get(self,s):
        return self.l[self.h(s)%len(self.l)]
    def set(self,s):
        r = self.l[self.h(s)%len(self.l)]
        self.l[self.h(s)%len(self.l)] = s
        return r
    
def bench(a,l):
    for i in range(26**l):
        s = ''
        for d in range(l):
            s += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(i//(26**d))%26]
        a.set(s)
    return a.l.count(None)
                   
