import yaml
import re
import pandas as pd
from typing import List, Dict, Tuple, Pattern, Any, Callable

def read_yaml_patterns(file_path: str) -> List[Dict[str, Tuple[Pattern[str], Pattern[str] | None]]]:
    """
    Read and parse the YAML file containing search patterns.

    Args:
    file_path (str): Path to the YAML file.

    Returns:
    List[Dict[str, Tuple[Pattern[str], Pattern[str] | None]]]: List of dictionaries with compiled patterns.
    """
    with open(file_path, 'r') as file:
        yaml_data = yaml.safe_load(file)

    patterns: List[Dict[str, Tuple[Pattern[str], Pattern[str] | None]]] = []
    for item in yaml_data:
        name = list(item.keys())[0]
        rules = item[name]

        # Compile inclusion patterns
        inclusion_pattern: Pattern[str] = re.compile('|'.join(rules['include']), re.IGNORECASE)

        # Compile exclusion patterns (if any)
        exclusion_pattern: Pattern[str] | None = (
            re.compile('|'.join(rules['exclude']), re.IGNORECASE) if 'exclude' in rules else None
        )

        patterns.append({name: (inclusion_pattern, exclusion_pattern)})

    return patterns

def read_preprocessing_patterns(file_path: str) -> Dict[str, Pattern[str]]:
    """
    Read and compile preprocessing patterns from a YAML file.

    Args:
    file_path (str): Path to the YAML file.

    Returns:
    Dict[str, Pattern[str]]: Dictionary of compiled preprocessing patterns.
    """
    with open(file_path, 'r') as file:
        yaml_data = yaml.safe_load(file)

    return {key: re.compile(pattern) for key, pattern in yaml_data.items()}

def preprocess_text(patterns: Dict[str, Pattern[str]]) -> Callable[[str], str]:
    """
    Create a preprocessing function using the provided patterns.

    Args:
    patterns (Dict[str, Pattern[str]]): Dictionary of compiled preprocessing patterns.

    Returns:
    Callable[[str], str]: A function that preprocesses text according to the patterns.
    """
    def wrapper(text: str) -> str:
        # Convert to lowercase
        text = text.lower()

        # Apply non-alpha pattern
        text = patterns['non_alpha'].sub(' ', text)

        # Remove multiple whitespaces
        text = patterns['multiple_spaces'].sub(' ', text)

        # Strip leading and trailing whitespace
        return text.strip()

    return wrapper

def apply_patterns(patterns: List[Dict[str, Tuple[Pattern[str], Pattern[str] | None]]]) -> Callable[[str], str]:
    """
    Create a function to apply patterns to text.

    Args:
    patterns (List[Dict[str, Tuple[Pattern[str], Pattern[str] | None]]]): List of compiled patterns.

    Returns:
    Callable[[str], str]: A function that applies patterns to text and returns the match.
    """
    def wrapper(sentence: str) -> str:
        for pattern_dict in patterns:
            name = list(pattern_dict.keys())[0]
            inclusion_pattern, exclusion_pattern = pattern_dict[name]

            if inclusion_pattern.search(sentence):
                if exclusion_pattern is None or not exclusion_pattern.search(sentence):
                    return name
        return sentence

    return wrapper

def calculate_display_value_counts(df: pd.DataFrame, column: str, normalize: bool = False, sort: bool = True) -> Dict[Any, Any]:
    """
    Calculate and display value counts for a specified column in a DataFrame.

    Args:
    df (pd.DataFrame): The input DataFrame.
    column (str): The name of the column to calculate value counts for.
    normalize (bool, optional): If True, returns proportions instead of counts. Defaults to False.
    sort (bool, optional): If True, sort the results by counts in descending order. Defaults to True.

    Returns:
    Dict[Any, Any]: A dictionary containing the value counts or proportions.

    Raises:
    KeyError: If the specified column does not exist in the DataFrame.

    Example:
    >>> df = pd.DataFrame({'category': ['A', 'B', 'A', 'C', 'B', 'A']})
    >>> result = calculate_display_value_counts(df, 'category')
    Value counts for column 'category':
    A    3
    B    2
    C    1
    Name: category, dtype: int64
    >>> print(result)
    {'A': 3, 'B': 2, 'C': 1}
    """
    try:
        # Calculate value counts
        value_counts = df[column].value_counts(normalize=normalize, sort=sort)

        # Display the results
        print(f"Value counts for column '{column}':")
        print(value_counts)

        # Return the results as a dictionary
        return value_counts.to_dict()

    except KeyError:
        print(f"Error: Column '{column}' not found in the DataFrame.")
        return {}

# Example usage
if __name__ == "__main__":
    # Read preprocessing patterns
    preprocess_yaml_path = "preprocessing_patterns.yaml"
    preprocess_patterns = read_preprocessing_patterns(preprocess_yaml_path)

    # Read search patterns
    search_yaml_path = "search_patterns.yaml"
    compiled_patterns = read_yaml_patterns(search_yaml_path)

    # Create preprocessing function
    preprocess_fn = preprocess_text(preprocess_patterns)

    # Create pattern application function
    apply_fn = apply_patterns(compiled_patterns)

    # Create a sample DataFrame with more examples
    data: Dict[str, List[str]] = {
        'sentences': [
            "The quick brown fox jumps over the lazy dog.",
            "A journey of a thousand miles begins with a single step.",
            "To be, or not to be: that is the question.",
            "All that glitters is not gold.",
            "It's raining cats and dogs outside!",
            "The latest advancements in artificial intelligence are impressive.",
            "I found a delicious recipe for homemade pizza.",
            "The football championship was intense this year.",
            "The melody of that song is stuck in my head.",
            "Students at the university are preparing for final exams.",
            "We went hiking in a beautiful forest last weekend.",
            "The government announced a new policy on climate change.",
            "According to the survey, 75% of people prefer coffee over tea.",
            "This sentence doesn't match any specific category.",
            "Wherefore art thou Romeo? Another famous Shakespeare quote.",
            "The non-technical aspects of computer science are often overlooked.",
            "I'm feeling under the weather, but it's not raining.",
            "The 21st century has seen rapid technological advancements.",
            "Actions speak louder than words, especially in politics.",
            "The restaurant's signature dish combines various cuisines.",
            "Olympic athletes train rigorously for years.",
            "The concert was silent due to technical difficulties.",
            "Life lessons are different from formal education.",
            "The wildlife in the mountain ranges is diverse.",
            "Office politics can be as complex as national elections.",
            "There are no numbers in this sentence.",
            "",  # Empty string to test miscellaneous category
        ]
    }
    df = pd.DataFrame(data)

    # Preprocess the sentences
    df['preprocessed'] = df['sentences'].apply(preprocess_fn)

    # Apply patterns to the preprocessed DataFrame
    result_df = df.copy()
    result_df['preprocessed'] = result_df['preprocessed'].apply(apply_fn)

    print("\nDetailed results:")
    print(result_df[['sentences', 'preprocessed']])

    # Calculate and display value counts for the 'preprocessed' column
    category_proportions = calculate_display_value_counts(result_df, 'preprocessed', normalize=True)