from bs4 import BeautifulSoup
import requests


url_qx=[]
def url_quxian(url):
    wb_data=requests.get(url)
    soup=BeautifulSoup(wb_data.text,'lxml')
    # print(soup)
    infomation=soup.select('div.multi-form > div >  a')
    # print(infomation)
    for url in infomation:
        data={'url':url.get('href'),'address':url.get_text()}
        # print(data)
        url_qx.append(data)

url_quxian("http://hangzhou.anjuke.com/sale/")
# print(url_qx)
url_quxian1=url_qx[1:]
url_qx2=[]
for i in range(1,14):
    url_qx2.append(url_qx[i]['url'].split('/')[4])
# print(url_qx2)
url_qx3=[]
for i in range(13):
    url="http://hangzhou.anjuke.com/sale/{}/".format(url_qx2[i])
    # print(url)
    wb_data=requests.get(url)
    soup=BeautifulSoup(wb_data.text,'lxml')
    infomations=soup.select('div.multi-subareas > div > a')
    infomations1=infomations[1:]
    for url in infomations1:
        data={'url':url.get('href'),'address':url.get_text()}
        print(data)
        url_qx3.append(data)
url_qx4=[]
for i in url_qx3:
    url_qx4.append(i['url'].split('/')[4])

