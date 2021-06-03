#!/bin/bash

# A script to run a trinity assembly from a tab file
# Example: bash path_to/run_trinity.sh reads.tab path_to/trinity_assembly_1

echo "#### START ####"
date
echo "###############"

INPUT=$1
OUTPUT=$2

while IFS='' read -r line; do
	LEFT=$(echo "$line" | cut -f1)
	RIGHT=$(echo "$line" | cut -f2)
	SINGLE=$(echo "$line" | cut -f3)
done < $INPUT

echo "Trinity --seqType fq --left $LEFT --right $RIGHT \
--max_memory 20G --CPU 8 \
--verbose --jaccard_clip --output $OUTPUT"

Trinity --seqType fq --left $LEFT --right $RIGHT \
--max_memory 20G --CPU 8 \
--verbose --jaccard_clip --output $OUTPUT

echo "#### END #####"
date
echo "##############"
