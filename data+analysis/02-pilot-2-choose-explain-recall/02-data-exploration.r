library(tidyverse)
library(tidyboot)
library(aida)
library(brms)
library(faintr)
library(dplyr)

##################################################

# these options help Stan run faster
options(mc.cores = parallel::detectCores())

# use the aida-theme for plotting
theme_set(theme_aida())

# global color scheme / non-optimized
project_colors = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#000000")

# setting theme colors globally
scale_colour_discrete <- function(...) {
  scale_colour_manual(..., values = project_colors)
}
scale_fill_discrete <- function(...) {
  scale_fill_manual(..., values = project_colors)
} 

##################################################
## auxiliary functions 
##################################################

d <- read_csv('01b-processed-data-pilot-2a.csv')

d <- d %>% mutate(
  trialType = case_when(
      !is.na(reproduction) ~ "reproduction",
    !is.na(response) ~ "choice",
    !is.na(justification) ~ "justification",
  ),
  response = case_when(
    !is.na(reproduction) ~ reproClass,
    !is.na(response) ~ response,
    !is.na(justification) ~ justification,
  )) %>% 
  pivot_wider(id_cols = submission_id, names_from = trialType, values_from = response)

# there must be a more elegant way than this!?
sumStats <- d %>% group_by(choice) %>% 
  mutate(choice_count = n()) %>% 
  ungroup() %>% 
  group_by(choice, reproduction) %>% 
  summarize(
    proportion = n() / choice_count
    ) %>% unique()

sumStats %>% ggplot(aes(x = reproduction, y = proportion, fill = reproduction)) + 
  geom_col() +
  facet_wrap(~choice, ncol = 1)

names(d)

