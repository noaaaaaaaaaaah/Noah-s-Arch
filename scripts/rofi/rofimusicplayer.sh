#!/usr/bin/env bash

FOLDER=$HOME/Music

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
	echo "$(mpc playlist Likes)" | rofi -sep "|" -dmenu -i -p "Likes" -lines 15
  )
  case $CHOICE in
	"") exit 0 ;;
	Play) mpc load Likes; mpc play ;;
	*) mpc add "$CHOICE"; mpc play >/dev/null 2>&1  ;;
  esac
}

case $(echo "Queue|Likes|Fuzzy|Sorted" | rofi -sep "|"  -dmenu -i -p "Select search engine" -lines 4) in
	Queue) queue ;;
  Likes) likes ;;
	Fuzzy) fuzzy ;;
	Sorted) sorted ;;
	*) exit 0 ;;
esac
