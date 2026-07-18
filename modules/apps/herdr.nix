# herdr: terminal multiplexer for coding agents (https://herdr.dev), pulled
# from its own flake since it's not in nixpkgs. The flake ships no
# home-manager module, so this is a plain package install plus a raw config
# file (same style as tmux.conf); runtime state lives under
# ~/.local/share/herdr.
{ herdr, system, ... }:
{
  home.packages = [ herdr.packages.${system}.default ];

  # ~/.config/herdr/config.toml — tmux-matching keybindings.
  xdg.configFile."herdr/config.toml".source = ./herdr/config.toml;
}
