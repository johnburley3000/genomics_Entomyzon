## libs:
library(dplyr)
library(tidyverse)


## setup:

setwd("~/Google Drive/Projects/BFHE_ms_2021/ReAnalyses/Pixy/")

DATA="males_filt1_pops_50kb"
dir.create(paste0("Figures/",DATA,"_msfig"))
OUTSTUB=paste0("Figures/",DATA,"_msfig/")


## parameters:

# position on contig 4 where PAR transitions to NR
tr1 <- 17400000
# position on contig 4 where synteny (to zebra finch) changes from Chr 5 to Z-PAR
tr2 <- 54600000 # from here to the end of contig.
#tr2 <- 49900000
#tr3 <- 51500000

## read in datasets:

#######
#### PI
#######

# A - Provide path to input. Can be pi or Dxy OR FST
inp<-read.table(paste0("Data/",DATA,"_pi.txt"),sep="\t",header=T)

# B - set the window pos in Mbp
inp$pos_mb <- inp$window_pos_1/1000000

# C - add chromosome names based on the contig name, drop all other contig names not specified
colnames(inp)[2] <- "contig"
df_pi <- inp %>%
  mutate(Chr = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "contig_4", x = contig)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = contig) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = contig) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = contig) ~ "Chr 1A")
    ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 < tr1) ~ "new PAR",
   (grepl(pattern = "contig_4", x = contig) & window_pos_1 > tr1 & window_pos_1 < tr2) ~ "added-Z NR",
   (grepl(pattern = "contig_4", x = contig) & window_pos_2 > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = contig) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = contig) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = contig) ~ "Chr 1A")
   
  ) %>%
  # dplyr::filter(count_missing < 2000) %>%
  drop_na()


# D - Re-orient the contigs of ancestral Z as well as Chr 1A for better representation of physical structure

# reverse the order of the ancestral Z
df_pi$pos_mb[which(df_pi$contig=="scaffold_430_segment0")] <- -1*(
  df_pi$pos_mb[which(df_pi$contig=="scaffold_430_segment0")] - 
  (max(df_pi$pos_mb[which(df_pi$contig=="scaffold_430_segment0")]) + min(df_pi$pos_mb[which(df_pi$contig=="scaffold_430_segment0")]))
)

## join the positions of Chr 1A contigs to make nice, continuous plot:
# assumed order: flip(contig_1888_segment0), scaffold_335_segment0, scaffold_335_segment1

# reverse contig_1888_segment0
#df_pi$pos_mb[which(df_pi$contig=="contig_1888_segment0")] <- -1*(
#  df_pi$pos_mb[which(df_pi$contig=="contig_1888_segment0")] - 
#    (max(df_pi$pos_mb[which(df_pi$contig=="contig_1888_segment0")]) + min(df_pi$pos_mb[which(df_pi$contig=="contig_1888_segment0")]))
#)

# get the end positions of the first 2 contigs
end_Chr1A_1 <- max(df_pi$pos_mb[which(df_pi$contig=="contig_1888_segment0")])
end_Chr1A_2 <- end_Chr1A_1 + max(df_pi$pos_mb[which(df_pi$contig=="scaffold_335_segment0")])

# re-project the second contig by adding the maximum position of the first
df_pi$pos_mb[which(df_pi$contig=="scaffold_335_segment0")] <- end_Chr1A_1 + 0.050001 + 
  df_pi$pos_mb[which(df_pi$contig=="scaffold_335_segment0")]
# re-project the third contig by adding the maximum position of combined first 2
df_pi$pos_mb[which(df_pi$contig=="scaffold_335_segment1")] <- end_Chr1A_2 + 0.050001 + 
  df_pi$pos_mb[which(df_pi$contig=="scaffold_335_segment1")]

# check the length of the full thing
max(df_pi$pos_mb[which(df_pi$Chr=="Chr 1A")])

# E - get the mean pi across populations, more appropriate for plotting points and boxplot:

df_pi2 = df_pi %>%
  group_by(Chr, Region, pos_mb) %>%
  summarise(avg_pi = mean(avg_pi),
            pos_mb = mean(pos_mb))

