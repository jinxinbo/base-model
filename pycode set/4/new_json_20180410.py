#!/usr/bin/env python
# -*- coding:utf-8 -*-

import json
import numpy as np
import pandas as pd

import copy



def cal_singal_var(data1, var, id):

    # 清洗一级json
    # var_name = list(data1[0][var][0].keys()) + ['house_holder', 'id']
    out_var = pd.DataFrame()  # 创建一个空的dataframe

    p_len = len(data1)
    for i in range(p_len):

        if len(data1[i]) > 0:
            var_value = pd.DataFrame(data1[i][var])

            var_value['house_holder'] = data1[i]['house_holder']
            var_value['id'] = id

            out_var = out_var.append(var_value)
    return out_var


def cal_singal_var_2(data1, id):

    # 清洗主表
    # var_name = [ i for i in list(data1[0]['lstNetBankDetailSummaryInfo'][0].keys()) if i not in
    #              ['transCategoryList','transTypeList','workDayTransList','nonWorkDayTransList']] \
    #            + ['card_id','month','house_holder', 'id']
    out_var = pd.DataFrame()  # 创建一个空的dataframe


    p_len = len(data1)
    for i in range(p_len):

        for j in range(len(data1[i]['lstNetBankDetailSummaryInfo'])):

            lt = {k: v for k, v in data1[i]['lstNetBankDetailSummaryInfo'][j].items() if k not in ['transCategoryList','transTypeList','workDayTransList','nonWorkDayTransList']}

            pd_lt = pd.DataFrame(lt, index=[0])

            pd_lt['card_id'] = data1[i]['lstNetBankDetailSummaryInfo'][j]['card_id']
            pd_lt['month'] = data1[i]['lstNetBankDetailSummaryInfo'][j]['month']
            pd_lt['id'] = id
            pd_lt['house_holder'] = data1[i]['house_holder']
            out_var = out_var.append(pd_lt)

    return out_var


def cal_singal_var_1(data1, var1, var2,id):

    # 清洗二级json
    # var_name = list(list(data1[0][var1][0][var2][0].keys())) + ['card_id','month','house_holder', 'id']
    out_var = pd.DataFrame()  # 创建一个空的dataframe

    p_len = len(data1)
    for i in range(p_len):

        if len(data1[i])>0:

            for j in range(len(data1[i][var1])):

                if len(data1[i][var1][j])>0:

                    var_value = pd.DataFrame(data1[i][var1][j][var2])

                    var_value['card_id'] = data1[i][var1][j]['card_id']
                    var_value['month'] = data1[i][var1][j]['month']
                    var_value['id'] = id
                    var_value['house_holder'] = data1[i]['house_holder']

                    out_var = out_var.append(var_value)

    return out_var

def cal_singal_var_0(data1, id):

    out_var = pd.DataFrame()  # 创建一个空的dataframe

    p_len = len(data1)
    for i in range(p_len):
        lt = {k: v for k, v in data1[i].items() if k not in ['lstNetBankCreditCardInfo', 'lstNetBankOrderDataInfo', 'lstNetBankCreditBillInfo','lstNetBankDepositCardInfo', 'lstNetBankDepositBillInfo', 'lstNetBankDetailSummaryInfo','salaryDetailList']}

        pd_lt = pd.DataFrame(lt, index=[0])

        pd_lt['id'] = id
        out_var = out_var.append(pd_lt)

    return out_var


if __name__ == "__main__":

    file_name = pd.read_excel(r'E:\卡牛项目\xxx\a.xls', 'a')
    file_name1 = list(file_name['name'])

    global out_lst
    out_lst=pd.DataFrame()

    # table_name = ['lstNetBankCreditCardInfo', 'lstNetBankOrderDataInfo', 'lstNetBankCreditBillInfo',
    #               'lstNetBankDepositCardInfo', 'lstNetBankDepositBillInfo', 'salaryDetailList']

    # table_name = ['transCategoryList', 'transTypeList', 'workDayTransList', 'nonWorkDayTransList']

    # for t_name in table_name:

    for fi in range(len(file_name1)):

        try:
            with open(r'E:\卡牛项目\xxx\{}'.format(file_name1[fi]), 'r', encoding='utf-8') as f:

                id = file_name1[fi].split('_')[0]

                print(id)
                data1 = json.load(f)

                if len(data1) > 0:

                    # s_var = cal_singal_var(data1, t_name, id)

                    s_var = cal_singal_var_0(data1, id)

                    if fi == 0:
                        out_lst = copy.deepcopy(s_var)
                    else:
                        out_lst = out_lst.append(s_var)

                        """
                        if len(data1[0]['lstNetBankDetailSummaryInfo'][0]['transCategoryList']) > 0:
                            s_var = cal_singal_var_1(data1, 'lstNetBankDetailSummaryInfo', 'transCategoryList', id)

                            if fi == 0:
                                out_lst = copy.deepcopy(s_var)
                            else:
                                out_lst = out_lst.append(s_var)
                        """
        except:
            data1 = []

    # out_lst.to_csv(r'E:\卡牛项目\xxx\lstNetBankDetailSummaryInfo_{}.csv'.format(t_name))

    out_lst.to_csv(r'E:\卡牛项目\xxx\user_info.csv')