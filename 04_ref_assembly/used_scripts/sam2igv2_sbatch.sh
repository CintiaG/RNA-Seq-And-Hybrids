#!/bin/bash
#SBATCH -J sam2igv
#SBATCH -o jobs/sam2igv.out.%j
#SBATCH -e jobs/sam2igv.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 24:00:00

# A script to convert several SAM files to BAM
# sbatch sam2igv2_sbatch.sh input_dir

echo -e "START\n"

date

INPUT=$1

cd $INPUT

for SAMFILE in $(ls *.sam); do
       echo "$SAMFILE"

	sam2igv2.sh $SAMFILE
done

echo -e "\nEND\n"

date
