# Entry point for all Home Manager modules, imported by every host.
# Layout follows omanix's organisation: core (shell, git, CLI basics),
# apps (per-app modules), terminal (prompt and terminal-adjacent config).
{ ... }:
{
  imports = [
    ./zsh.nix
    ./aliases.nix
    ./git.nix
    ./packages.nix
    ./apps/herdr.nix
    ./apps/tmux.nix
    ./apps/try.nix
    ./apps/claude.nix
    ./apps/direnv.nix
    ./apps/gh.nix
    ./apps/jujutsu.nix
    ./apps/hunk.nix
    ./apps/btop.nix
    ./terminal/starship.nix
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

  # ~/.config/nix/nix.conf  (user-level; system config is Determinate's
  # /etc/nix/nix.conf). warn-dirty silences the "Git tree has uncommitted
  # changes" warning, which fires constantly under jj since git HEAD always
  # trails the working-copy change.
  xdg.configFile."nix/nix.conf".text = ''
    warn-dirty = false
  '';
}
