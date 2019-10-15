# -*- coding: utf-8 -*-
import urllib.request
import pandas as pd
import re
from bs4 import BeautifulSoup
import csv

def search_street(urlx,proname,cityname):
    sub_url0='http://www.tcmap.com.cn'
    suburl=sub_url0+urlx
    try:
        sub_page=urllib.request.urlopen(suburl).read().decode('gbk')

        sp=BeautifulSoup(sub_page,'lxml')
        aa=sp.find_all('tr',bgcolor="#f8f8f8")
        # print(a)
        bb=sp.find_all('tr',bgcolor="#ffffff")
        # print(b)
        for sub_a in aa:
            findc=sub_a.find_all(class_='blue',href=re.compile(proname+'(.*?).html'))
            city=[i.string for i in findc]
            city0=city[0]
            re_city=re.compile(cityname)
            if not re_city.findall(city0):
                writer.writerow(city0)
        for sub_b in bb:
            findc=sub_b.find_all(class_='blue',href=re.compile(proname+'(.*?).html'))
            try:
                city=[i.string for i in findc]
                city0=city[0]
                re_city=re.compile(cityname)
                if not re_city.findall(city0):
                    writer.writerow(city0)
            except IndexError:
                writer.writerow('')
    except UnicodeDecodeError:
        writer.writerow(suburl)


writer=csv.writer(open("sub_city.csv","w",encoding = 'utf-8'))
url='http://www.tcmap.com.cn/hunan'

page=urllib.request.urlopen(url).read().decode('gbk')
soup=BeautifulSoup(page,'lxml')

a=soup.find_all('tr',bgcolor="#f8f8f8")
# print(a)
b=soup.find_all('tr',bgcolor="#ffffff")
for sub_a in a:
    a_findc=sub_a.find_all(class_='blue',href=re.compile('hunan'))
    a_findc1=a_findc[1:]
    a_findc0=a_findc[0].string
    writer.writerow(a_findc0)
    for i in a_findc1:
        writer.writerow(i.string)
        subcity=i.attrs['href']
        search_street(subcity,'hunan',a_findc0)
for sub_b in b:
    b_findc=sub_b.find_all(class_='blue',href=re.compile('hunan'))
    b_findc1=b_findc[1:]
    b_findc0=b_findc[0].string
    writer.writerow(b_findc0)
    for i in b_findc1:
        writer.writerow(i.string)
        subcity=i.attrs['href']
        search_street(subcity,'hunan',b_findc0)



