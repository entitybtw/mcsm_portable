#!/bin/bash

normalize() {
    local s="$1"
    s="${s,,}"
    s="${s// /_}"
    s="${s//\'/}"
    s="${s//./}"
    s="${s//\?/}"
    s="${s//!/}"
    s="${s//,/}"
    echo "$s"
}

echo "Введите номер ветки, с которой начать (например, 1):"
read branch

while true; do
    DIR="./choices/$branch"
    NEXT=$((branch + 1))
    NEXTDIR="./choices/$NEXT"

    if [ ! -d "$DIR" ]; then
        echo "Папка $DIR не найдена, завершаю."
        break
    fi

    if [ ! -d "$NEXTDIR" ]; then
        echo "Папка следующей ветки $NEXTDIR не найдена, создаю..."
        mkdir -p "$NEXTDIR"
    fi

    lua_files=("$DIR"/*.lua)
    if [ ${#lua_files[@]} -eq 0 ]; then
        echo "Lua файлы не найдены в $DIR, завершаю."
        break
    fi

    for lua_file in "${lua_files[@]}"; do
        filename=$(basename "$lua_file" .lua)
        pmp_file="$DIR/$filename.pmp"
        srt_file="$DIR/$filename.srt"

        if [ ! -f "$pmp_file" ]; then
            echo "Внимание: .pmp файл для $filename не найден ($pmp_file), пропускаю."
            continue
        fi

        echo ""
        echo "Редактируем $lua_file из ветки $branch"
        echo "Введите варианты выбора для этого скрипта."
        echo "Для каждого варианта введи текст и кнопку (square, circle и т.д.)"
        echo "Пустой текст — завершить ввод."

        texts=()
        buttons=()

        while true; do
            read -p "Текст выбора (Enter для завершения): " text
            [ -z "$text" ] && break
            read -p "Кнопка (square/circle/etc): " button
            texts+=("$text")
            buttons+=("$button")
        done

        used_icons=()
        for b in "${buttons[@]}"; do
            [[ ! " ${used_icons[*]} " =~ " $b " ]] && used_icons+=("$b")
        done

        # абсолютный путь к assets, чтобы вставлять в lua
        BASEPTHH="assets/video/episode5/choices"
        BASE_PATH="assets/video/episode5/choices/$branch"

        {
            echo "local choosing = true"
            for icon in "${used_icons[@]}"; do
                echo "local $icon = Image.load(\"assets/icons/$icon.png\")"
            done
            echo ""
            echo "PMP.setVolume(pmpvolume)"
            echo "local result = PMP.playEasy('$BASE_PATH/$filename.pmp', buttons.r, true, '$BASE_PATH/$filename.srt', font, subssize, \"#FFFFFF\", \"#000000/150\", subs)"
            if result == 1 then
                nextscene = "./mainmenu.lua"
                return 1
            end
            echo ""

            for i in "${!texts[@]}"; do
                b="${buttons[$i]}"
                t="${texts[$i]}"
                if [ "$b" = "square" ]; then
                    echo "Image.draw($b, 25, 127)"
                elif [ "$b" = "circle" ]; then
                    echo "Image.draw($b, 455, 127)"
                else
                    echo "Image.draw($b, 240, 127)"
                fi
            done

            for i in "${!texts[@]}"; do
                b="${buttons[$i]}"
                t="${texts[$i]}"
                if [ "$b" = "square" ]; then
                    echo "intraFont.print(25 + 15 + 5, 127, \"$t\", Color.new(255,255,255), font, 0.4)"
                elif [ "$b" = "circle" ]; then
                    echo "intraFont.print(455 - 5 - intraFont.textW(font, \"$t\", 0.4), 127, \"$t\", Color.new(255,255,255), font, 0.4)"
                else
                    echo "intraFont.print(240 - intraFont.textW(font, \"$t\", 0.4)/2, 127, \"$t\", Color.new(255,255,255), font, 0.4)"
                fi
                echo "intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)"
            done

            echo "debugoverlay.draw(debugoverlay.loadSettings())"
            echo "screen.flip()"
            echo ""
            echo "while choosing do"
            echo "    buttons.read()"
            echo ""

            for i in "${!texts[@]}"; do
                b="${buttons[$i]}"
                t="${texts[$i]}"
                norm=$(normalize "$t")
                if [ "$i" -eq 0 ]; then
                    echo "    if buttons.pressed(buttons.$b) then"
                else
                    echo "    elseif buttons.pressed(buttons.$b) then"
                fi
                for icon in "${used_icons[@]}"; do
                    echo "        Image.unload($icon)"
                done
                echo "        choosing = false"
                echo "        nextscene = \"$BASEPTHH/$NEXT/$(normalize "$t").lua\""
            done

            echo "    elseif buttons.pressed(buttons.start) then"
            for icon in "${used_icons[@]}"; do
                echo "        Image.unload($icon)"
            done
            echo "        choosing = false"
            echo "        local pause = dofile("assets/misc/pause.lua")"
            echo "        if pause == -1 then nextscene = "./mainmenu.lua" end"
            echo "    elseif buttons.pressed(buttons.r) then"
            echo "        choosing = false"
            echo "        SaveGame(5)"
            echo "    end"
            echo "end"

        } > "$lua_file"

        echo "Обновлён $lua_file"
    done

    echo ""
    read -p "Продолжить на ветке $((branch + 1))? (y/n): " ans
    case "$ans" in
        y|Y) branch=$((branch + 1)) ;;
        *) echo "Выход."; break ;;
    esac
done

echo "Скрипт завершён."
