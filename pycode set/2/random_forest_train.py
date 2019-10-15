import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression


dt = pd.read_csv('data_0905.csv', index_col='user_sid')
dt_X = dt.drop(['weight', 'target'], axis=1)
dt_y = dt['target']

# 逻辑回归
clf = LogisticRegression().fit(dt_X, dt_y)
feature_name = list(dt_X)
feature_coef = pd.DataFrame()
feature_coef['name'] = feature_name
feature_coef['coef'] = clf.coef_.ravel()
feature_coef.sort_values('coef', ascending=False, inplace=True)

