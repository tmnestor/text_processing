#!/usr/bin/gawk -f

BEGIN {
    today=ENVIRON["my_var"]
    all_digits = "^[0-9]+$"  # Pattern to include
    all_alpha = "^[a-z]+$"   # Pattern to exclude
}

{
    if ($0 ~ all_digits || $0 ~ all_alpha) {
        print "Matched:", $0
    } else {
        print "Did not match:", $0
    }
}
END {print today}

# export my_var=$(date +"%T") && awk -f regex_example.awk <input_file.txt