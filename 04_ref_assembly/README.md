# RNA-Seq assembly using an annotated reference genome

Author: Cintia Gómez-Muñoz

Created: April 07, 2021

Updated: June 7, 2021

---

## Introduction

Previously, we designed a pipeline to generate a _de novo_ transcripts assembly for gene expression analysis. The above applies when you do not have an annotated reference genome. However, the former *de novo* reads assembly may generate false, incomplete or chimeric transcripts (although it may also help you to discover genes not present in the reference). Another option would be to use and annotated reference. This process usually proceeds in two main steps: 1) alignment of the reads to the genome, and 2) assembly of transcripts and quantification. For that, plenty of software exists, some examples are:

* **Alignment:**
    - TopHat
    - STAR
    - Kallisto
    - Bowtie2
    - HISAT
* **Assembly and quantification:**
    - Cufflinks
    - StringTie
    - featureCounts
    - htseq-count
    - Salmon
    - RSEM

Some tools are frequently used together, for example **STAR** and **featureCounts**, and **TopHat** and **Cufflinks**. As you can intuit, the possible combination of tools is vast, which becomes a problem when [choosing the appropriate pipeline](https://www.researchgate.net/post/Reference_workflow_for_RNAseq_differential_gene_expression_experiment_data_analyses). On top of that, several new tools are generated continuously. Usually, the decision is made by non-scientific reasons. For instances, some might choose a tool because it was taught to them or used in their lab, or based on the tool popularity and not so much in the tool efficiency. For example, the [Tuxedo Suit and Cufflinks pipeline](http://cole-trapnell-lab.github.io/cufflinks/manual/) is a very popular and still used set of tools probably because it was one the firsts ways to analyze RNA-Seq data. Nonetheless, **Cufflinks** is now outdated and even the [creators of such tool recommend to use its replacement](https://www.youtube.com/watch?v=2qGiw4MRK3c), called **StringTie**. Therefore, does the above imply that, in order to perform a good analysis, you should test and compare several pipelines? Ideally yes, but it practice not many people have the time to learn several pipelines and compare them with their results. Additionally, results in the lab have to be obtained fast, otherwise you may not publish. My recommendation is that if you are relatively new to RNA-Seq analysis, you should choose one pipeline, preferentially an easy one to learn, and execute it. Then corroborate if the generated results make biological sense. Afterwards, if you have the time, you can learn different pipelines and compare them, specially if you know for a fact that the obtained results were not as good as expected. More information about [general RNA-Seq analysis and design](http://barc.wi.mit.edu/education/hot_topics/RNAseq_Apr2018/RNASeq_2018.pdf).

## Available pipelines

Having said the above, then what options do we have? Fortunately, many people nowadays publish their pipeline on-line; so one option is to select a core tool and then look for available pipelines on the web. For example, I chose to use **STAR** and **featureCounts** because it is an easy pipeline. I found the following guides:

* [A pipeline in GitHub](https://github.com/eastmallingresearch/RNA-seq_pipeline)
* [A pipeline from a course for analysis in a cluster](https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/schedule/)

The latter pipeline is particularly useful because it also gives instructions to execute the program is a cluster, such as my case. To test the pipelines, we are going to use, as a proof of concept, public gene expression information of _Saccharomyces pastorianus_ and a reference genome strategy.

## Procedure

### Source data

This work is going to be based in the data of Behr et al. (2020)<sup>1</sup>. These authors compared the transcriptional profile of several _S. pastorianus_ strains at 15°C and 20°C. We are going to use the data of only two interest strains, namely **CBS 1503** and **CBS 1513**. All of this information is deposited in the NCBI's BioProject [PRJEB33088](https://www.ncbi.nlm.nih.gov/bioproject/PRJEB33088). The work is going to be performed in the Thubat Kaal cluster.

To get the reads entries (SRA entries), go to the **SRA Run Selector** and download the accession list and metadata of the **CBS 1503** and **CBS 1513** strains.

Code  | Strain
--|---
TMW 3287 | CBS 1503
TMW 3681 | CBS 1513

The files are in the **source_data** directory under the names **SRR_Acc_List.txt** and **SraRunTable.txt**. For some reason, the last character of the downloaded **SRR_Acc_List.txt** is not recognized by the system. Edit it manually to avoid errors. Synchronize this information with the remote server to continue.

```bash
rsync -av --dry-run --rsh=ssh /home/cintia/Documents/IPICYT/Tesis/bioinfo/rna-seq-analysis/04_ref_assembly hpc-cintia-gomez@192.168.91.170:/lustre/scratch/hpc-cintia-gomez/rna-seq-analysis
```

* Do not forget to remove the `--dry-run` for the actual synchronization, or create custom-made scripts for the purpose (see **push_rsync.sh** and **pull_rsync.sh**).

Download the information with the **prefetchSRR.sh** script stored in the **used_scripts** directory like this:

```bash
./used_scripts/prefetchSRR.sh source_data/SRR_Acc_List.txt
```

Also, validate the downloaded files:

```bash
./used_scripts/vdb-validateSRR.sh source_data/SRR_Acc_List.txt
```

And dump the information to **FASTQ** format.

```bash
sbatch rna-seq-analysis/04_ref_assembly/used_scripts/fasterq-dumpSRR_sbatch_2.sh rna-seq-analysis/04_ref_assembly/source_data/SRR_Acc_List.txt rna-seq-analysis/04_ref_assembly/source_data/
```

When downloading the files, entry **ERR3384489** could not be found:

```none
2021-04-22T21:15:22 prefetch.2.10.8 err: name not found while resolving query within virtual file system module - failed to resolve accession 'ERR3384489' - no data ( 404 )
```

I manually checked this [entry in the NCBI](https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=ERR3384489) and I discovered that it was empty. Therefore, I proceeded without this entry, which correspond to the TMW3681_15_R2 (**CBS 1513**).

Sequences were already trimmed and filtered by the authors and reported as so; therefore, there is no need to preform this analysis in the data.

### Mapping with STAR

#### STAR genome indexing

For this process, we are going to test an alignment tool called **Spliced Transcripts Alignment to a Reference**<sup>2</sup> or [STAR](https://github.com/alexdobin/STAR). Once **STAR** is available in your PATH, the first step to run it is to create a genome index. The reference genome files are going to be two assemblies of the studied strains that we generated. This files are called **CBS1503.fasta** and **CBS1513.fasta**, and are stored in the **genomes** directory (see **01_assemblies.md** for more information about the assemblies and annotations). Create an **star_idx** directory for each genome in a separate directory, because according to the [STAR manual](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf) 'it is recommended to remove all files from the genome directory before running the genome generation step'.

 Also, to run this command, you will need the genome annotation file in **GTF** format; nonetheless, **STAR** can also take in **GFF** files as input. If you want convert this file to **GTF**, **MAKER** has a script to convert **GFF** to **GTF**. Go to the directory where the annotations are stored, activate the MAKER environment (`conda activate maker_py`) and do the following:

```bash
maker2eval_gtf CBS1503_nano.all.funct.renamed.gff > CBS1503_nano.all.funct.renamed.gtf
```

This is the basic command for indexing:

```bash
STAR --runThreadN NumberOfThreads # default: 1
--runMode genomeGenerate # default: alignReads
--genomeDir /path/to/genomeDir
--genomeFastaFiles /path/to/genome/fasta1
--sjdbGTFfile /path/to/annotations.gtf
--sjdbOverhang ReadLength-1 # default: 100 --> 99
```

The indexing process is not so heavy, so if you wish you can run it in your local computer, and then synchronize the resulting files. Flag `--runThreadN` depends on the number of available cores in your computer (use `lscpu` to find out). Before running the command, notice that by default **STAR** looks for '**exon**' features on the third column of the **GTF** file, but the **maker2eval_gtf** script outputs only **CDS** features. I manually check the original **GFF** files and noticed that exons are named **CDS** in the resulting **GTF**. Therefore, to override this, we need to set the flag `--sjdbGTFfeatureExon CDS`. Also, `--sjdbOverhang` is the read length, for instance 2 × 100 bp paired-end reads. In Behr et al. (2020)<sup>1</sup>, the length was length of 2 × 150 bp (paired-end reads). I case you want to use the **GFF** annotation file, you need to set the flag `--sjdbGTFtagExonParentTranscript Parent`. Furthermore, for small genomes the parameter `--genomeSAindexNbases` must to be scaled down by `min(14, log2(GenomeLength)/2 - 1)`; if not, you will get an error like this.

```none
!!!!! WARNING: --genomeSAindexNbases 14 is too large for the genome size=19178225, which may cause seg-fault at the mapping step. Re-run genome generation with recommended --genomeSAindexNbases 11
```

To correct it, calculate in **R**:

```r
min(14, log2(19178225) / 2 - 1)
# 11.09648 --> 11
min(14, log2(21279388)/2 - 1)
# 11.17148 --> 11
```

* To run it with **GTF**:

```bash
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir genomes/CBS1503/star_idx --genomeFastaFiles genomes/CBS1503/CBS1503.fasta --sjdbGTFfile genomes/CBS1503/CBS1503_nano.all.funct.renamed.gtf --sjdbOverhang 149 --sjdbGTFfeatureExon CDS --genomeSAindexNbases 11
```

* To run it with **GFF**

```bash
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir genomes/CBS1503/star_idx --genomeFastaFiles genomes/CBS1503/CBS1503.fasta --sjdbGTFfile genomes/CBS1503/CBS1503_nano.all.funct.renamed.gff --sjdbOverhang 149 --sjdbGTFtagExonParentTranscript Parent --genomeSAindexNbases 11
```

Perform the same for the other assembly.

#### STAR reads alignment

In order to perform the alignment, first we need to identify which files belong to each strain and condition. For that you can extract the information from the **SraRunTable.txt** file and the **by_strain.R** script.

```bash
Rscript by_strain.R
```

Now, I am going to test the alignment using the **CBS 1503** reads from 15 and 20°C. In the working directory, I created a new location (`mkdir out_star`). Be aware that one of the **STAR** aligner advantages is that it performs spliced alignments; this is, a read can be split during the alignment to account for splicing. Therefore, prior aligning the reads, we need to [calculate the intron's size of our organism](https://groups.google.com/g/rna-star/c/hQeHTBbkc0c). I chose to use a minimum and maximum intro size of 4 and 7000 bp, respectively. Next, I ran the alignment with the command below.

<!--
This options from the pipeline did not work
--outSAMtype BAM SortedByCoordinate \ # error, do it with sam2igv2.sh
--outSAMunmapped Within \ # what type of unmapped reads to report (default is none)
--outSAMattributes Standard # this is default, so it can be omitted
-->

```bash
STAR --genomeDir genomes/CBS1503/star_idx \
--runThreadN 32 \
--readFilesIn source_data/ERR3384482_1.fastq source_data/ERR3384482_2.fastq \
--alignIntronMin 4 --alignIntronMax 7000 --alignMatesGapMax 7000 \
--outFileNamePrefix out_star/CBS1503_15_1_
```

* Adjust `--runThreadN` according to your hardware.

Just so you know, **STAR** can also align multiple reads files at the same time (not applicable for this case). For that, pair 1 reads of all samples should be provided first, and so on. For example: `sample1_read1.fastq,sample2_read1.fastq sample1_read2.fastq,sample2_read2.fastq`. Notice the **space** between reads 1 and reads 2.

You will also have to run the same command for each library and condition. Use the **StarMap.slurm**, first edit `--readFilesIn` part by copying the reads information form the **SSR_list.txt** file (generated by **by_strain.R**). Sample **ERR3384489** did not have data, so I removed it from the script manually. Execute it like this:

```bash
sbatch rna-seq-analysis/04_ref_assembly/used_scripts/StarMap.slurm
```

The output is going to be a file in **SAM** format per input reads file. **SAM** files are huge and need to be converted to binary for visualization in the **IGV** and downstream analyses. To do that you can use the **sam2igv2.sh** script, which calls in **samtools** as follows

```bash
samtools view -b -S $1 > $(basename $1 .sam).bam
samtools sort $(basename $1 .sam).bam -o $(basename $1 .sam).sorted.bam
samtools index $(basename $1 .sam).sorted.bam
```

**sam2igv2.sh** is in my `program/bin` path. To execute this command over several **SAM** files contained in a single directory, you can use the **sam2igv2_sbatch.sh** script as follows:

```bash
sbatch rna-seq-analysis/04_ref_assembly/used_scripts/sam2igv2_sbatch.sh rna-seq-analysis/04_ref_assembly/out_star/
```

Download the **BAM** in order to visualize them in your computer in the **IGV**.

### Mapping with HISAT2

#### HISAT2 genome indexing

Another tool that I am going to test is **HISAT2**<sup>3</sup>. This tools also requires to create an genome index. For that, create a new directory (`mkdir hisat_idx`) in each  genome directory, and then run:

```bash
hisat2-build -f genomes/CBS1513/CBS1513.fasta genomes/CBS1513/hisat_idx/CBS1513 -q
```

#### HISAT2 reads alignment

For the alignment stage, create a new output directory (`mkdir hisat_out`). Similarly to **STAR**, **HISAT2** also performs spliced alignments. The minimum and maximum intron length can be specified with:

```none
--min-intronlen <int>
#Sets minimum intron length. Default: 20
--max-intronlen <int>
#Sets maximum intron length. Default: 500000
```

In this case, I could not specify a minimum intron size of 4 because the minimum allowed was 20. This is the command to perform the alignment:

```bash
hisat2 -q -p 32 -x genomes/CBS1503/hisat_idx/CBS1503 \
-1 source_data/ERR3384482_1.fastq -2 source_data/ERR3384482_2.fastq \
--min-intronlen 20 --max-intronlen 7000 \
-S out_hisat/CBS1503_15_1_aln.sam --no-unal
```

## Reads counts

This process is going to be performed using **featureCounts**<sup>4</sup>. To run this part, you will need the alignment output files from the previous section and the genome annotation file in **GTF** format. Create a new sub-directory `mkdir counts`. The main **featureCounts** command is like this:

```bash
featureCounts -T 32 -a genomes/CBS1503/CBS1503_nano.all.funct.renamed.gtf \
-o counts/CBS1503_counts.txt -t CDS -p out_star/CBS1503_15_Aligned.out.sorted.bam out_star/CBS1503_20_Aligned.out.sorted.bam
```

  * `-T` is threads. Adjust accordingly.
  * `-a` is the annotation file.
  * `-o` is the output.
  * `-t` is the string of the features to look up in the annotation file.
  * `-p` is to indicate that the input is paired-end.

Other parameters that you can check in the [Subread manual](http://bioinf.wehi.edu.au/subread-package/) are `minOverlap`, and `-s` which is to indicate if the data is stranded or not. In our case is not, which is the default `0`. Also, remember that by default **featureCounts** does not count multimappings.

To run it **featureCounts** in all the files, use the **featureCounts.slurm** script that contains the following:

```bash
ls out_star/CBS1503*sorted.bam | xargs featureCounts -T 32 -a genomes/CBS1503/CBS1503_nano.all.funct.renamed.gtf \
-o counts/CBS1503_counts.txt -t CDS -p
```

The output is going to be a count matrix that we are going to use for the differential expression gene analysis. In order to use this files as input in the next step, we need to clean the file a little bit:

```bash
sed '1d' star_CBS1503_counts.txt | sed 's/out_star\///g' | sed 's/_Aligned.out.sorted.bam//g' | cut -f1,7-12 | sed 's/Geneid\t//' > star_CBS1503_counts_mat.txt
```

## References

1. Behr, J., Kliche, M., Geißler, A., & Vogel, R. F. (2020). Exploring the potential of comparative de novo transcriptomics to classify Saccharomyces brewing yeasts. PLoS ONE, 15(9). https://doi.org/10.1371/journal.pone.0238924
2. Dobin, A., Davis, C. A., Schlesinger, F., Drenkow, J., Zaleski, C., Jha, S., Batut, P., Chaisson, M., & Gingeras, T. R. (2013). STAR: Ultrafast universal RNA-seq aligner. Bioinformatics, 29(1), 15–21. https://doi.org/10.1093/bioinformatics/bts635
3. Kim, D., Paggi, J. M., Park, C., Bennett, C., & Salzberg, S. L. (2019). Graph-Based Genome Alignment and Genotyping with HISAT2 and HISAT-genotype. Nature Biotechnology, 37(8), 907–915. https://doi.org/10.1038/s41587-019-0201-4
4. Liao, Y., Smyth, G. K., & Shi, W. (2014). featureCounts: An efficient general purpose program for assigning sequence reads to genomic features. Bioinformatics (Oxford, England), 30(7), 923–930. https://doi.org/10.1093/bioinformatics/btt656
