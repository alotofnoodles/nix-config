# tmux: package from nixpkgs, config kept as a raw file (reads exactly like
# the original instead of being translated to programs.tmux options; using
# programs.tmux would also fight over ~/.config/tmux/tmux.conf).
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.tmux ];

  # ~/.config/tmux/tmux.conf
  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;

  # AI dev layouts, cherry-picked from omanix apps/tmux.nix:
  #   t     — attach to (or create) the Work session
  #   tdl   — split the current tmux window into editor / AI / terminal panes
  #   tdlm  — one tdl window per subdirectory of the current dir
  programs.zsh = {
    shellAliases = {
      t = "tmux attach || tmux new -s Work";
      ic = "tdl claude";
    };

    initContent = lib.mkAfter ''
      # Create a Tmux Dev Layout with editor, ai, and terminal
      # Usage: tdl <ai_command> [<second_ai_command>]
      tdl() {
        [[ -z $1 ]] && { echo "Usage: tdl <ai_command> [<second_ai_command>]"; return 1; }
        [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

        local current_dir="''${PWD}"
        local editor_pane ai_pane ai2_pane
        local ai="$1"
        local ai2="$2"

        editor_pane="$TMUX_PANE"
        tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
        tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
        ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

        if [[ -n $ai2 ]]; then
          ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
          tmux send-keys -t "$ai2_pane" "$ai2" C-m
        fi

        tmux send-keys -t "$ai_pane" "$ai" C-m
        tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
        tmux select-pane -t "$editor_pane"
      }

      # Create multiple tdl windows, one per subdirectory
      # Usage: tdlm <ai_command> [<second_ai_command>]
      tdlm() {
        [[ -z $1 ]] && { echo "Usage: tdlm <ai_command> [<second_ai_command>]"; return 1; }
        [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }

        local ai="$1"
        local ai2="$2"
        local base_dir="$PWD"
        local first=true

        tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

        for dir in "$base_dir"/*/; do
          [[ -d $dir ]] || continue
          local dirpath="''${dir%/}"

          if $first; then
            tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
            first=false
          else
            local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
            tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
          fi
        done
      }
    '';
  };
}
