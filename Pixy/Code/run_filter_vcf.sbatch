#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 15000
#SBATCH -t 1-00:00
#SBATCH -J filtersnps
#SBATCH -o ./Logs/filtersnps_%j.out
#SBATCH -e ./Logs/filtersnps_%j.err

# requires bcftools/bgzip/tabix and vcftools
# run as sbatch Code/run_filter_snps_<RUN>.sbatch <SAMPLES> <RUN>
# where SAMPLES corresponds to the bamlist used to generate the vcf
# and RUN corresponds to a unique set of filters (save sbatch scripts to record filter params)
# assumes that an "all sites" vcf is stored in lab storage: Pixy/VCF/

## variables:
SAMPLES=$1
RUN=$2

## modules:
module load bcftools/1.5-fasrc02
module load vcftools/0.1.14-fasrc01
module load tabix/0.2.6-fasrc01

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Pixy
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
cd $SCRATCH

# create a filtered VCF containing only invariant sites
vcftools --gzvcf ${LAB}/VCF/$SAMPLES.vcf.gz \
--max-maf 0 \
--remove-indels \
--recode --stdout | bgzip -c > VCF/$SAMPLES.$RUN.invar.vcf.gz

# create a filtered VCF containing only variant sites
vcftools --gzvcf ${LAB}/VCF/$SAMPLES.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--minQ 30 \
--recode --stdout | bgzip -c > VCF/$SAMPLES.$RUN.var.vcf.gz

# index both vcfs using tabix
tabix VCF/$SAMPLES.$RUN.invar.vcf.gz
tabix VCF/$SAMPLES.$RUN.var.vcf.gz

# combine the two VCFs using bcftools concat
bcftools concat \
--allow-overlaps \
VCF/$SAMPLES.$RUN.var.vcf.gz VCF/$SAMPLES.$RUN.invar.vcf.gz \
-O z -o VCF/$SAMPLES.filt.$RUN.vcf.gz

tabix VCF/$SAMPLES.filt.$RUN.vcf.gz

cp VCF/$SAMPLES.filt.$RUN.vcf.gz ${LAB}/VCF/
cp VCF/$SAMPLES.filt.$RUN.vcf.gz.tbi ${LAB}/VCF/
