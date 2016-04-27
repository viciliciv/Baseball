# Baseball

#Scrape from fangraphs

FanGraph Scrape.R - Scrapes Regular split from Fangraph from 1975 - 2015:

- library('RSelenium')
- library('dplyr')
- library('httr')
- library('stringr')
- Requires Mozilla Firefox and setting up a Firefox profile. http://toolsqa.com/selenium-webdriver/custom-firefox-profile/
- Reference: http://www.astrometsmind.com/2016/04/Scrape-Fangraphs-Stats-RStudio.html

Salary with inflation.R:

- Merges table scraped from FanGraph Scrape.R
- Uses SFBB Player ID Map - PLAYERIDMAP.csv, MASTER.csv, and Salaries.csv(includes inflation) to add Age and Salary to players

Merged_reg_split.csv:

- End file from Salary with inflation.R
