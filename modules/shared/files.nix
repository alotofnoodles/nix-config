# Raw dotfiles managed as-is (kept verbatim rather than translated to Nix
# options, so they read exactly like the originals).
{ ... }:
{
  # ~/.inputrc  (readline)
  home.file.".inputrc".source = ./config/inputrc;

  # ~/.config/tmux/tmux.conf
  xdg.configFile."tmux/tmux.conf".source = ./config/tmux.conf;

  # ~/.config/starship.toml
  # Omarchy's shell already runs `starship init`; this just supplies the config.
  xdg.configFile."starship.toml".source = ./config/starship.toml;
}
