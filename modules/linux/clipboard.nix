# macOS-style clipboard commands on Wayland.
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.wl-clipboard ];

  programs.zsh.initContent = lib.mkAfter ''
    pbcopy()  { wl-copy --type text/plain "$@"; }
    pbpaste() { wl-paste "$@"; }
  '';
}
