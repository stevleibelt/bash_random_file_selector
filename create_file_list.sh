#!/bin/bash
####
# creates a list of mp3 files.
#
# [@param] - string:path to search in (default is current working directory)
# [@param] - string:name of the file (default is "list_of_file"
# [@param] - string:file extension to filter for (default is "mp3")
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-08-24
####

if [[ $# -gt 0 ]];
then
    PATH_TO_SEARCH_IN="${1}"
else
    PATH_TO_SEARCH_IN="."
fi

if [[ $# -gt 1 ]];
then
    LIST_OF_FILE_NAME="${2}"
else
    LIST_OF_FILE_NAME="list_of_file"
fi

if [[ -f ${LIST_OF_FILE_NAME} ]];
then
    rm ${LIST_OF_FILE_NAME}
    touch ${LIST_OF_FILE_NAME}
fi

if [[ $# -gt 2 ]];
then
    FILE_EXTENSION_TO_SEARCH_FOR="${3}"
else
    FILE_EXTENSION_TO_SEARCH_FOR="mp3"
fi

##not working
#shopt -s nullglob

#for FILE_PATH in music/alben/*/*
#do
#    echo ${FILE_PATH} >> ${LIST_OF_FILE_NAME}
#done

#for FILE_PATH in music/alben/*/*/*
#do
#    echo ${FILE_PATH} >> ${LIST_OF_FILE_NAME}
#done

#find -iname *.mp3 -type f
#for FILE_PATH in $(find ${PATH_TO_SEARCH_IN} -iname *.mp3 -type f -print0 | xargs -0 -i{} echo {})
#for FILE_PATH in $(find ${PATH_TO_SEARCH_IN} -iname *.mp3 -type f)
#find ${PATH_TO_SEARCH_IN} -iname *.mp3 -type f -exec echo "\"{}\"" >> ${LIST_OF_FILE_NAME} \;
#do
    #echo ${FILE_PATH:2} >> ${LIST_OF_FILE_NAME}
    #echo $(realpath "${FILE_PATH}")
#    echo "\"${FILE_PATH}\"" >> ${LIST_OF_FILE_NAME}
#done
## working
find ${PATH_TO_SEARCH_IN} -iname *.${FILE_EXTENSION_TO_SEARCH_FOR} -type f -exec echo "{}" >> ${LIST_OF_FILE_NAME} \;
#find ${PATH_TO_SEARCH_IN} -iname *.mp3 -type f -print0 | while read -d $'\0' FILE_PATH;
#do
#    if [[ -f "${FILE_PATH}" ]];
#    then
#        echo ${FILE_PATH} >> ${LIST_OF_FILE_NAME}
#    fi
#done;

echo "\"${LIST_OF_FILE_NAME}\" created"
