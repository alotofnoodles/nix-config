# Programs configured declaratively (as opposed to raw dotfiles in files.nix).
{ pkgs, ... }:
{
  # ── Git ──────────────────────────────────────────────────────────────────
  # Translated from your ~/.config/git/config. Home Manager writes this file,
  # so edit it here from now on, not in ~/.config/git/config.
  programs.git = {
    enable = true;
    userName = "Will Djingga";
    userEmail = "will@alotofnoodles.com";

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
    };

    # Prettier diffs, replacing the default pager.
    delta = {
      enable = true;
      options.navigate = true;
    };

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
      };
      commit.verbose = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "-version:refname";
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };

  # ── direnv ───────────────────────────────────────────────────────────────
  # nix-direnv gives fast, cached `use flake` / `use nix` environments.
  # NOTE: your shell (zsh/.bashrc) is managed by Omarchy, not Home Manager, so
  # the hook is not auto-installed. Add ONE of these to your ~/.zshrc:
  #     eval "$(direnv hook zsh)"
  # (bash:  eval "$(direnv hook bash)")
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = false; # HM does not own your .zshrc
    enableBashIntegration = false;
  };
}
