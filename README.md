# Random File Selector

This simple collection of bash script should ease up solving the task to randomly chose some files and copy them somewhere.

A real world scenario and the reason to code this is to fill up an usb stick with randomly selected mp3 files until it is full.

# Core Features

* creates a file list of your media files as a "cache" to speed things up
* copies random files from the list to a destination (like a mounted usb disk)

# Future Improvements

* Check free disk space before the start
    * Sum up the used file size and check if it can be copied on the file before doing it
    * Available disk space: `du -s <path>`
    * Sum up the size for all files: `ls -l <path> | awk '{ total += $5 }; END { print total }
* Maybe add file size to the generated file list
    * Benefit of this, we can configure a "max file size" (which kind of is a max run time)
* Create a configuration file to ease up the copy command (default could be the source path file and the number of files)
* Create a changelog.md
* Put both scripts into one script
* Run the copy script until the device is full or an fixed amout of files are copied (use output of df -i?)
* If write permission is not set
    * create a tempoary directory using >>mktemp -d<<
    * add entries until size of the target is reached
    * copy all stuff from tempoary directory to target using sudo
* Extend the "create_file_list.sh" script with following optional arguments
    * -f|--filter-by-extension
    * -g|--guided
    * -p|--output-file-path
* Extend the "copy_random_files_from_list.sh" script with the following optional arguments
    * -f|--maximum-amount-of-files
    * -g|--guided
    * -p|--destination-path
    * -s|--diskspace-left
* Rewrite in another language to release files for windows/bsd/linux/mac
