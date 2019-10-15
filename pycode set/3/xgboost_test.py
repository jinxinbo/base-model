#coding=utf-8

import pandas as pd
import xgboost as xgb
import os,random,pickle
from sklearn.model_selection import train_test_split

os.makedirs('features')


dt = pd.read_excel(r'E:\python工程\cash_tree\tmp.xlsx',index_col='cus_id')
train, test = train_test_split(dt, test_size=0.1,random_state=1234)

train_X, train_y = train.drop(['target'], axis=1), train.target
test_X, test_y = test.drop(['target'], axis=1), test.target

d_train = xgb.DMatrix(train_X, label=train_y)
d_test = xgb.DMatrix(test_X, label=test_y)

print(train_X.shape, test_X.shape)


def pipeline(iteration, random_seed, gamma, max_depth, lambd,subsmaple, colsample_bytree, min_child_weight):

    parmas={
            'booster':'gbtree',
            'objective':'rank:pairwise',
            'scale_pos_wieght':float(len(train_y)-sum(train_y))/float(sum(train_y)),
            'eval_metric':'auc',
            'gamma':gamma,
            'max_depth':max_depth,
            'lambda':lambd,
            'subsmaple':subsmaple,
            'colsample_bytree':colsample_bytree,
            'min_child_weight':min_child_weight,
            'eta':0.2,
            'seed':random_seed,
            'nthread':8
            }

    watchlist = [(d_train,'train'),(d_test,'test')]
    model = xgb.train(parmas, d_train, num_boost_round=100, evals=watchlist)

    feature_score = model.get_fscore()#feature_importance
    feature_score = sorted(feature_score.items(), key=lambda x:x[1], reverse=True)
    fs=[]

    for (key, value) in feature_score:
        fs.append("{0},{1}\n".format(key, value))

    with open('feature_score_{0}.csv'.format(iteration),'w') as f:
        f.writelines("feature, score\n")
        f.writelines(fs)


if __name__ == "__main__":
    random_seed = list(range(10000,20000,100))
    gamma = [i/1000.0 for i in range(0,300,3)]
    max_depth = [5,6,7]
    lambd = list(range(400,600,2))
    subsample = [i/1000.0 for i in range(500,700,2)]
    colsmaple_bytree = [i/1000.0 for i in range(550,750,4)]
    min_child_weight = [i/1000.0 for i in range(250,550,3)]

    random.shuffle(random_seed)
    random.shuffle(gamma)
    random.shuffle(max_depth)
    random.shuffle(lambd)
    random.shuffle(subsample)
    random.shuffle(colsmaple_bytree)
    random.shuffle(min_child_weight)

    # with open('parmas.pkl','w') as f:
    #     pickle.dump((random_seed,gamma,max_depth,lambd,subsample,colsmaple_bytree,min_child_weight),f)


    for i in range(36):
        pipeline(i,random_seed[i],gamma[i],max_depth[i%3],lambd[i],subsample[i],colsmaple_bytree[i],min_child_weight[i])


