# Candy-Bar-Ads-Campaign-Sales-Lift-Analysis

## Intro:
Ad Tech companies often seek to measure the effectiveness of online advertising. This repository contains an analysis I have done for a Ad Tech company to determine if their recent online campaign for a candy bar had lead to sales lift. More specifically, I investigated the differences in sales beteen households that saw the ad ('treatment') and those that did not ('control'). Note that the original data has not been included due to confidential reason. However, the table below provides a brief description about the data.

## Data:
Feature Name | Description 
-------------|-------------
hhid | Unique identifier
reached_flg | a binary flag indicating if a household was exposed to the ads
num_inds | number of individuals in the household
children_ind | number of children in the home
hh_income_ind | household income
age_ind | age of the person in the household that does most of the purchasing
state | state in which the household lives
num_cookies | number of cookies active in the household
num_days_online | number of days a cookie was active
num_events | total number of times that the Ad Tech company saw the cookie
brand_sales_q5 | household-level sales 5 quarters back in time
brand_sales_q4 | household-level sales 4 quarters back in time
brand_sales_q3 | household-level sales 3 quarters back in time
brand_sales_q2 | household-level sales 2 quarters back in time
brand_sales_q1 | household-level sales 1 quarter back in time
brand_sales_post | household-level sales during the campaign and in teh 4 weeks following the campaign

Note:
- Pre-campaign sales data is aggregated over a quarter and there are 5 quarters worth of pre-campaign data included for analysis. Post-campaign sales data consists of sales during the campaign and 4 weeks following the campaign end.
- Online activity data includes how many cookies are active in the household, the number of days a cookie was active, and the total number of times that the cookie was seen by the company.

## Analysis:
Online campaign typically build on the idea of A/B Testing. Therefore, this analysis needs to check whether or not the control and treatment groups are balanced in terms of the covariates. Violation of the data balance tamper the validity of an online experiment. My analysis included the following techniques:
- Exploratory Data Analysis
- KNN-Imputation
- t-test
- Difference-in-Difference Regression
- Propensity Score Matching

My analysis were done in 2 files:
- `analysis.ipynb` - contains EDA, feature engineering, and ads performance evaluation
- `matching.R` - contains data matching

## Summary Report
I have also prepared a presentation to report my findings the project stakeholder. The presentation is saved as a pdf and can be found [here](https://github.com/MTang0728/Candy-Bar-Ads-Campaign-Sales-Lift-Analysis/blob/main/doc/Analysis%20Presentation.pdf)
