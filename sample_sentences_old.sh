#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error
set -o pipefail  # Return the exit status of the last command in the pipeline that failed

# Function to display the usage message
usage() {
    echo "Usage: $0 <num> <input_dir> <input_file>"
    echo "  <num>        - Number of samples per category"
    echo "  <input_dir>  - Directory containing the input file"
    echo "  <input_file> - Name of the input CSV file"
    echo
    echo "Example:"
    echo "  $0 3 /path/to/input_dir sentences.csv"
    exit 1
}

# Check for required arguments
if [ $# -lt 3 ]; then
    usage
fi

# Number of samples per category
num=$1

# Input directory and file
input_dir=$2
input_file=$3

# Full path to input file
input_path="$input_dir/$input_file"

# Create or clear the output CSV file with column headers or leave it if not needed
echo "Sentence,Category" > "$input_dir/sampled_sentences.csv"

# Use appropriate shuffle command depending on OS
if command -v shuf > /dev/null; then
    SHUF_CMD=shuf
elif command -v gshuf > /dev/null; then
    SHUF_CMD=gshuf
else
    echo "Error: shuf command not found. Please install coreutils."
    exit 1
fi

# Step 1: Process each line of the input CSV file and split by category
awk -F, -v output_dir="$input_dir" '
BEGIN {
    # Initialize arrays for categories and tracking files
}
{
    category = $2;
    sentence = $1;
    filename = output_dir "/" category ".csv";

    # Append sentence to the specific category file using printf
    printf "\"%s\",\"%s\"\n", sentence, category > filename

    # Append the filename to the array to keep track of categories
    if (!(category in categories)) {
        categories[category] = filename
        files[filename]
    }
}
END {
    # Output the filenames of all category files
    for (filename in files) {
        print filename > (output_dir "/category_files.txt")
    }
}
' "$input_path"

# Step 2: Read the category files and shuffle them for sampling
while read -r CATEGORY_FILE; do
    CATEGORY=$(basename "$CATEGORY_FILE" ".csv")

    # Step 3: Shuffle and get a random sample of `num` sentences
    "$SHUF_CMD" -n "$num" "$CATEGORY_FILE" | while read -r LINE; do
        # Append the sampled sentence to the output CSV file
        echo "$LINE" >> "$input_dir/sampled_sentences.csv"
    done
done < "$input_dir/category_files.txt"

# Remove the temporary category files list
rm "$input_dir/category_files.txt"

# Confirmation message
echo "Sampled sentences have been written to $input_dir/sampled_sentences.csv"