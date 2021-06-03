# Reads Assembly

Author: Cintia Gómez

Created: July 30, 2020

Updated: June 3, 2021

---

<!-- TOC -->

- [Reads Assembly](#reads-assembly)
  - [Introduction](#introduction)
  - [Transcriptome assembly](#transcriptome-assembly)
    - [Assembling reads with Trinity](#assembling-reads-with-trinity)
  - [References](#references)

<!-- /TOC -->


## Introduction

The purpose of this analysis part is to obtain the 'scaffold' from which we are going to compare the amount of reads that we have of each transcript. For that, you can proceed it two different ways. The first way is when you have no reference genome. In this way, you can use the reads as input to an assembler to generate the potential transcripts of an organism (i.e. a transcriptome). The second option is when you _do have_ a reference genome that already has the coordinates of its transcripts. In this part, we are going to proceed as if we did not have a reference annotated genome.

## Transcriptome assembly

There are several programs to assembly transcripts, but two very good programs are **Trinity**<sup>1</sup> and **SPADES**<sup>2</sup>. We can run assemblies with both tools and later compare to decide which output assembly to select. We are going to start with **Trinity**.

### Assembling reads with Trinity

After you have installed **Trinity**, create the appropriate directories.

```bash
cd path_to/rna-seq-analysis
mkdir 03_reads_assembly
cd 03_reads_assembly/
mkdir trinity_assembly
```

To obtain a better assembly, you can use all the available libraries, not matter if they come from different treatments. I my case, I am working with a data set that contains reads from two different strains. To identify which libraries come from each strain, you can download the **SraRunTable.txt** (Metadata) file from the **Run Selector** of the NCBI. You can see the **by_strain.R** script as an example on how I extracted the strain information. This script generates a `.txt` file that contains the SRR numbers by strain. For example, in file **KJJ81_SRR_list.txt**, I have the following numbers:

```none
SRR3598367
SRR3598368
SRR3598371
SRR3598372
SRR3598373
SRR3598374
```

With this file, I can get the list with the full path of all libraries for one strain, because remember, they are scattered in different runs and, furthermore, they are separated in **paired** and **unpaired**.

I saved the file  **KJJ81_SRR_list.txt** in the `path_to/01_rna_seq_data/source_data`. Go to this direction do the following and to create a list of the requiered files.

```bash
sed ':a;N;$!ba;s/\n/\\|/g' KJJ81_SRR_list.txt | sed 's/^.*/ls -d $PWD\/* | grep "&/' | sed 's/.*/&"/' > get_KJJ81_libraries.sh
```

To get a list of the of all the same strain libraries, move or copy the **get_KJJ81_libraries.sh** to your last output of trimmed reads, in my case `path_to/trim_rnd2` and do the following:

```bash
bash get_KJJ81_libraries.sh > KJJ81_libraries.txt
```

Now we need to separate the reads by left (1 prefix), right (2 prefix), and unpaired. For that, you can use the following command.

```bash
paste <(grep "_pair" KJJ81_libraries.txt | grep "_1_" | sed ':a;N;$!ba;s/\n/,/g') <(grep "_pair" KJJ81_libraries.txt | grep "_2_" | sed ':a;N;$!ba;s/\n/,/g') <(grep "_unpair" KJJ81_libraries.txt | sed ':a;N;$!ba;s/\n/,/g') > KJJ81_libraries.tab
```

The result (**KJJ81_libraries.tab**) is an almost unreadable file, but do not worry, we are only going to use it as input ahead. Just know that it contains all the left, right, and unpaired reads in column one, two, and three, respectively, separated by a comma. Do the same for the other strain (if applies).

Now, we are going to proceed to the assembly. Since we have two strains, we are going to do two assemblies. Create the appropiate directories.

```bash
cd path_to/trinity_assembly
mkdir trinity_KJJ81
```

Afterwards, we are going to create a new script that contains the following main instruction.

```bash
Trinity --seqType fq --left reads1_PE.fq.gz --right reads2_PE.fq.gz --CPU 8 --max_memory 20G --jaccard_clip --output OUTPUT_DIR
```

`--SS_lib_type` is to be used when the library, is strand specific; but I did not find any indication of it in the data origin article, so I am going to skip it.

The script is called **run_trinity.sh**, copy it and move it to the **trinity_assembly** directory. The script will read the file names from our `.tab` file. We are not going to use the single reads, because typically, they are [negligible in relative quantities](https://github.com/trinityrnaseq/trinityrnaseq/issues/654). You only need to provide as first and second positional arguments the input reads tab file and the output directory, respectively.

Use `screen` to run it like this:

```bash
screen -SL trinity_job bash path_to/trinity_assembly/run_trinity.sh \
path_to/trimming/trim_rnd2/KJJ81_libraries.tab \
path_to/trinity_assembly/trinity_KJJ81
```

If you are running it in a system with **Slumr** use the **run_trinity_sbatch.sh**:

```bash
sbatch path_to/trinity_assembly/run_trinity_sbatch.sh \
path_to/trimming/trim_rnd2/KJJ81_libraries.tab \
path_to/trinity_assembly/trinity_KJJ81
```

The **run_trinity_sbatch.sh** contains the `--bflyCalculateCPU` argument that calculates the number of maximum processes that it can run with an 80% of the available assigned memory.

After the process is done, you can run it with the other strain (KPH12).
<!--
### Assembling reads with SPADES

Now we are going to proceed with


```bash
mkdir spades_assembly
cd spades_assembly
```

The main command is the following:

```bash
rnaspades.py -t 8 --pe1-1 reads1_PE.fq.gz --pe1-2
reads2_PE.fq.gz --pe1-s reads1_SE.fq.gz --pe1-s
reads2_SE.fq.gz -o rnaspades_output
```

Create output directories

```bash
mkdir spades_KJJ81
mkdir spades_KPH12
```



## Pending

https://kcvi.shinyapps.io/START/

https://gist.github.com/jdblischak/11384914

https://bioinformatics-core-shared-training.github.io/cruk-bioinf-sschool/Day3/rnaSeq_DE.pdf -->

## References

1. Grabherr, M. G., Haas, B. J., Yassour, M., Levin, J. Z., Thompson, D. A., Amit, I., Adiconis, X., Fan, L., Raychowdhury, R., Zeng, Q., Chen, Z., Mauceli, E., Hacohen, N., Gnirke, A., Rhind, N., di Palma, F., Birren, B. W., Nusbaum, C., Lindblad-Toh, K., … Regev, A. (2011). Trinity: Reconstructing a full-length transcriptome without a genome from RNA-Seq data. Nature Biotechnology, 29(7), 644–652. https://doi.org/10.1038/nbt.1883
