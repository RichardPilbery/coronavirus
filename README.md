# Coronavirus data

## Getting started
This script runs in R. It requires phantomjs to work as the PHE website takes a few seconds to render all the data.

The scrape_PHE.r script may need modification depending on whether you are using a UNIX-based system (I'm on a mac) or Windows. The script creates 3 csv files:

1. covid-utla-data.csv which contains the summary stats from each of the upper tier local authorities
2. covid-nhs-data.csv which contains summary data from each NHS region
3. convid-general-data.csv which contains overal numbers e.g. infected/dead/recovering etc.
