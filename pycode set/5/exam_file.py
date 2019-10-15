import numpy as np
import pandas as pd
from sklearn import tree
from sklearn.externals.six import StringIO

train=pd.read_excel("py_tree_learn.xls","Sheet1")
# print(train)
_=train.fillna(9999,inplace= True)
# print(train)
train_data=train.iloc[:,:-1]
train_target=train.iloc[:,-1]
# print(train_data)
train_data_1=train_data.values
train_target_1=train_target.values
# print(train_data_1)

clf=tree.DecisionTreeClassifier(criterion='entropy',max_depth=6)
clf=clf.fit(train_data_1,train_target_1)
dot_data = StringIO()
tree.export_graphviz(clf, out_file=dot_data)
print(dot_data.getvalue())



# new_train=(train['PENSION_FUND_STATUS'])
# # print(new_train)
# # print(new_train.value_counts())
# print(pd.crosstab(train.PENSION_FUND_STATUS,train.target_new,margins=True))

