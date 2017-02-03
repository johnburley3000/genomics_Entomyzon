#!/bin/bash

#SBATCH -p general
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 5-00:00
#SBATCH -J prep_psmc
#SBATCH -o ./logs/prep_psmc_%j.out
#SBATCH -e ./logs/prep_psmc_%j.err
#SBATCH --constrain=holyib
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

module load samtools/1.2-fasrc01
module load bcftools/1.2-fasrc01

SAMPLE=$1

samtools mpileup -Q 30 -q 30 -u -v \
-f ../BFHE_WA336010.fasta ../../PSMC_home/bams/${SAMPLE}-f.bam |
bcftools call -c |
vcfutils.pl vcf2fq -d 10 -D 50 -Q 30 > ${SAMPLE}_dip_ts.fq

module load psmc/0.6.5-fasrc01
module load gnuplot/4.6.4-fasrc01

/n/home01/jtb/apps/psmc/utils/fq2psmcfa -q20 ${SAMPLE}_dip_ts.fq > ${SAMPLE}.psmcfa
psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o ${SAMPLE}.psmc ${SAMPLE}.psmcfa

/n/home01/jtb/apps/psmc/utils/psmc_plot.pl -u 3.83e-08 -g 1 -p ${SAMPLE}_plot ${SAMPLE}.psmc

