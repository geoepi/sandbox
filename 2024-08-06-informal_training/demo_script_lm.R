#library(here)
#library(tidyverse)


# Sim Data
#test_data <- as.data.frame(
#  cbind(
#    Y = rnorm(1000, 0, 3),
#    X = rnorm(1000, 2, 1)
#  )
#)

#head(test_data)

 # my_model <- lm(Y ~ X, test_data)

# summary(my_model)

saveRDS(test_data, here("2024-08-06-informal_training/test_data.rds"))

#saveRDS(my_model, "out_my_model.rds")
