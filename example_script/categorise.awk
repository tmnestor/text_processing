BEGIN {
    FS = ","  # Set the field separator to comma
}

# Read the header line
NR == 1 {
    next
}

{
    categories[$2] = categories[$2] ? categories[$2] "," $1 : $1
}

END {
    for (category in categories) {
        split(categories[category], claims, ",")
        for (i in claims) {
            print category ": " claims[i]
        }
    }
}