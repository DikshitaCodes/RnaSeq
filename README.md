RNA-Seq Analysis Pipeline

Table of Contents:
1.	Introduction
2.	Software Used 
3.	Usage 

Introduction:

This repository contains the code and analysis for the RNA-Seq and Next-Generation Transcriptomics project. The primary objective of this project is to analyze RNA-Seq data obtained from the NextSeq500 sequencer. The analysis involves quality checking of raw reads, pre-processing steps such as adapter trimming, and downstream analysis including alignment to the reference genome and differential expression analysis.

Software Used:

The analysis pipeline utilizes several bioinformatics tools: 

Scythe: Identifies and trims contaminant substrings in sequence reads, particularly 3'-end adapters. 

Sickle: Performs quality-based trimming of reads, addressing deterioration towards the 3' and 5' ends. 

HISAT2: Efficiently aligns RNA-Seq reads to the reference genome using hierarchical indexing. 

Samtools: Converts the alignment results (SAM) to BAM format for further analysis. 

Stringtie: Assembles and quantifies transcripts based on the aligned reads.

Usage:

Explore the code to adapt it for your own RNA-Seq projects. Below are essential usage instructions:

HISAT2:

hisat2 [options]* -x <ht2-idx> -p -U <r> [-S <sam>] –rnastrandness 

[options] – give the quality for like –phred33 for illumine and phred64 for sanger.

ht2-idx - name of the index genome file

sam - name of the output sam file.

-U - path to the fastq files. 

-x - path to the index file. 

--rnastrandness - provides orientation of alignment.

Stringtie:

stringtie [-o <output.gtf>] [options] <read_alignments.bam>

Feel free to reach out if you have questions or need assistance. Happy coding!


