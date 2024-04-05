library(ggplot2)
df = read.csv("output.csv")

png("gene-transfer.png", width=400*sf, height=300*sf, res=72*sf)
ggplot(df, aes(x=mu,y=mean.transferred,color=factor(fitmutated))) + geom_line() + 
  scale_x_continuous(trans="log10") +
  labs(x = "Mutation rate per genome\nper generation", y = "Proportion of population with nuclear encoding\nafter 100 generations", color="Fitness upon\nmutation")
dev.off()
