#!/bin/bash
#SBATCH -p shared
#SBATCH -n 4
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 6-00:00
#SBATCH -J mpileup
#SBATCH -o ./Logs/mpileup_%j.out
#SBATCH -e ./Logs/mpileup_%j.err

## Code/run_mpileup.sbatch
# Purpose
# 1 - Generates ALLSITES VCF following: 
# https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html#generating-allsites-vcfs-using-bcftools-mpileup-call

# note: this took ~ 11 hrs for the subsetted genome. Next time consider breaking the reference genome by scaffold and run parallel. This will then probably take <4hrs.

module load bcftools/1.5-fasrc02
module load vcftools/0.1.14-fasrc01
module load tabix/0.2.6-fasrc01

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Pixy
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
cd $SCRATCH

# reference genome:
REF=BFHE_C1A_neoZ_v1 # subsetted from ONT-Flye assembly
REFGENOME=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Data/${REF}.fasta

# samples	
SAMPLES=males # corresponds to bamlist

# obtains ALL sites in a VCF
bcftools mpileup --threads 4 -f $REFGENOME -b ${LAB}/Code/$SAMPLES.bamlist | bcftools call -m -Oz -f GQ -o VCF/$SAMPLES.vcf.gz

if [ -f VCF/$SAMPLES.vcf.gz ]
then
  echo "bcftools mpileup generated an output file"
else
  echo "problem running mpileup"
fi


