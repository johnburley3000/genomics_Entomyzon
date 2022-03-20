#!/bin/bash
#SBATCH -p general
#SBATCH -n 12
#SBATCH -N 1
#SBATCH --mem 30000
#SBATCH -t 20:00:00
#SBATCH -J angsd_pca_june2018_allsamps
#SBATCH -o Logs/angsd_pca_june2018_allsamps_%j.out
#SBATCH -e Logs/angsd_pca_june2018_allsamps_%j.err

# VARS:
N_samp=24
FILE=E_cyan_24_hf_snps_rm_autos_1e5bp_nosexseg_thin10k  #or E_cyan_24_hf_snps_rm_autos_1e5bp_nosexseg_thin50k

REGIONS=Code/autos_2_1e5bp_nosexsegs.txt
REFGENOME=Data/BFHE336010v2.fasta # (link)

BAMLIST=Code/honeyeaters_${N_samp}.bamlist
SITES=Data/${FILE}.bed
RUN=${FILE}_nsamp${N_samp}

#Use ANGSD 9.12
module load centos6/0.0.1-fasrc01 gcc/4.8.2-fasrc01 ngsTools/20170201-fasrc01

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

