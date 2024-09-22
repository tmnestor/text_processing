#!/bin/sh

# Default values for arguments
ARG1="default_value1"
ARG2="default_value2"

# Function to display help/usage message
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <input_file> <output_file>

Options:
  --arg1 <value>   Description for argument 1 (default: default_value1)
  --arg2 <value>   Description for argument 2 (default: default_value2)
  -h, --help       Display this help message

Example:
  $0 --arg1 value1 --arg2 value2 input.txt output.txt
EOF
    exit 1
}

# Parse command-line arguments
INPUT_FILE=""
OUTPUT_FILE=""

while [ "$#" -gt 0 ]; do
    case $1 in
        --arg1)
            if [ -n "$2" ]; then
                ARG1="$2"
                shift 2
            else
                echo "Error: --arg1 requires a value"
                usage
            fi
            ;;
        --arg2)
            if [ -n "$2" ]; then
                ARG2="$2"
                shift 2
            else
                echo "Error: --arg2 requires a value"
                usage
            fi
            ;;
        -h | --help)
            usage
            ;;
        *)
            if [ -z "$INPUT_FILE" ]; then
                INPUT_FILE="$1"
            elif [ -z "$OUTPUT_FILE" ]; then
                OUTPUT_FILE="$1"
            else
                echo "Unknown option: $1"
                usage
            fi
            shift
            ;;
    esac
done

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Error: input file and output file must be provided."
    usage
fi

# Pass values to the Python script
python3 script.py < "$INPUT_FILE" > "$OUTPUT_FILE"
