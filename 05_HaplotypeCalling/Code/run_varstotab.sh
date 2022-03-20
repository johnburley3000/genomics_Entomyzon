#!/bin/bash
#Date : June 27 2017
#Purp : make a table with all of the FORMAT values for each sample.

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0-01:00
#SBATCH -J var2tab
#SBATCH -o Logs/var2tab_%j.out
#SBATCH -e Logs/var2tab_%j.err

#VCF=$1
VCF=E_cyan_snps_rm_autos_filt

module load java/1.8.0_45-fasrc01

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-R Data/BFHE336010v2.fasta \
-T VariantsToTable \
-V Results/VCFs/${VCF}.vcf \
-F CHROM -F POS \
-GF GT -GF AD -GF GQ \
--allowMissingData \
-o Results/Info/${VCF}.format


