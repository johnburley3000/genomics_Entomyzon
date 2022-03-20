#!/bin/bash
#purpose: running the final step of fastqc2readybam.sbatch, because it had failed on this step owing to no .dict file present in /Data
# don't need this in future because fastqc2readybam.sbatch should work now..
#Date: 03 June 2017

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0-12:00
#SBATCH -o ./Logs/merge-clean%j.out
#SBATCH -e ./Logs/merge-clean%j.err

ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/01_trim2FQ/Results/Post-trim/ Data/.

SAMPLE=$1
SAMPLEREPNUM=$2
REFGENOME=Data/BFHE336010v2.fasta
#make sure fasta is indexed and with .dict.

module load java/1.8.0_45-fasrc01

java -Xmx19g -jar /n/home12/pcwang/picard/picard-2.8.0/picard.jar MergeBamAlignment \
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


