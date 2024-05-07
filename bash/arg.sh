#!/bin/bash
echo "Script that mix positional and optional argument"
echo

# Initialize variables for options
verbose=0
filename=""

# Function to display help
usage() {
    echo "Usage: $0 [-v] [-f filename] -- [positional arguments]"
    echo "  -v, --verbose        Enable verbose mode"
    echo "  -f, --file FILENAME  Specify a file name"
    exit 1
}

# Parse options
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
    case $1 in
        -v | --verbose)
            verbose=1
            ;;
        -f | --file)
            shift; filename=$1
            ;;
        -h | --help)
            usage
            ;;
        *)
            echo "Error: Invalid option $1"
            usage
            ;;
    esac
    shift
done


# Remaining arguments are treated as positional
echo "Verbose mode is $verbose"
echo "Filename is $filename"
echo "Positional arguments:"

for arg in "$@"; do
    echo "  - $arg"
done
