# Random File Selector

This simple collection of bash script should ease up solving the task to randomly chose some files and copy them somewhere.

A real world scenario and the reason to code this is to fill up an usb stick with randomly selected mp3 files until it is full.

# Core Features

* creates a file list of your media files as a "cache" to speed things up
* copies random files from the list to a destination (like a mounted usb disk)

# Future Improvements

* Create a changelog.md
* Put both scripts into one script
* Run the copy script until the device is full or an fixed amout of files are copied (use output of df -i?)
* Extend the "create_file_list.sh" script with following optional arguments
    * -d|--dry-run
    * -f|--filter-by-extension
    * -g|--guided
    * -h|--help
    * -p|--output-file-path
* Extend the "copy_random_files_from_list.sh" script with the following optional arguments
    * -d|--dry-run
    * -f|--maximum-amount-of-files
    * -g|--guided
    * -h|--help
    * -p|--destination-path
    * -s|--diskspace-left
* Rewrite in another language to release fils for windows/bsd/linux/mac
