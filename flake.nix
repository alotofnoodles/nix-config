{
  description = "Standalone Home Manager config (Arch + Omarchy). Structure inspired by dustinlyons/nixos-config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      mkHome = { system, module }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
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
