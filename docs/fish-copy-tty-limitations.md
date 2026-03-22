# Copy shortcut: why Ctrl+Shift+ chords often fail in Fish on Linux

Fish only sees what the terminal sends. On a classic TTY, **Ctrl+Shift+letter**
often produces the **same** single-byte control character as **Ctrl+letter**
(ASCII 1–31). There is nothing for Fish to bind separately.

## Examples (`showkey -a`)

| You press        | Often shows | Same as   | Byte   |
|------------------|-------------|-----------|--------|
| Ctrl+Shift+C     | `^C`        | Ctrl+C    | `0x03` |
| Ctrl+Shift+S     | `^S`        | Ctrl+S    | `0x13` |

So **Ctrl+Shift+C** is not distinct from interrupt, and **Ctrl+Shift+S** is not
distinct from **Ctrl+S** (historically XOFF / flow control).

## What works without terminal config

**Default in this repo:** **`Alt+W`** → `bind alt-w __psrl_copy_selection`

`Alt` combinations usually send an escape-prefixed sequence, which Fish can bind
on its own.

## Custom chord

If you want a specific shortcut, run **`fish_key_reader`**, press the chord, and add:

```fish
bind <sequence-from-fish_key_reader> __psrl_copy_selection
```

to `fish_user_key_bindings.fish`.

Some terminals can remap keys to send a **unique CSI sequence** (e.g. Konsole
keyboard profiles) so you can mimic a “copy” chord — still bound in Fish to
`__psrl_copy_selection`.

### Legacy doc name

Older links may point to [fish-copy-ctrl-shift-c.md](fish-copy-ctrl-shift-c.md);
this file replaces that explanation.
