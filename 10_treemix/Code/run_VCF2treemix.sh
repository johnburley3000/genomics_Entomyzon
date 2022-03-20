#!/bin/bash
# Aug 02 2017
# j burley
# this can be run on interactive (< 20 mins for 26 sample, 1.5m snp dataset) unless many many jobs, but when would that be?
# longest procedure is running the .py script
# notes:
# get the plink2treemix code from https://bitbucket.org/nygcresearch/treemix/downloads/plink2treemix.py
# make the .clst file one time only - see notes below  (recommend making .clst after you have .fam file, to check sample order)

# resources:
# great examples: http://www.peterbeerli.com/classes/images/5/54/TreemixReport1.pdf
# publication: Pickrell and Pritchard 2014 PLos Genetics
# manual and more: https://bitbucket.org/nygcresearch/treemix/wiki/Home

module load plink/1.90-fasrc01 
module load gcc/7.1.0-fasrc01
export PATH=/n/home01/jtb/apps/treemix-1.13/src/:$PATH

FILE=Ento_Meli_rm_snps_filt1_autos_1e5
ROOT=M_lun # root with pop name, not sample name

# create PLINIK binary files (.nosex .log .fam .bin .bed)
# the options --double-id --allow-extra-chr are needed due to i) having "_" in sample IDs and ii) having assembly in hundreds of scaffolds rather than 10s of chromosomes
# --recode asks it to also make the readable files (.ped and .map) 
# --set-missing-var-ids @:# asks it to call the first variant scaffold0_:<bp_position> and so-on. It is neccesary to have unique Variant IDs for the later steps.

plink --vcf Data/${FILE}.vcf --maf 0.05 --set-missing-var-ids @:# --keep-allele-order --recode --double-id --allow-extra-chr --make-bed --out Data/${FILE}

# Wonder what happens if I change maf - how do people usually decide on this parameter?

# make Code/treemix_pops.clst based on the .fam file (the clst basically contains 2 identical rows of sample names, then a third row of pop group)

plink --bfile Data/${FILE} --allow-extra-chr --freq --missing --within Code/treemix_pops.clst -out Data/${FILE}
gzip Data/${FILE}.frq.strat
Code/plink2treemix.py Data/${FILE}.frq.strat.gz Data/${FILE}_treemix.frq.gz

# ready for Treemix! From here, do it in intereactive (or on local computer) and keep notes
#example:

#build ML tree
treemix -i Data/${FILE}_treemix.frq.gz -o Results/${FILE}_unroot
#root
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -o Results/${FILE}_root
#group SNPS into groups of size n (potential problem with this is that there will be more snps from regions with higher snp density)
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -o Results/${FILE}_k500
#test with samplesize correction:
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -noss -o Results/${FILE}_k500_noss
#add migration:
for i in {1..10}
do
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -m $i -o Results/${FILE}_k500_m${i}
done

# check the trees and residuals in R (see manual and Barrow/Beerli report), then go back to treemix. How do I know the best -m value? do bootstrap reps on each m value?
# try the option -se to calculate standard errors of migration weights (computationally expensive)
# try the “-global” option to do a round of global rearrangements after adding all populations
# 

# now, try treemix using only the Entomyzon, and no root. It seems like the root is unneccesary, because it uses estimates of allele freq in a population relative to the ancestral (?). So perhaps having outgroups with only 1 sample per population is misleading?

# remove the 2 outgroups from the treemix input file:
zcat Data/Ento_Meli_rm_snps_filt1_autos_1e5_treemix.frq.gz | cut -d ' ' -f 3-7 > Data/Ento_rm_snps_filt1_autos_1e5_treemix.frq; gzip Data/Ento_rm_snps_filt1_autos_1e5_treemix.frq

FILE=Ento_rm_snps_filt1_autos_1e5

#build ML tree
treemix -i Data/${FILE}_treemix.frq.gz -o Results/${FILE}_unroot

#group SNPS into groups of size n (potential problem with this is that there will be more snps from regions with higher snp density)
treemix -i Data/${FILE}_treemix.frq.gz -k 500 -o Results/${FILE}_unroot_k500
#test with samplesize correction:
treemix -i Data/${FILE}_treemix.frq.gz -k 500 -noss -o Results/${FILE}_unroot_k500_noss
#add migration:
for i in {1..10}
do
treemix -i Data/${FILE}_treemix.frq.gz -k 500 -m $i -o Results/${FILE}_unroot_k500_m${i}
done

# Aug 4 2017: go with the results from 20170802, using M_lun
# try doing global rearrangements after adding all populations:
for i in {1..10}
do
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -m $i -global -o Results/${FILE}_global_k500_m${i}
done
# tested for i=7 only (
# try estimating se of migration edges:
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -m $i -global -se -o Results/${FILE}_se_global_k500_m${i}

# try bootstrap x3 estimate for i=7:
i=7
for br in 1 2 3
do
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -m $i -boostrap -o Results/${FILE}_k500_m${i}_br${br}
done

# just realised I can set 2 populations as the roots! Re-run for all 10 migs and check it out!
root=M_lun,M_alb
for i in {1..10}
do
treemix -i Data/${FILE}_treemix.frq.gz -root $ROOT -k 500 -m $i -o Results/${FILE}_Melroot_k500_m${i}
done

# for Melroot, the best graph seems to be m=6 (ln(LH) scores converge around this value, and the residuals are minimised for Entomyxon)
# Now I want to do bootstrap reps for Melroot, and calculate edge p-values. -se takes a while, so submit jobs to slurm:
