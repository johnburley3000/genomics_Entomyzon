# Nov 21 2021
# Tajima's D
# goal:
# compare Tajimas D estimated using 2 methods:
# 1 using the genome-wide autosomal SNPs for all samples mapped to Assembly 1 (ANGSD)
# 2 using Chr 1A SNPs for male samples mapped to assembly 2 (VCFtools)

require(dplyr)
require(data.table)
library(tidyverse)
library(ggplot2)
library(patchwork)

## 1. Get data from ANGSD output:
#####

PATH1="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/neoZ_scans/Data/ThetaStats_2019/"

# read file path
all_paths <-
  list.files(path = PATH1,
             pattern = "*.pestPG",
             full.names = TRUE)
# read file content
all_content <-
  all_paths %>%
  lapply(read.delim,
         header = TRUE,
         sep = "\t")
# read file name
all_filenames <- all_paths %>%
  basename() %>%
  as.list()
# combine file content list and file name list
all_lists <- mapply(c, all_content, all_filenames, SIMPLIFY = FALSE)
# unlist all lists and change column name
all_result <- rbindlist(all_lists, fill = T)
# change column name
names(all_result)[15] <- "File"
# Now we have one big data table:
remove(all_content, all_lists, all_filenames, all_paths)

# Now create new columns for the variables of interest, extracting from file names:
df1 <- all_result %>%
  mutate(Pop = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "KP", x = File) ~ "KP",
    grepl(pattern = "TE", x = File) ~ "TE",
    grepl(pattern = "PNG", x = File) ~ "PNG",
    grepl(pattern = "CY", x = File) ~ "CY",
    grepl(pattern = "EC", x = File) ~ "EC",
  )) %>%
  mutate(Chrom_region = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "AUTOS", x = File) ~ "autosome",
    grepl(pattern = "NEOZ", x = File) ~ "add_Z_NR",
    grepl(pattern = "ZCHROM", x = File) ~ "anc_Z"
  )) %>%
  mutate(Seq_type = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "CDS", x = File) ~ "CDS",
    grepl(pattern = "intergenic", x = File) ~ "intergenic",
    grepl(pattern = "intron", x = File) ~ "intron"
  ))

remove(all_result)
#####

#####
Taj_ANGSD <- df1 %>%
  filter(Chrom_region=="autosome") %>%
  filter(Seq_type=="intergenic") %>%
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = Pop, y = Tajima, color = Pop)) +
  geom_boxplot(notch = TRUE) +
  coord_cartesian(ylim = c(-2.5, 3)) +  
  ylab("Tajima's D") +
  ggtitle("Estimated from all autosomal intergenic SNPS (Assembly 1), \nall samples, using ANGSD ThetStat") +
  theme_linedraw()

Taj_ANGSD

pi_ANGSD <- df1 %>%
  filter(Chrom_region=="autosome") %>%
  filter(Seq_type=="intergenic") %>%
  #group_by(Pop) %>% 
  mutate(tP_Norm = (tP/50000)/max((tP/50000))) %>% 
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = Pop, y = tP_Norm, color = Pop)) +
  geom_boxplot(notch = TRUE) +
  #coord_cartesian(ylim = c(-2.5, 3)) +  
  ylab("tP (normalized") +
  ggtitle("Estimated from all autosomal intergenic SNPS (Assembly 1), \nall samples, using ANGSD ThetStat") +
  theme_linedraw()

pi_ANGSD

## 2. Get data from VCFtools output:

PATH2="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/Pixy/Data/"

# read file path
all_paths <-
  list.files(path = PATH2,
             pattern = "*50Kb.Tajima.D",
             full.names = TRUE)
# read file content
all_content <-
  all_paths %>%
  lapply(read.delim,
         header = TRUE,
         sep = "\t")
# read file name
all_filenames <- all_paths %>%
  basename() %>%
  as.list()
# combine file content list and file name list
all_lists <- mapply(c, all_content, all_filenames, SIMPLIFY = FALSE)
# unlist all lists and change column name
all_result <- rbindlist(all_lists, fill = T)
# change column name
names(all_result)[5] <- "File"
# Now we have one big data table:
remove(all_content, all_lists, all_filenames, all_paths)

