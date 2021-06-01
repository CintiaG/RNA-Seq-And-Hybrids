#!/bin/bash
#SBATCH -J fastqc
#SBATCH -o jobs/fastqc.out.%j
#SBATCH -e jobs/fastqc.err.%j
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

fastqc -o /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/02_reads_qual/qual_rnd1 -t 32 --noextract /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/01_rna_seq_data/source_data/*.fastq

echo -e "END\n"

date
