# Pixy
# Pi and Dxy estiation

https://pixy.readthedocs.io/en/latest/

######################
#### Installing pixy:

module load Anaconda3/2020.11

conda create --name pixy

conda activate pixy

conda config --add channels conda-forge

conda install -c conda-forge pixy

conda install -c bioconda htslib
######################

######################
#### creating the Allsites VCF using BCFtools (mpileup/call)

module load bcftools/1.5-fasrc02
module load vcftools/0.1.14-fasrc01

SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Pixy
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
cd $SCRATCH

# reference genome:
REF=BFHE_C1A_neoZ_v1
REFGENOME=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Data/${REF}.fasta

made a bamlist of all male samples (realigned bams from mapping to the subsetted ONT-Flye assembly (BFHE_C1A_neoZ_v1)

# samples
SAMPLES=males

# Variant calling to generate a VCF with ALL sites (not just variant)
# following guide here: https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html#generating-allsites-vcfs-using-bcftools-mpileup-call

bcftools mpileup -f $REFGENOME -b ${LAB}/Code/$SAMPLES.bamlist | bcftools call -m -Oz -f GQ -o VCF/$SAMPLES.vcf.gz

# filter the VCF using some generic thresholds (come back to this to be more thorough):
# use the code below...


#### FILTERING SNPS:

# Complete this:
# Code/filter_vcf.sh $SAMPLES

#!/bin/bash
# requires bcftools/bgzip/tabix and vcftools

# create a filtered VCF containing only invariant sites
vcftools --gzvcf VCF/$SAMPLES.vcf.gz \
--max-maf 0 \
--remove-indels \
--recode --stdout | bgzip -c > VCF/$SAMPLES.invar.vcf.gz

# create a filtered VCF containing only variant sites
vcftools --gzvcf VCF/$SAMPLES.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--recode --stdout | bgzip -c > VCF/$SAMPLES.var.vcf.gz

# index both vcfs using tabix
tabix VCF/$SAMPLES.invar.vcf.gz
tabix VCF/$SAMPLES.var.vcf.gz

# combine the two VCFs using bcftools concat
bcftools concat \
--allow-overlaps \
VCF/$SAMPLES.var.vcf.gz VCF/$SAMPLES.invar.vcf.gz \
-O z -o VCF/$SAMPLES.filt.vcf.gz



# Run pixy:

pixy --help


GROUP=subspecies
WIN=50000

pixy --stats pi dxy fst\
--vcf VCF/$SAMPLES.filt.vcf.gz \
--populations Code/$GROUP.txt \
--window_size $WIN \
--n_cores 1 \
--output_folder Results \
--output_prefix ${SAMPLES}_${GROUP}_win${WIN}

GROUP=pops

pixy --stats pi dxy fst\
--vcf VCF/$SAMPLES.filt.vcf.gz \
--populations Code/$GROUP.txt \
--window_size $WIN \
--n_cores 1 \
--output_folder Results \
--output_prefix ${SAMPLES}_${GROUP}_win${WIN}

################
#!/bin/bash
#SBATCH -p shared
#SBATCH -n 8
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 1-00:00
#SBATCH -J pixy
#SBATCH -o ./Logs/pixy_%j.out
#SBATCH -e ./Logs/pixy_%j.err

# run as sbatch Code/run_pixy.sbatch <SAMPLES> <GROUP> <RUN>

# where SAMPLES corresponds to the bamlist used to generate the vcf
# and GROUP corresponds to a txt file describing which population the samples belong to
# and RUN corresponds to a unique set of SNP filters

## variables:
SAMPLES=$1 # males
GROUP=$2 # pops or subspecies
RUN=$3 # 1
WIN=50000 # the window size for analysis (appended to output prefix)
winkb=50kb

## modules:
module load Anaconda3/2020.11
source activate pixy
module load tabix/0.2.6-fasrc01

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/Pixy
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy
cd $SCRATCH

## run it:
pixy --stats pi dxy fst \
--vcf ${LAB}/VCF/$SAMPLES.filt.$RUN.vcf.gz \
--populations ${LAB}/Code/$GROUP.txt \
--window_size $WIN \
--n_cores 48 \
--output_folder ${LAB}/Results \
--output_prefix ${SAMPLES}_filt${RUN}_${GROUP}_${winkb}



######
# TRANSFER RESULTS TO LOCAL:

scp -r jtb@login.rc.fas.harvard.edu:/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Pixy/Results/ ./









POPULATIONS:
01_KP_336010	KP
02_KP_335960	KP
03_KP_335961	KP
04_TE_336114	TE
05_TE_22778	TE
06_TE_22941	TE
09_TE_29457	TE
13_PNG_56279	PNG
14_PNG_56278	PNG
15_CY_57525	CY
16_CY_57401	CY
17_CY_57369	CY
18_CY_52131	CY
20_EC_76718	EC
21_EC_76649	EC
22_EC_76521	EC
23_EC_76599	EC
SUBSPECIES:
01_KP_336010	albi
02_KP_335960	albi
03_KP_335961	albi
04_TE_336114	albi
05_TE_22778	albi
06_TE_22941	albi
09_TE_29457	albi
13_PNG_56279	gris
14_PNG_56278	gris
15_CY_57525	gris
16_CY_57401	gris
17_CY_57369	gris
18_CY_52131	gris
20_EC_76718	cyan
21_EC_76649	cyan
22_EC_76521	cyan
23_EC_76599	cyan
BAMFILES:
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/01_KP_336010.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/02_KP_335960.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/03_KP_335961.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/04_TE_336114.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/05_TE_22778.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/06_TE_22941.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/09_TE_29457.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/13_PNG_56279.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/14_PNG_56278.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/15_CY_57525.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/16_CY_57401.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/17_CY_57369.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/18_CY_52131.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/20_EC_76718.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/21_EC_76649.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/22_EC_76521.realigned.bam
/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/Mapping2Variants/Results/BFHE_C1A_neoZ_v1/23_EC_76599.realigned.bam

