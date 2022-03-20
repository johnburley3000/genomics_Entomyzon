#!/bin/bash
# caution: this had some edits because it didn't run smoothly the first time. if re-running, give it a once over.
# Usage: sbatch Code/run_PCA.sh <N_samp> <N_scaf> (see options below)
#SBATCH -p general
#SBATCH -n 12
#SBATCH -N 1
#SBATCH --mem 100000
#SBATCH -t 30:00:00
#SBATCH -J angsd_pca
#SBATCH -o Logs/angsd_pca_%j.out
#SBATCH -e Logs/angsd_pca_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

# does Logs exist?

# Data links:
#ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/A_ref_genome/Results/* Data/.
#ln -s /n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal/03_fastqc2readybams/Results/*realigned* Data/.
# NOTE: I renamed all of the bam and bai files so that the number order groups according to populations:
# i.e. cp -a BFHE3_220.realigned.bai 01_KP_336010.realigned.bai
# see the renaming script in Code/rename_files

# VARS:

N_samp=$1 #17, 24 or 26
N_scaf=$2 # 0to9 0to999, autos, zchrom

BAMLIST=Code/honeyeaters_${N_SAMP}.bamlist
REFGENOME=Data/BFHE336010v2.fasta #check that the link exists!
REGIONS=Code/reg_scaf${N_scaf}.txt
RUN=samp_${N_samp}_scaf_${N_scaf}
# previous: with_og_1 used 1000scaf; no_og_1000scaf
# RUN will identify the files in results. Use IDs such as with_og_1 (with outgroups included, version 1) or without_og_1


#Use ANGSD 9.12
module load gcc/4.8.2-fasrc01 ngsTools/20170201-fasrc01

# run angsd to do: (variant calling and estimate genotype LHs?)
angsd -bam $BAMLIST -ref $REFGENOME -uniqueOnly 1 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -rf $REGIONS \
-nThreads 12 -out Results/PCA/${RUN} -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1 -SNP_pval 1e-6 -doGeno 32 -doPost 1

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

# create a cluster-like file defining the labelling (population) for each sample
# this only needs to be run once
# the R script needs to be modified depending on the samples used!
 
#OLD - Rscript -e 'write.table(cbind(seq(1,26),c("10_PNG_56165","11_NSW_76718","12_NSW_76649","13_NSW_76521","14_NSW_76599","15_NT_22778","16_NT_22941","17_NT_23053","18_NT_22774","19_mlun_76541","1_CY_29457","22_WA_335960","23_WA_335961","24_NSW_76676","2_CY_57525","3_CY_57401","4_CY_57369","5_CY_52131","6_PNG_56130","7_PNG_56164","8_PNG_56279","9_PNG_56278"),c("PNG","NSW","NSW","NSW","NSW","NT","NT","NT","NT","mlun","CY","WA","WA","NSW","CY","CY","CY","CY","PNG","PNG","PNG","PNG")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="results_pca/sample_annot_1.clst", quote=F)'

# for 26 samples
Rscript -e 'write.table(cbind(seq(1,26),c("01_KP_336010","02_KP_335960","03_KP_335961","04_TE_336114","05_TE_22778","06_TE_22941","07_TE_23053","08_TE_22774","09_TE_29457","10_PNG_56165","11_PNG_56130","12_PNG_56164","13_PNG_56279","14_PNG_56278","15_CY_57525","16_CY_57401","17_CY_57369","18_CY_52131","19_EC_76677","20_EC_76718","21_EC_76649","22_EC_76521","23_EC_76599","24_EC_76676","25_Malb_76665","26_Mlun_76541"),c("KP","KP","KP","TE","TE","TE","TE","TE","TE","PNG","PNG","PNG","PNG","PNG","CY","CY","CY","CY","EC","EC","EC","EC","EC","EC","Malb","Mlun")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="Results/PCA/sample_annotations26.clst", quote=F)'

# Rscript for 24 samples (no outgroups)
#Rscript -e 'write.table(cbind(seq(1,24),c("01_KP_336010","02_KP_335960","03_KP_335961","04_TE_336114","05_TE_22778","06_TE_22941","07_TE_23053","08_TE_22774","09_TE_29457","10_PNG_56165","11_PNG_56130","12_PNG_56164","13_PNG_56279","14_PNG_56278","15_CY_57525","16_CY_57401","17_CY_57369","18_CY_52131","19_EC_76677","20_EC_76718","21_EC_76649","22_EC_76521","23_EC_76599","24_EC_76676"),c("KP","KP","KP","TE","TE","TE","TE","TE","TE","PNG","PNG","PNG","PNG","PNG","CY","CY","CY","CY","EC","EC","EC","EC","EC","EC")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="Results/PCA/sample_annotations24.clst", quote=F)'


# now call the script to run PCA and print plot:
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 1-2 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c1-2.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 1-3 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c1-3.pca.pdf
Rscript Code/plotPCA_ed.R -i Results/PCA/${RUN}.covar -c 2-3 -a Results/PCA/sample_annotations${N_samp}.clst -o Results/PCA/${RUN}_c2-3.pca.pdf
# if doesn't print labels, check the unedited R script.
