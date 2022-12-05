
  
## Set up the library
library(survival)
library(survminer)
library(flextable)
library(webshot)
webshot::install_phantomjs(force = TRUE)

## Read in the Data Set
data1 <- read.csv("derived_data/processed-bone-marrow.csv")

## Test of covariates effect
### Effect of Recipient age
fit <- survfit(Surv(data1$survival_time,data1$survival_status)~data1$Recipientage10,conf.type = "log-log")
summary(fit)
survdiff(Surv(data1$survival_time,data1$survival_status)~data1$Recipientage10)


p1<-ggsurvplot(fit, data = data1[,c('survival_time','survival_status','Recipientage10')],risk.table = TRUE,
               xlab = "Time In Days", ylab = "Survival",
               title = "Kaplan-Meier curves by Recipient Age",
               legend=c(0.8,1),legend.labs = c('Age < 10','Age > 10'))
p1
png('figures/Plot_KM_Age.png')
print(p1)
dev.off()


### ANC recovery
fit <- survfit(Surv(data1$survival_time,data1$survival_status)~data1$ANCrecovery,conf.type = "log-log")
summary(fit)
survdiff(Surv(data1$survival_time,data1$survival_status)~data1$ANCrecovery)


p2<-ggsurvplot(fit, data = data1[,c('survival_time','survival_status','ANCrecovery')],risk.table = TRUE,
               xlab = "Time In Days", ylab = "Survival",
               title = "Kaplan-Meier curves by ANC recovery",
               ylim = c(0,1),
               legend=c(0.8,1),legend.labs = c('No','Yes'))
p2
png('figures/Plot_KM_ANC.png')
print(p2)
dev.off()


### PLT recovery
fit <- survfit(Surv(data1$survival_time,data1$survival_status)~data1$PLTrecovery,conf.type = "log-log")
summary(fit)
survdiff(Surv(data1$survival_time,data1$survival_status)~data1$PLTrecovery)


p3<-ggsurvplot(fit, data = data1[,c('survival_time','survival_status','PLTrecovery')],risk.table = TRUE,
               xlab = "Time In Days", ylab = "Survival",
               title = "Kaplan-Meier curves by platelet recovery",
               ylim = c(0,1),
               legend=c(0.8,1),legend.labs = c('No','Yes'))
p3
png('figures/Plot_KM_PLT.png')
print(p2)
dev.off()

### acute graft versus host disease stage III or IV
fit <- survfit(Surv(data1$survival_time,data1$survival_status)~data1$aGvHDIIIIV,conf.type = "log-log")
summary(fit)
survdiff(Surv(data1$survival_time,data1$survival_status)~data1$aGvHDIIIIV)


p4<-ggsurvplot(fit, data = data1[,c('survival_time','survival_status','aGvHDIIIIV')],risk.table = TRUE,
               xlab = "Time In Days", ylab = "Survival",
               title = "Kaplan-Meier curves by acute graft versus host disease",
               ylim = c(0,1),
               legend=c(0.8,1),legend.labs = c('No','Yes'))
p4
png('figures/Plot_KM_aGvHD.png')
print(p4)
dev.off()


### Development of extensive chronic graft versus host disease 
fit <- survfit(Surv(data1$survival_time,data1$survival_status)~data1$extcGvHD,conf.type = "log-log")
summary(fit)
survdiff(Surv(data1$survival_time,data1$survival_status)~data1$extcGvHD)


p5<-ggsurvplot(fit, data = data1[,c('survival_time','survival_status','extcGvHD')],risk.table = TRUE,
               xlab = "Time In Days", ylab = "Survival",
               title = "Kaplan-Meier curves by extensive chronic graft versus host disease",
               ylim = c(0,1),
               legend=c(0.8,1),legend.labs = c('No','Yes'))
p5
png('figures/Plot_KM_ecGvHD.png')
print(p5)
dev.off()



## Cox proportional Hazard Model

cox <- coxph(Surv(survival_time,survival_status)~Recipientage+Rbodymass+Disease+Riskgroup+CD3dkgx10d8+
               PLTrecovery+extcGvHD, data = data1)
summary(cox)

cox2 <- coxph(Surv(survival_time,survival_status)~Riskgroup+CD3dkgx10d8+PLTrecovery+extcGvHD, data = data1)
sum_final <- summary(cox2)


fit_cox = round(cbind(coefficient = coef(cox2),exp(cbind(HR = coef(cox2), confint(cox2))),sum_final$coefficients),3)[,c(1:4,9)]
fit_cox = flextable(as.data.frame(cbind(variable = rownames(fit_cox),fit_cox)))
fit_cox

save_as_image(fit_cox,path = "tables/Table_cox.png")
