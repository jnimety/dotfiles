fish_add_path --append $HOME/.local/bin

set -g fish_term24bit 1
set -g fish_greeting ""

set -gx PAGER "less -sR"
set -gx VISUAL nvim
set -gx EDITOR $VISUAL
set -gx GIT_EDITOR $VISUAL
set -gx LANG en_US.UTF-8
set -gx LOCALE UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_COLLATE C
# set -gx MANPAGER "sh -c 'col -bx | bat --language man --plain'"
set -gx MANPAGER "nvim +Man!"
set -gx MANCOLOR 1

set -gx LESSCHARSET utf-8
# set LESS_TERMCAP_DEBUG=1 and open a man page to see termcap markup
# set -gx LESS_TERMCAP_mb (set_color --bold 2ac3de) # begin blink
# set -gx LESS_TERMCAP_md (set_color --bold 2ac3de) # begin bold
# set -gx LESS_TERMCAP_me (set_color normal) # reset bold/blink
# set -gx LESS_TERMCAP_se (set_color normal) # reset reverse video
# set -gx LESS_TERMCAP_so (set_color f7768e) # begin reverse video
# set -gx LESS_TERMCAP_ue (set_color normal) # reset underline
# set -gx LESS_TERMCAP_us (set_color e0af68) # begin underline

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t -- $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        # Variation on the original, vanilla "!" case
        # ===========================================
        #
        # If the `!$` is preceded by text, search backward for tokens that
        # contain that text as a substring. E.g., if we'd previously run
        #
        #   git checkout -b a_feature_branch
        #   git checkout main
        #
        # then the `fea!$` in the following would be replaced with
        # `a_feature_branch`
        #
        #   git branch -d fea!$
        #
        # and our command line would look like
        #
        #   git branch -d a_feature_branch
        #
        case "*!"
            commandline -f backward-delete-char history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# enables $?
function bind_status
    commandline -i (echo '$status')
end

# enables $$
function bind_self
    commandline -i (echo '$fish_pid')
end

# enable keybindings
function fish_user_key_bindings
    # Set the cursor shapes for the different vi modes.
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    # set -g fish_cursor_replace_one underscore blink
    set -g fish_cursor_visual block

    fish_vi_key_bindings

    bind '$?' bind_status
    bind '$$' bind_self

    bind -M insert ! bind_bang
    bind -M insert '$' bind_dollar
end
