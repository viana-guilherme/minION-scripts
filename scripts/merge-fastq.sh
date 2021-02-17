# !/usr/bin/env bash
#
# File: merge-fastq.sh

# Input: the path to the desired directories (eg. the output of minKNOW for a run)
# Output: several .fastq files, one for each provided directory

#the function below generates a single .fastq file from a collection of files in a directory
#then it moves every new file to a directory in the directory where the function was called

function merge-fastq {
  for CURR_DIR in $1
  do
    echo -e "\nmerging .FASTQ files directory '${CURR_DIR}'"
    DIR_NAME=$(echo "${CURR_DIR::-1}" | grep -oP "\w+$") # removes the `/` character from the dir name. This works really well because we are using symbolic links

   touch "${DIR_NAME}_merged.fastq"

    for  FILE in ${CURR_DIR}*.fastq
    do
        cat "${FILE}" >> "${DIR_NAME}_merged.fastq"
    done

    echo "$(ls -1 "${CURR_DIR}" | wc -l) files read"
    echo -e "Directory '${CURR_DIR}' done"

  done

  # setting an output directory and moving all the files there
  PARENT_NAME=$(echo ${CURR_DIR} | grep -oP "\d{8}\w*(?=\W)")

  date=$(echo ${PARENT_NAME} | grep -oP "\d{8}")
  flowcell=$(echo ${PARENT_NAME} | grep -oP [A-Z]{3}\\d{3})

  new_directory=$(echo "${date}_${flowcell}_merged_fastq")

  if [ ! -d ./${new_directory} ]
  then
    mkdir ./"${new_directory}"
    echo -e "\n\n${new_directory}_merged_fastq drectory created!"
    mv *.fastq ./"${new_directory}"
  else
    mv *.fastq ./"${new_directory}"
  fi
}
