#!/bin/sh

clear
# apt cache limits erhoehen
echo "APT::Cache-Limit \"100000000\";" > /etc/apt/apt.conf.d/70debconf
sudo apt-get clean
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"

				# PROGRAMM START
			# Quelliste fuer Packetmanager 

FILE="/etc/apt/sources.list"
REP1="deb http://ftp.de.debian.org/debian squeeze main"
REP2="deb http://us.archive.ubuntu.com/ubuntu vivid main universe"
REP3="" #deb http://http.kali.org/kali kali main non-free contrib"
REP4="" #deb http://security.kali.org/kali-security kali/updates main contrib non-free"
REP5="" #deb-src http://http.kali.org/kali kali main non-free contrib"
REP6="" #deb-src http://security.kali.org/kali-security kali/updates main contrib non-free"
echo -e $YELLOW"inserting missing keys..."$ENDCOLOR
gpg --keyserver pgpkeys.mit.edu --recv-key  AED4B06F473041FA
gpg -a --export AED4B06F473041FA | sudo apt-key add -
gpg --keyserver pgpkeys.mit.edu --recv-key  64481591B98321F9
gpg -a --export 64481591B98321F9 | sudo apt-key add -
gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
echo ""


echo -e $WHITE"fix 'sources.list' ? [y/n]"$ENDCOLOR
read -s -n 1 fix

#========================================================================================================= FRAGE1: QUELLDATEI BEARBEITEN ? 

	until [ $fix = "y" -o $fix = "n" ]
	do	
		read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" fix
		echo ""	
	done

#=============================================================================================================================> Frage1: NO
	if [ $fix = "n" ]  			
	then	echo "" 
		echo "Please fix sources.list manually or run script again."

#=============================================================================================================================> Frage1: YES

	#------------------------------------------------------------------------------------------------------------->> Frage1.File: DOESNT EXIST
	else	until [ -f ${FILE} ]
		do
			echo -e $RED $FILE" does not exist! Create the default souces.list file (/etc/apt/sources.list)? [y/n]"$ENDCOLOR
			read -s -n 1 yes
			#--------------------------------------------------------------------------------------------->> Create Frage1.File ?
			until [ $yes = "y" -o $yes = "n" ]
			do	
				read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" yes
				echo ""	
			done	
			#--------------------------------------------------------------------------------------------->> YES 
			if [ $yes = "y" ]		# IF 1.2 EBENE 
			then	touch $FILE
			else 	read -p "please enter location of 'sources.list: " FILE2		
				read -s -n 1 -p "create "$FILE2" ? [y/n]" yes2
			#----------------------------------------------------------------------------->> NO
				until [ $yes2 = "y" -o $yes2 = "n" ]
				do		
					echo ""					
					read -s -n 1 -p "Please enter 'y' for YES or 'n' for NO" yes2					
				done
				
				if [ $yes2 = "n" ]
				then 	echo ""
					echo -e $WHITE"Please create a sources.list file and run the script again."
					exit
				else 	echo ""						
				fi
				FILE=$FILE2
				touch $FILE
			fi		
		done

		
	#------------------------------------------------------------------------------------------------------------->> Frage1.File DOES EXIST
		echo ""
		echo -e $YELLOW"Creating "$FILE" ..."$ENDCOLOR	
		echo $REP1 >> $FILE
		echo $REP2 >> $FILE
		echo $REP3 >> $FILE
		echo $REP4 >> $FILE
		echo $REP5 >> $FILE
		echo ""						
	fi
#==================================================================================================================== FRAGE2: UPDATE APTITUDE?
echo -e $WHITE"update apt ? [y/n]"$ENDCOLOR
read  -s -n 1 update

	until [ $update = "n" -o $update = "y" ]
	do
		echo ""			
		read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" update
	done
#====================================================================================================> FRAGE2: NO
	if [ $update = "n" -a $fix = "y" ]
	then	echo ""
		echo -e $GREEN"changes made:"$ENDCOLOR				
		echo -e $RED"(1) APT was NOT updated (to update run 'sudo apt-get update' or run script again)"$ENDCOLOR
		echo -e $GREEN"(2) "$FILE" has been fixed as follows:"
		echo ""
		cat $FILE
		echo -e $ENDCOLOR
	
	#====================================================================================================> FRAGE2: YES
	else	if [ $update = "n" -a $fix = "n" ]
		then 	echo ""
			echo -e $WHITE"==================="
			echo  "  NO CHANGES MADE!"
			echo -e "==================="$ENDCOLOR
		else 	if [ $update = "y" -a $fix = "n" ]
			then	echo ""
				echo -e $YELLOW "Updating APT-Sources ..."$ENDCOLOR
				sudo apt-get update
				echo ""
				echo -e $GREEN"changes made:"				
				echo -e $GREEN"(1) APT was updated"$ENDCOLOR
				echo -e $RED"(2) "$FILE" has NOT been fixed...content of "$FILE":"
				echo -e ""$ENDCOLOR
				cat $FILE
				echo -e $ENDCOLOR
			else	echo ""
				echo -e $YELLOW "Updating APT-Sources ..."$ENDCOLOR
				sudo apt-get update
				echo ""
				echo -e $GREEN"changes made:"				
				echo -e $GREEN"(1) APT was updated"
				echo "(2) "$FILE" has been fixed...content of "$FILE":"
				echo  ""
				cat $FILE
				echo -e $ENDCOLOR
			fi

		fi
	fi			


				


echo "test"
