import sys

def process_line(line):
    # Process the line (Modify this function as needed)
    return line.upper()

def main():
    for line in (line for line in sys.stdin):
        processed_line = process_line(line)
        sys.stdout.write(processed_line)

if __name__ == "__main__":
    main()
