#!/bin/bash
# PCA for autosomes. purpose of running multi batches is to identify a group of scaffolds that is causing the populations to be split by gender.
# using fewer samples to make it an easier process - nope, not anymore, it was too had to tell if separating because of sex with only 1 sex per pop.

#SBATCH -p general
#SBATCH -n 12
#SBATCH -N 1
#SBATCH --mem 45000
#SBATCH -t 30:00:00
#SBATCH -J angsd_pca_mult
#SBATCH -o Logs/angsd_pca_mult_%j.out
#SBATCH -e Logs/angsd_pca_multi_%j.err

# VARS:

REGS=$1
#SCAF=$2

BAMLIST=Code/honeyeaters_24.bamlist
REFGENOME=Data/BFHE336010v2.fasta # (link)
REGIONS=Code/${REGS}.txt
SITES=Code/E_cyan_snps_rm_autos_filt_1e5bp.bed
RUN=${REGS}_2
N_samp=24

#Use ANGSD 9.12
module load gcc/4.8.2-fasrc01 ngsTools/20170201-fasrc01

#angsd sites index $SITES

# run angsd to do: (variant calling and estimate genotype LHs?) this will be faster if limit to the chroms used, using -rf option.
angsd -bam $BAMLIST -ref $REFGENOME -uniqueOnly 1 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -rf $REGIONS -sites $SITES \
-nThreads 12 -out Results/PCA/${RUN} -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1 -SNP_pval 1e-6 -doGeno 32 -doPost 1

# to only run it for one scaffold, do -r scaffold_$SCAF. to do many scafs, use -rf and direct to file called $REGS

gunzip Results/PCA/${RUN}.geno.gz
gunzip Results/PCA/${RUN}.mafs.gz

N_SITES=`cat Results/PCA/${RUN}.mafs | tail -n+2 | wc -l`
echo $N_SITES

###### run ngsTools
#Have to reload ngsTools
module load ngsTools/0.615-fasrc01
ngsCovar -probfile Results/PCA/${RUN}.geno -outfile Results/PCA/${RUN}.covar \
-nind $N_samp -minmaf 0.05 -nsites $N_SITES

# be sure to change -nind !

###### PLOT PCA:
# set  environment
NGSTOOLS=/n/sw/fasrcsw/apps/Core/ngsTools/0.615-fasrc01
module load R/3.3.1-fasrc01

Rscript -e 'write.table(cbind(seq(1,24),c("01_KP_336010","02_KP_335960","03_KP_335961","04_TE_336114","05_TE_22778","06_TE_22941","07_TE_23053","08_TE_22774","09_TE_29457","10_PNG_56165","11_PNG_56130","12_PNG_56164","13_PNG_56279","14_PNG_56278","15_CY_57525","16_CY_57401","17_CY_57369","18_CY_52131","19_EC_76677","20_EC_76718","21_EC_76649","22_EC_76521","23_EC_76599","24_EC_76676"),c("KP","KP","KP","TE","TE","TE","TE","TE","TE","PNG","PNG","PNG","PNG","PNG","CY","CY","CY","CY","EC","EC","EC","EC","EC","EC")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="Results/PCA/sample_annotations24.clst", quote=F)'

#This makes a different annotation table to delineate sex
#Rscript -e 'write.table(cbind(seq(1,24),c("01_KP_336010","02_KP_335960","03_KP_335961","04_TE_336114","05_TE_22778","06_TE_22941","07_TE_23053","08_TE_22774","09_TE_29457","10_PNG_56165","11_PNG_56130","12_PNG_56164","13_PNG_56279","14_PNG_56278","15_CY_57525","16_CY_57401","17_CY_57369","18_CY_52131","19_EC_76677","20_EC_76718","21_EC_76649","22_EC_76521","23_EC_76599","24_EC_76676"),c("M","M","M","M","M","M","F","F","M","F","F","F","M","M","M","M","M","M","F","M","M","M","M","F")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="Results/PCA/sample_annotations24_sex.clst", quote=F)'
#this makes an annotation table for only 8 samps - not used anymore...
#Rscript -e 'write.table(cbind(seq(1,8),c("08_TE_22774","09_TE_29457","11_PNG_56130","12_PNG_56164","13_PNG_56279","14_PNG_56278","19_EC_76677","20_EC_76718"),c("TE","TE","PNG","PNG","PNG","PNG","EC","EC")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="Results/PCA/sample_annotations8.clst", quote=F)'

# now call the script to run PCA and print plot:
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 1-2 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c1-2.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 3-4 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c3-4.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 5-6 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c5-6.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 7-8 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c7-8.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 9-10 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c9-10.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 11-12 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c11-12.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 13-14 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c13-14.pca.pdf
#Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 1-6 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c11-12.pca.pdf
#Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 1-6 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c13-14.pca.pdf
 
