# hunk: terminal-first diff viewer, pulled from its own flake (not in nixpkgs).
{ hunk, pkgs, ... }:
{
  programs.hunk = {
    enable = true;
    package = hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk;
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
}
