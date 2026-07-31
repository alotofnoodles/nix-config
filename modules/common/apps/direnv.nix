# direnv — per-project environments, with nix-direnv for fast, cached
# `use flake` / `use nix`.
#
# zsh is HM-owned (common/zsh.nix), so the hook is installed automatically.
# enableBashIntegration is left to the host: bash is Omarchy-owned on pasokon
# (add `eval "$(direnv hook bash)"` to ~/.bashrc there), unmanaged on the Mac.
{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true; # HM owns ~/.zshrc
  };
}
