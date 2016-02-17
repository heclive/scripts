#!/bin/sh
# build tools
sudo aptitude install -y build-essential libtool autoconf automake autoconf-archive pkg-config
# dependencies
sudo aptitude install -y libssl0.9.8 libssl-dev zlib1g zlib1g-dev libcurl4-openssl-dev lsb-base  ncurses-dev libncurses-dev libmozjs-dev libmozjs2d libicu-dev xsltproc
# optional for building documentation
sudo aptitude install -y help2man python-sphinx texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texinfo
cd /tmp/
wget http://www.erlang.org/download/otp_src_R14B04.tar.gz
tar xzf otp_src_R14B04.tar.gz
cd otp_src_R14B04
echo "skipping gs" > lib/gs/SKIP
echo "skipping jinterface" > lib/jinterface/SKIP
echo "skipping odbc" > lib/odbc/SKIP
echo "skipping wx" > lib/wx/SKIP
./configure --prefix=/usr/local
make && sudo make install
