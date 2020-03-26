library(ggplot2)
library(plyr)
library(dplyr)
library(scales)
library(readxl)
library(reshape2)
library(gridExtra)
library(RColorBrewer)

#Set working directory to current location if needed?
#setwd()

#This is used to source which input files we are referring to. 
#Possibly no longer necessary if everything is on the server.
INPUTSET <- "TEXT" 
#These are the scenario descriptions. Will need to generate these from the Assumptions file - Epi Curve and Capacity Indicators.
scenario_list <- c("Mild Distancing","Moderate Distancing","Strong Distancing")
#Reordering will go away when run on the server.
scenario_list_ordered <- c("Mild Distancing","Moderate Distancing","Strong Distancing") 

##Everything else should be pretty much set as is, fingers crossed.

#Load CSVs
ASSUMPTIONS <- read.csv(paste("MODELING RESULTSSS_R_TRIAL_ASSUMPTIONS_TRACKER_",INPUTSET,".csv",sep=""))
INPT_OCCUP <- read.csv(paste("MODELING RESULTSSS_R_INPT_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
ICU_OCCUP <- read.csv(paste("MODELING RESULTSSS_R_ICU_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
MEDSURG_OCCUP <- read.csv(paste("MODELING RESULTSSS_R_MEDSURG_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
ICU_QTIME <- read.csv(paste("MODELING RESULTSSS_R_INPT_Q_TIME_ICU_ELIGIBLE_BY_DAY_",INPUTSET,".csv",sep=""))
TURNEDAWAY <- read.csv(paste("MODELING RESULTSSS_R_TURNED_AWAY_COMPLETED_BY_DAY_",INPUTSET,".csv",sep=""))
Q_CONTENTS <- read.csv(paste("MODELING RESULTSSS_R_INPT_Q_CONTENTS_END_OF_DAY_",INPUTSET,".csv",sep=""))

#This is used to name results file PDFs.
SETLABEL <- as.character(ASSUMPTIONS$Results_Name[1])

#Set up values
num_trials <- max(ASSUMPTIONS$Trial.Num)
scale_factor <- mean(ASSUMPTIONS$Population.Size)/10000
value_list <- c("Lower Bound","Expected","Upper Bound")

#Adjust bed numbers per pop
ASSUMPTIONS$Sweep_AAC_Beds <- ASSUMPTIONS$Sweep_AAC_Beds/(sim_pop/10000)
ASSUMPTIONS$Sweep_ICU_Beds <- ASSUMPTIONS$Sweep_ICU_Beds/(sim_pop/100000)

#Match assumptions to data results sheets
INPT_OCCUP$AAC_beds <- ASSUMPTIONS$Sweep_AAC_Beds[INPT_OCCUP$Run.Num]
INPT_OCCUP$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[INPT_OCCUP$Run.Num]
ICU_OCCUP$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[ICU_OCCUP$Run.Num]
ICU_OCCUP$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[MEDSURG_OCCUP$Run.Num]
MEDSURG_OCCUP$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[ICU_QTIME$Run.Num]
ICU_QTIME$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[ICU_QTIME$Run.Num]
TURNEDAWAY$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[TURNEDAWAY$Run.Num]
TURNEDAWAY$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[TURNEDAWAY$Run.Num]
Q_CONTENTS$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[Q_CONTENTS$Run.Num]
Q_CONTENTS$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[Q_CONTENTS$Run.Num]

INPT_OCCUP <- subset(INPT_OCCUP,Scenario!="")
ICU_OCCUP <- subset(ICU_OCCUP,Scenario!="")
MEDSURG_OCCUP <- subset(MEDSURG_OCCUP,Scenario!="")
ICU_QTIME <- subset(ICU_QTIME,Scenario!="")
TURNEDAWAY <- subset(TURNEDAWAY,Scenario!="")
Q_CONTENTS <- subset(Q_CONTENTS,Scenario!="")

INPT_Melt <- melt(INPT_OCCUP,id=c("Open.Num","Trial.Num","Run.Num","Scenario","Type"),
                  value.name="Occupancy",variable.name="Day")
ICU_Melt <- melt(ICU_OCCUP,id=c("Open.Num","Trial.Num","Run.Num","Scenario","Type"),
                 value.name="Occupancy",variable.name="Day")
MS_Melt <- melt(MEDSURG_OCCUP,id=c("Open.Num","Trial.Num","Run.Num","Scenario","Type"),
                value.name="Occupancy",variable.name="Day")
ICUQ_Melt <- melt(ICU_QTIME,id=c("Open.Num","Trial.Num","Run.Num","Scenario","Type"),
                value.name="Queue_Time",variable.name="Day")
TA_Melt <- melt(TURNEDAWAY,id=c("Open.Num","Trial.Num","Run.Num","Scenario","Type"),
                value.name="Number",variable.name="Day")
QC_Melt <- melt(Q_CONTENTS,id=c("Open.Num","Trial.Num","Run.Num","Scenario","Type"),
                value.name="Number",variable.name="Day")

INPT_Melt$Day <- as.numeric(gsub("Day.", "", INPT_Melt$Day))
ICU_Melt$Day <- as.numeric(gsub("Day.", "", ICU_Melt$Day))
MS_Melt$Day <- as.numeric(gsub("Day.", "", MS_Melt$Day))
ICUQ_Melt$Day <- as.numeric(gsub("Day.", "", ICUQ_Melt$Day))
TA_Melt$Day <- as.numeric(gsub("Day.", "", TA_Melt$Day))
QC_Melt$Day <- as.numeric(gsub("Day.", "", QC_Melt$Day))

INPT_Melt$Occupancy <- as.numeric(INPT_Melt$Occupancy)*scale_factor
ICU_Melt$Occupancy <- as.numeric(ICU_Melt$Occupancy)*scale_factor
MS_Melt$Occupancy <- as.numeric(MS_Melt$Occupancy)*scale_factor
ICUQ_Melt$Queue_Time <- as.numeric(ICUQ_Melt$Queue_Time)
TA_Melt$Number <- as.numeric(TA_Melt$Number)*scale_factor
QC_Melt$Number <- as.numeric(QC_Melt$Number)*scale_factor

INPT_Melt <- subset(INPT_Melt,!is.na(Occupancy))
ICU_Melt <- subset(ICU_Melt,!is.na(Occupancy))
MS_Melt <- subset(MS_Melt,!is.na(Occupancy))
ICUQ_Melt <- subset(ICUQ_Melt,!is.na(Queue_Time))
TA_Melt <- subset(TA_Melt,!is.na(Number))
QC_Melt <- subset(QC_Melt,!is.na(Number))

INPT_Melt$Scenario <- factor(INPT_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
INPT_Melt$Type <- factor(INPT_Melt$Type,ordered=TRUE,levels=value_list)
ICU_Melt$Scenario <- factor(ICU_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
ICU_Melt$Type <- factor(ICU_Melt$Type,ordered=TRUE,levels=value_list)
MS_Melt$Scenario <- factor(MS_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
MS_Melt$Type <- factor(MS_Melt$Type,ordered=TRUE,levels=value_list)
ICUQ_Melt$Scenario <- factor(ICUQ_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
ICUQ_Melt$Type <- factor(ICUQ_Melt$Type,ordered=TRUE,levels=value_list)
TA_Melt$Scenario <- factor(TA_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
TA_Melt$Type <- factor(TA_Melt$Type,ordered=TRUE,levels=value_list)
QC_Melt$Scenario <- factor(QC_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
QC_Melt$Type <- factor(QC_Melt$Type,ordered=TRUE,levels=value_list)

INPT_Melt_Avg <- ddply(INPT_Melt,.(Scenario,Type,Day),summarize,Occupancy_Sm=mean(Occupancy))
ICU_Melt_Avg <- ddply(ICU_Melt,.(Scenario,Type,Day),summarize,Occupancy_Sm=mean(Occupancy))
MS_Melt_Avg <- ddply(MS_Melt,.(Scenario,Type,Day),summarize,Occupancy_Sm=mean(Occupancy))
ICUQ_Melt_Avg <- ddply(ICUQ_Melt,.(Scenario,Type,Day),summarize,Time_Sm=mean(Queue_Time))
TA_Melt_Avg <- ddply(TA_Melt,.(Scenario,Type,Day),summarize,Number_Sm=mean(Number))
QC_Melt_Avg <- ddply(QC_Melt,.(Scenario,Type,Day),summarize,Number_Sm=mean(Number))

p1b <- ggplot(data=ICU_Melt_Avg,aes(x=Day,y=Occupancy_Sm,group=Type))+
  geom_line()+theme_bw()+facet_wrap(~Scenario) +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="ICU Beds (Epi Uncertainty)") +
  scale_x_continuous(breaks=seq(from=0,to=max(ICU_Melt_Avg$Day),by=10))+ 
  theme(legend.title = element_blank())

p2b <- ggplot(data=MS_Melt_Avg,aes(x=Day,y=Occupancy_Sm,group=Type))+
  geom_line()+theme_bw()+facet_wrap(~Scenario)+
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="Adult Acute Beds (Epi Uncertainty)")+
  scale_x_continuous(breaks=seq(from=0,to=max(MS_Melt_Avg$Day),by=10))+ 
  theme(legend.title = element_blank())

INPT_Melt_SD <- ddply(INPT_Melt,.(Scenario,Type,Day),summarize,Occupancy_se=sqrt(var(Occupancy)))
ICU_Melt_SD <- ddply(ICU_Melt,.(Scenario,Type,Day),summarize,Occupancy_se=sqrt(var(Occupancy)))
MS_Melt_SD <- ddply(MS_Melt,.(Scenario,Type,Day),summarize,Occupancy_se=sqrt(var(Occupancy)))
ICUQ_Melt_SD <- ddply(ICUQ_Melt,.(Scenario,Type,Day),summarize,Time_se=sqrt(var(Queue_Time)))
TA_Melt_SD <- ddply(TA_Melt,.(Scenario,Type,Day),summarize,Number_se=sqrt(var(Number)))
QC_Melt_SD <- ddply(QC_Melt,.(Scenario,Type,Day),summarize,Number_se=sqrt(var(Number)))

ICU_Sub <- ICU_Melt_Avg
ICU_Sub$Lower <- ICU_Melt_Avg$Occupancy_Sm - ICU_Melt_SD$Occupancy_se*1.96*7
ICU_Sub$Upper <- ICU_Melt_Avg$Occupancy_Sm + ICU_Melt_SD$Occupancy_se*1.96*7
p1cross <- ggplot(data=ICU_Sub,aes(x=Day,y=Occupancy_Sm,group=Scenario))+
  geom_ribbon(data=ICU_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="ICU Beds")+
  scale_x_continuous(breaks=seq(from=0,to=max(ICU_Sub$Day),by=10))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type)

ICU_Sub <- subset(ICU_Sub,Type=="Expected")
p1c <- ggplot(data=ICU_Sub,aes(x=Day,y=Occupancy_Sm,group=Scenario))+
  geom_ribbon(data=ICU_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="ICU Beds (Capacity Uncertainty)")+
  scale_x_continuous(breaks=seq(from=0,to=max(ICU_Sub$Day),by=10))+ 
  theme(legend.title = element_blank())

MS_Sub <- MS_Melt_Avg
MS_Sub$Lower <- MS_Melt_Avg$Occupancy_Sm - MS_Melt_SD$Occupancy_se*1.96*7
MS_Sub$Upper <- MS_Melt_Avg$Occupancy_Sm + MS_Melt_SD$Occupancy_se*1.96*7
p2cross <- ggplot(data=MS_Sub,aes(x=Day,y=Occupancy_Sm,group=Scenario))+
  geom_ribbon(data=MS_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="AAC Beds")+
  scale_x_continuous(breaks=seq(from=0,to=max(MS_Sub$Day),by=10))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type)

MS_Sub <- subset(MS_Sub,Type=="Expected")
p2c <- ggplot(data=MS_Sub,aes(x=Day,y=Occupancy_Sm,group=Scenario))+
  geom_ribbon(data=MS_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="Adult Acute Beds (Capacity Uncertainty)") +
  scale_x_continuous(breaks=seq(from=0,to=max(MS_Sub$Day),by=10))+ 
  theme(legend.title = element_blank())

ICUQ_Sub <- ICUQ_Melt_Avg
ICUQ_Sub$Lower <- ICUQ_Melt_Avg$Time_Sm/60 - ICUQ_Melt_SD$Time_se/60*1.96
ICUQ_Sub$Upper <- ICUQ_Melt_Avg$Time_Sm/60 + ICUQ_Melt_SD$Time_se/60*1.96
ICUQ_Sub$Lower[ICUQ_Sub$Lower < 0] = 0
p3cross <- ggplot(data=ICUQ_Sub,aes(x=Day,y=Time_Sm/60,group=Scenario))+
  geom_ribbon(data=ICUQ_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Hours") +
  labs(title="Mean ICU Queueing Time (hrs)")+
  scale_x_continuous(breaks=seq(from=0,to=max(ICUQ_Sub$Day),by=10))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type)

TA_Sub <- TA_Melt_Avg
TA_Sub$Lower <- TA_Melt_Avg$Number_Sm - TA_Melt_SD$Number_se*1.96*7
TA_Sub$Upper <- TA_Melt_Avg$Number_Sm + TA_Melt_SD$Number_se*1.96*7
TA_Sub$Lower[TA_Sub$Lower < 0] = 0
p4cross <- ggplot(data=TA_Sub,aes(x=Day,y=Number_Sm,group=Scenario))+
  geom_ribbon(data=TA_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Number Turned Away") +
  labs(title="Number of Patients Turned Away")+
  scale_x_continuous(breaks=seq(from=0,to=max(TA_Sub$Day),by=10))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type)

QC_Sub <- QC_Melt_Avg
QC_Sub$Lower <- QC_Melt_Avg$Number_Sm - QC_Melt_SD$Number_se*1.96
QC_Sub$Upper <- QC_Melt_Avg$Number_Sm + QC_Melt_SD$Number_se*1.96
QC_Sub$Lower[QC_Sub$Lower < 0] = 0
p5cross <- ggplot(data=QC_Sub,aes(x=Day,y=Number_Sm,group=Scenario))+
  geom_ribbon(data=QC_Sub,aes(xmin=1,xmax=max(Day),ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Days") + ylab("Number of Patients") +
  labs(title="Number of Patients Waiting for an Inpatient Bed")+
  scale_x_continuous(breaks=seq(from=0,to=max(QC_Sub$Day),by=10))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type)

INPT_Melt_Cast <- dcast(INPT_Melt_Avg, Scenario+Day~Type, mean)
ICU_Melt_Cast <- dcast(ICU_Melt_Avg, Scenario+Day~Type, mean)
MS_Melt_Cast <- dcast(MS_Melt_Avg, Scenario+Day~Type, mean)

p1 <- ggplot(data=ICU_Melt_Cast,aes(x=Day,y=Expected)) + 
  geom_ribbon(data=ICU_Melt_Cast,aes(xmin=1,xmax=7,ymin='Lower Bound',ymax='Upper Bound'),fill="darkblue",alpha=.5) +
  geom_line(data=ICU_Melt_Cast,aes(x=Day,y='Lower Bound'),color="darkgrey")+
  geom_line(data=ICU_Melt_Cast,aes(x=Day,y=Expected),color="black")+
  geom_line(data=ICU_Melt_Cast,aes(x=Day,y='Upper Bound'),color="darkgrey")+
  theme_bw()+facet_wrap(~Scenario) +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="ICU Beds (Epi Uncertainty)") + scale_y_continuous(labels = comma) +
  scale_x_continuous(breaks=seq(from=0,to=max(ICU_Melt_Cast$Day),by=10))+ 
  theme(legend.title = element_blank())

p2 <- ggplot(data=MS_Melt_Cast,aes(x=Day,y=Expected)) + 
  geom_ribbon(data=MS_Melt_Cast,aes(xmin=1,xmax=7,ymin='Lower Bound',ymax='Upper Bound'),fill="darkgreen",alpha=.5) +
  geom_line(data=MS_Melt_Cast,aes(x=Day,y='Lower Bound'),color="darkgrey")+
  geom_line(data=MS_Melt_Cast,aes(x=Day,y=Expected),color="black")+
  geom_line(data=MS_Melt_Cast,aes(x=Day,y='Upper Bound'),color="darkgrey")+
  theme_bw()+facet_wrap(~Scenario) +
  xlab("Days") + ylab("Bed Occupancy") +
  labs(title="Acute Adult Beds (Epi Uncertainty)") + scale_y_continuous(labels = comma)+
  scale_x_continuous(breaks=seq(from=0,to=max(MS_Melt_Cast$Day),by=10))+ 
  theme(legend.title = element_blank())

p3 <- ggplot(data=ICU_Melt_Cast,aes(x=Day,y=Expected,group=Scenario,color=Scenario)) +
  geom_line() + theme_bw() + xlab("Days") + ylab("Bed Occupancy") + labs(title="ICU Beds (Expected)") +
  scale_color_brewer(type="qual",palette = "Dark2") + scale_y_continuous(labels = comma)+
  scale_x_continuous(breaks=seq(from=0,to=max(ICU_Melt_Cast$Day),by=10))+ 
  theme(legend.title = element_blank())

p3b <- p3 + scale_y_continuous(labels = comma,limits=c(0,max(MS_Melt_Cast$Expected*1.02)))

p4 <- ggplot(data=MS_Melt_Cast,aes(x=Day,y=Expected,group=Scenario,color=Scenario)) +
  geom_line() + theme_bw() + xlab("Days") + ylab("Bed Occupancy") + 
  labs(title="Acute Adult Beds (Expected)") + 
  scale_y_continuous(labels = comma,limits=c(0,max(MS_Melt_Cast$Expected*1.02))) + 
  scale_color_brewer(type="qual",palette = "Dark2") +
  scale_x_continuous(breaks=seq(from=0,to=max(MS_Melt_Cast$Day),by=10)) + 
  theme(legend.title = element_blank())

write.csv(ICU_Melt_Cast,paste(SETLABEL,"_ICU_Cast_Summary.csv"))
write.csv(MS_Melt_Cast,paste(SETLABEL,"_MS_Cast_Summary.csv"))
write.csv(INPT_Melt_Cast,paste(SETLABEL,"_INPT_Cast_Summary.csv"))

pdf(paste(SETLABEL,"_ICUandMSbeds.pdf",sep=""),width=8,height=5)
plot(p1b)
plot(p2b)
plot(p1c)
plot(p2c)
grid.arrange(p1c,p2c,nrow=1)
plot(p3)
plot(p4)
grid.arrange(p1cross,p2cross,nrow=2)
grid.arrange(p3cross,p4cross,nrow=2)
grid.arrange(p3cross,p5cross,nrow=2)
dev.off()

pdf(paste(SETLABEL,"_ICUandMSbeds2.pdf",sep=""),width=11,height=5)
grid.arrange(p1c,p2c,nrow=1)
grid.arrange(p1cross,p2cross,nrow=2)
dev.off()
