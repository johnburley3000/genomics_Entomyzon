#!/bin/bash
# Purpose: get FORMAT info from VCF

#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0:30:00
#SBATCH -J vcfFORMAT
#SBATCH -o Logs/vcfFORMAT_%j.out
#SBATCH -e Logs/vcfFORMAT_%j.err

#VCF=$1
VCF=E_cyan_snps_rm_autos_filt

module load vcftools

vcftools --vcf Results/VCFs/${VCF}.vcf --out Results/Info/${VCF}_GQ --extract-FORMAT-info GQ
#vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps --extract-FORMAT-info GL
#vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps --extract-FORMAT-info DP
#vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps --extract-FORMAT-info PL

