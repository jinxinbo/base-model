from numpy import mean

def cal_info_gain(dataset,feature_index,base_entropy):
	'''
	计算指定特征对数据集的信息增益值
	g(D,F) = H(D)-H(D/F) = entropy(dataset) - sum{1,k}(len(sub_dataset)/len(dataset))*entropy(sub_dataset)
	@base_entropy = H(D)
	'''
	datasets = []
	for data in dataset:
		datasets.append(data[0:4])
	#print datasets
	mean_value = mean(datasets,axis = 0)[feature_index]    #计算指定特征的所有数据集值的平均值
	#print mean_value
	dataset_less = []
	dataset_greater = []
	for data in dataset:
		if data[feature_index] > mean_value:
			dataset_greater.append(data)
		else:
			dataset_less.append(data)
	#条件熵 H(D/F)
	condition_entropy = float(len(dataset_less))/len(dataset)*cal_entropy(dataset_less) + float(len(dataset_greater))/len(dataset)*cal_entropy(dataset_greater)
	#print 'info_gain:',base_entropy - condition_entropy
	return base_entropy - condition_entropy