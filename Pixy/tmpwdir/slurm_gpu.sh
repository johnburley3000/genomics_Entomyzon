#!/bin/bash
#SBATCH -p gpu
#SBATCH -n 8
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 1-00:00
#SBATCH -J pixy
#SBATCH -o ./Logs/pixy_%j.out
#SBATCH -e ./Logs/pixy_%j.err

# run as sbatch Code/run_pixy.sbatch <SAMPLES> <GROUP> <RUN>

# where SAMPLES corresponds to the bamlist used to generate the vcf
# and GROUP corresponds to a txt file describing which population the samples belong to
# and RUN corresponds to a unique set of SNP filters

## variables:
SAMPLES=$1 # males
GROUP=$2 # pops or subspecies
RUN=$3 # 1
WIN=50000 # the window size for analysis (appended to output prefix)
winkb=50kb

## modules:
module load Anaconda3/2020.11
source activate pixy
module load tabix/0.2.6-fasrc01

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Pixy
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
cd $SCRATCH

## run it:
pixy --stats pi dxy fst \
--vcf ${LAB}/VCF/$SAMPLES.filt.$RUN.vcf.gz \
--populations ${LAB}/Code/$GROUP.txt \
--window_size $WIN \
--n_cores 48 \
--output_folder ${LAB}/Results \
--output_prefix ${SAMPLES}_filt${RUN}_${GROUP}_${winkb}

