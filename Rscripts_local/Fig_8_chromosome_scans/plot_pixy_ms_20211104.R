# Nov 4 2021
# Plotting pi, dxy and fst in windows along scaffolds of the ONT-Fly assembly corresponding to the neo-Z (including anc-C5) and Chr 1A.
# data generated using pixy (see sripts on Odyssey)

# aim: a 4-panel plot (2x2) for each metric (pi, dxy, fst) featuring
# scans for each contig: 4, 335, 430 (a-c)
# boxplots for each region type: new-PAR, added-Z-NR, anc-Z-PAR, anc-Z-NR, chr 1A (d)

# probably depict as a smoothed lines with shadow for 95 % CI
# (although this could get messy for multiple lines...)
# if there is nothing informative added by showing the pops separately, then use subspecies.

library(dplyr)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(viridis)
library(RColorBrewer)

# changes:
# t test 
# boxplots for dxy and fst
# add legend
# add text to show region
# add introgression stats from Dsuite?
# make the box plot panels wider relative to scans
# add the extra contigs where appropriate (e.g. in Chr 1A)

# check out this function to get legend from ggplot2 qnd use in a cowplot panel: https://github.com/wilkelab/cowplot/blob/master/R/get_legend.R

setwd("~/Google Drive/Projects/BFHE_ms_2021/ReAnalyses/Pixy/")

DATA="males_filt1_pops_50kb"
dir.create(paste0("Figures/",DATA,"_msfig"))
OUTSTUB=paste0("Figures/",DATA,"_msfig/")

main_contigs = c("scaffold_335_segment0", "scaffold_430_segment0", "contig_4_segment0")

# position on contig 4 where PAR transitions to NR
tr1 <- 17400000
# position on contig 4 where synteny (to zebra finch) changes from Chr 5 to Z-PAR
tr2 <- 54600000 # from here to the end of contig.
#tr2 <- 49900000
#tr3 <- 51500000

#### PI ##
##########

# Provide path to input. Can be pi or Dxy OR FST
inp<-read.table(paste0("Data/",DATA,"_pi.txt"),sep="\t",header=T)

# set the window pos in Mbp
inp$pos_mb <- inp$window_pos_1/1000000

# add chromosome names based on the contig name, drop all other contig names not specified
colnames(inp)[2] <- "contig"
df <- inp %>%
  mutate(Chr = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "contig_4", x = contig)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = contig) ~ "Chr 1A")
    ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 < tr1) ~ "new PAR",
   (grepl(pattern = "contig_4", x = contig) & window_pos_1 > tr1 & window_pos_1 < tr2) ~ "added-Z NR",
   (grepl(pattern = "contig_4", x = contig) & window_pos_2 > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = contig) ~ "Chr 1A")
  ) %>%
  # dplyr::filter(count_missing < 2000) %>%
  drop_na()

# get the mean across populations:

df2 = df %>%
  group_by(Chr, Region, window_pos_1) %>%
  summarise(avg_pi = mean(avg_pi),
            pos_mb = mean(pos_mb))

# re-order factors for better plotting:
df$Chr <- factor(df$Chr, levels = c("added-Z", "ancestral-Z", "Chr 1A"))
df$Region <- factor(df$Region, levels = c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))
df$pop <- factor(df$pop, levels = c("KP", "TE", "PNG", "CY", "EC"))

head(df)

### READY TO PLOT PI:

## PICKING COLOURS
library(wesanderson)
wes_palette = wes_palette(n=5, name="Moonrise3")

###

## Testing using ggplot facets (hard to combine a box plot with scatter plots)

pi <- df %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = pos_mb, y = avg_pi, col = Region)) +
  geom_point(alpha = 0.2) +
  #geom_point(size = 0.5, shape = 21, stroke = 1, col = Region, alpha = 0.5) +
  scale_color_manual(values=wes_palette) + # guide = "None"
  geom_smooth(method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.1, col = "black") +
  scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df2$pos_mb), by = 10)) +
  #geom_vline(xintercept = 17.4, linetype = "dashed", alpha = 0.5) +
  facet_wrap('Chr', scales = 'free_x', nrow = 1) + 
  geom_vline(data = df[which(df$Chr=="added-Z"),], 
             mapping = aes(xintercept = c(tr1/1000000)), 
             linetype = "dashed",
             alpha = 0.5) +
  ylab(expression(pi)) +
  #theme_classic() +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        #strip.text.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))

pi

pi_box  <- df2 %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = Region, y = avg_pi, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  scale_y_continuous(position = "left") +
  scale_x_discrete(labels= c("new\nPAR", "added-\nZ-NR", "anc.\nZ-PAR", "anc.\nZ", "Chr\n1A")) +
  coord_cartesian(ylim = c(0, 0.01)) +  
  scale_fill_manual(values=wes_palette) +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()
        ) +  
  labs(title = expression(italic(pi)))


