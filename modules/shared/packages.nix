# Dev tools installed declaratively via Nix.
#
# These land in ~/.nix-profile/bin. Where you already have a pacman copy, the
# Nix one simply takes over on PATH after activation. Language runtimes (node,
# go, python, ruby, bun) are intentionally left to mise; desktop apps are left
# to Omarchy/pacman.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Search / navigation
    ripgrep
    fd
    fzf
    zoxide
    eza
    bat

    # Git tooling
    git
    lazygit
    delta        # nicer git diffs (you don't have this yet)
    gh

    # Shell / misc CLI
    jq
    yq-go
    tmux
    starship
    direnv
    tree
    htop
    btop
    curl
    wget
    unzip
  ];
}
