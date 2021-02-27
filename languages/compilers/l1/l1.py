import symPy








import re

def replaceAllNamesOnce(s,names):
    for n in sorted(names.keys(),key=lambda n: -len(n)):
        s = s.split(n)
        o = 0
        for p in range(len(s)-1):
            if len(s[p-o]) and s[p-o][-1].isalnum():
                s[p-o] += n + s[p-o+1]
                del s[p-o+1]
                o += 1
        o = 0
        for p in range(1,len(s)):
            if len(s[p-o]) and s[p-o][0].isalnum():
                s[p-o-1] += n + s[p-o]
                del s[p-o]
                o += 1
        s = names[n].join(s)
    return s
def replaceAllNames(s,names):
    os = s
    s = replaceAllNamesOnce(s,names)
    while os != s:
        os = s
        s = replaceAllNamesOnce(s,names)
    return s

def parseDefs(s,names = {}):
    #first remove all comments (begin with #, end with \n)
    s = ''.join(re.split("(?<!\\)(?:(\\\\)*)#([^\n]+)",s))
    #next parse all names
    ns = s.split("\nname")
    for nc in ns[1:]:
        a = nc.split('\n')[0].split(None,1)
        names[a[0]] = a[1]
    #next apply name defs to name defs
    
    
        
    




#example syntax of routines:




name r8 {a,b,c,d,e,h,l}
name v8 {a,b,c,d,e,h,l,ixh,ixl,iyh,iyl}
name d8 {a,b,c,d,e,h,l,(hl),ixh,ixl,(ix+*),iyh,iyl,(iy+*)}
name ed8 {a,b,c,d,e,h,l,(hl),ixh,ixl,(ix+*),iyh,iyl,(iy+*),(bc),(de),(**)}
name ix {ix,ixh,ixl,(ix+*)}
name iy {iy,iyh,iyl,(iy+*)}
name addr {(**),(hl),(ix+*),(iy+*),(bc),(de)}

def `r1=`r2 -> `r1:
    ;inputs:
    ;`r1 in ed8
    ;`r2 in ed8
    ;vice versa (`r1,`r2){
        ;not( (`r1 in ix) and (`r2 in iy) )
        ;if ( not(`r1 in d8)) then `r2 == a
    ;}
    ;not( (`r1 in addr) and (`r2 in addr) )
    ;returns:
    ;`r1 = `r2
    ;identities:
    ;
    ;precedence:0
    ;assoc:r
    ld `r1,`r2

def ~a -> a:
    ;inputs:
    ;returns:
    ;a = ~a
    ;identities:
    ;precedence:13
    ;assoc:l
    cpl
    
def -a -> a:
    ;inputs:
    ;a:(int8|fix8)
    ;returns:
    ; a = -a
    ;identities:
    ; -a = (~a) + 1 = ~(a - 1)
    ;precedence:12
    ;assoc:l
    neg
    
def a+`r2 -> a:
    ;inputs:
    ;a:int8
    ;`r2:int8 in d8
    ;returns:
    ;a:int8 += `r2
    ;identities: #names here are not registers
    ;a+b = b+a
    ;(a+b)+c = a+(b+c)
    ;a + -a = 0
    ;precedence:10
    ;assoc:l
    add a,`r2
def a-`r2 -> a:
    ;inputs:
    ;a:int8
    ;`r2:int8 in d8
    ;returns:
    ;a:int8 -= `r2
    ;identities: #names here are not registers
    ;a-b = -(b-a)
    ;a-b = a + -b
    ;a-a = 0
    ;precedence:10
    ;assoc:l
    sub `r2

