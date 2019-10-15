# -*- coding: utf-8 -*-
import time
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeClassifier
from sklearn.externals import joblib
from sklearn.ensemble import GradientBoostingClassifier
from sklearn import cross_validation,metrics
from sklearn.grid_search import GridSearchCV
from scipy.stats import ks_2samp
from sklearn.feature_selection import SelectFromModel
from sklearn.metrics import make_scorer
from multiprocessing import Pool

def read_data(dt,sample):
    # dt=pd.read_excel(filename,sheetname)
    # dt=pd.read_excel(filename,sheetname,index_col='id')
    dt_in=dt[dt['target']==1]
    in_index=list(dt_in.index)
    sampler=np.random.permutation(len(in_index))
    in_test=[in_index[i] for i in sampler[:sample]]
    in_valid=[in_index[i] for i in sampler[sample:]]



    dt_out=dt[dt['target']==0]
    out_index=list(dt_out.index)
    sampler=np.random.permutation(len(out_index))
    out_test=[out_index[i] for i in sampler[:sample*9]]
    out_valid=[out_index[i] for i in sampler[sample*9:]]
    test=dt.reindex(in_test+out_test)
    valid=dt.reindex(in_valid+out_valid)


    return test,valid,in_test+out_test
def model_fit(alg,X,y,invarname,n_high):

    # alg.fit(X,y)

    d_pred=alg.predict(X)
    d_predprob=alg.predict_proba(X)[:,1]


    # 交叉验证
    # cv_score=cross_validation.cross_val_score(alg,X,y,cv=5,scoring=ksscore)
    accuracy=metrics.accuracy_score(y,d_pred)
    auc=metrics.roc_auc_score(y,d_predprob)
    ks,high_prop=ksvar(y,d_predprob,n_high)

    print("\nModel Report")
    # print("Accuracy : %.4g"% accuracy)
    print("AUC Score (Train){}".format(auc))
    print("Ks :%.6g"%ks)
    print("high_risk_badrate:{}".format(high_prop))

    # print("KS Score :Mean - {} |Std - {} |Min - {} | Max - {}".format(np.mean(cv_score),np.std(cv_score),np.min(cv_score),np.max(cv_score)))

    feat_imp=pd.Series(alg.feature_importances_,invarname).sort_values(ascending=False)
    feat_imp.to_csv('feature.csv',sep='\t')
    # print(feat_imp)
    # feat_imp.plot(kind='bar',title='Feature Importances')
    # plt.ylabel('Feature Importance Score')
    # plt.show()
    # return feat_imp

# ks值
# def ksvar(y,prob,nn):
#     tmp=zip(y,prob)
#     # print(list(tmp))
#     tmp1=pd.DataFrame(list(tmp),columns=['target','pred'])
#     npr=tmp1[tmp1['target']==0]
#     ppr=tmp1[tmp1['target']==1]
#     tmp2=tmp1.sort_values('pred',ascending=False)
#     tt=tmp2.count()['target']
#     perbin=int(tt/nn)
#     # for i in range(nn):
#     #     tmp3=tmp2[perbin*i:perbin*(i++1)+1]
#     #     tmp3.mean()['target']
#     b=list(range(nn))
#     allprob=list(map(lambda x:tmp2[perbin*x:perbin*(x+1)].mean()['target'],b))
#     plt.plot(np.arange(nn),allprob)
#     plt.plot(np.arange(nn),allprob,'or')
#     plt.show()
#     return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic,allprob

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
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic

def ksscore(alg,X,y):
    d_predprob=alg.predict_proba(X)[:,1]

    tmp=zip(y,d_predprob)

    tmp1=pd.DataFrame(list(tmp),columns=['target','pred'])
    npr=tmp1[tmp1['target']==0]
    ppr=tmp1[tmp1['target']==1]
    return ks_2samp(npr['pred'].values,ppr['pred'].values).statistic


def multiks(X,X1,y,y1,i,j,k,l,m):

    clf=GradientBoostingClassifier(n_estimators=i, learning_rate=0.1,
    max_depth=2, min_samples_split=j,min_samples_leaf=k,max_features=l,subsample=m,random_state=10).fit(X, y)


    d_predprob1=clf.predict_proba(X)[:,1]
    ks1=ksvar(y,d_predprob1,20)

    d_predprob2=clf.predict_proba(X1)[:,1]
    ks2=ksvar(y1,d_predprob2,20)
    ks=[i,j,k,l,m,ks1,ks2]
    return ks




# 训练模型
def train(dt):
    test=dt[dt['fg']==1]
    valid=dt[dt['fg']==0]
    X=test.drop(['target','fg'],axis=1)
    y=test['target']
    X1=valid.drop(['target','fg'],axis=1)
    y1=valid['target']
    predictors=[x for x in test.columns if x not in['target','fg']]

    p=Pool(3)
    ksall=[]
    for n_es in range(60,181,20):
        for n_split in range(200,2001,200):
            for n_leaf in range(30,81,10):
                for n_feature in range(6,13,1):
                    for n_sample in [0.7,0.75,0.8,0.85]:
                        ksall.append(p.apply_async(multiks,args=(X,X1,y,y1,n_es,n_split,n_leaf,n_feature,n_sample)))
    p.close()
    p.join()
    with open('ks1.txt','a+') as rd:
        for ks in ksall:
            # print(ks.get())
            rd.write(str(ks.get())+'\n')





    # model_fit(clf,X,y,predictors,20)
    #
    # joblib.dump(clf, "D:\python\my_model\my_train_model.m")

    # # 网格搜索

    # n_estimators等于220时最优
    # max_depth；3，min_samples_split：200,min_samples_leaf:30,max_features:11,subsample：0.8

    # param_test1={'n_estimators':list(range(60,201,20))}
    # param_test2={'max_depth':list(range(2,4,1)),'min_samples_split':list(range(200,2001,200))}
    # param_test3={'min_samples_leaf':list(range(30,121,10))}
    # param_test4={'max_features':list(range(7,19,1))}
    # param_test5={'subsample':[0.6,0.7,0.75,0.8,0.85,0.9]}

    # gsearch1=GridSearchCV(estimator=GradientBoostingClassifier(learning_rate=0.1,
    #                                                            n_estimators=120,
    #                                                            # max_depth=3,
    #                                                            # min_samples_split=600,
    #                                                            min_samples_leaf=40,
    #                                                            max_features=9,
    #                                                            random_state=10),
    #                       param_grid=param_test2,scoring=ksscore,n_jobs=4,cv=5)
    # gsearch1.fit(X,y)
    # print(gsearch1.grid_scores_,gsearch1.best_params_,gsearch1.best_score_)
    # model_fit(gsearch1.best_estimator_,X,y,predictors,20)




    # 验证数据
    # valid1=pd.read_excel("valid1216.xls","Sheet",index_col='id')


    # 用保存的模型试验效果
    # clf1=joblib.load("D:\python\my_model\my_train_model.m")
    # d_predprob=clf1.predict_proba(X1)[:,1]
    # ks,high_prop=ksvar(y1,d_predprob,20)
    # # auc=metrics.roc_auc_score(y1,d_predprob)
    # print("Ks :%.6g"%ks)
    # print("high_risk_badrate:{}".format(high_prop))














######--------------------------------上面是随机抽样数据----------------------------------------######

if __name__ == '__main__':
    # 读取excel
    sta=time.time()
    exceldata=pd.read_csv('train0110.csv',index_col='applycode')
    print(exceldata.shape)
    train(exceldata)
    end=time.time()
    print('process dura {}'.format(end-sta))








