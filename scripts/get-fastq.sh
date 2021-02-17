#!/usr/bin/env bash

# wrapper for retrieving fastq files

# create an directory for keeping the files
mkdir -p $1

#source the function that finds the files
source scripts/merge-fastq.sh

#create a list with each path to the directory you want to extract fastq files from
cd $1

prefix=$2
if [[ -z $3 ]]; then minknow_output="/var/lib/minknow/data/"; else minknow_output=$3; fi

for directory in $(ls $minknow_output | grep "${prefix}" )
do
  source ../scripts/retrieve-directories.sh "${minknow_output}${directory}"
done
