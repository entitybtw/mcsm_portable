# Languages and subtitles

Every language, built-in or a language pack, is a folder of `assets/langs/`. The game finds them at start (`scanLanguages` in `assets/misc/lang.lua`), and nothing about a language is hard-coded. The format for pack authors is in `assets/langs/README.txt`.

| Code | Name | Base | Notes |
|---|---|---|---|
| `en` | English | none | The reference and the last fallback; must always exist |
| `ru` | Русский | en | Cyrillic; episode 1 is a human translation with its own line split in 17 files |
| `uk` | Українська | en | Cyrillic |
| `es` | Español | en | Latin American ("ustedes") |
| `pt_br` | Português (Brasil) | en | Was `pt`; a saved `pt` is migrated |
| `pt_pt` | Português (Portugal) | pt_br | European Portuguese |

## How a language is chosen

**First launch.** `getlang()` takes the saved language if it exists, else the PSP system language (`US→en, ES→es, RU→ru, PT→pt_br`), else English. Ukrainian does not exist as a PSP system language.

**Fallbacks**, so a partial language still works:

- Subtitles: `ResolveSubs(path)` (called by `PMP.playExt`) uses the file of the current language, or of its `base`, and so on.
- Strings: `loadStrings(code)` loads English, then each language of the base chain, then the language itself, key by key. Only the globals `ui` and `choices_one` to `choices_five` are read from a `ui_strings.lua`.
- Fonts: `script: "cyrillic"` gets unifont (16 px menus, 12 px small text); Latin gets minecraft.ttf (12 and 8 px) and pexico for subtitles. `IsCyrillic(code)` is the only switch.

**Menus.** `assets/misc/language.lua` (settings) and `pause_language.lua` use `assets/misc/langmenu.lua`: a scrolling list of 5 visible buttons, with a scrollbar when there are more languages. A long name scrolls on the selected button.

## Subtitle files

`assets/langs/<code>/subtitles/episodeN/<same path as the video>.srt`, in UTF-8. English is the reference; the other languages translate it line by line with the same timings.

What the engine accepts (`parseSRT`):

- The usual block: number, `00:00:01,000 --> 00:00:02,500`, text lines, an empty line.
- **A space on both sides of `-->`.** Without it the parser stops and the rest of the file is lost.
- An empty line between blocks is required. A block without text swallows the next block.
- At most 256 cues per file and 512 bytes of text per cue.
- A cue with `end <= start`, or one that starts after the end of the video, never shows.
- Timestamps use a comma. Loose forms like `0:01:52,000` or `00:00:7,807` read correctly.
- Files use CRLF in places: turn `\r\n` into `\n` before parsing them in a script.

## Timing rules

- Timings made by a person are the reference: the English base of episodes 1 to 4 and the Russian of episode 1. **Never retime in bulk.** An AI commit once changed about 580 timings this way (208bd0585).
- Change a timing only when it is measured against the speech, and only for lines off by more than about a second.
- A line may be extended to the end of its speech, but never past the start of the next line.

## Speech recognition

A second opinion, not the truth: in fights and under music two models can agree on the wrong words, so a verdict needs two measures that agree and a person reading it. With `faster-whisper`, do not use voice activity detection (`vad_filter=True`, or the batched mode): it takes speech over music for silence.

## Glossary

| English | ru | uk | es | pt_br | pt_pt |
|---|---|---|---|---|---|
| Wither Storm | Шторм Визера | Шторм Візера | Tormenta Wither | Tempestade de Wither | Tempestade de Wither |
| Order of the Stone | Орден Камня | Орден Каменя | Orden de la Piedra | Ordem da Pedra | Ordem da Pedra |
| Formidi-Bomb | Гипербомба | Гіпербомба | Hiperbomba | Bomba Formidável | Formidi-Bomba |
| Command Block | командный блок | командний блок | bloque de comandos | bloco de comando | bloco de comando |
| Endercon | Крайкон | ЕндерКон | EnderCon | Endercon | Endercon |
| Far Lands | Чужедальние края | Далекі Краї | Tierras Lejanas | Terras Distantes | Terras Distantes |
| Eversource | Вечный источник | Вічне джерело | Fuente Eterna | Fonte Eterna | Fonte Eterna |
| the Founder | Основательница | Засновниця | la Fundadora | a Fundadora | a Fundadora |
| Sky City | Небесный город | Небесне місто | Ciudad del Cielo | Cidade do Céu | Cidade do Céu |
| Ocelots | Оцелоты | Оцелоти | Ocelotes | Ocelotes | Ocelotes |
| crafting table | верстак | верстат | mesa de trabajo | bancada de trabalho | bancada |

Names: Jesse, Petra, Axel, Olivia, Lukas, Reuben, Gabriel, Ellegaard, Magnus, Soren, Ivor, Aiden, Milo, Gill.

- ru: Джесси, Петра, Аксель, Оливия, Лукас, Рубен, Габриэль, Эльгорд, Магнус, Сорен, Айвор, Айден, Майло.
- uk: Джессі, Петра, Аксель, Олівія, Лукас, Рубен, Габріель, Еллегард, Магнус, Сорен, Айвор, Айден, Майло. Vocatives like Рубене, Лукасе, Петро are right.
- Jesse is male; Petra, Olivia, Ellegaard and the Founder are female.

Style:

- es: neutral Latin American ("ustedes").
- pt_br: "você".
- pt_pt: "tu", "estar a + infinitivo", enclisis, PT vocabulary (fixe, pá, malta, equipa, miúdo, comboio, ecrã, ficheiro).
