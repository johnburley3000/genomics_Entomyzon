#!/bin/bash
# J Burley 
# Date:
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 35000
#SBATCH -t 4:00:00
#SBATCH -J for_treemix
#SBATCH -o Logs/for_treemix_%j.out
#SBATCH -e Logs/for_treemix_%j.err

#LINKS

#VARIABLES

#MODULES
module load GATK/3.5-fasrc01
vcftools/vcftools_0.1.12b

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
   -T CombineVariants \
   -R Data/BFHE336010v2.fasta \
   --variant Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.vcf \
   --variant Results/VCFs/25_Malb_76665.vcf \
   -o Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_M_albo_combined.vcf \
   -genotypeMergeOptions UNIQUIFY

# > This might have worked. many of the positions have SNPS for either entomyzon or melithreptus. need to keep only those with snps for all.

java -Xmx10g -jar /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar \
   -T SelectVariants \
   -R Data/BFHE336010v2.fasta \
   -V Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_M_albo_combined.vcf \
   -o Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_M_albo_combined_intersect.vcf \
   -select 'set == "Intersection"'
   
FILE=Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_M_albo_combined_intersect

awk '{gsub(/^scaffold_/,""); print}' ${FILE}.vcf > ${FILE}_noscaf.vcf
vcftools --vcf ${FILE}_noscaf.vcf --plink --out ${FILE}




#NOTES
