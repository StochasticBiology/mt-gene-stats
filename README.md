# mt-gene-stats

Code and manuscript for a review article 

*Evolution and maintenance of mtDNA gene content across eukaryotes*, Shibani Veeraragavan (1), Maria Johansen (1), Iain G Johnston (1,2,*)

1. Department of Mathematics, University of Bergen, Bergen, Norway
2. Computational Biology Unit, University of Bergen, Bergen, Norway
* correspondence to iain.johnston@uib.no

Link here https://portlandpress.com/biochemj/article/481/15/1015/234775/Evolution-and-maintenance-of-mtDNA-gene-content

Note: we are trialling a form of crowdsourced review for this article. Please comment here https://docs.google.com/document/d/1Z9wrvBV2hOSIFauIQ-dK_6lR33uOKVooR44jzotsKAY/edit?usp=sharing if you'd like to provide feedback, or if there is aligned information you would like to share.

Summary statistics of mtDNA gene loss
-----
`mt-stats.csv` contains output from the pipeline here https://github.com/StochasticBiology/odna-loss on protein-coding mtDNA gene complements across eukaryotes.

`plot-stats.R` plots these data along with examples from different imaginary evolutionary regimes.

Gene transfer model
-----
Quick simulation demonstration of nuclear transfer stabilised by mutational robustness

`gene-transfer.c` simulates a population of N organisms evolving through non-overlapping, asexual generations. A single gene determines fitness. It can be encoded in the mitochondrion or in the nucleus. If in the mitochondrion, it experiences a loss of function mutation with probability mu per generation, which leads to a complete loss of fitness (the simulation can also support progressive functional loss over mutational events, with the same qualitative behaviour). If in the nucleus, it never mutates. The simulation begins with a single individual with nuclear encoding and N-1 with organelle encoding. As mu increases, the proportion of simulations that retain nuclear-encoding individuals increases above the neutral case towards unity. There is no contribution of mutation rate to the fitness function: it suffices that a lineage prone to mutation is more likely to die out.

`plot-sim.R` plots the results.

Knowledge graphs
-----
`knowledge-graphs.R` is a simple script to take a set of ideas and labelled links between them and plot them in a knowledge-graph style format.
