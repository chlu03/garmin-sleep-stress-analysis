#查看資料集
sleeps_dailies <- read.csv("data/sleeps_dailies_clean.csv")

summary(sleeps_dailies)
boxplot(sleeps_dailies$sleepScore)
boxplot(sleeps_dailies$averageStressLevel)
boxplot(sleeps_dailies$averageActiveIntensity)


#建立存圖資料夾
dir.create("figures", showWarnings = FALSE)

#ggplot2 繪圖
library(ggplot2)
p1 <- ggplot(data=sleeps_dailies, aes(x=averageStressLevel, y=sleepScore)) + 
  geom_point() + stat_smooth(method="lm",se=TRUE)
print(p1)
ggsave("figures/stress_vs_sleep.png", p1, width=6, height=4, dpi=150)
 
regressionA <- lm(formula = sleepScore~averageStressLevel, data=sleeps_dailies)
anova(regressionA)
summary(regressionA)
 
p2 <- ggplot(data=sleeps_dailies, aes(x=averageActiveIntensity, y=sleepScore)) + 
  geom_point() + stat_smooth(method="lm",se=TRUE)
print(p2)
ggsave("figures/intensity_vs_sleep.png", p2, width=6, height=4, dpi=150)
 
regressionB <- lm(formula = sleepScore~averageActiveIntensity, data=sleeps_dailies)
anova(regressionB)
summary(regressionB)
 
p3 <- ggplot(data=sleeps_dailies, aes(x=averageActiveIntensity, y=averageStressLevel)) + 
  geom_point() + stat_smooth(method="lm",se=TRUE)
print(p3)
ggsave("figures/intensity_vs_stress.png", p3, width=6, height=4, dpi=150)
 
regressionC <- lm(formula = averageStressLevel~averageActiveIntensity, data=sleeps_dailies)
anova(regressionC)
summary(regressionC)


#常態性
ks.test(scale(regressionB$residuals), "pnorm")
shapiro.test(regressionA$residuals)
shapiro.test(regressionB$residuals)
shapiro.test(regressionC$residuals)

#獨立性
library(car)
durbinWatsonTest(regressionA)
durbinWatsonTest(regressionB)
durbinWatsonTest(regressionC)

#變異數同質性
ncvTest(regressionA)
ncvTest(regressionB)
ncvTest(regressionC)
