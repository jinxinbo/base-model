def cal(sum,*args):
    print(type(args))
    print(args)
    for i in args:
        sum=sum+i**2
    return sum
asum=cal(2,2,3,4)
print(asum)