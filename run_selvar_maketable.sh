#!/bin/bash
#SBATCH -p general
#SBATCH --mem 30000
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 02:00:00
#SBATCH -J selvar
#SBATCH -e selvar_%j.err
#SBATCH -o selvar_%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu
module load java/1.8.0_45-fasrc01

SAMPLE=$1

java -Xmx30g -jar /n/regal/edwards_lab/jburley/GATK/GenomeAnalysisTK.jar \
-T SelectVariants \
-R ../BFHE_WA336010.fasta \
--variant ${SAMPLE}.vcf \
-o selvar_inlistPSMCFeb7/${SAMPLE}_inlistpsmcfeb7.vcf \
-L inlistPSMCFeb7_nohead.bed

java -Xmx30g -jar /n/regal/edwards_lab/jburley/GATK/GenomeAnalysisTK.jar \
-R ../BFHE_WA336010.fasta \
-T VariantsToTable \
-V selvar_inlistPSMCFeb7/${SAMPLE}_inlistpsmcfeb7.vcf \
-F CHROM -F POS -F ID -F QUAL -F AC -F AF -F AN -F DP -GF GT -GF AD -GF GQ -GF PL  \
-o selvar_inlistPSMCFeb7/summary${SAMPLE}_inlistpsmcfeb7_big.table \
--allowMissingData
	
java -Xmx30g -jar /n/regal/edwards_lab/jburley/GATK/GenomeAnalysisTK.jar \
-R ../BFHE_WA336010.fasta \
-T VariantsToTable \
-V selvar_inlistPSMCFeb7/${SAMPLE}_inlistpsmcfeb7.vcf \
-F CHROM -F AF -F DP \
-o selvar_inlistPSMCFeb7/summary${SAMPLE}_inlistpsmcfeb7_small.table \
--allowMissingData

