# generate data

Sys.sleep(30) # delay before run

set.seed(123) # seed

mydf <- data.frame(x = rnorm(1000), y = rnorm(1000))

write.csv(mydf, "data_2026-08-03.csv", row.names = FALSE)

print("Data generation complete!")