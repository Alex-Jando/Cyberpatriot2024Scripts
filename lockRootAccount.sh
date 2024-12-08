#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi

# ========================LOCK ROOT ACCOUNT========================

# Lock root account
echo "Locking root account"
passwd --lock root
echo "Root account has been locked"