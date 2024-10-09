%.words: %
	< $< tr -d '[:punct:]' | tr '\n\r' ' ' | tr -s '[:space:]' | tr '[:space:]' '\n' > $@

%.sorted: %
	< $< sort > $@

%.sorted.unique: %.sorted
	< $< uniq > $@

%.lowercase: %
	< $< tr '[:upper:]' '[:lower:]' > $@

%.sorted.unique.count: %.sorted
	< $< uniq -c > $@

%.descending-numeric-sorted: %
	< $< sort -n -r > $@
