# Tool shell integrations — the zsh branch of omarchy's shared `shell/inits`.
#
# Sourced by modules/core/shell.nix via readFile. zoxide, fzf, direnv and
# starship are omitted here because programs.zoxide / programs.fzf /
# programs.direnv / programs.starship install their own init into .zshrc.

# mise — runtime version manager, NOT nix-managed (Omarchy owns it), hence the
# command -v guard. NO_HASH_CMDS/DIRS (see options.zsh) keeps its shims
# resolving.
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi
