#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
SHELL_CONFIG="${SHELL_CONFIG:-$HOME/.bashrc}"

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

echo "Installing second-monitor scripts..."

mkdir -p "$INSTALL_DIR"

for i in "${!SCRIPTS[@]}"; do
  src="${SCRIPTS[$i]}"
  dest="$INSTALL_DIR/${ALIASES_LONG[$i]}"
  cp "$src" "$dest"
  chmod +x "$dest"
  echo "  Installed: $dest"
done

echo "" >> "$SHELL_CONFIG"
echo "# Second-monitor aliases" >> "$SHELL_CONFIG"
echo "alias ${ALIASES_SHORT[0]}='${INSTALL_DIR}/${ALIASES_LONG[0]}'" >> "$SHELL_CONFIG"
echo "alias ${ALIASES_SHORT[1]}='${INSTALL_DIR}/${ALIASES_LONG[1]}'" >> "$SHELL_CONFIG"
echo "alias ${ALIASES_LONG[0]}='${INSTALL_DIR}/${ALIASES_LONG[0]}'" >> "$SHELL_CONFIG"
echo "alias ${ALIASES_LONG[1]}='${INSTALL_DIR}/${ALIASES_LONG[1]}'" >> "$SHELL_CONFIG"

echo ""
echo "Aliases added to $SHELL_CONFIG:"
echo "  ${ALIASES_SHORT[0]}  /  ${ALIASES_LONG[0]}  →  start secondary monitor"
echo "  ${ALIASES_SHORT[1]}  /  ${ALIASES_LONG[1]}  →  stop secondary monitor"
echo ""
echo "Reload your shell or run: source $SHELL_CONFIG"
