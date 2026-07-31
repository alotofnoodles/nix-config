# Tool shell integrations — the zsh branch of omarchy's shared `shell/inits`.
#
# Sourced by modules/common/zsh.nix via readFile. zoxide, fzf, direnv and
# starship are omitted here because programs.zoxide / programs.fzf /
# programs.direnv / programs.starship install their own init into .zshrc.

# mise — runtime version manager. On pasokon Omarchy owns it; on the work Mac
# programs.mise.enable installs it and adds its own activate line. The guard
# makes this a no-op in the latter case only if mise is absent, so hosts that
# use programs.mise.enable rely on THIS eval being harmless — it re-runs
# activation, which is idempotent. NO_HASH_CMDS/DIRS (see options.zsh) keeps
# mise's shims resolving.
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# zd — `cd` wrapper that falls through to a zoxide fuzzy jump when the argument
# is not a real directory. `cd` is aliased to this in aliases.nix.
#
# Ported from Omarchy's default/bash/aliases, which is where pasokon has been
# getting it (via /usr/share/omarchy-zsh/shell/all). Defining it here removes
# that undeclared dependency on a system file — the stated goal of this module —
# and is what makes the `cd` alias work on the work Mac, where no Omarchy exists.
#
# Calls `j`, zoxide's command name here (programs.zoxide.options sets --cmd j).
# Omarchy's copy calls `z`; if you ever drop the --cmd override, change this too.
#
zd() {
  if (( $# == 0 )); then
    builtin cd ~ || return
  elif [[ -d $1 ]]; then
    builtin cd "$1" || return
  else
    # Report a miss rather than failing silently (as Omarchy's version does).
    if ! j "$@"; then
      echo "Error: Directory not found"
      return 1
    fi
    printf "\U000F17A9 "
    pwd
  fi
}
