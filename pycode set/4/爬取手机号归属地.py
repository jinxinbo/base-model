import time
import requests
import urllib.request
from bs4 import BeautifulSoup
import pandas as pd

def calladd(no):
    try:
        url ='http://shouji.xpcha.com/{}.html'.format(no)
        # wb_data=urllib.request.urlopen(url,timeout=0.1).read().decode('utf-8')
        wb_data = requests.get(url)
        soup = BeautifulSoup(wb_data.text,'lxml')
        # print(soup)
        str1 = soup.select('div[class="left_leirong"] > dl > dd')
        try:
            city = str1[0].get_text("|")
        except IndexError:
           return 'null'
    except:
        return 'null'

    return city.split('|')[1]




if __name__=='__main__':
    sta = time.time()
    add = calladd('1351109')
    print(add)

    mobileno = pd.read_excel('mobile_0121.xls',sheet_name='Sheet')
    print(mobileno.head())
    # test = mobileno.head()

    test = mobileno
    test['city'] = test['mob'].apply(calladd)
    test.to_csv('mobile_0121.csv',sep='\t')
    end = time.time()
    print('process dura {}'.format(end - sta))

