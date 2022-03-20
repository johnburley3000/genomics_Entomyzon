#!/bin/bash
# J Burley 
# Date:
# Purpose: delete after use unless problems, in which case just fix the other run_VCF2treemix script

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 5000
#SBATCH -t 2:00:00
#SBATCH -J tm
#SBATCH -o Logs/tm_%j.out
#SBATCH -e Logs/tm_%j.err

module load gcc/7.1.0-fasrc01
export PATH=/n/home01/jtb/apps/treemix-1.13/src/:$PATH

FILE=Ento_Meli_rm_snps_filt1_autos_1e5

#root
treemix -i Data/${FILE}_treemix.frq.gz -root 25_Malb_76665 -o Results/${FILE}_root
#group SNPS into groups of size n (potential problem with this is that there will be more snps from regions with higher snp density)
treemix -i Data/${FILE}_treemix.frq.gz -root 25_Malb_76665 -k 500 -o Results/${FILE}_k500
#test with samplesize correction:
treemix -i Data/${FILE}_treemix.frq.gz -root 25_Malb_76665 -k 500 -noss -o Results/${FILE}_k500_noss
#add migration:
for i in 1..10
do
treemix -i Data/${FILE}_treemix.frq.gz -root 25_Malb_76665 -k 500 -m $i -o Results/${FILE}_k500_m${i}
done


