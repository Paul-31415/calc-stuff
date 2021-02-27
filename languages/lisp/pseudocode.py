trace = False




def freetree(size):
    return [[-1,1,False,False]]+[["i'm a free node", i + 2, False,False] for i in range(size)]+[["lastFree","NIL",False,False]]


def enc(s):
    if s == '':
        return "00000000000000"
    if len(s) == 1:
        return "0000000"+bin(ord(s)+0x80)[3:]
    return bin(ord(s[1])+0x80)[3:]+bin(ord(s[0])+0x80)[3:]

def tob(ns):
    r = "prog:\n"
    for n in ns:
        r += ".dw "
        c = ""
        if atom(ns,n[0]):
            r += "%0"+enc(n[0])+"1, "
            c += ";"+n[0]
        else:
            r += "%"+bin((1<<16)+n[0]*4)[3:]+", "
        if atom(ns,n[1]):
            r += "%0"+enc(n[1])+"1\t"
            c += ";"+n[1]
        else:
            r += "%"+bin((1<<16)+n[1]*4)[3:]+"\t"
        r += c+"\n"
    return r

def namespace(ns,start):
    if atom(ns,start):#doesnt work with loops but whatev
        return {start}
    return namespace(ns,car(ns,start)) | namespace(ns,cdr(ns,start))
def nameList(ns,s):
    if len(s):
        return cons(ns,s[:2],nameList(ns,s[2:]))
    return "EON"
def setNames(ns,nt,start):
    for i in range(2):
        if atom(ns,ns[start][i]):
            if ns[start][i] in nt:
                ns[start][i] = str(nt[ns[start][i]])
        else:
            setNames(ns,nt,ns[start][i])
def destrNames(ns,start):
    for i in range(2):
        if atom(ns,ns[start][i]):
            try:
                ns[start][i] = int(ns[start][i])
            except:
                pass
        else:
            destrNames(ns,ns[start][i])
    
def compile(ns):
    #convert prog to the other format
    #ns[0] = (root . free) √
    #root = (prog stack)
    #prog = what you expect
    #but symbols are not
    if type(ns[0][0]) == str:
        ns[0][0] = cons(ns,nameList(ns,ns[0][0]),"NIL")
    else:
        names = namespace(ns,ns[0][0])
        nameTable = dict()
        for n in names:
            nameTable.update({n:cons(ns,nameList(ns,n),"NIL")})
        setNames(ns,nameTable,ns[0][0])
        #convert numbernames back into names
        destrNames(ns,ns[0][0])
    return tob(ns)
    






    

        

def tis(n,m):
    if type(n) == type(m):
        return n*m
    return n
def to1dNodes(ns):
    r=[]
    for n in ns:
        r += [[tis(n[0],2),n[2]],[tis(n[1],2),n[3]]]
    return r


def gc_mark_tail_call2(nodes,n=0,prev=-1):
    return gc_mark_tail_call2_d(nodes,n,prev)

def gc_mark_tail_call2_d(nodes,n,prev,cameFromBelow=False):
    print("-",n,prev)
    if (n&1 and not cameFromBelow) or not nodes[n&~1][1]:
        nodes[n&~1][1] = True
        nextN = nodes[n][0]
        if atom(nodes,nextN):
            if n&1 == 0:
                return gc_mark_tail_call2_d(nodes,n|1,prev)
            return gc_mark_tail_call2_a(nodes,n,prev)
        print("V",n,prev)
        nodes[n][0] ^= prev
        return gc_mark_tail_call2_d(nodes,nextN,n)
    if n&1 == 0:
        return gc_mark_tail_call2_d(nodes,n|1,prev)
    return gc_mark_tail_call2_a(nodes,n,prev)
def gc_mark_tail_call2_a(nodes,n,prev):
    print("^",n,prev)
    if prev == -1:
        return
    #climb up from n
    pprev = nodes[prev][0] ^ (n&~1) #note n&1 always is 1 when this is called
    nodes[prev][0] = n&~1
    return gc_mark_tail_call2_d(nodes,prev,pprev,True)







def gc(nodes):
    gc_premark(nodes)
    gc_mark(nodes,0)
    return gc_sweep(nodes)
def gc_premark(nodes):
    for n in range(len(nodes)):
        nodes[n][2] = False
def gc_mark(nodes,n=0):
    if not(atom(nodes,n)) and not(nodes[n][2]):
        nodes[n][2] = True
        gc_mark(nodes,nodes[n][0])
        gc_mark(nodes,nodes[n][1])






        
def gc_mark_tail_call(nodes,n=0,prev=-1):
    return gc_mark_tail_call_addr(nodes,n,prev)

def gc_mark_tail_call_addr(nodes,n,prev):
    if not nodes[n][2]:
        nodes[n][2] = True
        nextN = nodes[n][0]
        if atom(nodes,nextN):
            return gc_mark_tail_call_dec(nodes,n,prev)
        nodes[n][0] ^= prev
        return gc_mark_tail_call_addr(nodes,nextN,n)
    return gc_mark_tail_call_dec(nodes,n,prev)
