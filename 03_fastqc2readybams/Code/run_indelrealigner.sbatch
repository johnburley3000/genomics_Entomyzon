#!/bin/bash

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 0-14:00
#SBATCH -o ./Logs/realign_%j.out
#SBATCH -e ./Logs/realign_%j.err

SAMPLE=$1
GATKPATH=/n/edwards_lab/jburley/programs

module load java/1.8.0_45-fasrc01

java -Xmx18g -jar $GATKPATH/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R Data/BFHE336010v2.fasta \
-I Results/${SAMPLE}.dedup.sorted.bam \
-targetIntervals Results/honeyeaters26_indel.intervals \
-o Results/${SAMPLE}.realigned.bam

