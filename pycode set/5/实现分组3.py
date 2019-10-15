import read
from numpy import log

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

def setf(dataset,index):
    dataf=[]
    for data in dataset:
        dataf.append(data[index])
    count=set(dataf)
    listf=[i for i in count]
    return listf



def best_group_lx(train_dataset,index):
# 非缺失值,
    log2=lambda x:log(x)/log(2)
    nmiss_dataset=[]
    for data in train_dataset:
        if data[index]!='':
            nmiss_dataset.append(data)
    listf1=setf(nmiss_dataset,index)
    print(listf1)
    listf1.sort()
    print(listf1)
    #确实值，
    miss_dataset=[]
    for data in train_dataset:
        if data[index]=='':
            miss_dataset.append(data)
    # print(miss_dataset)

    max_gain_ratio=0.0
    split_value=0.0
    for i in range(len(listf1)-1):
        great_value=[]
        less_value=[]
        avg_value=(listf1[i]+listf1[i+1])/2.0
        for data in nmiss_dataset:
            if data[index]<=avg_value:
                less_value.append(data)
            else:
                great_value.append(data)
        condition_entropy = float(len(less_value)) / len(train_dataset) * cal_entropy(less_value) + float(
        len(great_value)) / len(train_dataset) * cal_entropy(great_value)+float(
        len(miss_dataset)) / len(train_dataset) * cal_entropy(miss_dataset)
        gain=cal_entropy(train_dataset)-condition_entropy
        splitinfo=-len(less_value)/len(train_dataset)*log2(len(less_value)/len(train_dataset))-len(
        great_value)/len(train_dataset)*log2(len(great_value)/len(train_dataset))-len(
        miss_dataset)/len(train_dataset)*log2(len(miss_dataset)/len(train_dataset))
        gain_ratio=gain/splitinfo
        if gain_ratio>max_gain_ratio:
            max_gain_ratio=gain_ratio
            split_value=avg_value
    return split_value,max_gain_ratio



train_feature,train_dataset=read.read("learn1.xls","sheet")
# listf=setf(train_dataset,1)

a,b=best_group_lx(train_dataset,2)
print(a)
print(b)








