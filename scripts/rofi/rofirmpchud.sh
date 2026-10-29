#!/bin/sh
#Rofi client for RMPC control

DMENU_RAN=$(if [ $(mpc status %random%) = 'on' ]; then echo "3"; else echo ''; fi)
DMENU_LOOP=$(if [ $(mpc status %repeat%) = 'on' ]; then echo "4"; else echo ''; fi)
DMENU_VOL=$(mpc volume)

confirm () {
        CONFIRMATION="$(echo "No|Yes|Back" | rofi -sep "|" -dmenu -u 1 -i -l 3  -p "Confirm")" || exit 0

        case "$CONFIRMATION" in
                Yes) rmpc clear ;;
                Back) hud ;;
                *) exit 0 ;;
        esac
}

hud () {
        CHOICE="$(echo "Play/Pause|Next|Previous|Random|Loop|Mute|Clear|Update" | rofi -sep "|" -dmenu -i -a 0:3 -u $DMENU_RAN,$DMENU_LOOP -l 8 -p "Choose action or enter a value to set volume (0-100, currently $DMENU_VOL)")"

        case "$CHOICE" in
                "") exit 0 ;;
                Play/Pause) rmpc togglepause ;;
		Random) rmpc togglerandom ;;
                Next) rmpc next ;;
                Previous) rmpc prev ;;
                Mute) rmpc volume 0 ;;
                Clear) confirm ;;
		Update) rmpc update ;;
		Loop) rmpc togglerepeat ;;
                *) rmpc volume $CHOICE ;;
        esac
}

hud