pi_box

pi_box_legend  <- df2 %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = Region, y = avg_pi, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = TRUE) +
  scale_y_continuous(position = "left") +
  scale_x_discrete(labels= c("new\nPAR", "added-\nZ-NR", "anc.\nZ-PAR", "anc.\nZ", "Chr\n1A")) +
  coord_cartesian(ylim = c(0, 0.01)) +  
  scale_fill_manual(values=wes_palette) +
  theme_linedraw() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank())

pi_box_legend


if("avg_pi" %in% colnames(df2)){

  p1 <- df2 %>%
    filter(Chr == "added-Z") %>%
    mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR"))) %>%
    ggplot(aes(x = pos_mb, y = avg_pi, col = Region)) +
    geom_point(alpha = 0.2) +
    scale_color_manual(values=wes_palette[1:3], guide="none") +
    geom_smooth(method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2, col = "black") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df2$pos_mb), by = 10)) +
    ylim(0,0.029) +
    geom_vline(xintercept = 17.4, linetype = "dashed") +
    ylab(expression(pi)) +
    theme_classic() +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.title.y=element_text(angle = 0, vjust = 0.5))
  
  p2 <- df2 %>%
    filter(Chr == "ancestral-Z") %>%
    ggplot(aes(x = pos_mb, y = avg_pi)) +
    geom_point(alpha = 0.2, col = wes_palette[4]) +
    geom_smooth(method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2, col = "black") +
    scale_x_continuous(name = "position on contig (Mbp)", breaks = seq(0, max(df2$pos_mb), by = 10)) +
    ylim(0,0.029) +
    ylab("pi") +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank())
    
  
  p3 <- df2 %>%
    filter(Chr == "Chr 1A") %>%
    ggplot(aes(x = pos_mb, y = avg_pi)) +
    geom_point(alpha = 0.2, col = wes_palette[5]) +
    geom_smooth(method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2, col = "black") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df2$pos_mb), by = 10)) +
    ylim(0,0.029) +
    ylab("pi") +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank())
  
  p4 <- df2 %>%
    mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
    ggplot(aes(x = Region, y = avg_pi, fill=Region)) +
    ylab("pi") +
    geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
    scale_y_continuous(position = "right", limits=c(0,0.008)) +
    #ylim(0,0.008) +
    scale_x_discrete(labels= c("new\nPAR", "added-\nZ-NR", "anc.\nZ-PAR", "anc.\nZ", "Chr\n1A")) +
    scale_fill_manual(values=wes_palette) +
    theme_classic() +
    theme(axis.text.x = element_text(face = "bold", angle=0),
          axis.title.x = element_blank(),
          axis.title.y = element_blank())
    
  fig <- plot_grid(p1, p2, p3, p4,
                   nrow = 1,
                   ncol = 4,
                   align = "hv")
  fig

} else {
  print("This is not a pi file")
  
} 

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
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "contig_4", x = contig)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = contig) ~ "Chr 1A")
  ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 < tr1) ~ "new PAR",
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 > tr1 & window_pos_1 < tr2) ~ "added-Z NR",
    (grepl(pattern = "contig_4", x = contig) & window_pos_2 > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = contig) ~ "Chr 1A")
  ) %>%
  # dplyr::filter(count_missing < 2000) %>%
  drop_na()

# re-order factors for better plotting:
df_dxy$Chr <- factor(df_dxy$Chr, levels = c("added-Z", "ancestral-Z", "Chr 1A"))
df_dxy$Region <- factor(df_dxy$Region, levels = c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))
df_dxy$pop_pair <- factor(df_dxy$pop_pair, levels = c("KP-EC", "TE-EC", "KP-PNG", "PNG-EC", "CY-EC", "TE-PNG", "KP-CY", "TE-CY", "PNG-CY", "KP-TE"))
# pop pairs arranged by decreasing autosome-wide Fst

## Ready to plot!

colors =  brewer.pal(10, "Spectral")

dxy <- df_dxy %>%
  #filter(Chr == "added-Z") %>%
  ggplot(aes(x = pos_mb, y = avg_dxy, color = pop_pair)) +
  geom_point(alpha = 0) +
  #scale_color_manual(values=colors[1:3], guide=FALSE) +
  geom_smooth(aes(group=pop_pair),
              method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2, size = 0.5) +
  scale_color_manual(values = colors,guide="none") +
  scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_dxy$pos_mb), by = 10)) +
  #geom_vline(xintercept = 17.4, linetype = "dashed") +
  geom_vline(data = df_dxy[which(df_dxy$Chr=="added-Z"),], 
             mapping = aes(xintercept = c(tr1/1000000)), 
             linetype = "dashed",
             alpha = 0.5) +
  facet_wrap('Chr', scales = 'free_x', nrow = 1) + 
  ylab(expression(italic(d[XY]))) +
  coord_cartesian(ylim = c(0, 0.01)) +  
  #theme_classic() +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))

