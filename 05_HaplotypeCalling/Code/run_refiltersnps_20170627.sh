#!/bin/bash
# J Burley 
# Date: June 27 2017
# Purpose: start with the filtered VCF file (June 27 2017), filter using a bed file with conservative estimates of autosomal scafs (413 scafs in total), and convert the new VCF to PLINK, and convert the VCF back to a bed file (for good measure)

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 30000
#SBATCH -t 8:00:00
#SBATCH -J refilt
#SBATCH -o Logs/refilt_%j.out
#SBATCH -e Logs/refilt_%j.err

#LINKS

#VARIABLES
#MODULES

module load vcftools

#COMMANDS

# 1 - trim vcf using a bed file generated in R. took 45 mins

vcftools --vcf Results/VCFs/E_cyan_snps_rm_autos_filt.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp --bed Code/Beds/autosome_scafs_2_1e5bp.bed
mv Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.recode.vcf Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.vcf

#### converting VCF to PLINK

#nFirst, have to change the formatting of the VCF file - the VCFtools converter can't understand scaffold names other than numbers

# So, use awk to output a new VCF with scaffold_0 replaced by 0, and soforth
awk '{gsub(/^scaffold_/,""); print}' Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.vcf > Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_noscaf.vcf

# Second, use vcftools to convert .vcf into a .ped and .map

FILE=E_cyan_snps_rm_autos_filt_1e5bp

vcftools --vcf Results/VCFs/${FILE}_noscaf.vcf --plink --out Results/PLINK/$FILE

#convert VCF to bed

module load gcc/6.3.0-fasrc01 bedops/2.4.26-fasrc01

vcf2bed < Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.vcf | cut -f 1-3 > Code/Beds/E_cyan_snps_rm_autos_filt_1e5bp.bed 

#NOTES
