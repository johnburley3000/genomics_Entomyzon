#!/bin/bash
# submits a pipe of analyses for each set of PE fq files. note different sbatch script for high/low cov
DIR=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/ReadTrimming/Results
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID1 BFHE3_220 CTTGTA 1 C9ECWANXX 1 20161121 01_KP_336010
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID2 BFHE3_220 CTTGTA 2 C9DJ6ANXX 2 20161121 01_KP_336010
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID3 BFHE3_220 CTTGTA 3 C9DJ6ANXX 3 20161121 01_KP_336010
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID4 BFHE3_220 CTTGTA 4 C9U28ANXX 4 20161128 01_KP_336010
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID1 BFHE4_220 CAGCTT 1 C9ECWANXX 1 20161121 04_TE_336114
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID2 BFHE4_220 CAGCTT 2 C9DJ6ANXX 2 20161121 04_TE_336114
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID3 BFHE4_220 CAGCTT 3 C9DJ6ANXX 3 20161121 04_TE_336114
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID4 BFHE4_220 CAGCTT 4 C9U28ANXX 4 20161128 04_TE_336114
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID1 BFHE5_220 TTCGAA 1 C9ECWANXX 1 20161121 19_EC_76677
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID2 BFHE5_220 TTCGAA 2 C9DJ6ANXX 2 20161121 19_EC_76677
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID3 BFHE5_220 TTCGAA 3 C9DJ6ANXX 3 20161121 19_EC_76677
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID4 BFHE5_220 TTCGAA 4 C9U28ANXX 4 20161128 19_EC_76677
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID1 WTHE1_220 CTCACG 1 C9ECWANXX 1 20161121 25_Malb_76665
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID2 WTHE1_220 CTCACG 2 C9DJ6ANXX 2 20161121 25_Malb_76665
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID3 WTHE1_220 CTCACG 3 C9DJ6ANXX 3 20161121 25_Malb_76665
sbatch Code/run_fastqc2readybam_highcov.sbatch ${DIR}/LaneID4 WTHE1_220 CTCACG 4 C9U28ANXX 4 20161128 25_Malb_76665
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 1_CY_29457 ACGGTC 1 CAKUPANXX 5 20170427 09_TE_29457
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 1_CY_29457 ACGGTC 2 CAYTEANXX 6 20170519 09_TE_29457
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 1_CY_29457 ACGGTC 3 CAYTEANXX 7 20170519 09_TE_29457
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 1_CY_29457 ACGGTC 4 CB0VWANXX 8 20170530 09_TE_29457
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 10_PNG_56165 CTTGAC 1 CAKUPANXX 5 20170427 10_PNG_56165
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 10_PNG_56165 CTTGAC 2 CAYTEANXX 6 20170519 10_PNG_56165
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 10_PNG_56165 CTTGAC 3 CAYTEANXX 7 20170519 10_PNG_56165
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 10_PNG_56165 CTTGAC 4 CB0VWANXX 8 20170530 10_PNG_56165
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 11_NSW_76718 CATTAG 1 CAKUPANXX 5 20170427 20_EC_76718
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 11_NSW_76718 CATTAG 2 CAYTEANXX 6 20170519 20_EC_76718
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 11_NSW_76718 CATTAG 3 CAYTEANXX 7 20170519 20_EC_76718
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 11_NSW_76718 CATTAG 4 CB0VWANXX 8 20170530 20_EC_76718
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 12_NSW_76649 GGACGG 1 CAKUPANXX 5 20170427 21_EC_76649
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 12_NSW_76649 GGACGG 2 CAYTEANXX 6 20170519 21_EC_76649
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 12_NSW_76649 GGACGG 3 CAYTEANXX 7 20170519 21_EC_76649
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 12_NSW_76649 GGACGG 4 CB0VWANXX 8 20170530 21_EC_76649
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 13_NSW_76521 CGATGT 1 CAKUPANXX 5 20170427 22_EC_76521
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 13_NSW_76521 CGATGT 2 CAYTEANXX 6 20170519 22_EC_76521
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 13_NSW_76521 CGATGT 3 CAYTEANXX 7 20170519 22_EC_76521
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 13_NSW_76521 CGATGT 4 CB0VWANXX 8 20170530 22_EC_76521
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 14_NSW_76599 TGACCA 1 CAKUPANXX 5 20170427 23_EC_76599
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 14_NSW_76599 TGACCA 2 CAYTEANXX 6 20170519 23_EC_76599
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 14_NSW_76599 TGACCA 3 CAYTEANXX 7 20170519 23_EC_76599
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 14_NSW_76599 TGACCA 4 CB0VWANXX 8 20170530 23_EC_76599
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 15_NT_22778 GCCAAT 1 CAKUPANXX 5 20170427 05_TE_22778
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 15_NT_22778 GCCAAT 2 CAYTEANXX 6 20170519 05_TE_22778
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 15_NT_22778 GCCAAT 3 CAYTEANXX 7 20170519 05_TE_22778
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 15_NT_22778 GCCAAT 4 CB0VWANXX 8 20170530 05_TE_22778
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 16_NT_22941 TACAGC 1 CAKUPANXX 5 20170427 06_TE_22941
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 16_NT_22941 TACAGC 2 CAYTEANXX 6 20170519 06_TE_22941
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 16_NT_22941 TACAGC 3 CAYTEANXX 7 20170519 06_TE_22941
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 16_NT_22941 TACAGC 4 CB0VWANXX 8 20170530 06_TE_22941
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 17_NT_23053 ATCACG 1 CAKUPANXX 5 20170427 07_TE_23053
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 17_NT_23053 ATCACG 2 CAYTEANXX 6 20170519 07_TE_23053
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 17_NT_23053 ATCACG 3 CAYTEANXX 7 20170519 07_TE_23053
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 17_NT_23053 ATCACG 4 CB0VWANXX 8 20170530 07_TE_23053
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 18_NT_22774 TTAGGC 1 CAKUPANXX 5 20170427 08_TE_22774
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 18_NT_22774 TTAGGC 2 CAYTEANXX 6 20170519 08_TE_22774
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 18_NT_22774 TTAGGC 3 CAYTEANXX 7 20170519 08_TE_22774
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 18_NT_22774 TTAGGC 4 CB0VWANXX 8 20170530 08_TE_22774
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 19_mlun_76541 ACTTGA 1 CAKUPANXX 5 20170427 26_Mlun_76541
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 19_mlun_76541 ACTTGA 2 CAYTEANXX 6 20170519 26_Mlun_76541
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 19_mlun_76541 ACTTGA 3 CAYTEANXX 7 20170519 26_Mlun_76541
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 19_mlun_76541 ACTTGA 4 CB0VWANXX 8 20170530 26_Mlun_76541
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 2_CY_57525 TTCGAA 1 CAKUPANXX 5 20170427 15_CY_57525
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 2_CY_57525 TTCGAA 2 CAYTEANXX 6 20170519 15_CY_57525
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 2_CY_57525 TTCGAA 3 CAYTEANXX 7 20170519 15_CY_57525
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 2_CY_57525 TTCGAA 4 CB0VWANXX 8 20170530 15_CY_57525
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 22_WA_335960 ATGAGC 1 CAKUPANXX 5 20170427 02_KP_335960
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 22_WA_335960 ATGAGC 2 CAYTEANXX 6 20170519 02_KP_335960
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 22_WA_335960 ATGAGC 3 CAYTEANXX 7 20170519 02_KP_335960
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 22_WA_335960 ATGAGC 4 CB0VWANXX 8 20170530 02_KP_335960
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 23_WA_335961 AGTCAA 1 CAKUPANXX 5 20170427 03_KP_335961
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 23_WA_335961 AGTCAA 2 CAYTEANXX 6 20170519 03_KP_335961
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 23_WA_335961 AGTCAA 3 CAYTEANXX 7 20170519 03_KP_335961
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 23_WA_335961 AGTCAA 4 CB0VWANXX 8 20170530 03_KP_335961
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 24_NSW_76676 AGTTCC 1 CAKUPANXX 5 20170427 24_EC_76676
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 24_NSW_76676 AGTTCC 2 CAYTEANXX 6 20170519 24_EC_76676
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 24_NSW_76676 AGTTCC 3 CAYTEANXX 7 20170519 24_EC_76676
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 24_NSW_76676 AGTTCC 4 CB0VWANXX 8 20170530 24_EC_76676
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 3_CY_57401 AGGTAC 1 CAKUPANXX 5 20170427 16_CY_57401
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 3_CY_57401 AGGTAC 2 CAYTEANXX 6 20170519 16_CY_57401
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 3_CY_57401 AGGTAC 3 CAYTEANXX 7 20170519 16_CY_57401
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 3_CY_57401 AGGTAC 4 CB0VWANXX 8 20170530 16_CY_57401
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 4_CY_57369 TGTACG 1 CAKUPANXX 5 20170427 17_CY_57369
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 4_CY_57369 TGTACG 2 CAYTEANXX 6 20170519 17_CY_57369
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 4_CY_57369 TGTACG 3 CAYTEANXX 7 20170519 17_CY_57369
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 4_CY_57369 TGTACG 4 CB0VWANXX 8 20170530 17_CY_57369
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 5_CY_52131 CCATGT 1 CAKUPANXX 5 20170427 18_CY_52131
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 5_CY_52131 CCATGT 2 CAYTEANXX 6 20170519 18_CY_52131
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 5_CY_52131 CCATGT 3 CAYTEANXX 7 20170519 18_CY_52131
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 5_CY_52131 CCATGT 4 CB0VWANXX 8 20170530 18_CY_52131
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 6_PNG_56130 ATGCGC 1 CAKUPANXX 5 20170427 11_PNG_56130
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 6_PNG_56130 ATGCGC 2 CAYTEANXX 6 20170519 11_PNG_56130
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 6_PNG_56130 ATGCGC 3 CAYTEANXX 7 20170519 11_PNG_56130
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 6_PNG_56130 ATGCGC 4 CB0VWANXX 8 20170530 11_PNG_56130
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 7_PNG_56164 TTAGCT 1 CAKUPANXX 5 20170427 12_PNG_56164
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 7_PNG_56164 TTAGCT 2 CAYTEANXX 6 20170519 12_PNG_56164
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 7_PNG_56164 TTAGCT 3 CAYTEANXX 7 20170519 12_PNG_56164
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 7_PNG_56164 TTAGCT 4 CB0VWANXX 8 20170530 12_PNG_56164
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 8_PNG_56279 GCCATA 1 CAKUPANXX 5 20170427 13_PNG_56279
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 8_PNG_56279 GCCATA 2 CAYTEANXX 6 20170519 13_PNG_56279
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 8_PNG_56279 GCCATA 3 CAYTEANXX 7 20170519 13_PNG_56279
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 8_PNG_56279 GCCATA 4 CB0VWANXX 8 20170530 13_PNG_56279
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID5 9_PNG_56278 AGTGCC 1 CAKUPANXX 5 20170427 14_PNG_56278
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID6 9_PNG_56278 AGTGCC 2 CAYTEANXX 6 20170519 14_PNG_56278
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID7 9_PNG_56278 AGTGCC 3 CAYTEANXX 7 20170519 14_PNG_56278
sbatch Code/run_fastqc2readybam_lowcov.sbatch ${DIR}/LaneID8 9_PNG_56278 AGTGCC 4 CB0VWANXX 8 20170530 14_PNG_56278
