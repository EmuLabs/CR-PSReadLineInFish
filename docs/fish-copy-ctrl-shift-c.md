# Why Ctrl+Shift+C usually cannot be “copy” in Fish on Linux

If you run `showkey -a` and press **Ctrl+Shift+C**, you may see the same output as
for **Ctrl+C**:

```text
^C     3 0003 0x03
```

That byte is ASCII **ETX**. The shell and Fish cannot tell “Ctrl+Shift+C” apart
from “Ctrl+C” when the terminal delivers only `0x03`.

So:

- **Ctrl+C** remains interrupt (or your binding on that byte).
- A separate Fish binding for “copy” on **Ctrl+Shift+C** is not possible unless
  the terminal sends a **different** sequence (some GUI terminals can be
  configured to do that).

**Default in this repo:** copy selection with **Ctrl+Shift+S** (`bind
ctrl-shift-s __psrl_copy_selection`). If your terminal does not send a distinct
sequence for that chord, use `fish_key_reader` and bind manually.

To use another shortcut, run `fish_key_reader`, press your chord, and add:

```fish
bind <sequence> __psrl_copy_selection
```
