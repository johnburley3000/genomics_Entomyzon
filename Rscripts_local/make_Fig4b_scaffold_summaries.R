# Make Figure 4b of BFHE ms
#clustering of scaffolds by m:f SNP density and coverage, and synteny.

# original script is: /Users/johnburley/Dropbox (Brown)/Harvard/Thesis_Project/analysis/06_z-linkedscafs/Satsuma/Code/Nov20_2017_order-zchrom-scafs.R

# steps:
# 1. Bring in Satsuma results, try to get 1 line per scaffold with a few different categories (i.e. chrom_Z, chrom_5, other_autosome, mixed_Z-5, mixed_Z-autosome, mixed_5-autosome, poor_match)
# 2. Bring in per-scaf m:f heterozygosity
# 3. Bring in per-scaf m:f coverage
# 4. make a plot to combine this information

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(svglite)

figstub = "/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/neoZ_ALLPATHS/Figures/"

## IMPORT DATA:

#Tgut_3.2.4 whole genome synteny results
data <- read.delim("/Users/johnburley/Dropbox (Brown)/Harvard/Thesis_Project/analysis/06_z-linkedscafs/Satsuma/zebra_finch/satsuma_summary.chained.out",
                   col.names= c("target_scaf", "start_target", "stop_target", "query_scaf", "start_query", "stop_query", "identity", "orientation"))


# per-scaffold male and female coverage from reseq data on ALLPATHS Assembly
datcov <- read.csv("/Users/johnburley/Dropbox (Brown)/Harvard/Thesis_Project/analysis/06_z-linkedscafs/df_new-3503scafs_coverage.csv")
datcov$X <- NULL

# per scaffold male and female heterozygosity (made using 08_filtering-VCFtools/Rscripts/hetbyscaf_mf.R)
dathet <- read.csv("/Users/johnburley/Dropbox (Brown)/Harvard/Thesis_Project/analysis/08_filtering-VCFtools/het_by_scaf_E_cyan_24_hf_snps_rm.csv")
dathet$X <- NULL

#  Synteny:
# make new data with sum of matching bases for each target scaffold on each BFHE scaffold. playing with this should reveal the major match(es) for each BFHE scaffold...

data <- separate(data,query_scaf, c("del","scaf"),sep="_",remove=TRUE)
data$length_on_query <- data$stop_query - data$start_query

data2 <- data %>%
  group_by(scaf, target_scaf) %>%
  summarise(sum_loq = sum(length_on_query), mean_ident = mean(identity)) %>%
  mutate(prop_loq = sum_loq/sum(sum_loq)) %>%
  arrange(as.integer(scaf))

hist(data2$prop_loq)
hist(data2$sum_loq)
hist(data2$mean_ident)

data3 <- data2 %>%
  filter(prop_loq > 0.01 & sum_loq > 1e3 & mean_ident > 0.4) %>%
  mutate(designation = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "chromosome_5", x = target_scaf) ~ "Chr 5",
    grepl(pattern = "chromosome_Z", x = target_scaf) ~ "Chr Z",
    grepl(pattern = "chromosome", x = target_scaf) ~ "autosome",
    #grepl(pattern = "chromosome_W", x = target_scaf) ~ "Chr W", # no W in this Tgut genome assembly
    grepl(pattern = "unplaced_genomic_scaffold", x = target_scaf) ~ "unplaced_genomic_scaffold",
  )) %>%
  arrange(as.integer(scaf))

# how many unique scaffolds are retained in this?
length(unique(data3$scaf))
# what is the total length of the scaffolds included?
sum(data3$sum_loq)
                

                          

datsyn <- data3 %>%
  group_by(scaf) %>%
  #summarise(total_loq = sum(sum_loq), designation = unique(list(designation))) %>%
  summarise(total_loq = sum(sum_loq), designation = paste(designation, collapse=",")) %>%
  arrange(as.integer(scaf))

#------------MERGE DATA

datcov$scaf <- as.character(datcov$scaf)
dathet$scaf <- as.character(dathet$scaf)

new1 <- left_join(datcov,dathet,"scaf")
new2 <- left_join(new1,datsyn,"scaf") %>%
  #filter(scaf_length > 50000) %>%
  drop_na()

#------------PLOT 

# first plot ALL 3505 scaffolds to view the full mess

svglite(filename = paste0(figstub,"all scaffolds summaries-- mf snp density,coverage.svg"),
    width=4, 
    height=4)

plot(new2$ratio_mf, new2$m_f,
     xlab="per scaffold coverage m/f", ylab="per scaffold SNP density m/f",
     col="grey", cex=0.75,
     xlim = c(0,2.2), ylim = c(0,5.5)) # see all of the points to gauge the spread.

dev.off()



# second plot the ~500 scaffolds > 100Kbp that were used in analysis

new3 <- left_join(new1,datsyn,"scaf") %>%
  filter(scaf_length > 100000) %>%
  drop_na()

svglite(filename = paste0(figstub,"scaffolds gt 100Kbp summaries-- mf snp density,coverage,synteny.svg"),
        width=4, 
        height=4)

