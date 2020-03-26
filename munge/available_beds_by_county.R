library(ggplot2)
library(plyr)
library(dplyr)
library(scales)
library(readxl)
library(reshape2)
library(gridExtra)
library(RColorBrewer)
library(viridis)
library(here)

DS <- data.frame(read_xlsx(here("data/Hospital capacity and population by county 2018.xlsx")))
DS <- subset(DS,AAC_per10k > 0 & ICU_per100k > 0)
DS <- subset(DS,AAC_per10k < 100 & ICU_per100k < 100)
DS$State <- as.factor(DS$State)

p1 <- ggplot(data=DS,aes(y=AAC_per10k*10,x=State))+geom_boxplot()+theme_bw() +
  xlab("")+ylab("Number of Beds") + labs(title="Available AAC Beds per 100k Population")+
  theme(axis.text.x = element_text(angle=90,vjust=.5,hjust=1))
p2 <- ggplot(data=DS,aes(y=ICU_per100k,x=State))+geom_boxplot()+theme_bw() +
  xlab("")+ylab("Number of Beds") + labs(title="Available ICU Beds per 100k Population")+
  theme(axis.text.x = element_text(angle=90,vjust=.5,hjust=1))

pdf(paste("../plots/Available Beds per Population Data.pdf",sep=""),width=10,height=5)
plot(p1)
plot(p2)
dev.off()

mean(DS$AAC_per10k)
mean(DS$ICU_per100k)
quantile(DS$AAC_per10k,c(.025,.25,.5,.75,.95,.975))
quantile(DS$ICU_per100k,c(.025,.25,.5,.75,.95,.975))
