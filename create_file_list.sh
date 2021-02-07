#!/bin/bash
####
# creates a list of mp3 files.
####
#
# [@param] - string:path to search in (default is current working directory)
# [@param] - string:name of the file (default is "list_of_file"
# [@param] - string:file extension to filter for (default is "mp3")
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-08-24
####

##begin of user input
IS_DRY_RUN=0
LEVEL_OF_VERBOSITY=0
SHOW_HELP=0
USE_THE_FORCE=0

while true;
do
    case "${1}" in
        -d)
            IS_DRY_RUN=1
            shift
            ;;
        -f)
            USE_THE_FORCE=1
            shift
            ;;
        -h)
            SHOW_HELP=1
            shift
            ;;
        -v)
            LEVEL_OF_VERBOSITY=1
            echo "   Verbose Level set to be verbose"
            shift
            ;;
        -vv)
            LEVEL_OF_VERBOSITY=2
            echo "   Verbose Level set to be very verbose"
            shift
            ;;
        -vvv)
            LEVEL_OF_VERBOSITY=3
            echo "   Verbose Level set to be very very verbose"
            shift
            ;;
         *)
            break
            ;;
    esac
done

FILE_EXTENSION_TO_SEARCH_FOR=${3:-'mp3'}
LIST_OF_FILE_NAME=${2:-'file.list'}
PATH_TO_SEARCH_IN=${1:-'.'}
##end of user input

##begin of help
if [[ ${SHOW_HELP} -eq 1 ]];
then
    echo ":: Usage"
    echo "   ${BASH_SOURCE[0]} [-d] [-f] [-h] [-v|-vv|-vvv] [<source_path>] [<path_to_the_source_list>] [<file_extension_to_filter_for>]"
    echo ""
    echo "  -d      - Dry run"
    echo "  -f      - Force"
    echo "  -h      - Show this help"
    echo "  -v      - Be verbose"
    echo "  -vv     - Be more verbose"

    exit 0
fi
##end of help

if [[ -f ${LIST_OF_FILE_NAME} ]];
then
    if [[ ${USE_THE_FORCE} -eq 0 ]];
    then
        if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
        then
            echo ":: >>${LIST_OF_FILE_NAME}<< exists, overwriting it ..."
        fi

        rm ${LIST_OF_FILE_NAME}
        touch ${LIST_OF_FILE_NAME}
    else
        echo ":: Destination file exists."
        echo "   Stop working."

        exit 1
    fi
fi

if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
then
    echo ":: Search in path >>${PATH_TO_SEARCH_IN}<<."
    echo ":: Creating >>${LIST_OF_FILE_NAME}<<."
    echo ":: Search for files with extension >>${FILE_EXTENSION_TO_SEARCH_FOR}<<."
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

NUMBER_OF_ENTRIES=$( cat ${LIST_OF_FILE_NAME} | wc -l );

if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
then
    echo ":: >>${LIST_OF_FILE_NAME}<< created."
    echo "   Containing >>${NUMBER_OF_ENTRIES}<< entries."
fi
