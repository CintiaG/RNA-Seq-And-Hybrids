# RNA-Seq Data

Author: Cintia Gómez-Muñoz

Created: July 2, 2020

Updated: June 1, 2021

---

## Introduction

The first step to perform an RNA-seq analysis is, obviously, to **obtain the data**. The former can happen in at least one the following two ways. The first is that your sequencing service provider gives you a link to a web page from which you can download your source data. The second is that you can download sequences from public databases such as the [Sequence Read Archive (SRA)](https://www.ncbi.nlm.nih.gov/sra) of the NCBI. In this tutorial, we will use the later for demonstration purposes.

## Get your data

In theory, you can get your hands on many public RNA-seq experiments. Most of the authors of recent papers using the RNA-seq technique upload their data to the **SRA** and report the identification number in their manuscript. Therefore, you just need to look up and select an interesting paper that provides the former information. In our case, we are going to use the information of a [paper](https://biotechnologyforbiofuels.biomedcentral.com/articles/10.1186/s13068-016-0653-4)<sup>1</sup> that reports and analyze the genome sequence of a yeast named _Saccharomycopsis fibuligera_ (strain KPH12) and its interspecific hybrid (strain KJJ81).

After whole genome sequencing, the authors performed a RNA-seq with duplicates using the following experimental design.

Strain | Sample ID | Condition
---|---|---
KPH12 | SAMN05180639 | B medium
KPH12 | SAMN05180640 | B medium
KPH12 | SAMN05180641 | YP containing glucose 0.1%
KPH12 | SAMN05180642 | YP containing glucose 0.1%
KPH12 | SAMN05180637 | YP containing glucose 2%
KPH12 | SAMN05180638 | YP containing glucose 2%
KJJ81 | SAMN05180633 | B medium
KJJ81 | SAMN05180634 | B medium
KJJ81 | SAMN05180635 | YP containing glucose 0.1%
KJJ81 | SAMN05180636 | YP containing glucose 0.1%
KJJ81 | SAMN05180637 | YP containing glucose 2%
KJJ81 | SAMN05180638 | YP containing glucose 2%

To download the data, one could search for the ID in the SRA and do it manually. However, this is lengthy, prone to errors and you depend on a graphical interface to do so, which would not work if you are working in a remote server without one. A more suitable option is to use the tools provided by the NCBI to perform this type of tasks, this tool is called the [SRA toolkit](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc) (for more information on how to install it, see the '**RNA-Seq Introduction and Setup**' document).

The **SRA toolkit** handels any SRA record as a single object in a `*.sra` format. This object contains all available information related to the SRA record, such as reads, alignments, or reference sequences, among others, in a super compressed format, which speeds up the information transfer. More information can be found [here](https://www.ncbi.nlm.nih.gov/books/NBK242621/).

To download a SRA record, you only need to know the **SRR** number and do the following:

```bash
prefetch SRR5494632
```

However, since we are going to work with several **SRR** records, it would be a good a idea to automatize the download with a simple bash script. To get all **SRR** numbers of the sequences you are going to analyze, you can use the 'SRA Run Selector' and download the list into a file in the desired location. In my case, the file is called **SRR_Acc_List.txt** (stored in the **source_data** directory) and it looks like this.

```none
SRR3598368
SRR3598369
SRR3598370
SRR3598371
SRR3598372
SRR3598373
SRR3598374
SRR3598375
SRR3598376
SRR3598377
SRR3598378
SRR3598367
```

The script, called **prefetchSRR.sh** (stored in the **used_scripts** directory) is a simple loop that looks like this:

```bash
#!/bin/bash

# A script to download a series of SRR numbers and save them into the ncbi/public directory

while IFS='' read -r SRR; do
        echo "$SRR"
        prefetch $SRR
done < $1
```

To run it:

```bash
./used_scripts/prefetchSRR.sh source_data/SRR_Acc_List.txt
```

If you are working in a computer cluster, make sure to run it from a node with Internet access, otherwise you could get error messages such as 'Failed to call external services'.

Now, it is extremely important to check the integrity of the downloaded files to make sure that they are identical copies to the original ones and that there were no problems during transfer. For that, the **SRA toolkit** has another tool called **vdb-validate**. Similar than before, we can make a bash script, called **vdb-validateSRR.sh** to check every downloaded record and execute it:

```bash
./used_scripts/vdb-validateSRR.sh source_data/SRR_Acc_List.txt
```

The next thing to do is to extract the sequences reads from the **SRA** files and store them in a more suitable format into a new directory. For that, there are two ways of doing so: **fastq-dump** and **fasterq-dump**; however, the first one is going to be depreciated because the second is way faster. For that reason, we will only use **fasterq-dump**, for example:

```bash
fasterq-dump SRR3598368 -O source_data
```

Or with the loop script:

```bash
./used_scripts/fasterq-dumpSRR.sh source_data/SRR_Acc_List.txt
```

To run it in a cluster computer, you have to take notice of the following. The **SRA toolkit** [v.10 requires Internet connection](https://github.com/ncbi/sra-tools/issues/302); nevertheless, the node I was working did not have Internet. Therefore, I opted to use a [lower version (v.9)](https://www.biostars.org/p/426430/).

So far, when working in the computer cluster, we were working out of the **SBATCH** queue system because we were only downloading information from the Internet and we were not using computational power; however, for this case, some computational power is required, therefore we should run the process with the **fasterq-dumpSRR_sbatch.sh** script.

After running **fasterq-dump**, we should have all the data information in **FASTQ** format in the **source_data** directory ready for the next step of the analysis.

## References

1. Choo, J. H., Hong, C. P., Lim, J. Y., Seo, J.-A., Kim, Y.-S., Lee, D. W., Park, S.-G., Lee, G. W., Carroll, E., Lee, Y.-W., & Kang, H. A. (2016). Whole-genome de novo sequencing, combined with RNA-Seq analysis, reveals unique genome and physiological features of the amylolytic yeast Saccharomycopsis fibuligera and its interspecies hybrid. Biotechnology for Biofuels, 9(1), 246. https://doi.org/10.1186/s13068-016-0653-4
