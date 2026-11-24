#!/usr/bin/env bash
#Bread on penguins Dmenu notes setup port to Rofi
folder=$HOME/Notes/
editor=nano
terminal=alacritty

new () { \
	dir="$(command ls -d "$folder" "$folder"*/ | rofi -dmenu -lines 5 -i -p 'Choose directory')"|| exit 0
	: "${dir:=$folder}" #if dir is empty, default to note folder
	name="$(echo "" | rofi -dmenu -p "Enter a name")"
	: "${name:=$(date +%F_%H-%M-%S)}" #if no name is inputed, default to date
	setsid -f "$terminal" -e "$editor" $dir$name".md" >/dev/null 2>&1
}

selected () { \
  choice=$(
    echo "New|$(find $folder -type f -printf '%T@ %P|' | sort -nr | cut -d' ' -f2-)" | rofi -sep "|" -dmenu -lines 5 -i -p "Choose note or create new "
  )
  case $choice in
    New) new ;;
    *.md) setsid -f "$terminal" -e "$editor" "$folder$choice" >/dev/null 2>&1 ;;
    *) exit ;;
  esac
}

selected
