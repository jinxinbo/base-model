# -*- coding: utf-8 -*-
import urllib.request
import pandas as pd
import re
import pandas as pd

def get_city(num):
    url='http://idcard.jyc.la/id_{}.html'.format(num)
    page=urllib.request.urlopen(url).read().decode('utf-8')
    # print(page)

    linkre = re.compile('src=\"./map.htm\?\d+&(.+?)\"')
    city=linkre.findall(page)
    return city

ct=get_city('411522')
print(ct)

# branch=pd.read_excel('cardno.xls','sheet1')
# print(branch)
# branch['value']=branch['card_x'].apply(get_city)
# branch.to_csv('cardno.csv',sep='\t')



http://www.ip138.com:8080/search.asp?mobile=1351155&action=mobile
