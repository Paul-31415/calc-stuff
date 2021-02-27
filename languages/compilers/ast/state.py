class register:
    def __init__(self,name,free = True,owner = None):
        self.name = name
        self.free = free
        self.owner = owner

class memVar:
    def __init__(self,name,size=1,up_to_date=True):
        self.name = name
        self.valid = up_to_date
        self.size = size

class stackVar:
    def __init__(self,name,offset,size=1,up_to_date=True):
        self.name = name
        self.offset = offset
        self.size = size
        self.valid = up_to_date
        
class state:
    
    def __init__(self):
        self.registers = [register(r) for r in 'abcdehl']
        self.memVars = []
        self.stackVars = []

    def get_free_reg(self):
        for r in self.registers:
            if r.free:
                return r
        raise 'no free regs'
    
