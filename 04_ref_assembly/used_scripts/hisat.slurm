#!/bin/bash
#SBATCH -J hisat
#SBATCH -o jobs/hisat.out.%j
#SBATCH -e jobs/hisat.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 10:00:00

# A script to map FASTQ reads using hisat2
# sbatch hisat.slurm

echo -e "START\n"

date

cd /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/04_ref_assembly

echo "CBS 1503"

echo "Condition 15"

echo "Lib 1"

hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384482_1.fastq -2 source_data/ERR3384482_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_15_1_aln.sam --no-unal

echo "Lib 2"

hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384483_1.fastq -2 source_data/ERR3384483_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_15_2_aln.sam --no-unal

echo "Lib 3"

hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384484_1.fastq -2 source_data/ERR3384484_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_15_3_aln.sam --no-unal

echo "Condition 20"

echo "Lib 1"

hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384485_1.fastq -2 source_data/ERR3384485_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_20_1_aln.sam --no-unal

echo "Lib 2"

hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384486_1.fastq -2 source_data/ERR3384486_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_20_2_aln.sam --no-unal


echo "Lib 3"

hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384487_1.fastq -2 source_data/ERR3384487_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_20_3_aln.sam --no-unal

echo ""

echo "CBS 1513"

echo "Condition 15"

echo "Lib 1"

hisat2 -q -p 32 -x genomes/CBS1513/hisat_idx/CBS1513 \
-1 source_data/ERR3384488_1.fastq -2 source_data/ERR3384488_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1513_15_1_aln.sam --no-unal

echo "Lib 3"

hisat2 -q -p 32 -x genomes/CBS1513/hisat_idx/CBS1513 \
-1 source_data/ERR3384490_1.fastq -2 source_data/ERR3384490_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1513_15_3_aln.sam --no-unal

echo "Condition 20"

echo "Lib 1"

hisat2 -q -p 32 -x genomes/CBS1513/hisat_idx/CBS1513 \
-1 source_data/ERR3384491_1.fastq -2 source_data/ERR3384491_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1513_20_1_aln.sam --no-unal

echo "Lib 2"

hisat2 -q -p 32 -x genomes/CBS1513/hisat_idx/CBS1513 \
-1 source_data/ERR3384492_1.fastq -2 source_data/ERR3384492_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1513_20_2_aln.sam --no-unal

echo "Lib 3"

hisat2 -q -p 32 -x genomes/CBS1513/hisat_idx/CBS1513 \
-1 source_data/ERR3384493_1.fastq -2 source_data/ERR3384493_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1513_20_3_aln.sam --no-unal

echo -e "END\n"

date
