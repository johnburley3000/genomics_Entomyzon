#!/bin/bash
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 10000
#SBATCH -t 0-06:00
#SBATCH -J Dinvestigate
#SBATCH -o ./Logs/Dinvestigate_%j.out
#SBATCH -e ./Logs/Dinvestigate_%j.err

# sbatch Code/run_Dinvestigate.sbatch <TRIO>

# purpose: genome scans of Dstats and other introgression evidence for a given trio.

# Steps:
# 0 specify the trio
# 1 Dinvsetigate

# Params:
TRIO=$1 # PNG_CY_EC or combined
REF=BFHE_C1A_neoZ_v1
SAMPLES=males_og.var.filt1
SETS=pops_og2

# note: combined trees will output results for all trios listed in that ttext file

# PATHS:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Dsuite
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Dsuite
cd $SCRATCH

# Programs:
module load centos6/0.0.1-fasrc01
module load GCC/9.3.0
module load zlib/1.2.8-fasrc12
DSUITE=~/apps/Dsuite/Build/Dsuite

$DSUITE Dinvestigate \
	--window=3000,1000 \
	--use-genotype-probabilities \
	${LAB}/VCF/${REF}/${SAMPLES}.vcf.gz ${LAB}/Sets/${SETS}.txt ${LAB}/Trios/${TRIO}.trio
	
# move results to lab storage:
mv *localFstats* ${LAB}/Results/Dinvestigate/
