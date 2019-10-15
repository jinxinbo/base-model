#coding = utf-8

import numpy as np
import pandas as pd


sample_set = pd.read_excel('/data.xlsx')

def calc_var_median(sample_set):
    '''
    计算相邻变量的中位数
    '''

    var_list = list(np.unique(sample_set.loc[:, 'var']))
    var_list.sort()
    var_median_list = []
    for i in range(len(var_list) - 1):
        var_median = (var_list[i] + var_list[i+1]) / 2
        var_median_list.append(var_median)

    return var_median_list


def choose_best_split(sample_set, min_sample):
    '''
    使用cart分类决策树选择最好的样本切分点
    '''
    var_median_list = calc_var_median(sample_set)

    sample_cnt = sample_set.shape[0]
    sample1_cnt = sum(sample_set['target'])
    sample0_cnt = sample_cnt - sample1_cnt

    Gini = 1 - np.square(sample1_cnt / sample_cnt) -np.square(sample0_cnt / sample_cnt)

    best_Gini = 0.0; bestSplit_point = 0.0

    for split in var_median_list:
        left = sample_set[sample_set['var'] < split][['var', 'target']]
        right = sample_set[sample_set['var'] > split][['var', 'target']]

        left_cnt = left.shape[0];right_cnt = right.shape[0]
        left1_cnt = sum(left['target']);right1_cnt = sum(right['target'])
        left0_cnt = left_cnt - left1_cnt;right0_cnt = right_cnt - right1_cnt
        left_ratio = left_cnt / sample_cnt; right_ratio = right_cnt / sample_cnt

        if left_cnt < min_sample or right_cnt < min_sample:
            continue

        Gini_left = 1 - np.square(left1_cnt / left_cnt) - np.square(left0_cnt / left_cnt)
        Gini_riht = 1 - np.square(right1_cnt / right_cnt) - np.square(right0_cnt / right_cnt)

        Gini_temp = Gini - (left_ratio * Gini_left + right_ratio * Gini_riht)

        if Gini_temp > best_Gini:
            best_Gini = Gini_temp;bestSplit_point = split
        else:
            continue

        Gini = Gini - best_Gini
        return bestSplit_point


    def bining_data_split(sample_set, min_sample, split_list):
        '''
        划分数据找到最优分割点list

        '''

        split = choose_best_split(sample_set, min_sample)
        split_list.append(split)

        sample_set_left = sample_set[sample_set['var'] < split][['var', 'target']]
        sample_set_right = sample_set[sample_set['var'] > split][['var', 'target']]

        if len(sample_set_left) >= min_sample * 2:
            bining_data_split(sample_set_left, min_sample, split)

        else:
            None


        if len(sample_set_right) >= min_sample * 2:
            bining_data_split(sample_set_right, min_sample, split)
        else:
            None


    def get_bestslpit_list(sample_set):

        min_sample = sample_set.shape[0] * 0.05
        split_list = []

        bining_data_split(sample_set, min_sample, split_list)

        return split_list







































