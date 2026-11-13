#!/bin/sh

startup () {
	DMENU_RAN=$(if [ $(mpc status %random%) = 'on' ]; then echo "3"; else echo ''; fi)
	DMENU_LOOP=$(if [ $(mpc status %repeat%) = 'on' ]; then echo "4"; else echo ''; fi)
	DMENU_VOL=$(mpc volume)
	MPC_CURRENT=$(mpc current --format '%file%')
	IS_CURRENT_LIKE=''
	mpc -f '%file%' playlist Likes | grep -Fxq -- "$MPC_CURRENT" && IS_CURRENT_LIKE=8
	hud
}

confirm () {
        CONFIRMATION="$(echo "No|Yes|Back" | rofi -sep "|" -dmenu -u 1 -i -l 3  -p "Confirm")" || exit 0

        case "$CONFIRMATION" in
                Yes) mpc clear ;;
                Back) hud ;;
                *) exit 0 ;;
        esac
}

hud () {
        CHOICE="$(echo "Play/Pause|Next|Previous|Random|Loop|Mute|Clear|Update|Like" | rofi -sep "|" -dmenu -i -a 0:3 -u $DMENU_RAN,$DMENU_LOOP,$IS_CURRENT_LIKE -l 9 -p  "Choose action or enter a value to set volume $IS_CURRENT_LIKE (0-100, currently $DMENU_VOL)")"

        case "$CHOICE" in
                "") exit 0 ;;
                Play/Pause) mpc toggle | startup ;;
		Random) mpc random | startup ;;
                Next) mpc next | startup ;;
                Previous) mpc prev | startup ;;
                Mute) mpc volume 0 ;;
                Clear) confirm ;;
		Update) mpc update | startup ;;
		Loop) mpc repeat | startup ;;
		Like) f=$(mpc current --format '%file%'); [ -z "$f" ] && exit 0; p=$(mpc -f '%file%' playlist Likes | awk -v f="$f" '$0==f {print NR; exit}'); if [ -n "$p" ]; then mpc delplaylist Likes "$p"; else mpc addplaylist Likes "$f"; fi ;;
                *) mpc volume $CHOICE ;;
        esac
}

startup
