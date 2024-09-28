"""
text_preprocessor.py

A module for text preprocessing based on user-defined configurations loaded from a YAML file.

This module includes a TextPreprocessor class that supports various text cleaning operations:
    - Converting text to lowercase
    - Removing punctuation
    - Removing numbers
    - Removing stopwords
    - Custom text replacements

Configuration for the text processing is provided via a 'config.yaml' file.

Example usage:
    Run this script directly to clean a sample text based on the provided configuration.
"""

import re
import string
from typing import List, Dict, Any
import yaml


class TextPreprocessor:
    """
    A class to preprocess text based on a configuration.

    Attributes:
        to_lowercase (bool): If true, convert text to lowercase.
        remove_punctuation (bool): If true, remove punctuation from text.
        remove_numbers (bool): If true, remove numbers from text.
        remove_stopwords (bool): If true, remove common stopwords from text.
        stopwords (set): A set of custom stopwords to remove.
        custom_replacements (List[Dict[str, str]]): A list of custom replacement rules.
    """

    def __init__(self, config: Dict[str, Any]):
        """
        Initializes the TextPreprocessor with a configuration.

        Args:
            config (Dict[str, Any]): Configuration dictionary.
        """
        self.to_lowercase: bool = config.get('to_lowercase', True)
        self.remove_punctuation: bool = config.get('remove_punctuation', True)
        self.remove_numbers: bool = config.get('remove_numbers', False)
        self.remove_stopwords: bool = config.get('remove_stopwords', False)
        self.stopwords: set = set(config.get('stopwords', []))
        self.custom_replacements: List[Dict[str, str]] = config.get('custom_replacements', [])

    def clean(self, text: str) -> str:
        """
        Cleans the input text based on the configured options.

        Args:
            text (str): The text to clean.

        Returns:
            str: The cleaned text.
        """
        if self.to_lowercase:
            text = text.lower()
        if self.remove_punctuation:
            text = re.sub(f"[{re.escape(string.punctuation)}]", "", text)
        if self.remove_numbers:
            text = re.sub(r"\d+", "", text)
        if self.remove_stopwords:
            text = " ".join([word for word in text.split() if word not in self.stopwords])
        for replacement in self.custom_replacements:
            pattern: str = replacement['pattern']
            repl: str = replacement['replacement']
            text = re.sub(pattern, repl, text)
        return text

def main():
    """
    Main function to read configuration from YAML, create the TextPreprocessor, 
    and clean a sample text.
    """
    # Read configuration from YAML file
    with open('config.yaml', 'r') as file:
        config: Dict[str, Any] = yaml.safe_load(file)

    # Create the preprocessor object using the configuration from the YAML file
    preprocessor: TextPreprocessor = TextPreprocessor(config['text_preprocessor'])

    # Sample text to clean
    text: str = "Today is the 2024-09-28, and the foo event is taking place in the venue."

    # Clean the text using the preprocessor
    cleaned_text: str = preprocessor.clean(text)

    # Print the cleaned text
    print(cleaned_text)  # Example Output: "today [DATE] foo event taking place venue"

if __name__ == "__main__":
    main()