dxy

dxy_box <- df_dxy %>%
  filter(pop_pair %in% c("KP-EC", "KP-TE")) %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = pop_pair, y = avg_dxy, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  scale_y_continuous(position = "left") +
  scale_x_discrete(labels= c("KP-EC", "KP-TE")) +
  coord_cartesian(ylim = c(0, 0.012)) +  
  scale_fill_manual(values=wes_palette) +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        #axis.text.x = element_blank(),
        axis.title.y = element_blank(),
        strip.text.x = element_blank(),
        #axis.title.y=element_text(angle = 0, vjust = 0.5),
        legend.position="bottom") +
  labs(title = expression(italic(d[XY])))

dxy_box

if("avg_dxy" %in% colnames(df_dxy)){
  
  p5 <- df_dxy %>%
    filter(Chr == "added-Z") %>%
    ggplot(aes(x = pos_mb, y = avg_dxy, color = pop_pair)) +
    geom_point(alpha = 0) +
    geom_smooth(aes(group=pop_pair),
                method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2) +
    scale_color_manual(values = colors, guide="none") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_dxy$pos_mb), by = 10)) +
    geom_vline(xintercept = 17.4, linetype = "dashed") +
    ylab(expression(italic(D[XY]))) +
    ylim(0,0.01) +
    theme_classic() +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.title.y=element_text(angle = 0, vjust = 0.5))
  
  p6 <- df_dxy %>%
    filter(Chr == "ancestral-Z") %>%
    ggplot(aes(x = pos_mb, y = avg_dxy, color = pop_pair)) +
    geom_point(alpha = 0) +
    geom_smooth(aes(group=pop_pair),
                method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2) +
    scale_color_manual(values = colors, guide="none") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_dxy$pos_mb), by = 10)) +
    ylab("dxy") +
    ylim(0,0.01) +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_blank())
  
  p7 <- df_dxy %>%
    filter(Chr == "Chr 1A") %>%
    ggplot(aes(x = pos_mb, y = avg_dxy, color = pop_pair)) +
    geom_point(alpha = 0) +
    geom_smooth(aes(group=pop_pair),
                method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2) +
    scale_color_manual(values = colors, guide="none") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_dxy$pos_mb), by = 10)) +
    ylab("dxy") +
    ylim(0,0.01) +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_blank())
  
  fig_dxy <- plot_grid(p5, p6, p7,
                   nrow = 1,
                   ncol = 4)
  fig_dxy
  
} else {
  print("This is not a dxy file")
}

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
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "contig_4", x = contig)  ~ "added-Z",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = contig) ~ "Chr 1A")
  ) %>%
  mutate(Region = case_when(
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 < tr1) ~ "new PAR",
    (grepl(pattern = "contig_4", x = contig) & window_pos_1 > tr1 & window_pos_1 < tr2) ~ "added-Z NR",
    (grepl(pattern = "contig_4", x = contig) & window_pos_2 > tr2 ) ~ "ancestral Z-PAR",
    grepl(pattern = "scaffold_430", x = contig) ~ "ancestral-Z",
    grepl(pattern = "scaffold_335", x = contig) ~ "Chr 1A")
  ) %>%
  # dplyr::filter(count_missing < 2000) %>%
  drop_na()

# re-order factors for better plotting:
df_fst$Chr <- factor(df_fst$Chr, levels = c("added-Z", "ancestral-Z", "Chr 1A"))
df_fst$Region <- factor(df_fst$Region, levels = c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))
df_fst$pop_pair <- factor(df_fst$pop_pair, levels = c("KP-EC", "TE-EC", "KP-PNG", "PNG-EC", "CY-EC", "TE-PNG", "KP-CY", "TE-CY", "PNG-CY", "KP-TE"))
  # pop pairs arranged by decreasing autosome-wide Fst

## Ready to plot!

fst <- df_fst %>%
  #filter(Chr == "added-Z") %>%
  ggplot(aes(x = pos_mb, y = avg_wc_fst, color = pop_pair)) +
  geom_point(alpha = 0) +
  #scale_color_manual(values=colors[1:3], guide=FALSE) +
  geom_smooth(aes(group=pop_pair),
              method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2, size=0.5) +
  scale_color_manual(values = colors, "population pair") +
  scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_fst$pos_mb), by = 10)) +
  #geom_vline(xintercept = 17.4, linetype = "dashed") +
  facet_wrap('Chr', scales = 'free_x', nrow = 1) + 
  ylab(expression(italic(F[ST]))) +
  coord_cartesian(ylim = c(0, 0.73)) +  
  geom_vline(data = df_fst[which(df_fst$Chr=="added-Z"),], 
             mapping = aes(xintercept = c(tr1/1000000)), 
             linetype = "dashed",
             alpha = 0.5) +
  #theme_classic()
  theme_linedraw(base_size = 10) +
  theme(axis.text.x = element_blank(),
       axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5),
        legend.position="right") 

