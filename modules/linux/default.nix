# Linux-only Home Manager modules. Imported by pasokon, NOT part of
# homeModules.common — none of this evaluates usefully on darwin.
{ ... }:
{
  imports = [
    ./gc.nix
    ./clipboard.nix
    ./aliases.nix
  ];
}
