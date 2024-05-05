#!/bin/sh

current="$(cat /sys/class/leds/*::kbd_backlight/brightness)"

if [[ "$current" -le "2" ]]; then
	brightnessctl -d \*::kbd_backlight set +33%
else
	brightnessctl -d \*::kbd_backlight set 0
fi
