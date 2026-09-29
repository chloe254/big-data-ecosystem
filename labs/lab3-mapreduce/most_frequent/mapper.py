import sys


def write_kv_array(kv_array):
    for kv in kv_array:
        print(f'{kv["key"]}\t{kv["value"]}')


def read_word_count_lines(text):
    key_values = []

    for line in text:
        line = line.strip()
        if not line:
            continue

        parts = line.split('\t')
        if len(parts) != 2:
            continue

        word, count_str = parts[0], parts[1]
        try:
            count = int(count_str)
        except ValueError:
            continue

        key_values.append({'key': 'MAX', 'value': f'{count}\t{word}'})

    return key_values


if __name__ == '__main__':
    write_kv_array(read_word_count_lines(sys.stdin))
