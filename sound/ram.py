
ram = [" " for i in range(1<<16)]
with open("ram.txt","r") as f:
    for line in f.readlines():
        if "," not in line:
            continue
        a,s,t,n = line.split(",")
        for i in range(eval(a),eval(a)+eval(s)):
            #for v in t:
            #    ram[i].add(v)
            #ram[i].add(n)
            ram[i] = t[0]
s = 64
for i in range(0x8000,0x9000,s):
    print(hex(i),"".join((i for i in ram[i:i+s])))
