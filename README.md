# nix-config

Standalone [Home Manager](https://nix-community.github.io/home-manager/) flake
for managing dev tools and portable dotfiles on Arch Linux (Omarchy desktop).
Structure inspired by [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config),
adapted to standalone Home Manager (no NixOS/nix-darwin system layer).

## Layout

```
flake.nix                 # homeConfigurations."foomaxchu@pasokon"
hosts/pasokon.nix         # username, home dir, stateVersion
modules/shared/
  default.nix             # imports everything below
  packages.nix            # dev CLI tools installed via Nix
  programs.nix            # git, direnv (declarative HM programs)
  files.nix               # raw dotfiles wired into place
  config/                 # verbatim dotfiles (tmux, starship, inputrc)
```

## Scope

**Managed by Nix/HM:** dev CLI tools (ripgrep, fd, fzf, bat, eza, zoxide,
lazygit, gh, jq, delta, direnv, tmux, starship, …), git config, tmux, starship,
`.inputrc`.

**Deliberately NOT managed (leave to Omarchy / mise / apps):** Hyprland, waybar,
terminals, mako, walker and the rest of the Omarchy desktop; `.zshrc` / `.bashrc`
(Omarchy's shell + bash→zsh exec logic); Neovim (LazyVim manages its own plugin
lockfile); language runtimes (mise: node/go/python/ruby/bun).

## Usage

First activation (nix profile has home-manager available via the flake):

```sh
nix run home-manager/master -- switch --flake .#foomaxchu@pasokon
```

Subsequent changes:

```sh
home-manager switch --flake .#foomaxchu@pasokon
```

Preview a build without touching `~/`:

```sh
nix build .#homeConfigurations."foomaxchu@pasokon".activationPackage
```

Update inputs:

```sh
nix flake update
```

## Notes

- `direnv`'s shell hook is not auto-installed because Home Manager does not own
  your `.zshrc`. Add `eval "$(direnv hook zsh)"` to `~/.zshrc` once.
- Where a tool exists both via pacman and here, the Nix copy wins on PATH after
  activation (`~/.nix-profile/bin` is prepended by the HM session vars).
