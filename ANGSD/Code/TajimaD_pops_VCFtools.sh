## March 30 2022
## comparing Tajima's D estimates from ANGSD and Tajima D

cd 

module load vcftools/0.1.14-fasrc01

VCF_DIR=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_resources/VCFs
LISTS_DIR=/n/holylfs04/LABS/edwards_lab/Lab/jburley/genomics_Entomyzon/ANGSD/Code
OUT_DIR=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/ANGSD/Results

DATA=E_cyan_24_hf_snps_rm_autos_1e5bp_nosexseg
POP=KP

for POP in KP TE PNG CY EC
do
echo $POP
vcftools \
--gzvcf ${VCF_DIR}/${DATA}.vcf.gz \
--keep ${LISTS_DIR}/${POP}.txt \
--TajimaD 50000 --out ${OUT_DIR}/TajD_vcftools_win50kbp_${POP}
done


###  Transfer to local:
# scp 'jtb@login.rc.fas.harvard.edu:/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/ANGSD/Results/*Tajima.D' ./

