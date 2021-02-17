# retrieving fastq files

source ./scripts/get-fastq.sh $1 $2 $3

# running the qc script

conda activate python-3_7 # this is needed to load NanoFilt

for directory in */
do
  source ../working_dir/minionqc.sh $directory
done

# generating alignments

## download the refseq 16S database (if needed)
source ../working_dir/database-download.sh

## running minimap2

for directory in *merged_fastq/
do
  source ../working_dir/run-minimap2.sh "$directory"
done

mkdir -p alignments
mv *_aln_output alignments/

# parsing the alignment files

## creating a directory to store the final tables
mkdir -p taxonomic_assignment

## running paf-parse.R for every .paf file found in the 'alignments' folder
for aln_file in $(find alignments | grep .paf)
do
  echo "$aln_file"

  parent_dir=$(echo "$aln_file" | grep -oP '\d{8}_\w{6}(?!_aln)')

  if [[ ! -d "taxonomic_assignment/${parent_dir}" ]]; then mkdir "taxonomic_assignment/$parent_dir"; fi

  Rscript --vanilla ../scripts/paf-parse.R $aln_file

  mv *taxCount.tsv "taxonomic_assignment/$parent_dir"

done

# removing collateral directories (duplicated)
rm -r *_merged_fastq/
