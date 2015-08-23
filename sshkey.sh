#!/bin/bash
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"
PRIVATE="/root/.ssh/id_rsa"
PUBLIC="/root/.ssh/id_rsa.pub"
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
	if [ -e ${PRIVATE} -a -e ${PUBLIC} ]
	then 
		echo ""
	else 
		cp /media/INTENSO/MyFiles/ssh/id_rsa ~/.ssh/
		cp /media/INTENSO/MyFiles/ssh/id_rsa.pub ~/.ssh/
		chmod 700 $PRIVATE
		chmod 644 $PUBLIC			
	fi
fi

eval "$(ssh-agent -s)"
ssh-add $FILE

read -s -n 1 -p "register global user.name and email with intenso [y/n]?" new
until [ $new = "y" -o $new = "n" ]
        do      
                read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" new
                echo "" 
        done
if [ $new = "y" ]
then
	git config --global user.name "intenso"
	git config --global user.email "intenso@dellpc"
else
	echo ""
fi
#echo "cheking ssh conection to github.."
#ssh -T git@github.com