# re-order factors for better plotting: (might be redundant now)
df_pi$Chr <- factor(df_pi$Chr, levels = c("added-Z", "ancestral-Z", "Chr 1A"))
df_pi$Region <- factor(df_pi$Region, levels = c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))
df_pi$pop <- factor(df_pi$pop, levels = c("KP", "TE", "PNG", "CY", "EC"))


##########
#### DXY ##
##########

# Provide path to input. Can be pi or Dxy OR FST
inp_dxy<-read.table(paste0("Data/",DATA,"_dxy.txt"),sep="\t",header=T)

# set the window pos in Mbp
inp_dxy$pos_mb <- inp_dxy$window_pos_1/1000000

inp_dxy$pop_pair <- paste(inp_dxy$pop1, inp_dxy$pop2, sep = "-")

# add chromosome names based on the contig name, drop all other contig names not specified
colnames(inp_dxy)[3] <- "contig"
df_dxy <- inp_dxy %>%
  mutate(Chr = case_when(
      grepl(pattern = "contig_4", x = contig)  ~ "added-Z",
      grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
      grepl(pattern = "scaffold_335_segment0", x = contig) ~ "Chr 1A",
      grepl(pattern = "scaffold_335_segment1", x = contig) ~ "Chr 1A",
      grepl(pattern = "contig_1888_segment0", x = contig) ~ "Chr 1A")
    ) %>%
      mutate(Region = case_when(
        (grepl(pattern = "contig_4", x = contig) & window_pos_1 < tr1) ~ "new PAR",
        (grepl(pattern = "contig_4", x = contig) & window_pos_1 > tr1 & window_pos_1 < tr2) ~ "added-Z NR",
        (grepl(pattern = "contig_4", x = contig) & window_pos_2 > tr2 ) ~ "ancestral Z-PAR",
        grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
        grepl(pattern = "scaffold_335_segment0", x = contig) ~ "Chr 1A",
        grepl(pattern = "scaffold_335_segment1", x = contig) ~ "Chr 1A",
        grepl(pattern = "contig_1888_segment0", x = contig) ~ "Chr 1A")
  ) %>%
  # dplyr::filter(count_missing < 2000) %>%
  drop_na()

# D - Re-orient the contigs of ancestral Z as well as Chr 1A for better representation of physical structure

# reverse the order of the ancestral Z
df_dxy$pos_mb[which(df_dxy$contig=="scaffold_430_segment0")] <- -1*(
  df_dxy$pos_mb[which(df_dxy$contig=="scaffold_430_segment0")] - 
    (max(df_dxy$pos_mb[which(df_dxy$contig=="scaffold_430_segment0")]) + min(df_dxy$pos_mb[which(df_dxy$contig=="scaffold_430_segment0")]))
)

## join the positions of Chr 1A contigs to make nice, continuous plot:
# assumed order: flip(contig_1888_segment0), scaffold_335_segment0, scaffold_335_segment1

# reverse contig_1888_segment0
#df_dxy$pos_mb[which(df_dxy$contig=="contig_1888_segment0")] <- -1*(
#  df_dxy$pos_mb[which(df_dxy$contig=="contig_1888_segment0")] - 
#    (max(df_dxy$pos_mb[which(df_dxy$contig=="contig_1888_segment0")]) + min(df_dxy$pos_mb[which(df_dxy$contig=="contig_1888_segment0")]))
#)

# get the end positions of the first 2 contigs
end_Chr1A_1 <- max(df_dxy$pos_mb[which(df_dxy$contig=="contig_1888_segment0")])
end_Chr1A_2 <- end_Chr1A_1 + max(df_dxy$pos_mb[which(df_dxy$contig=="scaffold_335_segment0")])

# re-project the second contig by adding the maximum position of the first
df_dxy$pos_mb[which(df_dxy$contig=="scaffold_335_segment0")] <- end_Chr1A_1 + 0.050001 + 
  df_dxy$pos_mb[which(df_dxy$contig=="scaffold_335_segment0")]
