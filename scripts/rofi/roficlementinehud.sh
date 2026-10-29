#!/bin/sh
#Clementine Hud in rofi

confirm () {
	CONFIRMATION="$(echo "No|Yes|Back" | rofi -sep "|" -dmenu -i -l 3  -p "Confirm")" || exit 0

	case "$CONFIRMATION" in
		Yes) clementine -l / ;;
		Back) hud ;;
		*) exit 0 ;;
	esac
}

hud () {
	CHOICE="$(echo "Play/Pause|Next|Previous|Mute|Clear" | rofi -sep "|" -dmenu -i -l 5  -p "Choose action or enter a value to set volume (0-100)")"

	case "$CHOICE" in
		"") exit 0 ;;
		Play/Pause) clementine -t ;;
		Next) clementine -f ;;
		Previous) clementine -r ;;
		Mute) clementine -v 0 ;;
		Clear) confirm ;;
        	*) clementine -v $CHOICE ;;
	esac
}

hud
