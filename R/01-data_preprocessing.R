# load packages
library(tidyverse)
library(magrittr)
library(dplyr)
library(ggplot2)
require(maps)
library(see)
library(wesanderson)
library(shadowtext)
library(countrycode)
library(plotly)

#### Loading data ####
raw <- read.csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-18/survey.csv',
  stringsAsFactors = TRUE
) |> 
  mutate(industry = str_to_title(industry))

country_cleaned <- readRDS("country_cleaned.rds")

#### Data Preprocessing ####

industry_subset <- table(raw$industry) |> 
  as.data.frame() |> 
  filter(Freq >= 100) 

raw |> 
  left_join(country_cleaned, by="country") |> 
  # remove the 133 cases where currency was indicated as "Other" 
  # and any industries with fewer than 100 individuals who responded
  filter(currency!="Other",
         industry %in% industry_subset$Var1) |> 
  # adjust salary to include other compensation
  # also convert to USD to standardize currency
  # average conversion rate taken on Apr 27, 2021
  mutate(industry = str_to_title(industry),
         gender = as.character(gender),
         gender = replace_na(gender, "Other/NA"),
         gender = case_when(
           gender == "Prefer not to answer" ~ "Other/NA",
           gender == "Other or prefer not to answer" ~ "Other/NA",
           TRUE ~ gender
         ),
         gender = factor(gender, levels=c(
           "Man", "Non-binary", "Woman", "Other/NA"
         )),
         other_monetary_comp = replace_na(other_monetary_comp, 0),
         salary_adj = case_when(
           currency == "AUD/NZD" ~ annual_salary * 0.7505,
           currency == "CAD"     ~ annual_salary * 0.81,
           currency == "CHF"     ~ annual_salary * 1.0951,
           currency == "EUR"     ~ annual_salary * 1.2088,
           currency == "GBP"     ~ annual_salary * 1.3911,
           currency == "HKD"     ~ annual_salary * 0.1288,
           currency == "JPY"     ~ annual_salary * 0.0092,
           currency == "SEK"     ~ annual_salary * 0.1192,
           currency == "ZAR"     ~ annual_salary * 0.0697,
           TRUE                  ~ annual_salary
         ),
         comp_adj = case_when(
           currency == "AUD/NZD" ~ other_monetary_comp * 0.7505,
           currency == "CAD"     ~ other_monetary_comp * 0.81,
           currency == "CHF"     ~ other_monetary_comp * 1.0951,
           currency == "EUR"     ~ other_monetary_comp * 1.2088,
           currency == "GBP"     ~ other_monetary_comp * 1.3911,
           currency == "HKD"     ~ other_monetary_comp * 0.1288,
           currency == "JPY"     ~ other_monetary_comp * 0.0092,
           currency == "SEK"     ~ other_monetary_comp * 0.1192,
           currency == "ZAR"     ~ other_monetary_comp * 0.0697,
           TRUE                  ~ other_monetary_comp
         ),
         total_comp_adj = salary_adj + comp_adj) |> 
  filter(total_comp_adj < 1000000) -> df


# clean up data to create world map
df %<>%
  mutate(
    country_cleaned = countrycode(country_cleaned, 
                                  origin = 'country.name', 
                                  destination = 'country.name')) %<>%
  drop_na(country_cleaned) 


# donut chart colour palette
gender_cols <- c("#F1BB7B", "#FD6467", "#E6A0C4", "#5B1A18")

# world map data
world <- map_data("world") |> 
  mutate(region = countrycode(region,
                              origin = 'country.name',
                              destination = 'country.name'))

