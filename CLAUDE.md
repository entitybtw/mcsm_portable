# Minecraft: Story Mode Portable (PSP)

A fan port to the PSP: the episodes are videos, the story and menus are Lua. Start with **`docs/README.md`**, then open only the page of the task. Open work is in `docs/NEXT.md`: a local file of the maintainer, git-ignored and never committed, but it is the queue of the work and its instructions. Read it before starting; on "continue" (продолжай / делай / дальше), take its first open item without questions, and update it when stopping. If it is missing (a fresh clone), say so instead of guessing the queue.

## Talking to the maintainer

- Answer in **Russian**. Code, comments, commit messages and docs stay in English.
- Report honestly: what is done, what is not, what was checked and how.

## Docs

- Docs describe the current state; history lives in git. New knowledge goes to the page of the topic, open work to `docs/NEXT.md`, and finished work leaves `NEXT.md`. Public docs never link to `NEXT.md` (it is not in the repository).
- **They are public.** Never write credentials, tokens, private host names, IPs, e-mail addresses or home paths. Write `$HOME`, `<psp root>`, `<engine repo>`.

## Rules

| # | Rule |
|---|---|
| R1 | Never `git checkout`/`git stash`/`git reset` over uncommitted work. Back up a file before a risky edit. |
| R2 | Commit or push only when the maintainer asks. Push only to `origin`, which mirrors to GitHub by itself. |
| R3 | Long-running work lives in `work/` or `tools/` (git-ignored), not in `/tmp`, which is wiped on reboot. |
| R4 | Subtitle timings made by a person are the reference: no mass retiming (`docs/LANGUAGES.md`). |
| R5 | Every language is a folder `assets/langs/<code>/`; no language is hard-coded. |
| R6 | Check every change in PPSSPP (`docs/TESTING.md`), and on a real PSP what PPSSPP cannot show: timing, races, memory. |
| R7 | A PSP-1000 has 32 MB of RAM: free the textures and sounds you load. |
| R8 | Small steps; one topic per commit. |

Many `.lua` and all `.srt`/`.pmp` files are in Git LFS: compare them with `git show REV:path | git lfs smudge`.
