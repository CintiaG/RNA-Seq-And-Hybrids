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

INPUT=$1

OUTPUT=$2

echo "Script ran with the following parameters:"

echo "fastqc -o "$OUTPUT" -t 32 --noextract "$INPUT"/*.fastq"

fastqc -o "$OUTPUT" -t 32 --noextract "$INPUT"/*.fastq

echo -e "END\n"

date
