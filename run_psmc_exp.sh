#!/bin/bash
#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 30000
#SBATCH -t 1-00:00
#SBATCH -J psmc_expNT1
#SBATCH -o psmc_expNT1_%j.out
#SBATCH -e psmc_expNT1_%j.err
#SBATCH --constrain=holyib
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john.burley@evobio.eu

module load psmc/0.6.5-fasrc01 gnuplot/4.6.4-fasrc01

for N in 25 50 100
do
for t in 5 15 30
do
for r in 1 5 10 20 
do

psmc -N${N} -t${t} -r${r} -p "4+25*2+4+6" -o BFHE_NT336114_N${N}_t${t}_r${r}.psmc BFHE_NT336114.psmcfa
psmc_plot.pl -u 1.4e-09 -g 2 -p -Y100 -x 10000 -X 100000000 BFHE_NT336114_N${N}_t${t}_r${r} BFHE_NT336114_N${N}_t${t}_r${r}.psmc

done
done
done
