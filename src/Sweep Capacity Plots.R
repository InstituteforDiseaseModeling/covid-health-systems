library(ProjectTemplate)
load.project()

DOALLTHETHINGS <- function(INPUTSET=""){
  
  #Remove previously loaded data
  remove(ASSUMPTIONS)
  remove(INPT_OCCUP)
  remove(ICU_OCCUP)
  remove(MEDSURG_OCCUP)
  remove(ICU_QTIME)
  remove(TURNEDAWAY)
  remove(Q_CONTENTS)
  
  #Load CSVs
  ASSUMPTIONS <- read.csv(paste(locationadjust,"SS_R_TRIAL_ASSUMPTIONS_TRACKER_",INPUTSET,".csv",sep=""))
  INPT_OCCUP <- read.csv(paste(locationadjust,"SS_R_INPT_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
  ICU_OCCUP <- read.csv(paste(locationadjust,"SS_R_ICU_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
  MEDSURG_OCCUP <- read.csv(paste(locationadjust,"SS_R_MEDSURG_OCCUPANCY_END_OF_DAY_",INPUTSET,".csv",sep=""))
  ICU_QTIME <- read.csv(paste(locationadjust,"SS_R_INPT_Q_TIME_ICU_ELIGIBLE_BY_DAY_",INPUTSET,".csv",sep=""))
  TURNEDAWAY <- read.csv(paste(locationadjust,"SS_R_TURNED_AWAY_COMPLETED_BY_DAY_",INPUTSET,".csv",sep=""))
  Q_CONTENTS <- read.csv(paste(locationadjust,"SS_R_INPT_Q_CONTENTS_END_OF_DAY_",INPUTSET,".csv",sep=""))
  
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
  
  INPT_OCCUP <- subset(INPT_OCCUP,AAC_beds!="")
  ICU_OCCUP <- subset(ICU_OCCUP,AAC_beds!="")
  MEDSURG_OCCUP <- subset(MEDSURG_OCCUP,AAC_beds!="")
  ICU_QTIME <- subset(ICU_QTIME,AAC_beds!="")
  TURNEDAWAY <- subset(TURNEDAWAY,AAC_beds!="")
  Q_CONTENTS <- subset(Q_CONTENTS,AAC_beds!="")
  ASSUMPTIONS <- subset(ASSUMPTIONS,!is.na(Sweep_AAC_Beds))
  
  INPT_Melt <- melt(INPT_OCCUP,id=c("Open.Num","Trial.Num","Run.Num","AAC_beds","ICU_beds"),
                    value.name="Value",variable.name="Day")
  ICU_Melt <- melt(ICU_OCCUP,id=c("Open.Num","Trial.Num","Run.Num","AAC_beds","ICU_beds"),
                   value.name="Value",variable.name="Day")
  MS_Melt <- melt(MEDSURG_OCCUP,id=c("Open.Num","Trial.Num","Run.Num","AAC_beds","ICU_beds"),
                  value.name="Value",variable.name="Day")
  ICUQ_Melt <- melt(ICU_QTIME,id=c("Open.Num","Trial.Num","Run.Num","AAC_beds","ICU_beds"),
                    value.name="Value",variable.name="Day")
  TA_Melt <- melt(TURNEDAWAY,id=c("Open.Num","Trial.Num","Run.Num","AAC_beds","ICU_beds"),
                  value.name="Value",variable.name="Day")
  QC_Melt <- melt(Q_CONTENTS,id=c("Open.Num","Trial.Num","Run.Num","AAC_beds","ICU_beds"),
                  value.name="Value",variable.name="Day")
  
  INPT_Melt$Day <- as.numeric(gsub("Day.", "", INPT_Melt$Day))
  ICU_Melt$Day <- as.numeric(gsub("Day.", "", ICU_Melt$Day))
  MS_Melt$Day <- as.numeric(gsub("Day.", "", MS_Melt$Day))
  ICUQ_Melt$Day <- as.numeric(gsub("Day.", "", ICUQ_Melt$Day))
  TA_Melt$Day <- as.numeric(gsub("Day.", "", TA_Melt$Day))
  QC_Melt$Day <- as.numeric(gsub("Day.", "", QC_Melt$Day))
  
  INPT_Melt$Value <- as.numeric(INPT_Melt$Value)*scale_factor
  ICU_Melt$Value <- as.numeric(ICU_Melt$Value)*scale_factor
  MS_Melt$Value <- as.numeric(MS_Melt$Value)*scale_factor
  ICUQ_Melt$Value <- as.numeric(ICUQ_Melt$Value)
  TA_Melt$Value <- as.numeric(TA_Melt$Value)*scale_factor
  QC_Melt$Value <- as.numeric(QC_Melt$Value)*scale_factor
  
  INPT_Melt <- subset(INPT_Melt,!is.na(Value))
  ICU_Melt <- subset(ICU_Melt,!is.na(Value))
  MS_Melt <- subset(MS_Melt,!is.na(Value))
  ICUQ_Melt <- subset(ICUQ_Melt,!is.na(Value))
  TA_Melt <- subset(TA_Melt,!is.na(Value))
  QC_Melt <- subset(QC_Melt,!is.na(Value))
  
  #Average values for smoothing over the trials/repetitions
  INPT_Melt_Avg <- ddply(INPT_Melt,.(AAC_beds,ICU_beds,Day),summarize,Value_Sm=mean(Value))
  ICU_Melt_Avg <- ddply(ICU_Melt,.(AAC_beds,ICU_beds,Day),summarize,Value_Sm=mean(Value))
  MS_Melt_Avg <- ddply(MS_Melt,.(AAC_beds,ICU_beds,Day),summarize,Value_Sm=mean(Value))
  ICUQ_Melt_Avg <- ddply(ICUQ_Melt,.(AAC_beds,ICU_beds,Day),summarize,Value_Sm=mean(Value)/60)
  TA_Melt_Avg <- ddply(TA_Melt,.(AAC_beds,ICU_beds,Day),summarize,Value_Sm=mean(Value))
  QC_Melt_Avg <- ddply(QC_Melt,.(AAC_beds,ICU_beds,Day),summarize,Value_Sm=mean(Value))
  ICU_Util_Melt_Avg <- ICU_Melt_Avg
  ICU_Util_Melt_Avg$Value_Sm <- ICU_Util_Melt_Avg$Value_Sm/ICU_Util_Melt_Avg$ICU_beds
  AAC_Util_Melt_Avg <- MS_Melt_Avg
  AAC_Util_Melt_Avg$Value_Sm <- AAC_Util_Melt_Avg$Value_Sm/AAC_Util_Melt_Avg$AAC_beds
  
  data_set_list <- list(INPT_Melt_Avg,ICU_Melt_Avg,ICU_Util_Melt_Avg,MS_Melt_Avg,AAC_Util_Melt_Avg,ICUQ_Melt_Avg,TA_Melt_Avg,QC_Melt_Avg)
  title_list <- c("Inpatient Occupancy","ICU Occupancy","ICU Bed Utilization","AAC Occupancy","AAC Bed Utilization","ICU Queue Time (hrs)","Number Turned Away","Number Waiting")
  dayset <- seq(5,40,by=5)
  myplots <- vector('list',length(data_set_list)*length(dayset))
  counternum <- 1
  
  for (ds in 1:length(data_set_list)){
    for (day in dayset){
      thisdata <- as.data.frame(data_set_list[ds])
      testsub <- subset(thisdata,Day==day)
      this.plot <- ggplot(testsub,aes(x=AAC_beds,y=ICU_beds,fill=Value_Sm))+geom_tile()+theme_bw() +
        xlab("AAC per 100k Pop")+ylab("ICU per 100k Pop") +
        labs(title=paste(title_list[ds]),
             subtitle=paste("Day ",mean(testsub$Day)))+
        theme(legend.title = element_blank()) +
        scale_fill_gradient(low="darkblue",high="goldenrod2",limits=c(0,max(subset(thisdata,Day<=max(dayset))$Value_Sm)))
      myplots[[counternum]] <- this.plot
      counternum = counternum+1
    }
  }
  
  #Calculate the number of days in each trial until max capacity is reached.
  INPT_Daystomax <- INPT_Melt
  INPT_Daystomax <- subset(INPT_Daystomax,Value>=(AAC_beds+ICU_beds))
  INPT_Daystomax <- ddply(INPT_Daystomax,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  INPT_Daystomax <- ddply(INPT_Daystomax,.(AAC_beds,ICU_beds),summarize,
                          DaystomaxMean=mean(Daystomax),
                          dtm_q1 = quantile(Daystomax,probs=c(.05)),
                          dtm_q2 = quantile(Daystomax,probs=c(.95)))
  AAC_Daystomax <- MS_Melt
  AAC_Daystomax <- subset(AAC_Daystomax,Value>=(AAC_beds))
  AAC_Daystomax <- ddply(AAC_Daystomax,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  AAC_Daystomax <- ddply(AAC_Daystomax,.(AAC_beds,ICU_beds),summarize,
                         DaystomaxMean=mean(Daystomax),
                         dtm_q1 = quantile(Daystomax,probs=c(.05)),
                         dtm_q2 = quantile(Daystomax,probs=c(.95)))
  ICU_Daystomax <- ICU_Melt
  ICU_Daystomax <- subset(ICU_Daystomax,Value>=(ICU_beds))
  ICU_Daystomax <- ddply(ICU_Daystomax,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  ICU_Daystomax <- ddply(ICU_Daystomax,.(AAC_beds,ICU_beds),summarize,
                         DaystomaxMean=mean(Daystomax),
                         dtm_q1 = quantile(Daystomax,probs=c(.05)),
                         dtm_q2 = quantile(Daystomax,probs=c(.95)))
  ICU_Daysto6hr <- ICUQ_Melt
  ICU_Daysto6hr <- subset(ICU_Daysto6hr,Value>=(6*60))
  ICU_Daysto6hr <- ddply(ICU_Daysto6hr,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  ICU_Daysto6hr <- ddply(ICU_Daysto6hr,.(AAC_beds,ICU_beds),summarize,
                         DaystomaxMean=mean(Daystomax),
                         dtm_q1 = quantile(Daystomax,probs=c(.05)),
                         dtm_q2 = quantile(Daystomax,probs=c(.95)))
  ICU_Daysto12hr <- ICUQ_Melt
  ICU_Daysto12hr <- subset(ICU_Daysto12hr,Value>=(12*60))
  ICU_Daysto12hr <- ddply(ICU_Daysto12hr,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  ICU_Daysto12hr <- ddply(ICU_Daysto12hr,.(AAC_beds,ICU_beds),summarize,
                          DaystomaxMean=mean(Daystomax),
                          dtm_q1 = quantile(Daystomax,probs=c(.05)),
                          dtm_q2 = quantile(Daystomax,probs=c(.95)))
  ICU_Daysto24hr <- ICUQ_Melt
  ICU_Daysto24hr <- subset(ICU_Daysto24hr,Value>=(24*60))
  ICU_Daysto24hr <- ddply(ICU_Daysto24hr,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  ICU_Daysto24hr <- ddply(ICU_Daysto24hr,.(AAC_beds,ICU_beds),summarize,
                          DaystomaxMean=mean(Daystomax),
                          dtm_q1 = quantile(Daystomax,probs=c(.05)),
                          dtm_q2 = quantile(Daystomax,probs=c(.95)))
  ICU_Daysto48hr <- ICUQ_Melt
  ICU_Daysto48hr <- subset(ICU_Daysto48hr,Value>=(48*60))
  ICU_Daysto48hr <- ddply(ICU_Daysto48hr,.(AAC_beds,ICU_beds,Trial.Num),summarize,Daystomax=min(Day))
  ICU_Daysto48hr <- ddply(ICU_Daysto48hr,.(AAC_beds,ICU_beds),summarize,
                          DaystomaxMean=mean(Daystomax),
                          dtm_q1 = quantile(Daystomax,probs=c(.05)),
                          dtm_q2 = quantile(Daystomax,probs=c(.95)))
  
  data_set_list <- list(INPT_Daystomax,AAC_Daystomax,ICU_Daystomax,ICU_Daysto6hr,ICU_Daysto24hr,ICU_Daysto48hr)
  title_list <- c("Days to Inpatient Full","Days to AAC Full","Days to ICU Full","Days to 6 hr Wait","Days to 24 hr Wait","Days to 48 hr Wait")
  myplots2 <- vector('list',length(data_set_list))
  counternum <- 1
  
  for (ds in 1:length(data_set_list)){
    thisdata <- as.data.frame(data_set_list[ds])
    this.plot <- ggplot(thisdata,aes(x=AAC_beds,y=ICU_beds,fill=DaystomaxMean))+geom_tile()+theme_bw() +
      xlab("AAC per 100k Pop")+ylab("ICU per 100k Pop") +
      labs(title=title_list[ds])+
      theme(legend.title = element_blank()) +
      scale_fill_gradient(low="darkblue",high="goldenrod2",limits=c(0,max(ICU_Melt$Day))) +
      xlim(min(ASSUMPTIONS$Sweep_AAC_Beds),max(ASSUMPTIONS$Sweep_AAC_Beds))+
      ylim(min(ASSUMPTIONS$Sweep_ICU_Beds),max(ASSUMPTIONS$Sweep_ICU_Beds))
    myplots2[[counternum]] <- this.plot
    counternum = counternum+1
  }
  
  plotsub <- subset(ICU_Daystomax,AAC_beds==max(AAC_beds))
  pICU_Days <- ggplot(plotsub,aes(x=ICU_beds,y=DaystomaxMean))+geom_bar(stat="identity",fill="darkblue")+theme_bw() +
    geom_errorbar(aes(ymin=dtm_q1,ymax=dtm_q2),width=.2,position=position_dodge(.9))+
    labs(title="Days to ICU Full Occupancy") + xlab("ICU per 100k Pop")+ylab("Days")+ylim(0,max(ICU_Melt$Day)*1.05)
  
  pICU_Days2 <- ggplot(plotsub,aes(x=ICU_beds,y=DaystomaxMean))+geom_line()+theme_bw() +
    labs(title="Days to ICU Full Occupancy") + xlab("ICU per 100k Pop")+ylab("Days") +
    geom_ribbon(data=plotsub,aes(xmin=min(plotsub$ICU_beds),xmax=max(plotsub$ICU_beds),ymin=dtm_q1,ymax=dtm_q2),alpha=.5,fill="darkblue") 
  
  plotsub6 <- subset(ICU_Daysto6hr,ICU_beds==round(median(ICU_beds),0))
  plotsub6$Delay <- "6 hours"
  plotsub12 <- subset(ICU_Daysto12hr,ICU_beds==round(median(ICU_beds),0))
  plotsub12$Delay <- "12 hours"
  plotsub24 <- subset(ICU_Daysto24hr,ICU_beds==round(median(ICU_beds),0))
  plotsub24$Delay <- "24 hours"
  plotsub <- rbind(plotsub6,plotsub12,plotsub24)
  plotsub$Delay <- factor(plotsub$Delay,ordered=TRUE,levels=c("6 hours","12 hours","24 hours"))
  pDaysToDelay <- ggplot(plotsub,aes(x=(AAC_beds+ICU_beds),y=DaystomaxMean,group=Delay))+
    geom_line(data=plotsub,aes(x=(AAC_beds+ICU_beds),y=DaystomaxMean,group=Delay))+theme_bw() +
    labs(title="Days Until Placement Delays for Inpatient Beds") + xlab("Total Beds per 100k Pop")+ylab("Days") +
    geom_ribbon(data=plotsub,aes(ymin=dtm_q1,ymax=dtm_q2,fill=plotsub$Delay),alpha=.5) +
    facet_wrap(~Delay) + theme(legend.position = "none") + ylim(0,max(ICU_Melt$Day)*1.05)+
    xlim(min(ASSUMPTIONS$Sweep_ICU_Beds+ASSUMPTIONS$Sweep_AAC_Beds),max(ASSUMPTIONS$Sweep_ICU_Beds+ASSUMPTIONS$Sweep_AAC_Beds))
  
  
  pdf(paste(resultsadjust,SETLABEL,"_Heatmaps_bybeds.pdf",sep=""),width=16,height=9)
  grid.arrange(myplots[[1]],myplots[[2]],myplots[[3]],myplots[[4]],myplots[[5]],myplots[[6]],myplots[[7]],myplots[[8]],nrow=2)
  grid.arrange(myplots[[9]],myplots[[10]],myplots[[11]],myplots[[12]],myplots[[13]],myplots[[14]],myplots[[15]],myplots[[16]],nrow=2)
  grid.arrange(myplots[[17]],myplots[[18]],myplots[[19]],myplots[[20]],myplots[[21]],myplots[[22]],myplots[[23]],myplots[[24]],nrow=2)
  grid.arrange(myplots[[25]],myplots[[26]],myplots[[27]],myplots[[28]],myplots[[29]],myplots[[30]],myplots[[31]],myplots[[32]],nrow=2)
  grid.arrange(myplots[[33]],myplots[[34]],myplots[[35]],myplots[[36]],myplots[[37]],myplots[[38]],myplots[[39]],myplots[[40]],nrow=2)
  grid.arrange(myplots[[41]],myplots[[42]],myplots[[43]],myplots[[44]],myplots[[45]],myplots[[46]],myplots[[47]],myplots[[48]],nrow=2)
  grid.arrange(myplots[[49]],myplots[[50]],myplots[[51]],myplots[[52]],myplots[[53]],myplots[[54]],myplots[[55]],myplots[[56]],nrow=2)
  grid.arrange(myplots[[57]],myplots[[58]],myplots[[59]],myplots[[60]],myplots[[61]],myplots[[62]],myplots[[63]],myplots[[64]],nrow=2)
  grid.arrange(myplots2[[1]],myplots2[[2]],myplots2[[3]],myplots2[[4]],myplots2[[5]],myplots2[[6]],nrow=2)
  dev.off()
  
  pdf(paste(resultsadjust,SETLABEL,"_TimeToOutcome.pdf",sep=""),width=8,height=5)
  myplots2[[1]]
  pICU_Days
  pDaysToDelay
  dev.off()
  
  Qout <- rbind(ICU_Daysto6hr,ICU_Daysto12hr,ICU_Daysto24hr,ICU_Daysto48hr)
  
  write.csv(INPT_Daystomax,paste(resultsadjust,SETLABEL,"_DaysToInptMax.csv"))
  write.csv(ICU_Daystomax,paste(resultsadjust,SETLABEL,"_DaysToICUMax.csv"))
  write.csv(Qout,paste(resultsadjust,SETLABEL,"_QTimeDelays.csv"))
  
}

resultsadjust <- "../New Capacity Sweep/"
scale_factor <- 1

locationadjust <- "../New Capacity Sweep/Moderate Social Distancing/"
SETLABEL <- "MSD"
INPUTSET <- "321_CapacitySweepOnline_BL"
DOALLTHETHINGS(INPUTSET=INPUTSET)

locationadjust <- "../New Capacity Sweep/School Closure 20 Weeks/"
SETLABEL <- "SC20"
INPUTSET <- "325_BESTRUN"
DOALLTHETHINGS(INPUTSET=INPUTSET)

locationadjust <- "../New Capacity Sweep/School Closure 2 Weeks/"
SETLABEL <- "SC_2W"
INPUTSET <- ""
DOALLTHETHINGS(INPUTSET=INPUTSET)

INPTMAX1 <- read.csv(paste(resultsadjust,"CapacitySweep_BL","_DaystoInptMax.csv"))
INPTMAX2 <- read.csv(paste(resultsadjust,"SocialDistancing_60","_DaystoInptMax.csv"))
INPTMAX3 <- read.csv(paste(resultsadjust,"SchoolsClosed12","_DaystoInptMax.csv"))
ICUMAX1 <- read.csv(paste(resultsadjust,"CapacitySweep_BL","_DaystoICUMax.csv"))
ICUMAX2 <- read.csv(paste(resultsadjust,"SocialDistancing_60","_DaystoICUMax.csv"))
ICUMAX3 <- read.csv(paste(resultsadjust,"SchoolsClosed12","_DaystoICUMax.csv"))
QTIME1 <- read.csv(paste(resultsadjust,"CapacitySweep_BL","_QTimeDelays.csv"))
QTIME2 <- read.csv(paste(resultsadjust,"SocialDistancing_60","_QTimeDelays.csv"))
QTIME3 <- read.csv(paste(resultsadjust,"SchoolsClosed12","_QTimeDelays.csv"))

scenario_list <- c("Baseline","Moderate Social Distancing","Schools Closed 12 Weeks")
list_ordered <- c(scenario_list[1],scenario_list[2],scenario_list[3])
SETLABEL <- "SummaryResults"

INPTMAX1$Scenario <- scenario_list[1]
INPTMAX2$Scenario <- scenario_list[2]
INPTMAX3$Scenario <- scenario_list[3]
ICUMAX1$Scenario <- scenario_list[1]
ICUMAX2$Scenario <- scenario_list[2]
ICUMAX3$Scenario <- scenario_list[3]
QTIME1$Scenario <- scenario_list[1]
QTIME2$Scenario <- scenario_list[2]
QTIME3$Scenario <- scenario_list[3]

InpatientMax <- rbind(INPTMAX1,INPTMAX2,INPTMAX3)
ICUMax <- rbind(ICUMAX1,ICUMAX2,ICUMAX3)
QTIME <- rbind(QTIME1,QTIME2,QTIME3)

InpatientMax$Scenario <- factor(InpatientMax$Scenario,ordered=TRUE,levels=list_ordered)
ICUMax$Scenario <- factor(ICUMax$Scenario,ordered=TRUE,levels=list_ordered)
QTIME$Scenario <- factor(QTIME$Scenario,ordered=TRUE,levels=list_ordered)

QTIME$Description <- paste(round(QTIME$DaystomaxMean,1)," (",round(QTIME$dtm_q1,1),", ",round(QTIME$dtm_q2,1),")",sep="")
write.csv(QTIME,paste(resultsadjust,SETLABEL,"Queue Time.csv",sep=""))

DS <- data.frame(read_xlsx(here("data/Book1.xlsx")))

InpatientMax$AAC_beds <- as.numeric(InpatientMax$AAC_beds)
InpatientMax$ICU_beds <- as.numeric(InpatientMax$ICU_beds)
p1 <- ggplot()+
  geom_tile(data=InpatientMax,aes(x=AAC_beds,y=ICU_beds,fill=DaystomaxMean/7))+theme_bw() +
  xlab("AAC per 100k Pop")+ylab("ICU per 100k Pop") +
  labs(title="Weeks Until COVID Census Exceeds Total Capacity") +
  theme(legend.title = "Weeks") +
  scale_fill_viridis(option="magma",direction=-1,oob=squish)+
  xlim(min(ASSUMPTIONS$Sweep_AAC_Beds),150)+
  ylim(min(ASSUMPTIONS$Sweep_ICU_Beds),max(ASSUMPTIONS$Sweep_ICU_Beds)) + 
  facet_wrap(~Scenario) + geom_point(data=DS,aes(x=AAC,y=ICU)) + 
  geom_text(data=DS,aes(x=AAC,y=ICU,label=County),hjust=-0.1,vjust=0)

ICUMax <- subset(ICUMax,AAC_beds==max(AAC_beds))
p2 <- ggplot(ICUMax,aes(x=ICU_beds,y=DaystomaxMean/7))+geom_point()+theme_bw() +
  geom_errorbar(aes(ymin=dtm_q1/7,ymax=dtm_q2/7),width=.2,position=position_dodge(.9))+
  labs(title="Weeks Until COVID ICU Census Exceed ICU Capacity") + xlab("ICU Beds per 100k Pop") +
  ylab("Weeks Until Maxed Capacity")+ylim(0,max(ICU_Melt$Day)*1.05)+
  facet_wrap(~Scenario)

QTIME <- subset(QTIME,Delay=="12 hours")
p3 <- ggplot(QTIME,aes(x=(AAC_beds+ICU_beds),y=DaystomaxMean,group=Scenario))+
  geom_line(data=QTIME,aes(x=(AAC_beds+ICU_beds),y=DaystomaxMean,group=Scenario))+theme_bw() +
  labs(title="Days Until Placement Delays for Inpatient Beds Exceed 12 Hours") + xlab("Total Beds per 100k Pop")+ylab("Days") +
  geom_ribbon(data=QTIME,aes(ymin=dtm_q1,ymax=dtm_q2,fill=QTIME$Scenario),alpha=.5) +
  theme(legend.title =  element_blank()) + ylim(0,max(ICU_Melt$Day)*1.05)+
  xlim(min(ASSUMPTIONS$Sweep_ICU_Beds+ASSUMPTIONS$Sweep_AAC_Beds),max(ASSUMPTIONS$Sweep_ICU_Beds+ASSUMPTIONS$Sweep_AAC_Beds))

pdf(paste(resultsadjust,SETLABEL,"_AllThreeScenarios.pdf",sep=""),width=10,height=5)
plot(p1)
plot(p2)
plot(p3)
dev.off()

