library(data.table)
library(ggplot2)
df = fread('../Data/C_matrices.csv')
df$Treatment = factor(df$Treatment,
                      levels=c('Unspecialised','Symmetric','Acid','Sugar'),
                      labels=c(expression(atop('Unspecialised',paste(q[A]==0,' and ',q[S]==0))),
                               expression(atop('Symmetric Specialisation',paste(q[A]==0.9,' and ',q[S]==0.9))),
                               expression(atop('Specialisation on A',paste(q[A]==0.9,' and ',q[S]==0))),
                               expression(atop('Specialisation on S',paste(q[A]==0.0,' and ',q[S]==0.9)))
                               ))
df$ESV = factor(df$ESV,levels=unique(df$ESV))
df$Resource = factor(df$Resource,levels=unique(df$Resource))

p1 <- ggplot(df) + geom_tile(aes(x=Resource,y=ESV,fill=c_ia)) +
  scale_fill_gradient(low="lightyellow",high="Red",) + 
  facet_wrap(~Treatment,ncol=2,nrow=2, labeller = label_parsed) + labs(x = 'Resources',y = 'Species',fill = expression(c[i*alpha]))+
  theme_minimal()+  theme(axis.text = element_blank(),
                          strip.text = element_text(size=15),
                          axis.title = element_text(size=20),
                          legend.title= element_text(size=20)) 
ggsave('../Plots/Fig4S4.png',p1,height=8,width=8)