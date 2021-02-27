
class tra:
    def __init__(self,args,*code):
        self.args = args
        self.code = code

class byte_const:
    def __init__(self,val):
        self.val = val

class byte_var:
    def __init__(self,val, loc):
        self.val = val
        self.loc = loc

class z80Alias:
    def __init__(self):
        self.namespace = {}
        self.regs = [[v,None] for v in ['a','b','c','d','e','h','l']]#for now
        self.code = []
        self.ramStorage = []
        
    def requestByteStorage(self,obj,name,val,priority=0):
        for p in self.regs:
            if p[1] == None:
                var = byte_var(name,p[0])
                self.namespace.update({name:(var,obj,val)})
                p[1] = (var,obj,val)
                
                self.code.push("  ld "+p[0]+","+str(val))
                return var
        for r in range(256):
            if (self.namespace.get(r,None) == None):
                var = byte_var(name,r)
                self.namespace.update({r:(var,obj,val)})
                self.ramStorage.push("var_"+name+":\n.db "+str(val))
                return var
    def free(self,
    def load(self,dest,src):
        if type
