#!/bin/bash
# purpose: taking Ento_Meli_rm_snps_filt1.vcf and applying some moree stringent filters..

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 6000
#SBATCH -t 0-2:00
#SBATCH -J filter23
#SBATCH -o Logs/filter23_%j.out
#SBATCH -e Logs/filter23_%j.err

module load java/1.8.0_45-fasrc01
module load vcftools/0.1.14-fasrc01

GROUP=Ento_Meli

# change the sample names in the VCF to match other analyses (i.e. 01_name..26_name)
#egrep "##" Results/VCFs/Ento_Meli_rm_snps_filt1.vcf > Results/VCFs/Ento_Meli_rm_snps_filt1_HEAD.vcf
#grep -v "#" Results/VCFs/Ento_Meli_rm_snps_filt1.vcf > Results/VCFs/Ento_Meli_rm_snps_filt1_BODY.vcf
# make SAMPLES line in excel, check to see that they join up properly..

#cat Results/VCFs/Ento_Meli_rm_snps_filt1_HEAD.vcf Results/VCFs/Ento_Meli_rm_snps_filt1_SAMPLES.vcf Results/VCFs/Ento_Meli_rm_snps_filt1_BODY.vcf > Results/VCFs/${GROUP}_rm_snps_filt1.vcf

# 1 aiming to remove snps where a sample has depth (DP) < 10 or genotype quality score < 30.
# I expect this will remove a lot of SNPs, because mean coverage of some samples is ~7.5x 
# --max-missing 1 Exclude sites on the basis of the proportion of missing data. 1 indicates no missing data allowed
# filt2
vcftools --vcf Results/VCFs/${GROUP}_rm_snps_filt1.vcf --recode --recode-INFO-all --out Results/VCFs/${GROUP}_rm_snps_filt2 --minDP 7 --minGQ 10 --max-missing 1

# allow SNPs with data for at least 10 samples 
# filt3
vcftools --vcf Results/VCFs/${GROUP}_rm_snps_filt1.vcf --recode --recode-INFO-all --out Results/VCFs/${GROUP}_rm_snps_filt3 --minDP 7 --minGQ 10 --max-missing-count 10

mv Results/VCFs/${GROUP}_rm_snps_filt2.recode.vcf Results/VCFs/${GROUP}_rm_snps_filt2.vcf
mv Results/VCFs/${GROUP}_rm_snps_filt3.recode.vcf Results/VCFs/${GROUP}_rm_snps_filt3.vcf

# Remove sites that are heterozygous in either Mel lunatus or Mel albogularis

# take a single SNP per rough Linkage group

# split the data by chromosome type, but try 2 sets:
	# 1 filt1 - this uses all genotypes that pass the filtering, as used in ANGSD 
	# 2 filt2 - this removes all genotypes with depth < x and GQ score < y, and then removes all SNPs with missing data for more than 1 individual (hence this dataset is MUCH reduced in size)
	# 3 filt3 - this is like filt2, but it only excludes sites with missing data for 10 or more samples.
for i in 1 2 3
do

# get autos(nosexseg) only (404scaf):

#cat Code/Beds/autosome_scafs_2_1e5bp.bed | egrep -vw "scaffold_6|scaffold_31|scaffold_48|scaffold_64|scaffold_103|scaffold_149|scaffold_158|scaffold_159|scaffold_423" > Code/Beds/autos_1e5bp_nosexseg.bed

vcftools --vcf Results/VCFs/${GROUP}_rm_snps_filt${i}.vcf --recode --recode-INFO-all --out Results/VCFs/${GROUP}_rm_snps_filt${i}_autos_1e5 --bed Code/Beds/autos_1e5bp_nosexseg.bed # make sure this bed file doesn't have sex segs!
mv Results/VCFs/${GROUP}_rm_snps_filt${i}_autos_1e5.recode.vcf Results/VCFs/${GROUP}_rm_snps_filt${i}_autos_1e5.vcf
# get sex-segs only (9scaf):

#cat Code/Beds/autosome_scafs_2_1e5bp.bed | egrep -w "scaffold_6|scaffold_31|scaffold_48|scaffold_64|scaffold_103|scaffold_149|scaffold_158|scaffold_159|scaffold_423" > Code/Beds/autos_1e5bp_sexseg.bed

vcftools --vcf Results/VCFs/${GROUP}_rm_snps_filt${i}.vcf --recode --recode-INFO-all --out Results/VCFs/${GROUP}_rm_snps_filt${i}_sexseg_1e5 --bed Code/Beds/autos_1e5bp_sexseg.bed
mv Results/VCFs/${GROUP}_rm_snps_filt${i}_sexseg_1e5.recode.vcf Results/VCFs/${GROUP}_rm_snps_filt${i}_sexseg_1e5.vcf

# get zchrom only (41scaf):

vcftools --vcf Results/VCFs/${GROUP}_rm_snps_filt${i}.vcf --recode --recode-INFO-all --out Results/VCFs/${GROUP}_rm_snps_filt${i}_zchrom_1e5 --bed Code/Beds/zchrom_1e5.bed
mv Results/VCFs/${GROUP}_rm_snps_filt${i}_zchrom_1e5.recode.vcf Results/VCFs/${GROUP}_rm_snps_filt${i}_zchrom_1e5.vcf

done
