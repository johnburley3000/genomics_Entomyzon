#!/bin/bash
#this ran in ~30 minutes with a 20gb mem allocation in interactive

GROUP=$1
#i.e. E_cyan_24, 25_Malb_76665, 26_Mlun_76541

module load java/1.8.0_45-fasrc01

java -cp /n/edwards_lab/jburley/programs/GenomeAnalysisTK.jar org.broadinstitute.gatk.tools.CatVariants \
-R Data/BFHE336010v2.fasta \
-V Results/VCFs/${GROUP}_1_partial.vcf \
-V Results/VCFs/${GROUP}_2_partial.vcf \
-V Results/VCFs/${GROUP}_3_partial.vcf \
-V Results/VCFs/${GROUP}_4_partial.vcf \
-V Results/VCFs/${GROUP}_5_partial.vcf \
-V Results/VCFs/${GROUP}_6_partial.vcf \
-V Results/VCFs/${GROUP}_7_partial.vcf \
-V Results/VCFs/${GROUP}_8_partial.vcf \
-V Results/VCFs/${GROUP}_9_partial.vcf \
-V Results/VCFs/${GROUP}_10_partial.vcf \
-out Results/VCFs/${GROUP}.vcf \
-assumeSorted
