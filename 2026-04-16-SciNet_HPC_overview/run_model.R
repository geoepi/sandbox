# run linear regression

Sys.sleep(30)

mydata <- read.csv("data_2026-04-16.csv")

model <- lm(y ~ x, data = mydata)

save(model, file = "model_output.RData")

print("Linear model analysis complete!")

print(summary(model))