#Analysis Script for the COVID Health Systems Model
#Github model source location: https://github.com/InstituteforDiseaseModeling/covid-health-systems

################################################################################################################
################################################################################################################
################################################################################################################

# Manually Input Your Export Name Here
# When you exported your simulation results, you assigned a file name, such as "March 28-DemoRun".
# Enter the exact same text between the " " in the line below, replacing the example text.
INPUTSET <- "DEMOMODELRUN1" 


################################################################################################################
################################################################################################################
################################################################################################################
# Do Not Edit Below
################################################################################################################

list.of.packages <- c("ggplot2", "plyr","dplyr","scales","reshape2","gridExtra","RColorBrewer")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(ggplot2)
library(plyr)
library(dplyr)
library(scales)
library(reshape2)
library(gridExtra)
library(RColorBrewer)

#Set working directory to current file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Load CSVs
ASSUMPTIONS <- read.csv(paste("SS_R_TRIAL_ASSUMPTIONS_TRACKER_",INPUTSET,".csv",sep=""))
INPT_OCCUP <- read.csv(paste("SS_R_INPT_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
ICU_OCCUP <- read.csv(paste("SS_R_ICU_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
MEDSURG_OCCUP <- read.csv(paste("SS_R_MEDSURG_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
ICU_QTIME <- read.csv(paste("SS_R_INPT_Q_TIME_ICU_ELIGIBLE_BY_DAY_",INPUTSET,".csv",sep=""))
TURNEDAWAY <- read.csv(paste("SS_R_TURNED_AWAY_COMPLETED_BY_DAY_",INPUTSET,".csv",sep=""))
Q_CONTENTS <- read.csv(paste("SS_R_INPT_Q_CONTENTS_END_OF_DAY_",INPUTSET,".csv",sep=""))

#This is used to name results file PDFs.
SETLABEL <- INPUTSET

#Set up scenario descriptions
epi_names <- c("Mild distance","Mild distance","Mild distance",
               "Moderate distance","Moderate distance","Moderate distance",
               "Aggressive distance","Aggressive distance","Aggressive distance",
               "0.3% test & isolate","0.3% test & isolate","0.3% test & isolate",
               "1.0% test & isolate","1.0% test & isolate","1.0% test & isolate")
type_names <- c("Best Case Epi","Median Case Epi","Worst Case Epi",
                "Best Case Epi","Median Case Epi","Worst Case Epi",
                "Best Case Epi","Median Case Epi","Worst Case Epi",
                "Best Case Epi","Median Case Epi","Worst Case Epi",
                "Best Case Epi","Median Case Epi","Worst Case Epi")
cap_names <- c("Typical occupancy","Cancel 20%","Cancel 50%")

#Set up values
value_list <- c("Best Case Epi","Median Case Epi","Worst Case Epi")
num_trials <- max(ASSUMPTIONS$Trial.Num)
sim_pop <- ASSUMPTIONS$Population.Size[1]

#Tag the Assumptions sheet with scenario number and info
ASSUMPTIONS$ScenNum <- ASSUMPTIONS$Select.EpiCurve*10+ASSUMPTIONS$Select.Capacity
ASSUMPTIONS$ScenEpi <- epi_names[ASSUMPTIONS$Select.EpiCurve]
ASSUMPTIONS$ScenCap <- cap_names[ASSUMPTIONS$Select.Capacity]
ASSUMPTIONS$Scenario <- paste(ASSUMPTIONS$ScenEpi,"/",ASSUMPTIONS$ScenCap)
ASSUMPTIONS$Type <- type_names[ASSUMPTIONS$Select.EpiCurve]
scenario_list <- unique(ASSUMPTIONS$Scenario)
scenario_list_ordered <- scenario_list

#Match assumptions to data results sheets
INPT_OCCUP$AAC_beds <- ASSUMPTIONS$Sweep_AAC_Beds[INPT_OCCUP$Run.Num]
ICU_OCCUP$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[ICU_QTIME$Run.Num]
TURNEDAWAY$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[TURNEDAWAY$Run.Num]
Q_CONTENTS$AAC_beds = ASSUMPTIONS$Sweep_AAC_Beds[Q_CONTENTS$Run.Num]

INPT_OCCUP$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[INPT_OCCUP$Run.Num]
ICU_OCCUP$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[ICU_QTIME$Run.Num]
TURNEDAWAY$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[TURNEDAWAY$Run.Num]
Q_CONTENTS$ICU_beds = ASSUMPTIONS$Sweep_ICU_Beds[Q_CONTENTS$Run.Num]

INPT_OCCUP$Scenario = ASSUMPTIONS$Scenario[INPT_OCCUP$Run.Num]
ICU_OCCUP$Scenario = ASSUMPTIONS$Scenario[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$Scenario = ASSUMPTIONS$Scenario[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$Scenario = ASSUMPTIONS$Scenario[ICU_QTIME$Run.Num]
TURNEDAWAY$Scenario = ASSUMPTIONS$Scenario[TURNEDAWAY$Run.Num]
Q_CONTENTS$Scenario = ASSUMPTIONS$Scenario[Q_CONTENTS$Run.Num]

INPT_OCCUP$Type = ASSUMPTIONS$Type[INPT_OCCUP$Run.Num]
ICU_OCCUP$Type = ASSUMPTIONS$Type[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$Type = ASSUMPTIONS$Type[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$Type = ASSUMPTIONS$Type[ICU_QTIME$Run.Num]
TURNEDAWAY$Type = ASSUMPTIONS$Type[TURNEDAWAY$Run.Num]
Q_CONTENTS$Type = ASSUMPTIONS$Type[Q_CONTENTS$Run.Num]

INPT_OCCUP$ScenEpi = ASSUMPTIONS$ScenEpi[INPT_OCCUP$Run.Num]
ICU_OCCUP$ScenEpi = ASSUMPTIONS$ScenEpi[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$ScenEpi = ASSUMPTIONS$ScenEpi[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$ScenEpi = ASSUMPTIONS$ScenEpi[ICU_QTIME$Run.Num]
TURNEDAWAY$ScenEpi = ASSUMPTIONS$ScenEpi[TURNEDAWAY$Run.Num]
Q_CONTENTS$ScenEpi = ASSUMPTIONS$ScenEpi[Q_CONTENTS$Run.Num]

INPT_OCCUP$ScenCap = ASSUMPTIONS$ScenCap[INPT_OCCUP$Run.Num]
ICU_OCCUP$ScenCap = ASSUMPTIONS$ScenCap[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$ScenCap = ASSUMPTIONS$ScenCap[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$ScenCap = ASSUMPTIONS$ScenCap[ICU_QTIME$Run.Num]
TURNEDAWAY$ScenCap = ASSUMPTIONS$ScenCap[TURNEDAWAY$Run.Num]
Q_CONTENTS$ScenCap = ASSUMPTIONS$ScenCap[Q_CONTENTS$Run.Num]

INPT_OCCUP$TotalNumBedsAAC = ASSUMPTIONS$TotalNumBedsAAC[INPT_OCCUP$Run.Num]
ICU_OCCUP$TotalNumBedsAAC = ASSUMPTIONS$TotalNumBedsAAC[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$TotalNumBedsAAC = ASSUMPTIONS$TotalNumBedsAAC[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$TotalNumBedsAAC = ASSUMPTIONS$TotalNumBedsAAC[ICU_QTIME$Run.Num]
TURNEDAWAY$TotalNumBedsAAC = ASSUMPTIONS$TotalNumBedsAAC[TURNEDAWAY$Run.Num]
Q_CONTENTS$TotalNumBedsAAC = ASSUMPTIONS$TotalNumBedsAAC[Q_CONTENTS$Run.Num]

INPT_OCCUP$TotalNumBedsICU = ASSUMPTIONS$TotalNumBedsICU[INPT_OCCUP$Run.Num]
ICU_OCCUP$TotalNumBedsICU = ASSUMPTIONS$TotalNumBedsICU[ICU_OCCUP$Run.Num]
MEDSURG_OCCUP$TotalNumBedsICU = ASSUMPTIONS$TotalNumBedsICU[MEDSURG_OCCUP$Run.Num]
ICU_QTIME$TotalNumBedsICU = ASSUMPTIONS$TotalNumBedsICU[ICU_QTIME$Run.Num]
TURNEDAWAY$TotalNumBedsICU = ASSUMPTIONS$TotalNumBedsICU[TURNEDAWAY$Run.Num]
Q_CONTENTS$TotalNumBedsICU = ASSUMPTIONS$TotalNumBedsICU[Q_CONTENTS$Run.Num]

INPT_OCCUP <- subset(INPT_OCCUP,Scenario!="")
ICU_OCCUP <- subset(ICU_OCCUP,Scenario!="")
MEDSURG_OCCUP <- subset(MEDSURG_OCCUP,Scenario!="")
ICU_QTIME <- subset(ICU_QTIME,Scenario!="")
TURNEDAWAY <- subset(TURNEDAWAY,Scenario!="")
Q_CONTENTS <- subset(Q_CONTENTS,Scenario!="")
INPT_OCCUP <- subset(INPT_OCCUP,Scenario!="NA / NA")
ICU_OCCUP <- subset(ICU_OCCUP,Scenario!="NA / NA")
MEDSURG_OCCUP <- subset(MEDSURG_OCCUP,Scenario!="NA / NA")
ICU_QTIME <- subset(ICU_QTIME,Scenario!="NA / NA")
TURNEDAWAY <- subset(TURNEDAWAY,Scenario!="NA / NA")
Q_CONTENTS <- subset(Q_CONTENTS,Scenario!="NA / NA")

INPT_Melt <- melt(INPT_OCCUP,id=c("Trial.Num","Run.Num","Scenario","Type","ScenEpi","ScenCap","TotalNumBedsICU","TotalNumBedsAAC"),
                  value.name="Occupancy",variable.name="Day")
ICU_Melt <- melt(ICU_OCCUP,id=c("Trial.Num","Run.Num","Scenario","Type","ScenEpi","ScenCap","TotalNumBedsICU","TotalNumBedsAAC"),
                 value.name="Occupancy",variable.name="Day")
MS_Melt <- melt(MEDSURG_OCCUP,id=c("Trial.Num","Run.Num","Scenario","Type","ScenEpi","ScenCap","TotalNumBedsICU","TotalNumBedsAAC"),
                value.name="Occupancy",variable.name="Day")
ICUQ_Melt <- melt(ICU_QTIME,id=c("Trial.Num","Run.Num","Scenario","Type","ScenEpi","ScenCap","TotalNumBedsICU","TotalNumBedsAAC"),
                value.name="Queue_Time",variable.name="Day")
TA_Melt <- melt(TURNEDAWAY,id=c("Trial.Num","Run.Num","Scenario","Type","ScenEpi","ScenCap","TotalNumBedsICU","TotalNumBedsAAC"),
                value.name="Number",variable.name="Day")
QC_Melt <- melt(Q_CONTENTS,id=c("Trial.Num","Run.Num","Scenario","Type","ScenEpi","ScenCap","TotalNumBedsICU","TotalNumBedsAAC"),
                value.name="Number",variable.name="Day")

INPT_Melt$Day <- as.numeric(gsub("Day.", "", INPT_Melt$Day))
ICU_Melt$Day <- as.numeric(gsub("Day.", "", ICU_Melt$Day))
MS_Melt$Day <- as.numeric(gsub("Day.", "", MS_Melt$Day))
ICUQ_Melt$Day <- as.numeric(gsub("Day.", "", ICUQ_Melt$Day))
TA_Melt$Day <- as.numeric(gsub("Day.", "", TA_Melt$Day))
QC_Melt$Day <- as.numeric(gsub("Day.", "", QC_Melt$Day))

INPT_Melt <- subset(INPT_Melt,!is.na(Day))
ICU_Melt <- subset(ICU_Melt,!is.na(Day))
MS_Melt <- subset(MS_Melt,!is.na(Day))
ICUQ_Melt <- subset(ICUQ_Melt,!is.na(Day))
TA_Melt <- subset(TA_Melt,!is.na(Day))
QC_Melt <- subset(QC_Melt,!is.na(Day))

INPT_Melt$Occupancy <- as.numeric(INPT_Melt$Occupancy)
ICU_Melt$Occupancy <- as.numeric(ICU_Melt$Occupancy)
MS_Melt$Occupancy <- as.numeric(MS_Melt$Occupancy)
ICUQ_Melt$Queue_Time <- as.numeric(ICUQ_Melt$Queue_Time)
TA_Melt$Number <- as.numeric(TA_Melt$Number)
QC_Melt$Number <- as.numeric(QC_Melt$Number)

INPT_Melt <- subset(INPT_Melt,!is.na(Occupancy))
ICU_Melt <- subset(ICU_Melt,!is.na(Occupancy))
MS_Melt <- subset(MS_Melt,!is.na(Occupancy))
ICUQ_Melt <- subset(ICUQ_Melt,!is.na(Queue_Time))
TA_Melt <- subset(TA_Melt,!is.na(Number))
QC_Melt <- subset(QC_Melt,!is.na(Number))

INPT_Melt$Scenario <- factor(INPT_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
ICU_Melt$Scenario <- factor(ICU_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
MS_Melt$Scenario <- factor(MS_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
ICUQ_Melt$Scenario <- factor(ICUQ_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
TA_Melt$Scenario <- factor(TA_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)
QC_Melt$Scenario <- factor(QC_Melt$Scenario,ordered=TRUE,levels=scenario_list_ordered)

INPT_Melt$ScenEpi <- factor(INPT_Melt$ScenEpi)
ICU_Melt$ScenEpi <- factor(ICU_Melt$ScenEpi)
MS_Melt$ScenEpi <- factor(MS_Melt$ScenEpi)
ICUQ_Melt$ScenEpi <- factor(ICUQ_Melt$ScenEpi)
TA_Melt$ScenEpi <- factor(TA_Melt$ScenEpi)
QC_Melt$ScenEpi <- factor(QC_Melt$ScenEpi)

INPT_Melt$ScenCap <- factor(INPT_Melt$ScenCap)
ICU_Melt$ScenCap <- factor(ICU_Melt$ScenCap)
MS_Melt$ScenCap <- factor(MS_Melt$ScenCap)
ICUQ_Melt$ScenCap <- factor(ICUQ_Melt$ScenCap)
TA_Melt$ScenCap <- factor(TA_Melt$ScenCap)
QC_Melt$ScenCap <- factor(QC_Melt$ScenCap)

INPT_Melt$Type <- factor(INPT_Melt$Type,ordered=TRUE,levels=value_list)
ICU_Melt$Type <- factor(ICU_Melt$Type,ordered=TRUE,levels=value_list)
MS_Melt$Type <- factor(MS_Melt$Type,ordered=TRUE,levels=value_list)
ICUQ_Melt$Type <- factor(ICUQ_Melt$Type,ordered=TRUE,levels=value_list)
TA_Melt$Type <- factor(TA_Melt$Type,ordered=TRUE,levels=value_list)
QC_Melt$Type <- factor(QC_Melt$Type,ordered=TRUE,levels=value_list)

INPT_Melt_Avg <- ddply(INPT_Melt,.(Scenario,Type,Day,ScenEpi,ScenCap),summarize,Occupancy_Sm=mean(Occupancy))
ICU_Melt_Avg <- ddply(ICU_Melt,.(Scenario,Type,Day,ScenEpi,ScenCap),summarize,Occupancy_Sm=mean(Occupancy))
MS_Melt_Avg <- ddply(MS_Melt,.(Scenario,Type,Day,ScenEpi,ScenCap),summarize,Occupancy_Sm=mean(Occupancy))
ICUQ_Melt_Avg <- ddply(ICUQ_Melt,.(Scenario,Type,Day,ScenEpi,ScenCap),summarize,Time_Sm=mean(Queue_Time))
TA_Melt_Avg <- ddply(TA_Melt,.(Scenario,Type,Day,ScenEpi,ScenCap),summarize,Number_Sm=mean(Number))
QC_Melt_Avg <- ddply(QC_Melt,.(Scenario,Type,Day,ScenEpi,ScenCap),summarize,Number_Sm=mean(Number))

p1b <- ggplot(data=ICU_Melt_Avg,aes(x=Day/7,y=Occupancy_Sm,group=Type))+
  geom_line(aes(linetype=Type))+theme_bw()+facet_wrap(~Scenario) +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
  labs(title="ICU Bed Occupancy") + theme(legend.title=element_blank())
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Melt_Avg$Day/7)),by=3))

p2b <- ggplot(data=MS_Melt_Avg,aes(x=Day/7,y=Occupancy_Sm,group=Type))+
  geom_line(aes(linetype=Type))+theme_bw()+facet_wrap(~Scenario)+
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
  labs(title="Adult Acute Bed Occupancy")+
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Melt_Avg$Day/7)),by=3))+ 
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
ICU_Sub$Lower[ICU_Sub$Lower < 0] = 0
p1cross <- ggplot(data=ICU_Sub,aes(x=Day/7,y=Occupancy_Sm,group=Scenario))+
  geom_ribbon(data=ICU_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
  labs(title="ICU Bed Occupancy")+
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Melt_Avg$Day/7)),by=3))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type+Scenario)

ICU_Sub <- subset(ICU_Sub,Type=="Median Case Epi")
ICU_Sub$Lower[ICU_Sub$Lower<0]=0
p1c <- ggplot(data=ICU_Sub,aes(x=Day/7,y=Occupancy_Sm,group=Scenario,color=Scenario))+
  geom_ribbon(data=ICU_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
  labs(title="ICU Bed Occupancy (Median Epi Curves)")+
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(ICU_Sub$Day/7)),by=3))+ 
  theme(legend.title = element_blank()) + facet_wrap(~Scenario)

MS_Sub <- MS_Melt_Avg
MS_Sub$Lower <- MS_Melt_Avg$Occupancy_Sm - MS_Melt_SD$Occupancy_se*1.96*3
MS_Sub$Upper <- MS_Melt_Avg$Occupancy_Sm + MS_Melt_SD$Occupancy_se*1.96*3
MS_Sub$Lower[MS_Sub$Lower < 0] = 0
p2cross <- ggplot(data=MS_Sub,aes(x=Day/7,y=Occupancy_Sm,group=Scenario))+
  geom_ribbon(data=MS_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
  labs(title="Adult Acute Bed Occupancy")+
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Sub$Day/7)),by=3))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type+Scenario)

MS_Sub <- subset(MS_Sub,Type=="Median Case Epi")
MS_Sub$Lower[MS_Sub$Lower<0]=0
p2c <- ggplot(data=MS_Sub,aes(x=Day/7,y=Occupancy_Sm,group=Scenario,color=Scenario))+
  geom_ribbon(data=MS_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
  labs(title="Adult Acute Bed Occupancy (Median Epi Curves)") +
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Sub$Day/7)),by=3))+ 
  theme(legend.title = element_blank()) + facet_wrap(~Scenario)

