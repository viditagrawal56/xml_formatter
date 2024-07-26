#!/bin/bash

export XMLLINT_INDENT="    "

process_xml_files() {
    local dir="$1"

    echo "Processing directory: $dir"

    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        return
    fi

    # Loop through each file in the directory
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # If the file is a directory, then recurse into it
            process_xml_files "$file"
        elif [[ "$file" == *.xml ]]; then
            # If the file is an XML file, run the diff command
            echo "Processing file: $file"
            diff -B --tabsize=4 "$file" <(xmllint --format "$file")
        else
            echo "Skipping non-XML file: $file"
        fi
    done
}

# Check if at least one argument is passed
if [ $# -eq 0 ]; then
    echo "Please provide path(s) to the directory"
    echo "Usage: $0 path1 [path2 ... pathN]"
    exit 1
fi

# Loop through all the arguments (paths)
for path in "$@"; do
    process_xml_files "$path"
done
