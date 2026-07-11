# Programs configured declaratively (as opposed to raw dotfiles in files.nix).
{ pkgs, hunk, claude-code, system, ... }:
{
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

  programs.claude-code = {
    enable = true;
    # Use sadjow/claude-code-nix instead of nixpkgs: tracks upstream releases
    # within hours and ships prebuilt via claude-code.cachix.org.
    package = claude-code.packages.${system}.default;
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
