# mt-gene-stats

Summary statistics of mtDNA gene loss
-----
`mt-stats.csv` contains output from the pipeline here https://github.com/StochasticBiology/odna-loss on protein-coding mtDNA gene complements across eukaryotes.

`plot-stats.R` plots these data along with examples from different imaginary evolutionary regimes.

Gene transfer model
-----
Quick simulation demonstration of nuclear transfer stabilised by mutational robustness

`gene-transfer.c` simulates a population of N organisms evolving through non-overlapping, asexual generations. A single gene determines fitness. It can be encoded in the mitochondrion or in the nucleus. If in the mitochondrion, it experiences a loss of function mutation with probability mu per generation, which leads to a complete loss of fitness (the simulation can also support progressive functional loss over mutational events, with the same qualitative behaviour). If in the nucleus, it never mutates. The simulation begins with a single individual with nuclear encoding and N-1 with organelle encoding. As mu increases, the proportion of simulations that retain nuclear-encoding individuals increases above the neutral case towards unity. There is no contribution of mutation rate to the fitness function: it suffices that a lineage prone to mutation is more likely to die out.

`plot-sim.R` plots the results:

![image](https://github.com/StochasticBiology/mitonuclear-balance/assets/50171196/8ea1582c-a889-4335-999c-faf1a26984f9)

here, mu is mutation rate and transfer is the proportion of samples that retain at least one nuclear-encoding individual. The colour gives the fitness effect of a mutation: red is none (so the fitness of mutated genes is the same as wildtype; the neutral case); blue is total loss of function (zero fitness mutants); green is partial (it takes two mutations to reduce fitness to zero).
