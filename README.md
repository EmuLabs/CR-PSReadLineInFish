# PSReadLine-Style Selection in Fish + Konsole

This repo configures Fish so command-line editing feels closer to PSReadLine in
PowerShell/Windows Terminal, especially for word-wise movement and selection.

## What was added

Fish bindings live in:

- `.config/fish/functions/fish_user_key_bindings.fish`

It adds:

- `Ctrl+Left` / `Ctrl+Right` -> move by word (`backward-word` / `forward-word`)
- `Ctrl+Shift+Left` / `Ctrl+Shift+Right` -> extend selection by word
- `Ctrl+Shift+Home` / `Ctrl+Shift+End` -> extend selection from the cursor to the **start** / **end** of the line
- `Alt+W` -> copy the current command-line selection to the clipboard

Several escape-sequence variants are included to improve compatibility across
terminal emulators and keyboard protocols. If **Ctrl+Shift+Home/End** do nothing,
run `fish_key_reader` and bind your terminal’s sequences to
`__psrl_select_to_beginning_of_line` / `__psrl_select_to_end_of_line`.

### Why not Ctrl+Shift+C?

On Linux TTYs, **Ctrl+Shift+C** often produces the **same** character as
**Ctrl+C** (ASCII `ETX`, `0x03`, shown as `^C` by `showkey -a`). Fish then sees
only **interrupt**, not a distinct “copy” chord — so you cannot bind
`Ctrl+Shift+C` for copy the way Windows Terminal does.

**Use `Alt+W`** for copy here, or configure your terminal to send a **unique**
escape sequence for a “copy line” shortcut and bind that sequence in
`fish_user_key_bindings.fish` to `__psrl_copy_selection` (check with
`fish_key_reader`). More detail: [docs/fish-copy-ctrl-shift-c.md](docs/fish-copy-ctrl-shift-c.md).

### Konsole split panes (optional)

Patches for **new split pane on the left / above** in Konsole are **not** part
of this Fish repo; see **[docs/konsole-emulator-features.md](docs/konsole-emulator-features.md)**
for shortcuts and a pointer to the KonsoleEMU build notes.

## Install

Copy the fish config directory into your home config path:

```sh
mkdir -p ~/.config/fish/functions
cp .config/fish/functions/fish_user_key_bindings.fish ~/.config/fish/functions/
```

Then start a new Fish session, or reload:

```fish
source ~/.config/fish/functions/fish_user_key_bindings.fish
fish_user_key_bindings
```

## Discover your actual key sequences

If a shortcut does not work, check what your terminal actually sends:

```fish
fish_key_reader
```

Press the key chord (`Ctrl+Shift+Right`, `Ctrl+Shift+Home`, etc.) and note the
sequence shown by `fish_key_reader`.

Add a corresponding bind in `fish_user_key_bindings.fish`, for example:

```fish
bind <sequence-from-fish_key_reader> __psrl_select_forward_word
```

or:

```fish
bind <sequence-from-fish_key_reader> begin-selection backward-word
```

Reload Fish and retest.

## Konsole behavior and limits

There are two separate interaction modes in Konsole:

1. **Normal shell input mode** (where Fish keybindings apply)
2. **Konsole Selection Mode** (`Ctrl+Shift+D` by default)

### Normal shell input mode (recommended for PSReadLine parity)

Use this mode when editing the current command line. Fish keybindings can mimic
PSReadLine-like `Ctrl+Shift+Arrow` word selection well here.

### Konsole Selection Mode (scrollback/terminal text)

Selection Mode is implemented by Konsole itself, not Fish. It supports keyboard
selection and navigation, but exact Windows Terminal mark-mode parity (including
all word-wise selection combinations) may not be available depending on Konsole
version and key handling.

Useful defaults in Selection Mode:

- Enter/leave mode: `Ctrl+Shift+D`
- Exit mode: `Esc`
- Move cursor: arrows, PageUp/PageDown, Home/End
- Start/end selection: `V` (or `Shift+V` for line selection)
- Extend selection with movement keys while selecting

Practical fallback for word-wise copy in Selection Mode:

1. Enter Selection Mode (`Ctrl+Shift+D`)
2. Move near target text
3. Press `V` to start selection
4. Use available jump movement for your profile/version (or repeated movement)
5. Press `V` again to finish
6. Copy selection

## Troubleshooting

- If `Ctrl+Shift+Arrow` does nothing, your desktop/global shortcut manager may
  intercept it before Konsole/Fish sees it.
- If `Ctrl+Left/Right` works but `Ctrl+Shift+Left/Right` does not, capture exact
  sequences with `fish_key_reader` and add explicit `bind` entries.
- If behavior differs between terminals, keep terminal-specific binds in
  `fish_user_key_bindings.fish` grouped by comments.

## Verification checklist

In a Fish prompt with text like:

```text
one two three four
```

Check:

1. `Ctrl+Left/Right` moves by words.
2. `Ctrl+Shift+Left` expands selection by one word to the left.
3. `Ctrl+Shift+Right` expands selection by one word to the right.
4. Typing replaces selected text.
5. Backspace/Delete removes selected text as expected.

In Konsole Selection Mode, check:

1. `Ctrl+Shift+D` enters/leaves Selection Mode.
2. `V` starts and ends selection.
3. Keyboard-only selection/copy works for scrollback text.
4. Any missing word-wise extension behavior is documented in your local notes,
   with your preferred fallback workflow.

## References

- [PSReadLine repository](https://github.com/PowerShell/PSReadLine)
- [Fish bind command docs](https://fishshell.com/docs/current/cmds/bind.html)
- [Konsole Selection Mode docs](https://docs.kde.org/trunk_kf6/en/konsole/konsole/selection.html)