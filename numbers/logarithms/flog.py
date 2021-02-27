import math
class flog:
    def __init__(self,n,mant=23):
        self.sign = n < 0
        self.mant = mant
        if (n == None):
            self.i = 0
        else:
            self.i = int(math.log(abs(n))/math.log(2)*(1<<mant))

    def __repr__(self):
        s = 'flog('+str((-2*self.sign+1)*(2**(self.i*1./(1<<self.mant))))
        if self.mant != 23:
            s += ','+str(self.mant)
        return s + ')'
    
    def __mul__(self,other):
        o = other
        if type(other) != type(self):
            o = flog(other)
        r = flog(None,max(self.mant,o.mant))
        i = (self.i,o.i)
        if self.mant < o.mant:
            i = (o.i,self.i)
        r.i = (i[1] << abs(self.mant-o.mant)) + i[0]
        r.sign = self.sign ^ o.sign
        return r

    def __div__(self,other):
        o = other
        if type(other) != type(self):
            o = flog(other)
        r = flog(None,max(self.mant,o.mant))
        i = (self.i,-o.i)
        if self.mant < o.mant:
            i = (-o.i,self.i)
        r.i = (i[1] << abs(self.mant-o.mant)) + i[0]
        r.sign = self.sign ^ o.sign
        return r

    def __add__(self,other):
        o = other
        if type(other) != type(self):
            o = flog(other)

        
    
            
