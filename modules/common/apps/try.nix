# try: ephemeral workspace manager (tobi/try, pulled from its own flake).
# Its home-manager module installs the package and adds the
# `eval "$(try init …)"` hook to the HM-owned .zshrc, replacing both the
# pacman `tobi-try` package and the manual init in tool-inits.zsh.
{ ... }:
{
  programs.try = {
    enable = true;
    path = "~/Work/tries";
  };
}
