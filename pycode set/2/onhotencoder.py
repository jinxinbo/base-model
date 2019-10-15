import pandas as pd
from sklearn import preprocessing


test = pd.DataFrame({'city': ['beijing', 'shanghai', 'shenzhen'], 'age': [21, 33, 23], 'target': [0, 1, 0]})
print(test)
label = preprocessing.LabelEncoder()
test['city'] = label.fit_transform(test['city'])
print(test)


enc=preprocessing.OneHotEncoder(categorical_features=[1], sparse=False)
test=enc.fit_transform(test)
print(test)

test=pd.DataFrame({'city': ['beijing', 'shanghai', 'shenzhen'], 'age': [21, 33, 23], 'target': [0, 1, 0]})

print('-------------')
print(pd.factorize(test['city']))

print(pd.get_dummies(test['city'], prefix='city'))

