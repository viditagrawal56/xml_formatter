#!/bin/bash

# Only execute if this script is called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script should not be run directly. Please run xml_formatter.sh instead."
    exit 1
fi

parse_options() {
    local fix_files=false
    local XMLLINT_INDENT="    "
    local paths=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f)
                fix_files=true
                shift
            ;;
            -i)
                XMLLINT_INDENT="$2"
                shift 2
            ;;
            # if an invalid option is provided
            -*)
                echo "Error: Unknown option $1" >&2
                exit 1
            ;;
            *)
                paths+=("$1")
                shift
            ;;
        esac
    done
    
    # Return the options and remaining arguments
    echo "$fix_files|$XMLLINT_INDENT|${paths[*]}"
}

export fix_files XMLLINT_INDENT
