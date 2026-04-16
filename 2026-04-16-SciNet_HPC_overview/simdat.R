# generate data

Sys.sleep(30) # delay before run

set.seed(123) # seed

mydf <- data.frame(x = rnorm(1000), y = rnorm(1000))

write.csv(mydf, "data_2026-04-16.csv", row.names = FALSE)

print("Data generation complete!")