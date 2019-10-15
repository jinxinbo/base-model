from bs4 import  BeautifulSoup
import urllib.request
import re
import math

url_header = "http://srh.bankofchina.com/search/whpj/search.jsp?erectDate=2016-01-25&nothing=2016-02-25&pjname=1314"
Webpage = urllib.request.urlopen(url_header).read()
Webpage=Webpage.decode('UTF-8')
# soup = BeautifulSoup(Webpage)
print (Webpage)
a=re.findall(r'var m_nRecordCount = (\d+)',str(Webpage))
print(a)
# page_count=soup.find('script')
# print(page_count)
total_page=math.ceil(int(a[0])/20)
print(total_page)