#!/bin/bash
#SBATCH -J samFiltTest
#SBATCH -o jobs/samFiltTest.out.%j
#SBATCH -e jobs/samFiltTest.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 24:00:00

# A script to filter a SAM file and convert it to BAM
# sbatch samFilt.slurm input_dir

echo -e "START\n"

date

INPUT=$1

cd $INPUT

samtools view -b -S -F 2308 CBS1513_15_1_Aligned.out.sam > CBS1513_15_1_Aligned.out.filt.bam

samtools sort CBS1513_15_1_Aligned.out.filt.bam -o CBS1513_15_1_Aligned.out.filt.sorted.bam

samtools index CBS1513_15_1_Aligned.out.filt.sorted.bam

echo -e "\nEND\n"

date
