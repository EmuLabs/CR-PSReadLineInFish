function __psrl_select_backward_word
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        commandline -f begin-selection
    end
    commandline -f backward-word
end

function __psrl_select_forward_word
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        commandline -f begin-selection
    end
    commandline -f forward-word
end

function __psrl_select_backward_char
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        commandline -f begin-selection
    end
    commandline -f backward-char
end

function __psrl_select_forward_char
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        commandline -f begin-selection
    end
    commandline -f forward-char
end

function __psrl_select_to_beginning_of_line
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        commandline -f begin-selection
    end
    commandline -f beginning-of-line
end

function __psrl_select_to_end_of_line
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        commandline -f begin-selection
    end
    commandline -f end-of-line
end

function __psrl_copy_selection
    set -l selected (commandline --current-selection | string collect)
    if test -z "$selected"
        return
    end

    if functions -q fish_clipboard_copy
        printf "%s" "$selected" | fish_clipboard_copy
        return
    end

    if type -q wl-copy
        printf "%s" "$selected" | wl-copy
        return
    end

    if type -q xclip
        printf "%s" "$selected" | xclip -selection clipboard
        return
    end

    if type -q xsel
        printf "%s" "$selected" | xsel --clipboard --input
    end
end

function __psrl_backspace_or_kill_selection
    set -l selected (commandline --current-selection | string collect)
    if test -n "$selected"
        commandline -f kill-selection
        commandline -f end-selection
        return
    end

    commandline -f backward-delete-char
end

function __psrl_delete_or_kill_selection
    set -l selected (commandline --current-selection | string collect)
    if test -n "$selected"
        commandline -f kill-selection
        commandline -f end-selection
        return
    end

    commandline -f delete-char
end

function fish_user_key_bindings
    # Keep fish defaults first, then layer overrides.
    fish_default_key_bindings

    # End active selection on regular cursor movement to avoid "sticky" selects.
    bind left end-selection backward-char
    bind right end-selection forward-char
    bind home end-selection beginning-of-line
    bind end end-selection end-of-line

    # Word-wise cursor movement (PSReadLine-like Ctrl+Left/Right).
    bind \e\[1\;5D end-selection backward-word
    bind \e\[1\;5C end-selection forward-word
    bind \e\[5D end-selection backward-word
    bind \e\[5C end-selection forward-word
    bind \eOd end-selection backward-word
    bind \eOc end-selection forward-word

    # Word-wise selection (PSReadLine-like Ctrl+Shift+Left/Right).
    bind \e\[1\;6D __psrl_select_backward_word
    bind \e\[1\;6C __psrl_select_forward_word
    bind \e\[6D __psrl_select_backward_word
    bind \e\[6C __psrl_select_forward_word

    # Select from cursor to start/end of line (PSReadLine-like Ctrl+Shift+Home/End).
    # Common xterm-style: CSI 1;6 (Ctrl+Shift). Use fish_key_reader if yours differs.
    bind \e\[1\;6H __psrl_select_to_beginning_of_line
    bind \e\[1\;6F __psrl_select_to_end_of_line

    # Char-wise shift selection for terminals that emit these sequences.
    bind \e\[1\;2D __psrl_select_backward_char
    bind \e\[1\;2C __psrl_select_forward_char
    bind \e\[2D __psrl_select_backward_char
    bind \e\[2C __psrl_select_forward_char

    # Copy command-line selection (Ctrl+Shift+S). Ctrl+Shift+C is not used: on
    # many Linux TTYs it is the same byte as Ctrl+C (0x03) — see docs/fish-copy-ctrl-shift-c.md
    bind ctrl-shift-s __psrl_copy_selection

    # Remove highlighted text with Backspace/Delete like PSReadLine.
    bind backspace __psrl_backspace_or_kill_selection
    bind \x7f __psrl_backspace_or_kill_selection
    bind delete __psrl_delete_or_kill_selection
    bind \e\[3\~ __psrl_delete_or_kill_selection

    # Keep default printable typing behavior.
    bind '' self-insert
end
