#!/bin/bash
# Purpose: based on the pipeline of fastqc2readybam.sbatch, but starting at the BWAstep.

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0-12:00
#SBATCH -o ./Logs/bwa_sam_%j.out
#SBATCH -e ./Logs/bwa_sam_%j.err

#for low cov, did mem 20gb time 12hr
#for high cov (lanes 1-4) try 35gb 24hr
#for the ref genome BFHE_3 try 50gb 30hr

FASTQDIR=$1
SAMPLE=$2
BARCODE=$3
SAMPLEREPNUM=$4
FLOWCELL=$5
LANE=$6
DATE=$7

#link to reference genome
#ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/A_ref_genome/Results/BFHE336010v2.fasta Data/.
# removed link because I copied the files directly to Data/
# NOTE THE ABOVE FOR FUTURE REFERNCE
REFGENOME=Data/BFHE336010v2.fasta
IDXBASE=Data/BFHE336010v2

#link to fastq data
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/01_trim2FQ/Results/Post-trim/ Data/.

module load java/1.8.0_45-fasrc01
module load bwa/0.7.9a-fasrc01

bwa mem -M -t 1 -p $IDXBASE Results/${SAMPLE}_${SAMPLEREPNUM}_samtofastq_interleaved.fq \
        > Results/${SAMPLE}_${SAMPLEREPNUM}_bwa_mem.sam

java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar MergeBamAlignment \
        ALIGNED_BAM=Results/${SAMPLE}_${SAMPLEREPNUM}_bwa_mem.sam \
        UNMAPPED_BAM=Results/${SAMPLE}_${SAMPLEREPNUM}_fastqtosam.bam \
        OUTPUT=Results/${SAMPLE}_${SAMPLEREPNUM}_mergebamalign.bam \
        R=${REFGENOME} CREATE_INDEX=true ADD_MATE_CIGAR=true \
        CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \
        INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \
        PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \
        TMP_DIR=./tmp

if [ -f Results/${SAMPLE}_${SAMPLEREPNUM}_mergebamalign.bam ]
then
  rm Results/${SAMPLE}_${SAMPLEREPNUM}_fastqtosam.bam
  rm Results/${SAMPLE}_${SAMPLEREPNUM}_markilluminaadapters.bam
  rm Results/${SAMPLE}_${SAMPLEREPNUM}_samtofastq_interleaved.fq
  rm Results/${SAMPLE}_${SAMPLEREPNUM}_bwa_mem.sam
fi


