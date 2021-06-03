#!/bin/bash
#SBATCH -J trinity
#SBATCH -o jobs/trinity.out.%j
#SBATCH -e jobs/trinity.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 48:00:00
#SBATCH --partition=computes_standard
#SBATCH --qos=default


echo "#### START ####"
date
echo "###############"

# Example: sbatch path_to/run_trinity.sh reads.tab path_to/trinity_assembly_1

INPUT=$1
OUTPUT=$2

while IFS='' read -r line; do
	LEFT=$(echo "$line" | cut -f1)
	RIGHT=$(echo "$line" | cut -f2)
	SINGLE=$(echo "$line" | cut -f3)
done < $INPUT

echo "Trinity --seqType fq --left $LEFT --right $RIGHT \
--max_memory 180G --bflyCalculateCPU --CPU 32 \
--verbose --jaccard_clip --output $OUTPUT"

Trinity --seqType fq --left $LEFT --right $RIGHT \
--max_memory 180G --bflyCalculateCPU --CPU 32 \
--verbose --jaccard_clip --output $OUTPUT

echo "#### END #####"
date
echo "##############"
