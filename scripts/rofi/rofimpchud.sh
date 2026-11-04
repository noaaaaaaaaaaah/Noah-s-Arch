#!/bin/sh

DMENU_RAN=$(if [ $(mpc status %random%) = 'on' ]; then echo "3"; else echo ''; fi)
DMENU_LOOP=$(if [ $(mpc status %repeat%) = 'on' ]; then echo "4"; else echo ''; fi)
DMENU_VOL=$(mpc volume)

confirm () {
        CONFIRMATION="$(echo "No|Yes|Back" | rofi -sep "|" -dmenu -u 1 -i -l 3  -p "Confirm")" || exit 0

        case "$CONFIRMATION" in
                Yes) mpc clear ;;
                Back) hud ;;
                *) exit 0 ;;
        esac
}

hud () {
        CHOICE="$(echo "Play/Pause|Next|Previous|Random|Loop|Mute|Clear|Update" | rofi -sep "|" -dmenu -i -a 0:3 -u $DMENU_RAN,$DMENU_LOOP -l 8 -p "Choose action or enter a value to set volume (0-100, currently $DMENU_VOL)")"

        case "$CHOICE" in
                "") exit 0 ;;
                Play/Pause) mpc toggle ;;
		Random) mpc random ;;
                Next) mpc next ;;
                Previous) mpc prev ;;
                Mute) mpc volume 0 ;;
                Clear) confirm ;;
		Update) mpc update ;;
		Loop) mpc repeat ;;
                *) mpc volume $CHOICE ;;
        esac
}

hud
