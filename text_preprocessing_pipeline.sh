#!/bin/bash

# Input file
# input_file="input.txt"
# output_file="cleaned_text.txt"

input_file="$1"
output_file="$2"

# Replacing date formats with "date"
sed -E -e 's/\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b/date/g' \
       -e 's!\b[0-9]{2}/[0-9]{2}/[0-9]{4}\b!date!g' \
       -e 's/\b[0-9]{2}-[0-9]{2}-[0-9]{4}\b/date/g' "$input_file" |

# Replacing currency formats with "money"
sed -E -e 's/\$[0-9]+(,[0-9]{3})*(\.[0-9]{2})?/money/g' |

# Replacing digits with "numbers"
sed -E 's/[0-9]+/numbers/g' |

# Removing punctuation
tr -d '[:punct:]' |

# Removing multiple spaces
awk '{$1=$1};1' |

# Converting to lowercase
tr '[:upper:]' '[:lower:]' > "$output_file"

echo "Data has been cleaned and saved to '$output_file'"