#!/bin/bash
#Date : June 21 2017
#Purp : 1. make separate VCFs for SNPs and indels
# note that this is using the VCF with NEW NAMES

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0-10:00
#SBATCH -J selvar2
#SBATCH -o Logs/selvar2_%j.out
#SBATCH -e Logs/selvar2_%j.err

module load java/1.8.0_45-fasrc01

java -Xmx19g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T SelectVariants \
-R Data/BFHE336010v2.fasta \
-V Results/VCFs/E_cyan_nn.vcf \
-o Results/VCFs/E_cyan_indels.vcf \
-selectType INDEL


