#stack lisp


class Cons:
    def __init__(self,a,b):
        self.a = a
        self.b = b
    def recRepr(self,parens=True):
        o = ["","("][parens]
        c = ["",")"][parens]
        ra = lambda x: repr(x) if x != None else "()"
        if type(self.b) == Cons:
            return f'{o}{ra(self.a)} {self.b.recRepr(False)}{c}'
        if self.b == None:
            return f'{o}{ra(self.a)}{c}'
        return f'{o}{ra(self.a)} . {self.b}{c}'
    def __repr__(self):
        return self.recRepr(True)
    @staticmethod
    def fromIterable(g):
        h = None
        for i in [i for i in g][::-1]:
            h = Cons(i,h)
        return h
