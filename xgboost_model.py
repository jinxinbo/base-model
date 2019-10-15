import pandas as pd
import numpy as np
import ks
import seaborn as sns
import xgboost as xgb
import pydotplus
import pickle
from collections import Counter
import seaborn as sn
import matplotlib.pyplot as plt
from sklearn import tree
from scipy.stats import ks_2samp
from sklearn.model_selection import train_test_split
from sklearn.ensemble import GradientBoostingClassifier

from sklearn.model_selection import ShuffleSplit, GridSearchCV

def ksscore(y_pred,y):
    # d_predprob = alg.predict_proba(X)[:, 1]

    tmp = zip(y,y_pred)
    tmp1 = pd.DataFrame(list(tmp),columns=['target','pred'])
    npr = tmp1[tmp1['target']==0]
    ppr = tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic

# 样本输入
data_train = pd.read_csv('xgb_train.csv', index_col='user_sid', encoding='gbk')
d_train_X, d_train_y = data_train.drop(['target'], axis=1), data_train['target']

# 增加蜜罐变量
data_mg = pd.read_csv('data_mg_train.csv', index_col='user_sid', encoding='gbk')

d_train_X_0 = pd.concat((d_train_X, data_mg), axis=1)
d_train_X_0.drop(['target'], axis=1, inplace=True)

# d_train_X, d_test_X, d_train_y, d_test_y = train_test_split(data_train_X, data_train_y, test_size=0.2, random_state=1234)
#
# d1_train= xgb.DMatrix(d_train_X, label=d_train_y)
# d1_test = xgb.DMatrix(d_test_X, label=d_test_y)


# 模型特征处理--缺失值
nullobs = d_train_X.describe().T
nullobs['total'] = len(d_train_X)
nullobs['nullnum'] = nullobs['total'] - nullobs['count']
nullobs['nullpercent'] = nullobs['nullnum'] / nullobs['total']
nullobs.sort_values('nullpercent', ascending=False, inplace=True)
nullobs.to_excel('nullobs.xlsx')

# 缺失比例在0~5%的用中位数填充，5%以上的不填充，单独赋值
nullobs1 = nullobs[(nullobs['nullpercent']<0.05) & (nullobs['nullnum']>0)]
nullobs1_value = dict(nullobs1['50%']) #不同的变量填充不同的缺失值
d_train_X_1 = d_train_X.fillna(nullobs1_value)

d_train_X_2 = d_train_X_1.fillna(9999)#5%以上的变量赋值9999
# 模型变量处理--数值型字符型变量


character_features = [c for c in d_train_X_0 if d_train_X_0[c].dtype.kind not in ('i', 'f')]
numeric_features = [c for c in d_train_X_0 if d_train_X_0[c].dtype.kind in ('i', 'f')]
d_train_X_1 = pd.get_dummies(d_train_X_0[character_features])

d_train_X_2 = pd.concat((d_train_X_0[numeric_features], d_train_X_1), axis=1)

var_drop_1 = ['m1_loan_sum',
'm3_loan_sum',
'm6_loan_sum',
'm12_loan_sum',
'm18_loan_sum'
]
var_drop_tz = [i for i in numeric_features if 'var_out' in i]
var_drop = var_drop_1 + var_drop_tz

d_train_X_3 = d_train_X_2.drop(var_drop, axis=1)



#XGBoost_sklearn接口
from xgboost import XGBClassifier

# 先learing_rate和n_estimators,再min_child_weight、colsample_bytree、subsample

xgc=XGBClassifier(max_depth=2, objective= 'binary:logistic')

model_params = {'learning_rate':[0.05, 0.02],
                'n_estimators':[300],
                'colsample_bytree':[0.7],
                'min_child_weight' : [5],
                'subsample':[0.7]}

gs = GridSearchCV(estimator=xgc,
                  param_grid=model_params,
                  n_jobs=4,
                  cv=5,
                  verbose=1,
                  scoring=ks.ks_scorer)
gs.fit(d_train_X_3, d_train_y)

clf = gs.best_estimator_

gs.best_score_
gs.best_params_

# 变量重要性
fea_imp = clf.feature_importances_
fea_imp1 = pd.DataFrame()
fea_imp1['feature']= list(d_train_X_3)
fea_imp1['importance']=list(fea_imp)
fea_imp1.sort_values('importance', ascending=False, inplace=True)



# 用plot_tree画图
fig,ax = plt.subplots()
fig.set_size_inches(60,30)
xgb.plot_tree(clf,ax = ax, num_trees=98)
plt.close()
fig.savefig('xgb_tree.jpg')



def dummy_enc(clf, oritab):

    # data_train_X2 = oritab.copy()
    train_new_feature = clf.apply(oritab)
    train_new_feature1 = pd.DataFrame(train_new_feature, index=oritab.index)
    columns = ['tree_{}'.format(i) for i in range(clf.n_estimators)]

    train_new_feature1.columns = columns

    node_var = pd.DataFrame()
    for i, column in enumerate(columns):

        tmp = pd.get_dummies(train_new_feature1[column], prefix=column)

        if i == 0:
            node_var = tmp.copy()
        else:
            node_var = pd.concat([node_var,tmp],axis=1)

    return node_var

node_train = dummy_enc(clf, d_train_X_3)

# 再进行IV值检测

