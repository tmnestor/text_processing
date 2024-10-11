import pyarrow.parquet as pq

def read_parquet_in_chunks(file_path, chunk_size=1000):
    table = pq.read_table(file_path, columns=['claims'])
    num_rows = table.num_rows
    for start in range(0, num_rows, chunk_size):
        end = min(start + chunk_size, num_rows)
        yield table.slice(start, end)

if __name__ == "__main__":
    import sys
    file_path = sys.argv[1]  # Pass the file path as the first argument
    for chunk in read_parquet_in_chunks(file_path):
        claims_column = chunk['claims'].to_pandas()
        for claim in claims_column:
            print(claim)  # Print each claim on a new line