#!/bin/bash
# J Burley 
# Date: June 17 2017
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 12:00:00
#SBATCH -J VCFt_depth
#SBATCH -o Logs/VCFt_depth_%j.out
#SBATCH -e Logs/VCFt_depth_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_24.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/26_Mlun_76541.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/25_Malb_76665.* Data/.

#VARIABLES
GROUP=E_cyan_24
SCAFS=allscaf
#BEDFILE=Code/1000scaf_100bp_off_either_end.bed

#MODULES
module load vcftools/0.1.14-fasrc01

#COMMANDS
vcftools --vcf Data/${GROUP}.vcf --out Results/VCFtools/${GROUP}_${SCAFS} --depth

#NOTES
# June 17 - ran GROUP=E_cyan_24 SCAFS=allscaf
