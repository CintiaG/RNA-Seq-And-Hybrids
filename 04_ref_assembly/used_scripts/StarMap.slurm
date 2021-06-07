#!/bin/bash
#SBATCH -J star-map
#SBATCH -o jobs/star-map.out.%j
#SBATCH -e jobs/star-map.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 10:00:00

# A script to map FASTQ reads using STAR
# sbatch StarMap.slurm

echo -e "START\n"

date

cd /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/04_ref_assembly

echo "CBS 1503"

echo "Condition 15"

echo "Lib 1"

STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384482_1.fastq source_data/ERR3384482_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_15_1_

echo "Lib 2"

STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384483_1.fastq source_data/ERR3384483_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_15_2_

echo "Lib 3"

STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384484_1.fastq source_data/ERR3384484_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_15_3_

echo "Condition 20"

echo "Lib 1"

STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384485_1.fastq source_data/ERR3384485_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_20_1_

echo "Lib 2"

STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384486_1.fastq source_data/ERR3384486_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_20_2_


echo "Lib 3"

STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384487_1.fastq source_data/ERR3384487_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_20_3_

echo ""

echo "CBS 1513"

echo "Condition 15"

echo "Lib 1"

STAR --genomeDir genomes/CBS1513/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384488_1.fastq source_data/ERR3384488_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1513_15_1_

echo "Lib 3"

STAR --genomeDir genomes/CBS1513/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384490_1.fastq source_data/ERR3384490_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1513_15_3_

echo "Condition 20"

echo "Lib 1"

STAR --genomeDir genomes/CBS1513/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384491_1.fastq source_data/ERR3384491_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1513_20_1_

echo "Lib 2"

STAR --genomeDir genomes/CBS1513/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384492_1.fastq source_data/ERR3384492_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1513_20_2_

echo "Lib 3"

STAR --genomeDir genomes/CBS1513/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384493_1.fastq source_data/ERR3384493_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1513_20_3_

echo -e "END\n"

date
