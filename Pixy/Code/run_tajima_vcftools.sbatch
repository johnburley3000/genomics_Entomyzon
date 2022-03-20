#!/bin/bash
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 5000
#SBATCH -t 0-02:00
#SBATCH -J Tajima
#SBATCH -o ./Logs/Tajima_%j.out
#SBATCH -e ./Logs/Tajima_%j.err

# sbatch Code/run_tajima_vcftools.sbatch <FILE> <POP>
# loop it through pops.. 

FILE=$1 # corresponds to the VCF 
POP=$2 # correponds to a list of samples to include (--keep in vcftools)
WIN=50000
win=50Kb

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Pixy
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
cd $SCRATCH

## run it:

module load vcftools/0.1.14-fasrc01

vcftools --gzvcf ${LAB}/VCF/$1.vcf.gz --keep ${LAB}/Code/$2.txt --TajimaD $WIN --out ${LAB}/Results/${1}_${2}_${win}

