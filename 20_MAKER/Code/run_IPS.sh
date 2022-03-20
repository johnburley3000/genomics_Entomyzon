#!/bin/bash
#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 10000
#SBATCH -t 7-00:00:00
#SBATCH -J InterProScan
#SBATCH -o Logs/InterProScan_%j.out
#SBATCH -e Logs/InterProScan_%j.err

# July 5 2018

module load interproscan/5.30.69.0-fasrc01

module load centos6/0.0.1-fasrc01 java/1.8.0_45-fasrc01

module load python/3.6.3-fasrc01 # loading this because it seemed to spit up error about not being able to find python 3

IN=BFHE336010v2.maker.output/BFHE336010v2.all.maker.proteins.fasta

interproscan.sh -i $IN -t p -pa --goterms --iprlookup --output-dir BFHE336010v2.maker.output

# -t	sequence type: p 
# -pa Optional, switch on lookup of corresponding Pathway annotation (IMPLIES -iprlookup option)
# it will make temp files in /temp/

# attempt 1 in interactive was running, although it by-passed errors.
# attempt 2 using this script failed - unsure why. it seemed unable to connect to the internet to do searches, so it proceeded to search locally, but I didn't specify any local sequences to search, so not sure what it was looking for...
# attempt 3. remove the parrellization of this script (change -n to 1 in SLURM and remove -cpu 1 in command line) and increase mem on single node
# attempt 3 ran out of time with 42 hr limit
# attempt 4. set time to 7 days.
