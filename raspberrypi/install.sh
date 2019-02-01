#!/bin/bash

# MapR Retail Demo - Raspberry Pi deployment automation

# Raspberry Pi Deployment github project
export RPI_GITHUB_PROJECT_NAME="raspberrypi-deployment"
export RPI_GITHUB_PROJECT_URL="https://github.com/mkieboom/$RPI_GITHUB_PROJECT_NAME"

# The config file
export RPI_CONFIG_FILE="/root/mapr-retail-demo/raspberrypi/mapr-retail-demo.config"

# Install git
echo "Installing basics..."
apt-get -qq -y install git

# Clone the raspberry-deployment ansible project
cd ~/
if [ ! -d "$RPI_GITHUB_PROJECT_NAME" ]; then
	# github project not yet there, get it using git clone
	git clone $RPI_GITHUB_PROJECT_URL
else
	# github project already there, update it using git pull
	cd ~/$RPI_GITHUB_PROJECT_NAME
	git pull $RPI_GITHUB_PROJECT_URL
fi

# Check if the config file is present
if [ ! -f $RPI_CONFIG_FILE ];
then
	echo
	echo
	echo
	echo "#############################################################"
	echo "We need to provide a config file first, eg:"
	echo "cp $RPI_CONFIG_FILE.template $RPI_CONFIG_FILE"
	echo ""
	echo "Edit the config file and provide all the details:"
	echo "vi $RPI_CONFIG_FILE"
	echo ""
	echo "Once done, launch this command again:"
	echo "curl https://raw.githubusercontent.com/mkieboom/mapr-retail-demo/master/raspberrypi/install.sh|bash"
	echo "#############################################################"
	exit 0;
fi

# Check if mkpasswd is installed, otherwise install it
if [ ! -f /usr/bin/mkpasswd ];
then
	echo "Installing whois for mkpasswd usage..."
    apt-get install -y whois
fi
if [ ! -f /usr/bin/mkpasswd ];
then
	echo "mkpassword not fount. Exiting."
    exit 0;
fi

# Create sha-512 encoded password of RPI_PASSWORD
#export RPI_PASSWORD_SHA512="$(mkpasswd --method=sha-512 $RPI_PASSWORD)"

# Update & upgrade
apt-get -y update
apt-get -y upgrade
apt-get clean all

# Install ansible, git and vim
apt-get -y install ansible git vim whois



# Run the ansible playbook
cd ~/$RPI_GITHUB_PROJECT_NAME
ansible-playbook \
  -i myhosts/raspberrypi_localhost \
  raspberrypi-deployment-mapr-retail-demo.yml \
  --connection=local \
  --extra-vars @"$RPI_CONFIG_FILE"

