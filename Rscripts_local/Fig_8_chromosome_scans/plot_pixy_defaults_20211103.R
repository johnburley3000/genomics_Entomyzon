# Nov 3 2021
# Plotting pi, dxy and fst in windows along scaffolds of the ONT-Fly assembly corresponding to the neo-Z (including anc-C5) and Chr 1A.
# data generated using pixy (see sripts on Odyssey)
# basing these plots on code provided here: https://pixy.readthedocs.io/en/latest/output.html

# How I used this code:
# Just check the subspecies
# only looking at the larger 3 contigs representing most of anc-Z, added-Z, Chr1A.
# manually choose the dataset, create subdir, and run the code to plot figures in there

setwd("Pixy/")

DATA="males_filt1_pops_50kb"
dir.create(paste0("Figures/",DATA,"_default"))
OUTSTUB=paste0("Figures/",DATA,"_default/")

main_contigs = c("scaffold_335_segment0", "scaffold_430_segment0", "contig_4_segment0")

# scaffold_335_segment0 is 52,861,155 bp of Chr 1A
# scaffold_430_segment0 is 551,630,051 bp of Chr Z (ancestral)
# contig_4_segment0 is _____ bp of the added-Z (ancestral C5)

library(dplyr)
library(ggplot2)


# Provide path to input. Can be pi or Dxy OR FST
# NOTE: this is the only line you should have to edit to run this code:
inp<-read.table(paste0("Data/",DATA,"_fst.txt"),sep="\t",header=T) %>%
  filter(chromosome %in% main_contigs)

# Find the chromosome names and order them: first numerical order, then any non-numerical chromosomes
#   e.g., chr1, chr2, chr22, chrX
chroms <- unique(inp$chromosome)
chrOrder <- sort(chroms)
inp$chrOrder <- factor(inp$chromosome,levels=chrOrder)
 
# Plot pi for each population found in the input file
# Saves a copy of each plot in the working directory
if("avg_pi" %in% colnames(inp)){
  pops <- unique(inp$pop)
  for (p in pops){
    thisPop <- subset(inp, pop == p)
    # Plot stats along all chromosomes:
    popPlot <- ggplot(thisPop, aes(window_pos_1, avg_pi, color=chrOrder)) +
      geom_point()+
      facet_grid(. ~ chrOrder)+
      labs(title=paste("Pi for population", p))+
      labs(x="Position of window start", y="Pi")+
      scale_color_manual(values=rep(c("black","gray"),ceiling((length(chrOrder)/2))))+
      theme_classic()+
      theme(legend.position = "none")
    ggsave(paste(OUTSTUB, "piplot_", p,".png", sep=""), plot = popPlot, device = "png", dpi = 300,
           height = 5, width = 13)
  }
    } else {
  print("Pi not found in this file")
}

# Plot Dxy for each combination of populations found in the input file
# Saves a copy of each plot in the working directory
if("avg_dxy" %in% colnames(inp)){
  # Get each unique combination of populations
  pops <- unique(inp[c("pop1", "pop2")])
  for (p in 1:nrow(pops)){
    combo <- pops[p,]
    thisPop <- subset(inp, pop1 == combo$pop1[[1]] & pop2 == combo$pop2[[1]])
    # Plot stats along all chromosomes:
    popPlot <- ggplot(thisPop, aes(window_pos_1, avg_dxy, color=chrOrder)) +
      geom_point()+
      facet_grid(. ~ chrOrder)+
      labs(title=paste("Dxy for", combo$pop1[[1]], "&", combo$pop2[[1]]))+
      labs(x="Position of window start", y="Dxy")+
      theme(legend.position = "none")+
      scale_color_manual(values=rep(c("black","gray"),ceiling((length(chrOrder)/2))))+
      theme_classic()+
      theme(legend.position = "none")
    ggsave(paste(OUTSTUB, "dxyplot_", combo$pop1[[1]], "_", combo$pop2[[1]],".png", sep=""), 
           plot = popPlot, device = "png", dpi = 300,
           height = 5, width = 13)
  }
} else {
  print("Dxy not found in this file")
}

# Plot fst for each combination of populations found in the input file
# Saves a copy of each plot in the working directory
if("avg_wc_fst" %in% colnames(inp)){
  # Get each unique combination of populations
  pops <- unique(inp[c("pop1", "pop2")])
  for (p in 1:nrow(pops)){
    combo <- pops[p,]
    thisPop <- subset(inp, pop1 == combo$pop1[[1]] & pop2 == combo$pop2[[1]])
    # Plot stats along all chromosomes:
    popPlot <- ggplot(thisPop, aes(window_pos_1, avg_wc_fst, color=chrOrder)) +
      geom_point()+
      facet_grid(. ~ chrOrder)+
      labs(title=paste("fst for", combo$pop1[[1]], "&", combo$pop2[[1]]))+
      labs(x="Position of window start", y="fst")+
      theme(legend.position = "none")+
      scale_color_manual(values=rep(c("black","gray"),ceiling((length(chrOrder)/2))))+
      theme_classic()+
      theme(legend.position = "none")
    ggsave(paste(OUTSTUB, "fstplot_", combo$pop1[[1]], "_", combo$pop2[[1]],".png", sep=""), 
           plot = popPlot, device = "png", dpi = 300,
           height = 5, width = 13)
  }
} else {
  print("fst not found in this file")
}

