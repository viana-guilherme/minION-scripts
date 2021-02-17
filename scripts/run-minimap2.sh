#!/usr/bin/env bash

# this is a straightforward script. We define variables to make generic
# filenames for every file found in a target directory

if [[ -z $1 ]]; then input_dir="."; else input_dir=$1; fi

target_dir="${input_dir}/filt/*.fastq"

for fastq in $target_dir
do
  parent_name=$(echo ${input_dir} | grep -oP "\d+_\w+\d")

  file_name=$(echo ${fastq} | grep -oP "(barcode\d{2}|unclassified)")

  input_file="./${fastq}"

  out_file="${parent_name}_${file_name}.paf"


  printf "\nrunning minimap2 for ${parent_name}_${file_name}"
  minimap2 -cx map-ont ncbi/refseq_16S.fa $input_file  > $out_file

  # let's move every alignment file to a new directory created after it's parent directory
  # this way data gets nicely organized even with longer calls to the script
  
  mkdir -p ${parent_name}_aln_output
  mv *.paf ${parent_name}_aln_output

done
