#!/bin/bash
# J Burley 
# Date:June 28 2017
# Purpose: Satsuma aligns two fastas and performs synteny mapping. The goal is to match scafs from BFHE to chromosomes from Zebra finch. Most importantly, I need to investigate a possible assembly error for the BFHE - check whether the zebra finch z-chromosome matches to parts of the BFHE autosomal scafs 

#SBATCH -p general
#SBATCH -n 25
#SBATCH -N 1
#SBATCH --mem 70000
#SBATCH -t 168:00:00
#SBATCH -J s_chicken
#SBATCH -o Logs/s_chicken_%j.out
#SBATCH -e Logs/s_chicken_%j.err

#LINKS

#VARIABLES

DIR=/n/sw/fasrcsw/apps/Core/satsuma/3.0-fasrc01/bin/

GENOME=Data/GCF_000002315.4_Gallus_gallus-5.0_genomic.fna

#MODULES

module load satsuma/3.0-fasrc01
# manual: http://satsuma.sourceforge.net/manual.html

#COMMANDS

$DIR/Satsuma -n 24 -q Data/BFHE336010v2.fasta -t $GENOME -o Results/Satsuma_chicken 

# for 2nd run (July 2), I set -l 100000 (min alignment length. I think this will restrict the analysis to large scaffolds, and possibly speed things up..)
#NOTES
#DONT FORGET TO DELETE CONTENTS OF OUTPUT DIRECTORY BEFORE RUNNING!
