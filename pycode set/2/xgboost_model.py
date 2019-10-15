import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import xgboost as xgb
import pydotplus
import seaborn as sn
from sklearn import tree
from scipy.stats import ks_2samp
from sklearn.model_selection import train_test_split
from sklearn.ensemble import GradientBoostingClassifier


def ksscore(y_pred,y):
    # d_predprob = alg.predict_proba(X)[:, 1]

    tmp = zip(y,y_pred)
    tmp1 = pd.DataFrame(list(tmp),columns=['target','pred'])
    npr = tmp1[tmp1['target']==0]
    ppr = tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic

# 样本输入
data_train = pd.read_csv('xgboost.csv', index_col='user_sid')
data_train_X, data_train_y = data_train.drop(['target'], axis=1), data_train['target']

d_train_X, d_test_X, d_train_y, d_test_y = train_test_split(data_train_X, data_train_y, test_size=0.2, random_state=1234)

d1_train= xgb.DMatrix(d_train_X, label=d_train_y)
d1_test = xgb.DMatrix(d_test_X, label=d_test_y)


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

character_features = [c for c in d_train_X if d_train_X[c].dtype.kind not in ('i', 'f')]
numeric_features = [c for c in d_train_X if d_train_X[c].dtype.kind in ('i', 'f')]



# 训练模型
watch_list = [(d1_test, 'test'), (d1_train, 'train')]
param = {'max_depth': 6, 'eta': 0.2, 'silent': 1, 'objective': 'binary:logistic','subsample':0.9,
         'eval_metric ':'auc','scale_pos_wieght':float(len(d_train_y)-sum(d_train_y))/float(sum(d_train_y))}
bst = xgb.train(param, d1_train, num_boost_round=100, evals=watch_list)


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
'''
from xgboost import XGBClassifier

xgc=XGBClassifier(n_estimators=100,
                  max_depth=6,
                  learning_rate=0.2,
                  criterion ='mse',
                  verbose=10).fit(d_train_X, d_train_y)

xgc.feature_importances_
'''

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





# 对gbdt训练出的树的各叶子节点，生成新的dummy变量，然后计算IV值，来衍生变量
d_train_X_3 = d_train_X_2.copy()
node_var = pd.DataFrame()
for i in range(100):

    var_tree = clf1.estimators_[i][0].apply(d_train_X_2)
    d_train_X_3['tree_{}'.format(i)] = var_tree
    tmp = pd.get_dummies(d_train_X_3['tree_{}'.format(i)], prefix='tree_{}'.format(i))

    if i == 0:
        node_var = tmp.copy()
    else:
        node_var = pd.concat([node_var,tmp],axis=1)

