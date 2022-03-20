#!/bin/bash
#SBATCH -p general
#SBATCH -n 16
#SBATCH -N 1
#SBATCH --mem 8000
#SBATCH -t 36:00:00
#SBATCH -J blastp
#SBATCH -o Logs/blastp_%j.out
#SBATCH -e Logs/blastp_%j.err

# July 5 2018

# perform blast protein search for known genes from other organisms in the MAKER output for BFHE

module load blast/2.6.0+-fasrc01

blastdb=Data/turkey-crow-flycatcher-chick-zebfinch-mouse-human-anolis-proteins.fa
query_seq=BFHE336010v2.maker.output/BFHE336010v2.all.maker.proteins.fasta
STUB=BFHE336010v2.maker.output/BFHE336010v2.all.maker.proteins.blastp.out

blastp -db $blastdb -query $query_seq -outfmt 6 -out ${STUB} -num_threads 16

