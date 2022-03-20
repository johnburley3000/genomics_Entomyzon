#!/bin/bash
# Date: June 12 2017
# purpose samtools idxstats takes a bam (with index bai) and prints out a tab delim file consisting of ref sequence name (i.e. scaffold_0), seq length, # mapped reads, # unmapped reads. This output can be used to identify z-linked scaffolds by comparing coverage per scaffold for female:male samples.

for SAMPLE in 01_KP_336010 \
02_KP_335960 \
03_KP_335961 \
04_TE_336114 \
05_TE_22778 \
06_TE_22941 \
07_TE_23053 \
08_TE_22774 \
09_TE_29457 \
10_PNG_56165 \
11_PNG_56130 \
12_PNG_56164 \
13_PNG_56279 \
14_PNG_56278 \
15_CY_57525 \
16_CY_57401 \
17_CY_57369 \
18_CY_52131 \
19_EC_76677 \
20_EC_76718 \
21_EC_76649 \
22_EC_76521 \
23_EC_76599 \
24_EC_76676 \
25_Malb_76665 \
26_Mlun_76541
do
samtools idxstats Data/${SAMPLE}.realigned.bam > Results/idxstats_${SAMPLE}.txt
done
