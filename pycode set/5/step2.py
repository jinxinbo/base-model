import numpy as np
import pandas as pd
from sklearn import tree
from sklearn import preprocessing
from sklearn.externals.six import StringIO

train=pd.read_excel("learn1.xls","sheet")
print(train)
_=train.fillna(9999,inplace= True)
# print(train)
train_data=train.iloc[:,-2:]
# print(train_data)
# train_target=train.iloc[:,-1]
enc = preprocessing.OneHotEncoder()
print(train_data.values)
enc.fit(train_data.values)
train_data_1 = enc.transform(train_data.values).toarray()
print(train_data_1)
print(train_data_1.shape)
