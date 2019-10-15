import urllib.request
import re
url = 'http://srh.bankofchina.com/search/whpj/search.jsp?erectDate=2016-01-25&nothing=2016-01-25&pjname=1314&page=7'
req = urllib.request.Request(url, headers = {
    'Connection': 'Keep-Alive',
    'Accept': 'text/html, application/xhtml+xml, */*',
    'Accept-Language': 'en-US,en;q=0.8,zh-Hans-CN;q=0.5,zh-Hans;q=0.3',
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'
})
oper = urllib.request.urlopen(req)
data = oper.read()
# print(data)
# print(str(data))
# a=re.findall(r'(http:[^\s]*?(jpg|png|gif))', str(data))
# print(a)
# data=data.decode('UTF-8')
# print(data.decode('UTF-8'))
data=data.decode('UTF-8')
a=re.findall(r'<th>(.*?)</th>', str(data))
print(a)
b=re.findall(r'<td>(.*?)</td>', str(data))
print(b)
# print(len(b))
for i in range(1,len(b)):
    if i/8 <= 1:
        print(b[i])

