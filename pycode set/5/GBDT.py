# -*- coding: utf-8 -*-
import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.externals import joblib
from sklearn.ensemble import GradientBoostingClassifier
from sklearn import cross_validation,metrics
import matplotlib.pyplot as plt
from matplotlib.pylab import rcParams
from sklearn.model_selection import GridSearchCV, cross_val_score
from scipy.stats import ks_2samp
from sklearn.feature_selection import SelectFromModel
from sklearn.metrics import make_scorer

def read_data(dt,sample):
    # dt=pd.read_excel(filename,sheetname)
    # dt=pd.read_excel(filename,sheetname,index_col='id')
    dt_in=dt[dt['target']==1]
    in_index=list(dt_in.index)
    sampler=np.random.permutation(len(in_index))
    in_test=[in_index[i] for i in sampler[:sample]]
    in_valid=[in_index[i] for i in sampler[sample:]]
    #
    #
    # # print(dt_in)


    dt_out=dt[dt['target']==0]
    out_index=list(dt_out.index)
    sampler=np.random.permutation(len(out_index))
    out_test=[out_index[i] for i in sampler[:sample*7]]
    out_valid=[out_index[i] for i in sampler[sample*7:]]
    test=dt.reindex(in_test+out_test)
    valid=dt.reindex(in_valid+out_valid)


    return test,valid,in_test+out_test,in_valid+out_valid

def model_fit(alg,X,y,invarname,n_high):

    # alg.fit(X,y)

    d_pred=alg.predict(X)
    d_predprob=alg.predict_proba(X)[:,1]


    # 交叉验证
    cv_score=cross_val_score(alg,X,y,cv=5,scoring=ksscore)
    accuracy=metrics.accuracy_score(y,d_pred)
    auc=metrics.roc_auc_score(y,d_predprob)
    ks,high_prop=ksvar(y,d_predprob,n_high)

    print("\nModel Report")
    # print("Accuracy : %.4g"% accuracy)
    # print("AUC Score (Train){}".format(auc))
    print("Ks :%.6g"%ks)
    print("high_risk_badrate:{}".format(high_prop))

    print("KS Score :Mean - {} |Std - {} |Min - {} | Max - {}".format(np.mean(cv_score),np.std(cv_score),np.min(cv_score),np.max(cv_score)))

    feat_imp=pd.Series(alg.feature_importances_,invarname).sort_values(ascending=False)
    # feat_imp.to_csv('feature.csv',sep='\t')
    # print(feat_imp)
    # feat_imp.plot(kind='bar',title='Feature Importances')
    # plt.ylabel('Feature Importance Score')
    # plt.show()
    # return feat_imp

# ks值
def ksvar(y,prob,nn):
    tmp=zip(y,prob)
    tmp1=pd.DataFrame(list(tmp),columns=['target','pred'])
    npr=tmp1[tmp1['target']==0]
    ppr=tmp1[tmp1['target']==1]
    tmp2=tmp1.sort_values('pred',ascending=False)
    tt=tmp2.count()['target']
    tmp3=tmp2[:int(tt/nn)+1]
    rk=[tt*(i+1)+1 for i in range(nn)]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic,tmp3.mean()['target']

def ksscore(alg,X,y):
    d_predprob = alg.predict_proba(X)[:, 1]

    tmp = zip(y,d_predprob)
    tmp1 = pd.DataFrame(list(tmp),columns=['target','pred'])
    npr = tmp1[tmp1['target']==0]
    ppr = tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic



