# Host-specific settings for "pasokon" (Arch Linux + Omarchy).
{ ... }:
{
  imports = [
    ../../modules/common
    ../../modules/linux
    ./claude.nix
    ./jellyfin.nix
  ];

  home.username = "foomaxchu";
  home.homeDirectory = "/home/foomaxchu";

  # Never change this after first activation; it is not "the version you run".
  # Per-host on purpose — the work Mac was first activated on 26.05.
  home.stateVersion = "25.05";

  # History file. The shared module sets sizes and options but leaves `path`
  # unset so each machine keeps its own file; this is the one zsh here already
  # writes to.
  programs.zsh.history.path = "$HOME/.zsh_history";

  # bash is still Omarchy-owned on this host, so tools that would inject a bash
  # hook are told not to. The work Mac makes its own choice.
  programs.direnv.enableBashIntegration = false;
  programs.starship.enableBashIntegration = false;

  # mise comes from Omarchy on this host, not Nix. The guarded `eval` in
  # modules/common/zsh/tool-inits.zsh activates whichever mise is on PATH.
  programs.mise.enable = false;
}
