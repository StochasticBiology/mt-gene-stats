#include <stdio.h>
#include <stdlib.h>

#define RND drand48()

#define NPOP 100      // population size
#define NEXPT 10000   // number of samples
#define MAXT 100     // number of generations

#define VERBOSE 0

int main(void)
{
  // labels denoting which compartment the gene is stored in (0 MT, 1 NU)
  int compartment[NPOP], new_compartment[NPOP];
  // fitness across population
  double fitness[NPOP], new_fitness[NPOP];
  double cum_fitness[NPOP];
  double mean_compartment;
  FILE *fp;
  int expt, t;
  int i, j;
  double r;
  double fitmutated;   // fitness cost for a mutation
  double MU;        // MT mutation rate
  double transfer;  // proportion of experiments maintaining >= 1 NU-encoded individual
  int some_nuclear;
  double fitvals[] = {0, 0.9, 1};
  int fitindex;
  
  // initialise output file
  fp = fopen("output.csv", "w");
  fprintf(fp, "mu,fitmutated,transfer,mean.transferred\n");

  printf("Simulating...\n\nmu,fitness on mutation,transferred proportion,mean transferred\n");
  // loop through mutation rates
  for(MU = 1e-3; MU <= 1; MU *= 2)
    {
      // loop over fitness loss for mutated gene
      for(fitindex = 0; fitindex < 3; fitindex++)
	{
	  fitmutated = fitvals[fitindex];
	  // initialise counter for these parameters
	  transfer = 0;
	  mean_compartment = 0;
	  // loop over samples
	  for(expt = 0; expt < NEXPT; expt++)
	    {
	      // initialise population with one NU-encoding individual
	      // all fitnesses are 1
	      for(i = 0; i < NPOP; i++)
		{
		  compartment[i] = (i==0);
		  fitness[i] = 1;
		}

	      // loop through generations
	      for(t = 0; t < MAXT; t++)
		{
		  // apply random mutation (loss of fitness) to any MT-encoding individuals and build fitness profile
		  for(i = 0; i < NPOP; i++)
		    {
		      if(compartment[i] == 0 && RND < MU)
			fitness[i] = fitmutated;
		      if(i == 0) cum_fitness[i] = fitness[i];
		      else cum_fitness[i] = cum_fitness[i-1]+fitness[i];
		    }
		  for(i = 0; i < NPOP; i++)
		    {
		      cum_fitness[i] = cum_fitness[i]/cum_fitness[NPOP-1];
		      if(VERBOSE)  printf("%i %i %e %e\n", i, compartment[i], fitness[i], cum_fitness[i]);
		    }
		  if(VERBOSE) printf("\n");
		  
		  // select individuals for next generation based on fitness
		  for(i = 0; i < NPOP; i++)
		    {
		      // choose an individual from roulette wheel
		      r = RND;
		      for(j = 0; cum_fitness[j] < r; j++);
		      if(VERBOSE) printf("Chose %i\n", j);
		      new_compartment[i] = compartment[j];
		      new_fitness[i] = fitness[j];
		    }
		  // update population and compartment statistic
		  for(i = 0; i < NPOP; i++)
		    {
		      compartment[i] = new_compartment[i];
		      fitness[i] = new_fitness[i];
		    }
		}
	      // record mean nuclear-encoding proportion, and
	      // proportion of simulations that have some nuclear-encoding individuals
	      some_nuclear = 0;
	      for(i = 0; i < NPOP; i++)
		{
		  mean_compartment += compartment[i];
		  if(compartment[i] == 1)
		    {
		      some_nuclear = 1;
		    }
		}
	      // if we have retained any NU encoding, record this
	      if(some_nuclear == 1)
		transfer++;
	    }
	  // output info
	  fprintf(fp, "%e,%e,%e,%e\n", MU, fitmutated, transfer/NEXPT, mean_compartment/(NEXPT*NPOP));
	  printf("%e,%e,%e,%e\n", MU, fitmutated, transfer/NEXPT, mean_compartment/(NEXPT*NPOP));
	}    
    }
  fclose(fp);

  return 0;
}
      
