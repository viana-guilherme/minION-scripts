# !/usr/bin/env bash
#
# File: retrieve-directories.sh

# Input: the path to the desired directories (eg. the output of minKNOW for a run)
# Output: a recursive list of the directories that contain .fastq files and "_pass"
#         in their location
#

if [[ -z $1 ]]; then INPUT="."; else INPUT=$1; fi

# first we need to find our target directories, that is, those that have fastq files inside a "_pass" subdirectory
TARGET_DIR_LIST=$(find "${INPUT}" -name "*.fastq" | grep "_pass" | grep -oP "^.+?(?=\w*.fastq$)" | sort | uniq)

# now we run iteratively the function defined by the merge-fastq.sh script
for directory in "${TARGET_DIR_LIST}"
do
  merge-fastq "${directory}"
done
