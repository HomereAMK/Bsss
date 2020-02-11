#!/bin/bash
#!/bin/bash

#PBS -W group_list=dp_00007 -A dp_00007
#PBS -N fastq-dump
#PBS -e FASTQC.err
#PBS -o FASTQC.log
#PBS -m n
#PBS -l nodes=1:ppn=14
#PBS -l mem=120gb
#PBS -l walltime=96:00:00


echo working directory is ${PBS_O_WORKDIR}
cd ${PBS_O_WORKDIR}

NPROCS='wc -l < $PBS_NODEFILE'
echo This job has allocated $NPROCS nodes

module load tools
module load jre/1.8.0
module load bbmap/38.35
module load ngs
module load jre/1.8.0
module load java/1.8.0
module load perl/5.24.0
module load fastqc/0.11.8
module load adapterremoval/2.2.4
module load flash/1.2.11
module load kraken/2.0.7-beta20180917/
module load ncbi_cxx/18.0.0
module load kronatools/2.7.1
module load bbmap/36.49
module load samtools/1.9
module load bowtie2/2.3.2
module load bwa/0.7.15
module load gatk-protected/3.7
module load picard-tools/2.9.1
module load bedtools/2.28.0
module load intel/compiler/64/2019
module load R/3.5.0
module load anaconda2/2.2.0
module load mapdamage/2.0.9
module load freebayes/1.2.0-2-g29c4002

for base in $(cat 01_info_files/List_SRA_fuckingFeb.txt|awk '{print $1}'|grep -iv "model")

do 
	toEval="cat 00_scripts/fastq-dump_all.sh | sed 's/__BASE__/$base/g'"; eval $toEval > FSTQ"$base".sh

done

for i in $(ls FSTQ*); do qsub $i; done
