#!/bin/bash 
#Bread on penguins Dmenu powermenu setup port to Rofi

case "$(printf "kill\nsleep\nreboot\nshutdown" | rofi -dmenu -p "powermenu" -i -lines 4)" in
	kill) ps -u "$USER" -o pid,comm,%cpu,%mem | rofi -dmenu -i -c -lines 10 -p "kill" | awk '{print $1}' | xargs -r kill ;;
	sleep) systemctl suspend -i ;;
	reboot) systemctl reboot -i ;;
	shutdown) systemctl poweroff ;;
	*) exit 1 ;;
esac
