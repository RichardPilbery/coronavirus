library(tidyverse)
library(lubridate)
library(plotly)

df <- read_csv('coronavirus-data.csv') %>%
  select(report_date, positive, deaths) %>%
  mutate(thedate = as.Date(report_date, "%d %B %Y")) %>%
  select(-report_date)

df1 <- read_csv('covid-general-data.csv') %>%
  select(thedate, `Total UK cases`, `Total UK deaths`) %>%
  rename(
    positive = `Total UK cases`,
    deaths = `Total UK deaths`
  ) %>% filter(thedate > '2020-04-05')

df_final <- bind_rows(df, df1)


a <- ggplot(df_final, aes(x=thedate)) +
  geom_point(aes(y=positive), stat="identity", color='red') + 
  geom_line(aes(y=positive), stat="identity", color='red') + 
  geom_line(aes(y=deaths), stat="identity", color='black') +
  geom_point(aes(y=deaths), stat="identity", color='black') +
  scale_x_date(date_breaks = "1 week") + 
  theme(axis.text.x = element_text(angle = 45))


b <- plotly::ggplotly(a)

htmlwidgets::saveWidget(as_widget(b), "cases.html")
