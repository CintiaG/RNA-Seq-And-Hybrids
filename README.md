# RNA-Seq analysis approaches for hybrid microorganisms

Author: Cintia Gómez-Muñoz

Created: June 1, 2021

Updated: June 7, 2021

---

## Introduction

In this repository I summarize the tools and approaches we have used to analyze RNA-Seq data from hybrids microorganisms. It includes description of the process and scripts to perform the analysis in a personal computer and a cluster.

Current content of this repository:

* **00_rna_seq_intro:** Brief RNA-Seq introduction and instructions to install used programs. Minor troubleshootings.
* **01_rna_seq_data:** Download RNA-Seq information form the NCBI database using the **SRA toolkit**.
* **02_reads_qual:** Sequences' quality evaluation, adapter removal and trimming (**FastQC**, **Cutadapt** and **Trimmomatic**).
* **03_reads_assembly:** _De novo_ transcriptome assembly with **Trinity**.
* **04_ref_assembly:** Transcriptome analysis using a reference assembly with **STAR**, **HISAT2** and **featureCounts**.
