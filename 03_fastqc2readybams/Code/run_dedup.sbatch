#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 25000
#SBATCH -t 0-18:00
#SBATCH -o ./Logs/dedup_%j.out
#SBATCH -e ./Logs/dedup_%j.err

# Mark Duplicates
# Code/run_dedup.sbatch

# Oct 27 2021. Accidently overwrote the original verison of this script and corresponding submit_ file while editing for new data.
# There are no substantial changes, just paths etc. 

# Purpose: run this after fastqc2readybam.sbatch.

# for full genome data, I did:
# low cov- mem 20gb, time 1day. future - 4hr
# high cov- 35gb, time 2day.future - 8.5hr

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Mapping2Variants
cd $SCRATCH

LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants

SAMPLE=$1

# reference genome:
REF=BFHE_C1A_neoZ_v1

# load modules and program paths:
module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01
PICARD=/n/home12/pcwang/picard/picard-2.8.0

DIR=${LAB}/Results/${REF}

java -Xmx19g -jar ${PICARD}/picard.jar MarkDuplicates TMP_DIR=tmp \
I=${DIR}/${SAMPLE}_1_mergebamalign.bam \
I=${DIR}/${SAMPLE}_2_mergebamalign.bam \
I=${DIR}/${SAMPLE}_3_mergebamalign.bam \
I=${DIR}/${SAMPLE}_4_mergebamalign.bam \
O=Results/${SAMPLE}.dedup.bam \
METRICS_FILE=Results/${SAMPLE}.dedup.metrics.txt \
REMOVE_DUPLICATES=false TAGGING_POLICY=All

if [ -f Results/${SAMPLE}.dedup.bam ]
then
	cp Results/${SAMPLE}.dedup.bam ${LAB}/Results/${REF}/
	cp Results/${SAMPLE}.dedup.metrics.txt ${LAB}/Results/${REF}/
fi

