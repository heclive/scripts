#!/bin/sh

clear
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
ENDCOLOR="\033[0m"
root="/media/INTENSO/"

#-----------------------------------------MENU------------------------------------------
menu () {
echo ""
echo ""
echo -e $WHITE"MENU:"$ENDCOLOR
echo -e $WHITE"[1]"$ENDCOLOR" correct sources.list"
echo -e $WHITE"[2]"$ENDCOLOR" install gimp"
echo -e $WHITE"[3]"$ENDCOLOR" install libre office"
echo -e $WHITE"[4]"$ENDCOLOR" install opera web browser"
echo -e $WHITE"[5]"$ENDCOLOR" install gconf-editor (gnome system controll app)"
echo -e $WHITE"[6]"$ENDCOLOR" install LaTeX"
echo -e $WHITE"[7]"$ENDCOLOR" install LAMP Web Server (Linux,Apache,MySQL,PHP)"
echo -e $WHITE"[8]"$ENDCOLOR" observer syslog file ..."
echo -e $RED"[9]"$ENDCOLOR" Quit"
echo "Please choose from [1] - ["${#opt[@]}"]:"
read i
echo ""
}

#------------------------------------------ARRAY-----------------------------------------
opt=(	[1]="bash "$root"system/scripts/sources.sh" 
	[2]="sudo apt-get install gimp -y" 
	[3]="sudo dpkg -i "$root"system/install/libre/DEBs/*.deb" 
	[4]="sudo dpkg -i "$root"system/install/opera/*.deb"
	[5]="sudo apt-get install gconf-editor"
	[6]=latex
	[7]=lamp	
	[8]="tail -f /var/log/syslog"
	[9]="quit"
)
#-----------------------------------------LATEX-------------------------------------------
lamp () {
localh=$(hostname -I)
defpage=$(find /var/www/ -name "index.html" -or -name "index.php" -maxdepth 1)
echo -e $YELLOW"Installing Apache2 Server ..."$ENDCOLOR
sudo apt-get -y install apache2
echo -e $YELLOW"Installing PHP ..."$ENDCOLOR
sudo apt-get -y install php5 libapache2-mod-php5
echo -e $YELLOW"Installing MYSQL ..."$ENDCOLOR
sudo apt-get install -y mysql-server php5-mysql 
echo -e $WHITE"LAMP Server successfully installed..."$ENDCOLOR
echo -e $BLUE"localhost: "$localh
echo -e "default web page: "$defpage$ENDCOLOR 

#-----------------------------------------Installation of WORDPRESS 
gut=0
until [ $gut = "y" -o $gut = "n" ] 
do 	
		echo ""		
		echo -e $WHITE"Install WORDPRESS [y/n]?"$ENDCOLOR
		echo -e $RED"***************************************************"$ENDCOLOR
		echo -e $RED"* WARNING:ALL DATA IN /VAR/WWW/ WILL BE DELETED!! *"$ENDCOLOR
		echo -e $RED"***************************************************"$ENDCOLOR
		read -s -n 1 -p "Please type in \"y\" or \"n\"." gut
		echo ""
		if [ $gut = "y" ]
		then 
			#-------------Emptying www folder and grabbing latest version of WORDPRESS -----------			
			echo -e $YELLOW"DOWNLOADING & INSTALLING wordpress to /var/www ..."$ENDCOLOR			
			cd /var/www
			#sudo chown pi: .
			#sudo rm * -R
			#wget --no-check-certificate http://wordpress.org/latest.tar.gz
			#-------------extract tarball, move contents to current directory and tidy up --------	
			#tar xzf latest.tar.gz
			#mv wordpress/* .
			#rm -rf wordpress latest.tar.gz
			echo -e $YELLOW"SETTING UP WordPress ..."$ENDCOLOR
				wp=0
				until [ $wp = "y" ] 
				do 	
				echo -e $BLUE"please provide username for your WordPress Login: "$ENDCOLOR
				read usr
				echo -e $WHITE"accept username: \""$usr"\" [y/n]?"$ENDCOLOR
				read -s -n 1 wp								
				if ! [ $wp = "n" -o $wp = "y" ]
					then 
						echo "Please enter only \"y\" or \"n\" to accept or decline."
						echo -e $WHITE"accept username: \""$usr"\" [y/n]?"$ENDCOLOR
						read -s -n 1 wp	
					else	
						echo "=>"$wp					
				fi
				done
				wp=0
				until [ $wp = "y" ] 
				do 	
				echo -e $BLUE"please provide your password: "$ENDCOLOR
				read psw
				echo -e $WHITE"accept password: \""$psw"\" [y/n]?"$ENDCOLOR
				read -s -n 1 wp								
				if ! [ $wp = "n" -o $wp = "y" ]
					then 
						echo "Please enter only \"y\" or \"n\" to accept or decline."
						echo -e $WHITE"accept password: \""$psw"\" [y/n]?"$ENDCOLOR
						read -s -n 1 wp	
					else
						echo "=>"$wp
				fi
				done	
				wp=0
				until [ $wp = "y" ] 
				do 	
				echo -e $BLUE"please provide your WordPress Database Name: "$ENDCOLOR
				read dbname
				echo -e $WHITE"accept Database Name: \""$dbname"\" [y/n]?"$ENDCOLOR
				read -s -n 1 wp								
				if ! [ $wp = "n" -o $wp = "y" ]
					then 
						echo "Please enter only \"y\" or \"n\" to accept or decline."
						echo -e $WHITE"accept Database Name: \""$dbname"\" [y/n]?"$ENDCOLOR
						read -s -n 1 wp	
					else
						echo "=>"$wp
				fi
				done	
				unset wp
			
			echo -e $GREEN	
			mysql -u$usr -p$psw -e "create database "$dbname";"$ENDCOLOR
			echo "[Admin User]" > wordpress.cfg
			echo "Database Name: "$dbname >> wordpress.cfg
			echo "User Name:     "$usr >> wordpress.cfg
			echo "Password:      "$psw >> wordpress.cfg
			echo "Database Host: localhost" >> wordpress.cfg
			echo "Table Prefix:  wp_" >> wordpress.cfg
			echo -e $WHITE"WORDPRESS set up successfully. Setup file: \"wordpress.cfg\"."
			echo -e "Please visit:"$BLUE" http://"$loalhc"/wp-admin"$WHITE" to login to your WordPress intstallation."
		else
			echo ""
		fi
done
}
latex () {
ok=0
until [ $ok = "y" -o $ok = "n" ] 
do 	
		echo ""		
		echo -e $WHITE"Install LaTeX [y/n]?"$ENDCOLOR
		read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." ok
		echo ""
		if [ $ok = "y" ]
		then 
			sudo apt-get -y install python-software-properties
			sudo apt-add-repository ppa:texlive-backports/ppa
			sudo apt-add-repository ppa:gummi/gummi
			sudo apt-get -y update
			sudo apt-get -y install texlive
			echo -e $BLUE"LaTeX has been installed...THANK YOU!"$ENDCOLOR		
		
		else
			echo ""
		fi
done
#-----------------------------------------ModernCV package
ok=0
until [ $ok = "y" -o $ok = "n" ] 
do 	
		echo ""		
		echo -e $WHITE"Install ModernCV package [y/n]?"$ENDCOLOR
		read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." ok
		echo ""
		if [ $ok = "y" ]
		then 
			#-------------CV Specific----------------			
			sudo apt-get -y install texlive-fonts-extra
			sudo apt-get -y install texlive-latex-extra
			#sudo apt-get install texlive-luatex
			#--------------Not CV Specific-----------
			#sudo apt-get install texlive-latex3
			#sudo apt-get install texlive-xetex
			echo -e $BLUE"ModernCV specific packages have been installed..."$ENDCOLOR
		else
			echo ""
		fi
done
#-----------------------------------------LaTeXML package
ok=0
until [ $ok = "y" -o $ok = "n" ] 
do 	
		echo ""		
		echo -e $WHITE"Install LaTeXML package [y/n]?"$ENDCOLOR
		read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." ok
		echo ""
		if [ $ok = "y" ]
		then 
			FILE="/etc/apt/sources.list"
			REP1="deb http://ftp.de.debian.org/debian squeeze main"
			#REP2="deb http://us.archive.ubuntu.com/ubuntu vivid main universe"			
			echo $REP1 > $FILE
			#echo $REP2 >> $FILE
			gpg --keyserver pgpkeys.mit.edu --recv-key  3B4FE6ACC0B21F32
			gpg -a --export 3B4FE6ACC0B21F32 | sudo apt-key add -
			gpg --keyserver pgpkeys.mit.edu --recv-key  AED4B06F473041FA
			gpg -a --export AED4B06F473041FA | sudo apt-key add -
			gpg --keyserver pgpkeys.mit.edu --recv-key  64481591B98321F9
			gpg -a --export 64481591B98321F9 | sudo apt-key add -
			gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
			gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
			sudo apt-get update
			sudo apt-get -y install python-software-properties
			sudo apt-add-repository ppa:texlive-backports/ppa
			sudo apt-add-repository ppa:gummi/gummi
			sudo apt-get update
			sudo apt-get -y install  \
  			libarchive-zip-perl libfile-which-perl libimage-size-perl  \
			libio-string-perl libjson-xs-perl libparse-recdescent-perl \
			liburi-perl libuuid-tiny-perl libwww-perl                  \
			libxml2 libxml-libxml-perl libxslt1.1 libxml-libxslt-perl  \
			texlive-latex-base imagemagick libimage-magick-perl
			sudo apt-get -y install latexml
			echo -e $BLUE"LaTeXML has been installed..."$ENDCOLOR
		else
			echo ""
		fi
done
#-----------------------------------------Winefish Editor
ok=0
until [ $ok = "y" -o $ok = "n" ] 
do 	
		echo ""		
		echo -e $WHITE"Install Winefish Editor [y/n]?"$ENDCOLOR
		read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." ok
		echo ""
		if [ $ok = "y" ]
		then 
	
			sudo apt-get -y install winefish
			echo -e $BLUE"Winefish Editor installed...THANK YOU!"$ENDCOLOR
		else
			echo ""
			
		fi
done
}
#-------------------------------------------------Schleife INTENSO--------------------------
ok=0
until [ $ok = "y" -o $ok = "n" ] 
do 	
		echo ""		
		echo "Is the directory of media \"INTENSO\" correct? ("$root")"
		read -s -n 1 -p "Please enter \"y\" or \"n\" to accept." ok
		echo ""
		if [ $ok = "n" ]
		then 
			read -p "Please enter root directory of \"INTENSO\":" root
		else
			echo ""			
		fi
export PATH=$PATH":"${root}git/
done
clear
menu
#---------------------------------------------------Schleife MENU-----------------------------
until [ ! -n $i ]
do
#-------------------------------------Schleife Y/N
	until [ -n "${opt[$i]}" ]
	do 
		echo "please enter a valid number (1 - "${#opt[@]}"):"
		read i
	done
#                                  Pruefe Auswahl
	if [ $i -eq ${#opt[@]} ]
	then 
 		echo "exiting ...."
		exit
	else
		echo ""
	fi
#                                  starte Auswahl
	echo -e $YELLOW "==========EXECUTING ......"$ENDCOLOR 
	echo "" 
	echo -e $YELLOW ${opt[$i]} $ENDCOLOR
	${opt[$i]}
	echo -e $GREEN "========================="$ENDCOLOR
	echo -e $GREEN ${opt[$i]}" EXECUTED."$ENDCOLOR
	echo -e $GREEN "========================="$ENDCOLOR
	menu
done					
