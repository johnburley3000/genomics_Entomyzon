#!/bin/bash
# J Burley 
# Date: June 17 2017
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 100000
#SBATCH -t 48:00:00
#SBATCH -J VCFt_LROH
#SBATCH -o Logs/VCFt_LROH_%j.out
#SBATCH -e Logs/VCFt_LROH_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_24.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/26_Mlun_76541.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/25_Malb_76665.* Data/.

#VARIABLES
GROUP=E_cyan_24
SCAFS=scaf_0
#BEDFILE=Code/1000scaf_100bp_off_either_end.bed

#MODULES
module load vcftools/0.1.14-fasrc01

#COMMANDS
vcftools --vcf Data/${GROUP}.vcf --out Results/VCFtools/${GROUP}_${SCAFS} --LROH --chr scaffold_0

#This option will identify and output Long Runs of Homozygosity. The output file has the suffix ".LROH". This function is experimental, and will use a lot of memory if applied to large datasets.

#NOTES
# June 17 - ran GROUP=E_cyan_24 SCAFS=allscaf
