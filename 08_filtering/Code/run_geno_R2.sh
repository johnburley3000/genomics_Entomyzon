#!/bin/bash
# J Burley 
# Date: June 17 2017
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 24:00:00
#SBATCH -J VCFt_genoR2
#SBATCH -o Logs/VCFt_genoR2_%j.out
#SBATCH -e Logs/VCFt_genoR2_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_24.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/26_Mlun_76541.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/25_Malb_76665.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_snps_rm_autos.recode.vcf Data/.

module load vcftools/0.1.14-fasrc01

for n in {1..3}
do

#VARIABLES
GROUP=E_cyan_snps_rm_autos.recode
BEDFILE=window${n}

#COMMANDS
vcftools --vcf Data/${GROUP}.vcf --out Results/VCFtools/E_cyan_rm_autos_scaf1_win${n} --geno-r2 --bed Code/LD_${BEDFILE}.bed

done

#NOTES
# June 17 - ran GROUP=E_cyan_24 SCAFS=allscaf
# timed out with 4 hrs 30gb ram

