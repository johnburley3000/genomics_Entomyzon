#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem=20G
#SBATCH -t 0-10:00
#SBATCH -J trim
#SBATCH -o ./Logs/trim_%j.out
#SBATCH -e ./Logs/trim_%j.err

# Code/run_trimgalore.sbatch
# Purpose: trim and quality check the paired end fastq files

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/ReadTrimming
cd $SCRATCH

LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/ReadTrimming

#VARIABLES:
READPATH=$1
SAMPLE=$2
LANEID=$3
ADAPTER=$4

# TESTING VARIABLES:
#READPATH=/n/holylfs04/LABS/edwards_lab/Lab/jburley/Data_backup/BFHE_reseq_20170425/Fastq/
#SAMPLE=10_PNG_56165
#LANEID=5
#ADAPTER=CTTGAC

##########
## THIS ENVIRONMENT WORKS AS OF OCT 26 2021
module purge
module load Anaconda3/2020.11
module load fastqc/0.11.5-fasrc01
#conda activate cutadaptenv
source activate cutadaptenv

TRIMGALORE=/n/home01/jtb/apps/TrimGalore-0.6.0/trim_galore
#locally installed:
#wget https://github.com/FelixKrueger/TrimGalore/archive/0.6.0.zip
#unzip trim_galore_v0.6.0.zip
##########

mkdir ${LAB}/Results/LaneID${LANEID}

$TRIMGALORE \
	--quality 30 \
	--phred33 \
	--fastqc \
	--paired \
	--adapter $ADAPTER \
	--retain_unpaired \
	-r1 100 \
	-r2 100 \
	-o ${LAB}/Results/LaneID${LANEID} \
	${READPATH}${SAMPLE}_${ADAPTER}.R1.fastq.gz ${READPATH}${SAMPLE}_${ADAPTER}.R2.fastq.gz

# The *_trimmed.fq.gz are produced as intermediate output (as R1 and R2 are trimmed individually in the first instance). 
# Once the trimming has completed, Trim Galore will launch a round of 'validation' (which is is where the files get the val in their names from), which primarily performs length-cutoff filtering (and a few more optional things I believe). 
# Once the validation is complete, the trimmed files will be deleted, and you are left with only the files N1_1_val_1.fq.gz and N1_2_val_2.fq.gz

# removing the intermediate files and the unpaired reads to save space. 

if [ -f ${LAB}/Results/LaneID${LANEID}/${SAMPLE}_${ADAPTER}.R1_val_1.fq.gz ]
then
  rm ${LAB}/Results/LaneID${LANEID}/${SAMPLE}_${ADAPTER}.*trimmed*
  rm ${LAB}/Results/LaneID${LANEID}/${SAMPLE}_${ADAPTER}.*unpaired*
fi

