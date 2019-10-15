# -*- coding: utf-8 -*-
import requests
from bs4 import BeautifulSoup
import urllib.request
from urllib.error import HTTPError,URLError

url_qx=[]
def url_quxian(url):
    wb_data=requests.get(url)
    soup=BeautifulSoup(wb_data.text,'lxml')
    # print(soup)
    infomation=soup.select('div.div-border.items-list > div > span.item-title')
    infomation1=[i.next_sibling.find_all('a')  for i in infomation if i.get_text()=="区域："]

    # print(infomation1)
    for url in infomation1[0]:
        data={'url':url.get('href'),'address':url.get_text()}
        # print(data)
        url_qx.append(data)

url_quxian("http://beijing.anjuke.com/sale/")
# print(url_qx)
# url_quxian1=url_qx[1:]
url_qx2=[]
for i in range(len(url_qx)):
    url_qx2.append(url_qx[i]['url'].split('/')[4])
#
for i in range(len(url_qx)):
    try:
        url="http://beijing.anjuke.com/market/{}/?from=listing".format(url_qx2[i])
        print(url_qx[i]['address'])
        rel=urllib.request.urlopen(url).read().decode('utf-8')
        soup=BeautifulSoup(rel,'lxml')
        infom=soup.select('div[class="trendR"] > h2 > em')
        print(infom[0].get_text())
        infom1=soup.select('div[class="trendR"] > h2 > i')
        print(infom1[1].get_text())
    except HTTPError as e:
        print('HTTPError:',e.code)
    except IndexError as e:
        print('null')


