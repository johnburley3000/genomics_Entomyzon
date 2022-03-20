#!/bin/bash
# J Burley 
# Date: Aug 17 2017
# Purpose: get cov for each sample from the Meli-Ento VCF used in treemix

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 6000
#SBATCH -t 5:00:00
#SBATCH -J VCFt_depth
#SBATCH -o Logs/VCFt_depth_%j.out
#SBATCH -e Logs/VCFt_depth_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/Ento_Meli_rm_snps_filt1_autos_1e5* Data/.

#VARIABLES
GROUP=Ento_Meli_rm_snps_filt1_autos_1e5
#SCAFS=allscaf
#BEDFILE=Code/1000scaf_100bp_off_either_end.bed

#MODULES
module load vcftools/0.1.14-fasrc01

#COMMANDS
vcftools --vcf Data/${GROUP}.vcf --out Results/VCFtools/${GROUP} --depth

#NOTES
# June 17 - ran GROUP=E_cyan_24 SCAFS=allscaf
