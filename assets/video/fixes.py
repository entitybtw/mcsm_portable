import os
import re
import subprocess
from collections import Counter

try:
    import enchant
except ImportError:
    print("❌ Модуль 'pyenchant' не установлен. Установи его командой:\n  pip install pyenchant")
    exit(1)

speller = enchant.Dict("en_US")
whitelist = {
    "ivor", "jesse", "gabriel", "ellegaard", "magnus", "reuben", "soren",
    "endercon", "minecraft", "nether", "wither"
}

word_regex = re.compile(r'\b[a-zA-Z]{3,}\b')

def find_srt_files(root="."):
    for dirpath, _, files in os.walk(root):
        for file in files:
            if file.lower().endswith(".srt"):
                yield os.path.join(dirpath, file)

def get_rare_words(files, min_occurrences=1, max_occurrences=2):
    counter = Counter()
    for path in files:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            for line in f:
                words = word_regex.findall(line.lower())
                for w in words:
                    if w not in whitelist:
                        counter[w] += 1
    return {w for w, c in counter.items() if min_occurrences <= c <= max_occurrences}

def highlight_word(line, word):
    return re.sub(rf"\b({re.escape(word)})\b", r"[\1]", line, flags=re.IGNORECASE)

def suggest(word):
    suggestions = speller.suggest(word)
    return suggestions[0] if suggestions else word

def process_file(path, rare_words):
    changed = False
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    for i, line in enumerate(lines):
        words = word_regex.findall(line)
        for word in words:
            lw = word.lower()
            if lw in rare_words and not speller.check(word) and lw not in whitelist:
                context = highlight_word(line.strip(), word)
                default = suggest(word)
                prompt = f"File: {path}\nLine {i+1}:\n{context}\n\nReplace '{word}' with:"
                result = subprocess.run([
                    "dialog", "--stdout", "--inputbox", prompt, "15", "80", default
                ], text=True, capture_output=True)

                if result.returncode == 0:
                    new_word = result.stdout.strip()
                    if new_word and new_word != word:
                        pattern = r'\b' + re.escape(word) + r'\b'
                        lines[i] = re.sub(pattern, new_word, lines[i])
                        changed = True

    if changed:
        with open(path, "w", encoding="utf-8") as f:
            f.writelines(lines)
        print(f"✔ Исправлено: {path}")

def main():
    files = list(find_srt_files())
    rare_words = get_rare_words(files)

    for file in files:
        process_file(file, rare_words)

if __name__ == "__main__":
    main()
