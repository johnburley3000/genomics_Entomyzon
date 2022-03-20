# Modified from 2018 and prior scripts

# Dec 2021:
# Used the data from this old analysis for plot in paper of genome-wide Fst (autosome, added-Z, anc-Z between subspeies)

# Dec 2021:
# Heavily stripped back this script to focus on what goes into the paper (and SI)
# don't forget to run the source code for split violin plots at bottom of this script

library(tidyr)
library(ggplot2)
library(dplyr)
#figstub <- "Rfigs/Fst_Nov2018/"
figstub_2021 <- "/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/ANGSD/Figures/"

#setwd("~/Documents/Harvard/Thesis_Project/analysis/04_ANGSD/")
setwd("/Users/johnburley/Dropbox (Brown)/Harvard/Thesis_Project/analysis/04_ANGSD")
temp = list.files(path="Results/Fst/Nov2018_vcftools/",  pattern="*.win50kb.windowed.weir.fst")
myfiles = lapply(paste0("Results/Fst/Nov2018_vcftools/",temp), read.delim)
names(myfiles) <- temp

fst01 <- as.data.frame(myfiles$`01_Ecyan24_AUTOSv2.dp5.mm1_KP_TE_win50kb.windowed.weir.fst`)
fst02 <- as.data.frame(myfiles$`02_Ecyan24_AUTOSv2.dp5.mm1_KP_PNG_win50kb.windowed.weir.fst`)
fst03 <- as.data.frame(myfiles$`03_Ecyan24_AUTOSv2.dp5.mm1_KP_CY_win50kb.windowed.weir.fst`)
fst04 <- as.data.frame(myfiles$`04_Ecyan24_AUTOSv2.dp5.mm1_KP_EC_win50kb.windowed.weir.fst`)
fst05 <- as.data.frame(myfiles$`05_Ecyan24_AUTOSv2.dp5.mm1_TE_PNG_win50kb.windowed.weir.fst`)
fst06 <- as.data.frame(myfiles$`06_Ecyan24_AUTOSv2.dp5.mm1_TE_CY_win50kb.windowed.weir.fst`)
fst07 <- as.data.frame(myfiles$`07_Ecyan24_AUTOSv2.dp5.mm1_TE_EC_win50kb.windowed.weir.fst`)
fst08 <- as.data.frame(myfiles$`08_Ecyan24_AUTOSv2.dp5.mm1_PNG_CY_win50kb.windowed.weir.fst`)
fst09 <- as.data.frame(myfiles$`09_Ecyan24_AUTOSv2.dp5.mm1_PNG_EC_win50kb.windowed.weir.fst`)
fst10 <- as.data.frame(myfiles$`10_Ecyan24_AUTOSv2.dp5.mm1_CY_EC_win50kb.windowed.weir.fst`)

fst11 <- as.data.frame(myfiles$`11_Ecyan_17males_ZCHROMv2.dp5.mm1_KP_m3_TE_m4_win50kb.windowed.weir.fst`)
fst12 <- as.data.frame(myfiles$`12_Ecyan_17males_ZCHROMv2.dp5.mm1_KP_m3_PNG_m2_win50kb.windowed.weir.fst`)
fst13 <- as.data.frame(myfiles$`13_Ecyan_17males_ZCHROMv2.dp5.mm1_KP_m3_CY_m4_win50kb.windowed.weir.fst`)
fst14 <- as.data.frame(myfiles$`14_Ecyan_17males_ZCHROMv2.dp5.mm1_KP_m3_EC_m4_win50kb.windowed.weir.fst`)
fst15 <- as.data.frame(myfiles$`15_Ecyan_17males_ZCHROMv2.dp5.mm1_TE_m4_PNG_m2_win50kb.windowed.weir.fst`)
fst16 <- as.data.frame(myfiles$`16_Ecyan_17males_ZCHROMv2.dp5.mm1_TE_m4_CY_m4_win50kb.windowed.weir.fst`)
fst17 <- as.data.frame(myfiles$`17_Ecyan_17males_ZCHROMv2.dp5.mm1_TE_m4_EC_m4_win50kb.windowed.weir.fst`)
fst18 <- as.data.frame(myfiles$`18_Ecyan_17males_ZCHROMv2.dp5.mm1_PNG_m2_CY_m4_win50kb.windowed.weir.fst`)
fst19 <- as.data.frame(myfiles$`19_Ecyan_17males_ZCHROMv2.dp5.mm1_PNG_m2_EC_m4_win50kb.windowed.weir.fst`)
fst20 <- as.data.frame(myfiles$`20_Ecyan_17males_ZCHROMv2.dp5.mm1_CY_m4_EC_m4_win50kb.windowed.weir.fst`)