# re-project the third contig by adding the maximum position of combined first 2
df_dxy$pos_mb[which(df_dxy$contig=="scaffold_335_segment1")] <- end_Chr1A_2 + 0.050001 + 
  df_dxy$pos_mb[which(df_dxy$contig=="scaffold_335_segment1")]

# check the length of the full thing
max(df_dxy$pos_mb[which(df_dxy$Chr=="Chr 1A")])

# re-order factors for better plotting:
df_dxy$Chr <- factor(df_dxy$Chr, levels = c("added-Z", "ancestral-Z", "Chr 1A"))
df_dxy$Region <- factor(df_dxy$Region, levels = c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))
df_dxy$pop_pair <- factor(df_dxy$pop_pair, levels = c("KP-EC", "TE-EC", "KP-PNG", "PNG-EC", "CY-EC", "TE-PNG", "KP-CY", "TE-CY", "PNG-CY", "KP-TE"))
# pop pairs arranged by decreasing autosome-wide Fst



##########
#### FST ##
##########

# Provide path to input. Can be pi or Dxy OR FST
inp_fst<-read.table(paste0("Data/",DATA,"_fst.txt"),sep="\t",header=T)

# set the window pos in Mbp
inp_fst$pos_mb <- inp_fst$window_pos_1/1000000

inp_fst$pop_pair <- paste(inp_fst$pop1, inp_fst$pop2, sep = "-")

# add chromosome names based on the contig name, drop all other contig names not specified
colnames(inp_fst)[3] <- "contig"
df_fst <- inp_fst %>%
  mutate(Chr = case_when(
    grepl(pattern = "contig_4", x = contig)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = contig) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = contig) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = contig) ~ "Chr 1A")
  ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 < tr1) ~ "new PAR",
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 > tr1 & window_pos_1 < tr2) ~ "added-Z NR",
    (grepl(pattern = "contig_4", x = contig) & window_pos_2 > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = contig) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = contig) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = contig) ~ "Chr 1A")
  ) %>%
  # dplyr::filter(count_missing < 2000) %>%
  drop_na()

# D - Re-orient the contigs of ancestral Z as well as Chr 1A for better representation of physical structure

# reverse the order of the ancestral Z
df_fst$pos_mb[which(df_fst$contig=="scaffold_430_segment0")] <- -1*(
  df_fst$pos_mb[which(df_fst$contig=="scaffold_430_segment0")] - 
    (max(df_fst$pos_mb[which(df_fst$contig=="scaffold_430_segment0")]) + min(df_fst$pos_mb[which(df_fst$contig=="scaffold_430_segment0")]))
)

## join the positions of Chr 1A contigs to make nice, continuous plot:
# assumed order: flip(contig_1888_segment0), scaffold_335_segment0, scaffold_335_segment1

# reverse contig_1888_segment0
#df_fst$pos_mb[which(df_fst$contig=="contig_1888_segment0")] <- -1*(
#  df_fst$pos_mb[which(df_fst$contig=="contig_1888_segment0")] - 
#    (max(df_fst$pos_mb[which(df_fst$contig=="contig_1888_segment0")]) + min(df_fst$pos_mb[which(df_fst$contig=="contig_1888_segment0")]))
#)

# get the end positions of the first 2 contigs
end_Chr1A_1 <- max(df_fst$pos_mb[which(df_fst$contig=="contig_1888_segment0")])
end_Chr1A_2 <- end_Chr1A_1 + max(df_fst$pos_mb[which(df_fst$contig=="scaffold_335_segment0")])

# re-project the second contig by adding the maximum position of the first
df_fst$pos_mb[which(df_fst$contig=="scaffold_335_segment0")] <- end_Chr1A_1 + 0.050001 + 
  df_fst$pos_mb[which(df_fst$contig=="scaffold_335_segment0")]
# re-project the third contig by adding the maximum position of combined first 2
df_fst$pos_mb[which(df_fst$contig=="scaffold_335_segment1")] <- end_Chr1A_2 + 0.050001 + 
  df_fst$pos_mb[which(df_fst$contig=="scaffold_335_segment1")]

# check the length of the full thing
max(df_fst$pos_mb[which(df_fst$Chr=="Chr 1A")])

