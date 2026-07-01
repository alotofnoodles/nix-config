# Shared Home Manager configuration, imported by every host.
{ ... }:
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./files.nix
  ];

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Standard XDG dirs; keeps generated config under ~/.config as expected.
  xdg.enable = true;
}
