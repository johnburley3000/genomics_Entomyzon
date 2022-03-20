#!/bin/bash
#Date: June 9 2017

#SBATCH -p general
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 6-00:00
#SBATCH -J HapC
#SBATCH -o ./Logs/HapC_%A_%a.out
#SBATCH -e ./Logs/gvcf_%A_%a.err
#SBATCH --constrain=holyib
#SBATCH --array=1-10

ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/03_fastqc2readybams/Results/Ready_BAMs/* Data/Ready_BAMs/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/03_fastqc2readybams/Data/BFHE336010v2.dict Data/.
# make sure fasta has relaven <name>.fasta.faii and <name>.dict in the same dir

module load java/1.8.0_45-fasrc01

SAMPLE=$1

mkdir Results/interval_list_"${SLURM_ARRAY_TASK_ID}"

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T HaplotypeCaller \
-R Data/BFHE336010v2.fasta \
-minPruning 1 \
-minDanglingBranchLength 1 \
-I Data/Ready_BAMs/${SAMPLE}.realigned.bam \
--emitRefConfidence GVCF \
-o Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/"${SAMPLE}"_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
-L Data/split_fastaindexBFHE336010v2.fasta_"${SLURM_ARRAY_TASK_ID}".interval_list

