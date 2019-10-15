
from math import log


def format_data(dataset_file):
	'''
	返回dataset(列表集合)和features(列表)
	'''
	dataset = []
	for index,line in enumerate(open(dataset_file,'rU').readlines()):
		line = line.strip()
		fea_and_label = line.split(',')
		dataset.append([float(fea_and_label[i]) for i in range(len(fea_and_label)-1)]+[fea_and_label[len(fea_and_label)-1]])
	#features = [dataset[0][i] for i in range(len(dataset[0])-1)]
	#sepal length（花萼长度）、sepal width（花萼宽度）、petal length（花瓣长度）、petal width（花瓣宽度）
	features = ['sepal_length','sepal_width','petal_length','petal_width']
	return dataset,features



def cal_entropy(dataset):
	'''
	计算数据集的熵大小
	'''
	n = len(dataset)
	label_count = {}
	for data in dataset:
		label = data[-1]
		if label in label_count.keys():
			label_count[label] += 1
		else:
			label_count[label] = 1
	entropy = 0
	for label in label_count:
		prob = float(label_count[label])/n
		entropy -= prob*log(prob,2)
	#print 'entropy:',entropy
	return entropy


m,n=format_data('model.txt')
print(m)
print(cal_entropy(m))