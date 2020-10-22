#!/bin/bash

if [[ $(uname -s) == "Linux" ]] && command -v xcape >/dev/null && command -v setxkbmap >/dev/null; then
  setxkbmap -option 'caps:ctrl_modifier'
  xcape -e 'Caps_Lock=Escape;Control_L=Escape;Control_R=Escape'
fi
