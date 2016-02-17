#logfile for IP="46.101.221.154"

LOGIN:
ssh -Y user@server

INSTALLATIONS:
sudo apt-get install xinit
sudo apt-get install ubuntu-desktop
gummi
pdfsam

EDITED FILES:
/etc/ssh/ssh_config
  ForwardAgent yes
  ForwardX11 yes
  ForwardX11Trusted yes

DISPLAY MANGAER:
LXDE:
/etc/init.d/lxdm start
/etc/init.d/lxdm stop

XFCE:
xfce4-panel
/etc/init.d/xdm start
/etc/init.d/xdm stop

RAM ERWEITERT (SWAP FILE):
dd if=/dev/zero of=/var/512mb.swap bs=1M count=512
mkswap /var/512mb.swap
swapon /var/512mb.swap

MAILSERVER:

rename hostname: 
sudo -s
editor /etc/hostname
editor /etc/hosts
shutdown -r now

SETUP (HOSTNAME) DIGITALOCEAN:
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-host-name-with-digitalocean

INSTALL AND SETUP POSTFIX ON UBUNTU SETUP A POSTFIX E-Mail Server with Dovecot:
--------------------------------------------------------------------------
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-postfix-e-mail-server-with-dovecot)
--------------------------------------------------------------------------
(https://www.digitalocean.com/community/tutorials/how-to-install-and-setup-postfix-on-ubuntu-14-04

SETTING UP DKIM for SIGNING EMAILs!:
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy
--------------------------------------------------------------------------------------------
http://askubuntu.com/questions/134725/setup-dkim-domainkeys-for-ubuntu-postfix-and-mailman
--------------------------------------------------------------------------------------------
https://www.howtoforge.com/community/threads/dkim-amavis-email-not-signed.62791/

TESTING EMAIL SPAMMYNESS:
http://www.mail-tester.com/
send email to: check-auth2@verifier.port25.com


Seting Up Postfix: 
 - cp /usr/share/postfix/main.cf.dist /etc/postfix/main.cf.dist:
 - edit main.cf.dist and save as main.cf

SetUP email users in:
sudo nano /etc/postfix/virtual

[email][user]
blah@example.com        demouser
dinosaurs@example.com   demouser
roar@example.com        root
contact@example.com     demouser,root

sudo postmap /etc/postfix/virtual
sudo service postfix restart

CREATE and DELETE USERS:
useradd [user] / userdel [user]
passwd [user]

sendemail:
mail -s "Thema"  -a FROM:"Absendername <deine-mail@provider.tld>" empfaenger@provider2.tld < /pfad/zur/datei/mit/mailinhalt
