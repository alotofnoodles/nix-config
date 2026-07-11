# Dev tools installed declaratively via Nix.
#
# These land in ~/.nix-profile/bin.
# Nix one simply takes over on PATH after activation. Language runtimes (node,
# go, python, ruby, bun) are intentionally left to mise
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
    delta
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
