# Starship prompt. programs.starship installs the package and adds
# `eval "$(starship init zsh)"` to the HM-owned .zshrc, so no manual init in
# tool-inits.zsh.
#
# `settings` is deliberately left unset: Home Manager only writes starship.toml
# when settings are given, so leaving it empty makes the verbatim toml below the
# single writer of ~/.config/starship.toml.
#
# An importing host must NOT also set programs.starship.settings — both routes
# produce that same file, and two writers on one path is an activation conflict
# lib.mkForce cannot resolve (there is no single option to prioritise between
# them).
{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # enableBashIntegration is left to the host: bash is Omarchy-owned on
    # pasokon, unmanaged on the work Mac.
  };

  # ~/.config/starship.toml
  xdg.configFile."starship.toml".source = ./starship.toml;
}
