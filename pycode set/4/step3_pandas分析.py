# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
import mysql.connector
import pandas as pd

# 中文不能写入问题,在mysql中新建数据库之前加上
# CREATE DATABASE `database` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

conn=mysql.connector.connect(user='root',database='database',charset='utf8')
# cursor=conn.cursor()
# cursor.execute('create table house3 (prices VARCHAR (20),address VARCHAR (50));')
ershoufang_1=pd.read_sql('select * from house10;',con=conn);
print(ershoufang_1)
conn.close()






