# -*- coding: utf-8 -*-
import urllib.request
import pandas as pd
import re
from bs4 import BeautifulSoup
import csv


def admins(pro_name):
    url0='http://www.tcmap.com.cn/'
    url=url0+pro_name
    page=urllib.request.urlopen(url).read().decode('gbk')
    # print(page)

    soup=BeautifulSoup(page,'lxml')

    a=soup.find_all('tr',bgcolor="#f8f8f8")
    b=soup.find_all('tr',bgcolor="#ffffff")
    for sub_a in a:
        findc=sub_a.find_all(class_='blue',href=re.compile(pro_name))
        city=[i.string for i in findc]
        writer.writerow(city)
    for sub_b in b:
        findc=sub_b.find_all(class_='blue',href=re.compile(pro_name))
        city=[i.string for i in findc]
        writer.writerow(city)

writer=csv.writer(open("city.csv","w"))
proall=['anhui',
'fujian',
'gansusheng',
'guangdong',
'guangxi',
'guizhou',
'hainan',
'hebei',
'henan',
'hubei',
'hunan',
'jiangsu',
'jiangxi',
'liaoning',
'ningxia',
'qinghai',
'shandong',
'shanxi',
'sichuan',
'xinjiang',
'yunan',
'zhejiangsheng',
'chongqin',
'shanxisheng',
'neimenggu',
'Tibet']
for pro in proall:
    admins(pro)