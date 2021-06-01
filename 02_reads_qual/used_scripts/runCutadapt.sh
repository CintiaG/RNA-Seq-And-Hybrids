#!/bin/bash

# A script to perform paired-end adapter removal from paired-end libraries
# Requires a two column file with the paired libraries with their full path, for example:
# path_to/SRR3598367_1.fastq      path_to/SRR3598367_2.fastq
# and a FASTA file with the adapters
# First adapter sequence is for the library in the first column,
# whereas the second adpater sequence is for the second
# Example: ./runCutadapt.sh libraries.txt TruSeq_adapters.fasta
# It will store results in the same directory of the libraries.txt file
# Check your number specific number of cores (-j)

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

	echo -e "\nCutadapt ran with the following parameters:"
	echo -e "\n$LIB1 and $LIB2 pair:"
	cutadapt -a $ADAPT1 -A $ADAPT2 -o $OUT1 -p $OUT2 $LIB1 $LIB2 -j 4
done < $LIBRARIES

echo "Done"
