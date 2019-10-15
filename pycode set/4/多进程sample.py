# from multiprocessing import Process, Lock
#
# def f(l, i):
#     l.acquire()
#     print ('hello world')
#     l.release()
#
# if __name__ == '__main__':
#     lock = Lock()
#
#     for num in range(10):
#         Process(target=f, args=(lock, num)).start()


from multiprocessing import Process, Value, Array

def f(n, a):
    n.value = 3.1415927
    for i in range(len(a)):
        a[i] = -a[i]

if __name__ == '__main__':
    num = Value('d', 0.0)
    arr = Array('i', range(10))
    # print(arr)
    p = Process(target=f, args=(num, arr))
    p.start()
    p.join()

    print (num.value)
    print (arr[:])