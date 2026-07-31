# Claude Code settings for pasokon.
#
# Host-specific by design: the shared module (modules/common/apps/claude.nix)
# installs the binary only, so each machine owns its own ~/.claude/settings.json.
# The work Mac keeps a hand-maintained file with different models, hooks and a
# different statusline; nothing here reaches it.
{ claude-code, pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      model = "claude-opus-4-8";
      effortLevel = "medium";
      statusLine = {
        type = "command";
        command = "bash ~/.claude/statusline-command.sh";
      };
      tui = "fullscreen";
      theme = "auto";
      editorMode = "vim";
      skipDangerousModePermissionPrompt = true;

      # Disable telemetry declaratively: no Statsig usage metrics, no Sentry
      # error reports. (Essential traffic — the API itself, updates — is kept.)
      env = {
        DISABLE_TELEMETRY = "1";
        DISABLE_ERROR_REPORTING = "1";
      };
    };
  };

  # The statusline script referenced above, kept in-repo.
  home.file.".claude/statusline-command.sh".source = ./claude/statusline-command.sh;
}
