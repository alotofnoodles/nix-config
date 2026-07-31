# btop as a configured program (from omanix apps/btop.nix, minus the
# build-time theming — Omarchy owns theming on this machine).
{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      vim_keys = true;
    };
  };
}
