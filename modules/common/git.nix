# Git.
{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      # Canonical identity; jujutsu (apps/jujutsu.nix) reads these same values,
      # so a host overriding the email here flows through to jj automatically.
      #
      # The email is the personal default. A host that needs a different identity
      # overrides it in its own host file with:
      #   programs.git.settings.user.email = lib.mkForce "…";
      # mkForce is needed because this is a plain value, not a mergeable list.
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
