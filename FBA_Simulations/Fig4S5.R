library(data.table)
library(ggplot2)
library(ggpubr)
dat = fread('FBA_oxygen.csv')
dat$Carbon_Source = factor(dat$Carbon_Source,levels =dat$Carbon_Source)

p1 <-ggplot(dat,aes(x=Carbon_Source,y=Oxygen)) + 
  geom_bar(stat='identity',fill='Orange',col='Black',size=2) + 
  scale_y_continuous(limits=c(0,1),breaks=c(0,0.5,1),expand=c(0,0)) + 
  theme_classic() + labs(x='',y = expression(O[2]/C)) +
  theme(axis.text.x = element_text(angle=90,size=12),
        axis.text.y=element_text(size=12),axis.title.y=element_text(size=15))

ggsave('Fig4S5.pdf',ggarrange(p1),height=4,width=6)