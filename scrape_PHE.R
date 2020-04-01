# Scrape data from PHE dashboard
# This requires PhantomJS: https://phantomjs.org/download.html
# Assumes PhantomJS binary is in same folder as R project

library(tidyverse)
library(rvest)

url <- "https://www.arcgis.com/apps/opsdashboard/index.html#/f94c3c90da5b4e9f9a0b19484dd4bb14"

# use system2 to invoke phantomjs via it's executable
system2("./phantomjs",
        #provide the path to the scraping script and the country url as argument
        args = c("scrape_PHE.js", url))

h <- read_html('phe-web-scrape.html')

# Find headline figures 1st
text <- h %>% html_nodes('margin-container') %>% html_text()
text2 <- trimws(gsub("\n", "", text))

# This function will scrape UTLA or NHS data and return a dataframe

process_covid <- function(textfield, thedate) {
  utla_list <- map(unlist(str_split(textfield, "  ")), function(y) {
    a = str_extract_all(y, "[a-zA-Z0-9\\,]+")
    # print('New one')
    if(length(a[[1]]) > 0) {
      b = a[[1]]
      lengthb = length(b)
      num = b[lengthb]
      name = paste(b[1:lengthb-1], collapse = " ")
      return(list('num' = num, 'name' = name))
      # print(paste(name, num))
    } else {
      # print('empty')
    }
    
  })
  
  utla_list2 <- utla_list[lengths(utla_list) != 0]
  
  df2 <- tibble(
    thedate = thedate,
    num = gsub(",","",unlist(lapply(utla_list2, function(x) {
      print(x$num)
    }))),
    name = unlist(lapply(utla_list2, function(x) {
      print(x$name)
    })),
  )
  
  return(df2)
}


today <- lubridate::dmy(str_extract(text2[3], "\\d{1,2}(rd|th|nd|st){1}\\s(January|February|March|April|May|June|July|August|September|October|November|December)\\s2020"))

#today <- lubridate::today()

# Calculate UTLA data

covid_utla <- process_covid(text2[14], today)

write_csv(covid_utla, 'covid-utla-data.csv', append=T)

# Calculate NHS data

covid_nhs <- process_covid(text2[13], today)

write_csv(covid_nhs, 'covid-nhs-data.csv', append=T)

# Tibble containing more general data

df <- tibble(
  thedate = lubridate::dmy(str_extract(text2[3], "\\d{1,2}(rd|th|nd|st){1}\\s(January|February|March|April|May|June|July|August|September|October|November|December)\\s2020")),
  `Total UK cases` = as.numeric(str_extract_all(gsub(",","",text[4]), "\\d+") %>% unlist())[1],
  `Daily Confirmed Cases` = as.numeric(str_extract_all(gsub(",","",text[5]), "\\d+") %>% unlist())[1],
  `Patients recovered` = NA, # as.numeric(str_extract_all(text[6], "\\d+") %>% unlist() %>% paste(sep="", collapse="")),
  `Total UK deaths` = as.numeric(str_extract_all(gsub(",","",text[4]), "\\d+") %>% unlist())[2],
  `Total England cases` = as.numeric(str_extract_all(gsub(",","",text[6]), "\\d+") %>% unlist())[1],
  `Total Scotland cases` = as.numeric(str_extract_all(gsub(",","",text[7]), "\\d+") %>% unlist())[1],
  `Total Wales cases` = as.numeric(str_extract_all(gsub(",","",text[8]), "\\d+") %>% unlist())[1],
  `Total N. Ireland cases` = as.numeric(str_extract_all(gsub(",","",text[9]), "\\d+") %>% unlist())[1],
  `Total England deaths` = as.numeric(str_extract_all(gsub(",","",text[7]), "\\d+") %>% unlist())[2],
  `Total Scotland deaths` = as.numeric(str_extract_all(gsub(",","",text[8]), "\\d+") %>% unlist())[2],
  `Total Wales deaths` = as.numeric(str_extract_all(gsub(",","",text[9]), "\\d+") %>% unlist())[2],
  `Total N. Ireland deaths` = as.numeric(str_extract_all(gsub(",","",text[10]), "\\d+") %>% unlist())[2]
)

write_csv(df, 'covid-general-data.csv', append = T)



