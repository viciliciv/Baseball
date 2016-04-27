#merges 


file_names <- dir('/Users/Work_JGI/Documents/Baseball/Reg_split/') #where you have your files

#set wd to read all files in folder and merge
setwd('/Users/Work_JGI/Documents/Baseball/Reg_split/')
# produces list of files that in the folder. It will allow to merge all the files by rows
file_list <- list.files()
#merges all csv files by row into one table
merged<-do.call(rbind, lapply(list.files(path=".", pattern=".csv"), read.table, header=TRUE, sep=","))

#opens csv 
#contains player ID from various baseball stat websites
playerID<-read.csv('/Users/Work_JGI/Documents/Baseball/SFBB Player ID Map - PLAYERIDMAP.csv', header = TRUE, sep = ',')
#contains players metadata. Retrieved from Baseball-databank.org
master<-read.csv('/Users/Work_JGI/Desktop/Baseball Data Bank/Master.csv', header = TRUE, sep = ',')
#contains players salary Retrieved from Baseball-databank.org
salaries<-read.csv('/Users/Work_JGI/Desktop/Baseball Data Bank/Salaries.csv', header = TRUE, sep = ',')

#truncate only for columns needed
master_s<-master[,c(16,1,2,20,24,25)]
#truncates for columns needed
pID<-playerID[,c(1,2,8,9,10)]
#replaces any na's with 0
pID[is.na(pID)]<-0
#changes player ID from factor to numeric and duplicate IDFANGRAPHS columns rename it as playerid as column name. 
pID$playerid<-as.numeric(levels(pID$IDFANGRAPHS))[pID$IDFANGRAPHS]
#duplicate FANGRAPHSNAME column and rename it as 'Name' 
pID$Name<-pID$FANGRAPHSNAME
#removes 'IDFANGRAPHS','FANGRAPHSNAME' columns. Not needed anymore
remove_fangraphs<- c('IDFANGRAPHS','FANGRAPHSNAME')
pID<-pID[ , !(names(pID) %in% remove_fangraphs)]
#changes any null to 'NA'(character)
pID[is.na(pID)]<-'NA'

#joins tables together
#left join merged table of split data with pID. Adds player ID used by dataabank so we can utilize salary from data bank
merged_reg_split<- join(merged, pID, by = 'playerid', type = 'left', match = 'all')
#left join master_s. Adds player birthdate to merged table
merged_reg_split<-join(merged_reg_split, master_s, by = 'Name', type = 'left', match = 'all')
#left join salary to merged table
merged_reg_split<-join(merged_reg_split,salaries, by  = c('playerID', 'year'), type = 'left', match = 'all')
#rename column 28 with 'Player Name'
colnames(merged_reg_split)[28]<-'Player Name'
#add a new column with player OPS
merged_reg_split$OPS<-merged_reg_split$OBP /merged_reg_split$SLG
#adds column that shows players Age during that year
merged_reg_split$Age<-merged_reg_split$year - merged_reg_split$birthYear

#used for plot_ly dual axis setup
ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right"
)

library(dplyr)
library(plotly)
#function to return players salary with inflation and OPSBI over the years
sal_b<-function(playerName){
  f<-merged_reg_split%>%
    filter(Name == playerName)
  #merged_reg_split$Name<-as.character(merged_reg_split$Name)
  #return(plot_ly(f, x = year, y = salary.w..inflation))
  return(plot_ly(f, x = Age, y = fitted(loess(salary.w..inflation ~ year)), mode = 'smooth', name = 'Salary w inflation')%>%
           add_trace(x = Age, y = fitted(loess(((OBP+SLG)*1000)+RBI ~ year)), name = "OPSBI", yaxis = "y2") %>%
           layout(title = paste(playerName, min(year), '-', max(year)), yaxis2 = ay))
  }

sal_b('Mike Piazza')


f<-merged_reg_split%>%
  filter(Name == 'Mike Piazza')

ggplot(f, aes(Age, y = salary.w..inflation)) +
  geom_smooth(aes(colour = "loess"), se = FALSE)



