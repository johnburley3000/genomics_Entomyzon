#!/bin/bash
# J Burley 
# Date: June 17 2017
# Purpose:

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 12:00:00
#SBATCH -J VCFt_fst
#SBATCH -o Logs/VCFt_fst_%j.out
#SBATCH -e Logs/VCFt_fst_%j.err

#LINKS
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/E_cyan_24.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/26_Mlun_76541.* Data/.
ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/05_HaplotypeCalling/Results/VCFs/25_Malb_76665.* Data/.

#VARIABLES
GROUP=E_cyan_24
SCAFS=scaf_0
BEDFILE=Code/scaf_0.bed
#MODULES
module load vcftools/0.1.14-fasrc01

#COMMANDS
vcftools --vcf Data/${GROUP}.vcf --bed Code/${SCAFS}.bed --out Results/VCFtools/${GROUP}_${SCAFS}_ECC-ECG --weir-fst-pop Code/ECC_list.txt --weir-fst-pop Code/ECG_list.txt
vcftools --vcf Data/${GROUP}.vcf --bed Code/${SCAFS}.bed --out Results/VCFtools/${GROUP}_${SCAFS}_ECC-ECA --weir-fst-pop Code/ECC_list.txt --weir-fst-pop Code/ECA_list.txt
vcftools --vcf Data/${GROUP}.vcf --bed Code/${SCAFS}.bed --out Results/VCFtools/${GROUP}_${SCAFS}_ECG-ECA --weir-fst-pop Code/ECG_list.txt --weir-fst-pop Code/ECA_list.txt

#NOTES
# it seems to read the first line of bed file as a header...
# June 17 - ran GROUP=E_cyan_24 SCAFS=allscaf
