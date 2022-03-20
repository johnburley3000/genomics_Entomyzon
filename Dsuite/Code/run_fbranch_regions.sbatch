#!/bin/bash
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 10000
#SBATCH -t 0-01:00
#SBATCH -J Fbranch
#SBATCH -o ./Logs/Fbranch_%j.out
#SBATCH -e ./Logs/Fbranch_%j.err

# sbatch Code/run_fbranch_regions.sbatch <REGION>

# purpose: generate plots of fbranch stats for the:
# chr 1a, new PAR, added Z, ancestal Z

# REGION corresponds to a bed file and will be propogated through to output files

# Steps:
# 1 filter VCF using region
# 2 Dtrios on filtered VCF
# 3 fbranch
# 4 plot

# Params:
REGION=$1 # ancZ
REF=BFHE_C1A_neoZ_v1
SAMPLES=males_og.var.filt1
SETS=pops_og2

# PATHS:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Dsuite
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Dsuite
cd $SCRATCH

# Programs:

module load bcftools/1.5-fasrc02
module load vcftools/0.1.14-fasrc01
module load tabix/0.2.6-fasrc01
DSUITE=~/apps/Dsuite/Build/Dsuite
dtools=/n/home01/jtb/apps/Dsuite/utils/dtools.py

## Filter VCF

vcftools --gzvcf ${LAB}/VCF/${REF}/$SAMPLES.vcf.gz \
	--bed ${LAB}/Regions/${REF}_${REGION}.bed \
	--recode --stdout | bgzip -c > VCF/${SAMPLES}_${REGION}.vcf.gz

# index using tabix
tabix VCF/${SAMPLES}_${REGION}.vcf.gz
	
## Run Dtrios

module load centos6/0.0.1-fasrc01
module load GCC/9.3.0
module load zlib/1.2.8-fasrc12

$DSUITE Dtrios \
	--JKnum 20 \
	--out-prefix=${LAB}/Results/Fbranch/ \
	--run-name=${SAMPLES}_${SETS}_${REGION} \
	--tree=${LAB}/Trees/${SETS}.tree.nwk \
	VCF/${SAMPLES}_${REGION}.vcf.gz ${LAB}/Sets/${SETS}.txt
	
## Run Fbranch

$DSUITE Fbranch \
	--pthresh=0.01 \
	${LAB}/Trees/${SETS}.tree.nwk \
	${LAB}/Results/Fbranch/_${SAMPLES}_${SETS}_${REGION}_tree.txt \
	> ${LAB}/Results/Fbranch/_${SAMPLES}_${SETS}_${REGION}.fbranch.txt
	
# copy results to lab?

## Plot results

$dtools \
	--run-name ${LAB}/Results/Fbranch/_${SAMPLES}_${SETS}_${REGION} \
	--ladderize \
	--color-cutoff 0.183 \
	${LAB}/Results/Fbranch/_${SAMPLES}_${SETS}_${REGION}.fbranch.txt \
	${LAB}/Trees/${SETS}.tree.nwk
	
# automatically saves results in ${LAB}/Results/Fbranch/


