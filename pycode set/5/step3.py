from numpy import mean
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

a,b=format_data('model.txt')
print(a)


# petal_length=[]
# for data in a:
#     petal_length.append(data[3])
#
# print(petal_length)
# mean_a=mean(petal_length,axis=0)
# print(mean_a)
# great=[]
# for data in petal_length:
#     if data>mean_a:
#         great.append(data)
#
# print(great)
# print(len(great))






# def mnreal(dataset,index):
# 	datasets = []
# 	for data in dataset:
# 		datasets.append(data[0:4])
# 	mena_real=mean(datasets,axis=0)[index]
# 	return mena_real
#
# print(mnreal(a,1))