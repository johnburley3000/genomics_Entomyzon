June 28 2017

# Make  new VCF file with the reduced SNP set:
vcftools --vcf Results/VCFs/E_cyan_snps_rm_autos_filt.vcf --recode --recode-INFO-all --out Results/VCFs/E_cyan_snps_rm_autos_filt --bed Code/Beds/autosome_scafs_2_1e5bp.bed
mv Results/VCFs/E_cyan_snps_rm_autos_filt.recode.vcf Results/VCFs/E_cyan_snps_rm_autos_filt.vcf


#### converting VCF to PLINK

#nFirst, have to change the formatting of the VCF file - the VCFtools converter can't understand scaffold names other than numbers

# So, use awk to output a new VCF with scaffold_0 replaced by 0, and soforth
awk '{gsub(/^scaffold_/,""); print}' Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.vcf > Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_noscaf.vcf

# Second, use vcftools to convert .vcf into a .ped and .map

FILE=Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp_noscaf.vcf

vcftools --vcf Results/PLINK/${FILE}.vcf --plink --chr scaffold_0 --out Results/PLINK/$FILE

### converting VCF to bed file:

# 3 - MAKE BED FILES FOR EACH FINAL SNP SET, TO BE USED IN ANGSD ANALYSES
# convert to bed, extract only col 1-3, copy to ANGSD dir, and give unique date.
module load gcc/6.3.0-fasrc01 bedops/2.4.26-fasrc01

test:

cut -f 1-3 Results/VCFs/E_cyan_snps_rm_autos_filt_1e5bp.recode.vcf > tmp/test.bed

cut -f 1-3 Results/VCFs/E_cyan_snps_rm_${i}.bed > Results/VCFs/E_cyan_snps_rm_${i}.bed
DATE=`date +%Y%m%d`
cp -r Results/VCFs/E_cyan_snps_rm_${i}.bed /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/04_ANGSD/Code/E_cyan_snps_rm_${i}_${DATE}.bed

