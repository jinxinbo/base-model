# -*- coding: utf-8 -*-

import urllib.request
from urllib.parse import urlencode
import re
import sys
import os


targetDir = r"E:\photo\xx"
def destFile(path):
    if not os.path.isdir(targetDir):
        os.mkdir(targetDir)
    pos = path.rindex('/')
    t = os.path.join(targetDir, path[pos+1:])
    return t

if __name__ == "__main__":
    data = {'a':'search','c':'search','keyword':'牛'}
    weburl = "https://fabiaoqing.com/?"+urlencode(data)
    # weburl = 'https://www.qqtn.com/article/article_257802_1.html'
    print(weburl)
    webheaders = {'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20100101 Firefox/23.0'}
    req = urllib.request.Request(url=weburl, headers=webheaders)
    webpage = urllib.request.urlopen(req)
    contentBytes = webpage.read()
    # contentBytes=contentBytes.decode('gbk')
    for link, t in set(re.findall(r'(http:[^\s]*?(jpg|png|gif))', str(contentBytes))):
        print(link)
        try:
            urllib.request.urlretrieve(link, destFile(link))
        except:
            print('失败')