fst

fst_box <- df_fst %>%
  filter(pop_pair %in% c("KP-EC", "KP-TE")) %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = pop_pair, y = avg_wc_fst, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  scale_y_continuous(position = "left") +
  scale_x_discrete(labels= c("KP-EC", "KP-TE")) +
  #coord_cartesian(ylim = c(0, 0.01)) +  
  scale_fill_manual(values=wes_palette) +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  labs(title = expression(italic(F[ST])))

fst_box
  
  

if("avg_wc_fst" %in% colnames(df_fst)){
  
  p8 <- df_fst %>%
    filter(Chr == "added-Z") %>%
    ggplot(aes(x = pos_mb, y = avg_wc_fst, color = pop_pair)) +
    geom_point(alpha = 0) +
    geom_smooth(aes(group=pop_pair),
                method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2) +
    scale_color_manual(values = colors, guide="none") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_fst$pos_mb), by = 10)) +
    geom_vline(xintercept = 17.4, linetype = "dashed") +
    ylab(expression(italic(F[ST]))) +
    theme_classic() +
    theme(axis.title.x = element_blank(),
          axis.title.y=element_text(angle = 0, vjust = 0.5))
  
  p9 <- df_fst %>%
    filter(Chr == "ancestral-Z") %>%
    ggplot(aes(x = pos_mb, y = avg_wc_fst, color = pop_pair)) +
    geom_point(alpha = 0) +
    geom_smooth(aes(group=pop_pair),
                method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2) +
    scale_color_manual(values = colors, guide="none") +
    scale_x_continuous(name = "position on contig (Mbp)", breaks = seq(0, max(df_fst$pos_mb), by = 10)) +
    ylab("fst") +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.text.y = element_blank())
  
  p10 <- df_fst %>%
    filter(Chr == "Chr 1A") %>%
    ggplot(aes(x = pos_mb, y = avg_wc_fst, color = pop_pair)) +
    geom_point(alpha = 0) +
    geom_smooth(aes(group=pop_pair),
                method="loess", se=FALSE, fullrange=FALSE, level=0.90, span = 0.2) +
    scale_color_manual(values = colors, guide="none") +
    scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_fst$pos_mb), by = 10)) +
    ylab("fst") +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank())
  
  fig_fst <- plot_grid(p8, p9, p10,
                       nrow = 1,
                       ncol = 4)
  fig_fst

} else{
  print("This is not an fst file")
}

p11 <- df_fst %>%
  ggplot(aes(x = pos_mb, y = avg_wc_fst, color = pop_pair))  +
  theme_classic() +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_blank())
p12 <- p11




bigfig <- plot_grid(p1, p2, p3, p4,
                    p5, p6, p7, p11,
                    p8, p9, p10, p12,
                 nrow = 3,
                 ncol = 4,
                 #labels = "AUTO",
                 #label_size = 10,
                 #label_fontface = "plain",
                 align = "hv")
bigfig # the margins are all messed up when I use align                           

save_plot(filename = paste0(OUTSTUB, "pi dxy fst - pops - neoZ chr1A tmp.pdf"), 
          bigfig, base_width = 6.5, base_height = 5)
  

# trying with patchwork              
patchplot <- (p1 | p2 | p3 | p4) /
  (p5 | p6 | p7 | p11) /
    (p8 | p9 | p10 | p12)

pdf(file = paste0(OUTSTUB, "pi dxy fst - pops - neoZ chr1A patchplot.pdf"),   # The directory you want to save the file in
    width = 6.5, # The width of the plot in inches
    height = 4) # The height of the plot in inches
patchplot
dev.off()
  
  
### FULL PLOT:

layout <- "
AAAE
BBBF
CCCG
DDDH
DDDH
DDDH"

full_plot <- pi + dxy + fst + ap + pi_box + dxy_box + fst_box + bp +
  plot_layout(design = layout,
              widths = c(2, 3))


layout2 <- "
ABCD
EEEE
FFFF
GGGG
HHHH"

full_plot2 <- pi_box  + dxy_box + fst_box + bp_2 + pi + dxy + fst + ap_2 +
  plot_layout(design = layout2, widths = c(1.1,1,1,0.9), heights = c(1.3,1,1,1,1)) +
  #plot_annotation(tag_levels = 'A')
full_plot2 

ggsave(file = paste0(OUTSTUB, "pi_dxy_fst(50kbp),dfm-((PNG,CY),EC)(3Ksnp)_fullplot2.svg"),
       plot = full_plot2,
       device = "svg",
       width = 255, height = 255, unit = "mm",
       dpi = "retina")




