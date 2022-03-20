#!/bin/bash
#Date: Jun 13 2017
# purpose: genotype GVCF files for sections of the genome. Use bam lists for all Entomyzon samples and all subspecies, so 4 runs. later, do this for the OGs individually.
# updated June 17 to include the CatVCF step!

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 80000
#SBATCH -t 5-00:00
#SBATCH -J GVCF_Ecc
#SBATCH -o ./Logs/GVCF_Ecc_%A_%a.out
#SBATCH -e ./Logs/GVCF_Ecc_%A_%a.err
#SBATCH --constrain=holyib
#SBATCH --array=1-10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

module load java/1.8.0_45-fasrc01

GROUP=E_cyan_cyan_6

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R Data/BFHE336010v2.fasta \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/19_EC_76677_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/20_EC_76718_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/21_EC_76649_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/22_EC_76521_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/23_EC_76599_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--variant Results/interval_list_"${SLURM_ARRAY_TASK_ID}"/24_EC_76676_"${SLURM_ARRAY_TASK_ID}".raw.g.vcf \
--heterozygosity 0.005 \
-o Results/VCFs/"${GROUP}"_"${SLURM_ARRAY_TASK_ID}"_partial.vcf

