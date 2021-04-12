rm(list=ls())
library(data.table)
library(ggplot2)
library(ggpubr)
library(gridExtra)
library(Metrics)
library(operators)

family_pairs = fread('../Data/Family_Pairs.csv')
esv_pairs = fread('../Data/ESV_Pairs.csv')
error_table = fread('../Data/Error_table.csv')

family = family_pairs[q == 0.9 & q2 == 0.9 & S==200]
esv = esv_pairs[q == 0.9 & q2 == 0.9 & S==200]
#Remove runs that did not converge in at least one relevant environment
error_table = error_table[exp_id %in% esv$exp_id,]
error_table = error_table[SS>1e-5 | SA >1e-5 | AA >1e-5]
family =family[exp_id %!in% error_table$exp_id]
esv =esv[exp_id %!in% error_table$exp_id]
#Remove run which()
p1 <- ggplot(family,aes(x=Predicted_Abundance,y=Abundance,col=Treatment)) +
  geom_point(alpha=0.9,size=2) + theme_minimal() +  
  labs(x='Predicted abundance', y='Observed abundance',col='') +
  scale_colour_manual(values = c( 'tan1', 'gray', 'mediumpurple1'))+
  scale_fill_manual(values = c( 'tan1', 'gray', 'mediumpurple1'))  +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        strip.text.x = element_text(size=14),
        strip.text.y = element_text(size=14),
        axis.title.y =element_text(size=16),
        axis.title.x = element_text(size = 16),
        panel.border = element_rect(color = "gray", fill = NA, size = 1),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.text=element_text(size=14),
        legend.title=element_text(size=14)) + geom_abline(linetype='dashed') +
  scale_y_continuous(limits = c(0,1)) + 
  scale_x_continuous(limits=c(0,1)) + ggtitle('Family Level')
p2 <- ggplot(esv,aes(x=Predicted_Abundance,y=Abundance,col=Treatment)) +
  geom_point(alpha=0.9,size=2) + theme_minimal() +  
  labs(x='Predicted abundance', y='Observed abundance',col='') +
  scale_colour_manual(values = c( 'tan1', 'gray', 'mediumpurple1'))+
  scale_fill_manual(values = c( 'tan1', 'gray', 'mediumpurple1'))  +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        strip.text.x = element_text(size=14),
        strip.text.y = element_text(size=14),
        axis.title.y =element_text(size=16),
        axis.title.x = element_text(size = 16),
        panel.border = element_rect(color = "gray", fill = NA, size = 1),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.text=element_text(size=14),
        legend.title=element_text(size=14)) + geom_abline(linetype='dashed') +
  scale_y_continuous(limits = c(0,1)) + 
  scale_x_continuous(limits=c(0,1)) + ggtitle('Species Level')

ggsave('../Plots/Fig4B.png',ggarrange(p2,p1,common.legend=TRUE),height=4,width=8)
