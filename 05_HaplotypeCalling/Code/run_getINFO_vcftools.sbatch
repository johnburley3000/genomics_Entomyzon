#!/bin/bash
# J Burley 
# Date: June 21 2017
# Purp: get INFO from VCF

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 10:00:00
#SBATCH -J vcfINFO_multi
#SBATCH -o Logs/vcfINFO_%j.out
#SBATCH -e Logs/vcfINFO_%j.err

module load vcftools/0.1.14-fasrc01

# vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_NS --get-INFO NS
# there is no NS in INFO (NS: no samps with data)
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_MQ --get-INFO MQ
#vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_MQ0 --get-INFO MQ0
# there is no MQ0 in INFO (MQ0: Number of MAPQ == 0 reads covering this record)
#vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_BQ --get-INFO BQ
# no BQ in INFO (BQ: RMS base quality at this position)
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_DP --get-INFO DP
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_RPRS --get-INFO ReadPosRankSum
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_BQRS --get-INFO BaseQRankSum
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_MQRS --get-INFO MQRankSum
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_QD --get-INFO QD
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_MLEAC --get-INFO MLEAC
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_MLEAF --get-INFO MLEAF
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_CRS --get-INFO ClippingRankSum
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_ExH --get-INFO ExcessHet
vcftools --vcf Results/VCFs/E_cyan_snps.vcf --out Results/Info/E_cyan_snps_SOR --get-INFO SOR

