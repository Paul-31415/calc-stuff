import math
tbl = [math.log(1+2**-i)/math.log(2) for i in range(60)]
def ilog2(a):
    i = 0
    while a > 2:
        a /= 2.
        i += 1
    else:
        while a < 1:
            a *= 2.
            i -= 1
    return i,a

def log2(a,prec=56):
    e,a = ilog2(a)
    s = 0
    p = 1
    a -= p
    for k in range(prec):
        t = p*(2**-k) 
        if t < a:
            p += t
            a -= t
            s += tbl[k]
    return e,s
        
