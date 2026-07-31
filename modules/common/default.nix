# Cross-platform Home Manager modules, exported as `homeModules.common`.
#
# Everything reachable from here must evaluate on BOTH x86_64-linux and
# aarch64-darwin — the work Mac imports this module out of a separate flake.
# Linux-only settings live in ../linux instead.
#
# This module is self-contained: it supplies its own module arguments from
# `inputs` via _module.args, so an importing flake only has to pass `inputs`
# and does not re-declare hunk/herdr/claude-code/try.
{ inputs, ... }:
{
  imports = [
    # Home Manager modules that ship with our flake inputs. These live here
    # rather than in flake.nix's `modules` list so that importing
    # homeModules.common brings them along.
    inputs.hunk.homeManagerModules.default
    inputs.try.homeModules.default

    ./zsh.nix
    ./aliases.nix
    ./git.nix
    ./packages.nix
    ./apps/herdr.nix
    ./apps/tmux.nix
    ./apps/try.nix
    ./apps/claude.nix
    ./apps/direnv.nix
    ./apps/gh.nix
    ./apps/jujutsu.nix
    ./apps/hunk.nix
    ./apps/btop.nix
    ./terminal/starship.nix
  ];

  # Flake inputs the modules below need as arguments. Declaring them here
  # (rather than in flake.nix's extraSpecialArgs) is what makes this module
  # importable by a foreign flake: the importer passes `inputs` and nothing
  # else. `system` is deliberately absent — modules read
  # pkgs.stdenv.hostPlatform.system, which is always in scope.
  _module.args = {
    inherit (inputs) hunk claude-code herdr;
  };

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Standard XDG dirs; keeps generated config under ~/.config as expected.
  xdg.enable = true;

  # ~/.config/nix/nix.conf  (user-level; on pasokon the system config is
  # Determinate's /etc/nix/nix.conf). warn-dirty silences the "Git tree has
  # uncommitted changes" warning, which fires constantly under jj since git HEAD
  # always trails the working-copy change.
  xdg.configFile."nix/nix.conf".text = ''
    warn-dirty = false
  '';
}
