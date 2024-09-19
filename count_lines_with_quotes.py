import sys

def count_lines_with_quotes():
    count = 0
    for line in sys.stdin:
        if '"' in line:
            count += 1
    print(count)

if __name__ == "__main__":
    count_lines_with_quotes()