def gc_mark_tail_call_dec(nodes,n,prev):
    if not nodes[n][3]:
        nodes[n][3] = True
        nextN = nodes[n][1]
        if atom(nodes,nextN):
            return gc_mark_tail_call_climb(nodes,n,prev)
        nodes[n][1] ^= prev
        return gc_mark_tail_call_addr(nodes,nextN,n)
    return gc_mark_tail_call_climb(nodes,n,prev)
def gc_mark_tail_call_climb(nodes,n,prev):
    if prev == -1:
        return
    #climb up from n
    i = nodes[prev][3]
    pprev = nodes[prev][i] ^ n
    nodes[prev][i] = n
    return gc_mark_tail_call_addr(nodes,prev,pprev)

    
    

        
def gc_mark_stackless(nodes,n=0):
    fromNode = -1
    while n != -1:
        while not(atom(nodes,n)) and not(nodes[n][3]):
            while not(atom(nodes,n)) and not(nodes[n][2]):
                nodes[n][2] = True
                if not(atom(nodes,nodes[n][0])):
                    #loop on nodes[n][0]
                    print("looping on addr of node "+str(n)+" "+str(nodes[n]))
                    print("from " + str(fromNode)+" "+str(nodes[fromNode]))
                    toNode = nodes[n][0]
                    nodes[n][0] ^= fromNode
                    fromNode = n
                    n = toNode

            #back up 1 and try the decrement
            #rn fromNode is last valid node pos
            #   n is the invalid node
            #nodes[fromNode][0] is n ^ fromfromNode
            if fromNode == -1:
                return
            print("backing up to "+str(fromNode)+" "+str(nodes[fromNode])+
                  " from "+str(n)+" "+str(nodes[n]))
            fromfromNode = nodes[fromNode][0] ^ n
            nodes[fromNode][0] = n
                    
            #rn nodes[fromNode][0] is restored
            #fromfromNode is where we got to fromNode from
            #fromNode still needs the decrement branch checked
            
            #var shuffle to make it like prev code
            n = fromNode
            fromNode = fromfromNode
            

            #set dec flag
            nodes[n][3] = True
            if not(atom(nodes,nodes[n][1])):
                print("looping on dec of node "+str(n)+" "+str(nodes[n]))
                #loop on nodes[n][1]
                toNode = nodes[n][1]
                nodes[n][1] ^= fromNode
                fromNode = n
                n = toNode
        #here both branches have terminated, we go up 
        # most recent terminated branch was the decrement one
        fromfromNode = nodes[fromNode][1] ^ n
        nodes[fromNode][1] = n
        
        n = fromNode
        fromNode = fromfromNode
        #now n is a finished node
        
        #go up 1
        #problem is how do we know which term we came from?
        #solution: two gc flags
        # if only addr set, we came from addr so i should be 0
        # if dec also set, we came from dec, so i should be 1
        i = nodes[fromNode][3]
        fromfromNode = nodes[fromNode][i] ^ n
        nodes[fromNode][i] = n
        
        #rn fromfromNode is parent of the node we just restored
        #   fromNode is node we just restored
        #   n is a finished node
        print("climbing from "+str(n)+" "+str(nodes[n])+" to "+str(fromNode)+" "+str(nodes[fromNode]))
        #varshuff to make n be the node we just restored
        n = fromNode
        fromNode = fromfromNode
        
        #loop until we go up the root
    return


def gc_sweep(nodes):
    num = 0
    for n in range(1,len(nodes)):
        if not nodes[n][2]:
            pushFree(nodes,n)
            num += 1
    return num

def pushFree(nodes,n):
    nodes[n][1] = nodes[0][1]
    nodes[n][2] = False
    nodes[0][1] = n
    

def getNewNode(nodes):
    ans = nodes[0][1]
    if null(nodes,ans):
        print("out of memory")
        input("[ENTER] for gc:")
        frd = gc(nodes)
        print("gc freed "+str(frd)+" nodes.")
        if frd == 0:
            print("out of memory... expand memory by how many cells? (min 1)")
            e = int(input("?:"))
            nodes[0][1] = len(nodes)
            nodes += [["newMem",len(nodes)+i+1,False,False] for i in range(e-1)] + [["memEnd","NIL",False,False]]
        return getNewNode(nodes)
    nodes[0][1] = cdr(nodes,ans)
    return ans


def car(nodes,node):
    if trace:
        print("car "+repr(node))
    return nodes[node][0]
def cdr(nodes,node):
    if trace:
        print("cdr "+repr(node))
    return nodes[node][1]
def cons(nodes,arg1,arg2):
    if trace:
        print("cons "+repr(arg1) + " "+repr(arg2))
    ans = getNewNode(nodes)
    nodes[ans][0] = arg1
    nodes[ans][1] = arg2
    return ans
def atom(nodes,node):
    if trace:
        print("atom "+repr(node))
    return type(node) == type("atom")
def eq(nodes,a1,a2):
    if trace:
        print("eq "+repr(a1) +" "+ repr(a2))
    return a1 == a2
