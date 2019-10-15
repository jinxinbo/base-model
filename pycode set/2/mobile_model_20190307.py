import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import xgboost as xgb
import pydotplus
import seaborn as sn
import pickle
from sklearn import tree
import ks
from scipy.stats import ks_2samp
import learning_curve
from sklearn.model_selection import ShuffleSplit, GridSearchCV
from sklearn.model_selection import train_test_split
from sklearn.ensemble import GradientBoostingClassifier



# 样本输入
data_train = pd.read_csv('mobile_model_0315.csv', index_col='user_sid')
data_train_X, data_train_y = data_train.drop(['target'], axis=1), data_train['target']

# d_train_X, d_test_X, d_train_y, d_test_y = train_test_split(data_train_X, data_train_y, test_size=0.2, random_state=1234)

nullobs = data_train_X.describe().T
nullobs['total'] = len(data_train_X)


# 删除变量
drop_col = ['lxr1_contact_cnt_std',
'lxr1_use_time_std',
'lxr2_contact_cnt_std',
'lxr2_use_time_std',
'top10_time_6m_std',
'top20_time_6m_std',
'credit_amount',
'app_week',
'app_mon',
'request_date',
'request_time',
'top10_cnt_percent_m2',
'top20_cnt_percent_m2',
'top10_outcnt_m2',
'top10_incnt_m2',
'top20_outcnt_m2',
'top20_incnt_m2',
'top10_cnt_m2',
'top20_cnt_m2',
'top10_cnt_percent_m3',
'top20_cnt_percent_m3',
'top10_outcnt_m3',
'top10_incnt_m3',
'top20_outcnt_m3',
'top20_incnt_m3',
'top10_cnt_m3',
'top20_cnt_m3',
'top10_cnt_percent_m4',
'top20_cnt_percent_m4',
'top10_outcnt_m4',
'top10_incnt_m4',
'top20_outcnt_m4',
'top20_incnt_m4',
'top10_cnt_m4',
'top20_cnt_m4',
'top10_cnt_percent_m5',
'top20_cnt_percent_m5',
'top10_outcnt_m5',
'top10_incnt_m5',
'top20_outcnt_m5',
'top20_incnt_m5',
'top10_cnt_m5',
'top20_cnt_m5',
'top10_cnt_percent_m6',
'top20_cnt_percent_m6',
'top10_outcnt_m6',
'top10_incnt_m6',
'top20_outcnt_m6',
'top20_incnt_m6',
'top10_cnt_m6',
'top20_cnt_m6']


# 同盾多头变量暂不集成,credit_level和net_age


feature_names = list(data_train_X)
drop_col1 = [i for i in drop_col if i in feature_names]
drop_col2 = [i for i in feature_names if 'td' in i]

data_train_X1 = data_train_X.drop(drop_col1 + drop_col2 + ['credit_level', 'net_age'], axis=1)


# 缺失值处理
# data_train_X1 = data_train_X1.fillna({'credit_level' : -999})
feature_names = list(data_train_X1)


# 先看学习曲线，看模型大致ks范围
cv = ShuffleSplit(n_splits=10, test_size=0.2, random_state=0)
estimator = GradientBoostingClassifier(n_estimators=200,
                                  max_depth=2,
                                  max_features='auto',
                                  min_samples_leaf=0.1,
                                  learning_rate=0.1,
                                  criterion ='mse',
                                  verbose=10)
learning_curve.plot_learn_curve(estimator, data_train_X1, data_train_y, ylim=(0.01, 1.01), cv=cv, n_jobs=3)


# data_train_X1.sort_values(by = ['count_same_percent', 'contact1_intop_x'], ascending = [False, False], inplace =True)


# 模型训练


gbdt = GradientBoostingClassifier(max_depth = 2, criterion ='mse')

model_params = {"n_estimators": [200, 300, 400, 500], "max_features": [0.3, 0.5, 0.8, 1], "learning_rate": [0.1, 0.01, 0.05],
                "subsample": [0.3, 0.5, 0.7]}

# model_params = {"n_estimators": [400], "max_features": [1], "learning_rate": [0.05],
#                 "subsample": [1]}

gs = GridSearchCV(estimator=gbdt,
                  param_grid=model_params,
                  n_jobs=3,
                  cv=5,
                  scoring=ks.ks_scorer)
gs.fit(data_train_X1, data_train_y)


clf0 = gs.best_estimator_


clf1 = gs.best_estimator_
gs.best_params_

# {'learning_rate': 0.05,
#  'max_features': 1,
#  'n_estimators': 400,
#  'subsample': 0.5}

clf1 = GradientBoostingClassifier(n_estimators=400,
                                  max_depth=2,
                                  max_features=1,
                                  min_samples_leaf=0.1,
                                  learning_rate=0.05,
                                  criterion ='mse',
                                  subsample=0.5,
                                  verbose=10).fit(data_train_X1, data_train_y)
# tree
dot_data=tree.export_graphviz(clf1.estimators_[173][0],out_file=None,
                              feature_names=feature_names,
                              filled=True,rounded=True,
                              special_characters=True)
graph=pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf("estimator.pdf")

clf1.estimators_[173][0].tree_.threshold
clf1.estimators_[173][0].tree_.feature

feature_names[381]


# 对gbdt训练出的树的各叶子节点，生成新的dummy变量，然后计算IV值，来衍生变量
def transfrom_orivar_gbvar(clf, oritab):

    data_train_X2 = oritab.copy()
    node_var = pd.DataFrame()
    for i in range(clf.n_estimators):

        var_tree = clf.estimators_[i][0].apply(oritab)
        data_train_X2['tree_{}'.format(i)] = var_tree
        tmp = pd.get_dummies(data_train_X2['tree_{}'.format(i)], prefix='tree_{}'.format(i))

        if i == 0:
            node_var = tmp.copy()
        else:
            node_var = pd.concat([node_var,tmp],axis=1)

    return node_var


node_train = transfrom_orivar_gbvar(clf1, data_train_X1)
node_train.to_csv('mobile_bin_train_0318.csv', sep=',')

# 验证数据

data_vlaid = pd.read_csv('mobile_valid_0315.csv', index_col='user_sid')
data_vlaid_X, data_vlaid_y = data_vlaid.drop(['target'], axis=1), data_vlaid['target']
# data_vlaid_X1 = data_vlaid_X.fillna({'credit_level' : -999})

data_vlaid_X1 = data_vlaid_X[feature_names]

node_valid = transfrom_orivar_gbvar(clf1, data_vlaid_X1)
node_valid.to_csv('mobile_bin_valid_0318.csv', sep=',')



# 保存及读出模型
fw = open("mobile_gbdt_20190318.pkl", "wb")
pickle.dump(clf1, fw)
fw.close()

fr = open('mobile_gbdt_20190315.pkl','rb')
clf1 = pickle.load(fr)
fr.close()

