#!/bin/bash
#SBATCH -J trimming_h
#SBATCH -o jobs/trimming_h.out.%j
#SBATCH -e jobs/trimming_h.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 24:00:00
#SBATCH --partition=computes_standard
#SBATCH --qos=default


# A script to perform trimming to a set of reads
# Requires a two column file with the paired libraries with their full path, for example:
# path_to/SRR3598367_1_adapt.fastq      path_to/SRR3598367_2_adapt.fastq
# Example: sbatch path_to/trimming_sbatch.sh path_to/libraries.txt
# It will store results in the same directory of the libraries.txt file

echo -e "\nSTART\n"

date

echo "Running Trimmomatic"

LIBRARIES=$1

OUTDIR=$(dirname $LIBRARIES)

while IFS='' read -r line; do
	LIB1=$(echo "$line" | cut -f1)
	LIB2=$(echo "$line" | cut -f2)

	OUTPAIR_1=$OUTDIR/$(basename $LIB1 .fastq)_trim_pair.fastq
	OUTUNPAIR_1=$OUTDIR/$(basename $LIB1 .fastq)_trim_unpair.fastq

	OUTPAIR_2=$OUTDIR/$(basename $LIB2 .fastq)_trim_pair.fastq
	OUTUNPAIR_2=$OUTDIR/$(basename $LIB2 .fastq)_trim_unpair.fastq

	echo "Processing:"
	echo -e "trimmomatic PE -threads 32 -validatePairs $LIB1 $LIB2\n$OUTPAIR_1 $OUTUNPAIR_1\n$OUTPAIR_2 $OUTUNPAIR_2\nLEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:35"

	trimmomatic PE -threads 32 -validatePairs $LIB1 $LIB2 \
	$OUTPAIR_1 $OUTUNPAIR_1 \
	$OUTPAIR_2 $OUTUNPAIR_2 \
	LEADING:3 TRAILING:3 HEADCROP:12 SLIDINGWINDOW:4:15 MINLEN:35
done < $LIBRARIES

echo "Done"

echo -e "\nEND\n"

date
