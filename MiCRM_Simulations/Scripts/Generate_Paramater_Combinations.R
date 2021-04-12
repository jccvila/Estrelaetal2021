rm(list=ls())
library(data.table)

#Fig 1
q = c(0.9)
q2 = c(0.9)
seed = seq(1,100)
S = c(200)
mdf=expand.grid(q,q2,seed,S)
colnames(mdf) = c('q','q2','seed','S')

#Fig S1
q = c(0.9)
q2 = c(0.9)
seed =seq(1,100)
generalists = c(FALSE)
S = c(100,150,200)
mdf2=expand.grid(q,q2,seed,S)
colnames(mdf2) = c('q','q2','seed','S')

#Heatmap gradient 1
q = seq(0.05,0.95,0.1)
q2 = seq(0.05,0.95,0.1)
seed = seq(1,100)
generalists = c(FALSE)
S = c(200)
mdf3=expand.grid(q,q2,seed,S)
colnames(mdf3) = c('q','q2','seed','S')
fdf = rbind(mdf,mdf2,mdf3)
fdf = fdf[!duplicated(fdf),]
fdf$exp_id = seq(1:nrow(fdf))

fwrite(fdf,'Experiment_list.csv')
