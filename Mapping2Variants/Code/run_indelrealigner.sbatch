#!/bin/bash
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 0-14:00
#SBATCH -o ./Logs/realign_%j.out
#SBATCH -e ./Logs/realign_%j.err

## Code/run_indelrealigner.sbatch

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Mapping2Variants
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants
cd $SCRATCH

# reference genome:
REF=BFHE_C1A_neoZ_v1
REFGENOME=${LAB}/Data/${REF}.fasta

# load modules and program paths:
module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01
GATKPATH=/n/holylfs04/LABS/edwards_lab/Lab/jburley/programs/
PICARD=/n/home12/pcwang/picard/picard-2.8.0

DIR=${LAB}/Results

SAMPLE=$1

java -Xmx18g -jar $GATKPATH/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R $REFGENOME \
-I Results/${SAMPLE}.dedup.sorted.bam \
-targetIntervals Results/honeyeaters26_indel.intervals \
-o Results/${SAMPLE}.realigned.bam

java -Xmx8g -jar ${PICARD}/picard.jar BuildBamIndex \
I=Results/${SAMPLE}.realigned.bam

if [ -f Results/${SAMPLE}.realigned.bam ]
then
	cp Results/${SAMPLE}.realigned.bam ${LAB}/Results/${REF}/
	cp Results/${SAMPLE}.realigned.bai ${LAB}/Results/${REF}/
fi

