library(dplyr)

BFWA <- read.delim("summaryBFHE_WA336010_inlistpsmcfeb7_small.table", "\t", header=TRUE)
WTHE <- read.delim("summaryWTHE_NSW76665_inlistpsmcfeb7_small.table", "\t", header=TRUE)
BFNT <- read.delim("summaryBFHE_NT336114_inlistpsmcfeb7_small.table", "\t", header=TRUE)
BFNSW <- read.delim("summaryBFHE_NSW76677_inlistpsmcfeb7_small.table", "\t", header=TRUE)

#WTFE:
par(mfrow=c(2,1))

WTHEf <- filter(WTHE, DP <= 80)
hist(WTHEf$DP, breaks = 100, xlab=NULL, main="WTHE", ylab = "frequency")

d <- 16
D <- 30

abline(v=c(d,D), col="red", lty=2)

het_homWTHEf <- cbind(count(WTHEf, AF!="1.00", DP),count(WTHEf, AF=="1.00", DP))
het_homWTHEf$hettototal <- het_homWTHEf[[3]]/(het_homWTHEf[[3]]+het_homWTHEf[[6]])
names(het_homWTHEf)[1]<-paste("name1")
names(het_homWTHEf)[2]<-paste("dp1")
names(het_homWTHEf)[3]<-paste("n_het_true")
names(het_homWTHEf)[4]<-paste("name2")
names(het_homWTHEf)[5]<-paste("dp2")
names(het_homWTHEf)[6]<-paste("n_hom_true")
names(het_homWTHEf)[7]<-paste("prop_het")
WTHEf2 <- as.data.frame(het_homWTHEf)
WTHEf2 <- filter(WTHEf2, WTHEf2$name2 == "TRUE")
plot(WTHEf2$dp1, WTHEf2$prop_het, xlab = "per-base sequencing depth", ylab = "proportion heterozygotes")

abline(v=c(d,D), col="red", lty=2)
dev.copy2pdf(width = 4, height = 7, out.type = "pdf", file=paste("figs/D_filter_WTHE_d",d,"D",D,".pdf",sep=""))

###############   BF_NT

par(mfrow=c(2,1))

BFNTf <- filter(BFNT, DP <= 80)
hist(BFNTf$DP, breaks = 100, xlab=NULL, main="BFNT", ylab = "frequency")

d <- 18
D <- 30

abline(v=c(d,D), col="red", lty=2)

het_homBFNTf <- cbind(count(BFNTf, AF!="1.00", DP),count(BFNTf, AF=="1.00", DP))
het_homBFNTf$hettototal <- het_homBFNTf[[3]]/(het_homBFNTf[[3]]+het_homBFNTf[[6]])
names(het_homBFNTf)[1]<-paste("name1")
names(het_homBFNTf)[2]<-paste("dp1")
names(het_homBFNTf)[3]<-paste("n_het_true")
names(het_homBFNTf)[4]<-paste("name2")
names(het_homBFNTf)[5]<-paste("dp2")
names(het_homBFNTf)[6]<-paste("n_hom_true")
names(het_homBFNTf)[7]<-paste("prop_het")
BFNTf2 <- as.data.frame(het_homBFNTf)
BFNTf2 <- filter(BFNTf2, BFNTf2$name2 == "TRUE")

plot(BFNTf2$dp1, BFNTf2$prop_het, xlab = "per-base sequencing depth", ylab = "proportion heterozygotes")

abline(v=c(d,D), col="red", lty=2)
dev.copy2pdf(width = 4, height = 7, out.type = "pdf", file=paste("figs/D_filter_BFNT_d",d,"D",D,".pdf",sep=""))

##BF_NSW

par(mfrow=c(2,1))

BFNSWf <- filter(BFNSW, DP <= 80)
hist(BFNSWf$DP, breaks = 100, xlab=NULL, main="BFNSW", ylab = "frequency")

d <- 12
D <- 28

abline(v=c(d,D), col="red", lty=2)

