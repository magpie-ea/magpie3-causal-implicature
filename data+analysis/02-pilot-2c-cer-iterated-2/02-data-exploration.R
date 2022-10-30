library(tidyverse)

d <- read_csv(
  "01-raw-data-pilot-2c.csv"
)
with(d, table(chain,generation))

d %>% 
  pivot_wider(id_cols = c('submission_id', 'chain', 'generation', 'triggerMessage'), names_from = measure, values_from = response) %>% 
  select(submission_id, chain, generation, triggerMessage, choice, reproduction) %>% 
  arrange(chain, generation) %>% View()
