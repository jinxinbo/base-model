import requests
import math
import pandas as pd

def locate(address):
    items = {'addr': address}
    r = requests.get('http://api.go2map.com/engine/api/geocoder/json?', params=items)
    dictResult = r.json()
    if dictResult['status']=='ok':
        col=dictResult['response']['x']
        row=dictResult['response']['y']
        x=col/20037508.34*180
        y=row/20037508.34*180
        y=180/math.pi*(2*math.atan(math.exp(y*math.pi/180))-math.pi/2)
    else:
        x=0
        y=0
    return (y,x)


a=locate('盐城市亭湖区解放南路58号中建大厦504-505室')
print(a)
# branch=pd.read_excel('appcode4_5.xls','sheet')
# # print(branch)
# branch['value']=branch['comaddress'].apply(locate)
# # print(branch)
# branch.to_csv('null5.csv',sep='\t')


