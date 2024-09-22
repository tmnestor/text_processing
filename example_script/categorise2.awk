BEGIN {
    OFS = ",";
    print "claims,categories";
}
NR > 1 {
    claims[$2] = claims[$2] $0 "\n";
}
END {
    for (category in claims) {
        printf "%s", claims[category];
    }
}