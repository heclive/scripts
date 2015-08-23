#!/bin/sh
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"
FILE="/root/.ssh/id_rsa"
echo ""
echo "when asked to type in save location..just press enter"
echo -e "The Passphrase used is:" $WHITE"QABENBAPPPKMP"$ENDCOLOR
echo "[create a new ssh keypair?]"
read -s -n 1 ok
until [ $ok = "y" -o $ok = "n" ]
        do      
                read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" ok
                echo "" 
        done

if [ $ok = "y" ]
then
	ssh-keygen -t rsa -b 4096 -C "heclive@hotmail.de"
else 
	if [ -e ${FILE} ]
	then 
		echo ""
	else 
		cp /media/INTENSO/MyFiles/ssh/id_rsa ~/.ssh/
		chmod 700 $FILE			
	fi
fi

eval "$(ssh-agent -s)"
ssh-add $FILE

#echo "cheking ssh conection to github.."
#ssh -T git@github.com

