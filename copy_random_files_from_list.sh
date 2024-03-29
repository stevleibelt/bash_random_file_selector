#!/bin/bash
####
# [@param] - string:destination path (default is /mnt)
# [@param] - string:name of the file (default is "list_of_file"
# [@param] - int:number of files to chose randomly (default is 80)
####
# @todo
#   * check if destionation path is writeable
#   * check, for the first file to copy, if we could copy the file
#
# @link https://stackoverflow.com/questions/301039/how-can-i-escape-white-space-in-a-bash-loop-list
# @link https://stackoverflow.com/questions/4928738/shell-script-copy-and-paste-a-random-file-from-a-directory#4928994
# @link http://www.unix.com/shell-programming-and-scripting/170387-copying-random-jpg-files-different-folder.html
#
# @author stev leibelt <artodeto@bazzline.net>
# @since 2017-08-24
####

##begin of function
####
# @param <string:path>
# @return 0 for yes, 1 for no
####
function check_if_free_disk_space_is_left ()
{
    local FREE_DISK_SPACE=$(df --output=avail "${1}" | tail -n +2)

    if [[ ${FREE_DISK_SPACE} -lt 100 ]];
    then
        return 1
    fi

    return 0
}
##end of function

##begin of user input
CLEANUP_DESTINATION_FIRST=0
IS_DRY_RUN=0
LEVEL_OF_VERBOSITY=0
SHOW_HELP=0
USE_THE_FORCE=0

while true;
do
    case "${1}" in
        -c)
            CLEANUP_DESTINATION_FIRST=1
            shift
            ;;
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
            shift
            ;;
        -vv)
            LEVEL_OF_VERBOSITY=2
            shift
            ;;
        -vvv)
            LEVEL_OF_VERBOSITY=3
            shift
            ;;
         *)
            break
            ;;
    esac
done

LIST_OF_FILE_PATH=${2:-'file.list'}
DESTINATION_PATH=${1:-'/mnt'}
NUMBER_OF_FILES_TO_TRY=${3:-666}
##end of user input

##begin of help
if [[ ${SHOW_HELP} -eq 1 ]];
then
    echo ":: Usage"
    echo "   ${BASH_SOURCE[0]} [-c] [-d] [-f] [-h] [-v|-vv|-vvv] [<destination_path>] [<path_to_the_source_list>] [<number_of_files_to_choose>]"
    echo ""
    echo "  -c      - Cleanup destination before copy (remove all files)"
    echo "  -d      - Dry run"
    echo "  -f      - Force"
    echo "  -h      - Show this help"
    echo "  -v      - Be verbose"
    echo "  -vv     - Be more verbose"
    echo "  -vvv    - Be most verbose"

    exit 0
fi
##end of help

##begin of validation
if [[ ${DESTINATION_PATH: -1} == "/" ]];
then
    DESTINATION_PATH="${DESTINATION_PATH:0:-1}"
fi

if [[ ! -f "${LIST_OF_FILE_PATH}" ]];
then
    if [[ ${USE_THE_FORCE} -eq 0 ]];
    then
        echo ":: Invalid file path provided!"
        echo "   ${LIST_OF_FILE_PATH} does not exist."

        exit 1
    fi
fi