het_homBFNSWf <- cbind(count(BFNSWf, AF!="1.00", DP),count(BFNSWf, AF=="1.00", DP))
het_homBFNSWf$hettototal <- het_homBFNSWf[[3]]/(het_homBFNSWf[[3]]+het_homBFNSWf[[6]])
names(het_homBFNSWf)[1]<-paste("name1")
names(het_homBFNSWf)[2]<-paste("dp1")
names(het_homBFNSWf)[3]<-paste("n_het_true")
names(het_homBFNSWf)[4]<-paste("name2")
names(het_homBFNSWf)[5]<-paste("dp2")
names(het_homBFNSWf)[6]<-paste("n_hom_true")
names(het_homBFNSWf)[7]<-paste("prop_het")
BFNSWf2 <- as.data.frame(het_homBFNSWf)
BFNSWf2 <- filter(BFNSWf2, BFNSWf2$name2 == "TRUE")

plot(BFNSWf2$dp1, BFNSWf2$prop_het, xlab = "per-base sequencing depth", ylab = "proportion heterozygotes")

abline(v=c(d,D), col="red", lty=2)
dev.copy2pdf(width = 4, height = 7, out.type = "pdf", file=paste("figs/D_filter_BFNSW_d",d,"D",D,".pdf",sep=""))

################################## BF_WA

par(mfrow=c(2,1))

BFWAf <- filter(BFWA, DP <= 80)
hist(BFWAf$DP, breaks = 100, xlab=NULL, main="BFWA", ylab = "frequency")

d <- 30
D <- 40

abline(v=c(d,D), col="red", lty=2)

het_homBFWAf <- cbind(count(BFWAf, AF!="1.00", DP),count(BFWAf, AF=="1.00", DP))
het_homBFWAf$hettototal <- het_homBFWAf[[3]]/(het_homBFWAf[[3]]+het_homBFWAf[[6]])
names(het_homBFWAf)[1]<-paste("name1")
names(het_homBFWAf)[2]<-paste("dp1")
names(het_homBFWAf)[3]<-paste("n_het_true")
names(het_homBFWAf)[4]<-paste("name2")
names(het_homBFWAf)[5]<-paste("dp2")
names(het_homBFWAf)[6]<-paste("n_hom_true")
names(het_homBFWAf)[7]<-paste("prop_het")
BFWAf2 <- as.data.frame(het_homBFWAf)
BFWAf2 <- filter(BFWAf2, BFWAf2$name2 == "TRUE")

plot(BFWAf2$dp1, BFWAf2$prop_het, xlab = "per-base sequencing depth", ylab = "proportion heterozygotes")

abline(v=c(d,D), col="red", lty=2)
dev.copy2pdf(width = 4, height = 7, out.type = "pdf", file=paste("figs/D_filter_BFWA_d",d,"D",D,".pdf",sep=""))

####


# Filter to remove when AF = 0.500,0500
#Filter out DP > 80
count(BF_WA, DP > 80)
BF_WA_f <- filter(BF_WA, DP <= 80)
hist(BF_WA_f$DP, breaks = 100) 

total <- count(BF_WA_f, DP)
het <- as.data.frame(count(BF_WA_f, DP, AF!=1.00), colnames= c(x1,x2,x3))
hom <- count(BF_WA_f, DP, AF==1.00)
het <- count(BF_WA_f, DP, AF=="0.500")

het <- cbind(count(BF_WA_f, AF!="1.00", DP),count(BF_WA_f, AF=="1.00", DP))
het <- filter(het, )
hom <- count(BF_WA_f, AF=="1.00", DP)

het_hom <- cbind(count(BF_WA_f, AF!="1.00", DP),count(BF_WA_f, AF=="1.00", DP))

het_hom$hettototal <- het_hom[[3]]/(het_hom[[3]]+het_hom[[6]])
#Almost there!!

het <- cbind(count(BF_WA_f, AF!="1.00", DP))
het <- filter(het, het[[1]]!="FALSE")
het <- filter(het, het[[1]] < 10)

names(het_hom)[1]<-paste("name1")
names(het_hom)[2]<-paste("dp1")
names(het_hom)[3]<-paste("n_het_true")
names(het_hom)[4]<-paste("name2")
names(het_hom)[5]<-paste("dp2")
names(het_hom)[6]<-paste("n_hom_true")
names(het_hom)[7]<-paste("prop_het")


new <- filter(het_hom, name1 == "TRUE")


rename(het_hom, n = test)

count

proportions <- bind_cols(total,het)


BF_WA_f$hom <- if()


View(iris)
iris %>%
  group_by(Species) %>%
  summarise(avg = mean(Sepal.Width))

BF_WA %>%
  group_by(DP) %>%
  summarise(no_het = count(BF_WA_f, DP, AF==1))

count(filter(BF_WA_f, AF==0.5), DP)

summary(BF_WA)
