#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

ALIASES_SHORT=(
  "mon-start"
  "mon-stop"
)

ALIASES_LONG=(
  "second-mon-start"
  "second-mon-stop"
)

SCRIPTS=(
  "mon_start.sh"
  "mon_stop.sh"
)

detect_shell_config() {
  local shell_name
  shell_name="$(basename "${SHELL:-}")"

  case "$shell_name" in
    bash)  echo "${HOME}/.bashrc" ;;
    zsh)   echo "${HOME}/.zshrc" ;;
    fish)  echo "${HOME}/.config/fish/config.fish" ;;
    *)
      for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.config/fish/config.fish"; do
        [ -f "$f" ] && echo "$f" && return
      done
      echo "$HOME/.bashrc"
      ;;
  esac
}

alias_syntax() {
  local shell_name
  shell_name="$(basename "${SHELL:-}")"
  [ "$shell_name" = "fish" ] && echo "fish" || echo "posix"
}

SHELL_CONFIG="${SHELL_CONFIG:-$(detect_shell_config)}"
ALIAS_SYNTAX="$(alias_syntax)"

echo "Detected shell config: $SHELL_CONFIG"

mkdir -p "$INSTALL_DIR"

for i in "${!SCRIPTS[@]}"; do
  src="${SCRIPTS[$i]}"
  dest="$INSTALL_DIR/${ALIASES_LONG[$i]}"
  cp "$src" "$dest"
  chmod +x "$dest"
  echo "  Installed: $dest"
done

write_alias() {
  local name="$1"
  local command="$2"
  if [ "$ALIAS_SYNTAX" = "fish" ]; then
    echo "alias $name \"$command\"" >> "$SHELL_CONFIG"
  else
    echo "alias $name='$command'" >> "$SHELL_CONFIG"
  fi
}

{
  echo ""
  echo "# Second-monitor aliases"
  write_alias "${ALIASES_SHORT[0]}" "${INSTALL_DIR}/${ALIASES_LONG[0]}"
  write_alias "${ALIASES_SHORT[1]}" "${INSTALL_DIR}/${ALIASES_LONG[1]}"
  write_alias "${ALIASES_LONG[0]}"  "${INSTALL_DIR}/${ALIASES_LONG[0]}"
  write_alias "${ALIASES_LONG[1]}"  "${INSTALL_DIR}/${ALIASES_LONG[1]}"
}

echo ""
echo "Aliases added to $SHELL_CONFIG:"
echo "  ${ALIASES_SHORT[0]}  /  ${ALIASES_LONG[0]}  →  start secondary monitor"
echo "  ${ALIASES_SHORT[1]}  /  ${ALIASES_LONG[1]}  →  stop secondary monitor"
echo ""
echo "Reload your shell or run: source $SHELL_CONFIG"
