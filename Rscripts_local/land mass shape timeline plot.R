# sea level dynamics and the australo-papuan ladmass

# goal: plot a timeline bar showing transitions between key land mass configurations reconstructed based on sea level data:

# Data: https://www.ncei.noaa.gov/pub/data/paleo/reconstructions/deboer2014/deboer2014.txt

library(ggplot2)
library(dplyr)
library(plotly)

OUTSTUB = "/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/Landmass_dynamics/"

data <- read.delim("/Volumes/GoogleDrive/My Drive/Projects/BFHE_ms_2021/ReAnalyses/Landmass_dynamics/deboer2014.txt",
                   sep = "\t", comment.char = "#")

data$Mya = (data$age_calkaBP/1000)*-1

data$Mya_end = (data$age_calkaBP/1000 + 0.0001)*-1

data$Kya = (data$age_calkaBP)*-1

data$Kya_end = (data$age_calkaBP + 0.1)*-1

head(data)

df <- data %>%
  mutate(shape = case_when(
    sealev > -15  ~ "1",
    sealev < -15 & sealev > -55 ~ "2",
    sealev < -55 ~ "3")) %>%
  mutate(epoch = case_when(
    Mya < 0.012 ~ "Holocene",
    Mya > 0.012 & Mya < 2.588 ~ "Pleistocene",
    Mya > 2.588 ~ "Pliocene"
  ))

colours <- c("#FF7F00", "#0000FF", "#00FFFF")

library(ggprism)


timeline_pp <- df %>% 
  ggplot(aes(x = Mya, y=shape,color = shape)) +
  geom_segment(aes(xend = Mya_end, yend = shape, color =  shape), 
               show.legend = F,
               size = 30) +
  #scale_color_brewer(palette = "Accent") +
  scale_color_manual(values=c("#4971B8", "#EC7D30", "#93C954")) +
  #scale_x_continuous(name = "Mya", breaks = seq(0,max(df$Mya), by = 0.5), guide = guide_prism_minor()) +
  scale_x_continuous(name = "Ma", breaks = seq(0,max(df$Mya), by = 0.5),
                     minor_breaks = seq(0,max(df$Mya), by = 0.1), guide = "prism_minor") +
  #scale_x_continuous(limits = c(0, max(df$Mya)), minor_breaks = seq(0,max(df$Mya), by = 0.1), guide = "prism_minor") +
  #coord_flip() +
  #scale_y_reverse() +
  theme_classic() +
  theme(strip.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_text(angle = 0, vjust = 0.5))

timeline_pp

cutoff_ka=200

timeline_young <- df %>% 
  filter(Kya < cutoff_ka) %>%
  ggplot(aes(x = Kya, y=shape,color = shape)) +
  geom_segment(aes(xend = Kya_end, yend = shape, color =  shape), 
               show.legend = F,
               size = 30) +
  #scale_color_brewer(palette = "Accent") +
  scale_color_manual(values=c("#4971B8", "#EC7D30", "#93C954")) +
  #scale_x_continuous(name = "Mya", breaks = seq(0,max(df$Mya), by = 0.5), guide = guide_prism_minor()) +
  scale_x_continuous(name = "Ka", breaks = seq(0,cutoff_ka, by = 50),
                  minor_breaks = seq(0,cutoff_ka, by = 10), guide = "prism_minor") +
  #scale_x_continuous(limits = c(0, max(df$Mya)), minor_breaks = seq(0,max(df$Mya), by = 0.1), guide = "prism_minor") +
  #coord_flip() +
  #scale_y_reverse() +
  theme_classic() +
  theme(strip.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_text(angle = 0, vjust = 0.5))

timeline_young

cutoff_ka_cyan=2500

pleistocene <- df %>% 
  filter(Kya < cutoff_ka_cyan) %>%
  ggplot(aes(x = Mya, y=shape,color = shape)) +
  geom_segment(aes(xend = Mya_end, yend = shape, color =  shape), 
               show.legend = F,
               size = 30) +
  scale_color_manual(values=c("#4971B8", "#EC7D30", "#93C954")) +

  scale_x_reverse(name = "Ma", breaks = seq(0,max(df$Mya), by = 0.5),
                  minor_breaks = seq(0,max(df$Mya), by = 0.1), guide = "prism_minor") +
  theme_classic() +
  theme(strip.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x=element_text(angle = 0, vjust = 0.5))

pleistocene


library(svglite)
ggsave(file=paste0(OUTSTUB,"timeline_Ma.svg"), plot=timeline_pp, width=3.15, height=1)
ggsave(file=paste0(OUTSTUB,"timeline_Ka.svg"), plot=timeline_young, width=1.3, height=1)
ggsave(file=paste0(OUTSTUB,"timeline_pleistocene.svg"), plot=pleistocene, width=3.2, height=1)


timelines <- (timeline_young / timeline_pp) +
  plot_layout(heights = c(1, 2))

timelines

               