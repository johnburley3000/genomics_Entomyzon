#!/bin/bash
# requires bcftools/bgzip/tabix and vcftools
# run as ./Code/filter_vcfs.sh <SAMPLES>
# where SAMPLES corresponds to the bamlist used to generate the vcf

SAMPLES=$1

# create a filtered VCF containing only invariant sites
vcftools --gzvcf VCF/$SAMPLES.vcf.gz \
--max-maf 0 \
--remove-indels \
--recode --stdout | bgzip -c > VCF/$SAMPLES.invar.vcf.gz

# create a filtered VCF containing only variant sites
vcftools --gzvcf VCF/$SAMPLES.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--minQ 30 \
--recode --stdout | bgzip -c > VCF/$SAMPLES.var.vcf.gz

# index both vcfs using tabix
tabix VCF/$SAMPLES.invar.vcf.gz
tabix VCF/$SAMPLES.var.vcf.gz

# combine the two VCFs using bcftools concat
bcftools concat \
--allow-overlaps \
VCF/$SAMPLES.var.vcf.gz VCF/$SAMPLES.invar.vcf.gz \
-O z -o VCF/$SAMPLES.filt.vcf.gz

tabix VCF/$SAMPLES.filt.vcf.gz


