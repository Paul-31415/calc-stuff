class scope:
    def __init__(self,p = None,c = []):
        self.parent = p
        self.contents = c
    def __contains__(self,other):
        s = self
        while s != None:
            if other in s.contents:
                return True
            s = s.parent
        return False
    def getLevel(self,obj):
        s = self
        while s != None:
            if obj in s.contents:
                i = 0
                while s != None:
                    i += 1
                    s = s.parent
                return i
            s = s.parent
        return -1
    def add(self,obj):
        return self.contents.append(obj)

class variable:
    def __init__(self,name):
        self.name = name
    def __eq__(self,other):
        return self.name == other.name
    def __repr__(self):
        return "var:"+self.name

class fixedSizeVar(variable):
    def __init__(self,name,bits):
        super().__init__(name)
        self.size = bits

class byteVar(fixedSizeVar):
    def __init__(self,name):
        super().__init__(name,8)





        
class state:
    def __init__(self):
        self.includedLibs = set()
        self.scope = scope()
        self.registers = {}
    def alloc(self,reg,var):
        for c in reg:
            self.registers[c] = var
    def deAllocAndStore(self,reg):



        del self.regAssocs[reg]

class code:
    def __init__(self,asmCode = [],globalVars = [],libCode = []):
        def classify(lines):
            res = []
            for line in lines:
                if line.find(';') > -1:
                    res.append([line[:line.find(';')],False])
                    res.append([line[line.find(';'):],True])
                else:
                    res.append([line,False])
            return res
        
        if type(asmCode) == type([]):
            self.content = asmCode
        else:
            self.content = classify(['\n' + l for l in asmCode.split('\n')])
        if type(globalVars) == type([]):
            self.gvars = globalVars
        else:
            self.gvars = classify(['\n' + l for l in globalVars.split('\n')])
        if type(libCode) == type([]):
            self.libs = libCode
        else:
            self.libs = classify(['\n' + l for l in libCode.split('\n')])
        
    def get(self,comment=True,libs = True,doVars = True):
        r = ''
        for i in range(len(self.content)):
            if comment and self.content[i][1]:
                r += self.content[i][0]
            elif not self.content[i][1]:
                r += self.content[i][0]
        if doVars:
            if comment:
                r += '\n\n;start of global fixed-length vars\n'
            for i in range(len(self.gvars)):
                if comment and self.gvars[i][1]:
                    r += self.gvars[i][0]
                elif not self.gvars[i][1]:
                    r += self.gvars[i][0]
        if libs:
            if comment:
                r += '\n\n;start of libs\n'
            for i in range(len(self.libs)):
                if comment and self.libs[i][1]:
                    r += self.libs[i][0]
                elif not self.libs[i][1]:
                    r += self.libs[i][0]
        return r
    def __add__(self, other):
        return code(self.content+other.content,self.gvars + other.gvars,self.libs+other.libs)


class ast:
    def __init__(self,*childs):
        self.children = childs
    
    def get_code(self,state):
        r = code([])
        for c in self.children:
            tmpCode,state = c.get_code(state)
            r += tmpCode
        return r,state
    
class codeNode(ast):
    def __init__(self,c):
        self.code = c
    def get_code(self,state):
        return self.code,state

class inlineAsm(codeNode):
    def __init__(self,c,v=[],l=[]):
        super().code = code(c,v,l)



class variableDeclarationNode(ast):
    def __init__(self,var):
        self.var = var
    def get_code(self,state):
        if self.var in state.scope.contents:
            raise "already exists in this locality!"
        else:
            state.scope.add(self.var)
        return code(),state
