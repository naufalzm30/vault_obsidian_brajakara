#!/usr/bin/env bash
# Portable node finder — works with nvm, volta, fnm, or system install
if ! command -v node &>/dev/null; then
  # nvm
  [ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh"
  # volta
  [ -x "$HOME/.volta/bin/node" ] && export PATH="$HOME/.volta/bin:$PATH"
  # fnm
  command -v fnm &>/dev/null && eval "$(fnm env 2>/dev/null)"
fi

if ! command -v node &>/dev/null; then
  echo "Error: node not found (tried nvm, volta, fnm, PATH)" >&2
  exit 1
fi

exec node "$@"
