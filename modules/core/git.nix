# Git.
{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      # Canonical identity; jujutsu (apps/jujutsu.nix) reads these same values.
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
}
