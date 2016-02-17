#!/bin/sh

clear
				# PROGRAMM START
			# Quelliste fuer Packetmanager 

IP1="46.101.221.154"
IP2="46.101.158.221"
YELLOW="\033[1;33m"
ENDCOLOR="\033[0m"
REP1="deb http://ftp.de.debian.org/debian squeeze main"
REP2="" #deb http://http.kali.org/kali kali main non-free contrib"
REP3="" #deb http://security.kali.org/kali-security kali/updates main contrib non-free"
REP4="" #deb-src http://http.kali.org/kali kali main non-free contrib"
REP5="" #deb-src http://security.kali.org/kali-security kali/updates main contrib non-free"
root="/media/INTENSO"
git="/media/INTENSO/system/git"
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
	gut=0		
	until [ $gut = "y" -o $gut = "n" ] 
	do 	
		read -s -n 1 -p "Is the ROOT directory correct? ("$root")" gut				
		
		if [ $gut = "n" ]
		then 
			echo ""						
		read -p "Please enter ROOT directory:" root		
		else
			gut2=0		
			until [ $gut2 = "y" -o $gut2 = "n" ] 
			do 	
				echo ""				
				read -s -n 1 -p "CONNECT TO SERVER-FILESYSTEM (y/n)?" gut2				
				
				if [ $gut2 = "n" ]
				then 
				echo ""						
				else
				echo ""
				echo "CONNECTING TO FILESYSTEMS....."
							
				menu () {
				echo ""
				echo ""
				echo -e $WHITE"SERVERS:"$ENDCOLOR
				echo -e $WHITE"[1]"$ENDCOLOR" hectoredunseng.com [46.101.221.154]"
				echo -e $WHITE"[2]"$ENDCOLOR" gourmetrepublic.co.uk [46.101.158.221]"
				echo -e $RED"[3]"$ENDCOLOR" Quit"
				echo ""
				read -n 1 -p"Please choose from [1] - [3]:" i
				echo ""
				read -p"username for Server"${i}":" user
				opt=(	[1]="gvfs-mount sftp://"${user}"@"${IP1}""
				[2]="gvfs-mount sftp://"${user}"@"${IP2}""
				[3]="exit"
				)												
				echo ""
				${opt[$i]};
				}
				
				
												
				sudo apt-get -y install gvfs-bin;
				menu
				echo ""			
				echo "CONTINUE WITH GRAPHICAL CONNECTION TO SERVER (y/n)? (n=exit)"						
				gut3=0		
				until [ $gut3 = "y" -o $gut3 = "n" ] 
				do 	
					read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." gut3				
					if [ $gut3 = "n" ]
					then 
					echo ""					
					exit 0;						
					else
					echo ""
					fi
				done		
		
				fi
			done		
		
		fi
	done
		
					gut4=0;
					until [ $gut4 = "y" -o $gut4 = "n" ] 
					do 				
						if [ $gut2 = "y" ]
						then 
						echo ""					
						exit 0;						
						else
						echo "CONTINUE WITH GRAPHICAL CONNECTION TO SERVER (y/n)? (n=exit)"						
							read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." gut4				
							if [ $gut4 = "n" ]
								then 
								echo ""					
								exit 0;						
								else
								echo ""
								fi
						fi
					done	

		sh $git/scripts/sources.sh					
		cp $root/MyFiles/IT/ssh/rootssh /root/
		sudo chmod 400 /root/rootssh
		xterm -e "ssh -XC -i /root/rootssh root@"$IP1" xfce4-panel"&				
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

