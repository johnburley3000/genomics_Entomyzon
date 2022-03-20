#!/bin/bash
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 30000
#SBATCH -t 1-00:00
#SBATCH -J Dquartets
#SBATCH -o ./Logs/Dquartets_%j.out
#SBATCH -e ./Logs/Dquartets_%j.err

## Code/run_Dquartets.sbatch
# purpose:
# runs the (experimental) Dquartets program in Dsuite
# this requires no output, so we can use the same SNP set used for pixy (males only)
# not that this code reads data from the Pixy lab storage

# Results are put in Lab storage for Dsuite

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Dsuite
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Dsuite

# load modules and program:

module load centos6/0.0.1-fasrc01 
module load GCC/9.3.0 
module load zlib/1.2.8-fasrc12

DSUITE=~/apps/Dsuite/Build/Dsuite 
$DSUITE

# Data paths:

# using the VCF generated for pixy (male samples, no outgroup)
DIR1=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
FILE=males.filt.1

$DSUITE Dquartets \
	--JKnum 20 \
	--out-prefix=${LAB}/Results/$FILE \
	${DIR1}/VCF/${FILE}.vcf.gz ${DIR1}/Code/pops.txt

