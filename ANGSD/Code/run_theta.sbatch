#!/bin/bash
#SBATCH -p shared
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 24
#SBATCH --mem 75000
#SBATCH -t 1-02:00
#SBATCH -J ANGSD_theta
#SBATCH -o ./Logs/ANGSD_theta_%j.out
#SBATCH -e ./Logs/ANGSD_theta_%j.err

### run it as: sbatch Code/run_theta.sbatch <POP> <REGIONS>

# POP corresponds to a bamlist
# REGIONS corresponds to a regions file (see below for example)

# Running ANGSD to get estimates of pi and tajimas D
# Differently to before, I'm using no site filtering so that ANGSD can do it's thing with genotype imputation.
# this way, the denominator (nSites) will be less biased, and hopefully we'll get a better estimate of pi for windows. 

# http://www.popgen.dk/angsd/index.php/Thetas,Tajima,Neutrality_tests

module load angsd/0.930-fasrc01 
# note this is a different angsd version than what I used to use.. 

POP=$1
# KP 

REGIONS=$2 
# autos_2_1e5bp_nosexsegs # autos_2_1e5bp_nosexsegs_10smallest

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/ANGSD
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/ANGSD
cd $SCRATCH

REG_FILE=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_resources/Regions_angsd/${REGIONS}.txt

angsd -bam ${LAB}/Bamlists/${POP}.bamlist \
-rf $REG_FILE \
-doSaf 1 \
-uniqueOnly 1 \
-remove_bads 1 \
-trim 0 \
-minMapQ 30 \
-minQ 30 \
-only_proper_pairs 0 \
-anc ${LAB}/Mel_albo_ANGSD_20170613.fasta \
-GL 1 \
-P 24 \
-out ${POP}.out 

realSFS ${POP}.out.saf.idx -P 24 > ${POP}.out.sfs

realSFS saf2theta ${POP}.out.saf.idx -sfs ${POP}.out.sfs -outname ${POP}.out

thetaStat do_stat ${POP}.out.thetas.idx -win 50000 -step 50000 -outnames ${POP}.50kb_thetasWindow.gz

cp ${POP}.50kb_thetasWindow.gz.pestPG ${LAB}/Results/${REGIONS}_${POP}_50kb_thetasWindow.gz.pestPG

