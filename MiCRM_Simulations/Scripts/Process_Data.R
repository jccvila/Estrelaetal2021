rm(list=ls())
library(data.table)
library(gdata)
format_data <- function(exp_id){
  dt = fread(paste('../Data/Raw/',exp_id,'.csv',sep=''))
  metadata = dt[,c(1,2)]
  colnames(metadata)  =c("Family","ESV")
  dt = dt[,3:ncol(dt)]
  dt = apply(dt,2,function(x){x/sum(x)})
  well_id = paste(c('S1','S2','A1','A2','SA','SS','AA'),sep='_')
  colnames(dt) =well_id
  dt = melt(cbind(metadata,dt),id.vars=c("Family","ESV"),value.name='Abundance')
  dt[,c("Treatment","Replicate") :=  tstrsplit(variable,"_",fixed=TRUE)]
  dt$exp_id = exp_id
  return(dt)
}

format_error <- function(exp_id){
  err = fread(paste('../Data/Raw/Error_',exp_id,'.csv',sep=''))
  err_SS = max(err[c(2,3,7),]$V2) #Maximum error for single sugar or pair
  err_AA = max(err[c(4,5,8),]$V2) #Maximum error for a single acid or pair
  err_SA = max(err[c(2,4,6),]$V2) #Maximum error one of singles or pair of sugar and acid
  return(c(err_SS,err_AA,err_SA))
}
experiment_list = fread('Experiment_list.csv')
experiment_list$file = paste('../Data/Raw/', experiment_list$exp_id, '.csv', sep ='')
experiment_list = experiment_list[file.exists(experiment_list$file)] #Gate for runs that did not throw up an error.


tdf = data.table()
tdf = rbindlist(lapply(experiment_list$exp_id,format_data))
tdf[tdf$Abundance<1e-6,]$Abundance = 0 #Abundance <1e-6 are considered extinct
fwrite(tdf,'../Data/Temp/Full_Data_Table.csv')
error_table = data.frame(do.call(rbind,lapply(experiment_list$exp_id,format_error)))
colnames(error_table) = c('SS','AA','SA')
error_table$exp_id = experiment_list$exp_id
error_table =merge(error_table,experiment_list)
fwrite(error_table,'../Data/Error_table.csv')

rm(list=ls())
library(data.table)
#Remove Taxa bellow detection limit in both predicted and observed
tdf = fread('../Data/Temp/Full_Data_Table.csv',na.strings=NULL)
pairs_SS = tdf[Treatment =='SS']
pairs_SS$Abundance_1 = tdf[Treatment == 'S1']$Abundance 
pairs_SS$Abundance_2 = tdf[Treatment == 'S2']$Abundance
pairs_SS$Predicted_Abundance = (pairs_SS$Abundance_1+pairs_SS$Abundance_2)/2
pairs_SS =pairs_SS[Abundance > 0 | Predicted_Abundance > 0]
pairs_SS = pairs_SS[!is.na(pairs_SS$Abundance)]
pairs_SS = pairs_SS[!is.na(pairs_SS$Predicted_Abundance)]
fwrite(pairs_SS,file='../Data/Temp/SS_Pairs.csv')

rm(list=ls())
library(data.table)
#Remove Taxa bellow detection limit in both predicted and observed
tdf = fread('../Data/Temp/Full_Data_Table.csv',na.strings=NULL)
pairs_AA = tdf[Treatment =='AA']
pairs_AA$Abundance_1 = tdf[Treatment == 'A1']$Abundance 
pairs_AA$Abundance_2 = tdf[Treatment == 'A2']$Abundance
pairs_AA$Predicted_Abundance = (pairs_AA$Abundance_1+pairs_AA$Abundance_2)/2
pairs_AA =pairs_AA[Abundance > 0| Predicted_Abundance > 0]
pairs_AA = pairs_AA[!is.na(pairs_AA$Abundance)]
pairs_AA = pairs_AA[!is.na(pairs_AA$Predicted_Abundance)]
fwrite(pairs_AA,file='../Data/Temp/AA_Pairs.csv')

rm(list=ls())
library(data.table)
#Remove Taxa bellow detection limit in both predicted and observed
tdf = fread('../Data/Temp/Full_Data_Table.csv',na.strings=NULL)
pairs_SA = tdf[Treatment =='SA']
pairs_SA$Abundance_1 = tdf[Treatment == 'S1']$Abundance 
pairs_SA$Abundance_2 = tdf[Treatment == 'A1']$Abundance
pairs_SA$Predicted_Abundance = (pairs_SA$Abundance_1+pairs_SA$Abundance_2)/2
pairs_SA =pairs_SA[Abundance > 0 | Predicted_Abundance > 0]
pairs_SA = pairs_SA[!is.na(pairs_SA$Abundance)]
pairs_SA = pairs_SA[!is.na(pairs_SA$Predicted_Abundance)]
fwrite(pairs_SA,file='../Data/Temp/SA_Pairs.csv')

rm(list=ls())
library(data.table)
experiment_list = fread('Experiment_list.csv')
pairs_SS = fread('../Data/Temp/SS_Pairs.csv')
pairs_AA = fread('../Data/Temp/AA_Pairs.csv')
pairs_SA = fread('../Data/Temp/SA_Pairs.csv')
pairs = rbind(pairs_SS,pairs_AA,pairs_SA)
family_pairs  = pairs[,lapply(.SD,sum,na.rm=TRUE),by=list(Family,Treatment,Replicate,exp_id,variable),
                      .SDcols=c('Abundance','Abundance_1','Abundance_2','Predicted_Abundance')]
fwrite(merge(pairs,experiment_list),file='../Data/ESV_Pairs.csv')
fwrite(merge(family_pairs,experiment_list),file='../Data/Family_Pairs.csv')



## Quantify Dominance at the Family level for SA pairs
rm(list=ls())
library(data.table)
library(ggplot2)
library(ggpubr)
library(gridExtra)
library(Metrics)
family_pairs = fread('../Data/Family_Pairs.csv')
family_pairs = family_pairs[Treatment=='SA']
family_pairs$Epsilon = family_pairs$Abundance-family_pairs$Predicted_Abundance
family_pairs$Dominates = 0
family_pairs[Abundance_1 > Abundance_2 & Epsilon >0]$Dominates = -1 #Resource 1 Dominates
family_pairs[Abundance_1 < Abundance_2 & Epsilon <0]$Dominates = -1 #Resource 1 Dominates
family_pairs[Abundance_1 < Abundance_2 & Epsilon >0]$Dominates = 1 #Resource 2 Dominates
family_pairs[Abundance_1 > Abundance_2 & Epsilon <0]$Dominates = 1 #Resource 2 Dominates
family_pairs$Epsilon = family_pairs$Dominates*abs(family_pairs$Epsilon) #correct for directionality of dominacne.
fwrite(family_pairs,file ='../Data/SA_Dominance_Family.csv')
