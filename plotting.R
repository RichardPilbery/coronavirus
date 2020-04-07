library(tidyverse)
library(lubridate)

df <- read_csv('covid-general-data.csv')

ggplot(df, aes(x=thedate)) +
  geom_point(aes(y=`Uk Daily Deaths`), stat="identity", color='red') + 
  geom_line(aes(y=`Uk Daily Deaths`), stat="identity", color='red') 