# Now create new columns for the variables of interest, extracting from file names:
df2 <- all_result %>%
  mutate(Pop = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "KP", x = File) ~ "KP",
    grepl(pattern = "TE", x = File) ~ "TE",
    grepl(pattern = "PNG", x = File) ~ "PNG",
    grepl(pattern = "CY", x = File) ~ "CY",
    grepl(pattern = "EC", x = File) ~ "EC",
  )) 
remove(all_result)

Taj_vcftools <- df2 %>%
  filter(CHROM %in% c("scaffold_335_segment0", "scaffold_335_segment1", "contig_1888_segment0")) %>%
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = Pop, y = TajimaD, color = Pop)) +
  geom_boxplot(notch = TRUE) +
  coord_cartesian(ylim = c(-2.5, 3)) +  
  ylab("Tajima's D") +
  ggtitle("Estimated from Chr 1A (Assembly 2), \nmale samples, using vcftools") +
  theme_linedraw()

Taj_vcftools

Taj_ANGSD + Taj_vcftools

#####
# Scan Tajima's D along the neo-Z:

Taj_scan <- df2 %>%
  mutate(Chr = case_when(
    grepl(pattern = "contig_4", x = CHROM)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = CHROM) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = CHROM) ~ "Chr 1A")
  ) %>%
  drop_na() %>%
  group_by(Chr, BIN_START) %>%
  summarise(win_mid_mb = mean((BIN_START+25000)/1000000),
            mean_Taj = mean(TajimaD)) %>%
  ggplot(aes(x = win_mid_mb, y = mean_Taj)) +
  geom_area(show.legend=T) +
  #geom_point() +
  #facet_wrap('chr', scales = 'fixed', nrow = 1) + 
  facet_grid(~ Chr, scales = "free_x") +
  scale_x_continuous(name = "genomic position (Mbp)")

Taj_scan
  
# MAKE TABLE FOR MANUSCRIPT
#####

# Goal: 
# Show pi and Tajima D for populations including 95% CI
# for pi, get data calculated using pixy for males only
# for Tajima, get data from genome-wide SNPs calculated using ANGSD
# Probably easiest to make separate tables, then join in excel

# 1 Tajima D from ANGSD

library(gmodels)


Tajima_table <- df1 %>%
  filter(Seq_type == "intergenic") %>%
  filter(nSites > 20) %>%
  drop_na() %>%
  group_by(Pop, Chrom_region) %>%
  summarise(#mean = ci(Tajima)[1], 
                      #lowCI = ci(Tajima)[2],
                      #hiCI = ci(Tajima)[3], 
                      #sd = ci (Tajima)[4],
            n_snps = sum(nSites),
            mean = mean(Tajima),
            quant_0.25 = quantile(Tajima, probs = 0.25),
            quant_0.75 = quantile(Tajima, probs = 0.75))
Tajima_table


# Tajima's D plot for paper:

Taj_ANGSD_ms <- df1 %>%
  filter(Chrom_region=="autosome") %>%
  filter(Seq_type=="intergenic") %>%
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = Pop, y = Tajima)) + 
  geom_boxplot(notch = F, outlier.shape = 1, outlier.size = 0.5, outlier.alpha = 0.5) +
  stat_summary(fun.y = "mean", geom = "point", shape = 23, size = 1.5, fill = "white") +
  #coord_cartesian(ylim = c(-2.2, 2.8)) +  
  ylab("Tajima's\nD") +
  #ggtitle("Estimated from all autosomal intergenic SNPS (Assembly 1), \nall samples, using ANGSD ThetStat") +
  theme_linedraw(base_size = 10) +
  theme(strip.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))
Taj_ANGSD_ms

OUTSTUB="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/neoZ_scans/Figures/"

ggsave(file = paste0(OUTSTUB,"Tajimas D - pops - autosomal intergenic SNPs - ANGSD.svg"),
       plot = Taj_ANGSD_ms,
       device = "svg",
       width = 60, height = 50, unit = "mm",
       dpi = "retina")



  
