import yaml
import pytest
from text_preprocessor import TextPreprocessor

@pytest.fixture
def config():
    return {
        "to_lowercase": True,
        "remove_punctuation": True,
        "remove_numbers": False,
        "remove_stopwords": False,
        "stopwords": [],
        "custom_replacements": [
            {"pattern": "\\d{4}-\\d{2}-\\d{2}", "replacement": "[DATE]"},
            {"pattern": "foo", "replacement": "[EVENT]"}
        ]
    }

@pytest.fixture
def preprocessor(config):
    return TextPreprocessor(config)

def test_to_lowercase(preprocessor):
    text = "HELLO WORLD"
    assert preprocessor.clean(text) == "hello world"

def test_remove_punctuation(preprocessor):
    text = "Hello, world!"
    assert preprocessor.clean(text) == "hello world"

def test_custom_replacements(preprocessor):
    text = "Today is the 2024-09-28, and the foo event is taking place."
    assert preprocessor.clean(text) == "today [DATE] and the [EVENT] event is taking place"

def test_remove_stopwords(preprocessor):
    preprocessor.remove_stopwords = True
    preprocessor.stopwords = {"is", "the", "and"}
    text = "Today is the day, and the sun is shining."
    assert preprocessor.clean(text) == "today day sun shining"

def test_invalid_input(preprocessor):
    assert preprocessor.clean(None) == ""
    assert preprocessor.clean(12345) == ""