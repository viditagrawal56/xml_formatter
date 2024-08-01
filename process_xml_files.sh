#!/bin/bash

# Only execute if this script is called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script should not be run directly. Please run xml_formatter.sh instead."
    exit 1
fi

process_xml_file() {
    local file="$1"
    local fix_files="$2"
    local XMLLINT_INDENT="$3"
    
    echo "Processing file: $file"
    if [ "$fix_files" = true ]; then
        format_xml_file "$file" "$XMLLINT_INDENT"
    else
        show_xml_diff "$file" "$XMLLINT_INDENT"
    fi
}

process_xml_files_in_directory() {
    local dir="$1"
    local fix_files="$2"
    local XMLLINT_INDENT="$3"
    
    echo "Processing directory: $dir"
    
    if [ ! -d "$dir" ]; then
        echo "Error: Directory $dir does not exist."
        return 1
    fi
    
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            process_xml_files_in_directory "$file" "$fix_files" "$XMLLINT_INDENT"
            elif [[ "$file" == *.xml ]]; then
            process_xml_file "$file" "$fix_files" "$XMLLINT_INDENT"
        else
            echo "Skipping non-XML file: $file"
        fi
    done
}

format_xml_file() {
    local file="$1"
    local XMLLINT_INDENT="$2"
    
    if ! XMLLINT_INDENT="$XMLLINT_INDENT" xmllint --format "$file" --output "$file"; then
        echo "Error: Failed to format $file"
        return 1
    fi
    echo "Fixed formatting for file: $file"
}

show_xml_diff() {
    local file="$1"
    local XMLLINT_INDENT="$2"
    
    if ! diff -B --tabsize=4 "$file" <(XMLLINT_INDENT="$XMLLINT_INDENT" xmllint --format "$file"); then
        echo "Error: Failed to diff $file"
        return 1
    fi
}