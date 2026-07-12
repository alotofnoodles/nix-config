# Shared Home Manager configuration, imported by every host.
{ ... }:
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./files.nix
    ./aliases.nix
  ];

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Weekly garbage collection via a systemd user timer (nix-gc.timer).
  # Keeps 14 days of generations as rollback insurance; git history covers
  # anything older.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Standard XDG dirs; keeps generated config under ~/.config as expected.
  xdg.enable = true;
}
