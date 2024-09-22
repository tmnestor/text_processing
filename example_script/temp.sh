#!/bin/bash

# Create a temporary directory
temp_dir=$(mktemp -d)

echo "Temporary directory created: $temp_dir"

# Store files inside the temporary directory
echo "This is file1" > "$temp_dir/file1.txt"
echo "This is file2" > "$temp_dir/file2.txt"

echo "Files stored in the temporary directory"

# Read files from the temporary directory
for file in "$temp_dir"/*; do
    echo "Reading $file"
    cat "$file"
done

# Clean up the temporary directory
rm -r "$temp_dir"
echo "Temporary directory removed"