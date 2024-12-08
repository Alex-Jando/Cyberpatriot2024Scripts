#!/bin/bash

# ========================ENSURE SCRIPT IS RUN AS ROOT========================
if [[ $EUID != 0 ]]
then
    echo "Please run this script as root"
    exit
fi


# ========================LIST FILES IN NON-CURRENT USER DIRECTORIES========================

echo "Scanning /home for files belonging to users other than the current script executor..."

# Extract the username of the script executor from the current working directory
currentUser=$(echo "$PWD" | cut -d'/' -f3)

# Iterate through all home directories
for userDir in /home/*; do
    # Extract username from the directory path
    user=$(basename "$userDir")
    
    # Skip the current user
    if [[ "$user" != "$currentUser" ]]; then
        echo "Listing files in /home/$user"
        
        # Find and output the absolute paths of all files, excluding specified files
        find "$userDir" -type f ! -name ".profile" ! -name ".bashrc" ! -name ".bash_logout" 2>/dev/null | while read -r file; do
            echo "$file"
        done
    fi
done

echo "Scan of non-current user directories completed"