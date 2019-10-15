#coding=utf-8

import time
import requests
import datetime
import pandas as pd


def locatebyAddr(address):

    items = {'output': 'json', 'key': 'UD2BZ-DAR3X-K6P4R-7M2ZK-V5VZT-PRBP5', 'address': address}

    try:
        time.sleep(0.2)
        r = requests.get('http://apis.map.qq.com/ws/geocoder/v1/', params=items)
        dictResult = r.json()

        if dictResult['status'] != 0 or dictResult is None:

            address_tmp = address.strip().split(';')[0]
            items_tmp = {'output': 'json', 'key': 'UD2BZ-DAR3X-K6P4R-7M2ZK-V5VZT-PRBP5', 'address': address_tmp}

            r_tmp = requests.get('http://apis.map.qq.com/ws/geocoder/v1/', params=items_tmp)
            dictResult_tmp = r_tmp.json()

            if dictResult_tmp['status'] != 0 or dictResult_tmp is None:
                return None

            else:
                coord0_tmp=dictResult_tmp['result']['location']
                coord_tmp = str(round(coord0_tmp['lng'], 6)) + "," + str(round(coord0_tmp['lat'], 6))

                return coord_tmp
        else:
            coord0=dictResult['result']['location']
            coord=str(round(coord0['lng'],6))+","+str(round(coord0['lat'],6))

            return coord

    # except requests.exceptions.ConnectTimeout as e:
    #     return 'error'
    except:
        return 'error'

print(locatebyAddr('江苏省苏州市吴江区谢庄浜;頔塘路与震庙线路口东148米'))


if __name__ == '__main__':

    now = datetime.datetime.now()
    print(now)

    rd_tab0 = pd.read_table(r'C:\Users\xinbo.jin\Desktop\label.txt',
                            index_col = 'ime',
                            sep = '\t',
                            header = None,
                            names = ['ime', 'addr1', 'addr2'])

    rd_tab = rd_tab0.head(100)
    print(rd_tab0.head())

    rd_tab['addr1_coord'] = rd_tab['addr1'].apply(locatebyAddr)
    rd_tab['addr2_coord'] = rd_tab['addr2'].apply(locatebyAddr)

    wt_tab = rd_tab[['addr1_coord', 'addr2_coord']]

    wt_tab.to_csv('tencent_coord.csv', sep='\t')

    now = datetime.datetime.now()
    print(now)