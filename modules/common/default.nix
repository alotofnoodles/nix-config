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

  programs.home-manager.enable = true;

  # Standard XDG dirs
  xdg.enable = true;
  xdg.configFile."nix/nix.conf".text = ''
    warn-dirty = false
  '';
}
