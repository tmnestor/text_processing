BEGIN {
    FS = ",";
    OFS = ",";
}

NR == 1 {
    print $0;
    next;
}

{
    data[$2] = (data[$2] ? data[$2] RS : "") $0;
}

END {
    for (label in data) {
        print data[label];
    }
}