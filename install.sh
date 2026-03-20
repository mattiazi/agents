#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── colours ────────────────────────────────────────────────────────────────
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

print_header() {
  echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${CYAN}║        Agent Installer v1.0          ║${RESET}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${RESET}\n"
}

print_step()  { echo -e "${BOLD}▶ $1${RESET}"; }
print_ok()    { echo -e "  ${GREEN}✔${RESET} $1"; }
print_warn()  { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
print_error() { echo -e "  ${RED}✖${RESET} $1"; }

# ── platform selection ──────────────────────────────────────────────────────
select_platform() {
  print_step "Select platform to install agents for:"
  echo -e "  ${BOLD}1)${RESET} Claude"
  echo -e "  ${BOLD}2)${RESET} Codex"
  echo -e "  ${BOLD}3)${RESET} Both"
  echo
  read -rp "  Choice [1-3] (default: 3): " choice
  choice="${choice:-3}"

  case "$choice" in
    1) PLATFORMS=("claude") ;;
    2) PLATFORMS=("codex") ;;
    3) PLATFORMS=("claude" "codex") ;;
    *) print_error "Invalid choice."; exit 1 ;;
  esac
}

# ── directory checks ────────────────────────────────────────────────────────
CLAUDE_BASE="$HOME/.claude"
CODEX_BASE="$HOME/.codex"

check_platform_dirs() {
  local valid_platforms=()

  for platform in "${PLATFORMS[@]}"; do
    if [[ "$platform" == "claude" ]]; then
      if [[ ! -d "$CLAUDE_BASE" ]]; then
        print_warn "~/.claude not found — skipping Claude agents."
      else
        valid_platforms+=("claude")
      fi
    elif [[ "$platform" == "codex" ]]; then
      if [[ ! -d "$CODEX_BASE" ]]; then
        print_warn "~/.codex not found — skipping Codex agents."
      else
        valid_platforms+=("codex")
      fi
    fi
  done

  if [[ ${#valid_platforms[@]} -eq 0 ]]; then
    print_error "No valid target directories found. Install aborted."
    exit 1
  fi

  PLATFORMS=("${valid_platforms[@]}")
}

# ── agent selection ─────────────────────────────────────────────────────────
select_agents() {
  local platform="$1"
  local source_dir="$SCRIPT_DIR/$platform"
  local all_agents=()

  while IFS= read -r f; do
    all_agents+=("$(basename "$f" .md)")
  done < <(find "$source_dir" -maxdepth 1 -name "*.md" | sort)

  echo
  print_step "Available agents for ${BOLD}$platform${RESET}:"
  for i in "${!all_agents[@]}"; do
    echo -e "  ${DIM}$((i+1)))${RESET} ${all_agents[$i]}"
  done
  echo -e "  ${DIM}a)${RESET} All (default)"
  echo
  read -rp "  Select agents (e.g. 1 3 5, or press Enter for all): " selection
  selection="${selection:-a}"

  if [[ "$selection" == "a" || "$selection" == "A" ]]; then
    SELECTED_AGENTS=("${all_agents[@]}")
  else
    SELECTED_AGENTS=()
    for idx in $selection; do
      if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#all_agents[@]} )); then
        SELECTED_AGENTS+=("${all_agents[$((idx-1))]}")
      else
        print_warn "Ignoring invalid selection: $idx"
      fi
    done

    if [[ ${#SELECTED_AGENTS[@]} -eq 0 ]]; then
      print_warn "No valid agents selected. Using all."
      SELECTED_AGENTS=("${all_agents[@]}")
    fi
  fi
}

# ── install ─────────────────────────────────────────────────────────────────
install_agents() {
  local platform="$1"
  local source_dir="$SCRIPT_DIR/$platform"
  local dest_dir

  if [[ "$platform" == "claude" ]]; then
    dest_dir="$CLAUDE_BASE/agents"
  else
    dest_dir="$CODEX_BASE/agents"
  fi

  mkdir -p "$dest_dir"

  echo
  print_step "Installing ${BOLD}$platform${RESET} agents → ${DIM}$dest_dir${RESET}"

  local count=0
  for agent in "${SELECTED_AGENTS[@]}"; do
    local src="$source_dir/$agent.md"
    if [[ -f "$src" ]]; then
      cp "$src" "$dest_dir/$agent.md"
      print_ok "$agent"
      (( count++ )) || true
    else
      print_warn "$agent.md not found in $source_dir, skipped."
    fi
  done

  echo -e "\n  ${GREEN}${BOLD}$count agent(s) installed for $platform.${RESET}"
}

# ── main ────────────────────────────────────────────────────────────────────
print_header
select_platform
check_platform_dirs

for platform in "${PLATFORMS[@]}"; do
  select_agents "$platform"
  install_agents "$platform"
done

echo -e "\n${GREEN}${BOLD}Done!${RESET}\n"
