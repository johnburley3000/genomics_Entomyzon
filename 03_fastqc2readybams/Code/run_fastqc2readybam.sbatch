#!/bin/bash

#Purpose: take trimmed reads through various processing steps, map to reference genome, and then process the bams to make ready for analysis.
#By J Burley. slightly modified from Allison Shultz script: https://github.com/ajshultz/whole-genome-reseq/blob/master/PreProcessing/run_FastqToAlignedBAM.sbatch
#Date: 31 May 2017

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 50000
#SBATCH -t 0-32:00
#SBATCH -o ./Logs/fastq_sam_hc%j.out
#SBATCH -e ./Logs/fastq_sam_hc%j.err

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

java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar FastqToSam \
    FASTQ=${FASTQDIR}/${SAMPLE}_${BARCODE}.R1_val_1.fq.gz \
    FASTQ2=${FASTQDIR}/${SAMPLE}_${BARCODE}.R2_val_2.fq.gz \
    OUTPUT=Results/${SAMPLE}_${SAMPLEREPNUM}_fastqtosam.bam \
    READ_GROUP_NAME=${FLOWCELL}.${LANE} \
    SAMPLE_NAME=${SAMPLE} \
    LIBRARY_NAME=${SAMPLE} \
    PLATFORM_UNIT=${FLOWCELL}.${LANE}.${SAMPLE} \
    PLATFORM=ILLUMINA \
    SEQUENCING_CENTER=BAUER \
    RUN_DATE=${DATE}
    
java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar MarkIlluminaAdapters \
	I=Results/${SAMPLE}_${SAMPLEREPNUM}_fastqtosam.bam \
	O=Results/${SAMPLE}_${SAMPLEREPNUM}_markilluminaadapters.bam \
	M=Results/${SAMPLE}_${SAMPLEREPNUM}_markilluminaadapters_metrics.txt
	TMP_DIR=./tmp
	
java -Xmx8g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar SamToFastq \
	I=Results/${SAMPLE}_${SAMPLEREPNUM}_markilluminaadapters.bam \
	FASTQ=Results/${SAMPLE}_${SAMPLEREPNUM}_samtofastq_interleaved.fq \
	CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
	TMP_DIR=./tmp

#needs index files for fasta in the same dir as fasta. Ran  
bwa mem -M -t 1 -p $IDXBASE Results/${SAMPLE}_${SAMPLEREPNUM}_samtofastq_interleaved.fq \
	> Results/${SAMPLE}_${SAMPLEREPNUM}_bwa_mem.sam

#needs .dict file for next step. Use Picard CreateSequenceDictionary (1 min in interative)
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

