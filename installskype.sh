#!/bin/sh
sudo apt-get install libqt4-dbus libqt4-network libqt4-xml libasound2
wget http://www.skype.com/go/getskype-linux-beta-ubuntu-32
sudo dpkg -i getskype-*
sudo apt-get -f install
