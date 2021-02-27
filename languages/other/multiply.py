def toBytes(n):
    r = []
    while n:
        r += [n&0xff]
        n >>= 8
    return r

def mul(a,b):
    c = 0
    mbl = 0
    for d in range(len(a)+len(b)):
        ai = min(len(a)-1,d)
        bi = d-ai
        if c>0xffff:
            print("enter overflow")
        while bi < len(b) and ai >= 0:
            c += a[ai]*b[bi] #3 bytes here is enough for 256 byte numbers
            mbl = max(mbl,c.bit_length())
            if c>0xffffff:
                print("overflow")
            ai -= 1
            bi += 1
        yield c&0xff
        c >>= 8
    while c:
        yield c&0xff
        c >>= 8
    print("carry size:",mbl,"bits.")
    return mbl

def mulmbl(a,b):
    a = [255]*a
    b = [255]*b
    c = 0
    mbl = 0
    for d in range(len(a)+len(b)):
        ai = min(len(a)-1,d)
        bi = d-ai
        while bi < len(b) and ai >= 0:
            c += a[ai]*b[bi]
            mbl = max(mbl,c.bit_length())
            ai -= 1
            bi += 1
        c >>= 8
    return mbl

def maxIntSizes(mb=32):
    i = 1
    n = 16
    while n < mb:
        b = mulmbl(i,i)
        while b > n:
            yield (n,i-1)
            n += 1
        i += 1


def mul2(a,b):
    c = 0
    di = len(a)+len(b)
    ai = 0
    bi = 0
    while di > 0:
        
        while ai>=0 and bi<len(bi):
            c += a[ai]*b[bi] 
            ai -= 1
            bi += 1
        if ai < 0:
            ai += 1
        else:
            ai += 2
            bi -= 1
            
        yield c&0xff
        c >>= 8

        a,b = b,a
        ai,bi = bi,ai
        
        di-=1
         
    while c:
        yield c&0xff
        c >>= 8


        
def fromGen(g):
    r = 0
    p = 1
    for n in g:
        r += p*n
        p <<= 8
    return r
