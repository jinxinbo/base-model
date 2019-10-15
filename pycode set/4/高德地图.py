#coding=utf-8

import requests
import datetime
import pandas as pd


def locatebyAddr(address):

    items = {'output': 'json', 'key': 'aacf4756a5da765d3ea8e4558812c878', 'address': address}

    try:
        r = requests.get('http://restapi.amap.com/v3/geocode/geo?', params=items)
        dictResult = r.json()

        if dictResult['status'] == 0 or dictResult is None:

            address_tmp = address.strip().split(';')[0]
            items_tmp = {'output': 'json', 'key': 'aacf4756a5da765d3ea8e4558812c878', 'address': address_tmp}

            r_tmp = requests.get('http://restapi.amap.com/v3/geocode/geo?', params=items_tmp)
            dictResult_tmp = r_tmp.json()

            if dictResult_tmp['status'] == 0 or dictResult_tmp is None:
                return None

            else:

                return dictResult_tmp['geocodes'][0]['location']
        else:

             return dictResult['geocodes'][0]['location']

    # except requests.exceptions.ConnectTimeout as e:
    #     return 'error'
    except:
        return 'error'

print(locatebyAddr('江苏省苏州市吴江区谢庄浜;頔塘路与震庙线路口东148米'))


# if __name__ == '__main__':
#
#     rd_tab = pd.read_table(r'C:\Users\xinbo.jin\Desktop\label.txt',
#                             index_col = 'ime',
#                             sep = '\t',
#                             header = None,
#                             names = ['ime', 'addr1', 'addr2'])

    # print(rd_tab0.head())
    # rd_tab = rd_tab0.head(10)

    # rd_tab['addr1_coord'] = rd_tab['addr1'].apply(locatebyAddr)
    # rd_tab['addr2_coord'] = rd_tab['addr2'].apply(locatebyAddr)
    #
    # wt_tab = rd_tab[['addr1_coord', 'addr2_coord']]
    #
    # wt_tab.to_csv('coord.csv', sep='\t')







# branch['sum']=branch['comaddress1']+branch['resaddress1']
# print(branch)
# 下面是高德地图计算车程
# def getdura(start,stop):
#     url='http://restapi.amap.com/v3/direction/driving?'
#     items={'output': 'json', 'key': 'aacf4756a5da765d3ea8e4558812c878','origin':start,'destination':stop}
#     r=requests.get(url, params =items)
#     dictResult = r.json()
#     dura=dictResult['route']['paths'][0]['duration']
#     # distance=dictResult['route']['paths'][0]['distance']
#     return dura
# # #
# # a='120.196953,30.480179'
# # b='120.191983,30.480892'
# # dura,dis=getdura(a,b)
# # print(dura)
# # print(dis)
# branch['dura']=getdura(branch['comaddress1'],branch['resaddress1'])
# print(branch)
