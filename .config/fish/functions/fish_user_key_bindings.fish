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

    # Char-wise shift selection for terminals that emit these sequences.
    bind \e\[1\;2D __psrl_select_backward_char
    bind \e\[1\;2C __psrl_select_forward_char
    bind \e\[2D __psrl_select_backward_char
    bind \e\[2C __psrl_select_forward_char

    # Copy current command-line selection without replacing Ctrl+C interrupt.
    bind alt-w __psrl_copy_selection
end
