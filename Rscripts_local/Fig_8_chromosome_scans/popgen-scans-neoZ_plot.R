### plotting 

# libs:
library(dplyr)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(viridis)
library(RColorBrewer)
library(wesanderson)
library(patchwork)



### CHANGES TO MAKE FOR NEXT TIME:
# 1. Update the data compilation code to properly join Chr1A scaffolds and flop Ancestral Z
# 2. Remove the dxy boxplot as it is just correlated with pi
# 3. Remove the ancestral Z-PAR from all boxplots except pi, as it is not very different to surrounding. 
# 4. add a scans and box plot to show ancestral introgression ((CY, PNG), TE), to show how patterns differ. 
# 5. check that the data aren't being cut out in Fst scans using the deceptive ylim()
# 6. make sure the span param is update in Figure legends, and same for each variable... 


# setup palettes
colors =  brewer.pal(10, "Spectral") #dxy and fst line cols
wes_palette = wes_palette(n=5, name="Moonrise3") # cols for 

######
###### pi
######

pi <- df_pi2 %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = pos_mb, y = avg_pi, col = Region)) +
  geom_point(alpha = 0.8) +
  #geom_point(size = 0.5, shape = 21, stroke = 1, col = Region, alpha = 0.5) +
  scale_color_manual(values=wes_palette) + # guide = "None"
  geom_smooth(method="loess", se=F, fullrange=F, level=0.95, span = 0.1, col = "black") +
  scale_x_continuous(name = "genomic position (Mbp)", breaks = seq(0, max(df_pi2$pos_mb), by = 10)) +
  #geom_vline(xintercept = 17.4, linetype = "dashed", alpha = 0.5) +
  facet_wrap('Chr', scales = 'free_x', nrow = 1) + 
  geom_vline(data = df_pi2[which(df_pi2$Chr=="added-Z"),], 
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

pi_box  <- df_pi2 %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = Region, y = avg_pi, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  scale_y_continuous(position = "left") +
  #scale_x_discrete(labels= c("new\nPAR", "add.\nZ-NR", "anc.\nZ-PAR", "anc.\nZ", "Chr\n1A")) +
  #scale_x_discrete(labels= c("add-Z\nPAR", "add-Z\nNR", "anc-Z\nPAR", "anc-\nZ", "Chr\n1A")) +
  scale_x_discrete(labels= c("add-Z PAR", "add-Z NR", "anc-Z PAR", "anc-Z", "Chr 1A")) +
  coord_cartesian(ylim = c(0, 0.01)) +  
  scale_fill_manual(values=wes_palette) +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 9, angle = 45,vjust=0.5)
  ) +  
  labs(title = expression(italic(pi)))


pi_box


######
###### DXY
######

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
  coord_cartesian(ylim = c(0, 0.013)) +  
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
        axis.text.y = element_text(size = 9),
        legend.position="bottom") +
  labs(title = expression(italic(d[XY])))

dxy_box


######
###### FST


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
  #filter(Region != "ancestral Z-PAR") %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = pop_pair, y = avg_wc_fst, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  scale_y_continuous(position = "left") +
  scale_x_discrete(labels= c("KP-EC", "KP-TE")) +
  #coord_cartesian(ylim = c(0, 0.01)) +  
  scale_fill_manual(values=wes_palette[c(1,2,4,5)]) +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 9)
  ) +
  labs(title = expression(italic(F[ST])))

fst_box

######
###### f_dm
#####

bp_2 <- df_bp %>%
  filter(Chr %in% c("Chr 1A", "ancestral-Z", "added-Z")) %>%
  filter(Trio == "PNG_CY_EC") %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  drop_na() %>%
  ggplot(aes(x = Region, y = f_dM, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  ylab(expression(italic(f[dM]))) +
  geom_hline(yintercept = 0) +
  #facet_wrap('Trio', nrow = 3, strip.position = "right", scales="free_y") +
  coord_cartesian(ylim = c(-0.06, 0.11)) +  
  #scale_x_discrete(labels= c("add-Z\nPAR", "add-Z\nNR", "anc-\nZ", "Chr\n1A")) +
  scale_x_discrete(labels= c("add-Z PAR", "add-Z NR", "anc-Z", "Chr 1A")) +
  scale_fill_manual(values=wes_palette[c(1,2,4,5)]) +
  theme_linedraw() +
  theme(strip.background = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 9, angle = 45,vjust=0.5)
  ) +
  #labs(title = paste0(expression(italic(f[dM])), " ((PNG,CY),EC)"))
  labs(title = expression(italic(f[dM])~"((PNG,CY),EC)"))

        #axis.title.y=element_text(angle = 0, vjust = 0.5)) +

bp_2

bp_2i <- df_bp %>%
  filter(Chr %in% c("Chr 1A", "ancestral-Z", "added-Z")) %>%
  filter(Trio == "EC_CY_TE") %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  drop_na() %>%
  ggplot(aes(x = Region, y = f_dM, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = FALSE) +
  ylab(expression(italic(f[dM]))) +
  geom_hline(yintercept = 0) +
  #facet_wrap('Trio', nrow = 3, strip.position = "right", scales="free_y") +
  coord_cartesian(ylim = c(-0.06, 0.11)) +  
  #scale_x_discrete(labels= c("add-Z\nPAR", "add-Z\nNR", "anc-\nZ", "Chr\n1A")) +
  scale_x_discrete(labels= c("add-Z PAR", "add-Z NR", "anc-Z", "Chr 1A")) +
  scale_fill_manual(values=wes_palette[c(1,2,4,5)]) +
  theme_linedraw() +
  theme(strip.background = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 9, angle = 45,vjust=0.5)
  ) +
  #labs(title = paste0(expression(italic(f[dM])), " ((PNG,CY),EC)"))
  labs(title = expression(italic(f[dM])~"((EC,CY),TE)"))

#axis.title.y=element_text(angle = 0, vjust = 0.5)) +

bp_2i

# run scan using overlapping windows


ap_2 <- df_ap %>%
  filter(Chr %in% c("Chr 1A", "ancestral-Z", "added-Z")) %>%
  filter(Trio == "PNG_CY_EC") %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  drop_na() %>%
  ggplot(aes(x = pos_mb, y = f_dM)) +
  geom_area(show.legend=T) +
  #geom_point() +
  #facet_wrap('chr', scales = 'fixed', nrow = 1) + 
  facet_grid(~ Chr, scales = "free_x") +
  scale_x_continuous(name = "genomic position (Mbp)", 
                     breaks = seq(0, max(df_ap$pos_mb), by = 10)) +
  ylab(expression(italic(f[dM]))) +
  geom_vline(data = df_ap[which(df_ap$Chr=="added-Z"),], mapping = aes(xintercept = tr1/1000000), linetype = "dashed", alpha = 0.5) +
  #theme_classic() +
  theme_linedraw(base_size = 10) +
  theme(strip.text.y = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))

