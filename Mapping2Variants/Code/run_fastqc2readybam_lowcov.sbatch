#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 0-12:00
#SBATCH -o ./Logs/fastq_sam_lc%j.out
#SBATCH -e ./Logs/fastq_sam_lc%j.err

# run_fastqc2readybam_lowcov.sbatch
# Purpose: pre-processing of trimmed read files (.fq), mapping to ref genome, align.
# produces interleaved fq file and bam files with the newer naming convention.

#for low cov, did mem 20gb time 12hr
#for high cov (lanes 1-4) try 35gb 24hr
#for the ref genome BFHE_3 try 50gb 30hr

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Mapping2Variants
cd $SCRATCH

LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants

# reference genome:
REF=BFHE_C1A_neoZ_v1
REFGENOME=${LAB}/Data/$REF.fasta
IDXBASE=${LAB}/Data/$REF

FASTQDIR=$1 #
SAMPLE=$2
BARCODE=$3
SAMPLEREPNUM=$4
FLOWCELL=$5
LANE=$6
DATE=$7
NEW_NAME=$8

#TESTING VARS:
#FASTQDIR=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/ReadTrimming/Results/LaneID6
#SAMPLE=16_NT_22941
#BARCODE=TACAGC
#SAMPLEREPNUM=2
#FLOWCELL=CAYTEANXX
#LANE=6
#DATE=20170519
#NEW_NAME=06_TE_22941

# load modules and program paths:
module load centos6/0.0.1-fasrc01 # RC now cautions against using this...
module load java/1.8.0_45-fasrc01
module load bwa/0.7.17-fasrc01 # old: bwa/0.7.9a-fasrc01
PICARD=/n/home12/pcwang/picard/picard-2.8.0

java -Xmx8g -jar $PICARD/picard.jar FastqToSam \
    FASTQ=${FASTQDIR}/${SAMPLE}_${BARCODE}.R1_val_1.fq.gz \
    FASTQ2=${FASTQDIR}/${SAMPLE}_${BARCODE}.R2_val_2.fq.gz \
    OUTPUT=Results/${NEW_NAME}_${SAMPLEREPNUM}_fastqtosam.bam \
    READ_GROUP_NAME=${FLOWCELL}.${LANE} \
    SAMPLE_NAME=${NEW_NAME} \
    LIBRARY_NAME=${SAMPLE}_${SAMPLEREPNUM} \
    PLATFORM_UNIT=${FLOWCELL}.${LANE}.${SAMPLE} \
    PLATFORM=ILLUMINA \
    SEQUENCING_CENTER=BAUER \
    RUN_DATE=${DATE}
    
# above: keep library name as the original name, but use the new name for sample name

java -Xmx8g -jar $PICARD/picard.jar MarkIlluminaAdapters \
	I=Results/${NEW_NAME}_${SAMPLEREPNUM}_fastqtosam.bam \
	O=Results/${NEW_NAME}_${SAMPLEREPNUM}_markilluminaadapters.bam \
	M=Results/${NEW_NAME}_${SAMPLEREPNUM}_markilluminaadapters_metrics.txt
	TMP_DIR=./tmp

java -Xmx8g -jar $PICARD/picard.jar SamToFastq \
	I=Results/${NEW_NAME}_${SAMPLEREPNUM}_markilluminaadapters.bam \
	FASTQ=Results/${NEW_NAME}_${SAMPLEREPNUM}_samtofastq_interleaved.fq \
	CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
	TMP_DIR=./tmp

#needs index files for fasta in the same dir as fasta. Ran
bwa mem -M -t 1 -p $IDXBASE Results/${NEW_NAME}_${SAMPLEREPNUM}_samtofastq_interleaved.fq \
	> Results/${NEW_NAME}_${SAMPLEREPNUM}_bwa_mem.sam

#needs .dict file for next step. Use Picard CreateSequenceDictionary (1 min in interative)
java -Xmx8g -jar $PICARD/picard.jar MergeBamAlignment \
	ALIGNED_BAM=Results/${NEW_NAME}_${SAMPLEREPNUM}_bwa_mem.sam \
	UNMAPPED_BAM=Results/${NEW_NAME}_${SAMPLEREPNUM}_fastqtosam.bam \
	OUTPUT=Results/${NEW_NAME}_${SAMPLEREPNUM}_mergebamalign.bam \
	R=${REFGENOME} CREATE_INDEX=true ADD_MATE_CIGAR=true \
	CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \
	INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \
	PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \
	TMP_DIR=./tmp


# copy what is needed to lab long-term storage. (interleaved.fq, metrics):
# the rest can stay in scratch to be used in next step.

mkdir ${LAB}/Results/$REF
if [ -f Results/${NEW_NAME}_${SAMPLEREPNUM}_mergebamalign.bam ]
then
	echo "finished processing ${SAMPLE} (oldname) as  ${NEW_NAME}_mergebamalign.bam"
	cp Results/${NEW_NAME}_${SAMPLEREPNUM}_samtofastq_interleaved.fq ${LAB}/Results/${REF}/
	cp Results/${NEW_NAME}_${SAMPLEREPNUM}_markilluminaadapters_metrics.txt ${LAB}/Results/${REF}/
	echo "saved interleaved fq files and markilluminaadapters metrics to lab storage"
fi

