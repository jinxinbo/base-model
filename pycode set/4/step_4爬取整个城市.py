# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
import mysql.connector
import time
import urllib.request

# 中文不能写入问题,在mysql中新建数据库之前加上
# CREATE DATABASE `database` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

conn=mysql.connector.connect(user='root',database='database',charset='utf8')
cursor=conn.cursor()
# cursor.execute('create table house10 (prices VARCHAR (20),address VARCHAR (80));')
cursor.execute('create table house11 (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,prices VARCHAR (20),address VARCHAR (50));')


header = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'}
url_qx=[]
def url_quxian(url):
    # wb_data=requests.get(url)
    req=urllib.request.Request(url=url,headers=header)
    wb_data=urllib.request.urlopen(req).read().decode()
    # print(wb_data)
    soup=BeautifulSoup(wb_data,'lxml')
    # print(soup)
    # infomation=soup.select('div.multi-form > div >  a')
    infomation=soup.select('div.div-border.items-list > div > span.item-title')
    infomation1=[i.next_sibling.find_all('a')  for i in infomation if i.get_text()=="区域："]
    # print(infomation1)
    for url in infomation1[0]:
        data={'url':url.get('href'),'address':url.get_text()}
        # print(data)
        url_qx.append(data)
url_quxian("http://shenzhen.anjuke.com/sale/")
# print(url_qx)
url_quxian1=url_qx[1:]
url_qx2=[]
# for i in range(1,14):
#     url_qx2.append(url_qx[i]['url'].split('/')[4])
for i in range(len(url_qx)):
    url_qx2.append(url_qx[i]['url'].split('/')[4])
# print(url_qx2)
url_qx3=[]
for i in range(len(url_qx)):
    url="http://shenzhen.anjuke.com/sale/{}/".format(url_qx2[i])
    print(url)
    wb_data=requests.get(url)
    soup=BeautifulSoup(wb_data.text,'lxml')
    req=urllib.request.Request(url=url,headers=header)
    # print(wb_data)
    soup=BeautifulSoup(wb_data,'lxml')
    infomations=soup.select('div > span.elems-l > div.sub-items > a')
    infomations1=infomations[1:]
    for url in infomations1:
        data={'url':url.get('href'),'address':url.get_text()}
        # print(data)
        url_qx3.append(data)
url_qx4=[]
for i in url_qx3:
    url_qx4.append(i['url'].split('/')[4])

print(url_qx3)
for i in url_qx4:
    for j in range(1,51):
        time.sleep(1)
        url="http://shenzhen.anjuke.com/sale/{}/p{}/".format(i,j)
        print(url)
        # wb_data=requests.get(url)
        # soup=BeautifulSoup(wb_data.text,'lxml')
        req=urllib.request.Request(url=url,headers=header)
        wb_data=urllib.request.urlopen(req).read().decode()
        # print(wb_data)
        soup=BeautifulSoup(wb_data,'lxml')
        prices=soup.select('div.house-details > div > span:nth-of-type(3)')
        addresses=soup.select('div.house-details > div > span.comm-address')
        if prices==None:
            continue
        else:
            for price,address in zip(prices,addresses):
                price=price.get_text()
                address=address.get('title')
                # print(address)
                # cursor.execute('insert into house10 (prices,address) VALUES (%s,%s)',[price,address])
                cursor.execute('insert into house11 (id,prices,address) VALUES (NULL,%s,%s)',[price,address])
                conn.commit()
cursor.close()
conn.close()






