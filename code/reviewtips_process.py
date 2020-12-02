#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 19 17:48:09 2020

@author: ruihuang
"""
import os
import pandas as pd

os.getcwd()

df_business = pd.read_csv('business_csv.csv')
df_review = pd.read_csv('review_csv.csv')
df_steak = pd.read_csv('steakhouse_business.csv')
df_steak['mark'] =  1 # add one column as a mark

# steakhouse review

df_review_s = pd.merge(df_review[['review_id', 'user_id', 'business_id', 
                                       'stars', 'date', 'text', 'useful', 
                                       'funny', 'cool']],
                       df_steak[['business_id', 'mark']],
                       on = 'business_id', how = 'left')
del df_review
df_steak_review = df_review_s[df_review_s['mark']==1] # only keep steakhouse reviews marked as 1
del df_review_s
del df_steak_review['mark']
df_steak_review.to_csv('steak_review.csv', index = False)
del df_steak_review

# steakhouse tips

df_tip = pd.read_csv('tip_csv.csv')
df_tip_3 = pd.merge(df_tip, df_steak[['business_id', 'mark']], on = 'business_id', how = 'left')
del df_tip
df_steak_tip = df_tip_3[df_tip_3['mark']==1]
del df_tip_3
del df_steak_tip['mark']
df_steak_tip.to_csv('steakhouse_tip.csv', index = False)
del df_steak_tip

del df_business