if [[ ${CLEANUP_DESTINATION_FIRST} -eq 1 ]];
then
    echo ":: Cleaning up destination first."

    rm -fr ${DESTINATION_PATH}/*
fi

check_if_free_disk_space_is_left "${DESTINATION_PATH}"

if [[ $? -gt 0 ]];
then
    echo ":: No space left."
    echo "   There is not enough free disk space on ${DESTINATION_PATH}"

    exit 2
fi
##end of validation

if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
then
    echo ":: Using >>${LIST_OF_FILE_PATH}<< as source."
    echo ":: Filling up destination path >>${DESTINATION_PATH}<<".
fi

#choose randome list of file
declare -a LIST_OF_FILE
#LIST_OF_FILE=( $(shuf -n 80 ${LIST_OF_FILE_PATH}) )

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for CURRENT_FILE_PATH in $(shuf -n ${NUMBER_OF_FILES_TO_TRY} ${LIST_OF_FILE_PATH})
do
    if [[ ${LEVEL_OF_VERBOSITY} -gt 2 ]];
    then
        echo "   Adding >>${CURRENT_FILE_PATH}<<"
    fi
    LIST_OF_FILE+=( "${CURRENT_FILE_PATH}" )
done
IFS=${SAVEIFS}

#SIZE = du -s ${PATH}
#AVERAGE_FILE_SIZE=SIZE/NUMBER_OF_FILES_IN_TOTAL
#SPACE_LEFT_ON_DESTINATION_DEVICE

#do it in big chunks until only AVERAGE_FILE_SIZE*10 is left on the destination device
#then do it one after another until device is full
#   for each of the last files, check if the file size is lss than the current existing free space on the destination device

#echo "deleting empty files"
if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
then
    echo ":: Deleting empty files in >>${DESTINATION_PATH}<<."
fi
find ${DESTINATION_PATH} -type f -empty -delete

if [[ ${LEVEL_OF_VERBOSITY} -gt 0 ]];
then
    echo ":: Trying to copy >>${#LIST_OF_FILE[@]}<< files."
fi

CURRENT_NUMBER_OF_COPIED_FILES=0

for FILE_PATH in "${LIST_OF_FILE[@]}";
do
    if [[ ${LEVEL_OF_VERBOSITY} -gt 3 ]];
    then
        echo "   File path >>${FILE_PATH}<<"
    fi
    #cp -v "${FILE_PATH}" /mnt/
    #echo "cp -v \"${FILE_PATH}\" ${DESTINATION_PATH}/"
    if [[ ${LEVEL_OF_VERBOSITY} -gt 3 ]];
    then
        ls -l "${FILE_PATH}"
    fi

    if [[ -e "${FILE_PATH}" ]];
    then
        if [[ ${LEVEL_OF_VERBOSITY} -gt 2 ]];
        then
            echo "   >>${FILE_PATH}<< is a file."
        fi
        if [[ ${LEVEL_OF_VERBOSITY} -gt 3 ]];
        then
            echo "   cp ${FILE_PATH}" ${DESTINATION_PATH}/
        fi
        cp "${FILE_PATH}" ${DESTINATION_PATH}/

        CURRENT_NUMBER_OF_COPIED_FILES=$(calc ${CURRENT_NUMBER_OF_COPIED_FILES} + 1)

        if [[ $(calc ${CURRENT_NUMBER_OF_COPIED_FILES} % 10) -eq 0 ]];
        then
            if [[ ${LEVEL_OF_VERBOSITY} -gt 2 ]];
            then
                echo "   Checking free disk space for >>${FILE_PATH}<<."
            fi

            check_if_free_disk_space_is_left "${DESTINATION_PATH}"

            #if function exit status is greater 0, something is not ok
            if [[ $? -gt 0 ]];
            then
                if [[ ${LEVEL_OF_VERBOSITY} -gt 1 ]];
                then
                    echo "   There is no space left on >>${DESTINATION_PATH}<< stoping copy job."
                fi

                break
            fi
        fi
    fi


    if [[ ${LEVEL_OF_VERBOSITY} -eq 1 && ${CURRENT_NUMBER_OF_COPIED_FILES} -gt 0 ]];
    then
        if [[ $(calc ${CURRENT_NUMBER_OF_COPIED_FILES} % 80 ) -eq 0 ]];
        then
            echo "."
        else
            echo -n "."
        fi
    fi

    if [[ ${LEVEL_OF_VERBOSITY} -gt 1 ]];
    then
        echo "   Progress: ( ${CURRENT_NUMBER_OF_COPIED_FILES} / ${NUMBER_OF_FILES_TO_TRY} )"
    fi
done;

if [[ ${LEVEL_OF_VERBOSITY} -gt 1 ]];
then
    echo "   Synchronizing file system."
fi
sync

if [[ ${LEVEL_OF_VERBOSITY} -gt 2 ]];
then
    echo ":: Deleting empty files."
fi
find ${DESTINATION_PATH} -type f -empty -delete

if [[ ${LEVEL_OF_VERBOSITY} -gt 1 ]];
then
    du -sh ${DESTINATION_PATH}/
fi
