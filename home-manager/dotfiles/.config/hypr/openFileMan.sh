#!/bin/bash

workspaces=$(hyprctl workspaces)
current=$(hyprctl)
if [[  ]]

if [[ $workspaces =~ "special:fm" ]] then
  hyprctl dispatch togglespecialworkspace fm
else
  hyprctl dispatch exec [workspace special:fm] kitty ranger
  hyprctl dispatch togglespecialworkspace fm
fi

