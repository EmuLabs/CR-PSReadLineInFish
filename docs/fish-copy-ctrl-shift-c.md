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

**Practical default in this repo:** copy selection with **Alt+W** (`bind alt-w
__psrl_copy_selection`).

To use another shortcut, run `fish_key_reader`, press your chord, and add:

```fish
bind <sequence> __psrl_copy_selection
```
