from multiprocessing import Pool
import os, time, random
import requests
from bs4 import BeautifulSoup
import urllib.request
from urllib.error import HTTPError,URLError
import csv


def url_quxian(city):
    url="http://{}.anjuke.com/sale/".format(city)
    wb_data=requests.get(url)
    soup=BeautifulSoup(wb_data.text,'lxml')
    # print(soup)
    infomation=soup.select('div.div-border.items-list > div > span.item-title')
    infomation1=[i.next_sibling.find_all('a')  for i in infomation if i.get_text()=="区域："]

    # print(infomation1)
    url_qx=[]
    for url in infomation1[0]:
        data={'url':url.get('href'),'address':url.get_text()}
        # print(data)
        url_qx.append(data)

    url_qx2=[]
    for i in range(len(url_qx)):
        url_qx2.append(url_qx[i]['url'].split('/')[4])
    #

    sub_result=[]
    for i in range(len(url_qx)):
        try:
            url="http://{}.anjuke.com/market/{}/?from=listing".format(city,url_qx2[i])
            # print(url_qx[i]['address'])
            rel=urllib.request.urlopen(url).read().decode('utf-8')
            soup=BeautifulSoup(rel,'lxml')
            infom=soup.select('div[class="trendR"] > h2 > em')
            # print(infom[0].get_text())
            infom1=soup.select('div[class="trendR"] > h2 > i')
            # print(infom1[1].get_text())
            oup=[city,url_qx[i]['address'],infom[0].get_text(),infom1[1].get_text()]
            # print(oup)
            # writer.writerow(oup)
            sub_result.append(oup)
        except HTTPError as e:
            print('HTTPError:',e.code)
        except IndexError as e:
            print('null')
    return sub_result


if __name__=='__main__':

    print('Parent process %s.' % os.getpid())
    p = Pool(4)
    sta=time.time()
    result=[]
    list=['beijing','shanghai','shenzhen','wuhan','zhengzhou','hefei','suzhou','chengdu','xiamen','nanjing']
    for i in list:
        result.append(p.apply_async(url_quxian, args=(i,)))
    # result.append(p.map_async(url_quxian,list))
    print('Waiting for all subprocesses done...')
    p.close()
    p.join()
    with open('city.txt','a+') as rd:
        for res in result:
            # rd.write(str(res.get()))
            for i in res.get():
                rd.write(str(i)+'\n')
    print('All subprocesses done.')
    end=time.time()
    print('process dura {}'.format(end-sta))