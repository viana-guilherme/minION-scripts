#! /usr/bin/env Rscript

# loading the needed packages

if(!require(pafr)){
  install.packages("pafr")
  library(pafr, quietly = TRUE)
} else {
  library(pafr, quietly = TRUE)
  }

if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse, quietly = TRUE)
} else {
  library(tidyverse, quietly = TRUE)
  }

# checking if the conversion table exists; if not, make it (requires accession2name script)
if(!file.exists("ncbi/nametable.tsv")) {
  source("accession2name.R")
  name_table <- read_tsv(file="ncbi/nametable.tsv", col_names = TRUE)
} else {
  name_table <- read_tsv(file="ncbi/nametable.tsv", col_names = TRUE)
}

# reading the paf file and generating the summary

input_file <- commandArgs(trailingOnly = TRUE) # takes filenames given as arguments from the command line 
paf <- read_paf(file = input_file, tibble = TRUE)

paf_count <- paf %>%
  filter(mapq != 0 & nmatch > 1000) %>% # PLACE TO LOOK FOR IF TUNING THE STRICTNESS OF THE SCRIPT
  mutate(species = map_chr(.$tname, ~ {idx <- match(.x, name_table$accession)
                                 return(name_table$name[idx])}
    )) %>%
  group_by(species) %>%
  tally(sort = TRUE)

# saving the final table
input_name <- str_extract(input_file, pattern = "(?<=output\\/)\\d{8}_\\w+_.*(?=.paf)") # retrieving info on the parent directory
output_name <- paste0("./",input_name, "_taxCount.tsv")

write_tsv(x = paf_count, file = output_name)
