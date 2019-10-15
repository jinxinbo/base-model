# -*- coding: utf-8 -*-
import time
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeClassifier
from sklearn.externals import joblib
from sklearn.ensemble import GradientBoostingClassifier
from sklearn import cross_validation,metrics
from sklearn.grid_search import GridSearchCV
from scipy.stats import ks_2samp



# 读取excel

exceldata=pd.read_csv("jin.csv")
# exceldata=pd.read_excel("train1228.xls","Sheet",index_col='id')
print(exceldata.shape)
test=exceldata
# test=exceldata[exceldata['target']==1]
# print(test)

# X=test.drop(['target','fg'],axis=1)
X=test.drop(['applycode','target'],axis=1)
clf1=joblib.load("D:\python\my_model\my_train_model.m")
d_predprob=clf1.predict_proba(X)[:,1]
print(type(d_predprob))
X1=pd.DataFrame({'pred':d_predprob})
X2=test[['applycode','target','monthpayrate']]

X2=X2.join(X1)
# print(X2)
X2.to_csv('pred0110.csv',sep='\t')







