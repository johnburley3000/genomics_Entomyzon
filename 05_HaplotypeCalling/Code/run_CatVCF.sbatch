#!/bin/bash
#Date : June 16 2017
#Purp : take partial vcfs made by GenotypeGVCF and join them into a single VCF.

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0-05:00
#SBATCH -J catvcf
#SBATCH -o Logs/catvcf_%j.out
#SBATCH -e Logs/catvcf_%j.err

module load java/1.8.0_45-fasrc01

GROUP=$1
# Use the identifier given to results of GenotypeGVCF. eg. "E_cyan_24"

java -cp -Xmx10g /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar org.broadinstitute.gatk.tools.CatVariants \
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
# note - not sure if the -cp and -xmx options will work together..