# join the data needed:
#ll <- list(fst01,fst11,fst02,fst12,fst02,fst13,fst04,fst14,fst05,fst15,fst06,fst16,fst07,fst17,fst08,fst18,fst09,fst19,fst10,fst20)
ll <- list(fst01,fst02,fst03,fst04,fst05,fst06,fst07,fst08,fst09,fst10,fst11,fst12,fst13,fst14,fst15,fst16,fst17,fst18,fst19,fst20)

# add an integer to distinguish each pop pair:
for(i in seq(1,20)){
  ll[[i]]$poppair <- rep(paste0(i),nrow(ll[[i]]))
}
# add a character to distinguish chromosome type:
for(i in seq(1,10)){
  ll[[i]]$chr <- rep("autosome",nrow(ll[[i]]))
}
for(i in seq(11,20)){
  ll[[i]]$chr <- rep("Z",nrow(ll[[i]]))
}

df <- data.frame()
for(i in seq(1,20)){
  data <- data.frame(ll[[i]])
  df <- rbind(df,data)
}

# rename poppair column to indicate population pair
df$poppair[df$poppair%in%c(1,11)] <- "KP-TE"
df$poppair[df$poppair%in%c(2,12)] <- "KP-PNG"
df$poppair[df$poppair%in%c(3,13)] <- "KP-CY"
df$poppair[df$poppair%in%c(4,14)] <- "KP-EC"
df$poppair[df$poppair%in%c(5,15)] <- "TE-PNG"
df$poppair[df$poppair%in%c(6,16)] <- "TE-CY"
df$poppair[df$poppair%in%c(7,17)] <- "TE-EC"
df$poppair[df$poppair%in%c(8,18)] <- "PNG-CY"
df$poppair[df$poppair%in%c(9,19)] <- "PNG-EC"
df$poppair[df$poppair%in%c(10,20)] <- "CY-EC"
# How to arrange the pop combo's by rank Fst autosome?
res <- data.frame(matrix(nrow = 10, ncol = 3))
for(i in seq(1,10)){
  res[i, 1] <- mean(ll[[i]]$MEAN_FST)
  res[i, 2] <- ll[[i]]$poppair[1]
  res[i, 3] <- median(ll[[i]]$MEAN_FST)
}
# must be a way to simply order these, otherwise:
arrange(res, by = X1)
order <- c("KP-TE","PNG-CY","TE-CY","KP-CY","TE-PNG","CY-EC","PNG-EC","KP-PNG","TE-EC","KP-EC")
# note that the order by median is v slightly different..

##### GOOD PLOT:
# see code below for split violin plot: https://stackoverflow.com/questions/35717353/split-violin-plot-with-ggplot2/45614547#45614547
ggplot(df, aes(x=poppair, y=MEAN_FST, fill = chr)) + 
  geom_split_violin() +
  scale_x_discrete(limits=order) +
  labs(x = "population pair", y = "Fst", fill = "chromosome") +
  #stat_summary(fun.y=median.quartile,geom='point') +
  coord_flip()
dev.copy2pdf(width = 4, height = 5, out.type = "pdf", file=paste0(figstub,"Fst_populations_Autosome-vs-Z.pdf"))
# Possibly use something like the function below to mark the median or mean for each fst distribution
median.quartile <- function(x){
  out <- quantile(x, probs = c(0.25,0.5,0.75))
  names(out) <- c("ymin","y","ymax")
  return(out) 
}

