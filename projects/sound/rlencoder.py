
def encSong(toneGen):
    



def encTone(gen):
    prev = -1
    num = 0
    output = ""
    for i in gen:
        if prev == -1:
            prev = i
        if i != prev or num == 15:
            output += "\n.db %"+bin(16+num)[3:]+bin(16+prev)[3:]
            prev = i
            num = 0
        num += 1
    output += "\n.db %"+bin(16+num)[3:]+bin(16+prev)[3:] + "\n.db 0"
    return output


def hine(x):
    return (math.sin(x*2*math.pi)+math.sin(x*4*math.pi)/4+math.sin(x*6*math.pi)/9+math.sin(x*8*math.pi)/16)/1.4236111111


 
