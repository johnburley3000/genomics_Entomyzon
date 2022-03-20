#!/bin/bash

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 16000
#SBATCH -t 0-15:00
#SBATCH -o ./Logs/sort_index_sum_%j.out
#SBATCH -e ./Logs/sort_index_sum_%j.err

ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/01_trim2FQ/Results/Post-trim/ Data/.

SAMPLE=$1
REFGENOME=Data/BFHE336010v2.fasta

module load java/1.8.0_45-fasrc01

java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar SortSam \
I=Results/${SAMPLE}.dedup.bam \
O=Results/${SAMPLE}.dedup.sorted.bam \
SORT_ORDER=coordinate

java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar BuildBamIndex \
I=Results/${SAMPLE}.dedup.sorted.bam

java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar CollectAlignmentSummaryMetrics \
I=Results/${SAMPLE}.dedup.sorted.bam \
R=$REFGENOME \
METRIC_ACCUMULATION_LEVEL=SAMPLE \
METRIC_ACCUMULATION_LEVEL=READ_GROUP \
O=Results/${SAMPLE}.alignment_metrics.txt

java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar ValidateSamFile \
I=Results/${SAMPLE}.dedup.sorted.bam \
O=Results/${SAMPLE}.validate.txt MODE=SUMMARY
