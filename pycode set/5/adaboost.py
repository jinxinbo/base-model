# -*- coding: utf-8 -*-
import pandas as pd
import numpy as np
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.externals import joblib
from sklearn.ensemble import GradientBoostingClassifier
from sklearn import cross_validation,metrics
from sklearn.grid_search import GridSearchCV



dt=pd.read_excel('model.xls','Sheet1')
# print(dt)
# print(dt.shape)

dt1=dt[dt['l1m_cnt'].isnull()]
# print(dt1)
dt=dt.fillna({'l1m_cnt':0})
dt2=dt[dt['l1m_cnt'].isnull()]
# print(dt2)

# print(dt)
dt_in=dt[dt['target_new']==1]
in_index=list(dt_in.index)
sampler=np.random.permutation(len(in_index))
in_test=[in_index[i] for i in sampler[:400]]
in_valid=[in_index[i] for i in sampler[400:]]


# print(dt_in)
dt_out=dt[dt['target_new']==0]
out_index=list(dt_out.index)

sampler=np.random.permutation(len(out_index))
out_test=[out_index[i] for i in sampler[:400]]
out_valid=[out_index[i] for i in sampler[400:450]]
# print(inxsam)

test=dt.reindex(in_test+out_test)
# print(test)
valid=dt.reindex(in_valid+out_valid)
# print(valid)

X=test.drop('target_new',axis=1)
y=test['target_new']


######--------------------------------上面是随机抽样数据----------------------------------------######

bdt = AdaBoostClassifier(DecisionTreeClassifier(max_depth=1),
                         algorithm="SAMME",
                         n_estimators=200)

bdt.fit(X, y)


clf = GradientBoostingClassifier(n_estimators=200, learning_rate=1.0,
    max_depth=1, random_state=0).fit(X, y)


score=bdt.score(X,y)
print(score)

score1=clf.score(X, y)
print(score1)
d_pred1=clf.predict_proba(X)
print(d_pred1)
d_pred=d_pred1[:,1]
print(d_pred)


# 交叉验证
cv_score=cross_validation.cross_val_score(clf,X,y,cv=5,scoring='roc_auc')
print(cv_score)
auc=metrics.roc_auc_score(y,d_pred)
print(auc)
# twoclass_output = bdt.decision_function(X)
# # print(type(twoclass_output))
# print(twoclass_output.max())
# print(twoclass_output.min())

# 保存模型
joblib.dump(clf, "train_model.m")
# p=bdt.predict(X)
# print(p)

# pred=pd.Series(p)
# print(pred)
# pred.to_csv('tt.csv',sep='\t')

# pam=bdt.get_params()
# print(pam)
# 验证数据


clf=joblib.load("train_model.m")

valid_x=valid.drop('target_new',axis=1)
valid_y=valid['target_new']
score1=clf.score(valid_x,valid_y)
print(score1)
p=clf.predict(valid_x)
print(p)


