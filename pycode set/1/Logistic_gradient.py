import time
from math import *
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import metric

def load_data(dat, index):

    data1 = pd.read_csv(dat, index_col=index)

    X, y = data1.drop('target', axis=1), data1[['target']]

    return X, y

def sigmod(x):
    '''

    :param x: the linear score
    :return: pred
    '''
    return 1/(1 + exp(-x))

# def cost_func(y, pred):
#
#     if y == 1:
#         return log(pred)
#     else:
#         return log(1 - pred)

def plot_loss_func(func_size, func_loss, lr):

    plt.figure()
    plt.xlabel("update_num")
    plt.ylabel("loss func")
    plt.plot(func_size, func_loss, 'o-', color="b", label = 'learing_rate:%s'%lr)

    plt.legend(loc="best")
    plt.show()

    return plt


def gradient_update_theta(X, y, alpha, update_num):
    '''
    :param x: the input dataset
    :param y: the input label
    :param alpha: the learning rate
    :return theta: the intercept
    '''
    X_design = np.hstack((np.ones(shape=(X.shape[0], 1)), X))
    intercept_0  = np.log(sum(y) / (len(y) - sum(y)))
    theta = np.hstack((intercept_0, np.zeros(shape=(X.shape[1])))).T

    loss_func_list = []
    while update_num > 0 :

        pred = np.dot(X_design, theta)
        pred_df = pd.DataFrame(pred, columns=['pred'])

        pred_df['sig_pred'] = pred_df['pred'].apply(sigmod)

        loss_vlaue = y - pred_df['sig_pred'].values.ravel()

        #取每次迭代的损失函数
        loss_func = y * pred + np.log(1 - pred_df['sig_pred'].values.ravel())
        loss_func_sum = -1 * loss_func.sum()
        loss_func_list.append(loss_func_sum)

        theta = theta + alpha * np.dot(X_design.T, loss_vlaue)##梯度更新，可以增加限制条件

        # print(np.dot(X_design.T, loss_vlaue))

        update_num -= 1

    return theta, pred_df['sig_pred'].values.ravel(), loss_func_list


def newton_method(X, y, update_num):
    '''
    :param x: the input dataset
    :param y: the input label
    :return theta: the intercept
    '''

    X_design = np.hstack((np.ones(shape=(X.shape[0], 1)), X))
    intercept_0 = np.log(sum(y) / (len(y) - sum(y)))
    theta = np.hstack((intercept_0, np.zeros(shape=(X.shape[1])))).T
    loss_func_list= []
    while update_num > 0:

        pred = np.dot(X_design, theta)
        pred_df = pd.DataFrame(pred, columns=['pred'])

        pred_df['sig_pred'] = pred_df['pred'].apply(sigmod)

        loss_vlaue = y - pred_df['sig_pred'].values.ravel()
        gd_value = np.dot(X_design.T, loss_vlaue) ##一阶导数

        #取每次迭代的损失函数
        loss_func = y * pred + np.log(1 - pred_df['sig_pred'].values.ravel())
        loss_func_sum = -1 * loss_func.sum()
        loss_func_list.append(loss_func_sum)

        ##二阶导数
        diag_array = np.multiply(pred_df['sig_pred'].values.ravel(), 1 - pred_df['sig_pred'].values.ravel())
        V = np.diag(np.array(diag_array).ravel())
        m1 = X_design.T.dot(V)
        m2 = m1.dot(X_design)
        cov_mat = np.linalg.inv(m2)

        theta = theta + np.dot(cov_mat, gd_value)

        update_num -= 1

    return theta, pred_df['sig_pred'].values.ravel(), loss_func_list


if __name__ == '__main__':
    startTime = time.time()

    data_name = 'woe_xb_0320.csv'
    train_X, train_y = load_data(data_name, 'user_sid')
    train_X.drop('weight', axis =1, inplace=True)
    train_X_v = train_X.values
    train_y_v = train_y.values.ravel()
    feature_name = list(train_X)
    feature_name.insert(0, 'Intercept')  # the varname

    update_num = 100
    learing_rate = 0.006
    test_theta, pred, loss_func_list = gradient_update_theta(train_X_v, train_y_v, learing_rate, update_num)

    # test_theta, pred, loss_func_list = newton_method(train_X_v, train_y_v, update_num)

    feature_coef = pd.DataFrame()
    feature_coef['name'] = feature_name
    feature_coef['coef'] = test_theta

    ks = metric.ksscore(pred, train_y_v) #ks value

    wald_stats = metric.wald_test(train_X_v, pred, test_theta)  #wald test :to evaluate the var importance
    feature_coef['chisq'] = wald_stats
    feature_coef.sort_values('chisq', ascending=False, inplace=True)

    print(feature_coef,'\n\n' ,'ks = ', ks)

    print('dura_time =', time.time() - startTime)

    plot_loss_func(list(range(update_num)), loss_func_list, learing_rate)  # 绘制损失函数曲线



