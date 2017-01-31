#!/bin/bash

#SBATCH -p general
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 5-00:00
#SBATCH -J prep_psmc
#SBATCH -o ./logs/prep_psmc_%A_%a.out
#SBATCH -e ./logs/prep_psmc_%A_%a.err
#SBATCH --constrain=holyib
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

module load samtools/1.2-fasrc01  
module load bcftools/1.2-fasrc01

#samtools mpileup -C50 -uf ../BFHE_WA336010.fasta ../../PSMC_home/bams/BFHE_WA336010-f.bam | bcftools view -c 20 | vcfutils.pl vcf2fq -d 20 -D 100 | gzip > BFHE_WA336010_dip.fq.gz

SAMPLE=$1

samtools mpileup -C50 -uf ../BFHE_WA336010.fasta ../../PSMC_home/bams/${SAMPLE}-f.bam | bcftools view -c 10 | vcfutils.pl vcf2fq -d 10 -D 50 | gzip > ${SAMPLE}_dip.fq.gz

