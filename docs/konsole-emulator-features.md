# KonsoleEMU (patched Konsole) — features used with this setup

The Fish bindings in this repo only affect the **shell command line**. Optional
enhancements for **Konsole** itself (split layout, select mode, etc.) live in a
separate source tree: build and install that fork if you want them.

## Split panes (new pane on the left / above)

Stock Konsole splits horizontally with the **new** terminal to the **right** of
the focused pane, and vertically with the new pane **below**. The KonsoleEMU
fork adds actions so you can insert the new pane on the **left** or **above**
instead.

| Action | Default shortcut (KonsoleEMU) |
|--------|-------------------------------|
| Split View Left/Right *(new pane on the **right** — stock)* | **Ctrl+**`(` |
| Split View Left/Right **(New Pane on Left)** | **Ctrl+Shift+[** |
| Split View Top/Bottom *(new pane **below** — stock)* | **Ctrl+**`)` |
| Split View Top/Bottom **(New Pane Above)** | **Ctrl+Shift+]** |

Menu paths: **View → Split View → …**

## Build / install

See the Konsole fork’s `README.md` (local path example):

- `~/git/CR-konsoleEMU/README.md` — **Local Build and Install (KonsoleEMU)** section  
  (`cmake`, `CMAKE_INSTALL_PREFIX=$HOME/.local`, optional `konsoleemu` launcher name).

Installing under `~/.local` keeps the patched `konsole` in `~/.local/bin` while
the distro package remains in `/usr/bin`.

## Other KonsoleEMU patches (summary)

The same fork may also include (depending on branch):

- Select Mode: word-wise movement, Alt+arrow / Ctrl+Shift+copy behavior, etc.
- See that repository’s history and `README.md` for the authoritative list.

This file is a **companion** to the Fish config in this repo; it does not ship
Konsole source code.
