library('RSelenium')#tool to navigate on website
library('dplyr')
library('httr')
library('stringr')
#http://www.astrometsmind.com/2016/04/Scrape-Fangraphs-Stats-RStudio.html
#/Users/Work_JGI/Library/Application Support/Firefox/Profiles/0r1cew7b.Randy

getwd()

#start connection to Rselenium. Allows to R to communicate with website. Firefox is the default broswer to run rSelenium
RSelenium::startServer()
#set up profile by following the instructions in the link below. 
#http://toolsqa.com/selenium-webdriver/custom-firefox-profile/
#copy profile path and paste below. 
fprof <- getFirefoxProfile("/Users/Work_JGI/Library/Application Support/Firefox/Profiles/0r1cew7b.Randy", useBase = TRUE)
#creates a drived
remDr <- remoteDriver(extraCapabilities = fprof)

#set working directory to save extracted files
setwd('/Users/Work_JGI/Documents/Baseball/Reg_split')
getwd()

#commands to open firefox driver using profile above
remDr$open()

# creates loop using year. Year acts as a variable for the URL and will command to open stats from different years
for (year in 1975 : 2015)
{
#each year will be inserted into URL using paste.
url <- paste('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=8&season=',year,'&month=0&season1=',year,'&ind=0&team=0&rost=0&age=0&filter=&players=0&page=1_2000',sep = '')
#Opens firefox and go to the URL above
remDr$navigate(url)
#pauses the code run for 2 seconds. Gives time webpage to load before running next line of code
Sys.sleep(2)
#Use HTML id to find element in webpage that allows R to interact with the website
webElem <- remDr$findElement(using = 'id', value = "LeaderBoard1_cmdCSV")
#this case. Element chosen is a export download button. So we command R to click on the element and excute the download
webElem$clickElement()
#pauses the code run for 5 seconds. 
#NOTE: download pop-up window will appear. Choose 'Do not Ask Again for future download.' This will allow future years to download automatically
Sys.sleep(5)
#'~/Downloads/FanGraphs Leaderboard.csv' is default download name
#read Download file
split <- read.csv('~/Downloads/FanGraphs Leaderboard.csv')
#added year column containing the year of stats in each row 
split$year <- year
#save table as csv with year as suffix
write.csv(split, paste('split_',year,'.csv',sep = ''))
#pauses run for 10 seconds
Sys.sleep(10)
#removes original download file. This will allow loop to download file using the same file name
file.remove("/Users/Work_JGI/Downloads/FanGraphs Leaderboard.csv")
#ensures that the code is running
print(year)
#lets you know when the code is done :)
if (year == 2015)  'done'}

