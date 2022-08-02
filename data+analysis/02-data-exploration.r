library(tidyverse)
library(tidyboot)
library(aida)
library(brms)
library(faintr)

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

d <- read_csv('01-raw-data.csv') 

# decision trials  
d_decision <- filter(d, trialNR == 0) %>% 
  rename(responseTimeDecision = responseTime,
         decision = response) %>% 
  select(-justification) %>% 
  mutate(decision = case_when(decision == "both xeliherb and ralocrop" ~ "both", TRUE ~ "single"))
# justifcation trials
d_justification <- filter(d, trialNR == 1) %>% 
  rename(responseTimeJustifcation = responseTime) %>% 
  select(submission_id, justification, responseTimeJustifcation)

d <- full_join(d_decision, d_justification, by = 'submission_id')

write_csv(d, '01-wrangled-data.csv')

sumStats <- d %>% 
  mutate(decision = ifelse(decision == "both", 1, 0)) %>% 
  group_by(condition) %>% 
  tidyboot_mean(column = decision) %>% 
  mutate(condition = factor(condition, levels = c("deniedCausation", "commonCause", "association", "intervention")))

sumStats %>% 
  ggplot(aes(x = condition, fill = condition, y = mean)) +
  geom_col() +
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), alpha = 0.3, width =0.2) +
  theme(legend.position = 'none') +
  xlab('condition') +
  ylab('proportion of "both" choice')

# run regression model
fit <- brm(decision ~ condition, family = bernoulli(link = "logit"), data = d %>% mutate(decision = factor(decision, levels = c("single", "both"))))
fit

# collect pairwise comparisions

deniedCausationVScommonCause <- faintr::compare_groups(
  fit, 
  lower = condition == "deniedCausation",
  higher  = condition == "commonCause"
)

commonCauseVSassociation <- faintr::compare_groups(
  fit, 
  lower = condition == "commonCause",
  higher  = condition == "association"
)

associationVSintervention <- faintr::compare_groups(
  fit, 
  lower = condition == "association",
  higher  = condition == "intervention"
)

deniedCaustaionVSassociation <- faintr::compare_groups(
  fit, 
  lower = condition == "deniedCausation",
  higher  = condition == "association"
)

deniedCausationVSintervention <- faintr::compare_groups(
  fit, 
  lower = condition == "deniedCausation",
  higher  = condition == "intervention"
)


tribble(
  ~comparison, ~posterior, ~"95%HDI (low)", ~"95%HDI (high)",
  "denied causation < common cause" , deniedCausationVScommonCause$post_prob, deniedCausationVScommonCause$l_ci, deniedCausationVScommonCause$u_ci,  
  "common cause < association" , commonCauseVSassociation$post_prob, commonCauseVSassociation$l_ci, commonCauseVSassociation$u_ci,
  "association < intervention" , associationVSintervention$post_prob, associationVSintervention$l_ci, associationVSintervention$u_ci,
  "denied causation < association" , deniedCaustaionVSassociation$post_prob, deniedCaustaionVSassociation$l_ci, deniedCaustaionVSassociation$u_ci,
  "denied causation < intervention" , deniedCausationVSintervention$post_prob, deniedCausationVSintervention$l_ci, deniedCausationVSintervention$u_ci,
)
