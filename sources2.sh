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

#Programmstart

FILE="/etc/apt/sources.list"
REP1="deb http://ftp.de.debian.org/debian squeeze main"
REP2="" #deb http://http.kali.org/kali kali main non-free contrib"
REP3="" #deb http://security.kali.org/kali-security kali/updates main contrib non-free"
REP4="" #deb-src http://http.kali.org/kali kali main non-free contrib"
REP5="" #deb-src http://security.kali.org/kali-security kali/updates main contrib non-free"
echo -e $YELLOW"inserting missing keys..."$ENDCOLOR
gpg --keyserver pgpkeys.mit.edu --recv-key  AED4B06F473041FA
gpg -a --export AED4B06F473041FA | sudo apt-key add -
gpg --keyserver pgpkeys.mit.edu --recv-key  64481591B98321F9
gpg -a --export 64481591B98321F9 | sudo apt-key add -
gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
echo ""
echo -e $WHITE"fix 'sources.list' ? [y/n]"$ENDCOLOR
read  answer
	until [ \( $answer = "n" \) -o \( $answer = "y" \) ]
	do
	echo -e "please enter 'y' for YES or 'n' for NO"
	read answer
	done
if [ $answer = "n" ] 
then	echo "ok" 
	exit

else	until [ -f ${FILE} ]
	do
	echo -e $RED $FILE" does not exist! Create ? [y/n]"
	read yes
	if [ $yes = "y" ] 
	then	touch $FILE
	else	echo -e "please enter location of 'sources.list (e.g. /etc/apt/sources.list)"	
		read FILE2
		echo "create" $FILE2 " ? [y/n]"
		read yes2
		until [ $yes2 = "y" ]
		do
		echo -e "please enter location of 'sources.list (e.g. /etc/apt/sources.list)"	
		read FILE2
		echo "create" $FILE2 " ? [y/n]"
		read yes2
		done
		touch $FILE2
		FILE=$FILE2
	fi
	done
		
	echo -e $YELLOW"fixing..."$ENDCOLOR	
	echo $REP1 > $FILE
	echo $REP2 >> $FILE
	echo $REP3 >> $FILE
	echo $REP4 >> $FILE
	echo $REP5 >> $FILE
	echo ""						
	echo -e $WHITE"update apt ? [y/n]"$ENDCOLOR
	read  update
	until [ \( $update = "n" \) -o \( $update = "y" \) ]
	do
		echo -e "please enter 'y' for YES or 'n' for NO"
		read update
	done
		
		if [ $update = "n" ]
		then	echo -e $GREEN"changes made:"$ENDCOLOR				
			echo -e $RED"(1) APT was NOT updated"$ENDCOLOR
			echo -e $GREEN"(2) "$FILE" has been updated as follows:"
			echo ""
			cat $FILE
			echo -e $ENDCOLOR
			exit

		else	echo -e $YELLOW"updating ..."$ENDCOLOR 
			sudo apt-get update
			echo ""
			echo -e $GREEN"changes made:"				
			echo "(1) APT was updated"
			echo "(2) "$FILE" has been updated as follows:"
			echo ""
			cat $FILE
			echo -e $ENDCOLOR
			exit
		fi

fi
