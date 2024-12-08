#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi

# ========================CONFIGURE SSH========================

cp /etc/ssh/sshd_config $backupDir/sshd_config.bak

# Remove root login
sed -i '/PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config

# Ignore Rhosts
sed -i '/IgnoreRhosts/s/no/yes/' /etc/ssh/sshd_config

# Disable Password Authentication
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Disable X11 Forwarding
sed -i 's/^X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config

# Set MaxAuthTries to 3
sed -i 's/^MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config

# Set LoginGraceTime to 30 seconds
sed -i 's/^LoginGraceTime.*/LoginGraceTime 30/' /etc/ssh/sshd_config

# Restart SSH service
systemctl restart ssh