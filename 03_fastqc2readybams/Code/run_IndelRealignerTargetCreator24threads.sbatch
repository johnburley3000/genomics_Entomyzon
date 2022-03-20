#!/bin/bash

#SBATCH -p general
#SBATCH -n 26
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 7-00:00
#SBATCH -o ./Logs/indelcreator_%j.out
#SBATCH -e ./Logs/indelcreator_%j.err

module load java/1.8.0_45-fasrc01
GATKPATH=/n/edwards_lab/jburley/programs

java -Xmx16g -jar $GATKPATH/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-nt 26 \
-R Data/BFHE336010v2.fasta \
-I Results/BFHE3_220.dedup.sorted.bam \
-I Results/BFHE4_220.dedup.sorted.bam \
-I Results/BFHE5_220.dedup.sorted.bam \
-I Results/WTHE1_220.dedup.sorted.bam \
-I Results/10_PNG_56165.dedup.sorted.bam \
-I Results/11_NSW_76718.dedup.sorted.bam \
-I Results/12_NSW_76649.dedup.sorted.bam \
-I Results/13_NSW_76521.dedup.sorted.bam \
-I Results/14_NSW_76599.dedup.sorted.bam \
-I Results/15_NT_22778.dedup.sorted.bam \
-I Results/16_NT_22941.dedup.sorted.bam \
-I Results/17_NT_23053.dedup.sorted.bam \
-I Results/18_NT_22774.dedup.sorted.bam \
-I Results/19_mlun_76541.dedup.sorted.bam \
-I Results/1_CY_29457.dedup.sorted.bam \
-I Results/22_WA_335960.dedup.sorted.bam \
-I Results/23_WA_335961.dedup.sorted.bam \
-I Results/24_NSW_76676.dedup.sorted.bam \
-I Results/2_CY_57525.dedup.sorted.bam \
-I Results/3_CY_57401.dedup.sorted.bam \
-I Results/4_CY_57369.dedup.sorted.bam \
-I Results/5_CY_52131.dedup.sorted.bam \
-I Results/6_PNG_56130.dedup.sorted.bam \
-I Results/7_PNG_56164.dedup.sorted.bam \
-I Results/8_PNG_56279.dedup.sorted.bam \
-I Results/9_PNG_56278.dedup.sorted.bam \
-o Results/honeyeaters26_indel.intervals
