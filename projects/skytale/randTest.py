state = [0,0,0,0,0,0,0,1]
mask = 0x31

def stepForward():
    global state,mask
    s = state.pop()
    state.insert(0,0)
    for i in range(len(state)):
        if mask & (1<<i):
            state[i] = (state[i]-s) & 0xff
    return state
def stepBackwards():
    global state,mask
    s = state[0]
    for i in range(len(state)):
        if mask & (1<<i):
            state[i] = (state[i]-s) & 0xff
    state.pop(0)
    state.append((-s)&0xff)
    return state
    

while 1:
    print(state)
    a = input("")
    if a == "":
        stepForward()
    else:
        stepBackwards()
