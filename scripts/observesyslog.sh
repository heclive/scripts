#!/bin/sh
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"

opt=(	[1]="sudo apt-get install gconf-editor" 
	[2]="sudo apt-get install xinput" 
	[3]="tail -f /var/log/syslog"
	[q]="clear"
)

echo -e "Please choose:
	"$WHITE"[1]"$ENDCOLOR" install gconf-editor (gnome system controll app)
	"$WHITE"[2]"$ENDCOLOR" install xinput (for checking input devices)
	"$WHITE"[3]"$ENDCOLOR" observer syslog file ...
	"$RED"[q]"$ENDCOLOR" Quitt"
read -s -n 1 -p "Please choose from [1] - [3] .." number
${opt[$number]}

