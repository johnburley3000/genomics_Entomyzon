# Dec 9 2021
# plot pi for populations from autosome-wide SNPs using ANGSD
# using the appropriate deniminator

require(dplyr)
require(data.table)
library(tidyverse)
library(ggplot2)
library(patchwork)


PATH1="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/ANGSD/Data"
DATA="autos_2_1e5bp_nosexsegs"
POPS="pops"
fig_stub="/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/ANGSD/Figures/"

# read file path
all_paths <-
  list.files(path = PATH1,
             pattern = "*.pestPG",
             full.names = TRUE)
all_paths <- all_paths[grep(DATA, all_paths)]

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
  )) 

#remove(all_result)
#####

pi <- df1 %>%
  #filter(Chr == "scaffold_0") %>%
  mutate(tP_avg = tP/nSites) %>% 
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = Pop, y = tP_avg)) +
  geom_boxplot(notch = T, outlier.shape = NA) +
  coord_cartesian(ylim = c(0, 0.008)) +  
  #ylab("tP") +
  theme_linedraw() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +  
  labs(title = expression(italic(pi)))

Taj <- df1 %>%
  #filter(Chr == "scaffold_0") %>%
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = Pop, y = Tajima)) +
  geom_boxplot(notch = T, outlier.shape = NA) +
  coord_cartesian(ylim = c(-2, 2)) +  
  #ylab("Tajima's D") +
  theme_linedraw() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +  
  labs(title = "Tajima's D")

pi_Taj <- pi | Taj

  pi_Taj
  
ggsave(file = paste0(fig_stub, DATA, "_",POPS,"_pi_Taj_no-outliers.svg"),
         plot = pi_Taj,
         device = "svg",
         width = 100, height = 70, unit = "mm",
         dpi = "retina")


summary <- df1 %>%
  #filter(Chr == "scaffold_0") %>%
  mutate(tP_avg = tP/nSites) %>% 
  mutate(Pop = factor(Pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  group_by(Pop) %>%
  summarise(pi_mean = mean(tP_avg),
            pi_median = quantile(tP_avg, 0.5),
            pi_sd = sd(tP_avg),
            pi_25Q = quantile(tP_avg, 0.25),
            pi_75Q = quantile(tP_avg, 0.75),
            Taj_mean = mean(Tajima),
            Taj_median = quantile(Tajima, 0.5),
            Taj_sd = sd(Tajima),
            Taj_25Q = quantile(Tajima, 0.25),
            Taj_75Q = quantile(Tajima, 0.75))

summary  

write.csv(summary,paste0(fig_stub, DATA, "_",POPS,"_summary.csv")) 


mean(summary$pi_mean)
