#!/bin/bash

for i in Chr1A addZPAR addZNR ancZ
do
sbatch Code/run_fbranch_regions.sbatch $i
done