###################################################################################
#### Now try a split violin plot for the subspecies, on z chrom vs neo-Z chromosoms
fst31 <- as.data.frame(myfiles$`31_Ecyan24_AUTOSv2.dp5.mm1_albi_gris_win50kb.windowed.weir.fst`)
fst32 <- as.data.frame(myfiles$`32_Ecyan24_AUTOSv2.dp5.mm1_albi_cyan_win50kb.windowed.weir.fst`)
fst33 <- as.data.frame(myfiles$`33_Ecyan24_AUTOSv2.dp5.mm1_gris_cyan_win50kb.windowed.weir.fst`)
fst34 <- as.data.frame(myfiles$`34_Ecyan_17males_ZCHROMv2.dp5.mm1_albi_m7_gris_m6_win50kb.windowed.weir.fst`)
fst35 <- as.data.frame(myfiles$`35_Ecyan_17males_ZCHROMv2.dp5.mm1_albi_m7_cyan_m4_win50kb.windowed.weir.fst`)
fst36 <- as.data.frame(myfiles$`36_Ecyan_17males_ZCHROMv2.dp5.mm1_gris_m6_cyan_m4_win50kb.windowed.weir.fst`)
fst37 <- as.data.frame(myfiles$`37_Ecyan_17males_NEOZv2.dp5.mm1_albi_m7_gris_m6_win50kb.windowed.weir.fst`)
fst38 <- as.data.frame(myfiles$`38_Ecyan_17males_NEOZv2.dp5.mm1_albi_m7_cyan_m4_win50kb.windowed.weir.fst`)
fst39 <- as.data.frame(myfiles$`39_Ecyan_17males_NEOZv2.dp5.mm1_gris_m6_cyan_m4_win50kb.windowed.weir.fst`)

ll_subsp <- list(fst31,fst32,fst33,fst34,fst35,fst36,fst37,fst38,fst39)

# add an integer to distinguish each pop pair:
for(i in seq(1,9)){
  ll_subsp[[i]]$poppair <- rep(paste0(i),nrow(ll_subsp[[i]]))
}
# add a character to distinguish chromosome type:
for(i in seq(1,3)){
  ll_subsp[[i]]$chr <- rep("autosomes",nrow(ll_subsp[[i]]))
}
for(i in seq(4,6)){
  ll_subsp[[i]]$chr <- rep("ancestral-Z",nrow(ll_subsp[[i]]))
}
for(i in seq(7,9)){
  ll_subsp[[i]]$chr <- rep("added-Z NR",nrow(ll_subsp[[i]]))
}

#put everything in a df
df_subsp <- data.frame()
for(i in seq(1,9)){
  data <- data.frame(ll_subsp[[i]])
  df_subsp <- rbind(df_subsp,data)
}

# rename poppair column to indicate population pair
df_subsp$poppair[df_subsp$poppair%in%c(1,4,7)] <- "albi-gris"
df_subsp$poppair[df_subsp$poppair%in%c(2,5,8)] <- "albi-cyan"
df_subsp$poppair[df_subsp$poppair%in%c(3,6,9)] <- "gris-cyan"

# How to arrange the pop combo's by rank Fst autosome?
res <- data.frame(matrix(nrow = 10, ncol = 3))
for(i in seq(1,9)){
  res[i, 1] <- mean(ll_subsp[[i]]$MEAN_FST)
  res[i, 2] <- ll_subsp[[i]]$poppair[1]
  res[i, 3] <- median(ll_subsp[[i]]$MEAN_FST)
}
# must be a way to simply order these, otherwise:
#arrange(res, by = X1)
#order <- c("KP-TE","PNG-CY","TE-CY","KP-CY","TE-PNG","CY-EC","PNG-EC","KP-PNG","TE-EC","KP-EC")
# note that the order by median is v slightly different..

##### GOOD PLOT:
ggplot(df_subsp, aes(x=poppair, y=MEAN_FST, fill = chr)) + 
  geom_violin() +
  #scale_x_discrete(limits=order) +
  labs(x = "subspecies pair", y = "Fst", fill = "chromosome") +
  #stat_summary(fun.y=median.quartile,geom='point') +
  coord_flip()
dev.copy2pdf(width = 4, height = 5, out.type = "pdf", file=paste0(figstub,"Fst_subspecies_Autosome-vs-Z-vs-neoZ.pdf"))

# PLOT FOR MANUSCRIPT:
p <- ggplot(df_subsp, aes(x=chr, y=MEAN_FST)) + 
  geom_violin(fill = "grey80") 

Fst_plot <- p + facet_grid(poppair ~ .) + #coord_flip() + 
  geom_boxplot(outlier.shape = NA, width=0.1) + 
  labs(x = NULL, y = expression(italic(F[ST]))) +
  coord_flip() +
  theme_linedraw()

