#!/bin/sh

current="$(cat /sys/class/leds/*::kbd_backlight/brightness)"

if [[ "$current" -le "2" ]]; then
	brightnessctl -d \*::kbd_backlight set +33%
else
	brightnessctl -d \*::kbd_backlight set 0
fi

new="$(cat /sys/class/leds/*::kbd_backlight/brightness)"
osdval=$(echo "scale=2; $new/3" | bc)

echo "$osdval"

if [[ "$osdval" -eq "0" ]]; then
	osdval=0.001
fi

swayosd-client --custom-icon keyboard-brightness-symbolic --custom-progress "$osdval"