# 训练模型
def train(dt):
    test,valid,samix=read_data(dt,4500)
    # print(test.shape)
    X=test.drop('target',axis=1)
    y=test['target']
    predictors=[x for x in test.columns if x not in['target']]
    # clf=GradientBoostingClassifier(n_estimators=100, learning_rate=0.1,
    # max_depth=2, min_samples_split=2000,min_samples_leaf=40,max_features=9,subsample=0.8,random_state=10).fit(X, y)
    #
    # model_fit(clf,X,y,predictors,20)
    #
    # joblib.dump(clf, "D:\python\my_model\my_train_model.m")

    # # 网格搜索

    # n_estimators等于220时最优
    # max_depth；3，min_samples_split：200,min_samples_leaf:30,max_features:11,subsample：0.8

    param_test1={'n_estimators':list(range(60,201,20))}
    # param_test2={'max_depth':list(range(2,4,1)),'min_samples_split':list(range(200,201,200))}
    # param_test3={'min_samples_leaf':list(range(30,121,10))}
    # param_test4={'max_features':list(range(7,19,1))}
    # param_test5={'subsample':[0.6,0.7,0.75,0.8,0.85,0.9]}

    gsearch1=GridSearchCV(estimator=GradientBoostingClassifier(learning_rate=0.05,
                                                               # n_estimators=200,
                                                               max_depth=4,
                                                               min_samples_split=600,
                                                               min_samples_leaf=50,
                                                               max_features='sqrt',
                                                               random_state=10,subsample=0.8),
                          param_grid=param_test1,scoring=ksscore,n_jobs=4,cv=5)
    gsearch1.fit(X,y)
    print(gsearch1.grid_scores_,gsearch1.best_params_,gsearch1.best_score_)
    model_fit(gsearch1.best_estimator_,X,y,predictors,20)




    # 验证数据
    # valid1=pd.read_excel("valid1216.xls","Sheet",index_col='id')
    X1=valid.drop('target',axis=1)
    y1=valid['target']
    d_predprob=gsearch1.best_estimator_.predict_proba(X1)[:,1]
    ks,high_prop=ksvar(y1,d_predprob,20)
    # auc=metrics.roc_auc_score(y1,d_predprob)
    print("Ks :%.6g"%ks)
    print("high_risk_badrate:{}".format(high_prop))

    # clf1=joblib.load("D:\python\my_model\my_train_model.m")
    # d_predprob=clf1.predict_proba(X1)[:,1]
    # ks,high_prop=ksvar(y1,d_predprob,20)
    # # auc=metrics.roc_auc_score(y1,d_predprob)
    # print("Ks :%.6g"%ks)
    # print("high_risk_badrate:{}".format(high_prop))


    # model_fit(gsearch1.best_estimator_,X1,y1,predictors,10)
    # return feat_imp






def train1(dt,f1,f2,bin):
    test,valid,saminx,samoutx=read_data(dt,1875)
    # print(test.shape)
    X=test.drop(['target'],axis=1)
    y=test['target']
    predictors=[x for x in test.columns if x not in['target']]
    X1=valid.drop(['target'],axis=1)
    y1=valid['target']

    # for i in range(2,3,1):
    #     for j in range(200,201,20):
    clf=GradientBoostingClassifier(n_estimators=120, learning_rate=0.1,
        max_depth=2, min_samples_split=600,min_samples_leaf=50,max_features=7,subsample=0.8,random_state=10).fit(X, y)

    d_predprob1=clf.predict_proba(X)[:,1]
    ks1,high_prop1=ksvar(y,d_predprob1,20)

    d_predprob2=clf.predict_proba(X1)[:,1]
    ks2,high_prop2=ksvar(y1,d_predprob2,20)
    ks=[bin,ks1,ks2]
    prop=[bin,high_prop1,high_prop2]

    f1.write(str(ks)+'\n')
    f2.write(str(prop)+'\n')
    return saminx,samoutx












######--------------------------------上面是随机抽样数据----------------------------------------######

if __name__ == '__main__':
    # 读取excel
    exceldata=pd.read_csv('train0109.csv',index_col='applycode')
    print(exceldata.shape)
    # print(exceldata1.shape)
    f1=open('res1.txt','w')
    f2=open('res2.txt','w')

    # 随机抽样50次
    result,fk=train1(exceldata,f1,f2,0)
    result1=pd.DataFrame({0:result})
    fk1=pd.DataFrame({0:fk})
    for i in range(1,100):
        saminx,samoutx=train1(exceldata,f1,f2,i)
        saminx1=pd.DataFrame({i:saminx})
        samoutx1=pd.DataFrame({i:samoutx})

        result1=result1.join(saminx1)
        result1.to_csv('feature.csv',sep='\t')

        fk1=fk1.join(samoutx1)
        fk1.to_csv('feature1.csv',sep='\t')






