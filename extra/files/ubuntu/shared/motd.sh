#!/usr/bin/env bash
fastfetch --config /etc/fastfetch.jsonc
if [ -f ~/.Xauthority ]; then
  xauth merge ~/.Xauthority
fi
export XAUTHORITY=$HOME/.Xauthority

