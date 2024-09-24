# Makefile

# Default values for extract stage
EXTRACT_INPUT_URL?=http://example.com/data.csv
EXTRACTED_FILE?=extracted.csv
EXTRACT_LOG_FILE?=extract.log

# Default values for preprocess stage
PREPROCESS_INPUT_FILE?=$(EXTRACTED_FILE)
PREPROCESSED_FILE?=preprocessed.csv
PREPROCESS_LOG_FILE?=preprocess.log

# Default values for categorise stage
CATEGORISE_INPUT_FILE?=$(PREPROCESSED_FILE)
CATEGORISED_FILE?=categorised.csv
CATEGORISE_LOG_FILE?=categorise.log

all: extract preprocess categorise

extract:
    @echo "Extract stage running..."
    @echo "EXTRACT_INPUT_URL: $(EXTRACT_INPUT_URL)"
    @echo "EXTRACTED_FILE: $(EXTRACTED_FILE)"
    @echo "EXTRACT_LOG_FILE: $(EXTRACT_LOG_FILE)"
    @./extract.sh "$(EXTRACT_INPUT_URL)" "$(EXTRACTED_FILE)" "$(EXTRACT_LOG_FILE)"

preprocess: extract
    @echo "Preprocess stage running..."
    @echo "PREPROCESS_INPUT_FILE: $(PREPROCESS_INPUT_FILE)"
    @echo "PREPROCESSED_FILE: $(PREPROCESSED_FILE)"
    @echo "PREPROCESS_LOG_FILE: $(PREPROCESS_LOG_FILE)"
    @./preprocess.sh "$(PREPROCESS_INPUT_FILE)" "$(PREPROCESSED_FILE)" "$(PREPROCESS_LOG_FILE)"

categorise: preprocess
    @echo "Categorise stage running..."
    @echo "CATEGORISE_INPUT_FILE: $(CATEGORISE_INPUT_FILE)"
    @echo "CATEGORISED_FILE: $(CATEGORISED_FILE)"
    @echo "CATEGORISE_LOG_FILE: $(CATEGORISE_LOG_FILE)"
    @./categorise.sh "$(CATEGORISE_INPUT_FILE)" "$(CATEGORISED_FILE)" "$(CATEGORISE_LOG_FILE)"

.PHONY: all extract preprocess categorise