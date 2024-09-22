input_file="sorted_input.csv"
output_file="sampled_output.csv"
num=3  # Set the number of records to sample for each unique value, adjust as needed

# Extract and write the header to the output file
header=$(head -n 1 "$input_file")
echo "$header" > "$output_file"

# Use awk and shuf to sample records
awk -F, 'NR>1 {print > $2".csv"}' "$input_file"

for file in *.csv; do
    if [[ "$file" != "$input_file" ]]; then
        # Sample records and append to output file
        tail -n +1 "$file" | shuf -n "$num" >> "$output_file"
        rm "$file"
    fi
done