#!/bin/bash
# Code/submit_indelrealigner.sh
# for full genome data, consider making new sbatch script for high cov samples with more mem and time.
sbatch Code/run_indelrealigner.sbatch 09_TE_29457
sbatch Code/run_indelrealigner.sbatch 10_PNG_56165
sbatch Code/run_indelrealigner.sbatch 20_EC_76718
sbatch Code/run_indelrealigner.sbatch 21_EC_76649
sbatch Code/run_indelrealigner.sbatch 22_EC_76521
sbatch Code/run_indelrealigner.sbatch 23_EC_76599
sbatch Code/run_indelrealigner.sbatch 05_TE_22778
sbatch Code/run_indelrealigner.sbatch 06_TE_22941
sbatch Code/run_indelrealigner.sbatch 07_TE_23053
sbatch Code/run_indelrealigner.sbatch 08_TE_22774
sbatch Code/run_indelrealigner.sbatch 26_Mlun_76541
sbatch Code/run_indelrealigner.sbatch 02_KP_335960
sbatch Code/run_indelrealigner.sbatch 03_KP_335961
sbatch Code/run_indelrealigner.sbatch 24_EC_76676
sbatch Code/run_indelrealigner.sbatch 16_CY_57401
sbatch Code/run_indelrealigner.sbatch 17_CY_57369
sbatch Code/run_indelrealigner.sbatch 18_CY_52131
sbatch Code/run_indelrealigner.sbatch 11_PNG_56130
sbatch Code/run_indelrealigner.sbatch 12_PNG_56164
sbatch Code/run_indelrealigner.sbatch 13_PNG_56279
sbatch Code/run_indelrealigner.sbatch 14_PNG_56278
sbatch Code/run_indelrealigner.sbatch 15_CY_57525 # almost left out by mistake
sbatch Code/run_indelrealigner.sbatch 01_KP_336010
sbatch Code/run_indelrealigner.sbatch 04_TE_336114
sbatch Code/run_indelrealigner.sbatch 19_EC_76677
sbatch Code/run_indelrealigner.sbatch 25_Malb_76665
