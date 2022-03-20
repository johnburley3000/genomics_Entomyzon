#!/bin/bash
for i in KP TE PNG CY EC
do
sbatch Code/run_theta.sbatch $i autos_2_1e5bp_nosexsegs
done
