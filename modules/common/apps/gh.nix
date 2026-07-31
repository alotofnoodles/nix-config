# GitHub CLI as a configured program (from omanix apps/gh.nix) instead of a
# bare package, so its settings are declarative too.
{ ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };
}
