#!/bin/bash
####
# [@param] - string:destination path (default is /mnt)
# [@param] - string:name of the file (default is "list_of_file"
# [@param] - int:number of files to chose randomly (default is 80)
#
# @link https://stackoverflow.com/questions/301039/how-can-i-escape-white-space-in-a-bash-loop-list
# @link https://stackoverflow.com/questions/4928738/shell-script-copy-and-paste-a-random-file-from-a-directory#4928994
# @link http://www.unix.com/shell-programming-and-scripting/170387-copying-random-jpg-files-different-folder.html
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-08-24
####

if [[ $# -gt 0 ]];
then
    MOUNT_PONT="${1}"
else
    MOUNT_PONT="/mnt"
fi

if [[ $# -gt 1 ]];
then
    LIST_OF_FILE_PATH="${2}"
else
    LIST_OF_FILE_PATH="list_of_file"
fi

if [[ $# -gt 2 ]];
then
    NUMBER_OF_FILES_TO_TRY="${3}"
else
    NUMBER_OF_FILES_TO_TRY=80
fi

if [[ ! -f "${LIST_OF_FILE_PATH}" ]];
then
    echo ":: Invalid file path provided!"
    echo "   ${LIST_OF_FILE_PATH} does not exist."

    exit 1
fi

#choose randome list of file
declare -a LIST_OF_FILE
#LIST_OF_FILE=( $(shuf -n 80 ${LIST_OF_FILE_PATH}) )

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in $(shuf -n ${NUMBER_OF_FILES_TO_TRY} ${LIST_OF_FILE_PATH})
do
    LIST_OF_FILE+=( "$f" )
done
IFS=$SAVEIFS

#SIZE = du -s ${PATH}
#AVERAGE_FILE_SIZE=SIZE/NUMBER_OF_FILES_IN_TOTAL
#SPACE_LEFT_ON_DESTINATION_DEVICE

#do it in big chunks until only AVERAGE_FILE_SIZE*10 is left on the destination device
#then do it one after another until device is full
#   for each of the last files, check if the file size is lss than the current existing free space on the destination device

#echo "deleting empty files"
find ${MOUNT_PONT} -type f -empty -delete

for FILE_PATH in "${LIST_OF_FILE[@]}";
do
    #echo "${FILE_PATH}"
    #cp -v "${FILE_PATH}" /mnt/
    if [[ -f "${FILE_PATH}" ]];
    then
        #echo "cp ${FILE_PATH}" ${MOUNT_PONT}/
        cp "${FILE_PATH}" ${MOUNT_PONT}/
    fi
done;

sync

find ${MOUNT_PONT} -type f -empty -delete

du -sh ${MOUNT_PONT}/
