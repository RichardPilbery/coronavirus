library(tidyverse)

df <- data.frame(
  n = c(33,61,86,112,116,129,192,174,344,304,327,246,320,339,376),
  thedate = c(paste0("2020-03-",seq(18,31,1)), "2020-04-01"),
  stringsAsFactors = F
) %>%
  mutate(
    thedate = as.Date(thedate)
  )

ggplot(df, aes(x = thedate, y = n)) +
  geom_line() +
  geom_point() +
  geom_smooth()
