import read
from numpy import log


def setf(dataset,index):
    dataf=[]
    for data in dataset:
        dataf.append(data[index])
    count=set(dataf)
    listf=[i for i in count]
    return listf

def cal_entropy(dataset):
    '''
	计算数据集的熵大小
	'''
    log2=lambda x:log(x)/log(2)
    n = len(dataset)
    label_count = {}
    for data in dataset:
        label = data[-1]
        if label in label_count.keys():
            label_count[label] += 1
        else:
            label_count[label] = 1
    entropy = 0
    # print(label_count)
    for label in label_count:
        prob = float(label_count[label]) / n
        entropy -= prob * log2(prob)
    # print 'entropy:',entropy
    return entropy

import itertools
# zuhe=list(itertools.combinations(listf,2))
# print(zuhe)
# print(zuhe[0])
# sdata=[]
# edata=[]
# for data in train_dataset:
#     if data[2] in zuhe[0]:
#         sdata.append(data)
#     else:
#         edata.append(data)
#
# print(sdata)
# print(cal_entropy(sdata))

# condition_entropy = float(len(sdata)) / len(train_dataset) * cal_entropy(sdata) + float(
# len(edata)) / len(train_dataset) * cal_entropy(edata)

def bets_group(listf,train_dataset,index):
    idex=0.0
    jdex=0.0
    log2=lambda x:log(x)/log(2)
    max_gain_ratio=0.0
    for i in range(1,len(listf)):
        zuhe=list(itertools.combinations(listf,i))
        for j in range(len(zuhe)):
            sdata=[]
            edata=[]
            for data in train_dataset:
                if data[index] in zuhe[j]:
                    sdata.append(data)
                else:
                    edata.append(data)
            condition_entropy = float(len(sdata)) / len(train_dataset) * cal_entropy(sdata) + float(
            len(edata)) / len(train_dataset) * cal_entropy(edata)
            gain=cal_entropy(train_dataset)-condition_entropy
            splitinfo=-len(sdata)/len(train_dataset)*log2(len(sdata)/len(train_dataset))-len(edata)/len(train_dataset)*log2(len(edata)/len(train_dataset))
            gain_ratio=gain/splitinfo
            if gain_ratio>max_gain_ratio:
                max_gain_ratio=gain_ratio
                idex=i
                jdex=j
                # print(idex)
                # print(jdex)
                cholist=zuhe[jdex]
    return cholist,max_gain_ratio



train_feature,train_dataset=read.read("learn1.xls","sheet")
listf=setf(train_dataset,0)
print(listf)
print(len(listf))
a,b=bets_group(listf,train_dataset,0)
print(a)
print(b)

















