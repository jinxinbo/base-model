# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
import mysql.connector
import urllib.request

# 中文不能写入问题,在mysql中新建数据库之前加上
# CREATE DATABASE `database` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

conn=mysql.connector.connect(user='root',database='database',charset='utf8')
cursor=conn.cursor()
cursor.execute('create table house4 (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,prices VARCHAR (20),address VARCHAR (50));')


url='http://shenzhen.anjuke.com/sale/nanshan/p4/'
header = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'}
req=urllib.request.Request(url=url,headers=header)
wb_data=urllib.request.urlopen(req).read().decode()
# print(wb_data)
soup=BeautifulSoup(wb_data,'lxml')

infomation=soup.select('div.div-border.items-list > div > span.elems-l > div > a')
# print(infomation)
# for url in infomation:
#     data={'url':url.get('href'),'address':url.get_text()}
#     print(data)
prices=soup.select('div.house-details > div > span:nth-of-type(3)')
addresses=soup.select('div.house-details > div > span.comm-address')
print(prices)
for price,address in zip(prices,addresses):
    price=price.get_text()
    address=address.get('title')
    # print(address)
    cursor.execute('insert into house4 (id,prices,address) VALUES (NULL,%s,%s)',[price,address])
    conn.commit()
cursor.close()
conn.close()






