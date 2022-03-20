# this script is to get stats for the main text from pop gen scans of neo-Z and Chr 1A
# assumes that the script to compile data and make plots has been sourced... 

library(car)


### Compare means between populations:
# Note that this isn't used in ms because the ANGSD approach is better for this. 
df_pi %>%
  group_by(pop) %>%
  summarise(mean_pi = mean(avg_pi),
            median_pi = median(avg_pi))

summary(df_pi$avg_pi)
summary(df_pi2$avg_pi)

# Compute the analysis of variance
pop.pi.aov <- aov(avg_pi ~ pop, data = df_pi)
# Summary of the analysis
summary(pop.pi.aov)
# there are significant differences among the populations...

TukeyHSD(pop.pi.aov)



### Compare means between regions:

regions_pi_sum <- df_pi2 %>%
  group_by(Region) %>%
  summarise(mean_pi = mean(avg_pi),
            median_pi = median(avg_pi))

regions_pi_sum <- df_pi2 %>%
  group_by(Region) %>%
  summarise(mean_pi = mean(avg_pi),
            median_pi = median(avg_pi),
            sd_pi = sd(avg_pi),
            pi_25Q = quantile(avg_pi, 0.25),
            pi_75Q = quantile(avg_pi, 0.75))

write.csv(regions_pi_sum,paste0(OUTSTUB, "pi summary in regions.csv")) 


# How much lower is pi on the added-Z than ancestral-Z?
pi_add<- 0.00158
pi_anc<- 0.00223
pi_c1a<- 0.00369
pi_newPAR <- 0.00428
pi_add/pi_anc
pi_newPAR/pi_c1a

pi_add/pi_newPAR
pi_anc/pi_newPAR

pi_add/pi_c1a
pi_anc/pi_c1a



# ANOVA compare pi between regions:
reg.pi.aov <- Anova(lm(tmp$avg_pi~tmp$Region),type=2)
reg.pi.aov

TukeyHSD(reg.pi.aov)

# ANOVA compare pi between regions:
one.way <- aov(avg_pi ~ Region, data = df_pi2)

summary(one.way)
# Tukey's posthoc: which regions have different pi??
TukeyHSD(one.way)



### FST:

one.way.fst.KP_EC <- aov(avg_wc_fst ~ Region, data = df_fst[which(df_fst$pop_pair=="KP-EC"),])
summary(one.way.fst.KP_EC)

one.way.fst.KP_TE <- aov(avg_wc_fst ~ Region, data = df_fst[which(df_fst$pop_pair=="KP-TE"),])
summary(one.way.fst.KP_TE)

fst_summary <- df_fst %>%
  #filter(pop_pair == "KP-EC") %>%
  group_by(Region, pop_pair) %>%
  summarise(mean_fst = mean(avg_wc_fst),
            median_fst = median(avg_wc_fst))
  

# For which regions does Fst (KP-EC) differ??
TukeyHSD(one.way.fst.KP_EC)

# For which regions does Fst (KP-TE) differ??
TukeyHSD(one.way.fst.KP_TE)

### INTROGRESSION EVIDENCE:

# Recent ((PNG,CY),EC)
bp_2
adm_rec <- df_bp %>%
  filter(Region %in% c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A")) %>%
  filter(Trio == "PNG_CY_EC") %>%
  drop_na()
head(adm_rec)
one.way.adm_rec <- aov(f_dM ~ Region, data = adm_rec)
summary(one.way.adm_rec)

# which regions differ in mean F_dm?  
TukeyHSD(one.way.adm_rec)
# summarize:
df_bp %>%
  filter(Region %in% c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A")) %>%
  filter(Trio == "PNG_CY_EC") %>%
  drop_na() %>%
  group_by(Region) %>%
  summarize(mean_fdm = mean(f_dM),
            Q25 = quantile(f_dM)[2],
            Q50 = quantile(f_dM)[3],
            Q75 = quantile(f_dM)[4])

n.gt0 <-length(which(adm_rec$f_dM[which(adm_rec$Region=="new PAR")] > 0))
n <- length(adm_rec$f_dM[which(adm_rec$Region=="Chr 1A")])
perc.gt0 <- (n.gt0 / n) * 100
perc.gt0

# Ancient ((EC,CY),TE)
bp_2i
adm_anc <- df_bp %>%
  filter(Region %in% c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A")) %>%
  filter(Trio == "EC_CY_TE") %>%
  drop_na()
head(adm_anc)
one.way.adm_anc <- aov(f_dM ~ Region, data = adm_anc)
summary(one.way.adm_anc)
# which regions differ in mean F_dm?  
TukeyHSD(one.way.adm_anc)
  
n.gt0 <-length(which(adm_anc$f_dM > 0))
n <- length(adm_anc$f_dM)
perc.gt0 <- (n.gt0 / n) * 100
perc.gt0

mean(adm_anc$f_dM)



