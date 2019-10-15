#coding = utf-8

def huiwen(str):

    if len(str) == 1:
        return True

    else:
        return str[0]==str [-1] and huiwen(str[1:-1])