#!/bin/bash
#Date : Jul 31 2017
#Purp : 
#1 take partial vcfs made by GenotypeGVCF and join them into a single VCF.
#2 

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 50000
#SBATCH -t 0-15:00
#SBATCH -J cat-filter1
#SBATCH -o Logs/cat-filter1_%j.out
#SBATCH -e Logs/cat-filter1_%j.err

module load java/1.8.0_45-fasrc01
GROUP=Ento_Meli
# Use the identifier given to results of GenotypeGVCF. eg. "E_cyan_24"

java -cp /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar org.broadinstitute.gatk.tools.CatVariants \
-R Data/BFHE336010v2.fasta \
-V Results/VCFs/${GROUP}_1_partial.vcf \
-V Results/VCFs/${GROUP}_2_partial.vcf \
-V Results/VCFs/${GROUP}_3_partial.vcf \
-V Results/VCFs/${GROUP}_4_partial.vcf \
-V Results/VCFs/${GROUP}_5_partial.vcf \
-V Results/VCFs/${GROUP}_6_partial.vcf \
-V Results/VCFs/${GROUP}_7_partial.vcf \
-V Results/VCFs/${GROUP}_8_partial.vcf \
-V Results/VCFs/${GROUP}_9_partial.vcf \
-V Results/VCFs/${GROUP}_10_partial.vcf \
-out Results/VCFs/${GROUP}.vcf \
-assumeSorted

module load vcftools/0.1.14-fasrc01

vcftools --vcf Results/VCFs/${GROUP}.vcf --recode --recode-INFO-all --out Results/VCFs/${GROUP}_rm --exclude-bed Code/Beds/rm.bed

mv Results/VCFs/${GROUP}_rm.recode.vcf Results/VCFs/${GROUP}_rm.vcf  # re-name the vcftools output, if need be

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T SelectVariants \
-R Data/BFHE336010v2.fasta \
-V Results/VCFs/${GROUP}_rm.vcf \
-o Results/VCFs/${GROUP}_rm_snps_filt1.vcf \
-select "QD > 2.0" \
-select "DP < 700" \
-select "BaseQRankSum > -0.5" \
-select "BaseQRankSum < 0.5" \
-select "SOR < 3.0" \
-select "ReadPosRankSum > -4.0" \
-select "ReadPosRankSum < 4.0" \
-selectType SNP \
--restrictAllelesTo BIALLELIC \
--selectTypeToExclude INDEL


