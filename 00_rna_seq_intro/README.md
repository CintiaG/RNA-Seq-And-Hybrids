# RNA-Seq Introduction and Setup

Author: Cintia Gómez-Muñoz

Created: July 2, 2020

Updated: June 1, 2021

---

## Introduction

RNA-Seq is a powerful technique to simultaneously sequence the complete set of expressed transcripts in a biological sample. However, the amount of data that it produces is incredibly large, which requires the use of computing power, and its analysis is equally large and complex. There are several options, steps, and tools, that in combination are called **pipelines**. But generally the following structure can be followed (inspired by [uhkniazi](https://github.com/uhkniazi/BRC_FOG1KO_John_PID_20)):

1. Data quality assessment (FASTQC, Fastp, MultiQC, etc.)
2. Data trimming and filtering (Trimmomatic, Cutadapt, etc.)
3. Comparison with reference
   * Alignment to pre-stablished reference (HISAT, Bowtie2, STAR, etc.)
   * _De novo_ assembly (Trinity, SPADES, etc.)
4. File conversions and quality checks (SAMTOOLS, etc.)
5. Count transcripts (RSEM, featureCounts, etc.)
6. Differential expression gene (DEG) analysis (DESeq, EdgeR, etc.) and exploratory analysis (PCAs, MA plots, boxplots, etc.)
7. Comparison of DEGs with Venn diagrams (VennDiagram, venny, etc.)
8. Gene Ontology enrichment analysis.

## Recommendations

The objective of this document is to guide you through a conventional **RNA-Seq** analysis pipeline. I will try to be as explicit as I can; however, many things will not be included, for example, the description of what exactly the tools are doing, among others, although I will try to provide links or references of them, and any other extra material. Furthermore, remember to work clean. Create directories with numerical prefixes in the order you are doing the analyses. To keep every new analysis directory clean, I keep my information separated by creating sub-directories for the source data and the used scripts, among others (for example, **source_data** and **used_scripts**).

One way for running lengthy processes is to use `screen`. This program is likely to be already installed in your computer. To use it you can do the following.

```bash
screen -SL process_name commands ...
```

For example:

```bash
screen -SL my_fastqc fastqc -o path_to/rna-seq-analysis/02_reads_qual/qual_rnd1 -t 8 --noextract path_to/rna-seq-analysis/01_rna_seq_data/source_data/*.fastq
```

This will send your **stdout** (the printed information on your screen) to a new screen which you can access on command. To disconnect from this new screen, you can type `Ctrl + a` to stop sending signals to the screen, and then `Ctrl + d` to detach from the current screen. To reconnect to the screen and supervise the progress, you can do:

```bash
screen -r process_name
```

All of the screen output will be saved in the `screenlog.0` file.

Another recommendation would be to refrain from using `rm` to delete files, and instead use `trash` to send them to the trash bin in your home. To [install trash-cli](https://www.tecmint.com/trash-cli-manage-linux-trash-from-command-line/).

Notice that when you see `path_to`, specified the in the manuals, you need to specify your full path to your working directory.

## Pre-requisites

In this part, we will set up our computer or server with the required programs in order to perform the analysis.

### SRA toolkit

To download and install **SRA toolkit** you can do:

```bash
sudo apt install sra-toolkit
```

Or you can download it with `wget`. Please verify the version and appropriate platform before downloading. For the computer cluster I was working, I used the following:

```bash
wget "ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz"
tar -xzf sratoolkit.current-centos_linux64.tar.gz
```

Go to the **bin** sub-directory and run the following command to [configure SRA toolkit](https://github.com/ncbi/sra-tools/wiki/03.-Quick-Toolkit-Configuration):

```bash
./vdb-config -i
```

The main aspect to configure is the **Cache** tab. Select a directory where to cache the records, usually a `ncbi/public` in your home will do.

Finally, to make the program available in your **PATH**, open and carefully edit your `.bashrc` file in your home by adding the following line:

```bash
export PATH=$PATH:/path_to_my_programs/sratoolkit.2.9.6-1-ubuntu64/bin
```

Source the edited file:

```bash
source .bashrc
```

[More information about SRA toolkit](https://reneshbedre.github.io/blog/fqutil.html).

### FastQC

To install **FastQC** in your computer you can do:

```bash
sudo apt-get install fastqc
```

To install **FastQC** in a server you can do:

```bash
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
```

Unzip the file in the desired location:

```bash
unzip downloads/fastqc_v0.11.9.zip -d programs/
```

Go to the newly created directory **FastQC** and make the **fastqc** program executable:

```bash
chmod 755 fastqc
```

Add it to your **PATH** by adding the following to your `.bashrc` file:

```bash
export PATH=$PATH:/lustre/scratch/hpc-cintia-gomez/programs/FastQC
```

### MultiQC

For your computer:

```bash
pip install multiqc
```

For the server:

```bash
conda install -c bioconda multiqc
```

### Cutadapt

To [install Cutadapt](https://cutadapt.readthedocs.io/en/stable/installation.html), you can do:

```bash
sudo apt install cutadapt
```

For the server, it is best to install it with **conda**.

Create a new environment:

```bash
conda create -n cutadaptenv cutadapt
```

Accept the suggested packages.

To activate this environment, use:

```bash
conda activate cutadaptenv
```

### TrimmomaticPE

For your computer:

```bash
sudo apt-get install trimmomatic
```

For the server:

```bash
conda install -c bioconda trimmomatic
```

### Trinity

For your computer or the server:

```bash
wget https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v2.11.0/trinityrnaseq-v2.11.0.FULL.tar.gz
```

Decompress the file and follow [this instructions](https://github.com/trinityrnaseq/trinityrnaseq/wiki/Installing-Trinity)

You can copy the binaries to yout `bin` directory or source the path to yout `$PATH`.

If you do not have **cmake**, you can do:

```bash
wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2.tar.gz
```

And follow the instructions of [this page](https://linux4one.com/how-to-install-cmake-on-debian-10).

If you get problems with the **OpenSSL** libraries, do:

```bash
sudo apt-get install libssl-dev
```

Install also the additional requirements, which are BOWTIE2, jellyfish, and salmon

### BOWTIE2

```bash
conda install bowtie2
```

### Jellyfish

Follow this [instructions](http://www.genome.umd.edu/jellyfish.html)

```bash
wget https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz
```

If your in a server where you are not SUDO, do:

```bash
./configure
```

And then `make`. Do not do `make install` because we did not set the `--prefix=` variable when we were configuring the compilation. I did not do that, because in this way apparently, it could not correctly solve the required libraries directions. I chose to modify my `.bashrc` file to export the **jellyfish** binaries location.


### Salmon

Download the pre-compiled binaries from their GitHub page. Decompress the file (**detar** is an alias for `tar -xzvf`), and make a soft link of the binaries to your bin folder, if applies. If not, export the program location to your `.bashrc` file.

```bash
wget https://github.com/COMBINE-lab/salmon/releases/download/v1.3.0/salmon-1.3.0_linux_x86_64.tar.gz
detar salmon-1.3.0_linux_x86_64.tar.gz
cd path_to/programs/bin
ln -s path_to/salmon-latest_linux_x86_64/bin/salmon
```

### STAR

To install it in the server (provided that you have **conda** installed), do:

```bash
conda install -c bioconda star
```

In case the Python version requirements are not met, you can create an environment with `conda create -n star_py python=2.7` and re-run the command above.

### Subread (featureCounts)

Download it from [this link](https://sourceforge.net/projects/subread/). Decompress the file with `detar` and copy the binaries to your **bin** directory (in my case `/home/cintia/programs/bin`, which is available in my PATH).

### HISAT2

Activate **star_py** environment and install it with **conda**.

```bash
conda install -c bioconda hisat2
```

<!-- ### SPADES

```bash
conda install -c bioconda spades
``` -->
