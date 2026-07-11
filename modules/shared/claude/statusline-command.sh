#!/usr/bin/env bash
# Claude Code status line - mirrors Starship prompt style

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Truncate directory: show last 2 components, with …/ prefix if truncated
truncated_dir() {
  local dir="$1"
  # Replace $HOME with ~
  dir="${dir/#$HOME/~}"
  # Split by / and keep last 2 parts
  local parts
  IFS='/' read -ra parts <<< "$dir"
  local count=${#parts[@]}
  if [ "$count" -le 2 ]; then
    echo "$dir"
  else
    echo "…/${parts[$((count-2))]}/${parts[$((count-1))]}"
  fi
}

dir=$(truncated_dir "$cwd")

# Git info (skip lock acquisition to avoid blocking)
git_branch=""
git_status=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

  # Gather git status indicators
  git_flags=""
  git_status_output=$(git -C "$cwd" status --porcelain 2>/dev/null)

  untracked=$(echo "$git_status_output" | grep -c '^??' || true)
  modified=$(echo "$git_status_output" | grep -c '^.M\|^M.' || true)
  staged=$(echo "$git_status_output" | grep -c '^[ADMRC]' || true)

  [ "$untracked" -gt 0 ] && git_flags="${git_flags}? "
  [ "$modified" -gt 0 ] && git_flags="${git_flags} "
  [ "$staged" -gt 0 ] && git_flags="${git_flags} "

  ahead=$(git -C "$cwd" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  behind=$(git -C "$cwd" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
  [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ] && git_flags="${git_flags}⇕⇡${ahead}⇣${behind} "
  [ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ] && git_flags="${git_flags}⇡${ahead} "
  [ "$behind" -gt 0 ] && [ "$ahead" -eq 0 ] && git_flags="${git_flags}⇣${behind} "

  git_status="$git_flags"
fi

# Context usage
ctx_part=""
if [ -n "$used_pct" ]; then
  ctx_part=" | ctx:$(printf '%.0f' "$used_pct")%"
fi

# Session cost
cost_part=""
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$total_cost" ] && [ "$total_cost" != "0" ]; then
  cost_part=" | \$$(printf '%.4f' "$total_cost")"
fi

# Build output with cyan color (ANSI 36)
CYAN='\033[0;36m'
RESET='\033[0m'

parts="${dir}"
[ -n "$git_branch" ] && parts="${parts} ${git_branch}"
[ -n "$git_status" ] && parts="${parts} ${git_status}"

printf "${CYAN}[${parts}]${RESET} %s%s%s" "$model" "$ctx_part" "$cost_part"
