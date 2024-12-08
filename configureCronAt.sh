#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi

# ========================CONFIGURE CRON AND AT========================

# Create allow lists
echo "root" > /etc/cron.allow
echo "root" > /etc/at.allow

# Restrict access to others
chmod 600 /etc/cron.allow /etc/at.allow