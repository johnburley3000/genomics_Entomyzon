#!/bin/bash
# J Burley 
# Date: June 17 2017
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 6:00:00
#SBATCH -J VCFt_genoR2
#SBATCH -o Logs/VCFt_genoR2_%j.out
#SBATCH -e Logs/VCFt_genoR2_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_snps_rm_autos.recode.vcf Data/.

module load vcftools/0.1.14-fasrc01

for i in 330 331 336
do
vcftools --vcf Data/E_cyan_snps_rm_autos.recode.vcf --out Results/VCFtools/E_cyan_rm_autos_scaf${i} --geno-r2 --chr scaffold_${i}
done