def iv_select(node_trian_1):

    feature_name = list(node_trian_1)
    feature_name = [i for i in feature_name if 'target' not in i]

    feature_keep = []
    for ni in feature_name:
        iv = ks.IV_compute(node_trian_1[ni], node_trian_1['target'])
        if iv >=0.02:
            feature_keep.append(ni)

    return feature_keep

# 最小叶节点要求
sum_1 = node_train.sum()
sum_1 /= len(node_train)

sum_2 = sum_1[(sum_1 >= 0.05) & (sum_1 <= 0.95)]

feature_keep_1 = list(sum_2.index.values)

node_train_1 = node_train.merge(pd.DataFrame(d_train_y), left_index=True, right_index=True)
feature_keep_2 = iv_select(node_train_1)

feature_keep = [i for i in feature_keep_1 if i in feature_keep_2]



# 全部数据转换

data_test = pd.read_csv('xgb_alldata.csv', index_col='user_sid', encoding='gbk')
data_test_X, data_test_y = data_test.drop(['target'], axis=1), data_test['target']

data_mg_all = pd.read_csv('data_mg_all.csv', index_col='user_sid', encoding='gbk')
data_mg_all.drop(['target'], axis=1, inplace=True)

# data_vlaid_X1 = data_vlaid_X.fillna({'credit_level' : -999})
data_test_X0 = pd.concat((data_test_X, data_mg_all), axis=1)
data_test_X1 = data_test_X0[numeric_features]

data_test_X1.drop(var_drop, axis=1, inplace=True)
data_test_X2 = pd.get_dummies(data_test_X[character_features])

data_test_X3 = pd.concat((data_test_X1, data_test_X2), axis=1)

node_test = dummy_enc(clf, data_test_X3)
node_test_1 = node_test[feature_keep].reset_index()

node_test_1.to_csv('all_data_from_xgb_1009.csv', sep=',', index=False)





# 保存及读出模型
fw = open("mobile_gbdt_20191009.pkl", "wb")
pickle.dump(clf, fw)
fw.close()

fr = open('mobile_gbdt_20191009.pkl','rb')
clf = pickle.load(fr)
fr.close()





Counter(list(train_new_feature[:,0]))

min([temp1[i].value_counts().min() for i in temp1.columns])


# dict = {}
# for key in list(train_new_feature[:,1]):
#     dict[key] = dict.get(key, 0) + 1


fig,ax = plt.subplots()
fig.set_size_inches(60,30)
xgb.plot_tree(xgc,ax = ax, num_trees=76)
plt.close()
fig.savefig('xgb_tree.jpg')

xgc.feature_importances_



feature_names = list(d_train_X_2)
clf1 = GradientBoostingClassifier(n_estimators=100,
                                  max_depth=6,
                                  max_features='auto',
                                  min_samples_leaf=0.05,
                                  learning_rate=0.2,
                                  criterion ='mse',
                                  verbose=10).fit(d_train_X_2, d_train_y)
# tree
dot_data=tree.export_graphviz(clf1.estimators_[0][0],out_file=None,
                              feature_names=feature_names,
                              filled=True,rounded=True,
                              special_characters=True)
graph=pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf("estimator.pdf")

# ks值
import ks
y_train_pred1 = clf1.predict_proba(d_train_X_2)[:,1]
ks.ksscore(y_train_pred1,d_train_y)


# 变量重要性
fea_imp = clf1.feature_importances_
fea_imp1 = pd.DataFrame()
fea_imp1['feature']=feature_names
fea_imp1['importance']=list(fea_imp)
fea_imp1.sort_values('importance', ascending=False, inplace=True)

fig,ax= plt.subplots()
fig.set_size_inches(20,10)
plt.xticks(rotation=60)#横坐标刻度的和x轴的角度
sn.barplot(data=fea_imp1.head(30),x="feature",y="importance",ax=ax,orient="v")






# xgboost自带接口训练模型
watch_list = [(d1_test, 'test'), (d1_train, 'train')]
param = {'max_depth': 2, 'eta': 0.2, 'silent': 1, 'objective': 'binary:logistic','subsample':0.9,
         'eval_metric ':'auc','scale_pos_wieght':float(len(d_train_y)-sum(d_train_y))/float(sum(d_train_y))}
bst = xgb.train(param, d1_train, num_boost_round=100, evals=watch_list)


# 用plot_tree画图
fig,ax = plt.subplots()
fig.set_size_inches(60,30)
xgb.plot_tree(bst,ax = ax, num_trees=13)
plt.close()
fig.savefig('xgb_tree.jpg')




# 生成新的特征
train_new_feature= bst.predict(d1_train, pred_leaf=True)
test_new_feature= bst.predict(d1_test, pred_leaf=True)
train_new_feature.shape
test_new_feature.shape





# 变量重要性
feat_imp = bst.get_fscore()

# seaborn重要性直方图
'''
features = pd.DataFrame()
features['features'] = feat_imp.keys()
features['importance'] = feat_imp.values()
features.sort_values(by=['importance'],ascending=False,inplace=True)
fig,ax= plt.subplots()
fig.set_size_inches(20,10)
plt.xticks(rotation=60)
sns.barplot(data=features.head(30),x="features",y="importance",ax=ax,orient="v")
'''
# sorted(feat_imp.items(), key=lambda x:x[1], reverse=True)