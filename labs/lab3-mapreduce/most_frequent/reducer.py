import sys


def read_kv_array(text):
    key_values = []

    for line in text:
        line = line.strip()
        if not line:
            continue

        parts = line.split('\t', 1)
        if len(parts) != 2:
            continue

        key, value = parts[0], parts[1]
        key_values.append({'key': key, 'value': value})

    return key_values


def write_result(word, count):
    print(f'{word}\t{count}')


def most_frequent(kv_array):
    best_count = None
    best_word = None

    for kv in kv_array:
        if kv['key'] != 'MAX':
            continue

        parts = kv['value'].split('\t', 1)
        if len(parts) != 2:
            continue

        count_str, word = parts[0], parts[1]
        try:
            count = int(count_str)
        except ValueError:
            continue

        if best_count is None or count > best_count or (count == best_count and word < best_word):
            best_count = count
            best_word = word

    return best_word, best_count


if __name__ == '__main__':
    word, count = most_frequent(read_kv_array(sys.stdin))
    if word is not None:
        write_result(word, count)
