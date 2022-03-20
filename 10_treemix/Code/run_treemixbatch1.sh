#!/bin/bash

#!/bin/bash
# J Burley 
# Date:
# Purpose: submit a batch of treemix jobs with 

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 4000
#SBATCH -t 13:00:00
#SBATCH -J tm1
#SBATCH -o Logs/tm1_%j.out
#SBATCH -e Logs/tm1_%j.err

# 4 hrs and 4000mb was sufficient for all runs to finish except for m9 bs 2. Re-running it allowing 7hrs. now 14

module load R
module load gcc/7.1.0-fasrc01
export PATH=/n/home01/jtb/apps/treemix-1.13/src/:$PATH
FILE=Ento_Meli_rm_snps_filt1_autos_1e5
ROOT=M_lun,M_alb

i=$1
s=$2

treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -m $i -se -seed $s -global -o Results2/${FILE}_Melroot_se_global_k500_m${i}_bs${s}

cd Results2
Rscript ../Code/treemixVarianceExplained.R ${FILE}_Melroot_se_global_k500_m${i}_bs${s} -v > ${FILE}_Melroot_se_global_k500_m${i}_bs${s}.var.txt

