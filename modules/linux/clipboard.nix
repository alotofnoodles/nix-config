# macOS-style clipboard commands on Wayland.
#
# Linux-only, and deliberately NOT in modules/common: on darwin `pbcopy` and
# `pbpaste` are real system binaries, and aliasing them to wl-copy/wl-paste
# would shadow the working clipboard.
#
# These are shell functions rather than aliases so they compose in pipelines
# and subshells the way the macOS binaries do (aliases are not expanded in
# non-interactive contexts, e.g. `xargs pbcopy` or inside a script).
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.wl-clipboard ];

  programs.zsh.initContent = lib.mkAfter ''
    pbcopy()  { wl-copy --type text/plain "$@"; }
    pbpaste() { wl-paste "$@"; }
  '';
}
