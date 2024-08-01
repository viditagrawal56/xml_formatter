#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/parse_options.sh"
source "$DIR/check_os.sh"
source "$DIR/process_xml_files.sh"
source "$DIR/check_commands.sh"

usage() {
    cat <<EOF
Usage: xml_formatter.sh [OPTIONS] path1 [path2 ... pathN]

Options:
  -f          Fix the XML files instead of just showing differences
  -i    Set the XML indentation (e.g., '    ' for 4 spaces or $'\t' for a tab)
  -h, --help  Show this help message and exit
EOF
}

main() {
    if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        usage
        exit 0
    fi
    
    check_os
    
    check_commands xmllint diff
    
    local options_output
    if ! options_output=$(parse_options "$@"); then
        echo ""
        usage
        exit 1
    fi
    
    # Extract values from options_output
    local fix_files
    local XMLLINT_INDENT
    local paths
    
    fix_files=$(echo "$options_output" | cut -d'|' -f1)
    XMLLINT_INDENT=$(echo "$options_output" | cut -d'|' -f2)
    paths=$(echo "$options_output" | cut -d'|' -f3-)
    
    # If no paths are provided after parsing options, show usage
    if [ -z "$paths" ]; then
        usage
        exit 0
    fi
    
    for path in $paths; do
        if [ -f "$path" ]; then
            if [[ "$path" == *.xml ]]; then
                process_xml_file "$path" "$fix_files" "$XMLLINT_INDENT"
            else
                echo "Skipping non-XML file: $path"
            fi
            elif [ -d "$path" ]; then
            process_xml_files_in_directory "$path" "$fix_files" "$XMLLINT_INDENT"
        else
            echo "Error: $path is not a valid file or directory."
        fi
    done
}

main "$@"