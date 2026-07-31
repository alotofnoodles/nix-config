# Jujutsu VCS.
{ config, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      # Identity comes from git (core/git.nix) — single source of truth.
      user = config.programs.git.settings.user;

      # Bare `jj` shows the log instead of a wall of help text. The pager and
      # diff-formatter are set by programs.hunk.enableJujutsuIntegration
      # (apps/hunk.nix).
      ui.default-command = "log";

      # Push new bookmarks without needing --allow-new every time.
      git.push-new-bookmarks = true;

      # Short subcommand aliases: `jj s` = status, `jj d` = diff.
      aliases = {
        s = [ "status" ];
        d = [ "diff" ];
      };
    };
  };
}
