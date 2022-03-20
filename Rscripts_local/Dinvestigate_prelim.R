# genome scan plots of D stats and other introgression evidence from Dsuite
# Nov 11 2021


# saves a plot of scans of f_dM for all possible trio tests:

library(dplyr)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(viridis)
library(RColorBrewer)
library(patchwork)

require(data.table)

library(wesanderson)


setwd("/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/Dsuite_BFHE")


windows="3000_1000"

OUTSTUB=paste0("Figures/Dinvestigate_msplot_", windows)

tr1 <- 17445000
# position on contig 4 where synteny (to zebra finch) changes from Chr 5 to Z-PAR
tr2 <- 54600000 # from here to the end of contig.

DATA_PATH="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/Dsuite_BFHE/Dinvestigate/Dinvestigate/"
# read file path
all_paths <-
  list.files(path = DATA_PATH,
             pattern = paste0("*",windows,".txt"),
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

df <- all_result %>%
  mutate(Trio = case_when(
    grepl(pattern = "EC_CY_KP", x = File) ~ "EC_CY_KP",
    grepl(pattern = "PNG_CY_EC", x = File) ~ "PNG_CY_EC",
    grepl(pattern = "EC_CY_TE", x = File) ~ "EC_CY_TE",
    grepl(pattern = "CY_PNG_KP", x = File) ~ "CY_PNG_KP",
    grepl(pattern = "TE_KP_CY", x = File) ~ "TE_KP_CY",
    grepl(pattern = "CY_PNG_TE", x = File) ~ "CY_PNG_TE",
    grepl(pattern = "EC_PNG_KP", x = File) ~ "EC_PNG_KP",
    grepl(pattern = "TE_KP_EC", x = File) ~ "TE_KP_EC",
    grepl(pattern = "EC_PNG_TE", x = File) ~ "EC_PNG_TE",
    grepl(pattern = "TE_KP_PNG", x = File) ~ "TE_KP_PNG")) %>%
  mutate(Chr = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "contig_4", x = chr)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = chr) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = chr) ~ "Chr 1A")
  ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = chr) & windowStart < tr1) ~ "new PAR",
    (grepl(pattern = "contig_4", x = chr) & windowEnd > tr1 & windowStart < tr2) ~ "added-Z NR",
    (grepl(pattern = "contig_4", x = chr) & windowStart > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = chr) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = chr) ~ "Chr 1A")
  )

df$win_mid_mb <- (df$windowStart+((df$windowEnd-df$windowStart)/2))/1000000

# how big are the windows?
hist(df$windowEnd-df$windowStart)
summary(df$windowEnd-df$windowStart)


# good plots:

wes_palette = wes_palette(n=5, name="Moonrise3")


bp <- df %>%
  filter(Chr %in% c("Chr 1A", "ancestral-Z", "added-Z")) %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  drop_na() %>%
  ggplot(aes(x = Region, y = f_dM, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  ylab(expression(italic(f[dM]))) +
  geom_hline(yintercept = 0) +
  facet_wrap('Trio', nrow = 10, strip.position = "right", scales="free_y") +
  ylim(-0.06,0.13) +
  scale_x_discrete(labels= c("new\nPAR", "added.\nZ", "anc.\nZ", "Chr\n1A")) +
  scale_fill_manual(values=wes_palette[c(1,2,4,5)]) +
  theme_classic() +
  theme(strip.background = element_blank(),
        axis.title.y = element_blank())

bp

ap <- df %>%
  filter(Chr %in% c("Chr 1A", "ancestral-Z", "added-Z")) %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  drop_na() %>%
  ggplot(aes(x = win_mid_mb, y = f_dM)) +
  geom_area(show.legend=F) +
  #geom_point() +
  #facet_wrap('chr', scales = 'fixed', nrow = 1) + 
  facet_grid(Trio ~ Chr, scales = "free_x") +
  scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df$win_mid_mb), by = 10)) +
  ylab(expression(italic(f[dM]))) +
  geom_vline(data = df[which(df$Chr=="added-Z"),], mapping = aes(xintercept = tr1/1000000), linetype = "dashed") +
  #theme_classic() +
  theme_linedraw() +
  theme(
    strip.text.y = element_blank(),
        #strip.text.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))

ap
  
plot <- (ap |bp) +
  plot_layout(widths = c(3, 1.2))

plot



pdf(file = paste0(OUTSTUB, "_alltrios.pdf"),   # The directory you want to save the file in
    width = 8,
    height = 14) # inches
plot
dev.off()
plot