# re-order factors for better plotting:
df_fst$Chr <- factor(df_fst$Chr, levels = c("added-Z", "ancestral-Z", "Chr 1A"))
df_fst$Region <- factor(df_fst$Region, levels = c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))
df_fst$pop_pair <- factor(df_fst$pop_pair, levels = c("KP-EC", "TE-EC", "KP-PNG", "PNG-EC", "CY-EC", "TE-PNG", "KP-CY", "TE-CY", "PNG-CY", "KP-TE"))
  # pop pairs arranged by decreasing autosome-wide Fst



##########
#### D-stats ##
##########

DATA_PATH="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/Dsuite_BFHE/Dinvestigate/Dinvestigate/"

## windows deterimines which file to read in...
windows_bp="3000_3000" # non-overlapping windows for the boxplot so as not to artificially reduce noise. 
windows_ap="3000_1000" # stepped windows for then scan plot to make smoother lines

## Step to read in all data and collate:

## FIRST READ DATA IN NON_OVERLAPPING WINDOWS FOR BOXPLOT:

# read file path
all_paths <-
  list.files(path = DATA_PATH,
             pattern = paste0("*",windows_bp,".txt"),
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
names(all_result)[8] <- "File"
# Now we have one big data table:
remove(all_content, all_lists, all_filenames, all_paths)

df_bp <- all_result %>%
  mutate(Trio = case_when(
    grepl(pattern = "EC_CY_TE", x = File) ~ "EC_CY_TE",
    grepl(pattern = "PNG_CY_TE", x = File) ~ "PNG_CY_TE",
    grepl(pattern = "PNG_CY_EC", x = File) ~ "PNG_CY_EC")) %>%
  mutate(Chr = case_when(
    grepl(pattern = "contig_4", x = chr)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = chr) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = chr) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = chr) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = chr) ~ "Chr 1A")
  ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = chr) & windowStart < tr1) ~ "new PAR",
    (grepl(pattern = "contig_4", x = chr) & windowStart > tr1 & windowStart < tr2) ~ "added-Z NR",
    (grepl(pattern = "contig_4", x = chr) & windowEnd > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = chr) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = chr) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = chr) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = chr) ~ "Chr 1A")
  )

# new column for mid point of window in Mbp
df_bp$pos_mb <- (df_bp$windowStart+((df_bp$windowEnd-df_bp$windowStart)/2))/1000000

# D - Re-orient the contigs of ancestral Z as well as Chr 1A for better representation of physical structure

# reverse the order of the ancestral Z
df_bp$pos_mb[which(df_bp$chr=="scaffold_430_segment0")] <- -1*(
  df_bp$pos_mb[which(df_bp$chr=="scaffold_430_segment0")] - 
    (max(df_bp$pos_mb[which(df_bp$chr=="scaffold_430_segment0")]) + min(df_bp$pos_mb[which(df_bp$chr=="scaffold_430_segment0")]))
)

## join the positions of Chr 1A contigs to make nice, continuous plot:
# assumed order: flip(contig_1888_segment0), scaffold_335_segment0, scaffold_335_segment1

# reverse contig_1888_segment0
#df_bp$pos_mb[which(df_bp$chr=="contig_1888_segment0")] <- -1*(
#  df_bp$pos_mb[which(df_bp$chr=="contig_1888_segment0")] - 
#    (max(df_bp$pos_mb[which(df_bp$chr=="contig_1888_segment0")]) + min(df_bp$pos_mb[which(df_bp$chr=="contig_1888_segment0")]))
#)

# get the end positions of the first 2 contigs
end_Chr1A_1 <- max(df_bp$pos_mb[which(df_bp$chr=="contig_1888_segment0")])
end_Chr1A_2 <- end_Chr1A_1 + max(df_bp$pos_mb[which(df_bp$chr=="scaffold_335_segment0")])

# re-project the second contig by adding the maximum position of the first
df_bp$pos_mb[which(df_bp$chr=="scaffold_335_segment0")] <- end_Chr1A_1 + 0.050001 + 
  df_bp$pos_mb[which(df_bp$chr=="scaffold_335_segment0")]
