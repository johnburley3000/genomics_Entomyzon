#!/bin/bash
#Date: Jun 13 2017
# purpose: genotype GVCF files for sections of the genome. Use bam lists for all Entomyzon samples and all subspecies, so 4 runs. later, do this for the OGs individually.

#SBATCH -p general
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem 100000
#SBATCH -t 7-00:00
#SBATCH -J GVCF_Eca
#SBATCH -o ./Logs/GVCF_Eca_%A_%a.out
#SBATCH -e ./Logs/GVCF_Eca_%A_%a.err
#SBATCH --constrain=holyib
#SBATCH --array=1-10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

module load java/1.8.0_45-fasrc01

GROUP=E_cyan_albi_9

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R Data/BFHE336010v2.fasta \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/01_KP_336010_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/02_KP_335960_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/03_KP_335961_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/04_TE_336114_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/05_TE_22778_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/06_TE_22941_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/07_TE_23053_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/08_TE_22774_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/09_TE_29457_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--heterozygosity 0.005 \
-o Results/VCFs/"${GROUP}"_"${SLURM_ARRAY_TASK_ID}"_partial.vcf

