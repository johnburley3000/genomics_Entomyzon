#!/bin/bash
#Date: Jun 13 2017
# purpose: genotype GVCF files for sections of the genome. Use bam lists for all Entomyzon samples and all subspecies, so 4 runs. later, do this for the OGs individually.

#SBATCH -p general
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem 25000
#SBATCH -t 1-00:00
#SBATCH -J GgVCF
#SBATCH -o ./Logs/GgVCF_%A_%a.out
#SBATCH -e ./Logs/GgVCF_%A_%a.err
#SBATCH --constrain=holyib
#SBATCH --array=1-10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

#INFILES=$1 #i.e. Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/01_KP_336010_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf
#OUTFILE=$2 #i.e. Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/01_KP_336010_"${SLURM_ARRAY_TASK_ID}".vcf

GROUP=$1

module load java/1.8.0_45-fasrc01

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R Data/BFHE336010v2.fasta \
-V Code/${GROUP}_gvcf.list \
-o Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/"${GROUP}"_"${SLURM_ARRAY_TASK_ID}"_partial.vcf

#--variant interval_list_"${SLURM_ARRAY_TASK_ID}"/"${SAMPLE}"_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
-o Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/"${GROUP}"_"${SLURM_ARRAY_TASK_ID}"_partial.vcf
# the -V option with .list doesnt work.
