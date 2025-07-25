#!/bin/bash

list="ep3spisok.txt"

while read -r filepath; do
  [ -f "$filepath" ] || { echo "⛔ Пропущено (не найден): $filepath"; continue; }

  # Очистим экран
  clear
  echo "Редактируем: $filepath"

  # Ввод текста
  square_text=$(dialog --inputbox "[$filepath]\n\nВведите текст для кнопки SQUARE" 10 60 "" 3>&1 1>&2 2>&3)
  [ -z "$square_text" ] && continue

  circle_text=$(dialog --inputbox "[$filepath]\n\nВведите текст для кнопки CIRCLE" 10 60 "" 3>&1 1>&2 2>&3)
  [ -z "$circle_text" ] && continue

  tmpfile=$(mktemp)

  awk -v sq_text="$square_text" -v cr_text="$circle_text" '
  BEGIN {
    replaced_img = 0
    replaced_draw = 0
    inserted_draws = 0
    replaced_unloads = 0
  }
  {
    if ($0 ~ /local img = Image\.load/) {
      print "local square = Image.load(\"assets/icons/square.png\")"
      print "local circle = Image.load(\"assets/icons/circle.png\")"
      replaced_img = 1
    }
    else if ($0 ~ /screen\.clear\(\)/) {
      next
    }
    else if ($0 ~ /Image\.draw\(img, 0, 0\)/) {
      print "Image.draw(square, 25, 127)"
      print "Image.draw(circle, 455, 127)"
      print "intraFont.print(25 + 15 + 5, 127, \"" sq_text "\", Color.new(255,255,255), font, 0.4)"
      print "intraFont.print(455 - 5 - intraFont.textW(font, \"" cr_text "\", 0.4), 127, \"" cr_text "\", Color.new(255,255,255), font, 0.4)"
      inserted_draws = 1
    }
    else if ($0 ~ /Image\.unload\(img\)/) {
      if (!replaced_unloads) {
        print "Image.unload(square)"
        print "Image.unload(circle)"
        replaced_unloads = 1
      } else {
        print "Image.unload(square)"
        print "Image.unload(circle)"
      }
    }
    else {
      print
    }
  }
  ' "$filepath" > "$tmpfile"

  mv "$tmpfile" "$filepath"
  echo "✅ $filepath отредактирован"
done < "$list"

clear
echo "🎉 ВСЁ ГОТОВО! Все скрипты обработаны!"
