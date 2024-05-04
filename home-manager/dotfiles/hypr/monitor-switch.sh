#!/bin/sh
icon=/run/current-system/sw/share/icons/hicolor/1024x1024/apps/nix-snowflake.png
monitors="$(hyprctl monitors)"
#if echo ${monitors} | grep Acer ; then
if true; then
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/monitors-acer.conf ~/.config/hypr/monitors-live.conf
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/workspaces-acer.conf ~/.config/hypr/workspaces-live.conf
	notify-send --transient --icon=computer-symbolic "  Monitor Configuration" "  Acer Monitor Activated"
elif echo $monitors | grep LG ; then
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/monitors-ultrawide.conf ~/.config/hypr/monitors-live.conf
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/workspaces-ultrawide.conf ~/.config/hypr/workspaces-live.conf
	notify-send --transient --icon=computer-symbolic "  Monitor Configuration" "  LG Ultrawide Monitor Activated"
else
	notify-send --transient --icon=software-update-urgent-symbolic "  Monitor Configuration" "  No pre-configured monitors detected!"
fi

