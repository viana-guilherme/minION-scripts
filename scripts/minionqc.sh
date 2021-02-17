#!/usr/bin/env bash

# this script runs guppy_barcoder AND NanoFilt for .fastq files prior to tax assignment

export PATH=$PATH:/opt/ont/minknow/guppy/bin

# checking if a argument was provided
if [[ -z $1 ]]; then input_dir="."; else input_dir=$1; fi

cd ${input_dir}

input_name=${PWD##*/} # nice trick to obtain the name of the current directory wihtout "/"

# first step: let's create a temporary dir for securely holding our trimmed files
# this is needed because guppy has a weird preset and creates a complex directory hierarchy

mkdir trimmed_temp/

guppy_barcoder\
 -i .\
 -s ./trimmed_temp\
 -q 0\
 --barcode_kits "SQK-16S024"\
 --trim_barcodes\

# now let's retrieve our files. I use a lot of grep to make tidy file names
mkdir trimmed

fastq_files=$(find ./trimmed_temp/ | grep ".fastq$")

for file in $fastq_files
do
	echo $file
	parent=$(echo $file | grep -oP "\w+(?=\/\w+.fastq$)")

	cat $file >> "trimmed/${parent}_trim.fastq"
done

# we do not need the temporary directory anymore
rm -r trimmed_temp

# second step, running NanoFilt on our de-barcoded files reads. This is more straight forward

mkdir filt

for trimmed in trimmed/*_trim.fastq
do
	filt=$(echo $trimmed | grep -oP "\w+_trim(?=\.fastq$)")
	cat "${trimmed}" | NanoFilt -q 10 -l 1350 --maxlength 1650  > "filt/${filt}_filt.fastq"
done

# returning to the directory in which the script was called
cd $OLDPWD
