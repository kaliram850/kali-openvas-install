#!/bin/bash

DIRECTORY=`pwd`

sudo locale-gen en_US.UTF-8
export LC_ALL="C"

# Install the pre-requisites for OpenVAS
sudo $DIRECTORY/root/1-requirements.sh

# Create the GVM user
sudo $DIRECTORY/root/2-create-user.sh

# Install the initial GVM scripts as the GVM user
sudo /bin/su -c "$DIRECTORY/gvm/3-create-user.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/4-git-clone.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/5-install-gvm-libs.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/6-install-openvas-smb.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/7-install-openvas.sh" - gvm

# Run the next series of root scripts
sudo $DIRECTORY/root/8-fix-redis.sh
sudo $DIRECTORY/root/9-sudoers.sh

# Next GVM Scripts
sudo /bin/su -c "$DIRECTORY/gvm/10-install-openvas.sh" - gvm

# Update OpenVAS Plugins
sudo openvas -u

sudo /bin/su -c "$DIRECTORY/gvm/11-config-and-build-manager.sh" - gvm

# Postgres Scripts
sudo service postgres start
sudo /bin/su -c "$DIRECTORY/gvm/12-setup-postgres.sh" - postgres

# Third round of GVM scripts
sudo /bin/su -c "$DIRECTORY/gvm/13-manage-certs.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/14-create-admin-user.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/15-update-feeds.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/16-update-iana.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/17-install-gsa.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/18-install-virtualenv.sh" - gvm
sudo /bin/su -c "$DIRECTORY/gvm/19-install-ospd.sh" - gvm

# Next round of root scripts
sudo $DIRECTORY/root/20-create-startup-scripts.sh
sudo $DIRECTORY/root/21-restart-services.sh
sudo $DIRECTORY/root/22-check-service-status.sh

# Fourth round of GVM Scripts
sudo /bin/su -c "$DIRECTORY/gvm/23-setup-scanner.sh" - gvm