# re-project the third contig by adding the maximum position of combined first 2
df_bp$pos_mb[which(df_bp$chr=="scaffold_335_segment1")] <- end_Chr1A_2 + 0.050001 + 
  df_bp$pos_mb[which(df_bp$chr=="scaffold_335_segment1")]

# check the length of the full thing
max(df_bp$pos_mb[which(df_bp$Chr=="Chr 1A")])

# SECOND READ IN DATA IN OVERLAPPING WINDOWS FOR SCAN PLOT

# read file path
all_paths <-
  list.files(path = DATA_PATH,
             pattern = paste0("*",windows_ap,".txt"),
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
names(all_result)[8] <- "File"
# Now we have one big data table:
remove(all_content, all_lists, all_filenames, all_paths)

df_ap <- all_result %>%
  mutate(Trio = case_when(
    grepl(pattern = "EC_CY_TE", x = File) ~ "EC_CY_TE",
    grepl(pattern = "PNG_CY_TE", x = File) ~ "PNG_CY_TE",
    grepl(pattern = "PNG_CY_EC", x = File) ~ "PNG_CY_EC")) %>%
  mutate(Chr = case_when(
    grepl(pattern = "contig_4", x = chr)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = chr) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = chr) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = chr) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = chr) ~ "Chr 1A")
  ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = chr) & windowStart < tr1) ~ "new PAR",
    (grepl(pattern = "contig_4", x = chr) & windowStart > tr1 & windowStart < tr2) ~ "added-Z NR",
    (grepl(pattern = "contig_4", x = chr) & windowEnd > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = chr) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335_segment0", x = chr) ~ "Chr 1A",
    grepl(pattern = "scaffold_335_segment1", x = chr) ~ "Chr 1A",
    grepl(pattern = "contig_1888_segment0", x = chr) ~ "Chr 1A")
  )

# new column for mid point of window in Mbp
df_ap$pos_mb <- (df_ap$windowStart+((df_ap$windowEnd-df_ap$windowStart)/2))/1000000

# D - Re-orient the contigs of ancestral Z as well as Chr 1A for better representation of physical structure

# reverse the order of the ancestral Z
df_ap$pos_mb[which(df_ap$chr=="scaffold_430_segment0")] <- -1*(
  df_ap$pos_mb[which(df_ap$chr=="scaffold_430_segment0")] - 
    (max(df_ap$pos_mb[which(df_ap$chr=="scaffold_430_segment0")]) + min(df_ap$pos_mb[which(df_ap$chr=="scaffold_430_segment0")]))
)

## join the positions of Chr 1A contigs to make nice, continuous plot:
# assumed order: flip(contig_1888_segment0), scaffold_335_segment0, scaffold_335_segment1

# reverse contig_1888_segment0
#df_ap$pos_mb[which(df_ap$chr=="contig_1888_segment0")] <- -1*(
#  df_ap$pos_mb[which(df_ap$chr=="contig_1888_segment0")] - 
#    (max(df_ap$pos_mb[which(df_ap$chr=="contig_1888_segment0")]) + min(df_ap$pos_mb[which(df_ap$chr=="contig_1888_segment0")]))
#)

# get the end positions of the first 2 contigs
end_Chr1A_1 <- max(df_ap$pos_mb[which(df_ap$chr=="contig_1888_segment0")])
end_Chr1A_2 <- end_Chr1A_1 + max(df_ap$pos_mb[which(df_ap$chr=="scaffold_335_segment0")])

# re-project the second contig by adding the maximum position of the first
df_ap$pos_mb[which(df_ap$chr=="scaffold_335_segment0")] <- end_Chr1A_1 + 0.050001 + 
  df_ap$pos_mb[which(df_ap$chr=="scaffold_335_segment0")]
# re-project the third contig by adding the maximum position of combined first 2
df_ap$pos_mb[which(df_ap$chr=="scaffold_335_segment1")] <- end_Chr1A_2 + 0.050001 + 
  df_ap$pos_mb[which(df_ap$chr=="scaffold_335_segment1")]

# check the length of the full thing
max(df_ap$pos_mb[which(df_ap$Chr=="Chr 1A")])





#######
####### THE END





