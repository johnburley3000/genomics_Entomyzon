#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 25000
#SBATCH -t 0-20:00
#SBATCH -J DeSoInSu
#SBATCH -o ./Logs/DeSoInSu_%j.out
#SBATCH -e ./Logs/DeSoInSu_%j.err

# Code/run_dedup_sort_index_summary.sbatch

# Purpose: run this after fastqc2readybam.sbatch.
# # Mark Duplicates (and merge bams into 1 per sample)
# # Sort reads in sam file
# # create bam index files (bai)
# # get read mapping summary metrics
# # perform validation of sam file

# Note: 
# assumes that four *_mergebamalign.bam files per sample are in Results/ of scratch

# for full genome data, I did:
# low cov- mem 20gb, time 1day. future - 4hr
# high cov- 35gb, time 2day.future - 8.5hr

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Mapping2Variants
cd $SCRATCH

LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants

SAMPLE=$1

# reference genome:
REF=BFHE_C1A_neoZ_v1
REFGENOME=${LAB}/Data/${REF}.fasta

# load modules and program paths:
module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01
PICARD=/n/home12/pcwang/picard/picard-2.8.0

DIR=${LAB}/Results/${REF}

java -Xmx19g -jar ${PICARD}/picard.jar MarkDuplicates TMP_DIR=tmp \
I=Results/${SAMPLE}_1_mergebamalign.bam \
I=Results/${SAMPLE}_2_mergebamalign.bam \
I=Results/${SAMPLE}_3_mergebamalign.bam \
I=Results/${SAMPLE}_4_mergebamalign.bam \
O=Results/${SAMPLE}.dedup.bam \
METRICS_FILE=Results/${SAMPLE}.dedup.metrics.txt \
REMOVE_DUPLICATES=false TAGGING_POLICY=All

java -Xmx8g -jar ${PICARD}/picard.jar SortSam \
I=Results/${SAMPLE}.dedup.bam \
O=Results/${SAMPLE}.dedup.sorted.bam \
SORT_ORDER=coordinate

java -Xmx8g -jar ${PICARD}/picard.jar BuildBamIndex \
I=Results/${SAMPLE}.dedup.sorted.bam

java -Xmx8g -jar ${PICARD}/picard.jar CollectAlignmentSummaryMetrics \
I=Results/${SAMPLE}.dedup.sorted.bam \
R=$REFGENOME \
METRIC_ACCUMULATION_LEVEL=SAMPLE \
METRIC_ACCUMULATION_LEVEL=READ_GROUP \
O=Results/${SAMPLE}.alignment_metrics.txt

java -Xmx8g -jar ${PICARD}/picard.jar ValidateSamFile \
I=Results/${SAMPLE}.dedup.sorted.bam \
O=Results/${SAMPLE}.validate.txt MODE=SUMMARY

if [ -f Results/${SAMPLE}.dedup.sorted.bam ]
then
	echo "there is a .dedup.sorted.bam for sample ${SAMPLE}"
	echo "copying dedup/alignment metrics and sam validation to lab storage"
	cp Results/${SAMPLE}.dedup.metrics.txt ${LAB}/Results/${REF}/
	cp Results/${SAMPLE}.alignment_metrics.txt ${LAB}/Results/${REF}/
	cp Results/${SAMPLE}.validate.txt ${LAB}/Results/${REF}/
	cp Results/${SAMPLE}.dedup.sorted.bam ${LAB}/Results/${REF}/
	echo "copied .dedup.sorted.bam to lab storage"
fi

