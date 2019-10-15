import csv
# readline 读取文件，很快
f = open("log1.txt",'r')
result = list()
for line in f:
    line = f.readline()
    # print (line)
    result.append(line)
print ((result[0]))

f.close()
for i in range(10):
    m=result[i*7000:(i+1)*7000]
    open('result'+str(i)+'.txt', 'w').write('%s' % '\n'.join(m))
    # writer=csv.writer(open('result'+str(i)+'.csv',"wb"))
    # writer.writerow(m)



