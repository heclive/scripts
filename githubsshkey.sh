#!/bin/sh
echo "when asked to type in save location..just press enter"
echo "The Passphrase used is: QABENBAPPPKMP"
echo "[press enter when ready start]"
read ok
ssh-keygen -t rsa -b 4096 -C "heclive@hotmail.de"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "cheking ssh conection to github.."
sleep 1
ssh -T git@github.com

