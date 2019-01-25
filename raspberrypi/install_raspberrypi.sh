#!/bin/bash

# MapR Retail Demo - Raspberry Pi deployment automation

# Raspberry Pi Deployment github project
export RPI_GITHUB_PROJECT_NAME="raspberrypi-deployment"
export RPI_GITHUB_PROJECT_URL="https://github.com/mkieboom/$RPI_GITHUB_PROJECT_NAME"

# Create a hidden config file .rpi_config
export RPI_CONFIG_FILE="/root/.rpi_config"

# Set the Raspberry Pi variables
export INTERACTIVE=${INTERACTIVE:="true"}

export RPI_HOSTNAME="maprretail"
export RPI_USERNAME="mapr"
export RPI_PASSWORD="maprmapr"
export RPI_SSHPUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8c3uZAc1s+uxfaKdmWbAzxhCRSesUCFKWfpdm0o7R8FKS+VUMxk8xAso+/H9jxsPfC+IO/bDeIYYAtrx/yZ7AKsucI22wvg8WEAZdaZpRbK214HRSwkVpfKNihUFi/JE0BiCScjkF1DPmfiApYZLTelJyoU68AJgaWG0i6khq+YwXI2ON5SXpPblvIASqD20LljTLjcus69ZhzoQAgWJ8ixE/eLDXnxwwqwUK8gMnCNzYblemyZ6roV4e24qjw9IE7lpc47yO3MuKoTtVMqwqzdAn1W3yMQIReChEBJYRTaJsQUFQjBr+jELkbSNhJv8nJn7OOO9yd/+jygYZ+NtX mkieboom"


## Make the script interactive to set the variables
read -rp "Hostname ($RPI_HOSTNAME): " choice;
if [ "$choice" != "" ] ; then
	export RPI_HOSTNAME="$choice";
fi

read -rp "Username ($RPI_USERNAME): " choice;
if [ "$choice" != "" ] ; then
	export RPI_USERNAME="$choice";
fi

read -rp "Password ($RPI_PASSWORD): " choice;
if [ "$choice" != "" ] ; then
	export RPI_PASSWORD="$choice";
fi

read -rp "Your public SSH KEY ($RPI_SSHPUBKEY): " choice;
if [ "$choice" != "" ] ; then
	export RPI_SSHPUBKEY="$choice";
fi


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
export RPI_PASSWORD_SHA512="$(mkpasswd --method=sha-512 $RPI_PASSWORD)"


# Write the configuration to the hidden config file
echo "hostname: \""$RPI_HOSTNAME"\"" > $RPI_CONFIG_FILE
echo "username: \""$RPI_USERNAME"\"" >> $RPI_CONFIG_FILE
echo "password: \""$RPI_PASSWORD_SHA512"\"" >> $RPI_CONFIG_FILE
echo "sshkey: \""$RPI_SSHPUBKEY"\"" >> $RPI_CONFIG_FILE


# VPNC
echo "ipsec_gateway: \"portalx.mapr.com\"" >> $RPI_CONFIG_FILE
echo "ipsec_id: \"maprtech\"" >> $RPI_CONFIG_FILE
echo "ipsec_secret: \"maprmapr\"" >> $RPI_CONFIG_FILE
echo "ipsec_xauth_username: \"mkieboom\"" >> $RPI_CONFIG_FILE
echo "ipsec_xauth_password: \"R%t2MT]VFeaQZJUgoAXHs6DY\"" >> $RPI_CONFIG_FILE

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
  --extra-vars @"$RPI_CONFIG_FILE" \

