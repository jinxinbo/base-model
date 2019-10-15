import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

from sklearn.decomposition import PCA


def real_results(reduced_data, preds):

    reduced_data = pd.DataFrame(reduced_data[:, :2], columns=['Dimesion 1', 'Dimesion 2'])

    predictions = pd.DataFrame(preds, columns=['Cluster'])
    plot_data = pd.concat([reduced_data, predictions], axis=1)

    fig, ax = plt.subplots(figsize = (14, 8))
    cmap = cm.get_cmap('gist_rainbow')

    for i, cluster in plot_data.groupby('Cluster'):
        print(cluster)
        cluster.plot(ax=ax, kind='scatter', x='Dimesion 1', y='Dimesion 2', \
                     color=cmap((i)*1.0/9), label = 'Cluster %i'%(i), s=30)

    ax.set_title('real_results')


def cluster_results(reduced_data, preds, centeres):

    reduced_data = pd.DataFrame(reduced_data[:, :2], columns=['Dimesion 1', 'Dimesion 2'])

    predictions = pd.DataFrame(preds, columns=['Cluster'])
    plot_data = pd.concat([reduced_data, predictions], axis=1)

    fig, ax = plt.subplots(figsize = (14, 8))
    cmap = cm.get_cmap('gist_rainbow')

    for i, cluster in plot_data.groupby('Cluster'):
        # print(cluster)
        cluster.plot(ax=ax, kind='scatter', x='Dimesion 1', y='Dimesion 2', \
                     color=cmap((i)*1.0/6), label = 'Cluster %i'%(i), s=30)

    for i, c in enumerate(centeres):
        ax.scatter(x=c[0], y=c[1], color='white', edgecolors='black',\
                   alpha=1, linewidth=2, marker='o', s=200)
        ax.scatter(x=c[0], y=c[1], marker='$%d$'%(i), alpha=1, s=100)
    ax.set_title('cluster_results')

# 样本输入
data_train = pd.read_csv('xgb_train.csv', index_col='user_sid', encoding='gbk')
d_train_X, d_train_y = data_train.drop(['target'], axis=1), data_train['target']

# 增加蜜罐变量
data_mg = pd.read_csv('data_mg_train.csv', index_col='user_sid', encoding='gbk')

d_train_X_0 = pd.concat([d_train_X, data_mg], axis=1)
d_train_X_0.drop(['target'], axis=1, inplace=True)

character_features = [c for c in d_train_X_0 if d_train_X_0[c].dtype.kind not in ('i', 'f')]
numeric_features = [c for c in d_train_X_0 if d_train_X_0[c].dtype.kind in ('i', 'f')]
d_train_X_1 = pd.get_dummies(d_train_X_0[character_features])

d_train_X_2 = pd.concat([d_train_X_0[numeric_features], d_train_X_1], axis=1)

var_drop_1 = ['m1_loan_sum',
'm3_loan_sum',
'm6_loan_sum',
'm12_loan_sum',
'm18_loan_sum'
]
var_drop_tz = [i for i in numeric_features if 'var_out' in i]
var_drop = var_drop_1 + var_drop_tz + ['score_l', 'score_s']

d_train_X_3 = d_train_X_2.drop(var_drop, axis=1)
d_train_X_3 = d_train_X_3.fillna(-999)

score = -1
for i in range(2, 15):
    kmeans = KMeans(n_clusters=i, random_state=0)
    test_preds = kmeans.fit_predict(d_train_X_3)
    test_score = silhouette_score(d_train_X_3, test_preds)
    print("test_score is ", test_score)

    if (score<test_score):
        best_clusternum = i
        score = test_score
        best_cluster = kmeans


# 原前2个特征特征
real_results(d_train_X_3.values, d_train_y.values)

# pca之后
pca = PCA(n_components=0.99)
data_pca = pca.fit_transform(d_train_X_3)
real_results(data_pca, d_train_y.values)



kmeans = KMeans(n_clusters=2, random_state=0)
test_preds = kmeans.fit_predict(data_pca)
test_score = silhouette_score(data_pca, test_preds)

centers = kmeans.cluster_centers_

cluster_results(data_pca, test_preds, centers)
