###### Clear environment and load libraries
rm(list = ls())
library(MatchIt) #for propensity score matching
library(cobalt)
library(ggplot2)

###### Load the data
data <- read.csv("combined_data.csv",header=T,
                    colClasses=c("numeric","numeric","numeric","factor","factor","factor","factor",
                                 "numeric","numeric","numeric","numeric","numeric","numeric",
                                 "numeric","numeric","numeric"))
data = subset(data, select = -c(X))


###### View properties of the data
str(data)
head(data)
dim(data)
summary(data)

###### Covariate balance
summary(data[data$reached_flg == 0, 3:15]) 
summary(data[data$reached_flg == 1, 3:15]) 
bal.tab(list(treat=data$reached_flg,covs=data[,3:15],estimand="ATT"))
love.plot(list(treat=data$reached_flg,covs=data[,3:15],estimand="ATT"),stars = "std")

###### Propensity scores estimation
pscorereg <- glm(reached_flg ~ num_inds+children_ind+hh_income_ind+age_ind+
                               state+num_cookies+num_days_online+num_events+
                               brand_sales_q5+brand_sales_q4+brand_sales_q3+
                               brand_sales_q2+post_flg,
                 data = data, family=binomial)
summary(pscorereg)

#now let's estimate the propensity scores
pscores <- predict(pscorereg, type = "response")
#use type="response" since we want probabilities
head(pscores)
summary(pscores)
ggplot(data, aes(pscores)) +
  geom_histogram(alpha=.6,fill=rainbow(20),bins=20)

# identify outliers
min_point = max(summary(pscores[data$reached_flg == 1])[1], 
                summary(pscores[data$reached_flg == 0])[1])
max_point = min(summary(pscores[data$reached_flg == 1])[6], 
                summary(pscores[data$reached_flg == 0])[6])
# determine number of outliers to be discarded
sum(pscores < min_point | pscores > max_point)
# discard outliers
data <- data[pscores >= min_point & pscores <= max_point, ]
# discard the outliers in pscore
pscores <- pscores[pscores >= min_point & pscores <= max_point]
ggplot(data, aes(pscores)) +
  geom_histogram(alpha=.6,fill=rainbow(20),bins=20)

#look at distribution of propensity scores for treateds and controls
data$treated <- 'treated'
data$treated[data$reached_flg == 0] <- 'control'
ggplot(data, aes(y=pscores, x=treated, fill=treated)) +
  geom_boxplot()
#we can see clear differences in the distributions of propensity scores
#thus, a simple comparison of the outcomes would be confounded
#by differences in the background variables

#actually we need to overlay the distributions to see overlap clearly
ggplot(data, aes(x=pscores, fill=treated)) +
  geom_density(alpha=.3) +
  xlim(0, 1)
#the propensity scores overlap very well
#so we can feel good about prospects for matching

###### Propensity scores matching
#main call-- embed the logistic regression inside the call
#start with a main effects only regression
matchesdata <- matchit(reached_flg ~ num_inds+children_ind+hh_income_ind+age_ind+
                                     state+num_cookies+num_days_online+num_events+
                                     post_flg*(brand_sales_q5+brand_sales_q4+brand_sales_q3+brand_sales_q2),
                       method = "nearest", distance = "logit", data = data)

matchesdata$match.matrix
matchesdata$nn
summary(matchesdata)

#extract the matched dataset
datamatcheddata <- match.data(matchesdata)
bal.tab(list(treat=datamatcheddata$reached_flg,covs=datamatcheddata[,3:16],estimand="ATT"))
love.plot(list(treat=datamatcheddata$reached_flg,covs=datamatcheddata[,3:16],estimand="ATT"),stars = "std")

write.csv(datamatcheddata,'matched_data.csv')

#let's look at the propensity scores after matching.  the "distance" variable gives scores.
ggplot(datamatcheddata, aes(y=distance, x=treated, fill=treated)) +
  geom_boxplot()

 



