#!/usr/bin/env bash
if command -v fastfetch >/dev/null 2>&1 && [ -f /etc/fastfetch.jsonc ]; then
  fastfetch --config /etc/fastfetch.jsonc
fi
if [ -f ~/.Xauthority ]; then
  xauth merge ~/.Xauthority
fi
export XAUTHORITY=$HOME/.Xauthority

