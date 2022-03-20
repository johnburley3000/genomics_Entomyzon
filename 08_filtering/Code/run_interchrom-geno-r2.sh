#!/bin/bash
# J Burley 
# Date: June 17 2017
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 30000
#SBATCH -t 12:00:00
#SBATCH -J VCFt_interchrom-genoR2
#SBATCH -o Logs/VCFt_ic-genoR2_%j.out
#SBATCH -e Logs/VCFt_ic-genoR2_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_24.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/26_Mlun_76541.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/25_Malb_76665.* Data/.

#VARIABLES
GROUP=E_cyan_24
SCAFS=scaf10
BEDFILE=Code/10scaf.bed

#MODULES
module load vcftools/0.1.14-fasrc01

#COMMANDS
vcftools --vcf Data/${GROUP}.vcf --bed Code/10scaf.bed --out Results/VCFtools/${GROUP}_${SCAFS} --interchrom-geno-r2

#NOTES
# June 17 - ran GROUP=E_cyan_24 SCAFS=allscaf
