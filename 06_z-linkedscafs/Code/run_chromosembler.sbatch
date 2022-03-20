#!/bin/bash
# J Burley 
# Date:June 28 2017
# Purpose: Satsuma aligns two fastas and performs synteny mapping. The goal is to match scafs from BFHE to chromosomes from Zebra finch. Most importantly, I need to investigate a possible assembly error for the BFHE - check whether the zebra finch z-chromosome matches to parts of the BFHE autosomal scafs 

#SBATCH -p general
#SBATCH -n 25
#SBATCH -N 1
#SBATCH --mem 70000
#SBATCH -t 168:00:00
#SBATCH -J satsuma
#SBATCH -o Logs/satsuma_%j.out
#SBATCH -e Logs/satsuma_%j.err

#LINKS

#VARIABLES

DIR=/n/sw/fasrcsw/apps/Core/satsuma/3.0-fasrc01/bin/

#MODULES

module load satsuma/3.0-fasrc01
# manual: http://satsuma.sourceforge.net/manual.html

#COMMANDS

$DIR/Chromosemble -n 24 -q Data/BFHE336010v2.fasta -t Data/GCF_000151805.1_Taeniopygia_guttata-3.2.4_genomic.fna -o Results/Satsuma2 -pseudochr -s

#NOTES
#DONT FORGET TO DELETE CONTENTS OF OUTPUT DIRECTORY BEFORE RUNNING!
