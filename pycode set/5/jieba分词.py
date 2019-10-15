import pandas as pd
import jieba
from collections import Counter

pf=pd.read_excel("jieba1.xls","sheet")
# print(pf)


def jb(wd):
    return set(list(jieba.cut_for_search(wd)))
#
pf['value']=pf["DISCRIPTION"].apply(jb)
# print(pf)
pf.to_csv('out.csv',sep='\t')


# w=''
# fw=list(jieba.cut_for_search(w))
# fw1=set(fw)
# fw2=Counter(fw)
# print(fw2)