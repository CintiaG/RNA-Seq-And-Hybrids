#!/bin/bash
#SBATCH -J fasterq-dump
#SBATCH -o jobs/fasterq-dump.out.%j
#SBATCH -e jobs/fasterq-dump.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 48:00:00

# A script to extract a series of SRR numbers and save them into a source_data file
# sbatch fasterq-dumpSRR_sbatch_2.sh path_to/SRR_Acc_List.txt path_to/source_data

echo -e "START\n"

date

while IFS='' read -r SRR; do
       echo "$SRR"
       SRAPATH=$(srapath $SRR)
       /lustre/scratch/hpc-cintia-gomez/programs/sratoolkit.2.9.4-ubuntu64/bin/fasterq-dump "$SRR" -O $2
done < $1

echo -e "END\n"

date
