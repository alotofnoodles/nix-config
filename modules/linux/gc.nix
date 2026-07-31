# Weekly garbage collection via a systemd user timer (nix-gc.timer).
# Keeps 14 days of generations as rollback insurance; git history covers
# anything older.
#
# Linux-only: home-manager implements nix.gc as a systemd user unit, which has
# no standalone-HM equivalent on darwin. The work Mac therefore has no
# automatic GC; it still needs a darwin answer.
{ ... }:
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
