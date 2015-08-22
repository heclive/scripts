#!/bin/sh

clear
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"

				# PROGRAMM START
			# Quelliste fuer Packetmanager 

IP="46.101.188.218"
REP1="deb http://ftp.de.debian.org/debian squeeze main"
REP2="" #deb http://http.kali.org/kali kali main non-free contrib"
REP3="" #deb http://security.kali.org/kali-security kali/updates main contrib non-free"
REP4="" #deb-src http://http.kali.org/kali kali main non-free contrib"
REP5="" #deb-src http://security.kali.org/kali-security kali/updates main contrib non-free"

echo -e $WHITE"Are you allready logged in ? (hiyamobile@digitalocean.com [46.101.188.218]) [y/n]"$ENDCOLOR
read -s -n 1 log

#=================================================================================================LOGGED IN?
#Schleife 
	until [ $log = "y" -o $log = "n" ]
	do	
		read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" log
		echo ""	
	done
#----------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------> NO
	if [ $log = "n" ]  
	then ssh root@$IP
	exit
	else echo ""
	fi
#------------------------------------------------------------------------------------------------> ELSE
echo -e $WHITE"Checking Server status ...."$ENDCOLOR
ps aux | grep odoo


#=================================================================================================> START SERVER?
echo -e $WHITE"Start Server? [y/n]"$ENDCOLOR
read  -s -n 1 start
#Schleife
	until [ $start = "n" -o $start = "y" ]
	do
		echo ""			
		read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" start
	done
#--------------------------------------------------------------------------------
	if [ $start = "y" ]
	then	sudo service odoo-server start
		echo ""
		echo -e $GREEN"Odoo Server Started"$ENDCOLOR			
	else echo ""
	fi			

