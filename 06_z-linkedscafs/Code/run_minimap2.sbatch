#!/bin/bash
# J Burley 
# Date:July18 2017
# Purpose:Run minimap2 

#SBATCH -p general
#SBATCH -n 3
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 6:00:00
#SBATCH -J minimap2
#SBATCH -o Logs/minimap2_%j.out
#SBATCH -e Logs/minimap2_%j.err

# Following these instructions: https://github.com/lh3/minimap2

MINIMAP2=/n/home01/jtb/apps/minimap2/minimap2/minimap2

INSAMPLE1=BFHE336010v2
INSAMPLE2=Tgut_324

OUTDIR=Results/Minimap2

# 1 Make index and dump to file (-d)
$MINIMAP2 -d Data/${INSAMPLE1}.mmi Data/${INSAMPLE1}.fasta
$MINIMAP2 -d Data/${INSAMPLE2}.mmi Data/GCF_000151805.1_Taeniopygia_guttata-3.2.4_genomic.fna

# not sure if I need to index the Tgut fasta.
# removed the -x preset which is used for example online

# 2 Map long reads against a reference genome:
$MINIMAP2 -t 3 Data/${INSAMPLE1}.mmi Data/GCF_000151805.1_Taeniopygia_guttata-3.2.4_genomic.fna > ${OUTDIR}/${INSAMPLE1}_vs_${INSAMPLE2}.paf

# -a output in SAM format. check out the PAF output: https://github.com/lh3/miniasm/blob/master/PAF.md



