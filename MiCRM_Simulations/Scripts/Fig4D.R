rm(list=ls())
library(data.table)
library(ggplot2)
library(ggpubr)
library(gridExtra)
library(Metrics)

dominance = fread('../Data/SA_Dominance_Family.csv')
error_table = fread('../Data/Error_table.csv')
dominance = dominance[S==200 & Family=='F1' & q !=0.9]
error_table = error_table[exp_id %in% dominance$exp_id,]
#Remove runs that did not converge in at least one relevant environment
dominance = dominance[exp_id %in% error_table[SA<1e-5,]$exp_id]
mean_dominance = dominance[,mean(Epsilon),by=c('q','q2')]
n = dominance[,length(Epsilon),by=c('q','q2')]
p1 <- ggplot(mean_dominance,aes(x=q,y=q2,width=0.1,fill= V1)) + geom_tile() + 
  scale_fill_gradient2(low="mediumpurple1",mid='white', high="tan1",midpoint=0,limits=c(-0.1,0.1),breaks=c(-0.1,0,0.1))+ theme_pubr() +
  labs(x = expression(q[S]),y= expression(q[a]),fill = expression(mean(delta)))  +
  scale_x_continuous(expand=c(0,0)) + scale_y_continuous(expand=c(0,0)) +theme(legend.position = 'right')
ggsave('../Plots/Fig4D.png',height=5,width=6)