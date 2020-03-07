# Scrape data from Gov.UK

library(tidyverse)

library(rvest)
url <- "https://www.gov.uk/guidance/coronavirus-covid-19-information-for-the-public"
h <- read_html(url)

text <- h %>% html_nodes("p")
text2 <- lapply(text, function(x) {
  web_text <- as.character(html_text(x))
  if(str_sub(web_text, 0, 5) == "As of") {
    #print("Matched")
    #print(web_text)
    the_date = str_extract(web_text, "\\d{1,2}\\s(January|February|March|April|May|June|July|August|September|October|November|December)\\s2020")
    
    the_numbers <- str_match_all(web_text, "\\d{1,3}(,\\d{3})?(,\\d{3})?")

    num_row <- the_numbers[[1]][,1]
    length_the_number = length(num_row)
    positive <- str_replace(num_row[length_the_number - 1], ",", "")
    negative <- str_replace(num_row[length_the_number - 2], ",", "")
    num_tests <- str_replace(num_row[length_the_number - 3], ",", "")
    
    new_row <- c(the_date, num_tests, negative, positive)
    return(new_row)
  }
})

text3 <- unlist(text2)
start_df <- data.frame(report_date = text3[1], tests = text3[2], negative=text3[3], positive=text3[4], deaths = "", stringsAsFactors = F)

tab <- h %>% html_nodes("table")
tab <- tab[[1]] %>% html_table
pivot_tab <- pivot_wider(tab, names_from = `NHS region`, values_from = Cases)

final_row <- bind_cols(start_df, pivot_tab)

write_csv(final_row, "coronavirus-data.csv", append = T)
