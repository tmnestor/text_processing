#!/usr/bin/gawk -f

function tolowercase(str) {
    return tolower(str)
}

function trim(str) {
    sub(/^[ \t]+/, "", str)
    sub(/[ \t]+$/, "", str)
    return str
}

function cleanline(line) {
    if (line == "") {
        return ""
    }
    gsub(/[ \t]+/, " ", line)
    line = trim(line)
    line = tolowercase(line)
    return line
}

{
    print cleanline($0)
}
