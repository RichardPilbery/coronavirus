library(tidyverse)
library(lubridate)

df <- read_csv('coronavirus-data.csv') %>%
  mutate(
    rep_date = dmy(report_date),
    prop_positive = positive/test * 100
  )  

ggplot(df, aes(x=rep_date)) +
  geom_point(aes(y=positive), stat="identity") + 
  geom_line(aes(y=positive), stat="identity")

ggplot(df, aes(x=rep_date)) +
  geom_point(aes(y=deaths), stat="identity", color='red') + 
  geom_line(aes(y=deaths), stat="identity", color='red') +
  geom_point(aes(y=positive), stat="identity") + 
  geom_line(aes(y=positive), stat="identity") +
  scale_y_continuous( trans = scales::log_trans())


ggplot(df, aes(x=rep_date)) +
  geom_point(aes(y=prop_positive), stat="identity") + 
  geom_line(aes(y=prop_positive), stat="identity")

# library(incidence)
# 
# i.1 <- incidence(df$rep_date, interval = 1)
# 
# 
# my_theme <- theme_bw(base_size = 12) +
#   theme(panel.grid.minor = element_blank()) +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, color = "black"))
# 
# plot(i.1, border = "white") +
#   my_theme +
#   theme(legend.position = c(0.8, 0.75))
