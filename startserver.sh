#!/bin/sh

clear
				# PROGRAMM START
			# Quelliste fuer Packetmanager 

IP="46.101.221.154"
REP1="deb http://ftp.de.debian.org/debian squeeze main"
REP2="" #deb http://http.kali.org/kali kali main non-free contrib"
REP3="" #deb http://security.kali.org/kali-security kali/updates main contrib non-free"
REP4="" #deb-src http://http.kali.org/kali kali main non-free contrib"
REP5="" #deb-src http://security.kali.org/kali-security kali/updates main contrib non-free"

echo ""
echo "Allready Logged in to ["$IP"]? [y/n]"
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
	then 
		cp /media/INTENSO/MyFiles/ssh/rootssh /root/
		sudo chmod 400 /root/rootssh
		ssh -i /root/rootssh root@$IP
		exit
	else echo ""
	fi
#------------------------------------------------------------------------------------------------> ELSE
echo "Checking Server status ...."
ps aux | grep odoo


#=================================================================================================> START SERVER?
echo "Please Choose:"
echo "1.) Start Server"
echo "2.) Stop Server"
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
		echo "Odoo Server Started"		
	else 
		sudo service odoo-server stop
		echo ""
		echo "Odoo Server Stoped"
echo ""
	fi			

