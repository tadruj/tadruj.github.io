#!/bin/bash

vagrant.init

# We need Ubuntu 14.04 LTS
# Vagrantfile:
# config.vm.box = "ubuntu/trusty64"

vagrant up
vagrant ssh

# Ref: https://github.com/facebook/hhvm/wiki/Prebuilt-packages-on-Ubuntu-14.04
# Ref: http://fideloper.com/hhvm-nginx-laravel

# HHVM setup on Ubuntu
sudo apt-get -y install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
sudo add-apt-repository 'deb http://dl.hhvm.com/ubuntu trusty main'
sudo apt-get update
sudo apt-get -y install apt-show-versions
sudo apt-get -y install hhvm=3.5.0~trusty

# We got: HipHop VM 3.5.0 (rel)
# apt-show-versions hhvm
# hhvm:amd64/trusty 3.5.0~trusty uptodate
# version is: 3.5.0~trusty

wget http://wordpress.org/wordpress-4.1.tar.gz
tar xvfz wordpress-4.1.tar.gz
rm wordpress-4.1.tar.gz

sudo mkdir -p /var/www
sudo mv wordpress /var/www/wordpress
chown www-data.www-data /var/www --recursive

sudo cp hhvm.hdf /etc
sudo mkdir -p /var/log/hhvm
sudo mkdir -p /var/run/hhvm

# sudo hhvm --mode server -vServer.Type=fastcgi -vServer.FileSocket=/var/run/hhvm/sock

sudo apt-get install -y nginx=1.4.6-1ubuntu3.1

# This might not be needed !!!
# changes the hhvm.conf and added root and unix_socket. Stored in /vagrant
# sudo service nginx restart

# install fastcgi
sudo /usr/share/hhvm/install_fastcgi.sh

# run hhvm at the boot
sudo update-rc.d hhvm defaults

sudo service hhvm restart 

# make HHVM available as normal PHP
sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

sudo apt-get install -y lynx

