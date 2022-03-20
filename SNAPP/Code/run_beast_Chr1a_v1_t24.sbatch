#!/bin/bash

  # Job name:
  #SBATCH --job-name=SNAPP_t24 
  #
  # Wall clock limit:
  #SBATCH --time=16:00:00
  #
  # Processor and memory usage:
  #SBATCH --ntasks=1
  #SBATCH --cpus-per-task=24
  #SBATCH --mem-per-cpu=1G
  #
  # Output:
  #SBATCH -o ./Logs/SNAPP_t24%j.err
  #SBATCH -e ./Logs/SNAPP_t24%j.err

# Usage:
# sbatch Code/run_beast.sbatch

module load GCC/7.3.0-2.30  OpenMPI/3.1.1 Beast/2.6.0

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/SNAPP
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/SNAPP
cd $SCRATCH

STUB=males.var

beast -threads -1 -seed 12345 ${STUB}_snapptest_copy.xml


