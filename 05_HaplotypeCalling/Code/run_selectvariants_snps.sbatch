#!/bin/bash
#Date : June 21 2017, adj June 23
#Purp : 1. make separate VCFs for SNPs only; then remove all regions ID'd by repeatmasker; then make separate VCFs for autosomes and z chromosome

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 1-00:00
#SBATCH -J selvar2
#SBATCH -o Logs/selvar2_%j.out
#SBATCH -e Logs/selvar2_%j.err

# 1 - SELECT SNPs ONLY

module load java/1.8.0_45-fasrc01

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T SelectVariants \
-R Data/BFHE336010v2.fasta \
-V Results/VCFs/E_cyan_nn.vcf \
-o Results/VCFs/E_cyan_snps.vcf \
-selectType SNP

# 2 - UNSELECT REPEAT/LOW COMPLEXITY REGIONS AND SPLIT AUTOSOMES/Z-CHROMOSOME

vcftools/0.1.14-fasrc01

# mask rm
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm --exclude-bed Code/Beds/rm.bed

# (nb bed files are expected to have header)
# can't use --exclude-bed and --bed together

# z-chrom
vcftools --vcf Results/VCFs/E_cyan_snps_rm.recode.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm_autos --bed Code/Beds/autos.bed

# z-chrom
vcftools --vcf Results/VCFs/E_cyan_snps_rm.recode.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm_zchrom --bed Code/Beds/zchrom.bed

# 3 - MAKE BED FILES FOR EACH FINAL SNP SET, TO BE USED IN ANGSD ANALYSES
# convert to bed, extract only col 1-3, copy to ANGSD dir, and give unique date.
module load gcc/6.3.0-fasrc01 bedops/2.4.26-fasrc01

i=autos
cut -f 1-3 Results/VCFs/E_cyan_snps_rm_${i}.bed > Results/VCFs/E_cyan_snps_rm_${i}.bed
DATE=`date +%Y%m%d`
cp -r Results/VCFs/E_cyan_snps_rm_${i}.bed /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/04_ANGSD/Code/E_cyan_snps_rm_${i}_${DATE}.bed

i=zchrom
cut -f 1-3 Results/VCFs/E_cyan_snps_rm_${i}.bed > Results/VCFs/E_cyan_snps_rm_${i}.bed
DATE=`date +%Y%m%d`
cp -r Results/VCFs/E_cyan_snps_rm_${i}.bed /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/04_ANGSD/Code/E_cyan_snps_rm_${i}_${DATE}.bed


