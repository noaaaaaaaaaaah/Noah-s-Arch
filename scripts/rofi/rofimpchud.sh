#!/bin/sh

FOLDER=$HOME/Music

add () { \
	case $(echo "Queue|Likes|Fuzzy|Sorted" | rofi -sep "|"  -dmenu -i -p "Select search engine" -lines 4) in
        	Queue) queue ;;
        	Likes) likes ;;
        	Fuzzy) fuzzy ;;
        	Sorted) sorted ;;
        	*) exit 0 ;;
	esac
}

name () { \
  NAME="$(echo "$(command ls "$FOLDER"/"$ARTIST"/"$ALBUM")" | rofi -dmenu -p "$ALBUM" -i -l 15)" || exit 0
  mpc add "$ARTIST"/"$ALBUM"/"$NAME"; mpc play >/dev/null 2>&1
}

sorted () { \
  ARTIST="$(echo "$(command ls $FOLDER)" | rofi -dmenu -i -p "Artiste" -lines 15)" || exit 0
  ALBUM="$(echo "$(command ls "$FOLDER"/"$ARTIST"/"")" | rofi -dmenu -p "$ARTIST" -i -l 15)" || exit 0
  CHOICE=$(
        echo "Play|Back|$(find "$FOLDER"/"$ARTIST"/"$ALBUM"/"" -type f -printf '%P|' | cut -d'|' -f2- | sort -n)" | rofi -sep "|" -dmenu -i -p "Play mode" -lines 15
  )
  case $CHOICE in
        "") exit 0 ;;
        Play) mpc add "$ARTIST"/"$ALBUM"; mpc play ;;
        Back) sorted ;;
        *) mpc add "$ARTIST"/"$ALBUM"/"$CHOICE"; mpc play >/dev/null 2>&1  ;;
  esac
}

fuzzy () { \
  FUZZY="$(find "$FOLDER" -name "*.jpg" -prune -o -type f -print | sort -nr | rofi -dmenu -i -keep-right -only-match  -p "All" -lines 15)" || exit0
  MPD_PATH="${FUZZY#"$FOLDER"/}"
  mpc add "$MPD_PATH"; mpc play
}

queue () { \
  GOTO="$(mpc playlist | rofi -dmenu -format i -p "Current queue")" || exit 0
  mpc play $(expr $GOTO + 1)
}

likes () { \
  CHOICE=$(
        echo "$(mpc playlist Likes)" | rofi -dmenu -format i -i -p "Likes" -lines 15
  )
  case $CHOICE in
        "") exit 0 ;;
        Play) mpc load Likes; mpc play ;;
        *) mpc load --range=$((CHOICE)):$((CHOICE+1)) Likes ; mpc play >/dev/null 2>&1  ;;
  esac
}

startup () {
	DMENU_RAN=$(if [ $(mpc status %random%) = 'on' ]; then echo "3"; else echo ''; fi)
	DMENU_LOOP=$(if [ $(mpc status %repeat%) = 'on' ]; then echo "4"; else echo ''; fi)
	DMENU_VOL=$(mpc volume)
	MPC_CURRENT=$(mpc current --format '%file%')
	IS_CURRENT_LIKE=''
	mpc -f '%file%' playlist Likes | grep -Fxq -- "$MPC_CURRENT" && IS_CURRENT_LIKE=8
	# Theme Elements
	status="`mpc status`"
	if [[ -z "$status" ]]; then
		prompt='Offline'
		mesg="MPD is Offline"
	else
		prompt="`mpc -f "%artist%" current`"
		mesg="`mpc -f "%title%" current` :: `mpc status | grep "#" | awk '{print $3}'`"
	fi	
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
	
        CHOICE="$(echo "Play/Pause|Next|Previous|Random|Loop|Mute|Clear|Update|Like|Library" | 
		rofi -sep "|" -dmenu -i -a 0:3 -u $DMENU_RAN,$DMENU_LOOP,$IS_CURRENT_LIKE -l 11 -mesg "${mesg}" -p  "Choose action or enter a value to set volume (0-100, currently $DMENU_VOL)")"
        case "$CHOICE" in
                "") exit 0 ;;
                Play/Pause) mpc toggle | startup ;;
		Library) add;;
		Random) mpc random | startup ;;
                Next) mpc next | startup ;;
                Previous) mpc cdprev | startup ;;
                Mute) mpc volume 0 ;;
                Clear) confirm ;;
		Update) mpc update | startup ;;
		Loop) mpc repeat | startup ;;
		Like) f=$(mpc current --format '%file%'); [ -z "$f" ] && exit 0; p=$(mpc -f '%file%' playlist Likes | awk -v f="$f" '$0==f {print NR; exit}'); if [ -n "$p" ]; then mpc delplaylist Likes "$p"; else mpc addplaylist Likes "$f"; fi | startup ;;
                *) mpc volume $CHOICE ;;
        esac
}

startup
