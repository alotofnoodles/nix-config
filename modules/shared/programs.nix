# Programs configured declaratively (as opposed to raw dotfiles in files.nix).
{ pkgs, hunk, system, ... }:
{
  # ── hunk ─────────────────────────────────────────────────────────────────
  # Terminal-first diff viewer from github:modem-dev/hunk. The module's default
  # package is `pkgs.hunk` (absent from nixpkgs), so point it at the flake's own
  # build. Settings render to ~/.config/hunk/config.toml.
  programs.hunk = {
    enable = true;
    package = hunk.packages.${system}.hunk;
    settings = {
      theme = "graphite";
      mode = "split";
      line_numbers = true;
    };
    # Hunk is the pager for both git and jj (the jj toggle also sets
    # ui.diff-formatter = ":git" so jj emits diffs hunk can render).
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };

  # ── Git ──────────────────────────────────────────────────────────────────
  # Translated from your ~/.config/git/config. Home Manager writes this file,
  # so edit it here from now on, not in ~/.config/git/config.
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Will Djingga";
        email = "will@alotofnoodles.com";
      };

      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
      };

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

  # delta stays available as a standalone CLI (see packages.nix) but is no
  # longer the git pager — hunk is (programs.hunk.enableGitIntegration above).

  # ── jj (jujutsu) ─────────────────────────────────────────────────────────
  # Git-compatible VCS. Settings render to ~/.config/jj/config.toml.
  # NB: `home.packages = [ pkgs.jj ]` would install an unrelated JSON tool;
  # this module installs pkgs.jujutsu, whose binary is also called `jj`.
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Will Djingga";
        email = "will@alotofnoodles.com";
      };

      # Bare `jj` shows the log instead of a wall of help text. The pager and
      # diff-formatter are set by programs.hunk.enableJujutsuIntegration above.
      ui.default-command = "log";

      # Push new bookmarks without needing --allow-new every time.
      git.push-new-bookmarks = true;
    };
  };

  # ── Claude Code ──────────────────────────────────────────────────────────
  # Installs the CLI and renders ~/.claude/settings.json. Home Manager writes
  # settings.json as a read-only symlink, so in-app changes that target user
  # settings (/config, user-level "always allow") can't save — edit here and
  # `hms` instead. Project-level .claude/settings.local.json and runtime state
  # in ~/.claude.json are untouched and stay writable.
  programs.claude-code = {
    enable = true;
    settings = {
      model = "claude-fable-5[1m]";
      effortLevel = "medium";
      statusLine = {
        type = "command";
        command = "bash ~/.claude/statusline-command.sh";
      };
      tui = "fullscreen";
      theme = "auto";
      editorMode = "vim";
      skipDangerousModePermissionPrompt = true;
    };
  };
  # The statusline script referenced above, kept in-repo.
  home.file.".claude/statusline-command.sh".source = ./claude/statusline-command.sh;

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
