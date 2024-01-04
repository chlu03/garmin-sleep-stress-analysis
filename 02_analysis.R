#查看資料集
sleeps_dailies <- read.csv("data/sleeps_dailies_clean.csv")

summary(sleeps_dailies)
boxplot(sleeps_dailies$sleepScore)
boxplot(sleeps_dailies$averageStressLevel)
boxplot(sleeps_dailies$averageActiveIntensity)

#ggplot2 繪圖
library(ggplot2)
ggplot(data=sleeps_dailies, aes(x=averageStressLevel, y=sleepScore)) + 
  geom_point() + stat_smooth(method="lm",se=TRUE)

regressionA <- lm(formula = sleepScore~averageStressLevel, data=sleeps_dailies)
anova(regressionA)
summary(regressionA)

ggplot(data=sleeps_dailies, aes(x=averageActiveIntensity, y=sleepScore)) + 
  geom_point() + stat_smooth(method="lm",se=TRUE)

regressionB <- lm(formula = sleepScore~averageActiveIntensity, data=sleeps_dailies)
anova(regressionB)
summary(regressionB)

ggplot(data=sleeps_dailies, aes(x=averageActiveIntensity, y=averageStressLevel)) + 
  geom_point() + stat_smooth(method="lm",se=TRUE)

regressionC <- lm(formula = averageStressLevel~averageActiveIntensity, data=sleeps_dailies)
anova(regressionC)
summary(regressionC)

#殘差
regressionB$residuals

#常態性
ks.test(regressionB$residuals, "pnorm")
shapiro.test(regressionA$residuals)
shapiro.test(regressionB$residuals)
shapiro.test(regressionC$residuals)

#獨立性
require(car)
durbinWatsonTest(regressionA)
durbinWatsonTest(regressionB)
durbinWatsonTest(regressionC)

#變異數同質性
ncvTest(regressionA)
ncvTest(regressionB)
ncvTest(regressionC)



