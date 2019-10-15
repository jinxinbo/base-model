import numpy as np
import pandas as pd
import scipy.stats
from sklearn.linear_model import LogisticRegression

def wald_test(X, model):

    pred_probs = np.matrix(model.predict_proba(X))
    X_design = np.hstack((np.ones(shape=(X.shape[0], 1)), X))
    diag_array = np.multiply(pred_probs[:, 0], pred_probs[:, 1])
    # V = scipy.sparse.diags(diag_array)
    V = np.diag(np.array(diag_array).ravel())
    m1 = X_design.T.dot(V)
    m2 = m1.dot(X_design)
    cov_mat = np.linalg.inv(m2)

    model_params = np.hstack((model.intercept_[0], model.coef_[0]))
    wald_stats = (model_params / np.sqrt(np.diag(cov_mat))) ** 2

    return wald_stats

dt = pd.read_csv('dataout.csv',index_col='user_sid')

dt_X = dt.drop(['weight', 'target'], axis=1)
dt_y = dt['target']

clf = LogisticRegression().fit(dt_X, dt_y)
feature_name = list(dt_X)
feature_coef = pd.DataFrame()
feature_coef['name'] = feature_name
feature_coef['coef'] = clf.coef_.ravel()
feature_coef.sort_values('coef', ascending=False, inplace=True)

wald_stats = wald_test(dt_X, clf)
feature_coef['chisq']  = wald_stats

