#!/bin/bash

# MapR Retail Demo - Raspberry Pi deployment automation

# Raspberry Pi Deployment github project
export RPI_GITHUB_PROJECT_NAME="raspberrypi-deployment"
export RPI_GITHUB_PROJECT_URL="https://github.com/mkieboom/$RPI_GITHUB_PROJECT_NAME"

# Create a hidden config file .rpi_config
export RPI_CONFIG_FILE="mapr-retail-demo.config"

# Check if mkpasswd is installed, otherwise exit
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


# Run the ansible playbook
cd ~/$RPI_GITHUB_PROJECT_NAME
ansible-playbook \
  -i myhosts/raspberrypi_localhost \
  raspberrypi-deployment-mapr-retail-demo.yml \
  --connection=local \
  --extra-vars @"$RPI_CONFIG_FILE"