ap_2

ap_2i <- df_ap %>%
  filter(Chr %in% c("Chr 1A", "ancestral-Z", "added-Z")) %>%
  filter(Trio == "EC_CY_TE") %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral-Z", "Chr 1A"))) %>%
  drop_na() %>%
  ggplot(aes(x = pos_mb, y = f_dM)) +
  geom_area(show.legend=T) +
  #geom_point() +
  #facet_wrap('chr', scales = 'fixed', nrow = 1) + 
  facet_grid(~ Chr, scales = "free_x") +
  scale_x_continuous(name = "genomic position (Mbp)", 
                     breaks = seq(0, max(df_ap$pos_mb), by = 10)) +
  ylab(expression(italic(f[dM]))) +
  geom_vline(data = df_ap[which(df_ap$Chr=="added-Z"),], mapping = aes(xintercept = tr1/1000000), linetype = "dashed", alpha = 0.5) +
  #theme_classic() +
  theme_linedraw(base_size = 10) +
  theme(strip.text.y = element_blank(),
        strip.text.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))

ap_2i


######
###### Draw and save full plot:

layout2 <- "
ABCD
EEEE
FFFF
GGGG
HHHH"

full_plot2 <- pi_box  + dxy_box + fst_box + bp_2 + pi + dxy + fst + ap_2 +
  plot_layout(design = layout2, widths = c(1.1,1,1,0.9), heights = c(1.3,1,1,1,1))
#plot_annotation(tag_levels = 'A')
full_plot2 

layout3 <- "
ABCD
EEEE
FFFF
GGGG
HHHH
IIII"

full_plot3 <- pi_box + fst_box + bp_2 + bp_2i + pi + dxy + fst + ap_2 + ap_2i +
  plot_layout(design = layout3, widths = c(1.2,1.2,1,1), heights = c(1.4,1,1,1,1,1))
#plot_annotation(tag_levels = 'A')
full_plot3 

ggsave(file = paste0(OUTSTUB, "pi_dxy_fst(50kbp),dfm-((PNG,CY),EC),dfm-((EC,CY),TE)(3Ksnp)_fullplot.svg"),
       plot = full_plot3,
       device = "svg",
       width = 190, height = 220, unit = "mm",
       dpi = "retina")

######
###### Save plots that contains a legends for the chromosome region colors and for the population pair colors:


pi_box_legend  <- df_pi2 %>%
  mutate(Region = factor(Region, levels=c("new PAR", "added-Z NR", "ancestral Z-PAR", "ancestral-Z", "Chr 1A"))) %>%
  ggplot(aes(x = Region, y = avg_pi, fill=Region)) +
  geom_boxplot(notch = T, outlier.shape = NA, show.legend = TRUE) +
  scale_y_continuous(position = "left") +
  scale_x_discrete(labels= c("new\nPAR", "added-\nZ-NR", "anc.\nZ-PAR", "anc.\nZ", "Chr\n1A")) +
  coord_cartesian(ylim = c(0, 0.01)) +  
  scale_fill_manual(values=wes_palette) +
  theme_linedraw(base_size = 10) 

pi_box_legend

fst_line_legend <- df_fst %>%
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
  theme_linedraw(base_size = 10) 

legend_plots <- pi_box_legend / fst_line_legend
legend_plots

ggsave(file = paste0(OUTSTUB, "pi_dxy_fst(50kbp),dfm-((PNG,CY),EC)(3Ksnp)_legend_plots.svg"),
       plot = legend_plots,
       device = "svg",
       width = 255, height = 180, unit = "mm",
       dpi = "retina")


### Pi Chr 1 plot:

pi_pops_box  <- df_pi %>%
  filter(Region == "Chr 1A") %>%
  mutate(pop = factor(pop, levels=c("KP", "TE", "PNG", "CY", "EC"))) %>%
  ggplot(aes(x = pop, y = avg_pi)) +
  geom_boxplot(notch = F, outlier.shape = 1, outlier.size = 0.5, outlier.alpha = 0.5) +
  stat_summary(fun.y = "mean", geom = "point", shape = 23, size = 1.5, fill = "white") +
  coord_cartesian(ylim = c(0, 0.02)) +  
  ylab(expression(italic(pi))) +
  theme_linedraw(base_size = 10) +
  theme(axis.title.x = element_blank(),
        axis.title.y=element_text(angle = 0, vjust = 0.5))

pi_pops_box



ggsave(file = paste0(OUTSTUB,"pi - pops - Chr 1A - pixy.svg"),
       plot = pi_pops_box,
       device = "svg",
       width = 60, height = 50, unit = "mm",
       dpi = "retina")




