#!/usr/bin/env bash

FOLDER=$HOME/Public/Music

name () { \
  NAME="$(echo "$(command ls "$FOLDER"/"$ARTIST"/"$ALBUM")" | rofi -dmenu -p "$ALBUM" -i -l 15)" || exit 0
  mpc add "$FOLDER"/"$ARTIST"/"$ALBUM"/"$NAME"; mpc play >/dev/null 2>&1
}

sorted () { \
  ARTIST="$(echo "$(command ls $FOLDER)" | rofi -dmenu -i -p "Artiste" -lines 15)" || exit 0
  ALBUM="$(echo "$(command ls "$FOLDER"/"$ARTIST"/"")" | rofi -dmenu -p "$ARTIST" -i -l 15)" || exit 0
  CHOICE=$(
	echo "Back|Play|$(find "$FOLDER"/"$ARTIST"/"$ALBUM"/"" -type f -printf '%P|' | cut -d'|' -f2- | sort -n)" | rofi -sep "|" -dmenu -i -p "Play mode" -lines 15
  )
  case $CHOICE in
	"") exit 0 ;;
	Back) sorted ;;
	Play) mpc add "$FOLDER"/"$ARTIST"/"$ALBUM"; mpc play ;;
	*) mpc add "$FOLDER"/"$ARTIST"/"$ALBUM"/"$CHOICE"; mpc play >/dev/null 2>&1  ;;
  esac
}

fuzzy () { \
  FUZZY="$(find "$FOLDER" -name "*.jpg" -prune -o -type f | sort -nr | rofi -dmenu -i -keep-right -only-match  -p "All" -lines 15)" || exit0
  mpc add "$FUZZY"; mpc play
}

case $(echo "Fuzzy|Sorted" | rofi -sep "|"  -dmenu -i -p "Select search engine" -lines 2) in
	Fuzzy) fuzzy ;;
	Sorted) sorted ;;
	*) exit 0 ;;
esac
