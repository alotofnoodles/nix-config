{
  description = "alotofnoodles Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stable nixpkgs used only by hunk below. Not for our own packages.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    # hunk: terminal-first diff viewer (not in nixpkgs, so pulled from its flake).
    # Pinned to stable nixpkgs, not ours: hunk's flake evaluates x86_64-darwin
    # outputs, which throw on current nixos-unstable (darwin support was dropped
    # in 26.11).
    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs, home-manager, hunk, ... }:
    let
      mkHome = { system, module }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          # Make the hunk flake input (and system) visible to modules.
          extraSpecialArgs = { inherit hunk system; };
          modules = [
            hunk.homeManagerModules.default
            ./modules/shared
            module
          ];
        };
    in
    {
      # Activate with:  home-manager switch --flake .#foomaxchu@pasokon
      homeConfigurations."foomaxchu@pasokon" = mkHome {
        system = "x86_64-linux";
        module = ./hosts/pasokon.nix;
      };
    };
}
