# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
import urllib.request
url='http://sz.lianjia.com/ershoufang/'
rq_url=urllib.request.urlopen(url).read().decode('utf-8')
soup=BeautifulSoup(rq_url,'lxml')
# print(soup)
infom=soup.select('div[data-role="ershoufang"] > div > a')
# print(infom)
url_qx=[]
for url in infom:
    data={'url':url.get('href'),'address':url.get_text()}
    # print(data)
    url_qx.append(data)
url_qx2=[]
for i in range(9):
    url_qx2.append(url_qx[i]['url'].split('/')[2])
    # print(url_qx[i]['url'].split('/')[2])
url_qx3=[]
for i in range(9):
    url='http://sz.lianjia.com/ershoufang/{}/'.format(url_qx2[i])
    wb_data=urllib.request.urlopen(url).read().decode('utf-8')
    soup=BeautifulSoup(wb_data,'lxml')
    inform=soup.select('div > b ')
    inform1=inform[0].find_next_siblings('a')
    # print(inform1)
    for url in inform1:
        data={'url':url.get('href'),'address':url.get_text()}
        print(data)
        url_qx3.append(data)
# url_qx4=[]
# for i in url_qx3:
#     url_qx4.append(i['url'].split('/')[2])

