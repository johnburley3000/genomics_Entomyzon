#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 16000
#SBATCH -t 0-15:00
#SBATCH -o ./Logs/SoInSu_%j.out
#SBATCH -e ./Logs/SoInSu_%j.err

#
# Purpose:

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Mapping2Variants
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants
cd $SCRATCH

SAMPLE=$1

NEW_NAME=$2

# reference genome:
REF=BFHE_C1A_neoZ_v1
REFGENOME=${LAB}/Data/${REF}.fasta

# load modules and program paths:
module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01
PICARD=/n/home12/pcwang/picard/picard-2.8.0

DIR=${LAB}/Results/${REF}

java -Xmx8g -jar ${PICARD}/picard.jar SortSam \
I=${DIR}/${SAMPLE}.dedup.bam \
O=Results/${NEW_NAME}.dedup.sorted.bam \
SORT_ORDER=coordinate

java -Xmx8g -jar ${PICARD}/picard.jar BuildBamIndex \
I=Results/${NEW_NAME}.dedup.sorted.bam

java -Xmx8g -jar ${PICARD}/picard.jar CollectAlignmentSummaryMetrics \
I=Results/${NEW_NAME}.dedup.sorted.bam \
R=$REFGENOME \
METRIC_ACCUMULATION_LEVEL=SAMPLE \
METRIC_ACCUMULATION_LEVEL=READ_GROUP \
O=Results/${NEW_NAME}.alignment_metrics.txt

java -Xmx8g -jar ${PICARD}/picard.jar ValidateSamFile \
I=Results/${NEW_NAME}.dedup.sorted.bam \
O=Results/${NEW_NAME}.validate.txt MODE=SUMMARY

if [ -f Results/${NEW_NAME}.dedup.sorted.bam ]
then
	cp Results/${NEW_NAME}.dedup.sorted.bam ${LAB}/Results/${REF}/
	cp Results/${NEW_NAME}.dedup.sorted.bai ${LAB}/Results/${REF}/
	cp Results/${NEW_NAME}.alignment_metrics.txt ${LAB}/Results/${REF}/
	cp Results/${NEW_NAME}.validate.txt ${LAB}/Results/${REF}/
fi

