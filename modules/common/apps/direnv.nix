# direnv — per-project environments, with nix-direnv for fast, cached
# `use flake` / `use nix`.
# zsh is HM-owned (core/shell.nix), so the hook is installed automatically.
# bash is still Omarchy-owned; add `eval "$(direnv hook bash)"` to ~/.bashrc.
{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true; # HM owns ~/.zshrc
    enableBashIntegration = false; # bash rc still owned by Omarchy
  };
}
