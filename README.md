The text_processor.py file contains several functions for text processing and pattern matching. 

Here's a summary of the key components:

 1. read_yaml_patterns(): Reads and compiles search patterns from a YAML file.

 2. read_preprocessing_patterns(): Reads and compiles preprocessing patterns from a YAML file.

 3. preprocess_text(): Applies preprocessing steps to input text, including lowercase conversion, non-alpha character removal, and whitespace normalization.

 4. apply_patterns(): Applies compiled patterns to a pandas DataFrame column, matching sentences to categories.

 5. calculate_display_value_counts(): Calculates and displays value counts for a specified column in a DataFrame.

The script also includes an example usage section that demonstrates how to use these functions:

 - It reads preprocessing and search patterns from YAML files.
 - reates a sample DataFrame with sentences.
 - Preprocesses the sentences using the preprocess_text() function.
 - Applies patterns to categorize the preprocessed sentences using apply_patterns().
 - Displays the results, including original and preprocessed sentences.
 - Calculates and displays category proportions using calculate_display_value_counts().
 
 This text processing pipeline allows for flexible pattern matching and categorization of text data, with the ability to easily modify patterns through external YAML files.