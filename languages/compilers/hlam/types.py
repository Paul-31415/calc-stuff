import * from hla
types = {}
class Byte:
    def __init__(self,name=None,value=None):
        self.location = requestByteStorage(self,name,value)
        self.useDefaultOpsWith = (Byte,)

types.update({"Byte":Byte})



class Q:
    def __init__(self,m1,m2):
        self.m = int(m1)
        self.f = int(m2)
        self.size = self.m+self.f

  
types.update({"Q([+-]?[0-9]+).([+-]?[0-9]+)":Q})


  
  
