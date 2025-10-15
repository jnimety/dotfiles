fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path --append $HOME/.bin
fish_add_path --append $HOME/.local/bin
fish_add_path /opt/homebrew/opt/ruby/bin

set -g fish_term24bit 1
set -U fish_greeting ""

set -Ux PAGER "less -sR"
set -Ux VISUAL nvim
set -Ux EDITOR $VISUAL
set -Ux GIT_EDITOR $VISUAL
set -Ux LANG en_US.UTF-8
set -Ux LOCALE UTF-8
set -Ux LC_ALL en_US.UTF-8
set -Ux LC_COLLATE C
# set -Ux MANPAGER "sh -c 'col -bx | bat --language man --plain'"
set -Ux MANPAGER "nvim +Man!"
set -Ux MANCOLOR 1

set -Ux LESSCHARSET 'utf-8'
# set LESS_TERMCAP_DEBUG=1 and open a man page to see termcap markup
# set -Ux LESS_TERMCAP_mb (set_color --bold 2ac3de) # begin blink
# set -Ux LESS_TERMCAP_md (set_color --bold 2ac3de) # begin bold
# set -Ux LESS_TERMCAP_me (set_color normal) # reset bold/blink
# set -Ux LESS_TERMCAP_se (set_color normal) # reset reverse video
# set -Ux LESS_TERMCAP_so (set_color f7768e) # begin reverse video
# set -Ux LESS_TERMCAP_ue (set_color normal) # reset underline
# set -Ux LESS_TERMCAP_us (set_color e0af68) # begin underline

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
    set fish_cursor_default block blink
    set fish_cursor_insert line blink
    # set fish_cursor_replace_one underscore blink
    set fish_cursor_visual block

    fish_vi_key_bindings

    bind '$?' bind_status
    bind '$$' bind_self

    bind -M insert ! bind_bang
    bind -M insert '$' bind_dollar
end