Fst_plot
dev.copy2pdf(width = 4, height = 4, out.type = "pdf", file=paste0(figstub_2021,"Fst_subspecies_Autosome-vs-Z-vs-neoZ_B_Dec2021.pdf"))


svg(width = 4, height = 4, filename = paste0(figstub_2021,"Fst_subspecies_Autosome-vs-Z-vs-neoZ_B_Dec2021.svg"))
Fst_plot
dev.off()


# Get the mean, median etc. for the manuscript text:

df_subsp %>%
  group_by(poppair, chr) %>%
  summarise(mean_fst = mean(MEAN_FST),
            fst_25Q = quantile(MEAN_FST, 0.25),
            fst_median = quantile(MEAN_FST, 0.5),
            fst_75Q = quantile(MEAN_FST, 0.75)
  ) %>%
  arrange(chr)
            
            


# split violin plot with only Z and autos:
df_subsp_subset <- df_subsp %>%
  filter(chr!="neo-Z")
ggplot(df_subsp_subset, aes(x=poppair, y=MEAN_FST, fill = chr)) + 
  geom_split_violin() +
  scale_x_discrete(limits=c("gris-cyan", "albi-cyan", "albi-gris")) +
  labs(x = "subspecies pair", y = "Fst", fill = "chromosome") +
  coord_flip()
dev.copy2pdf(width = 4, height = 5, out.type = "pdf", file=paste0(figstub,"Fst_subspecies_Autosome-vs-Z-vs-neoZ_B.pdf"))
# in this plot, it's surprising that alb-cyan and albi-gris are so different.
# plot the raw data, just to make sure there wasn't a mix-up in R.
plot(density(myfiles$`31_Ecyan24_AUTOSv2.dp5.mm1_albi_gris_win50kb.windowed.weir.fst`$MEAN_FST))
lines(density(myfiles$`32_Ecyan24_AUTOSv2.dp5.mm1_albi_cyan_win50kb.windowed.weir.fst`$MEAN_FST), col = "red")
lines(density(myfiles$`33_Ecyan24_AUTOSv2.dp5.mm1_gris_cyan_win50kb.windowed.weir.fst`$MEAN_FST), col = "blue")


###################################################################################
#### Similarly to above,
#### How about comparing the subspecies Fsts on different sequence types, on the autosomes:
#### SEQUENCE-TYPE ANALYSIS

#1 import a new myfiles equiv. so as not to get confused:
temp = c(
  list.files(path="Results/Fst/Nov2018_vcftools/",  pattern="CDS"),
  list.files(path="Results/Fst/Nov2018_vcftools/",  pattern="intron"),
  list.files(path="Results/Fst/Nov2018_vcftools/",  pattern="intergenic")
)
myfiles = lapply(paste0("Results/Fst/Nov2018_vcftools/",temp), read.delim)
names(myfiles) <- temp

fst01 <- as.data.frame(myfiles$`01_Ecyan24_AUTOSv2.dp5.mm1_CDS_KP_TE_win50kb.windowed.weir.fst`)
fst02 <- as.data.frame(myfiles$`02_Ecyan24_AUTOSv2.dp5.mm1_CDS_KP_PNG_win50kb.windowed.weir.fst`)
fst03 <- as.data.frame(myfiles$`03_Ecyan24_AUTOSv2.dp5.mm1_CDS_KP_CY_win50kb.windowed.weir.fst`)
fst04 <- as.data.frame(myfiles$`04_Ecyan24_AUTOSv2.dp5.mm1_CDS_KP_EC_win50kb.windowed.weir.fst`)
fst05 <- as.data.frame(myfiles$`05_Ecyan24_AUTOSv2.dp5.mm1_CDS_TE_PNG_win50kb.windowed.weir.fst`)
fst06 <- as.data.frame(myfiles$`06_Ecyan24_AUTOSv2.dp5.mm1_CDS_TE_CY_win50kb.windowed.weir.fst`)
fst07 <- as.data.frame(myfiles$`07_Ecyan24_AUTOSv2.dp5.mm1_CDS_TE_EC_win50kb.windowed.weir.fst`)
fst08 <- as.data.frame(myfiles$`08_Ecyan24_AUTOSv2.dp5.mm1_CDS_PNG_CY_win50kb.windowed.weir.fst`)
fst09 <- as.data.frame(myfiles$`09_Ecyan24_AUTOSv2.dp5.mm1_CDS_PNG_EC_win50kb.windowed.weir.fst`)
fst10 <- as.data.frame(myfiles$`10_Ecyan24_AUTOSv2.dp5.mm1_CDS_CY_EC_win50kb.windowed.weir.fst`)

