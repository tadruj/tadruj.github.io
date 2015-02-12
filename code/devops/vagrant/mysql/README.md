# Needs manual install because of the dialog boxes

sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

sudo apt-get install mysql-server-5.6
sudo apt-get install apache2
sudo apt-get install phpmyadmin
sudo php5enmod mcrypt
sudo service apache2 restart
sudo update-rc.d mysql defaults
