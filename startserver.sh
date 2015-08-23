#!/bin/bash

clear
				# PROGRAMM START
			# Quelliste fuer Packetmanager 

IP="46.101.188.218"
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"

echo ""
echo -e $WHITE"Allready Logged in to [46.101.188.218]? [y/n]"$ENDCOLOR
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
	else echo ""
	exit
	fi
#------------------------------------------------------------------------------------------------> ELSE
echo -e $WHITE"Odoo Server status ...."$ENDCOLOR
ps aux | grep odoo


#=================================================================================================> START SERVER?
echo -e $WHITE"Please Choose:"
echo "1.) Start Server"
echo -e "2.) Stop Server"$ENDCOLOR
read  -s -n 1 start
#Schleife
	until [ $start = "1" -o $start = "2" ]
	do
		echo ""			
		read -s -n 1 -p "please select '1' or '2'" start
	done
#--------------------------------------------------------------------------------
	if [ $start = "1" ]
	then	sudo service odoo-server start
		echo ""
		echo -e $GREEN"Starting Odoo Server..."$ENDCOLOR		
	else 
		sudo service odoo-server stop
		echo ""
		echo -e $RED"Stoping Odoo Server...."$ENDCOLOR
	fi			
sleep 0.5
ps aux | grep odoo 

