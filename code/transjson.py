#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 18 19:46:33 2020

@author: ruihuang
"""
import pandas as pd
import os

#convert json to csv
os.getcwd()
os.chdir('/Users/ruihuang/Downloads/Data')

business = pd.read_json('./business_city.json', lines=True)
business.head()
business.to_csv('business_csv.csv',index=False)

review = pd.read_json('./review_city.json', lines=True)
review.head()
review.to_csv('review_csv.csv',index=False)

tip = pd.read_json('./tip_city.json', lines=True)
tip.head()
tip.to_csv('tip_csv.csv',index=False)

user = pd.read_json('./user_city.json', lines=True)
user.head()
user.to_csv('user_csv.csv',index=False)

#select the info of steakhouse
steak_id = []
df_business = pd.read_csv('./business_csv.csv')


#merge data

df_business = pd.read_csv('business_csv.csv')
df_review = pd.read_csv('review_csv.csv')

categories = []
df_business.shape[0]
for i in range(df_business.shape[0]):
    cate_line = df_business.iloc[i,12]
    if isinstance(cate_line, str):
        cate_line = cate_line.replace(', ', ',')
        cate_line = cate_line.split(',')
        for cate in cate_line:
            if cate not in categories:
                categories.append(cate)

categories_count = []
for i in range(len(categories)):
    categories_count.append(0)

df_review_2 = pd.merge(df_review[['review_id', 'business_id']], 
                       df_business[['business_id', 'categories']],
                       on = ['business_id'], how = 'left')
del df_business
del df_review
for i in range(df_review_2.shape[0]):
    cate_line = df_review_2.iloc[i,2]
    if isinstance(cate_line, str):
        cate_line = cate_line.replace(', ', ',')
        cate_line = cate_line.split(',')
        for cate in cate_line:
            index = categories.index(cate)
            categories_count[index] += 1

df_cate_count = pd.DataFrame({"category":categories, 
                              "review count": categories_count})
df_cate_count.sort_values("review count", inplace = True, ascending = False)
df_cate_count.head()
df_cate_count.to_csv('category_count.csv', index=False)

### extract data

# mexican info
steak_id = []
df_business = pd.read_csv('business_csv.csv')
df_business.head()
#del df_business['Unnamed: 0']
df_steak = pd.DataFrame(columns = ['business_id', 'name', 'city', 'state',
                                    'latitude', 'longitude', 'stars',
                                    'review_count','is_open','attributes','category','hours'])
for i in range(df_business.shape[0]):
    cate_line = df_business.iloc[i,12]
    if isinstance(cate_line, str):
        cate_line = cate_line.replace(', ', ',')
        cate_line = cate_line.split(',')
        if 'Steakhouses' in cate_line:
            insert_row = df_business.iloc[i, [0, 1, 3, 4, 6, 7, 8, 9, 10, 11,12,13]]
            df_steak.loc[df_steak.shape[0]] = insert_row.to_list()
            steak_id.append(df_business.iloc[i, 0])
            

df_steak.to_csv('steakhouse.csv', index = False)

#steakhouse number check
check=0
for i in range(df_business.shape[0]):
    zl = df_business.iloc[i,12]
    if isinstance(zl, str):
        zl = zl.replace(', ', ',')
        zl = zl.split(',')
        if 'Steakhouses' in zl:
            check = check +1

df_steak = pd.read_csv('steakhouse_bi.csv')
for i in range(df_steak.shape[0]):
    attrbutes = df_steak.iloc[i, 9]
    attrb = []
    print(i)
    if isinstance(attrbutes, str):
        if attrbutes == 'None':
            df_steak.iloc[i, 9]=''
        else:
            attr = eval(attrbutes)
            keys = list(attr.keys())
            for key in keys:
                if attr[key] == 'True':
                    attrb.append(key)
            df_steak.iloc[i, 9] = ','.join(attrb)
    else:
        df_steak.iloc[i, 9] = ''

df_steak.to_csv('steakhouse_business.csv', index = False)
del df_steak
