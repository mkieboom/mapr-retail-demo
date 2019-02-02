#!/bin/bash

# MapR Retail Demo - MapR Cluster requirements deployment

# MapR Retail Demo github project
export RETAIL_GITHUB_PROJECT_NAME="mapr-retail-demo"
export RETAIL_GITHUB_PROJECT_URL="https://github.com/mkieboom/$RETAIL_GITHUB_PROJECT_NAME"

# Install git
echo "Installing basics... please wait"
yum install -qq -y ansible git

# Clone the ansible project
echo "Cloning the ansible project from github"
cd ~/
if [ ! -d "$RETAIL_GITHUB_PROJECT_NAME" ]; then
	# github project not yet there, get it using git clone
	git clone $RETAIL_GITHUB_PROJECT_URL
else
	# github project already there, update it using git pull
	cd ~/$RETAIL_GITHUB_PROJECT_NAME
	git pull $RETAIL_GITHUB_PROJECT_URL
fi

# Run the ansible playbook
cd ~/$RETAIL_GITHUB_PROJECT_NAME/cluster
#ansible-playbook \
#  -i myhosts/1node_cluster \
#  mapr-retail-demo.yml \
#  --connection=local
