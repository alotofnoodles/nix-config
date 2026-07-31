# zsh, owned by Home Manager.
#
# Background: Omarchy ships an `omarchy-zsh` package whose ~/.zshrc sources a
# framework from /usr/share/omarchy-zsh/shell/ (options, completion, plugins,
# fzf widgets, tool inits). We reproduce that "goodness" here so zsh is fully
# declarative and no longer depends on the omarchy-zsh package or its
# /usr/share files. Plugins come from nixpkgs, not the system.
#
# The shell-heavy parts live verbatim in ./zsh/*.zsh and are spliced in
# with readFile (so they read like normal zsh, with editor highlighting and
# linting, instead of escaped Nix strings). Ordering matters:
#   - tool-inits + fzf-widgets go in early (mkOrder 550) so the widgets are
#     defined before zsh-syntax-highlighting loads and thus get highlighted;
#   - options (completion zstyles etc.) go in late (mkAfter) so they run after
#     Home Manager's compinit and after the plugins.
#
# NOTE: enabling this makes HM write ~/.zshrc and ~/.zshenv. If Omarchy's copies
# are still in place, do the first switch with `-b bak` (backs them up) or
# `home-manager switch` will refuse to clobber them.
{ lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true; # runs compinit
    autosuggestion.enable = true; # gray inline history suggestion (accept with →)
    syntaxHighlighting.enable = true; # colors valid commands as you type; sourced last

    # EDITOR comes from omarchy's `envs`, not zoptions, so it stays here.
    sessionVariables.EDITOR = "nvim";

    initContent = lib.mkMerge [
      (lib.mkOrder 550 (builtins.readFile ./zsh/tool-inits.zsh))
      (lib.mkOrder 550 (builtins.readFile ./zsh/fzf-widgets.zsh))
      (lib.mkAfter (builtins.readFile ./zsh/options.zsh))
      # Aliases are managed in aliases.nix and rendered to a POSIX-neutral
      # fragment shared with bash. Source it last so aliases win.
      (lib.mkAfter ''
        [[ -f ~/.config/shell/aliases.sh ]] && source ~/.config/shell/aliases.sh
      '')
    ];
  };

  # fzf standard integration (Ctrl-R history, Ctrl-T files, Alt-C cd) plus
  # completion — self-contained from nixpkgs, replacing the /usr/share/fzf
  # sourcing omarchy used. Coexists with the custom widgets in fzf-widgets.zsh.
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # zoxide smart-jump (`z`, `zi`), self-contained from nixpkgs.
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ~/.inputrc  (readline, used by bash and other readline apps)
  home.file.".inputrc".source = ./inputrc;

  # ~/.local/bin on PATH (from omarchy's `envs`).
  home.sessionPath = [ "$HOME/.local/bin" ];
}
