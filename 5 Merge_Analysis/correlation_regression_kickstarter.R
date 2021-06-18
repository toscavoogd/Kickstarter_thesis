#### Import libraries####
library(tidyverse)
library(readxl)
library(car)
library(funModeling)

#### Import data #### 

data <- read_excel("/Users/toscavoogd/Kickstarter_Thesis/merged_data.xlsx")
#View(data)

#Check datatypes and change to numeric
str(data)
data$com_count <- as.numeric(data$com_count)
data$com_count[is.na(data$com_count)] <- 0 
#Make df with only numeric values
data_num <- select_if(data, is.numeric) 

#### Check correlations on percentage fulfilled ####

correlation_table(data=data_num, target="percentage_fulfilled")
correlation_table(data=data_num, target="pledged_amount")

summary(data_num)
#### Perception sustainability on percentage_fulfilled ####
#comments
sus_com_percentage <- lm(percentage_fulfilled ~ sus_com_totalword, data  = data_num)
summary(sus_com_percentage) #pvalue 0.05056
sus_com_percentage1 <- lm(percentage_fulfilled ~ sus_com_StdDev, data  = data_num)
summary(sus_com_percentage1) #pvalue 0.02177

sus_com_pledged <- lm(pledged_amount ~ sus_com_totalword, data  = data_num)
summary(sus_com_pledged) #pvalue 0.005273

#description
sus_des_percentage <- lm(percentage_fulfilled ~ sus_des_totalword, data  = data_num)
summary(sus_des_percentage) #pvalue 0.07424
sus_des_percentage1 <- lm(percentage_fulfilled ~ sus_des_StdDev, data  = data_num)
summary(sus_des_percentage1) #pvalue 0.07424

sus_des_pledged <- lm(pledged_amount ~ sus_des_totalword, data = data_num)
summary(sus_des_pledged) #pvalue 0.003195

#### Perception innovativeness on percentage_fulfilled ####
#comments
inn_com_percentage <- lm(percentage_fulfilled ~ innov_com_totalword, data  = data_num)
summary(inn_com_percentage) #pvalue 0.000005
inn_com_percentage1 <- lm(percentage_fulfilled ~ innov_com_StdDev, data  = data_num)
summary(inn_com_percentage1) #pvalue 0.000005

inn_com_pledged <- lm(pledged_amount ~ innov_com_totalword, data  = data_num)
summary(inn_com_pledged) #pvalue 0.00004

#description
inn_des_percentage <- lm(percentage_fulfilled ~ innov_des_totalword, data  = data_num)
summary(inn_des_percentage) #pvalue 0.1525
inn_des_percentage1 <- lm(percentage_fulfilled ~ innov_des_StdDev, data  = data_num)
summary(inn_des_percentage1) #pvalue 0.1525

inn_des_pledged <- lm(pledged_amount ~ innov_des_totalword, data = data_num)
summary(inn_des_pledged) #pvalue 0.156


#### Sentiment in comment section ####
#totalsentiment
totalsentiment_perc <- lm(percentage_fulfilled ~ Sum_Sentiment, data  = data_num)
summary(totalsentiment_perc) #pvalue 0.5661
totalsentiment_pledge <- lm(pledged_amount ~ Sum_Sentiment, data  = data_num)
summary(totalsentiment_pledge) #pvalue 0.5017

#stddev
stdsentiment_perc <- lm(percentage_fulfilled ~ sentiment_com_StdDev, data  = data_num)
summary(stdsentiment_perc) #pvalue 0.2053
stdsentiment_pledge <- lm(pledged_amount ~ sentiment_com_StdDev, data  = data_num)
summary(stdsentiment_pledge) #pvalue 0.2703

#totalnegative
totalneg_perc <- lm(percentage_fulfilled ~ TotalNegative, data  = data_num)
summary(totalneg_perc) #pvalue 0.00004
totalneg_pledged <- lm(pledged_amount ~ TotalNegative, data  = data_num)
summary(totalneg_pledged) #pvalue 0.000002

#totalpositive
totalpos_perc <- lm(percentage_fulfilled ~ TotalPositive, data  = data_num)
summary(totalpos_perc) #pvalue 0.001307
totalpos_pledged <- lm(pledged_amount ~ TotalPositive, data  = data_num)
summary(totalpos_pledged) #pvalue 0.0002354

#sentiment on pledge/backer ratio.
ratiosen <- lm(pledge_backer_ratio ~ Sum_Sentiment, data = data_num)
summary(ratiosen)
cor.test(data_num$pledge_backer_ratio, data_num$Sum_Sentiment)

ratiosen1 <- lm(pledge_backer_ratio ~ sentiment_com_StdDev, data = data_num)
summary(ratiosen1)
cor.test(data_num$pledge_backer_ratio, data_num$sentiment_com_StdDev)



#### Budget description ####
budget <- lm(percentage_fulfilled ~ budget_discussed, data = data_num)
summary(budget)
cor.test(data_num$budget_discussed, data_num$percentage_fulfilled)

#### Numbers of comments ####
comcount_perc <- lm (percentage_fulfilled ~ com_count, data  = data_num)
summary(comcount_perc) #pvalue 0.00000000001
comcount_pledged <- lm (pledged_amount ~ com_count, data  = data_num)
summary(comcount_pledged) #pvalue 0.00000000001

#### Model ####
#without commentcount
new_model <- lm(percentage_fulfilled ~ sus_com_StdDev + sus_des_totalword + innov_com_StdDev + innov_des_totalword + Sum_Sentiment + sentiment_com_StdDev, data = data_num)
summary(new_model) # 0.001065
vif(new_model) # check for multicollinarity

new_model1 <- lm(pledged_amount ~ sus_com_StdDev + sus_des_totalword + innov_com_StdDev + innov_des_totalword + Sum_Sentiment + sentiment_com_StdDev, data = data_num)
summary(new_model1) # 0.000244
vif(new_model1) # check for multicollinarity

#with commentcount
new_model2 <- lm(percentage_fulfilled ~ com_count + sus_com_StdDev + sus_des_totalword + innov_com_StdDev + innov_des_totalword + Sum_Sentiment + sentiment_com_StdDev, data = data_num)
summary(new_model2) # 1.36e-10
vif(new_model2) # check for multicollinarity

new_model3 <- lm(pledged_amount ~ com_count + sus_com_StdDev + sus_des_totalword + innov_com_StdDev + innov_des_totalword + Sum_Sentiment + sentiment_com_StdDev, data = data_num)
summary(new_model3) # 0.074e-11
vif(new_model3) # check for multicollinarity


