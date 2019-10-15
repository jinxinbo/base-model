
from math import *
import numpy as np
import pandas as pd
from scipy.stats import ks_2samp

def ksscore(y_pred,y):
    # d_predprob = alg.predict_proba(X)[:, 1]

    tmp = zip(y,y_pred)
    tmp1 = pd.DataFrame(list(tmp),columns=['target','pred'])
    npr = tmp1[tmp1['target']==0]
    ppr = tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic


def wald_test(X, y_pred, model_params):

    # pred_probs = np.matrix(model.predict_proba(X))
    X_design = np.hstack((np.ones(shape=(X.shape[0], 1)), X))
    diag_array = np.multiply(y_pred, 1 - y_pred)
    # V = scipy.sparse.diags(diag_array)
    V = np.diag(np.array(diag_array).ravel())
    m1 = X_design.T.dot(V)
    m2 = m1.dot(X_design)
    cov_mat = np.linalg.inv(m2)

    # model_params = np.hstack((model.intercept_[0], model.coef_[0]))
    wald_stats = (model_params / np.sqrt(np.diag(cov_mat))) ** 2

    return wald_stats
