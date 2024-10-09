import sys
import pyarrow.parquet as pq

if len(sys.argv) != 2:
    print("Usage: python read_parquet.py <path_to_parquet_file>")
    sys.exit(1)

parquet_file = sys.argv[1]

# Read the Parquet file
try:
    table = pq.read_table(parquet_file)
    for row in table.to_pandas().itertuples(index=False):
        print(row)
except Exception as e:
    print(f"Error reading {parquet_file}: {e}")
    sys.exit(1)