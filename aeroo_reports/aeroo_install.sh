# -*- encoding: utf-8 -*-
################################################################################
#
# Copyright (c) 2015 Luke Branch ( https://github.com/odoocommunitywidgets ) 
#               All Rights Reserved.
#               General Contact <odoocommunitywidgets@gmail.com>
#
# WARNING: This script as such is intended to be used by professional
# programmers who take the whole responsability of assessing all potential
# consequences resulting from its eventual inadequacies and bugs
# End users who are looking for a ready-to-use solution with commercial
# guarantees and support are strongly adviced to contract a Free Software
# Service Company
#
# This script is Free Software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but comes WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
################################################################################
# DESCRIPTION: This script is designed to install all the dependencies for the aeroo-reports modules from Alistek. 
# If you'd like to install Odoo along with it simply uncomment lines 108-113. Otherwise it assumes you already have Odoo
# installed according to the script here: 
# https://raw.githubusercontent.com/lukebranch/odoo-install-scripts/master/odoo-saas4/ubuntu-14-04/odoo_install.sh

# Install Git:
echo -e "\n---- Install Git ----"
sudo apt-get install git -y

# Install AerooLib:
echo -e "\n---- Install AerooLib ----"
sudo apt-get install python-setuptools python-genshi python-cairo python-lxml libreoffice-script-provider-python libreoffice-base python-cups -y
sudo mkdir /opt/aeroo
cd /opt/aeroo
sudo git clone https://github.com/aeroo/aeroolib.git
cd /opt/aeroo/aeroolib
sudo python setup.py install

#Create Init Script for OpenOffice (Headless Mode):
echo -e "\n---- create init script for LibreOffice (Headless Mode) ----"
sudo touch /etc/init.d/office
sudo su root -c "echo '### BEGIN INIT INFO' >> /etc/init.d/office"
sudo su root -c "echo '# Provides:          office' >> /etc/init.d/office"
sudo su root -c "echo '# Required-Start:    $remote_fs $syslog' >> /etc/init.d/office"
sudo su root -c "echo '# Required-Stop:     $remote_fs $syslog' >> /etc/init.d/office"
sudo su root -c "echo '# Default-Start:     2 3 4 5' >> /etc/init.d/office"
sudo su root -c "echo '# Default-Stop:      0 1 6' >> /etc/init.d/office"
sudo su root -c "echo '# Short-Description: Start daemon at boot time' >> /etc/init.d/office"
sudo su root -c "echo '# Description:       Enable service provided by daemon.' >> /etc/init.d/office"
sudo su root -c "echo '### END INIT INFO' >> /etc/init.d/office"
sudo su root -c "echo '#! /bin/sh' >> /etc/init.d/office"
sudo su root -c "echo '/usr/bin/soffice --nologo --nofirststartwizard --headless --norestore --invisible \"--accept=socket,host=localhost,port=8100,tcpNoDelay=1;urp;\" &' >> /etc/init.d/office"

# Setup Permissions and test LibreOffice Headless mode connection

sudo chmod +x /etc/init.d/office
sudo update-rc.d office defaults

# Install AerooDOCS
echo -e "\n---- Install AerooDOCS (see: https://github.com/aeroo/aeroo_docs/wiki/Installation-example-for-Ubuntu-14.04-LTS for original post): ----"

[start]
interface = localhost
port = 8989
oo-server = localhost
oo-port = 8100
spool-directory = /tmp/aeroo-docs
spool-expire = 1800
log-file = /var/log/aeroo-docs/aeroo_docs.log
pid-file = /tmp/aeroo-docs.pid
[simple-auth]
username = anonymous
password = anonymous

echo -e "\n---- create conf file for AerooDOCS ----"
sudo touch /etc/aeroo-docs.conf
sudo su root -c "echo '[start]' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'interface = localhost' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'port = 8989' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'oo-server = localhost' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'oo-port = 8100' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'spool-directory = /tmp/aeroo-docs' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'spool-expire = 1800' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'log-file = /var/log/aeroo-docs/aeroo_docs.log' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'pid-file = /tmp/aeroo-docs.pid' >> /etc/aeroo-docs.conf"
sudo su root -c "echo '[simple-auth]' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'username = anonymous' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'password = anonymous' >> /etc/aeroo-docs.conf"

sudo apt-get install python3-pip -y
sudo pip3 install jsonrpc2 daemonize
cd /opt/aeroo
sudo git clone https://github.com/aeroo/aeroo_docs.git
sudo touch /etc/init.d/office
sudo python3 /opt/aeroo/aeroo_docs/aeroo-docs start -c /etc/aeroo-docs.conf
sudo ln -s /opt/aeroo/aeroo_docs/aeroo-docs /etc/init.d/aeroo-docs
sudo update-rc.d aeroo-docs defaults
sudo service aeroo-docs restart

# If you encounter and error "Unable to lock on the pidfile while trying #16 just restart the service (sudo service aeroo-docs restart).

# Install Odoo from Source
echo -e "\n---- Install Odoo 8 from Source (Github) ----"

while true; do
    read -p "Would you like to install Odoo 8?" yn
    case $yn in
        [Yy]* ) sudo wget https://raw.githubusercontent.com/lukebranch/odoo-install-scripts/8.0/odoo-saas4/ubuntu-14-04/odoo_install.sh
        sudo sh odoo_install.sh;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
    esac
done

# cd /tmp
# sudo wget https://raw.githubusercontent.com/lukebranch/odoo-install-scripts/8.0/odoo-saas4/ubuntu-14-04/odoo_install.sh
# sudo sh odoo_install.sh

# Install Aeroo Reports:
echo -e "\n---- Install Aeroo Reports Odoo Modules: ----"

while true; do
    read -p "Would you like to install Aeroo Reports Odoo modules for Odoo 8?" yn
    case $yn in
        [Yy]* ) cd /opt/odoo/custom
        sudo git clone -b master https://github.com/aeroo/aeroo_reports.git;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
    esac
done

# cd /opt/odoo/custom
# sudo git clone -b master https://github.com/aeroo/aeroo_reports.git

echo -e "\n---- restart the server (sudo shutdown -r now) ----"