def null(nodes,v):
    if trace:
        print("null "+repr(v))
    return v == "NIL" 

def equal(nodes,x,y):
    if trace:
        print("equal "+repr(x) + " " + repr(y))
    if atom(nodes,x):
        return atom(nodes,y) and eq(nodes,x,y)
    return equal(nodes,car(nodes,x),car(nodes,y)) and equal(nodes,cdr(nodes,x),cdr(nodes,y))

def pairlis(nodes,x,y,a):
    if trace:
        print("pairlis "+repr(x) + " " + repr(y)+" "+repr(a))
    if null(nodes,x):
        return a
    return cons(nodes,cons(nodes,car(nodes,x),car(nodes,y)),pairlis(nodes,cdr(nodes,x),cdr(nodes,y),a))
def assoc(nodes,x,a):
    if trace:
        print("assoc "+repr(x) + " "+repr(a))
    if equal(nodes,car(nodes,car(nodes,a)),x):
        return car(nodes,a)
    return assoc(nodes,x,cdr(nodes,a))

def evalquote(nodes,fn,x):
    return lapply(nodes,fn,x,"NIL")

def lapply(nodes,fn,x,a):
    if trace:
        print("nodes:"+repr(nodes)+"\napply "+repr(fn) + " " + repr(x)+" "+repr(a))
    if atom(nodes,fn):
        if eq(nodes,fn,"CAR"):
            return car(nodes,car(nodes,x))
        if eq(nodes,fn,"CDR"):
            return cdr(nodes,car(nodes,x))
        if eq(nodes,fn,"CONS"):
            return cons(nodes,car(nodes,x),car(nodes,cdr(nodes,x)))
        if eq(nodes,fn,"ATOM"):
            return atom(nodes,car(nodes,x))
        if eq(nodes,fn,"EQ"):
            return eq(nodes,car(nodes,x),car(nodes,cdr(nodes,x)))
        return lapply(nodes,leval(nodes,fn,a),x,a)
    if eq(nodes,car(nodes,fn),"LAMBDA"):
        return leval(nodes,car(nodes,cdr(nodes,cdr(nodes,fn))),
                     pairlis(nodes,car(nodes,cdr(nodes,fn)),x,a))
    if eq(nodes,car(nodes,fn),"LABEL"):
        return lapply(nodes,car(nodes,cdr(nodes,cdr(nodes,fn))),
                      x,cons(nodes,cons(nodes,car(nodes,cdr(nodes,fn)),car(nodes,cdr(nodes,cdr(nodes,)))),a))



def leval(nodes,e,a):
    if trace:
        print("nodes:"+repr(nodes)+"\neval "+repr(e)+" "+repr(a))
    if atom(nodes,e):
        return cdr(nodes,assoc(nodes,e,a))
    if atom(nodes,car(nodes,e)):
        if eq(nodes,car(nodes,e),"QUOTE"):
            return car(nodes,cdr(nodes,e))
        if eq(nodes,car(nodes,e),"COND"):
            return evcon(nodes,cdr(nodes,e),a)
        return lapply(nodes,car(nodes,e),evlis(nodes,cdr(nodes,e),a),a)
    return lapply(nodes,car(nodes,e),evlis(nodes,cdr(nodes,e),a),a)

def evcon(nodes,c,a):
    if trace:
        print("evcon "+repr(c) + " " + repr(a))
    if "T" == leval(nodes,car(nodes,car(nodes,c)),a):
        return leval(nodes,car(nodes,cdr(nodes,car(nodes,c))),a)
    return evcon(nodes,cdr(nodes,c),a)

def evlis(nodes,m,a):
    if trace:
        print("evlis "+repr(m) + " " + repr(a))
    if null(nodes,m):
        return "NIL"
    return cons(nodes,leval(nodes,car(nodes,m),a),evlis(nodes,cdr(nodes,m),a))

def pr(nodes,code):
    nodes[0][0] = parse(nodes,code)
    

def parse(nodes,code):
    #whitespace sensative
    if len(code) == 0:
        return "NIL"
    if code[0] == "(":
        #list or (a . b) or (a b . c)
        groups = [""]
        parens = 0
        for c in code[1:-1]:
            if c == "(":
                parens += 1
            if c == ")":
                parens -= 1
            if c == " " and parens == 0:
                groups += [""]
            else:
                groups[-1] += c
        if len(groups) == 1:
            if groups[0] == "":
                return "NIL"
            return cons(nodes,parse(nodes,groups[0]),"NIL")
        pgs = [parse(nodes,g) for g in groups if g != "."]
        if groups[-2] != ".":
            pgs += ["NIL"]
        r = cons(nodes,pgs[-2],pgs[-1])
        for i in range(3,len(pgs)+1):
            r = cons(nodes,pgs[-i],r)
        return r
    #here we assume its an atom
    return code


def run(nodes):
    return evalquote(nodes,car(nodes,car(nodes,0)),cdr(nodes,car(nodes,0)))


    
    
    
