
import read
from numpy import mean
train_feature,train_dataset=read.read("learn1.xls","sheet")
train_features=train_feature[0]

def get_means(train_dataset):
    '''
	获取训练数据集各个属性的数据平均值
	'''
    dataset = []
    for data in train_dataset:
        dataset.append(data[:-1])
    print(dataset)
    mean_values = mean(dataset,axis=0)  # 数据集在该特征项的所有取值的平均值
    return mean_values
val=get_means(train_dataset)
print(val)

    