ICUQ_Sub <- ICUQ_Melt_Avg
ICUQ_Sub$Lower <- ICUQ_Melt_Avg$Time_Sm/60 - ICUQ_Melt_SD$Time_se/60*1.96
ICUQ_Sub$Upper <- ICUQ_Melt_Avg$Time_Sm/60 + ICUQ_Melt_SD$Time_se/60*1.96
ICUQ_Sub$Lower[ICUQ_Sub$Lower < 0] = 0
p3cross <- ggplot(data=ICUQ_Sub,aes(x=Day/7,y=Time_Sm/60,group=Scenario))+
  geom_ribbon(data=ICUQ_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Hours") +
  labs(title="Mean Queueing Time (hrs)",subtitle="Note: Flat lines at 0 indicate no patients experienced placement delays")+
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(ICUQ_Sub$Day/7)),by=3))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type+Scenario)

TA_Sub <- TA_Melt_Avg
TA_Sub$Lower <- TA_Melt_Avg$Number_Sm - TA_Melt_SD$Number_se*1.96
TA_Sub$Upper <- TA_Melt_Avg$Number_Sm + TA_Melt_SD$Number_se*1.96
TA_Sub$Lower[TA_Sub$Lower < 0] = 0
p4cross <- ggplot(data=TA_Sub,aes(x=Day/7,y=Number_Sm,group=Scenario))+
  geom_ribbon(data=TA_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Number Turned Away") +
  labs(title="Number of Patients Turned Away",subtitle="Note: Flat lines at 0 indicate no patients were turned away")+
  scale_x_continuous(breaks=seq(from=1,to=max(TA_Sub$Day/7),by=3))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type+Scenario)

