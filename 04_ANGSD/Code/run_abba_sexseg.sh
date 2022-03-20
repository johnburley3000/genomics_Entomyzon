ANGSD=/n/home01/jtb/apps/ngsTools/ngsTools/angsd/angsd
REFGENOME=Data/BFHE336010v2.fasta # (link)
ANC=Results/Fasta/Mel_albo_ANGSD_20170613.fasta
REGIONS=autos_2_1e5bp_sexseg # works with -rf
SITES=Code/E_cyan_snps_rm_autos_filt_1e5bp.bed 
JK=/n/home01/jtb/apps/ngsTools/ngsTools/angsd/R/jackKnife.R
INDS=D_test1

module load R/3.3.1-fasrc01

$ANGSD -doAbbababa 1 -bam Code/D_test1.filelist -out Results/Abba/D_test1_${REGIONS} -doCounts 1 \
-anc $ANC -minMapQ 30 -minQ 30 -blockSize 100000 -rf Code/${REGIONS}.txt -only_proper_pairs 0 -remove_bads 1

Rscript $JK file=Results/Abba/D_test1_${REGIONS}.abbababa indNames=Code/D_test1.namelist outfile=Results/Abba/D_test1_${REGIONS}

