#!/bin/bash
# J Burley 
# Date: July 5 2017
# Purpose: Run VCFtools --het per scaf, in a loop, then cat the results in one table

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 5:00:00
#SBATCH -J het_scaf
#SBATCH -o Logs/het_scaf_%j.out
#SBATCH -e Logs/het_scaf_%j.err

module load vcftools/0.1.14-fasrc01

GROUP=E_cyan_snps_rm_autos_filt

for SCAF in  scaffold_6 scaffold_31 scaffold_48 scaffold_64 scaffold_103 scaffold_149 scaffold_158 scaffold_159 scaffold_423 
do
vcftools --vcf Data/${GROUP}.vcf --chr $SCAF --out Results/VCFtools/Het_by_scaf/${GROUP}_${SCAF} --het
sed "s/$/\t$SCAF/g" Results/VCFtools/Het_by_scaf/${GROUP}_${SCAF}.het > Results/VCFtools/Het_by_scaf/${GROUP}_${SCAF}_new.het
done
