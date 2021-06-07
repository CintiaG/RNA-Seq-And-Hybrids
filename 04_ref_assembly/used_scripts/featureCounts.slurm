#!/bin/bash
#SBATCH -J FeatCo
#SBATCH -o jobs/FeatCo.out.%j
#SBATCH -e jobs/FeatCo.err.%j
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH -t 08:00:00

# A script to count mapped reads using featureCounts
# sbatch featureCounts.slurm

echo -e "START\n"

date

cd /lustre/scratch/hpc-cintia-gomez/rna-seq-analysis/04_ref_assembly

echo "STAR CBS 1503"

ls out_star/CBS1503*sorted.bam | xargs featureCounts -T 32 -a genomes/CBS1503/CBS1503_nano.all.funct.renamed.gtf \
-o counts/star_CBS1503_counts.txt -t CDS -p

echo "STAR CBS 1513"

ls out_star/CBS1513*sorted.bam | xargs featureCounts -T 32 -a genomes/CBS1513/CBS1513_nano.all.funct.renamed.gtf \
-o counts/star_CBS1513_counts.txt -t CDS -p

echo "HISAT CBS 1503"

ls out_hisat/CBS1503*sorted.bam | xargs featureCounts -T 32 -a genomes/CBS1503/CBS1503_nano.all.funct.renamed.gtf \
-o counts/hisat_CBS1503_counts.txt -t CDS -p

echo "HISAT CBS 1513"

ls out_hisat/CBS1513*sorted.bam | xargs featureCounts -T 32 -a genomes/CBS1513/CBS1513_nano.all.funct.renamed.gtf \
-o counts/hisat_CBS1513_counts.txt -t CDS -p

echo -e "END\n"

date
