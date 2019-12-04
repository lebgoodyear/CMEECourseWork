#!/bin/bash
#PBS -1 walltime=12:00:00
#PBS -1 select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "copying"
cp $HOME/Week9HPC/leg19_HPC_2019_main.R $TMPDIR
cat $HOME/Week9HPC/leg19_HPC_2019_main.R
echo "testing the copy"
pwd
cat leg19_HPC_2019_main.R
echo "R is about to run"
R --vanilla < $HOME/Week9HPC/leg19_HPC_2019_cluster.R
mv Results* $HOME
echo "R has finished running"
# end of file