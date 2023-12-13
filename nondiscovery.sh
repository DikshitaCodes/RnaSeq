#! /bin/bash
#PBS -l nodes=1:ppn=4,cput=02:00:00,walltime=04:00:00
#PBS -N nondiscovery
#PBS -d /export/home/biostuds/2809330n/reassessment/nondiscovery
#PBS -m abe
#PBS -M 2809330n@student.gla.ac.uk
#PBS -q bioinf-stud
#
#Resource files
adapter='/export/projects/polyomics/biostuds/data/illumina_adapter.fa' #path to adapter files
hisat2index='/export/projects/polyomics/Genome/Mus_musculus/mm10/Hisat2Index/chr2' #path to reference genome index
gtf='/export/projects/polyomics/Genome/Mus_musculus/mm10/annotations/chr2.gtf' #path for the annotations file
datafiles='/export/home/biostuds/2809330n/reassessment/datafiles' #path to the local directory- with fastq files

#Making subdirectories
hisat_results="$datafiles/hisat_results" # path to directory for hisat2 results
stringtie_results="$datafiles/stringtie_results" # path to directory for stringtie results
mkdir -p "${hisat_results}" # make above hisat2 directory, -p checks if such dir already exists
mkdir -p "${stringtie_results}" # make above stringtie directory

gtflist='list.gtf.txt' # filename for final GTF list
rm -f ${gtflist} # remove if exists
#RUNNING a single LOOP for all the work
for sample in s1.c2 s2.c2 s3.c2 s4.c2 s5.c2 s6.c2 s7.c2 s8.c2 s9.c2 s10.c2 s11.c2 s12.c2 
do
	fastq="$datafiles/$sample.fq" # path to raw fastq file
	trim1="$datafiles/$sample.t1.fq" # path to adapter-trimmed fastq file
	trim2="$datafiles/$sample.t2.fq" # path to quality-trimmed fastq file
	scythe -a $adapter -q sanger -o $trim1 $fastq # command to execute scythe
	sickle se -f $trim1 -t sanger -o $trim2 -q 10 -l 50 # command to execute sickle
	hisat2 --phred33 -x $hisat2index -p 4 -U $trim2 -S $hisat_results/$sample.sam --rna-strandness RF # command to execute hisat2
	samtools view -bS -o $hisat_results/$sample.bam $hisat_results/$sample.sam # command to execute samtools view
 	samtools sort $hisat_results/$sample.bam -o $hisat_results/$sample.sort # command to execute samtools sort
	rm $hisat_results/$sample.sam $hisat_results/$sample.bam # removing unnecessary files
	rm $trim1 $trim2 # removing unnecessary files
 	str_smp_dir="$stringtie_results/$sample" # path to sample-specific subdirectory for stringtie results
 	mkdir -p "$str_smp_dir" # make the above directory
 	stringtie $hisat_results/$sample.sort -p 4 -B -e -G $gtf -o $str_smp_dir/$sample.gtf --rf # command to execute stringtie
 	gtfline="$sample $str_smp_dir/$sample.gtf" # line containing sample and path to GTF
 	echo $gtfline >> $gtflist # adding the above line to a file
done
# Converting sample-specific GTFs to a single gene-count matrix

/export/home/biostuds/2809330n/bin/python2.7 /export/projects/polyomics/App/prepDE.py -i ${gtflist} 

