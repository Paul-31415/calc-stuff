import code

class Type:
    def __init__(self):

class Byte(Type):
    def __init__(self):
        self.size = 1
    def load_const(self,const,name,state):
        r = state.get_free_reg()
        r.free = False
        r.owner = name
        return code('\tld '+r.name+','+str(const)+';loading const')
