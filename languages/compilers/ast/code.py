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