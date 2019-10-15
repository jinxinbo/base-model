import read
from numpy import log
import pandas as pd

def freq(dataset,feature_index):
    group_count = {}
    for data in dataset:
        group_count[data[feature_index]] = group_count.get(data[feature_index], 0) + 1
    return group_count


def cal_entropy(dictcount):
    '''
	计算数据集的熵大小
	'''
    log2=lambda x:log(x)/log(2)
    entropy = 0
    dsum=0
    for label in list(dictcount.keys()):
        dsum+=dictcount[label]
    for label in list(dictcount.keys()):
        prob = float(dictcount[label]) / dsum
        entropy -= prob * log2(prob)
    # print 'entropy:',entropy
    return dsum,entropy

def setf(dataset,index):
    dataf=[]
    for data in dataset:
        dataf.append(data[index])
    count=set(dataf)
    listf=[i for i in count]
    return listf

def best_group_lx(train_dataset,var_index,label_index):
    listf=setf(train_dataset,var_index)
    print(listf)
    listl=setf(train_dataset,label_index)
    print(listl)
    fl={listf[i]:{listl[j]:0 for j in range(len(listl))} for i in range(len(listf))}
    for i in range(len(listf)):
        for j in range(len(listl)):
            for data in train_dataset:
                if data[var_index]==listf[i] and data[label_index]==listl[j]:
                    fl[listf[i]][listl[j]]+=1
    return fl
# datafra算法结构算法

# b=pd.DataFrame(a)
# # print(b)
# c=b.T
# print(c)
# # print(c.count())

# 基本统计量
# print(c.describe())
#
# print(c['0'])
# print(c[:3])
# print(c.head())
# print(c.head())
# d=c.iloc[:4]
# print(d)
# # print(d['0'].sum())
# # print(d['1'].sum())
# print(d.sum())
# f=c.iloc[4:]
# # print(f.sum())
# print(dict(f.sum()))


# 求a的长度
def group_new(train_dataset,indict,inframe):
    log2=lambda x:log(x)/log(2)
    train_freq=freq(train_dataset,3)
    train_length,train_ent=cal_entropy(train_freq)
    alength=len(list(indict.keys()))
    print(alength)
    if alength>=0:
        max_gain_ratio=0.0
        for i in range(1,alength):
            less_a=inframe.iloc[:i]
            dict_less_a=dict(less_a.sum())
            less_length,less_ent=cal_entropy(dict_less_a)
            great_a=inframe.iloc[i:]
            dict_great_a=dict(great_a.sum())
            great_length,great_ent=cal_entropy(dict_great_a)
            condition_entropy = less_length / train_length * less_ent + great_length / train_length *great_ent
            gain=train_ent-condition_entropy
            splitinfo=-less_length / train_length*log2(less_length / train_length) - great_length / train_length*log2(great_length / train_length)
            gain_ratio=gain/splitinfo
            if gain_ratio>max_gain_ratio:
                max_gain_ratio=gain_ratio
                spi=i
    return spi,max_gain_ratio

train_feature,train_dataset=read.read("learn1.xls","sheet")
a=best_group_lx(train_dataset,0,3)

print(a)
b=pd.DataFrame(a)
print(b)
c=b.T
print(c)
tt,msxsp=group_new(train_dataset,a,c)
print(tt)
print(msxsp)


