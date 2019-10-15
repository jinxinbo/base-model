import pandas as pd
from scipy.stats import ks_2samp



def ksscore(y_pred,y):
    # d_predprob = alg.predict_proba(X)[:, 1]

    tmp = zip(y,y_pred)
    tmp1 = pd.DataFrame(list(tmp),columns=['target','pred'])
    npr = tmp1[tmp1['target']==0]
    ppr = tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic


def ks_scorer(alg, X, y):
    y_pred = alg.predict_proba(X)[:, 1]

    tmp = zip(y, y_pred)
    tmp1 = pd.DataFrame(list(tmp),columns=['target','pred'])
    npr = tmp1[tmp1['target']==0]
    ppr = tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic