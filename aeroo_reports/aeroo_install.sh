# Install Git:
echo -e "\n---- Install Git ----"
sudo apt-get install git -y

# Install AerooLib:
echo -e "\n---- Install AerooLib ----"
sudo apt-get install python-setuptools python-genshi python-cairo python-lxml libreoffice-script-provider-python libreoffice-base -y
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

sudo apt-get install python3-pip -y
sudo pip3 install jsonrpc2 daemonize
cd /opt/aeroo
sudo git clone https://github.com/aeroo/aeroo_docs.git
sudo touch /etc/init.d/office
sudo python3 /opt/aeroo/aeroo_docs/aeroo-docs start -c /etc/aeroo-docs.conf
sudo ln -s /opt/aeroo/aeroo_docs/aeroo-docs /etc/init.d/aeroo-docs
sudo update-rc.d aeroo-docs defaults
sudo service aeroo-docs start

# If you encounter and error "Unable to lock on the pidfile while trying #16 just restart your server (sudo shutdown -r now)                         and try #16 again after reboot.

# Install Odoo from Source
echo -e "\n---- Install Odoo from Source ----"

cd /tmp
sudo wget https://raw.githubusercontent.com/lukebranch/odoo-install-scripts/master/odoo-saas4/ubuntu-14-04/odoo_install.sh
sudo sh odoo_install.sh

# Install Aeroo Reports:
echo -e "\n---- Install Aeroo Reports: ----"
sudo apt-get install python-cups -y
cd /opt/odoo/custom
sudo git clone -b master https://github.com/aeroo/aeroo_reports.git

echo -e "\n---- restart the server (sudo shutdown -r now) ----"
