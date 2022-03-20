#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 25000
#SBATCH -t 0-5:00
#SBATCH -J bam2fq
#SBATCH -o ./Logs/bam2fq_%j.out
#SBATCH -e ./Logs/bam2fq_%j.err

# Code/run_bam2fq.sbatch
# Purpose:
# We want a single set of .fq reads per sample after having marked read groups, marked dups, etc. 

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Mapping2Variants
cd $SCRATCH

LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants

SAMPLE=$1

# reference genome:
REF=BFHE_C1A_neoZ_v1
REFGENOME=${LAB}/Data/${REF}.fasta

# load modules and program paths:
module load samtools/1.10-fasrc01


DIR=${LAB}/Results/${REF}

samtools collate -u -O ${DIR}/${SAMPLE}.dedup.sorted.bam | \
samtools fastq -1 ${DIR}/${SAMPLE}.dedup.sorted.paired1.fq.gz -2 ${DIR}/${SAMPLE}.dedup.sorted.paired2.fq.gz -0 /dev/null -s /dev/null -n

#samtools fastq \
#	-1 ${DIR}/${SAMPLE}.dedup.sorted.paired1.fq.gz \
#	-2 ${DIR}/${SAMPLE}.dedup.sorted.paired2.fq.gz \
#	-O -t \
#	/dev/null -s /dev/null \
#	-n ${DIR}/${SAMPLE}.dedup.sorted.bam
	
