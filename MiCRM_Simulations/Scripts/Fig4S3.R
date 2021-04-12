rm(list=ls())
library(data.table)
library(ggplot2)
library(ggpubr)
library(gridExtra)
library(Metrics)
library(operators)

family = fread('../Data/Family_Pairs.csv')
family = family[q!=0.9]
error_table = fread('../Data/Error_table.csv')
error_table = error_table[exp_id %in% family$exp_id,]
error_table = error_table[SS>1e-5 | SA >1e-5 | AA >1e-5]
family = family[exp_id %!in% error_table$exp_id]

cor_epsilon = family[,cor(Abundance,Predicted_Abundance),by=c('q','q2','Treatment')]
rmse_epsilon = family[,rmse(Abundance,Predicted_Abundance),by=c('q','q2','Treatment')]
rmse_epsilon = rmse_epsilon[q==q2]
p1 <- ggplot(rmse_epsilon,aes(x=q,y=V1,col=Treatment)) + geom_point(size=3,shape=1, stroke=2) + theme_classic()+  
  scale_colour_manual(values=c('Blue','Grey','Orange')) +
  labs(x = 'q',y = 'RMSE') +theme(axis.text.x = element_text(size = 10),
                                  axis.title.y=element_text(size=12))
ggsave('../Plots/Fig4S3.png',p1,height=3,width=6)
