#! /usr/bin/env Rscript

if(!require(tidyverse)){install.packages("tidyverse"); library(tidyverse)}

database <- read_file("ncbi/refseq_16S.fa") %>%
  str_extract_all(pattern = "(?<=>).*(?=\n)", simplify = TRUE) %>%
  str_split(pattern = " ", simplify = TRUE)


accession <- database[,1]
species <- str_c(database[,2], database[,3], sep = " ")

nametable <- tibble(accession = accession,  name = species) %>%
  write_tsv(file = "ncbi/nametable.tsv")
