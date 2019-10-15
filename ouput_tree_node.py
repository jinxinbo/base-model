import re
import pickle
import matplotlib.pyplot as plt

import xgboost as xgb

fr = open('mobile_gbdt_20191009.pkl','rb')
clf = pickle.load(fr)
fr.close()

from __future__ import absolute_import
from xgboost.core import Booster

fmap = ''
booster = clf.get_booster()

tree = booster.get_dump(fmap=fmap)[215]
print(tree)


for i in range(400):
    tree1 = booster.get_dump(fmap=fmap)[i]
    if 'cus_sex' in tree1:
        print(i)


# 用plot_tree画图
fig,ax = plt.subplots()
fig.set_size_inches(60,30)
xgb.plot_tree(clf,ax = ax, num_trees=106)
plt.close()
fig.savefig('xgb_tree.jpg')



data_test_X = pd.read_csv('all_sup_data.csv', index_col='user_sid', encoding='gbk')

varname = d_train_X_0[numeric_features].columns.tolist()


# data_vlaid_X1 = data_vlaid_X.fillna({'credit_level' : -999})
data_test_X1 = data_test_X[varname].drop(var_drop, axis=1)

data_test_X2 = pd.get_dummies(data_test_X[character_features])

data_test_X3 = pd.concat((data_test_X1, data_test_X2), axis=1)

node_test = dummy_enc(clf, data_test_X3)

var_keep = ['tree_215_5',
'tree_377_4',
'tree_106_3',
'tree_26_5',
'tree_178_4',
'tree_160_4',
'tree_302_6',
'tree_193_6',
'tree_326_5',
'tree_246_4',
'tree 0_134_6',
'tree_250_5',
'tree_270_3']

node_test_1 = node_test[var_keep].reset_index()

node_test_1.to_csv('all_sup_tree.csv', sep=',', index=False)
