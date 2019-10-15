import time
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import ks_2samp
from sklearn.externals import joblib
from sklearn.ensemble import GradientBoostingClassifier




def ksvar(y,prob,nn):
    tmp=zip(y,prob)
    # print(list(tmp))
    tmp1=pd.DataFrame(list(tmp),columns=['target','pred'])
    npr=tmp1[tmp1['target']==0]
    ppr=tmp1[tmp1['target']==1]
    tmp2=tmp1.sort_values('pred',ascending=False)
    tt=tmp2.count()['target']
    perbin=int(tt/nn)
    # print('high line:{}'.format(tmp2.iloc[perbin]['pred']))
    # for i in range(nn):
    #     tmp3=tmp2[perbin*i:perbin*(i++1)+1]
    #     tmp3.mean()['target']
    b=list(range(nn))
    allprob=list(map(lambda x:tmp2[perbin*x:perbin*(x+1)].mean()['target'],b))
    # plt.plot(np.arange(nn),allprob)
    # plt.plot(np.arange(nn),allprob,'or')
    # plt.show()
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic,allprob
def train(X,y,X1,y1,i,j,k,l,m):

    clf=GradientBoostingClassifier(n_estimators=i, learning_rate=0.1,
    max_depth=2, min_samples_split=j,min_samples_leaf=k,max_features=l,subsample=m,random_state=10).fit(X, y)

    d_predprob1=clf.predict_proba(X)[:,1]
    ks,high_prop1=ksvar(y,d_predprob1,10)

    # print("high_risk_badrate:{}".format(high_prop))


    d_predprob2=clf.predict_proba(X1)[:,1]
    ks,high_prop2=ksvar(y1,d_predprob2,10)

    # print("high_risk_badrate:{}".format(high_prop))
    return high_prop1,high_prop2

if __name__ == '__main__':
    # 读取excel
    sta=time.time()
    exceldata=pd.read_csv('train0110.csv',index_col='applycode')
    print(exceldata.shape)

    test=exceldata[exceldata['fg']==1]
    valid=exceldata[exceldata['fg']==0]
    X=test.drop(['target','fg'],axis=1)
    y=test['target']
    X1=valid.drop(['target','fg'],axis=1)
    y1=valid['target']

    pd1=pd.read_csv("kschoose.csv")
    test=pd1.values
    # print(test)

    with open('modelchoose.txt','a+') as mc:
        for i in range(test.shape[0]):
            prob1,prob2=train(X,y,X1,y1,int(test[i][0]),int(test[i][1]),int(test[i][2]),int(test[i][3]),test[i][4])
            mc.write(str(prob2)+'\n')
    # print(test[i][0],test[i][1],test[i][2],test[i][3],test[i][4])

    end=time.time()
    print('process dura {}'.format(end-sta))