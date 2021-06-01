#!/bin/bash
#SBATCH -J multiqc
#SBATCH -o jobs/multiqc.out.%j
#SBATCH -e jobs/multiqc.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 2:30:00
#SBATCH --partition=computes_standard
#SBATCH --qos=default

# A script to perform reads quality analysis with FastQC

echo -e "START\n"
date
echo -e "\n"

multiqc /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/02_reads_qual/qual_rnd1 -o /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/02_reads_qual/qual_rnd1

echo -e "\nEND\n"

date
