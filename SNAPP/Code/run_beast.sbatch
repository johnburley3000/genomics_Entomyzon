#!/bin/bash
#SBATCH -p shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem 10000
#SBATCH -t 6-02:00
#SBATCH -J SNAPP_D
#SBATCH -o ./Logs/SNAPP_D_%j.out
#SBATCH -e ./Logs/SNAPP_D_%j.err

# RUN: sbatch Code/run_beast.sbatch

module load GCC/7.3.0-2.30  OpenMPI/3.1.1 Beast/2.6.0

## paths:
SCRATCH=/n/holyscratch01/edwards_lab/jburley/BFHE2021/SNAPP
LAB=/n/holylfs04/LABS/edwards_lab/Lab/jburley/BFHE_ms2021/SNAPP
cd $SCRATCH

STUB=E_cyan_24_hf_snps_rm_autos_1e5bp_nosexseg_17males_thin  # corresponds to a prepared VCF
ind=17 # indicates number of samples, and corresponds to a samples*.txt

# random seed generator
SEED=123
# number of MCMC iterations
LENGTH=5000000
LEN=5e6
# max number of SNPs to translate to the xml
SITES=3500
#name of the constraits file
CONS=constraints_Ec_1
# generation time in years
GEN=2.0

# prepare the XML file using Mach's ruby script:
ruby ${LAB}/snapp_prep/snapp_prep.rb \
--analysis SNAPP \
--vcf ${LAB}/${STUB}.vcf \
--constraints ${LAB}/${CONS}.txt \
--starting-tree ${LAB}/starting_tree_Ec.nwk \
--min-dist 1000 \
--length $LENGTH \
--max-snps $SITES \
--table ${LAB}/individuals_${ind}.txt \
--xml ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.xml \
--out ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}

# no limit on # SNPs, should use ~4000 in Chr 1A test set

# Run beast:
beast -threads -1 -seed $SEED -overwrite ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.xml

# Now add population size:
ruby ${LAB}/snapp_prep/add_theta_to_log.rb \
-l ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.log \
-t ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.trees \
-g $GEN \
-o ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}_theta.log

# quantify the posterior probabilities of clades as node support in a maximum-clade-credibility tree using TreeAnnotator (Beast)

treeannotator -burnin 10 -heights mean ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.trees ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}_burn10.tre

treeannotator -burnin 35 -heights mean ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.trees ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}_burn35.tre

treeannotator -burnin 50 -heights mean ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.trees ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}_burn50.tre

treeannotator -burnin 75 -heights mean ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}.trees ${STUB}_seed${SEED}_L${LEN}_S${SITES}_${CONS}_burn75.tre

# move the results to local computer to view on Tracer, Densitree, figtree