QC_Sub <- QC_Melt_Avg
QC_Sub$Lower <- QC_Melt_Avg$Number_Sm - QC_Melt_SD$Number_se*1.96
QC_Sub$Upper <- QC_Melt_Avg$Number_Sm + QC_Melt_SD$Number_se*1.96
QC_Sub$Lower[QC_Sub$Lower < 0] = 0
p5cross <- ggplot(data=QC_Sub,aes(x=Day/7,y=Number_Sm,group=Scenario))+
  geom_ribbon(data=QC_Sub,aes(ymin=Lower,ymax=Upper,fill=Scenario),alpha=.5) +
  geom_line()+theme_bw() +
  xlab("Weeks since prevalence of 100/10,000 population") + ylab("Number of Patients") +
  labs(title="Number of Patients Waiting for an Inpatient Bed",subtitle="Note: Flat lines at 0 indicate no patients were delayed")+
  scale_x_continuous(breaks=seq(from=1,to=ceiling(max(QC_Sub$Day/7)),by=3))+ 
  theme(legend.title = element_blank()) +facet_wrap(~Type+Scenario)

INPT_Melt_Cast <- dcast(INPT_Melt_Avg, Scenario+Day~Type, mean)
ICU_Melt_Cast <- dcast(ICU_Melt_Avg, Scenario+Day~Type, mean)
MS_Melt_Cast <- dcast(MS_Melt_Avg, Scenario+Day~Type, mean)

