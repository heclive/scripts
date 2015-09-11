#!/bin/sh

clear
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
ENDCOLOR="\033[0m"
#------------------------------------------ARRAY
opt=(	[1]="./system/scripts/sources.sh" 
	[2]="sudo apt-get install gimp" 
	[3]="sudo dpkg -i /system/install/libre/DEBs/*.deb" 
	[4]="sudo dpkg -i /system/install/opera/*.deb"
	[5]="sudo apt-get install gconf-editor"
	[6]="sudo apt-get install xinput"
	[7]="tail -f /var/log/syslog"
	[8]="quitt"
)
#-----------------------------------------OPTIONEN MENU
menu () {
echo -e $WHITE"MENU:"$ENDCOLOR
echo -e $WHITE"[1]"$ENDCOLOR" correct sources.list"
echo -e $WHITE"[2]"$ENDCOLOR" install gimp"
echo -e $WHITE"[3]"$ENDCOLOR" install libre office"
echo -e $WHITE"[4]"$ENDCOLOR" install opera web browser"
echo -e $WHITE"[5]"$ENDCOLOR"install gconf-editor (gnome system controll app)"
echo -e $WHITE"[6]"$ENDCOLOR" install xinput (for checking input devices)"
echo -e $RED"[7]"$ENDCOLOR" observer syslog file ..."
echo -e $RED"[8]"$ENDCOLOR" Quitt"
read -s -n 1 -p "Please choose from [1] - [3] .." i
echo ""
}

#==============================================================Schleife
menu
until [ $i == ${#opt[@]} ]
do
	until [ ! "${opt[$i]}" == "" ] 
	do 	

		echo ""	
		read -s -n 1 -p "please enter a valid number (1 - "${#opt[@]}"):" i
		
	done
#=============================================================Pruefe Auswahl
	if [ $i == ${#opt[@]} ]
	then 
 	echo "exit"
	exit
	else
		echo ""
	fi 
#=============================================================starte Auswahl
	echo -e $YELLOW "==========>EXECUTING ......"$ENDCOLOR 
	echo "" 
	echo -e $YELLOW ${opt[$i]} $ENDCOLOR
	${opt[$i]}
	echo -e $GREEN "==========>DONE"$ENDCOLOR
	menu
	done
