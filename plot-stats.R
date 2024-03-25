library(ggplot2)
library(ggrepel)
library(ggpubr)

df = read.csv("mt-stats.csv")
ggplot(df, aes(x=mtdna.length, y=cds.count.ncbi)) + geom_point() + ylim(0,100)
df$exlabel = NA
s.labels = c("Homo sapiens","Arabidopsis thaliana","Plasmodium falciparum","Cucumis sativus","Reclinomonas americana","Fucus vesiculosus","Zostera marina","Saccharomyces cerevisiae","Chondrus crispus","Chlamydomonas reinhardtii","Chlorella vulgaris","Saccharomyces pastorianus","Emiliania huxleyi","Aspergillus niger","Triticum aestivum","Physcomitrium patens","Ginkgo biloba")
for(i in 1:length(s.labels)) {
  df$exlabel[df$species==s.labels[i]] = paste(substring(strsplit(s.labels[i], " ")[[1]],1,1), collapse="")
}

g.cds = ggplot(df, aes(x=log10(mtdna.length), y=log10(cds.count.ncbi))) + stat_binhex() + 
 # scale_fill_continuous(trans = "log1p", colours=c("#DDDDDD","#333333")) +
  scale_fill_gradientn(trans="log1p", colours=c("#EEEEEE","#5555FF"),name='Frequency',na.value=NA) +
 # geom_text_repel(aes(label=exlabel)) +
   geom_text(aes(label=exlabel)) +
  xlim(3.5,6.5)+ylim(0.3,log10(70)) + 
  theme_light()+ theme(legend.position="none")

g.rna = ggplot(df, aes(x=log10(mtdna.length), y=log10(trna.count.ncbi+rrna.count.ncbi))) + stat_binhex() + 
  # scale_fill_continuous(trans = "log1p", colours=c("#DDDDDD","#333333")) +
  scale_fill_gradientn(trans="log1p", colours=c("#EEEEEE","#5555FF"),name='Frequency',na.value=NA) +
  # geom_text_repel(aes(label=exlabel)) +
  geom_text(aes(label=exlabel)) +
  xlim(3.5,6.5)+ylim(0.3,log10(70)) + 
  theme_light() + theme(legend.position="none")

g.total = ggplot(df[df$sum!=0,], aes(x=mtdna.length, y=sum)) + stat_binhex() + 
  # scale_fill_continuous(trans = "log1p", colours=c("#DDDDDD","#333333")) +
  scale_fill_gradientn(trans="log1p", colours=c("#EEEEEE","#5555FF"),name='Frequency',na.value=NA) +
  # geom_text_repel(aes(label=exlabel)) +
  geom_text(aes(label=exlabel)) +
  scale_x_log10(limits=c(2e3,3e6)) + scale_y_log10(limits=c(3,100)) +
  labs(x="mtDNA length", y="mtDNA gene count") +
  theme_light()+ theme(legend.position="none")

g.labels = ggtexttable(matrix(sort(s.labels), ncol=1), theme=ttheme(base_size=12))
ggarrange(g.cds, g.total, g.labels, nrow=1)

sf = 2
png("fig-1-length-count.png", width=600*sf, height=400*sf, res=72*sf)
ggarrange(g.total, g.labels, nrow=1, widths=c(2,1) )
dev.off()

##### heatmap of profiles

mt.heatmap = function(mt.m, col.names = FALSE) {
  mt.m.red = unique(mt.m)   
  row.sums = as.vector(rowSums(mt.m.red))
  row.ordering = order(row.sums, decreasing=TRUE)
  mt.ordered = mt.m.red[row.ordering,]
  col.sums = as.vector(colSums(mt.ordered))
  col.ordering = order(col.sums, decreasing=TRUE)
  mt.ordered = mt.ordered[,col.ordering]
  return(pheatmap(mt.ordered, cluster_cols=FALSE, cluster_rows=FALSE, show_rownames = FALSE, 
                  show_colnames = col.names,
                  color = c("white", "#AAAAAA"), legend = FALSE, border_color = NA))
}


mt.bar = read.csv("mt-barcodes-manual.csv", header=T)
mt.m = mt.bar[,2:ncol(mt.bar)]               # all species
g.1 = as.ggplot(mt.heatmap(mt.m, col.names= TRUE))

cont.m = mt.m[1:nrow(unique(mt.m)),]
cont.1 = cont.2 = cont.m
for(i in 1:nrow(cont.m)) {
  cont.1[i,] = ifelse(runif(ncol(cont.m)) < 0.5, 0, 1)
  
  r = runif(1,min=1,max=ncol(cont.m))
  cont.2[i,1:r] = 1
  cont.2[i,r:ncol(mt.ordered)] = 0
}

g.2 = as.ggplot(mt.heatmap(cont.1)) + theme_void() + ggtitle("Expected if random")
g.3 = as.ggplot(mt.heatmap(cont.2)) + theme_void() + ggtitle("Expected if stereotypical")
g.0 = ggplot() + geom_blank() + theme_void()

ggarrange(g.1, ggarrange(g.0, g.2, g.3, nrow=3, ncol=1), nrow=1, widths=c(3,1))

sf = 2
png("fig-1-all.png", width=600*sf, height=700*sf, res=72*sf)
ggarrange( ggarrange(g.total, g.labels, nrow=1, widths=c(2,1) ),
      ggarrange(g.1, ggarrange(g.0, g.2, g.3, nrow=3, ncol=1), nrow=1, widths=c(3,1)), 
      labels = c("A", "B"), nrow=2)
dev.off()
