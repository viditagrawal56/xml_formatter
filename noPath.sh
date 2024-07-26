#!/bin/bash

ROOT_DIR="./WordPress/Docs"

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

process_xml_files "$ROOT_DIR"
