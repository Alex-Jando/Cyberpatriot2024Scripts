#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi

# ========================CONFIGURE FILE PERMISSIONS FOR IMPORTANT FILES========================

chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/passwd
chmod 644 /etc/group