fst11 <- as.data.frame(myfiles$`11_Ecyan24_AUTOSv2.dp5.mm1_intergenic_KP_TE_win50kb.windowed.weir.fst`)
fst12 <- as.data.frame(myfiles$`12_Ecyan24_AUTOSv2.dp5.mm1_intergenic_KP_PNG_win50kb.windowed.weir.fst`)
fst13 <- as.data.frame(myfiles$`13_Ecyan24_AUTOSv2.dp5.mm1_intergenic_KP_CY_win50kb.windowed.weir.fst`)
fst14 <- as.data.frame(myfiles$`14_Ecyan24_AUTOSv2.dp5.mm1_intergenic_KP_EC_win50kb.windowed.weir.fst`)
fst15 <- as.data.frame(myfiles$`15_Ecyan24_AUTOSv2.dp5.mm1_intergenic_TE_PNG_win50kb.windowed.weir.fst`)
fst16 <- as.data.frame(myfiles$`16_Ecyan24_AUTOSv2.dp5.mm1_intergenic_TE_CY_win50kb.windowed.weir.fst`)
fst17 <- as.data.frame(myfiles$`17_Ecyan24_AUTOSv2.dp5.mm1_intergenic_TE_EC_win50kb.windowed.weir.fst`)
fst18 <- as.data.frame(myfiles$`18_Ecyan24_AUTOSv2.dp5.mm1_intergenic_PNG_CY_win50kb.windowed.weir.fst`)
fst19 <- as.data.frame(myfiles$`19_Ecyan24_AUTOSv2.dp5.mm1_intergenic_PNG_EC_win50kb.windowed.weir.fst`)
fst20 <- as.data.frame(myfiles$`20_Ecyan24_AUTOSv2.dp5.mm1_intergenic_CY_EC_win50kb.windowed.weir.fst`)

# here is the data for the subgenome comparison plot:
fst31 <- as.data.frame(myfiles$`31_Ecyan24_AUTOSv2.dp5.mm1_CDS_albi_gris_win50kb.windowed.weir.fst`)
fst32 <- as.data.frame(myfiles$`32_Ecyan24_AUTOSv2.dp5.mm1_CDS_albi_cyan_win50kb.windowed.weir.fst`)
fst33 <- as.data.frame(myfiles$`33_Ecyan24_AUTOSv2.dp5.mm1_CDS_gris_cyan_win50kb.windowed.weir.fst`)
fst34 <- as.data.frame(myfiles$`34_Ecyan24_AUTOSv2.dp5.mm1_intergenic_albi_gris_win50kb.windowed.weir.fst`)
fst35 <- as.data.frame(myfiles$`35_Ecyan24_AUTOSv2.dp5.mm1_intergenic_albi_cyan_win50kb.windowed.weir.fst`)
fst36 <- as.data.frame(myfiles$`36_Ecyan24_AUTOSv2.dp5.mm1_intergenic_gris_cyan_win50kb.windowed.weir.fst`)
fst37 <- as.data.frame(myfiles$`37_Ecyan24_AUTOSv2.dp5.mm1_intron_albi_gris_win50kb.windowed.weir.fst`)
fst38 <- as.data.frame(myfiles$`38_Ecyan24_AUTOSv2.dp5.mm1_intron_albi_cyan_win50kb.windowed.weir.fst`)
fst39 <- as.data.frame(myfiles$`39_Ecyan24_AUTOSv2.dp5.mm1_intron_gris_cyan_win50kb.windowed.weir.fst`)

ll_subsp <- list(fst31,fst32,fst33,fst34,fst35,fst36,fst37,fst38,fst39)

