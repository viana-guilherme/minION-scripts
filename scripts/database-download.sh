#!/usr/bin/env bash

# this script creates a dir with reference 16S fasta files downloaded from ncbi refseq db

mkdir ncbi
cd ./ncbi/

# Download bacterial 16S
curl ftp://ftp.ncbi.nlm.nih.gov/refseq/TargetedLoci/Bacteria/bacteria.16SrRNA.fna.gz | gunzip > bacteria_16SrRNA.fa

# Download archaeal 16S
curl ftp://ftp.ncbi.nlm.nih.gov/refseq/TargetedLoci/Archaea/archaea.16SrRNA.fna.gz | gunzip > archaea_16SrRNA.fa

# unifying archaeal and bacterial datatouch arch_bact_16S.fa
cat *_16SrRNA.fa >> refseq_16S.fa

cd $OLDPWD
