#!/bin/bash
#SBATCH -J cutadapt
#SBATCH -o jobs/cutadapt.out.%j
#SBATCH -e jobs/cutadapt.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 24:00:00
#SBATCH --partition=computes_standard
#SBATCH --qos=default

# A script to perform paired-end adapter removal from paired-end libraries
# Requires a two column file with the paired libraries with their full path, for example:
# path_to/SRR3598367_1.fastq      path_to/SRR3598367_2.fastq
# and a FASTA file with the adapters
# First adapter sequence is for the library in the first column,
# whereas the second adpater sequence is for the second
# Example: ./runCutadapt.sh libraries.txt TruSeq_adapters.fasta
# It will store results in the same directory of the libraries.txt file

echo -e "\nSTART\n"

date

echo "Running Cutadapt"

LIBRARIES=$1
ADAPTERS=$2

while IFS='' read -r line; do
	LIB1=$(echo "$line" | cut -f1)
	LIB2=$(echo "$line" | cut -f2)

	ADAPT1=$(sed '/>/d' $ADAPTERS | head -1)
	ADAPT2=$(sed '/>/d' $ADAPTERS | tail -1)

	OUT1=$(dirname $LIBRARIES)/$(basename $LIB1 .fastq)_adapt.fastq
	OUT2=$(dirname $LIBRARIES)/$(basename $LIB2 .fastq)_adapt.fastq

	echo -e "\n$LIB1 and $LIB2 pair:"
	cutadapt -a $ADAPT1 -A $ADAPT2 -o $OUT1 -p $OUT2 $LIB1 $LIB2 -j 32
done < $LIBRARIES

echo "Done"

echo -e "\nEND\n"

date
