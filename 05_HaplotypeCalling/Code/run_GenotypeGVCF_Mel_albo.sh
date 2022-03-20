#!/bin/bash
#Date: Jun 13 2017
#purp: 

#SBATCH -p general
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem 100000
#SBATCH -t 7-00:00
#SBATCH -J GVCF_Malb
#SBATCH -o ./Logs/GVCF_Malb_%A_%a.out
#SBATCH -e ./Logs/GVCF_Malb_%A_%a.err
#SBATCH --constrain=holyib
#SBATCH --array=1-10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

module load java/1.8.0_45-fasrc01

GROUP=25_Malb_76665

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R Data/BFHE336010v2.fasta \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/"${GROUP}"_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--heterozygosity 0.005 \
-o Results/VCFs/"${GROUP}"_"${SLURM_ARRAY_TASK_ID}"_partial.vcf

