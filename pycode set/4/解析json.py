#!/usr/bin/env python
# -*- coding:utf-8 -*-
import json
import numpy as np
import pandas as pd
with open('data1.json', 'r') as f:
    data1=json.load(f)
all_keys=list(data1.keys())
print(all_keys)
# for i in range(len(all_keys)):
#     sub_dict=data1[all_keys[i]]
#     print(all_keys[i])
#     print(sub_dict)
contact=data1['main_service']
# print(contact)
pd_contact=pd.DataFrame(contact)
print(pd_contact)
# contact_v=contact[1]
# print(contact_v.values())
# pd_contact.to_csv('contact.csv',sep='\t')
