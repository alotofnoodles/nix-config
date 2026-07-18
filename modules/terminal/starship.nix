# Starship prompt. programs.starship installs the package and adds
# `eval "$(starship init zsh)"` to the HM-owned .zshrc, so no manual init in
# tool-inits.zsh. `settings` is left unset — HM only writes starship.toml when
# settings are given — so the verbatim toml kept in-repo stays the config.
{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false; # bash rc still owned by Omarchy
  };

  # ~/.config/starship.toml
  xdg.configFile."starship.toml".source = ./starship.toml;
}
