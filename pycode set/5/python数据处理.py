# encoding:utf-8
import pandas as pd
import numpy as np
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier

# dt=pd.read_sas("class.xpt")
# print(dt)

# 生成dataframe
ind=['a','b','c','d']
data=[1,2,3,4]
pd1=pd.DataFrame(data,index=ind,columns=['data'])
print(pd1)


dt=pd.DataFrame({'x':[6,3,5],'y':[2,4,6]})
# print(dt)

# 筛选
dt1=dt[dt['x']>2]
# print(dt1)

dt['flag']=np.where(dt['x']>2,'1','0')
# print(dt)
# dt['time1']=dt.Time

# keep
dt1=dt[['x','flag']]
# print(dt1)

dt2=dt.drop('x',axis=1)
# print(dt2)

# rename
dt3=dt.rename(columns={'x':'x1'})
# print(dt3)

# sort

dt4=dt.sort_values(['x','flag'])
# print(dt4)

# join

df1=pd.DataFrame({'keys':['A','B','C','D'],'values':np.random.randn(4)})
df2=pd.DataFrame({'keys':['B','D','E','D'],'values':np.random.randn(4)})
print(df1)
# print(df2)

inner_join=df1.merge(df2,on='keys',how='inner')
# print(inner_join)

left_join=df1.merge(df2,on='keys',how='left')
# print(left_join)

# 缺失值
err=left_join[pd.isnull(left_join['values_y'])]
# print(err)

err1=left_join[pd.notnull(left_join['values_y'])]
# print(err1)

err2=left_join.dropna()
# print(err2)

# 缺失值填充
err3=left_join.fillna(method='ffill')
# print(err3)

err4=left_join['values_y'].fillna(left_join['values_y'].mean())
# print(err4)

left_join['values_y'].fillna(left_join['values_x'])
print(left_join)

# 对不同列填充不同值
left_join=left_join.fillna({'values_x':0,'values_y':1})

# 随机抽样

bag=np.array([5,7,1,3,4])
sampler=np.random.randint(0,len(bag),size=10)
sam=bag.take(sampler)
# 也可直接
sam=bag[sampler]
print(sam)

bag=pd.DataFrame(np.arange(20).reshape(5,4))
# print(bag)
sampler=np.random.permutation(5)
sam=bag.reindex(sampler)
sam1=bag.take(sampler)
sam2=bag.ix[sampler]
print(sam)
print(sam1)
print(sam2)


# searchsorted对数值进行分组
# 返回后面数组在前面数组的索引，riht则返回相同值的后面的索引
a=np.searchsorted([1,1,6,9], [1,1,3,4,5,6,7,8,9],side='right')
print(a)


data = np.floor(np.random.uniform(0, 10000, size=50))
bins = np.array([0, 100, 1000, 5000, 10000])
labels = bins.searchsorted(data)
print(labels)

# 这个groupby好神奇
a=pd.Series(data).groupby(labels).mean()
print(a)



# 和时间相关
a['date']=pd.Timestamp('2016-12-1')

a['date_year']=a['date'].dt.month

a['date_next']=a['date']+pd.offsets.MonthBegin(2)

a['date2']=pd.Timestamp('2016-5-31')

# 月份差
a['date_between']=(a['date'].dt.to_period('M')-a['date2'].dt.to_period('M'))