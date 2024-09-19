#!/bin/bash

# Function to display usage message
usage() {
    echo "Usage: $0 <input_csv> <output_csv> <conda_env>"
    echo "  <input_csv>  - Path to the input CSV file"
    echo "  <output_csv> - Path to the output CSV file"
    echo "  <conda_env>  - Name of the Conda environment"
    exit 1
}

# Check for required arguments
if [ $# -ne 3 ]; then
    usage
fi

# Extract arguments
INPUT_CSV="$1"
OUTPUT_CSV="$2"
CONDA_ENV="$3"

# Validate input CSV file
if [ ! -f "$INPUT_CSV" ]; then
    echo "Error: Input CSV file '$INPUT_CSV' not found."
    exit 1
fi

# Activate the Conda environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$CONDA_ENV"

# Process the CSV: strip quotes, convert to lowercase, trim whitespace, convert #\d{2,} to invoice, remove multiple spaces, and save to output CSV
sed 's/"//g' "$INPUT_CSV" | 
sed -E 's/#([0-9]{2,})/invoice/g' | 
awk 'BEGIN {FS=OFS = ","} (NR>1){gsub(/[ \t]+/," ", $1); print tolower($1)}' | 
awk 'BEGIN {FS=OFS = ","} (NR>1){gsub(/^[ \t]+|[ \t]+$/, "", $1);  print}' > "$OUTPUT_CSV"

# Pipe the output to the Python script that counts the lines with quotes
cat "$OUTPUT_CSV" | python3 count_lines_with_quotes.py

# Deactivate the Conda environment
conda deactivate
