#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/claude"
DEST_DIR="$HOME/.claude/agents"

# ── colours ────────────────────────────────────────────────────────────────
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

print_step()  { echo -e "${BOLD}▶ $1${RESET}"; }
print_ok()    { echo -e "  ${GREEN}✔${RESET} $1"; }
print_warn()  { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
print_error() { echo -e "  ${RED}✖${RESET} $1"; }

echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${CYAN}║        Agent Installer v1.0          ║${RESET}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${RESET}\n"

if [[ ! -d "$HOME/.claude" ]]; then
  print_error "~/.claude not found — is Claude Code installed? Install aborted."
  exit 1
fi

# ── agent selection ─────────────────────────────────────────────────────────
all_agents=()
while IFS= read -r f; do
  all_agents+=("$(basename "$f" .md)")
done < <(find "$SOURCE_DIR" -maxdepth 1 -name "*.md" | sort)

print_step "Available agents:"
for i in "${!all_agents[@]}"; do
  echo -e "  ${DIM}$((i+1)))${RESET} ${all_agents[$i]}"
done
echo -e "  ${DIM}a)${RESET} All (default)"
echo
read -rp "  Select agents (e.g. 1 3 5, or press Enter for all): " selection
selection="${selection:-a}"

selected_agents=()
if [[ "$selection" =~ ^[aA]$ ]]; then
  selected_agents=("${all_agents[@]}")
else
  for idx in $selection; do
    if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#all_agents[@]} )); then
      selected_agents+=("${all_agents[$((idx-1))]}")
    else
      print_warn "Ignoring invalid selection: $idx"
    fi
  done

  if [[ ${#selected_agents[@]} -eq 0 ]]; then
    print_warn "No valid agents selected. Using all."
    selected_agents=("${all_agents[@]}")
  fi
fi

# ── install ─────────────────────────────────────────────────────────────────
mkdir -p "$DEST_DIR"

echo
print_step "Installing agents → ${DIM}$DEST_DIR${RESET}"

count=0
for agent in "${selected_agents[@]}"; do
  cp "$SOURCE_DIR/$agent.md" "$DEST_DIR/$agent.md"
  print_ok "$agent"
  (( ++count ))
done

echo -e "\n${GREEN}${BOLD}Done — $count agent(s) installed.${RESET}\n"