# add an integer to distinguish each pop pair:
for(i in seq(1,9)){
  ll_subsp[[i]]$poppair <- rep(paste0(i),nrow(ll_subsp[[i]]))
}
# add a character to distinguish chromosome type:
for(i in seq(1,3)){
  ll_subsp[[i]]$seq <- rep("coding",nrow(ll_subsp[[i]]))
}
for(i in seq(4,6)){
  ll_subsp[[i]]$seq <- rep("intergenic",nrow(ll_subsp[[i]]))
}
for(i in seq(7,9)){
  ll_subsp[[i]]$seq <- rep("intron",nrow(ll_subsp[[i]]))
}

#put everything in a df
df_subsp <- data.frame()
for(i in seq(1,9)){
  data <- data.frame(ll_subsp[[i]])
  df_subsp <- rbind(df_subsp,data)
}

# rename poppair column to indicate population pair
df_subsp$poppair[df_subsp$poppair%in%c(1,4,7)] <- "albi-gris"
df_subsp$poppair[df_subsp$poppair%in%c(2,5,8)] <- "albi-cyan"
df_subsp$poppair[df_subsp$poppair%in%c(3,6,9)] <- "gris-cyan"

# weighted vs man fst:
ggplot(data = df_subsp, aes(x = WEIGHTED_FST, y = MEAN_FST)) +
  geom_point() +
  facet_grid(poppair ~ seq)

mean(df_subsp$WEIGHTED_FST[which(df_subsp$poppair == "albi-cyan" & df_subsp$seq == "intron")])
mean(df_subsp$MEAN_FST[which(df_subsp$poppair == "albi-cyan"& df_subsp$seq == "intron")])

# check out summaries
res <- data.frame(matrix(nrow = 10, ncol = 3))
for(i in seq(1,9)){
  res[i, 1] <- mean(ll_subsp[[i]]$MEAN_FST)
  res[i, 2] <- ll_subsp[[i]]$poppair[1]
  res[i, 3] <- median(ll_subsp[[i]]$MEAN_FST)
}

##### GOOD PLOT:
ggplot(df_subsp, aes(x=poppair, y=MEAN_FST, fill = seq)) + 
  geom_violin() +
  #scale_x_discrete(limits=order) +
  labs(x = "subspecies pair", y = "Fst", fill = "sequence type") +
  coord_flip()
#dev.copy2pdf(width = 4, height = 5, out.type = "pdf", file=paste0(figstub,"Fst_subspecies_Autosome-vs-Z-vs-neoZ.pdf"))

# differnt approach:
p <- ggplot(df_subsp, aes(x=seq, y=MEAN_FST)) + 
  geom_violin() 
p + facet_grid(poppair ~ .) + coord_flip() + 
  geom_boxplot(outlier.shape = NA, width=0.1) + 
  labs(x = NULL, y = "Fst")
dev.copy2pdf(width = 4, height = 4, out.type = "pdf", file=paste0(figstub,"Fst_subspecies_Autosomes_intron-intergenic-coding.pdf"))


###################################################################################
#### How about correlation between pairwise Fst between pops on autosomes and sex chrom(s)

df_meanfsts <- df %>%
  group_by(poppair, chr) %>%
  summarise(Fstmean = mean(MEAN_FST)) %>%
  spread(chr,Fstmean)
plot(df_meanfsts$autosome,df_meanfsts$Z)

df_meanfsts$inclEC <- if_else(grepl("EC",df_meanfsts$poppair), "yes", "no")
df_meanfsts$ZtoAutoRatio <- df_meanfsts$Z/df_meanfsts$autosome
# plot points of any pair involving EC

ggplot(df_meanfsts, aes(x=autosome, y=Z, shape = inclEC)) +
  geom_smooth(method = "lm", fill = NA, colour = "black") +
  geom_point(colour = "black", size = 2.5) + 
  geom_point(colour = "white", size = 1) +
  geom_abline(slope = 1, intercept = 0, linetype = 2) +
  geom_abline(slope = 2, intercept = 0, linetype = 2, colour = "red") +
  xlim(0,0.6) + ylim(0,0.6) +
  labs(title = "pairwise Fst", x = "autosomes", y = "Z chromosome", shape = "pair\nincludes\nEC")
dev.copy2pdf(width = 5, height = 4, out.type = "pdf", file=paste0(figstub,"Fst_subspecies_Autosome-vs-Z-regression.pdf"))

###################################################################################
#### some Fst scans for fun:

