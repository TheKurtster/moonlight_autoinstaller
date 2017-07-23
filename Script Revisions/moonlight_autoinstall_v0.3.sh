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
echo "THIS SCRIPT COMES WITH ABSOLUTELY NO WARRANTY"
echo
sleep 3

echo "You are required to have an NVIDIA GeForce GPU in order to run Moonlight"
echo "It MUST be a GTX 650 or higher"
echo "If you meet this criteria, you must also have enabled Gamestream within GeForce Experience"
echo "See the video on kurtgrosser.com for more information on setting GeForce Experience up"
sleep 3

echo "You must be running a build of Raspbian in order to use this installer"
echo "The installer will now check"
sleep 2
echo

VersionChecker=$(cat /etc/os-release | grep "^ID=")

if [ "$VersionChecker" = "ID=raspbian"  ] ; then
        echo "You are running a version of Raspbian"
        echo "The installer will now proceed with the privilege check"
else
        echo 1>&2 "You are NOT running a version of Raspbian"
        echo 1>&2 "Please run this installer on a Rapsbian distro"
        echo 1>&2 "The installer will now quit"
        exit 1
fi

echo "NOTE: Some of the following commands require root privilege"
echo "You should have enabled Super User to avoid problems"
echo "To ensure that you have enabled Super User mode, the script will now check"
echo

PrivilegeChecker=$(whoami)

if [ "$PrivilegeChecker" = root ] ; then
        echo "You are the Super User!"
        echo "The installer will proceed"
else
        echo 1>&2 "You are NOT the Super User!"
        echo 1>&2 "Please enter Super User mode by typing 'sudo ./moonlight_autoinstall.sh'"
        exit 1
fi

StartInstaller=NULL

until [ "$StartInstaller" = "Y" -o "$StartInstaller" = "N" -o "$StartInstaller" = "n" -o "$StartInstaller" = "y" ]
do
        read -p "Start Now? (Y/N) " StartInstaller
done

case "$StartInstaller" in 
  y|Y ) echo "The installer will now begin";;
  n|N ) exit 2;;
  * ) echo "That is an invalid entry.";;
esac
echo

echo 1. Getting Users IP Address before Proceeding
echo ---------------------------------------------
echo
echo "To make this installer as seamless as possible, the script will get your IP Address now."
echo "To begin, please supply the IP Address of your GeForce Enabled PC."
echo "To do this, you can open a Command Prompt in Windows and type, ipconfig"
echo "See the video on kurtgrosser.com for more information"
echo
read -p "Please enter that IP Address now: " IPAddress
echo "Using $IPAddress as the address to sync with Moonlight"
sleep 2
echo


echo 2. Installing Dependencies
echo --------------------------
echo
echo "Installing all dependencies required to run Moonlight"
echo
sudo apt-get install libopus0 libasound2 libudev0 libavahi-client3 libcurl3 libevdev2
echo
echo "Dependencies Installed"
echo

echo 3. Force HDMI Audio at Boot
echo ---------------------------
echo
echo "Appending hdmi_drive=2 flag to /boot/config.txt"
echo hdmi_drive=2 >> /boot/config.txt
echo "Flag successfully appended to Boot Config file"
echo

echo 4. Adding Moonlight to the APT Sources list
echo -------------------------------------------
echo
echo "Appending source to /etc/apt/sources.list"
echo
echo "deb http://archive.itimmer.nl/raspbian/moonlight jessie main" >> /etc/apt/sources.list
echo
echo "Source successfully appended"
echo

echo 5. Updating sources
echo -------------------
echo
echo "Running apt-get update to ensure sources are up to date"
echo
sudo apt-get update -y 
echo
echo "Sources successfully updated"
echo

echo 6. Installing Moonlight
echo -----------------------
echo
echo "Proceeding with installation of Moonlight"
echo
sudo apt-get install moonlight-embedded
echo
echo "Moonlight successfully installed"
echo

echo 7. Pairing to GeForce GPU Enabled PC
echo ------------------------------------
echo
echo "Begining pairing process with GeForce Enabled PC"
echo "Ensure that GeForce Experience is running"
echo "Moonlight will provide you with a code"
echo "Please enter that code when GeForce Experience prompts you"
sleep 5
moonlight pair "$IPAddress"
echo

echo 8. Adding aliases
echo -----------------
echo
echo "Adding an alias to /home/pi/.bash_aliases for easy launching"
echo "alias steam720p30='moonlight stream -720 -30fps $IPAddress'" >> /home/pi/.bash_aliases
echo "Alias steam720p30 successfully added"
echo "alias steam720p60='moonlight stream -720 -60fps $IPAddress'" >> /home/pi/.bash_aliases
echo "Alias steam720p60 successfully added"
echo "alias steam1080p30='moonlight stream -1080 -30fps $IPAddress'" >> /home/pi/.bash_aliases
echo "Alias steam1080p30 successfully added"
echo "alias steam1080p60='moonlight stream -1080 -60fps $IPAddress'" >> /home/pi/.bash_aliases
echo "Alias steam1080p60 successfully added"
echo "All aliases successfully added!"
echo "To start Moonlight in its default mode (720p 60fps), type 'steam720p60' into a bash shell"
echo

echo 9. Cleaning Up
echo --------------
echo
echo "Moonlight has been successfully installed"
echo "To start Moonlight, type 'steam720p60' into a bash shell"
echo
echo "Thank you for using the Moonlight Auto Installer"
echo "Created by: Kurt Grosser"
echo "For more information, please visit: kurtgrosser.com"
echo
echo "In order to force the HDMI Audio to work and the aliases to register, the system must reboot"

RebootNow=NULL

until [ "$RebootNow" = "Y" -o "$RebootNow" = "N" -o "$RebootNow" = "n" -o "$RebootNow" = "y" ]
do
        read -p "Reboot Now? (Y/N) " RebootNow
done

case "$RebootNow" in 
  y|Y ) sudo shutdown -r now;;
  n|N ) echo "The script will now exit.";;
esac
echo