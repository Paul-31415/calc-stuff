def notes_to_freqs(notes,offset=440/8):
    for n in notes:
        i = [0,2,3,5,7,8,10][['a','b','c','d','e','f','g'].index(n[0])]
        if n[1] in '1234567890':
            i += 12*eval(n[1:])
        else:
            i += (n[1] == "#") - (n[1] == 'b')
            i += 12*eval(n[2:])
        f = 2**(i/12)
        yield f*offset

def freqs_to_bytes(freqs,scale=1/220):
    for f in freqs:
        yield hex(round(f*scale))

def freqs_to_mods(freqs,scale=1):
    for f in freqs:
        yield hex(round(scale/f))

            
