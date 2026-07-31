# Claude Code CLI.
{ claude-code, system, ... }:
{
  programs.claude-code = {
    enable = true;
    # Use sadjow/claude-code-nix instead of nixpkgs: tracks upstream releases
    # within hours and ships prebuilt via claude-code.cachix.org.
    package = claude-code.packages.${system}.default;
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
