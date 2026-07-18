# Dev tools installed declaratively via Nix.
#
# These land in ~/.nix-profile/bin.
# Nix one simply takes over on PATH after activation. Language runtimes (node,
# go, python, ruby, bun) are intentionally left to mise.
#
# Tools with declarative config live in their own modules instead:
# git (core/git.nix), fzf/zoxide (core/shell.nix), the apps/ modules
# (jj, gh, direnv, tmux, btop, claude, …), starship (terminal/starship.nix).
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Search / navigation
    ripgrep
    fd
    eza
    bat

    # Git tooling
    lazygit
    delta

    # AI
    opencode

    # Shell / misc CLI
    jq
    yq-go
    tree
    htop
    curl
    wget
    unzip
  ];
}
