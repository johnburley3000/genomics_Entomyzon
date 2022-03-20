Nov 19: Restarting on BFHE project

First, restore the important MAKER output,
Then, use Pengchengs method to create bed files that can be used to filter SNPs based on sequence type:
As follows:

LAB=/n/edwards_lab/jburley/Proj_BFHE_20170526_lab
REG=/n/regal/edwards_lab/jburley/Proj_BFHE_20170526_regal
cp -rp $LAB/20_MAKER/BFHE336010v2.maker.output/BFHE336010v2.all* $REG/20_MAKER/BFHE336010v2.maker.output/

#####
##### Pengcheng: 
To extract intronic regions, I first calculate the length of each scaffold, named genlength, the format is scaffold name, tab, length, eg. (scaffold_0      14280873). After that,  I make the bed file of scaffold, gen, and exon,  the scripts as follows:
cat ./genlength | sort | uniq | awk 'OFS="\t" {print $1, $2}' | sort -k1,1 | sed 's/>//g' > chromSizes.bed
cat  ./Eared.gff | awk 'OFS="\t" {if ($3 == "gene") print $1, $4-1, $5}' | sort -k1,1 -k2,2n >gene.bed
cat ./Eared.gff | awk 'OFS="\t" {if ($3 == "exon") print $1, $4-1, $5}' | sort -k1,1 -k2,2n > exon.bed
After this, I use bedtools to extract intergenic, intronic region.
     module load bedtools2/2.26.0-fasrc01
     bedtools complement -i gene.bed -g chromSizes.bed > intergenic.bed
    	bedtools complement -i <(cat exon.bed intergenic.bed | sort -k1,1 -k2,2n) -g chromSizes.bed > intron.bed

     awk -v OFS="\t" '{print $1, $2+1, $3}' intergenic.bed >t  
     mv t intergenic.bed

That is all the script that how I get the intronic and gene region. Enjoy it.
And by the way, just for a reminder, we had better update the MAKER generated GFF3 file with the InterProScan results and then filter it. The scripts are in the 25th page of the attachment. 
#####
####

Nov 20:
make a set of bed files based on the annotation results:
mkdir Bed-file-results

cp -rp $LABPATH/A_ref_genome/Data/* Data/

# make a genlength file (scaffold<tab>contig_length) from the fasta.fai file:
cut -f1,2 Data/BFHE336010v2.fasta.fai > Beds/BFHE336010v2.fasta.scaf_lengths

cat Beds/BFHE336010v2.fasta.scaf_lengths | sort | uniq | awk 'OFS="\t" {print $1, $2}' | sort -k1,1 | sed 's/>//g' > Beds/BFHE336010v2.contigSizes.bed
cat BFHE336010v2.maker.output/BFHE336010v2.all.gff | awk 'OFS="\t" {if ($3 == "gene") print $1, $4-1, $5}' | sort -k1,1 -k2,2n > Beds/BFHE336010v2.gene.bed
cat BFHE336010v2.maker.output/BFHE336010v2.all.gff | awk 'OFS="\t" {if ($3 == "exon") print $1, $4-1, $5}' | sort -k1,1 -k2,2n > Beds/BFHE336010v2.exon.bed
cat BFHE336010v2.maker.output/BFHE336010v2.all.gff | awk 'OFS="\t" {if ($3 == "CDS") print $1, $4-1, $5}' | sort -k1,1 -k2,2n > Beds/BFHE336010v2.CDS.bed

#After this, I use bedtools to extract intergenic, intronic regions
module load bedtools2/2.26.0-fasrc01
bedtools complement -i Beds/BFHE336010v2.gene.bed -g Beds/BFHE336010v2.contigSizes.bed > Beds/BFHE336010v2.intergenic.bed
bedtools complement -i <(cat Beds/BFHE336010v2.exon.bed Beds/BFHE336010v2.intergenic.bed | sort -k1,1 -k2,2n) -g Beds/BFHE336010v2.contigSizes.bed > Beds/BFHE336010v2.intron.bed

# add 1bp to the start of each intergenic region - jb not sure why:
awk -v OFS="\t" '{print $1, $2+1, $3}' Beds/BFHE336010v2.intergenic.bed >t  
mv t Beds/BFHE336010v2.intergenic.bed
     
# checked pengchengs script against this: http://crazyhottommy.blogspot.com/2013/05/find-exons-introns-and-intergenic.html 

# make some more bed files using the repeatmasker output:

cat BFHE336010v2.maker.output/BFHE336010v2.all.gff | grep "repeatmasker" | awk 'OFS="\t" {if ($3 == "match") print $1, $4-1, $5}' | sort -k1,1 -k2,2n > Beds/BFHE336010v2.rm-match.bed
cat BFHE336010v2.maker.output/BFHE336010v2.all.gff | grep "repeatmasker" | awk 'OFS="\t" {if ($3 == "match_part") print $1, $4-1, $5}' | sort -k1,1 -k2,2n > Beds/BFHE336010v2.rm-match_part.bed
# match and match_part have same number of entries. the coordinates seem to always overlap.

# backup:

cp -r Beds $LABPATH/20_MAKER/
# now save this text doc in $LABPATH:
cat > $LABPATH/20_MAKER/Code/make-beds-for-seq-type.md