plot(new3$ratio_mf, new3$m_f,
     xlab="per scaffold coverage m/f", ylab="per scaffold SNP density m/f",
     col="grey", cex=0.75,
     xlim = c(0,2.2), ylim = c(0,5.5))

# next, plot colour-coded groups
# also, re-make datsyn with a column showing top matches...
# plot the values of new2$scaf instead of points on the plot: https://stackoverflow.com/questions/2248261/r-how-to-use-contents-of-one-vector-as-the-symbol-in-a-plot
# look for scaffolds that have high m/f coverage ~2, and synteny to chr5... These are likely regions where greater degredation has occured...

points(new3$ratio_mf[which(new3$designation=="autosome")],new3$m_f[which(new3$designation=="autosome")], 
       col="black", cex=0.75,
       xlab="per scaffold coverage m/f", ylab="per scaffold SNP density m/f",
       xlim = c(0,2.5), ylim = c(0,2))
points(new3$ratio_mf[which(new3$designation=="Chr 5")],new3$m_f[which(new3$designation=="Chr 5")], 
       col="red", cex=0.75)
points(new3$ratio_mf[which(new3$designation=="Chr Z")],new3$m_f[which(new3$designation=="Chr Z")], 
       col="blue", cex=0.75)

legend(x = "topleft",          # Position
       legend = c("Chr 5", "other autosome", "Chr Z", "mixed homology"),  # Legend texts
       #lty = c(1, 2),           # Line types
       pch = 1,
       cex = 1,
       col = c("red", "black", "blue", "grey"),           # Line colors
       bty = "n" # Removes the legend box
       )  

dev.off()

## Equivelant plots but using f/m on the y-axis:

svglite(filename = paste0(figstub,"all scaffolds summaries-- fm snp density,mf coverage.svg"),
        width=4, 
        height=4)

plot(new2$ratio_mf, new2$f_m,
     xlab="per scaffold coverage m:f", ylab="per-scaffold SNP density f:m",
     col="grey", cex=0.75,
     #yaxp = c(0.01, 100, 1),
     ylim = c(0.01,100),
     log = 'y',
     yaxt = "n")
axis(2, at = c(0.01, 0.1, 1, 10, 100), labels = c("0.01", "0.1", "1", "10", "100"), las = 1)

dev.off()


svglite(filename = paste0(figstub,"scaffolds gt 100Kbp summaries-- fm snp density,mf coverage,synteny.svg"),
        width=4, 
        height=4)

plot(new3$ratio_mf, new3$f_m,
     xlab="per scaffold coverage m:f", ylab="per-scaffold SNP density f:m",
     col="grey", cex=0.75,
     #yaxp = c(0.01, 100, 1),
     ylim = c(0.01,100),
     log = 'y',
     yaxt = "n")
axis(2, at = c(0.01, 0.1, 1, 10, 100), labels = c("0.01", "0.1", "1", "10", "100"), las = 1)

points(new3$ratio_mf[which(new3$designation=="autosome")],new3$f_m[which(new3$designation=="autosome")], 
       col="black", cex=0.75,
       xlab="per scaffold coverage m:f", ylab="per-scaffold/nSNP density/nm:f",
       xlim = c(0,2.5), ylim = c(0,2))
points(new3$ratio_mf[which(new3$designation=="Chr 5")],new3$f_m[which(new3$designation=="Chr 5")], 
       col="red", cex=0.75)
points(new3$ratio_mf[which(new3$designation=="Chr Z")],new3$f_m[which(new3$designation=="Chr Z")], 
       col="blue", cex=0.75)

legend(x = "bottomleft",          # Position
       legend = c("Chr 5", "other autosome", "Chr Z", "mixed homology"),  # Legend texts
       #lty = c(1, 2),           # Line types
       pch = 1,
       cex = 0.9,
       col = c("red", "black", "blue", "grey"),           # Line colors
       bty = "n" # Removes the legend box
)  

dev.off()

#points(new2$ratio_mf[which(new2$scaf==31)],new2$m_f[which(new2$scaf==31)], col="orange", cex=3)

# I noticed that the way I have labelled points is very conservative. 
# Scaffolds are only colored (red, black, blue) if the synteny is exact.
# i.e. if a query scaffold is syntenic with more than one refernce scaffold (even if both are Chr 5), then it shows grey


# potentially a different way to go about it.. 
# use mutate functions to designate scaffolds with different possible combos of syntney results. 
# this is not really needed for the paper. ... 
new4 <- new3 %>%
  mutate(Chr5 = case_when(
    # When "AUTOS" is found, fill Seq_type with "autosome"
    grepl(pattern = "Chr 5", x = designation) ~ "yes",
    grepl(pattern = "TE", x = File) ~ "TE",
    grepl(pattern = "PNG", x = File) ~ "PNG",
    grepl(pattern = "CY", x = File) ~ "CY",
    grepl(pattern = "EC", x = File) ~ "EC",
  )) 
