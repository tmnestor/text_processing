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

# Step 1 & Step 2: Process each line of the input CSV file, split by category, shuffle, and sample
awk -F, -v num="$num" -v output_file="$input_dir/sampled_sentences.csv" '
{
    category = $2;
    sentence = $1;
    key = category;

    # Store sentences based on their category
    sentences[key][count[key]] = sentence;
    count[key]++;
}
END {
    srand()  # Initialize the random number generator
    for (key in sentences) {
        # Shuffle the sentences
        n = count[key];
        for (i = 0; i < n; i++) {
            j = int((n - i) * rand()) + i;
            tmp = sentences[key][i];
            sentences[key][i] = sentences[key][j];
            sentences[key][j] = tmp;
        }

        # Output a sample of sentences up to num per category
        for (i = 0; i < (num < n ? num : n); i++) {
            printf "\"%s\",\"%s\"\n", sentences[key][i], key >> output_file;
        }
    }
}
' "$input_path"

# Confirmation message
echo "Sampled sentences have been written to $input_dir/sampled_sentences.csv"