fst33$window <- seq(1,nrow(fst33))
fst33$contig_start <- if_else(fst33$BIN_START==1, 1, 0)
plot(fst33$window, fst33$MEAN_FST, pch = 20, cex=0.1)

# NICER LOOKIN' FST SCANS
# modified from: https://www.r-graph-gallery.com/wp-content/uploads/2018/02/Manhattan_plot_in_R.html

#PARTIAL SCAN (single scaf):
# 1 make a df:
for(i in c("scaffold_0","scaffold_1","scaffold_2","scaffold_3")){
  df_scan <- fst33 %>%
    filter(CHROM==paste0(i))
  # plot a scan:
  ggplot(df_scan, aes(x=BIN_START, y=MEAN_FST)) +
    geom_point(size=0.05) +
    theme(legend.position="none") +
    ylim(0,0.6) 
}

fst_temp <- fst33[1:5000,]
#FULL SCAN:
# get contig count:
contigcount <- length(unique(fst33$CHROM))
ordercontigs <- unique(fst33$CHROM)
ggplot(fst33, aes(x=window, y=MEAN_FST)) +
  
  # Show all points coloured by scaffold
  #geom_point( aes(color=as.factor(CHROM)), alpha=1, size=0.05) +
  #scale_color_manual(values = rep(c("red", "blue", "black", "green"), contigcount/4 )) +
  
  # add a line for mean + 3*sd
  geom_hline(yintercept = mean(fst33$MEAN_FST)+3*sd(fst33$MEAN_FST), linetype = 2) +
  geom_vline(xintercept = fst33$window[which(fst33$contig_start==1)], linetype = 1, alpha = 0.3) +

  # Show all points no colour
  geom_point(alpha=1, size=0.3, colour = "brown") +
  
  
# Custom the theme:
theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )
dev.copy2pdf(width = 20, height = 4, out.type = "pdf", file=paste0(figstub,"fst33_cyan-gris_hline:3sd-above-mean_vlines:scaffold-breaks.pdf"))
par(mfrow=c(2,1))
hist(fst33$MEAN_FST, breaks = seq(min(fst33$MEAN_FST)-0.1,1,0.01), main = NULL)
hist(fst33$MEAN_FST, breaks = seq(min(fst33$MEAN_FST)-0.1,1,0.01), ylim = c(0,20), main = NULL)

dev.copy2pdf(width = 6, height = 10, out.type = "pdf", file=paste0(figstub,"fst33_cyan-gris_histogram_bin0.01.pdf"))


###################################################################################
#####
#### Correlated Fst windows?

merger1 <- fst34#fst31#fst01 
merger2 <- fst35#fst32#fst08
merger1$pos <- paste(merger1$CHROM,merger1$BIN_START)
merger2$pos <- paste(merger2$CHROM,merger2$BIN_START)
merge2pop <- merge(merger1, merger2, by = "pos")
plot(merge2pop$MEAN_FST.x, merge2pop$MEAN_FST.y, xlab = "1", ylab = "2")
abline(a=0,b=1)

# How many "outlier windows" are there?
genomewidemean <- mean(fst33$MEAN_FST)
meanplus3sd <- genomewidemean + 3*sd(fst33$MEAN_FST)
n_outliers <- nrow(fst33[which(fst33$MEAN_FST > meanplus3sd),])
frac_outliers <- n_outliers / nrow(fst31)

plot(fst33$MEAN_FST,fst33$N_VARIANTS)

# remove windows with few variants:
outliers <- fst33 %>%
  filter(MEAN_FST > meanplus3sd) %>%
  filter(N_VARIANTS > 2)
###########################
##### Histograms

par(mfrow=c(1,1))
temp_intergenic <- fst36$MEAN_FST
temp_intron <- fst39$MEAN_FST
temp_CDS <- fst33$MEAN_FST

hist(temp_intergenic, breaks = seq(-0.2,1.01,0.01), main = "intergenic - clear \n intron - blue \n CDS - red")
hist(temp_intron, breaks = seq(-0.2,1.01,0.01), main = NULL, col=rgb(0,0,1,0.5), alpha = 0.5, add = T)
hist(temp_CDS, breaks = seq(-0.2,1.01,0.01), main = NULL, col=rgb(1,0,0,0.5), add = T, alpha = 0.5)
dev.copy2pdf(width = 6, height = 5, out.type = "pdf", file=paste0(figstub,"fst_win50kb_cyan-gris_histogram_bin0.01_intron-exon.pdf"))

