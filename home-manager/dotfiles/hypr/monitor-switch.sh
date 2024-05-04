#!/bin/sh

if hyprctl monitors | grep Acer ; then
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/monitors-acer.conf ~/.config/hypr/monitors-live.conf
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/workspaces-acer.conf ~/.config/hypr/workspaces-live.conf
elif hyprctl monitors | grep LG ; then
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/monitors-ultrawide.conf ~/.config/hypr/monitors-live.conf
	ln -sf ~/flake-config/home-manager/dotfiles/hypr/workspaces-ultrawide.conf ~/.config/hypr/workspaces-live.conf
fi

