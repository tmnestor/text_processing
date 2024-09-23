#!/bin/sh

# Default values
input_csv=""
preprocessed_csv=""
log_file=""

# Predefined values
DEFAULT_INPUT=""
DEFAULT_PREPROCESSED=""
DEFAULT_LOG=""

usage() {
    cat << EOF
Usage: $0 [OPTIONS]
Options:
  --input input_csv          Specify the input CSV file (default: $DEFAULT_INPUT)
  --preprocessed preprocessed_csv
                             Specify the preprocessed CSV file (default: $DEFAULT_PREPROCESSED)
  --log log                  Specify the log file (default: $DEFAULT_LOG)
  --help                     Display this help message and exit

Example:
  $0 --input data.csv --preprocessed preprocessed.csv --log process.log

This script preprocesses a CSV file with the given options, logs the output, and tees feedback to screen and log file.
EOF
}

# Function to tee feedback to screen and to log file
tee_feedback() {
    # Tee feedback to both stdout and the log file
    echo "$1" | tee -a "$log_file"
}

# Argument parsing
while [ "$#" -gt 0 ]; do
    case "$1" in
        --input)
            input_csv="$2"
            shift 2
            ;;
        --preprocessed)
            preprocessed_csv="$2"
            shift 2
            ;;
        --log)
            log_file="$2"
            shift 2
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Use default values if variables are empty
input_csv="${input_csv:-$DEFAULT_INPUT}"
preprocessed_csv="${preprocessed_csv:-$DEFAULT_PREPROCESSED}"
log_file="${log_file:-$DEFAULT_LOG}"

if [ -z "$input_csv" ] || [ -z "$preprocessed_csv" ] || [ -z "$log_file" ]; then
    echo "Error: Missing required arguments."
    usage
    exit 1
fi

# Your script logic here, for example:
tee_feedback "Processing input CSV: $input_csv"
tee_feedback "Saving preprocessed CSV: $preprocessed_csv"
tee_feedback "Logging to file: $log_file"

# Example processing
cp "$input_csv" "$preprocessed_csv" && tee_feedback "File processing completed successfully!"

exit 0