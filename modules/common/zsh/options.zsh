# zsh options, history, completion styling and keybindings.
#
# Distilled from omarchy-zsh's `shell/zoptions`:
#   https://github.com/omacom-io/omarchy-zsh/blob/master/shell/zoptions
#
# Sourced by modules/shared/zsh.nix via readFile (lib.mkAfter), so it runs
# after Home Manager's compinit and after the plugins load.
#
# Deliberately dropped from the upstream file:
#   - `autoload -Uz compinit; compinit -i`  — Home Manager runs compinit
#     (programs.zsh.enableCompletion).
#   - the syntax-highlighting `source` line   — provided from nixpkgs via
#     programs.zsh.syntaxHighlighting.enable.
#   - the `omarchy <Tab>` route-completion widget and `_parameters`/`omarchy-*`
#     tweaks — those are coupled to the omarchy-zsh package's _omarchy
#     completion, which we no longer depend on.

# Use emacs key bindings
bindkey -e

# Meta/UTF-8 settings
setopt COMBINING_CHARS

# History configuration.
#
# HISTFILE/HISTSIZE/SAVEHIST and the dup/share/space options are NOT set here.
# This file is spliced in with mkAfter, so assignments here would run after —
# and silently override — programs.zsh.history. They live in
# modules/common/zsh.nix instead, with `path` set per-host.
#
# Only the two options with no programs.zsh.history equivalent remain:
setopt HIST_REDUCE_BLANKS       # Remove unnecessary blanks
setopt HIST_VERIFY              # Don't execute immediately upon history expansion

# Completion configuration (bash-like: list on first tab, menu on repeat)
setopt COMPLETE_IN_WORD         # Complete from both ends of word
setopt ALWAYS_TO_END            # Move cursor to end after completion
unsetopt MENU_COMPLETE          # Don't jump into menu selection on first tab
unsetopt BASH_AUTO_LIST         # Let AUTO_LIST below list immediately when ambiguous
setopt AUTO_LIST                # List choices when completion is ambiguous
setopt LIST_AMBIGUOUS           # Insert any shared prefix before listing choices
setopt AUTO_MENU                # Enter menu selection on repeated tab after listing

# zsh/complist provides the menuselect keymap and the highlighted
# interactive completion menu (enabled below via `menu select`).
zmodload zsh/complist

# Directory navigation
setopt AUTO_CD                  # cd by typing directory name
setopt CHASE_LINKS              # Mark symlinked directories

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* l:|=*'

# Interactive menu with the current selection highlighted.
zstyle ':completion:*' menu select

# Populate LS_COLORS so completion listings (and ls) get colors. Coreutils
# `ls` falls back to built-in defaults, but the list-colors zstyle below
# needs LS_COLORS to be exported.
if [[ -z $LS_COLORS ]] && (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi

# Colored completion listings
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Show all completions at once (no paging)
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''

# Don't complete hidden files unless explicitly starting with dot
zstyle ':completion:*' match-hidden-files off

# Arrow keys: history search matching current input
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char

# Shift-Tab cycles the completion menu backwards. The main-keymap binding
# kicks in on the first press; the menuselect binding handles subsequent
# presses once the highlighted menu is active.
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Extended globbing
setopt EXTENDED_GLOB

# Don't beep on errors
unsetopt BEEP

# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Ensure mise works (disable command hashing)
setopt NO_HASH_CMDS
setopt NO_HASH_DIRS
