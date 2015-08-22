#!/bin/sh
WHITE="\033[1;29m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"
echo -e $WHITE"when asked to type in save location..just press enter"
echo "The Passphrase used is: QABENBAPPPKMP"
echo -e "[create a new ssh keypair?]"$ENDCOLOR
read -s -n 1 ok
until [ $ok = "y" -o $ok = "n" ]
        do      
                read -s -n 1 -p "please enter 'y' for YES or 'n' for NO" ok
                echo "" 
        done

if [ $ok = "y" ]
then
ssh-keygen -t rsa -b 4096 -C "heclive@hotmail.de"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "cheking ssh conection to github.."
ssh -T git@github.com
exit
else 
cp /media/INTENSO/MyFiles/ssh/id_rsa ~/.ssh/
chmod 700 ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "cheking ssh conection to github.."
ssh -T git@github.com
fi
