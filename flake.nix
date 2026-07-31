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

    # claude-code: always-current packaging of Claude Code, ahead of nixpkgs.
    # Deliberately NOT following our nixpkgs: the claude-code.cachix.org cache
    # is only valid against its own pinned nixpkgs.
    claude-code.url = "github:sadjow/claude-code-nix";

    # try: ephemeral workspace manager (tobi/try; the nixpkgs `try` is an
    # unrelated tool). Ships its own home-manager module (programs.try),
    # configured in modules/apps/try.nix. Follows our nixpkgs — it's a plain
    # ruby script wrap, nothing cache-sensitive.
    try = {
      url = "github:tobi/try";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # herdr: terminal multiplexer for coding agents (herdr.dev; not in
    # nixpkgs). Built from source via its flake — no binary cache — so it
    # follows our nixpkgs to avoid carrying a second nixpkgs closure.
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      mkHome =
        { system, module }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          # `inputs` is the whole contract. modules/common/default.nix unpacks
          # what it needs via _module.args, and imports the home-manager modules
          # that ship with hunk/try itself — so a foreign flake importing
          # homeModules.common passes `inputs` and nothing else, and does not
          # re-declare those inputs.
          extraSpecialArgs = { inherit inputs; };
          modules = [ module ];
        };
    in
    {
      # Cross-platform modules, for consumption by other flakes (e.g. the work
      # Mac's separate config). Importers must also pass `inputs` through
      # extraSpecialArgs:
      #
      #   extraSpecialArgs = { inputs = nix-config.inputs; };
      #   modules = [ nix-config.homeModules.common ./hosts/work-mac.nix ];
      #
      # Everything reachable from here must evaluate on both x86_64-linux and
      # aarch64-darwin. Linux-only bits live in ./modules/linux.
      homeModules.common = ./modules/common;

      # Activate with:  home-manager switch --flake .#foomaxchu@pasokon
      homeConfigurations."foomaxchu@pasokon" = mkHome {
        system = "x86_64-linux";
        module = ./hosts/pasokon;
      };

    };
}
