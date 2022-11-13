library(tidyverse)


d <- read_csv(
  "01-raw-data-pilot-3a.csv"
) %>% 
  # coding error, swap measure names 'ralocrop' and 'relation' %>% 
  mutate(
    measure = case_when(
      measure == 'ralocrop' ~ 'relation',
      measure == 'relation' ~ 'ralocrop',
      TRUE ~ measure
      )
  )

d <- d %>% 
  group_by(submission_id) %>% 
  mutate(exclude = any(response %in% c("Cultivation of ralocrop is easy and cheap.", "Ralocrop does not grow on Xelifan-3."))) %>%
  ungroup() %>% 
  filter(exclude == FALSE)

dSummary <- d %>% 
  dplyr::select(submission_id, condition, measure, response) %>% 
  filter(measure %in% c('relation', 'choice')) %>% 
  pivot_wider(names_from = measure, values_from = response)

with(dSummary , table(condition, relation, choice)) %>% 
  prop.table(., c(1,3)) %>% 
  as_tibble() %>% 
  pivot_wider(names_from = relation, values_from = n) %>% 
  arrange(choice, condition)

transProb <- with(dSummary , table(condition, relation)) %>% 
  prop.table(., c(1)) %>% 
  as_tibble() %>% 
  pivot_wider(names_from = relation, values_from = n) %>% 
  arrange(condition)

transitionMatrix <- transProb[,2:4] %>% as.matrix()
colnames(transitionMatrix) = transProb$condition

with(dSummary, table(condition, choice)) %>% 
  prop.table(.,1)


# getting the stationary distributions.
# following this tutorial: 
# https://stephens999.github.io/fiveMinuteStats/markov_chains_discrete_stationary_dist.html

library(expm)
library(MASS)

pi_bru <- (transitionMatrix %^% 100)[1,]
pi_bru
