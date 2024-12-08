#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi

# ========================UNINSTALL HACKING RELATED SOFTWARE========================

# Put the hacking tools you want to uninstall in the array below
hackingTools=("nmap" "hydra" "john" "netcat")

for tool in "${hackingTools[@]}"; do
    if dpkg -l | grep -q "$tool"; then
        echo "$tool is installed. Uninstalling..."
        apt purge -y "$tool" > /dev/null
        echo "$tool has been uninstalled"
    else
        echo "$tool is not installed"
    fi
done

apt autoremove -y
apt autoclean -y