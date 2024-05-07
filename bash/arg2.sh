echo "Script that parse argument with getops "

# Initialize variables with default values
input_file=""
output_file=""
verbose=0

# Function to display help
usage() {
    echo "Usage: $0 [-v] [-i filename] [-o filename]"
    exit 1
}

# Parse options
while getopts "i:o:v" opt; do
  case $opt in
    i)
      input_file="$OPTARG"
      ;;
    o)
      output_file="$OPTARG"
      ;;
    v)
      verbose=1
      ;;
    *)
      usage
      ;;
  esac
done

# Validate required options
if [[ -z $input_file ]]; then
  echo "Input file is required"
  usage
fi

# Print parsed options
echo "Input file: $input_file"
echo "Output file: $output_file"
echo "Verbose mode: $verbose"
