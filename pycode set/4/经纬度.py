#coding=utf-8

import time
import requests
import datetime
import pandas as pd


def locatebyAddr(address):


    items = {'output': 'json', 'ak': 'ObQLdW3equfoPv6leHFcpzQk', 'address': address}

    try:
        time.sleep(0.1)
        r = requests.get('http://api.map.baidu.com/geocoder/v2/', params=items)
        dictResult = r.json()

        if dictResult['status'] != 0 or dictResult is None:

            address_tmp = address.strip().split(';')[0]
            items_tmp = {'output': 'json', 'ak': 'ObQLdW3equfoPv6leHFcpzQk', 'address': address_tmp}

            r_tmp = requests.get('http://api.map.baidu.com/geocoder/v2/', params=items_tmp)
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

print(locatebyAddr('北京大学'))
# branch=pd.read_excel('dd.xls','Sheet1')
# branch=branch.drop('START_TIME',axis=1)
# test=branch.head()
# test['comaddresscoord']=test['comaddress'].apply(locatebyAddr)
# test.to_csv('test1.csv',sep='\t')

# branch=pd.read_excel('comaddress.xls','sheet')
# branch1=branch.iloc[:10000,]
# branch2=branch.iloc[10001:,]
# branch3=branch.iloc[20001:30000,]
# branch4=branch.iloc[30001:40000,]
# branch5=branch.iloc[40001:,]

# branch1['comaddresscoord']=branch1['comaddress'].apply(locatebyAddr)
# branch['resaddresscoord']=branch['resaddress'].apply(locatebyAddr)
# branch.to_csv('code1.csv',sep='\t')

# branch2['comaddresscoord']=branch2['comaddress'].apply(locatebyAddr)
# branch2['resaddresscoord']=branch2['resaddress'].apply(locatebyAddr)
# branch2.to_csv('code4.csv',sep='\t')



# branch['comaddresscoord']=branch['comaddress'].apply(locatebyAddr)
# branch.to_csv('code2.csv',sep='\t')

# branch4['comaddresscoord']=branch4['comaddress'].apply(locatebyAddr)
# branch4.to_csv('code4.csv',sep='\t')

# branch5['comaddresscoord']=branch5['comaddress'].apply(locatebyAddr)
# branch5.to_csv('code5.csv',sep='\t')



if __name__ == '__main__':



    print(datetime.datetime.now())

    rd_tab0 = pd.read_table(r'C:\Users\xinbo.jin\Desktop\label.txt',
                            index_col = 'ime',
                            sep = '\t',
                            header = None,
                            names = ['ime', 'addr1', 'addr2'])

    rd_tab = rd_tab0.head(100)
    # print(rd_tab0.head())

    start_pro = time.time()

    rd_tab['addr1_coord'] = rd_tab['addr1'].apply(locatebyAddr)
    rd_tab['addr2_coord'] = rd_tab['addr2'].apply(locatebyAddr)

    dura = time.time() - start_pro
    print(dura)

    wt_tab = rd_tab[['addr1_coord', 'addr2_coord']]

    wt_tab.to_csv('baidu_coord.csv', sep='\t')

