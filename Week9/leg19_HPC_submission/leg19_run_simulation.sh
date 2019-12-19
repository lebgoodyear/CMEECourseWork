#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run"
R --vanilla < $HOME/Week9HPC/leg19_HPC_2019_cluster.R
mv Results* $HOME
echo "R has finished running"
# end of file