# p1 <- ggplot(data=ICU_Melt_Cast,aes(x=Day/7,y='Median Case Epi')) + 
#   geom_ribbon(data=ICU_Melt_Cast,aes(ymin='Best Case Epi',ymax='Upper Bound'),fill="darkblue",alpha=.5) +
#   geom_line(data=ICU_Melt_Cast,aes(x=Day/7,y='Best Case Epi'),color="darkgrey")+
#   geom_line(data=ICU_Melt_Cast,aes(x=Day/7,y='Median Case Epi'),color="black")+
#   geom_line(data=ICU_Melt_Cast,aes(x=Day/7,y='Upper Bound'),color="darkgrey")+
#   theme_bw()+facet_wrap(~Scenario) +
#   xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
#   labs(title="ICU Bed Occupancy (Epi Uncertainty)") + scale_y_continuous(labels = comma) +
#   scale_x_continuous(breaks=seq(from=1,to=ceiling(max(ICU_Melt_Cast$Day/7)),by=3))+ 
#   theme(legend.title = element_blank())
# 
# p2 <- ggplot(data=MS_Melt_Cast,aes(x=Day/7,y='Median Case Epi')) + 
#   geom_ribbon(data=MS_Melt_Cast,aes(xmin=1,xmax=7,ymin='Best Case Epi',ymax='Upper Bound'),fill="darkgreen",alpha=.5) +
#   geom_line(data=MS_Melt_Cast,aes(x=Day/7,y='Best Case Epi'),color="darkgrey")+
#   geom_line(data=MS_Melt_Cast,aes(x=Day/7,y='Median Case Epi'),color="black")+
#   geom_line(data=MS_Melt_Cast,aes(x=Day/7,y='Upper Bound'),color="darkgrey")+
#   theme_bw()+facet_wrap(~Scenario) +
#   xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") +
#   labs(title="Acute Adult Bed Occupancy (Epi Uncertainty)") + scale_y_continuous(labels = comma)+
#   scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Melt_Cast$Day/7)),by=3))+ 
#   theme(legend.title = element_blank())
# 
# p3 <- ggplot(data=ICU_Melt_Cast,aes(x=Day/7,y='Median Case Epi',group=Scenario,color=Scenario)) +
#   geom_line() + theme_bw() + xlab("Weeks since prevalence of 100/10,000 population") + 
#   ylab("Bed Occupancy") + labs(title="ICU Bed Occupancy (Median Epi Curve)") +
#   scale_color_brewer(type="qual",palette = "Dark2") + scale_y_continuous(labels = comma)+
#   scale_x_continuous(breaks=seq(from=1,to=ceiling(max(ICU_Melt_Cast$Day/7)),by=3))+ 
#   theme(legend.title = element_blank())
# 
# p3b <- p3 + scale_y_continuous(labels = comma,limits=c(0,max(MS_Melt_Cast$Expected*1.02)))
# 
# p4 <- ggplot(data=MS_Melt_Cast,aes(x=Day/7,y='Median Case Epi',group=Scenario,color=Scenario)) +
#   geom_line() + theme_bw() + xlab("Weeks since prevalence of 100/10,000 population") + ylab("Bed Occupancy") + 
#   labs(title="Acute Adult Bed Occupancy (Median Epi Curve)") + 
#   scale_y_continuous(labels = comma,limits=c(0,max(MS_Melt_Cast$Expected*1.02))) + 
#   scale_color_brewer(type="qual",palette = "Dark2") +
#   scale_x_continuous(breaks=seq(from=1,to=ceiling(max(MS_Melt_Cast$Day/7)),by=3)) + 
#   theme(legend.title = element_blank())

write.csv(ICU_Melt_Cast,paste(SETLABEL,"_ICU_Cast_Summary.csv"))
write.csv(MS_Melt_Cast,paste(SETLABEL,"_MS_Cast_Summary.csv"))
write.csv(INPT_Melt_Cast,paste(SETLABEL,"_INPT_Cast_Summary.csv"))

wv <- length(unique(ASSUMPTIONS$Scenario))*3.5
pdf(paste(SETLABEL,"_ICUandAACbeds_plots1.pdf",sep=""),width=wv,height=9)
plot(p1b)
plot(p2b)
plot(p1c)
plot(p2c)
plot(p1cross)
plot(p2cross)
plot(p3cross)
plot(p4cross)
plot(p5cross)
dev.off()
