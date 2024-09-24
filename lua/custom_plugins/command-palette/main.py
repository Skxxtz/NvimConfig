def bad_character_heuristic(pattern):
    """
    Create a bad character heuristic table for the given pattern.
    """
    bad_char = {}
    pattern_length = len(pattern)

    for i in range(pattern_length):
        bad_char[pattern[i]] = i  # Set the last occurrence of each character

    return bad_char

def boyer_moore(text, pattern):
    """
    Boyer-Moore algorithm to find all occurrences of the pattern in the text.
    """
    m = len(pattern)
    n = len(text)
    
    bad_char = bad_character_heuristic(pattern)
    matches = []

    s = 0  # Shift of the pattern with respect to text
    while s <= n - m:
        j = m - 1  # Start comparing from the last character of pattern

        while j >= 0 and pattern[j] == text[s + j]:
            j -= 1

        if j < 0:  # Match found
            matches.append(s)
            s += (m - bad_char.get(text[s + m], -1)) if s + m < n else 1  # Shift pattern
        else:
            s += max(1, j - bad_char.get(text[s + j], -1))  # Shift pattern based on bad character

    return matches

# Example usage
text = "Jump to previous occurrence"
pattern = "occ"
result = boyer_moore(text, pattern)

print(f"Pattern found at indices: {result}")

