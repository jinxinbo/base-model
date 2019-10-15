#coding=utf-8

import time
import re
import requests
import datetime
import pandas as pd
import urllib.request
from bs4 import BeautifulSoup


def get_phone_address(phone):

    # items = {'mobile':phone, 'action':'mobile'}
    #
    # items1 = urllib.parse.urlencode(items).encode('utf-8')
    # print(items1)
    try:
        # time.sleep(0.1)
        url = 'http://www.ip138.com:8080/search.asp?mobile={}&action=mobile'.format(phone)

        req = urllib.request.Request(url, headers = {
        'Connection': 'Keep-Alive',
        'Accept': 'text/html, application/xhtml+xml, */*',
        'Accept-Language': 'en-US,en;q=0.8,zh-Hans-CN;q=0.5,zh-Hans;q=0.3',
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'
        })

        oper = urllib.request.urlopen(req)
        data = oper.read().decode('gbk')

        soup=BeautifulSoup(data,'lxml')


        # print(soup)
        td_list = soup.select('td')
        return [td.get_text() for td in td_list][6]
    except:
        return 'error'


def get_idno_address(idno):

    try:
        url = 'http://qq.ip138.com/idsearch/index.asp?action=idcard&userid=' + idno +'199203026934'+ '&B1=%B2%E9+%D1%AF'
        req = urllib.request.Request(url, headers={
            'Connection': 'Keep-Alive',
            'Accept': 'text/html, application/xhtml+xml, */*',
            'Accept-Language': 'en-US,en;q=0.8,zh-Hans-CN;q=0.5,zh-Hans;q=0.3',
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'
        })

        oper = urllib.request.urlopen(req)
        data = oper.read().decode('gbk')

        soup = BeautifulSoup(data, 'lxml')

        list1 = soup.select('td[class="tdc2"]')

        re1 = re.compile('>(.+?)<br/>')
        return re1.findall(str(list1[2]))[0]

    except:
        return 'error'

# print(get_idno_address('469027'))
# find_next_siblings('td') for td in td_list if td.get_text() == '卡号归属地'

if __name__ == '__main__':



    print(datetime.datetime.now())

    celltab = pd.read_csv(r'E:\买买钱包\cellphone_null0308.csv')
    cellphone = celltab

    print(cellphone.head())
    start_pro = time.time()

    cellphone['address'] = cellphone['mob7'].apply(get_phone_address)

    dura = time.time() - start_pro
    print(dura)

    cellphone.to_csv(r'E:\买买钱包\mob_adderss_0308.csv', sep='\t')


