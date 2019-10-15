import logging
import pandas as pd
import numpy as np
import scipy.stats
import scipy.sparse
import feature_selector
import adaboost_lr_model
import random_forest_model
from scipy.stats import ks_2samp


def wald_test(X):

    # pred_probs = np.matrix(self.model.predict_proba(X)
    X_design = np.hstack((np.ones(shape=(X.shape[0], 1)), X))
    diag_array = np.multiply(X['fraud_p1'], X['fraud_p']).A1
    V = scipy.sparse.diags(diag_array)
    m1 = X_design.T * V
    m2 = m1.dot(X_design)
    cov_mat = np.linalg.inv(m2)

    # model_params = np.hstack((self.model.intercept_[0], self.model.coef_[0]))
    # wald_stats = (model_params / np.sqrt(np.diag(cov_mat))) ** 2

    return cov_mat


if __name__ == "__main__":

    datapath = r'D:\京东金融大赛'
    train = pd.read_csv(datapath + '\modeldata_1127.csv', index_col='uid')
    varname = [x for x in train.columns if x not in ['target']]

    print(train.head(), train['target'].mean())

    train_x = train.drop(['target'], axis=1)
    train_y = train['target']

    # train_x_values = train_x.values

    select = feature_selector.FeatureSelector()
    drop_list = select.fit(train_x, train_y)

    print(drop_list)
