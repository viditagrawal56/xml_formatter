#!/bin/bash

export XMLLINT_INDENT="    "
fix_files=false

# function to define the usage of the script.
usage() {
    echo "Usage: $0 [-f] path1 [path2 ... pathN]"
    echo "  -f    Fix the XML files instead of just showing differences"
    echo "  -i indent Set the XML indentation (e.g., '    ' for 4 spaces or $'\t' for a tab)"
    exit 1
}

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
            # If the file is an XML file, run the diff command or fix the file
            echo "Processing file: $file"
            if [ "$fix_files" = true ]; then
                XMLLINT_INDENT="$XMLLINT_INDENT" xmllint --format "$file" --output "$file"
                echo "Fixed formatting for file: $file"
            else
                diff -B --tabsize=4 "$file" <(XMLLINT_INDENT="$XMLLINT_INDENT" xmllint --format "$file")
            fi
        else
            echo "Skipping non-XML file: $file"
        fi
    done
}

# Parse command line options
while getopts ":fi:" opt; do
    case $opt in
        f)
            fix_files=true
            ;;
        i)
            XMLLINT_INDENT="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if at least one path is provided
if [ $# -eq 0 ]; then
    usage
fi

# Loop through all the provided paths
for path in "$@"; do
    process_xml_files "$path"
done
