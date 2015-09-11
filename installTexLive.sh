#!/bin/sh
sudo apt-get install python-software-properties
echo "updating apt-repository .... "
echo "please hit enter"
read
sudo apt-add-repository ppa:texlive-backports/ppa
sudo apt-add-repository ppa:gummi/gummi
echo " "
echo "DONE!"
echo "continue with enter ..."
read
echo "updating synaptic"
echo "please hit enter"
read
sudo apt-get update
echo " "
echo "DONE!"
echo "continue with enter ..."
read
echo "installing TeXLive"
echo "please hit enter"
read
sudo apt-get install texlive
# extra Schriftarten
sudo apt-get install texlive-fonts-extra
# CV specific packages
sudo apt-get install texlive-latex-extra
#sudo apt-get install texlive-luatex
# latex editor Winefish
sudo apt-get install winefish
#sudo apt-get install texlive-latex3
#sudo apt-get install texlive-xetex
