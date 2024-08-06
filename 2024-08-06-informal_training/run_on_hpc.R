library(tidyverse)
library(here)

my_data <- readRDS("test_data.rds")
head(my_data)

my_model <- lm(Y ~ X, my_data)

summary(my_model)

saveRDS(my_model, "out_my_model2.rds")