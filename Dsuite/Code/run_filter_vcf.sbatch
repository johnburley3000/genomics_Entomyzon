#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 1-00:00
#SBATCH -J filtersnps
#SBATCH -o ./Logs/filtersnps_%j.out
#SBATCH -e ./Logs/filtersnps_%j.err

# requires bcftools/bgzip/tabix and vcftools
# run as sbatch Code/run_filter_snps_<RUN>.sbatch <SAMPLES> <RUN>
# where SAMPLES corresponds to the bamlist used to generate the vcf
# and RUN corresponds to a unique set of filters (save sbatch scripts to record filter params)

## variables:
SAMPLES=$1
RUN=$2
REF=BFHE_C1A_neoZ_v1

## modules:
module load bcftools/1.5-fasrc02
module load vcftools/0.1.14-fasrc01
module load tabix/0.2.6-fasrc01

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Dsuite
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Dsuite
cd $SCRATCH

# create a filtered VCF containing only variant sites
vcftools --gzvcf ${LAB}/VCF/${REF}/$SAMPLES.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--minQ 30 \
--recode --stdout | bgzip -c > VCF/$SAMPLES.var.filt${RUN}.vcf.gz

# index using tabix
tabix VCF/$SAMPLES.var.filt${RUN}.vcf.gz

cp VCF/$SAMPLES.var.filt${RUN}.vcf* ${LAB}/VCF/${REF}/
