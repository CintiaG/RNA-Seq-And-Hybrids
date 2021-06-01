#!/bin/bash
#SBATCH -J fasterq-dump
#SBATCH -o jobs/fasterq-dump.out.%j
#SBATCH -e jobs/fasterq-dump.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 48:00:00
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-user=cintia.gomez@ipicyt.edu.mx

# A script to extract a series of SRR numbers and save them into a source_data file

echo -e "START\n"

date

while IFS='' read -r SRR; do
       echo "$SRR"
       SRAPATH=$(srapath $SRR)
       /lustre/scratch/hpc-cintia-gomez/programs/sratoolkit.2.9.4-ubuntu64/bin/fasterq-dump "$SRR" -O /lustre/scratch/hpc-cintia-gomez/source_data
done < /lustre/scratch/hpc-cintia-gomez/source_data/SRR_Acc_List.txt

echo -e "END\n"

date
