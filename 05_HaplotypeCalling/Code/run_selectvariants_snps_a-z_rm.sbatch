#!/bin/bash
#Date : June 21 2017
#Purp : 1. make separate VCFs using SNPs only with no repeat regions, and A) autosomes, B) Z-chrom
# easiest way to do this is with VCFtools, but if I later decide to do hard filtering with GATK, apply that before re-running the VCFtools commands

### NOTE! This script was integrated into run_selectvariants_snps.sbatch 

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 0-08:00
#SBATCH -J vcf_sel
#SBATCH -o Logs/vcf_sel_%j.out
#SBATCH -e Logs/vcf_sel_%j.err

module load vcftools/0.1.14-fasrc01

# mask rm
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm --exclude-bed Code/Beds/rm.bed

# (nb bed files are expected to have header)
# can't use --exclude-bed and --bed together

# z-chrom
vcftools --vcf Results/VCFs/E_cyan_snps_rm.recode.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm_autos --bed Code/Beds/autos.bed

# z-chrom
vcftools --vcf Results/VCFs/E_cyan_snps_rm.recode.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm_zchrom --bed Code/Beds/zchrom.bed
