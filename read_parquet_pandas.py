import sys
import pandas as pd

if len(sys.argv) != 2:
    print("Usage: python read_parquet.py <path_to_parquet_file>")
    sys.exit(1)

parquet_file = sys.argv[1]

# Read the Parquet file using pandas
try:
    df = pd.read_parquet(parquet_file)
    rows = (row for row in df.itertuples(index=False))  # Generator expression for rows

    header_skipped = False  # Flag to indicate whether header has been skipped
    for row in rows:
        if not header_skipped:
            header_skipped = True
            continue  # Skip the first row, which is the header
        print(row)
except Exception as e:
    print(f"Error reading {parquet_file}: {e}")
    sys.exit(1)