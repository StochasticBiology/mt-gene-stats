# Load the igraph package
library(igraph)

# take a matrix of ideas: src, dest, edge label
# and construct a list with the graph object and labels ready for plotting
make.kg = function(ideas) {
  ideas = gsub(" ", "\n", ideas)
  nodes = unique(c(ideas[,1:2]))
  edges = matrix(nrow=nrow(ideas), ncol=2)
  for(i in 1:nrow(ideas)) {
    src = which(nodes == ideas[i,1])
    dest = which(nodes == ideas[i,2])
    edges[i,] = cbind(c(src, dest))
  }
  kg <- graph_from_edgelist(edges, directed = TRUE)
  edge_labels <- ideas[,3]
  rlist = list(kg = kg, nodes = nodes, edge_labels = edge_labels)
  return(rlist)
}

# plot a knowledge graph produced as above, with corresponding styling
plot.kg = function(kg) {
  my.layout = layout_with_sugiyama(kg$kg)
  
  return(plot(kg$kg, 
       layout = my.layout,
       vertex.label = kg$nodes,                  # Assign labels to nodes
       vertex.size = 15,                      # Set node size
       vertex.color = "#FFFFFF44",            # Set node color
       vertex.frame.color = "white",
       vertex.label.cex = 1.,
       edge.arrow.size = 0.5,                 # Set arrow size for directed edges
       edge.label = kg$edge_labels,              # Add edge labels
       edge.label.dist = 0.5,                 # Set distance from edge for labels
       edge.label.font = 1.2,                   # Set font style for edge labels
       edge.label.cex = 0.8,
       vertex.label.family = "sans",
       edge.label.family = "sans"))
}

## the actual ideas in the two knowledge graphs

# C -- causes
# S -- supports 
# F -- favours (target might be helpful)
# I -- includes

# first, the set of external factors that shape recombination/selection poise
# whitespace will be converted to newlines
ideas1 = matrix(c(
  # environment and gene retention
  "Dynamic environ ment", "Genes retained", "F",
  "Genes retained", "Mutational hazard", "C",
  "Genetic features", "Genes retained", "C",
  
  # environment and heterozygosity
  "Dynamic environ ment", "Heterozygous inheritance", "F",
  "Heterozygous inheritance", "Recombination", "F",
  
  # mutational hazard and repair
  "Mutational hazard", "Damage repair", "F",
  "Mutational hazard", "Damage removal", "F",
  "Damage removal", "(Multiscale) selection", "F",
  
  # animal-like or other germline
  "Germline structure", "Gene conversion", "S (other)",
  "Germline structure", "Animal-like bottleneck", "S (animal-like)",

  # recombination processes
  "Gene conversion", "Recombination", "S",
  "Damage repair", "Recombination", "S",

  # nuclear influences
  "Cell/sequence properties", "Mitonuclear interactions", "C",
  "Cell/sequence properties", "(Multiscale) selection", "C",
  "Mitonuclear interactions", "(Multiscale) selection", "F"
), ncol = 3, byrow = TRUE)

# now the consequences and facilitators of recombination and selection
ideas2 = matrix(c(
  # basic processes vs molecular processes
  "(Multiscale) selection", "Mitophagy/ turnover",  "C",
  "Recombination", "Segregation", "C",
  "Mitophagy/ turnover", "Segregation", "C",
  
  # recombination and structural variants
  "Recombination", "Structural variants", "C",
  "Structural variants", "Selfish elements", "I",
  "Structural variants", "Fragment ation and junk", "I",
  
  # links with mitochondrial dynamics
  "Recombination", "Fused networks (in space)", "F",
  "Mitophagy/ turnover", "Fragmented mitos", "F",
  "Structural variants", "Depleted mitos", "C",
  "Fragmented mitos", "Depleted mitos", "C",
  "Depleted mitos", "Social networks (in time)", "F",
  
  # tying up loose ends  
  "Mitophagy/ turnover", "Animal-like bottleneck", "S",
  "(Multiscale) selection", "Selfish elements", "   Controls",
  
  # h dynamics
  "(Multiscale) selection", "Heteroplasmy", "   Shifts",
  "Segregation", "Heteroplasmy", "Widens"
), ncol = 3, byrow = TRUE)

# make the knowledge graphs from these ideas
kg1 = make.kg(ideas1)
kg2 = make.kg(ideas2)

# plot the knowledge graphs
sf = 2
png("kg.png", width=1000*sf, height=550*sf, res=72*sf)
par(mfrow=c(1,2))
par(lheight = 0.7)
par(mar=c(0,0,0,0)+.1)
plot.kg(kg1)
plot.kg(kg2)
dev.off()

