library(ggplot2)
library(ggrepel)

df = read.csv("mt-stats.csv")
ggplot(df, aes(x=mtdna.length, y=cds.count.ncbi)) + geom_point() + ylim(0,100)
df$exlabel = NA
df$exlabel[df$species == "Homo sapiens"] = "HS"
df$exlabel[df$species == "Arabidopsis thaliana"] = "AT"
df$exlabel[df$species == "Plasmodium falciparum"] = "PF"
df$exlabel[df$species == "Cucumis sativus"] = "CS"
df$exlabel[df$species == "Reclinomonas americana"] = "RA"
df$exlabel[df$species == "Fucus vesiculosus"] = "FV"
df$exlabel[df$species == "Zostera marina"] = "ZM"
df$exlabel[df$species == "Saccharomyces cerevisiae"] = "SC"
df$exlabel[df$species == "Chondrus crispus"] = "CC"
df$exlabel[df$species == "Chlamydomonas reinhardtii"] = "CR"
df$exlabel[df$species == "Chlorella vulgaris"] = "CV"
df$exlabel[df$species == "Saccharomyces pastorianus"] = "SP"
df$exlabel[df$species == "Emiliania huxleyi"] = "EH"
df$exlabel[df$species == "Aspergillus niger"] = "AN"
df$exlabel[df$species == "Triticum aestivum"] = "TA"
df$exlabel[df$species == "Physcomitrium patens"] = "PP"
df$exlabel[df$species == "Ginkgo biloba"] = "GB"

ggplot(df, aes(x=log10(mtdna.length), y=log10(cds.count.ncbi))) + stat_binhex() + 
 # scale_fill_continuous(trans = "log1p", colours=c("#DDDDDD","#333333")) +
  scale_fill_gradientn(trans="log1p", colours=c("#EEEEEE","#5555FF"),name='Frequency',na.value=NA) +
 # geom_text_repel(aes(label=exlabel)) +
   geom_text(aes(label=exlabel)) +
  xlim(3.5,6.5)+ylim(0.3,log10(70)) + 
  theme_light()

ggplot(df[df$cds.count.ncbi < 70,], aes(x=log10(mtdna.length), y=cds.count.ncbi/mtdna.length)) + stat_binhex() + 
  # scale_fill_continuous(trans = "log1p", colours=c("#DDDDDD","#333333")) +
  scale_fill_gradientn(trans="log1p", colours=c("#EEEEEE","#5555FF"),name='Frequency',na.value=NA) +
  # geom_text_repel(aes(label=exlabel)) +
  geom_text(aes(label=exlabel)) +
 # xlim(3.5,6.5)+ylim(0.3,log10(70)) + 
  theme_light()

df[df$cds.count.ncbi>exp(1.5) & df$cds.count.ncbi<exp(2) & df$mtdna.length < exp(10.5),]
df[df$cds.count.ncbi>exp(3.5) & df$cds.count.ncbi<exp(4) & df$mtdna.length > exp(11) & df$mtdna.length < exp(11.5),]
df[df$cds.count.ncbi>exp(2.5) & df$cds.count.ncbi<exp(2.8) & df$mtdna.length > exp(11) & df$mtdna.length < exp(11.5),]
df[df$cds.count.ncbi>exp(2.6) & df$cds.count.ncbi<exp(3.) & df$mtdna.length > exp(10) & df$mtdna.length < exp(10.5),]
df[df$cds.count.ncbi>exp(3.5) & df$cds.count.ncbi<exp(3.8) & df$mtdna.length > exp(11.5) & df$mtdna.length < exp(13),]
df[df$cds.count.ncbi>exp(4.3),]
