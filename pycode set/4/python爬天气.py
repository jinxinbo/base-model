# -*- coding:utf-8 -*-
import urllib.request
from bs4 import BeautifulSoup
import re
url = "http://qq.ip138.com/weather/henan/XinYang.html"
read_url=urllib.request.urlopen(url).read().decode('utf-8')
# print(read_url)
Bea_url=BeautifulSoup(read_url,'lxml')
print(Bea_url)


# req = urllib2.Request(url)
# res = urllib2.urlopen(req)
# html = res.read()
# res.close()
# patteraddress=re.compile("<div><b>(.*?)</b><br/><br/>")
# address=patteraddress.findall(html)
# patternwind = re.compile(r"<br/>(.*?)<br/><br/>")
# wind = patternwind.findall(html)
# patternweather = re.compile("<b>(\d{4}-\d{1,2}-\d{1,2} .{9})</b><br/>(.*?)<br/>")
# weather = patternweather.findall(html)
# print weather
# patterntemperature = re.compile("(-\d{1,2}C|\d{1,2}C)")
# temperature = patterntemperature.findall(html)
# print address[0].decode('utf8')
#
# for i in xrange(7):#一共15天的预报 这是前7天，由于后8天的正则不一样，就没写出来
#     for j in xrange(len(weather[i])):
#         print weather[i][j].decode('utf8')
#     if i==0:#温度爬取涉及一个算法挺有趣
#         print temperature[0]
#     else:
#         print temperature[i*2-1]+u' 到'+temperature[i*2]
#     print wind[i]
#     print '************'
