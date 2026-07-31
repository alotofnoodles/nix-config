# Claude Code CLI — shared package, per-host settings.
#
# This module installs the binary and nothing else. It does NOT write
# ~/.claude/settings.json, so each machine's Claude config stays independent:
#
#   * pasokon      — declarative, in hosts/pasokon/claude.nix
#   * work Mac     — hand-maintained real file (hooks, statusline, its own model
#                    choices), left alone entirely
#
# Two reasons this module must not touch settings:
#   1. On some machines ~/.claude/settings.json is a real file, not a Nix
#      symlink. A module claiming that path either fails activation or
#      destroys it.
#   2. Another home-manager module may already own
#      programs.claude-code.settings.env (e.g. to route the API through a
#      gateway). This module used to set that same `env` attribute for telemetry
#      flags, so the two would have fought. Leaving it unset keeps whichever
#      module owns it uncontested.
{
  claude-code,
  config,
  lib,
  pkgs,
  ...
}:
{
  # sadjow/claude-code-nix rather than nixpkgs: tracks upstream releases within
  # hours and ships prebuilt via claude-code.cachix.org.
  #
  # Guarded on programs.claude-code.enable so we don't install the binary twice:
  # a host that manages settings declaratively (pasokon) enables that module,
  # which installs its own copy. Hosts that don't (the work Mac) get it here.
  home.packages = lib.mkIf (!config.programs.claude-code.enable) [
    claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