mean(temp_intergenic)
mean(temp_intron)
mean(temp_CDS)

# Try a histogram to replace the viol plot of subspecies Fst comparing subgenomes:
df_hist <- df_subsp %>%
  filter(seq != "intergenic") %>%
  filter(poppair == "albi-cyan")
  
p <- ggplot(df_hist, aes(x=MEAN_FST, color = seq))
p + geom_histogram(binwidth = 0.03, fill="white", alpha=0.5, position="dodge") +
  xlim(0,1) + 
  labs(x = "mean Fst per 50kb window") +
  facet_grid(. ~ poppair) 
dev.copy2pdf(width = 9, height = 4, out.type = "pdf", file=paste0(figstub,"fst_win50kb_subspp_hist_intron-exon_bin0.03.pdf"))

df_subsp.filt <- df_subsp %>%
  filter(N_VARIANTS > 30)
ggplot(df_subsp.filt, aes(x = poppair, y = MEAN_FST)) +
  geom_boxplot(aes(fill = seq), outlier.shape = NA)
dev.copy2pdf(width = 9, height = 4, out.type = "pdf", file=paste0(figstub,"fst_win50kb_subspp_boxplot_intron-exon_gt15variantsperwin.pdf"))

# COMPARE WEIGHTED AND MEAN FST

ggplot(df_subsp.filt, aes(x = MEAN_FST, y = WEIGHTED_FST)) +
  geom_point(aes(colour = N_VARIANTS, alpha = 0.5)) +
  facet_grid(seq ~ poppair) +
  scale_colour_gradientn(colours = rainbow(10))
  
  #geom_vline(data=df_hist, aes(xintercept=mean(MEAN_FST), color=seq), linetype="dashed") 

###########################
####################### END

# CODE FOR GEOMSPLITVIOLIN
GeomSplitViolin <- ggproto("GeomSplitViolin", GeomViolin, 
                             draw_group = function(self, data, ..., draw_quantiles = NULL) {
                               data <- transform(data, xminv = x - violinwidth * (x - xmin), xmaxv = x + violinwidth * (xmax - x))
                               grp <- data[1, "group"]
                               newdata <- plyr::arrange(transform(data, x = if (grp %% 2 == 1) xminv else xmaxv), if (grp %% 2 == 1) y else -y)
                               newdata <- rbind(newdata[1, ], newdata, newdata[nrow(newdata), ], newdata[1, ])
                               newdata[c(1, nrow(newdata) - 1, nrow(newdata)), "x"] <- round(newdata[1, "x"])
                               
                               if (length(draw_quantiles) > 0 & !scales::zero_range(range(data$y))) {
                                 stopifnot(all(draw_quantiles >= 0), all(draw_quantiles <=
                                                                           1))
                                 quantiles <- ggplot2:::create_quantile_segment_frame(data, draw_quantiles)
                                 aesthetics <- data[rep(1, nrow(quantiles)), setdiff(names(data), c("x", "y")), drop = FALSE]
                                 aesthetics$alpha <- rep(1, nrow(quantiles))
                                 both <- cbind(quantiles, aesthetics)
                                 quantile_grob <- GeomPath$draw_panel(both, ...)
                                 ggplot2:::ggname("geom_split_violin", grid::grobTree(GeomPolygon$draw_panel(newdata, ...), quantile_grob))
                               }
                               else {
                                 ggplot2:::ggname("geom_split_violin", GeomPolygon$draw_panel(newdata, ...))
                               }
                             })
  
  geom_split_violin <- function(mapping = NULL, data = NULL, stat = "ydensity", position = "identity", ..., 
                                draw_quantiles = NULL, trim = TRUE, scale = "area", na.rm = FALSE, 
                                show.legend = NA, inherit.aes = TRUE) {
    layer(data = data, mapping = mapping, stat = stat, geom = GeomSplitViolin, 
          position = position, show.legend = show.legend, inherit.aes = inherit.aes, 
          params = list(trim = trim, scale = scale, draw_quantiles = draw_quantiles, na.rm = na.rm, ...))
  }
