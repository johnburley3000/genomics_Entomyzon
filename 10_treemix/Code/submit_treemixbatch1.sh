#!/bin/bash
for i in {1..9}
do
for s in {1..10}
do
sbatch Code/run_treemixbatch1.sh $i $s
done
done

