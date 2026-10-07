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


#混合效應模型（以受試者 id 為隨機截距，處理同一人重複測量的問題）
library(lme4)

#虛無模型：只有受試者的隨機截距
nullSleep  <- lmer(sleepScore ~ 1 + (1|id), data=sleeps_dailies, REML=FALSE)
nullStress <- lmer(averageStressLevel ~ 1 + (1|id), data=sleeps_dailies, REML=FALSE)

#組內相關係數 ICC：總變異中有多少來自「受試者之間的差異」
iccSleep <- as.data.frame(VarCorr(nullSleep))
iccSleep$vcov[1] / sum(iccSleep$vcov)
iccStress <- as.data.frame(VarCorr(nullStress))
iccStress$vcov[1] / sum(iccStress$vcov)

#加入自變數的模型
mixedA <- lmer(sleepScore ~ averageStressLevel + (1|id), data=sleeps_dailies, REML=FALSE)
mixedB <- lmer(sleepScore ~ averageActiveIntensity + (1|id), data=sleeps_dailies, REML=FALSE)
mixedC <- lmer(averageStressLevel ~ averageActiveIntensity + (1|id), data=sleeps_dailies, REML=FALSE)

summary(mixedA)
summary(mixedB)
summary(mixedC)

#概似比檢定：加入自變數後是否顯著改善模型
anova(nullSleep, mixedA)
anova(nullSleep, mixedB)
anova(nullStress, mixedC)
