#!/bin/sh -u

# DO NOT EDIT THIS FILE
# Moonlight Auto Installer for Raspberry Pi
# Kurt Grosser --- thekurtgrosser@gmail.com
# kurtgrosser.com
# Shell Script to auto-install Moonlight Embedded
# for Raspberry Pi Users

echo "Welcome to the Moonlight Auto Installer for Raspberry Pi"
echo "Created by: Kurt Grosser"
echo "For more information, please visit: kurtgrosser.com"
echo "Grosser Entertainment 2017"
echo
sleep 3

echo "NOTE: Some of the following commands require root privilege"
echo "You should have enabled Super User to avoid problems"
echo "To ensure that you have enabled Super User mode, the script will now check"
echo

PrivilegeChecker=$(whoami)

if [ "$PrivilegeChecker" = root ] ; then
        echo "You are the Super User!"
        echo "The installer will proceed"
else
        echo "You are NOT the Super User!"
        echo "Please enter Super User mode by typing 'sudo su'"
        echo "Then please re-run this script"
        exit 1
fi

echo "The installer will start in 5 seconds."
sleep 5

IPAddress="$1"

echo 1. Installing Dependencies
echo --------------------------
echo
echo "Installing all dependencies required to run Moonlight"
sudo apt-get install libopus0 libasound2 libudev0 libavahi-client3 libcurl3 libevdev2
echo "Dependencies Installed"
echo

echo 2. Force HDMI Audio at Boot
echo ---------------------------
echo
echo "Appending hdmi_drive=2 flag to /boot/config.txt"
#echo hdmi_drive=2 >> /boot/config.txt
echo "Flag successfully appended to Boot Config file"
echo

echo 3. Adding Moonlight to the APT Sources list
echo -------------------------------------------
echo
echo "Appending source to /etc/apt/sources.list"
#echo deb http://archive.itimmer.nl/raspbian/moonlight jessie main >> /etc/apt/sources.list
echo "Source successfully appended"
echo

echo 4. Updating sources
echo -------------------
echo
echo "Running apt-get update to ensure sources are up to date"
#sudo apt-get update
echo "Sources successfully updated"
echo

echo 5. Installing Moonlight
echo -----------------------
echo
echo "Proceeding with installation of Moonlight"
#sudo apt-get install moonlight-embedded
echo "Moonlight successfully installed"

echo 6. Pairing to GeForce GPU Enabled PC
echo ------------------------------------
echo
echo PLACEHOLDER
echo

echo 7. Adding alias
echo ---------------
echo
echo "Adding an alias to /home/pi/.bash_aliases for easy launching"
echo "alias steam='moonlight stream $IPAddress'" >> /home/pi/.bash_aliases
echo "Alias successfully added"
echo "To start Moonlight in its default mode (720p 60fps), type 'steam' into a bash shell"
echo

echo 8. Cleaning Up
echo --------------
echo
echo "Moonlight has been successfully installed"
echo "To start Moonlight, type 'steam' into a bash shell"
echo
echo "Thank you for using the Moonlight Auto Installer"
echo "Created by: Kurt Grosser"
echo "For more information, please visit: kurtgrosser.com"
echo
echo "In order to force the HDMI Audio to work, the system must reboot"
echo "The system will reboot in 10 seconds."
sleep 10
#reboot