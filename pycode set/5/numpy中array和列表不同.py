import numpy as np
arr=np.arange(15)
print(arr)
print(arr[1])
brr=arr[3:5]
print(brr)
brr[:]=100
print(brr)
print(arr)

a=[i for i in range(15)]
print(a)
b=a[3:5]
b[:]=[12,12]
print(b)
print(a)

me_an=np.mean(a)
print(me_an)

me_arrn=np.mean(arr)
print(me_arrn)