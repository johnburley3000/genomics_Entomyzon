#!/bin/bash
#SBATCH -p shared
#SBATCH -n 26
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 7-00:00
#SBATCH -o ./Logs/indelcreator_%j.out
#SBATCH -e ./Logs/indelcreator_%j.err

# sbatch Code/run_indeltargetcreator.sbatch
# Purpose: Use bams from every indv to find targets for indel realignment

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

DIR=${SCRATCH}/Results
# using the scratch dir because indexed bams are there.

# create sequence dictionary for fasta

java -Xmx16g -jar $GATKPATH/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-nt 26 \
-R $REFGENOME \
-I ${DIR}/01_KP_336010.dedup.sorted.bam \
-I ${DIR}/02_KP_335960.dedup.sorted.bam \
-I ${DIR}/03_KP_335961.dedup.sorted.bam \
-I ${DIR}/04_TE_336114.dedup.sorted.bam \
-I ${DIR}/05_TE_22778.dedup.sorted.bam \
-I ${DIR}/06_TE_22941.dedup.sorted.bam \
-I ${DIR}/07_TE_23053.dedup.sorted.bam \
-I ${DIR}/08_TE_22774.dedup.sorted.bam \
-I ${DIR}/09_TE_29457.dedup.sorted.bam \
-I ${DIR}/10_PNG_56165.dedup.sorted.bam \
-I ${DIR}/11_PNG_56130.dedup.sorted.bam \
-I ${DIR}/12_PNG_56164.dedup.sorted.bam \
-I ${DIR}/13_PNG_56279.dedup.sorted.bam \
-I ${DIR}/14_PNG_56278.dedup.sorted.bam \
-I ${DIR}/15_CY_57525.dedup.sorted.bam \
-I ${DIR}/16_CY_57401.dedup.sorted.bam \
-I ${DIR}/17_CY_57369.dedup.sorted.bam \
-I ${DIR}/18_CY_52131.dedup.sorted.bam \
-I ${DIR}/19_EC_76677.dedup.sorted.bam \
-I ${DIR}/20_EC_76718.dedup.sorted.bam \
-I ${DIR}/21_EC_76649.dedup.sorted.bam \
-I ${DIR}/22_EC_76521.dedup.sorted.bam \
-I ${DIR}/23_EC_76599.dedup.sorted.bam \
-I ${DIR}/24_EC_76676.dedup.sorted.bam \
-I ${DIR}/25_Malb_76665.dedup.sorted.bam \
-I ${DIR}/26_Mlun_76541.dedup.sorted.bam \
-o ${DIR}.honeyeaters26_indel.intervals

# This time just writing results straight to Lab storage

