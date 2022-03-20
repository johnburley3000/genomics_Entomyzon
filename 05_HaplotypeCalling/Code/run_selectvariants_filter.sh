#!/bin/bash

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 30000
#SBATCH -t 0-6:00
#SBATCH -J selvar_f
#SBATCH -o Logs/selvar_f_%j.out
#SBATCH -e Logs/selvar_f_%j.err

module load java/1.8.0_45-fasrc01

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T SelectVariants \
-R Data/BFHE336010v2.fasta \
-V Results/VCFs/E_cyan_snps_rm_autos.recode.vcf \
-o Results/VCFs/E_cyan_snps_rm_autos_filt.vcf \
-select "QD > 2.0" \
-select "DP < 700" \
-select "BaseQRankSum > -0.5" \
-select "BaseQRankSum < 0.5" \
-select "SOR < 3.0" \
-select "ReadPosRankSum > -4.0" \
-select "ReadPosRankSum < 4.0" 
