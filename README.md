# STAT628 Module3 Group6

## Introduction

The repository includes four folders-<code>code</code>, <code>data</code>, <code>figure</code> and <code>Shiny</code>. Executive summary and slides for presentation are attached outside the four folders. 

The <code>code</code> folder contains data generating code, attribute analysis code and review analysis code. 

- <code>transjson.py</code> pre-process <code>business.json</code>
- <code>reviewtips_process.py</code> pre-process <code>review.json</code> and <code>tips.json</code>
- <code>wordcloud_tip.R</code> count word frequency and plot word clouds
- <code>extract_attributes.ipynb</code> extract attributes from <code>business.json</code>
- <code>attribute_analysis.R</code> factorize attributes and do statistical analysis
- <code>attributes_suggestions.ipynb</code> generate suggestions data file

The <code>data</code> folder contains extracted steakhouse business data and other data generated from the analysis. 

The <code>figure</code> folder contains plots generated from the code files. 

The <code>Shiny</code> folder contains shiny app generating code and other support files. 
- <code>global.R </code> is for loading the required packages and reading the datasets for the app.
- <code>server.R</code> is for the interactive part, computing and plotting for the app.
- <code>ui.R</code> is for the layout of the app.
- <code>suggestionsnew.csv</code> is the csv file of customized suggestions.
- <code>steakhouse_business.csv</code> is the csv file of business information of all steakhouses.


Detailed data clearning process, analysis methods and suggestions on business owners is presented in the executive summary. Slides will help present our analysis. 

## Objective

1. Extract Yelp Steakhouse business data. 

2. Analyze contribution of attributes and reviews to star ratings. 

3. Give suggestions to Steakhouse business owners to help them improve their star ratings. 

4. Build up R shiny to help present our finds. 

## Shiny App Link: 

https://rhuang95.shinyapps.io/shiny/

## Team Member

Mengkun Chen  mchen373@wisc.edu

Rui Huang  rhuang95@wisc.edu

Haoran Lu  hlu226@wisc.edu
