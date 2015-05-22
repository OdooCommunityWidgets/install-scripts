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

#Create Init Script for OpenOffice (Headless Mode) - (see: https://www.odoo.com/forum/help-1/question/how-to-install-aeroo-reports-2780 for original post from Ahmet):
echo -e "\n---- create init script for LibreOffice (Headless Mode) ----"

sudo su root -c "echo '### BEGIN INIT INFO' >> /etc/init.d/office"
sudo su root -c "echo '# Provides:          office' >> /etc/init.d/office"
sudo su root -c "echo '# Required-Start:    $remote_fs $syslog' >> /etc/init.d/office"
sudo su root -c "echo '# Required-Stop:     $remote_fs $syslog' >> /etc/init.d/office"
sudo su root -c "echo '# Default-Start:     2 3 4 5' >> /etc/init.d/office"
sudo su root -c "echo '# Default-Stop:      0 1 6' >> /etc/init.d/office"
sudo su root -c "echo '# Short-Description: Start daemon at boot time' >> /etc/init.d/office"
sudo su root -c "echo '# Description:       Enable service provided by daemon.' >> /etc/init.d/office"
sudo su root -c "echo '### END INIT INFO' >> /etc/init.d/office"
sudo su root -c "echo '#!/bin/sh' >> /etc/init.d/office"
sudo su root -c "echo '/usr/bin/soffice --nologo --nofirststartwizard --headless --norestore --invisible "--accept=socket,host=localhost,port=8100,tcpNoDelay=1;urp;" &' >> /etc/init.d/office"

# Setup Permissions and test LibreOffice Headless mode connection

# sudo chmod +x /etc/init.d/office
# sudo update-rc.d office defaults

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

# [ ! ]  If you encounter and error "Unable to lock on the pidfile while trying #16 just restart your server (sudo shutdown -r now)                         and try #16 again after reboot.

# Install Odoo from Source:
# echo -e "\n---- Install Odoo from Source ----"

# cd /tmp
# sudo wget https://raw.githubusercontent.com/lukebranch/odoo-install-scripts/master/odoo-saas4/ubuntu-14-04/odoo_install.sh
# sudo sh odoo_install.sh

# restart the server (sudo shutdown -r now)

# Install Aeroo Reports:
echo -e "\n---- Install Aeroo Reports: ----"
sudo apt-get install python-cups -y
cd /opt/odoo/custom
sudo git clone -b master https://github.com/aeroo/aeroo_reports.git

# After following the (above) steps in this guide you should have Aeroo Reports installed correctly on your server for Ubuntu 14.04 and Odoo 8.0. You'll just need to create a database and install the required Aeroo reports modules you need for that database.

# [ ! ]    Do not have aeroo_report_sample in your addons directory or you will get an error message when updating module list:
#          Warning! Unmet python dependencies! No module named cups

# Install report_aeroo module in Odoo database:

#31    Go to Settings >> Users >> Administrator in the backend of Odoo
#32    Tick the box next to 'Technical Features' and Save, then refresh your browser window.
#33    Go to Settings >> Update Modules List > Update
#34    Go to Settings >> Local Modules > Search for: Aeroo
#35    Install report_aeroo
#36    You'll be confronted with an installation wizard, click: Continue >> Choose Simple Authentication from the Authentication dropdown list, and add username and password: anonymous
# [ ! ]     You can change the username and password in: /etc/aeroo-docs.conf if required.
#37    Click Apply and Test. You should see the following message if it was successful:
