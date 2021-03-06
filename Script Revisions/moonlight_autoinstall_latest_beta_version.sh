#!/bin/bash
# DO NOT EDIT THIS FILE

# Moonlight Auto Installer for Raspberry Pi
# Kurt Grosser --- thekurtgrosser@gmail.com
# KurtGrosser.com --- @KurtGrosser
# Shell Script to auto-install Moonlight Embedded
# for Raspberry Pi Users
# Latest script revision allows for RetroPie
# users to utilize Launch Scripts

echo "Welcome to the Moonlight Auto Installer for Raspberry Pi"
echo "Created by: Kurt Grosser"
echo "For more information, please visit: kurtgrosser.com"
echo "Grosser Entertainment 2017"
echo "This script is licensed under a GNU/GPL."
echo
sleep 3

if [ "$#" -gt 0 ]; then
        echo "ERROR! ARGUMENT(S) SUPPLIED TO SCRIPT"
        echo "DO NOT SUPPLY ARGUMENTS TO THIS SCRIPT"
        echo "EXITING"
        exit 1
fi

echo "You are required to have an NVIDIA GeForce GPU in order to run Moonlight."
echo "It MUST be a GTX 650 or higher."
echo "If you meet this criteria, you must also have enabled Gamestream within GeForce Experience."
echo "See the video on kurtgrosser.com for more information on setting GeForce Experience up."
echo
sleep 3

echo "You must be running a build of Raspbian in order to use this installer."
echo "The installer will now check."
sleep 2
echo

VersionChecker=$(cat /etc/os-release | grep "^ID=")

if [ "$VersionChecker" = "ID=raspbian"  ] ; then
        echo "You are running a version of Raspbian."
        echo "The installer will now proceed with the privilege check."
        echo
else
        echo 1>&2 "You are NOT running a version of Raspbian."
        echo 1>&2 "Please run this installer on a Rapsbian distro."
        echo 1>&2 "The installer will now quit."
        exit 2
fi

echo "NOTE: Some of the following commands require root privilege"
echo "You should have enabled Super User to avoid problems."
echo "To ensure that you have enabled Super User mode, the script will now check."
sleep 2
echo


PrivilegeChecker=$(whoami)

if [ "$PrivilegeChecker" = root ] ; then
        echo "You are the Super User!"
        echo "The installer will proceed."
        echo
else
        echo 1>&2 "You are NOT the Super User!"
        echo 1>&2 "Please enter Super User mode by typing 'sudo ./moonlight_autoinstall.sh'"
        exit 3
fi

StartInstaller=NULL

until [ "$StartInstaller" = "Y" -o "$StartInstaller" = "y" -o "$StartInstaller" = "N" -o "$StartInstaller" = "n" ]
do
        read -p "Start Now? (Y/N) " StartInstaller
done

case "$StartInstaller" in 
  y|Y ) echo "The installer will now begin.";;
  n|N ) exit 4;;
esac

echo

if [ -e /opt/retropie/VERSION ]; then
    RetroPieChecker=0
elif [ ! -e /opt/retropie/VERSION ]; then
    RetroPieChecker=1
fi

echo 1. Getting Users IP Address before Proceeding
echo ---------------------------------------------
echo
echo "To make this installer as seamless as possible, the script will get your IP Address now."
echo "To begin, please supply the IP Address of your GeForce Enabled PC."
echo "To do this, you can open a Command Prompt in Windows and type, ipconfig."
echo "See the video on kurtgrosser.com for more information."
echo

IPAddress=NULL
ConfirmationVar=NULL
	
until [ "$ConfirmationVar" = "YES" ]
do
	if [ "$IPAddress" = "NULL" ]; then
		until [[ "$IPAddress" =~ ^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$ ]]
		do
			read -p "Please enter a valid IP Address now: " IPAddress
		done
	fi
	
	read -p "Are you sure you want to use $IPAddress to pair with Moonlight? (Y/N) " ConfirmationVar

	case "$ConfirmationVar" in 
	n|N ) IPAddress=NULL ;;
	y|Y ) ConfirmationVar=YES ;;
	esac

done

echo "Using $IPAddress as the address to sync with Moonlight."
sleep 2
echo

echo 2. Installing Dependencies
echo --------------------------
echo
echo "Installing all dependencies required to run Moonlight."
echo
sleep 3
sudo apt-get install -y libopus0 libasound2 libudev0 libavahi-client3 libcurl3 libevdev2
echo
echo "Dependencies Installed."
echo

echo 3. Force HDMI Audio at Boot
echo ---------------------------
echo

if [ "$RetroPieChecker" = 0 ]; then
        HDMIAudioFlag=NULL
elif [ "$RetroPieChecker" = 1 ]; then
        HDMIAudioFlag=$(cat /boot/config.txt | grep "^hdmi_drive=2")
fi

if [ "$HDMIAudioFlag" = "" ]; then
        echo "Appending hdmi_drive=2 flag to /boot/config.txt"
        echo "This will force HDMI Audio when the Pi starts."
        echo "hdmi_drive=2" >> /boot/config.txt
        echo "Flag successfully appended to Boot Config file."
        echo
elif [ "$HDMIAudioFlag" = "hdmi_drive=2" ]; then
        echo "Flag already exists."
        echo "HDMI is forced at boot."
        echo "Skipping step."
        echo
elif [ "$HDMIAudioFlag" = "NULL" ]; then
        echo "HDMI audio should've been already set when setting up RetroPie, skipping."
        echo
fi

echo 4. Adding Moonlight to the APT Sources list
echo -------------------------------------------
echo

MoonlightSource=$(cat /etc/apt/sources.list | grep "^deb http://archive.itimmer.nl/raspbian/moonlight jessie main")

if [ "$MoonlightSource" = "" ]; then
        echo "Appending Moonlight source to /etc/apt/sources.list"
        echo "This will allow Moonlight to be installed."
        echo "deb http://archive.itimmer.nl/raspbian/moonlight jessie main" >> /etc/apt/sources.list
        echo "Source successfully appended to APT sources list."
        echo
elif [ "$MoonlightSource" = "deb http://archive.itimmer.nl/raspbian/moonlight jessie main" ]; then
        echo "Source already exists within APT sources list."
        echo "Skipping step."
        echo
fi

sleep 3

ITimmerKeyCheck=$(sudo apt-key list | grep "Iwan Romario Timmer")

if [ "$ITimmerCheck" = "uid                  Iwan Romario Timmer <irtimmer@gmail.com>" ]; then
        echo "Moonlight Source GPG Key already exists, skipping."
        sleep 3
fi

until [ "$ITimmerKeyCheck" = "uid                  Iwan Romario Timmer <irtimmer@gmail.com>" ] 
do
        echo "Downloading the GPG Key for the Moonlight Source."
        echo
        curl -o /tmp/itimmer.gpg http://archive.itimmer.nl/itimmer.gpg
        echo
        echo "Adding the GPG Key for the Moonlight Source."
        sudo apt-key add /tmp/itimmer.gpg
        ITimmerKeyCheck=$(sudo apt-key list | grep "Iwan Romario Timmer")
done
echo

echo 5. Updating sources
echo -------------------
echo
echo "Running apt-get update to ensure sources are up to date."
sleep 2
echo
sudo apt-get update -y
echo
echo "Sources updated!"
echo

echo 6. Installing Moonlight
echo -----------------------
echo

MoonlightCheck=$(which moonlight)

until [ "$MoonlightCheck" = "/usr/bin/moonlight" ]
do
        MoonlightCheck=$(which moonlight)
        
        if [ "$MoonlightCheck" = "" ]; then
                echo "Installing Moonlight."
                echo
                sudo apt-get install -y moonlight-embedded
                echo
        fi
done

echo "Moonlight is installed!"
echo

echo 7. Pairing to GeForce GPU Enabled PC
echo ------------------------------------
echo
echo "Begining pairing process with GeForce Enabled PC."
echo "Ensure that GeForce Experience is running."
echo "Moonlight will provide you with a code."
echo "Please enter that code when GeForce Experience prompts you."
sleep 10
sudo moonlight pair "$IPAddress"
echo

echo 8. Adding aliases
echo -----------------
echo

SheBangLine="#!/bin/bash"

if [ ! -e /home/pi/.bash_aliases ]; then
    touch /home/pi/.bash_aliases
fi

var720p30=$(cat /home/pi/.bash_aliases | grep "^alias steam720p30='moonlight stream -720 -fps 30 $IPAddress'")
var720p60=$(cat /home/pi/.bash_aliases | grep "^alias steam720p60='moonlight stream -720 -fps 60 $IPAddress'")
var1080p30=$(cat /home/pi/.bash_aliases | grep "^alias steam1080p30='moonlight stream -1080 -fps 30 $IPAddress'")
var1080p60=$(cat /home/pi/.bash_aliases | grep "^alias steam1080p60='moonlight stream -1080 -fps 60 $IPAddress'")
SteamPair=$(cat /home/pi/.bash_aliases | grep "^alias steampair='moonlight pair $IPAddress'")

case "$RetroPieChecker" in
    0)
        echo "RetroPie is installed, adding launch scripts."
        mkdir -p /home/pi/RetroPie/roms/SteamStreaming
        echo "$SheBangLine" > /home/pi/RetroPie/roms/SteamStreaming/steam720p30.sh
        echo "moonlight stream -720 -fps 30 "$IPAddress"" >> /home/pi/RetroPie/roms/SteamStreaming/steam720p30.sh
        echo "$SheBangLine" > /home/pi/RetroPie/roms/SteamStreaming/steam720p60.sh
        echo "moonlight stream -720 -fps 60 "$IPAddress"" >> /home/pi/RetroPie/roms/SteamStreaming/steam720p60.sh
        echo "$SheBangLine" > /home/pi/RetroPie/roms/SteamStreaming/steam1080p30.sh
        echo "moonlight stream -1080 -fps 30 "$IPAddress"" >> /home/pi/RetroPie/roms/SteamStreaming/steam1080p30.sh
        echo "$SheBangLine" > /home/pi/RetroPie/roms/SteamStreaming/steam1080p60.sh
        echo "moonlight stream -1080 -fps 60 "$IPAddress"" >> /home/pi/RetroPie/roms/SteamStreaming/steam1080p60.sh
        echo "$SheBangLine" > /home/pi/RetroPie/roms/SteamStreaming/steampair.sh
        echo "moonlight pair "$IPAddress"" >> /home/pi/RetroPie/roms/SteamStreaming/steampair.sh
        sudo chown -R pi:pi /home/pi/RetroPie/roms/SteamStreaming
        ;;
    1)
        echo "RetroPie is NOT installed, skipping launch scripts."
        ;;
esac

case "$var720p30" in
    "")
        echo "Adding steam720p30 alias."
        echo "alias steam720p30='moonlight stream -720 -fps 30 $IPAddress'" >> /home/pi/.bash_aliases
        ;;
    "alias steam720p30='moonlight stream -720 -fps 30 $IPAddress'")
        echo "720p30 alias already exists, skipping."
        ;;
esac

case "$var720p60" in
    "")
        echo "Adding steam720p60 alias."
        echo "alias steam720p60='moonlight stream -720 -fps 60 $IPAddress'" >> /home/pi/.bash_aliases
        ;;
    "alias steam720p60='moonlight stream -720 -fps 60 $IPAddress'")
        echo "720p60 alias already exists, skipping."
        ;;
esac

case "$var1080p30" in
    "")
        echo "Adding steam1080p30 alias."
        echo "alias steam1080p30='moonlight stream -1080 -fps 30 $IPAddress'" >> /home/pi/.bash_aliases
        ;;
    "alias steam1080p30='moonlight stream -1080 -fps 30 $IPAddress'")
        echo "1080p30 alias already exists, skipping."
        ;;
esac

case "$var1080p60" in
    "")
        echo "Adding steam1080p60 alias."
        echo "alias steam1080p60='moonlight stream -1080 -fps 60 $IPAddress'" >> /home/pi/.bash_aliases
        ;;
    "alias steam1080p60='moonlight stream -1080 -fps 60 $IPAddress'")
        echo "1080p60 alias already exists, skipping."
        ;;
esac

case "$SteamPair" in
    "")
        echo "Adding steampair alias."
        echo "alias steampair='moonlight pair $IPAddress'" >> /home/pi/.bash_aliases
        ;;
    "alias steampair='moonlight pair $IPAddress'")
        echo "SteamPair alias already exists, skipping."
        ;;
esac

echo "To start Moonlight in its default mode (720p fps 60), type 'steam720p60' into a bash shell."
echo "Alternatively, if you use RetroPie, Steam Launch Scripts should now appear in EmulationStation."
echo
sleep 3
echo "Changing ownership of files and folders back to user pi."
sudo chown pi:pi /home/pi/.bash_aliases
echo

echo 9. Adding Steam Functions to Retropie
echo -------------------------------------
echo

if [ "$RetroPieChecker" = 0 ]; then
        EmulationStationConfigCheck=$(test -f /home/pi/.emulationstation/es_systems.cfg; echo "$?")
elif [ "$RetroPieChecker" = 1 ]; then
        EmulationStationConfigCheck=NULL
fi

if [ -e /home/pi/.emulationstation/es_systems.cfg ]; then
    SteamESConfigCheck=$(cat /home/pi/.emulationstation/es_systems.cfg | grep "<fullname>Steam</fullname>")
else
    SteamESConfigCheck=NULL
fi

if [ "$SteamESConfigCheck" = "    <fullname>Steam</fullname>" ]; then
    EmulationStationConfigCheck=INSTALLED
fi

case "$EmulationStationConfigCheck" in
        1)
                echo "Copying the EmulationStation System Config file."
                cp -a /etc/emulationstation/es_systems.cfg /home/pi/.emulationstation/es_systems.cfg
                echo "Adding Steam to the list of Systems in EmulationStation."
                sed -i -e 's|</systemList>|  <system>\n    <name>steam</name>\n    <fullname>Steam</fullname>\n    <path>~/RetroPie/roms/SteamStreaming</path>\n    <extension>.sh .SH</extension>\n    <command>bash %ROM%</command>\n    <platform>steam</platform>\n    <theme>steam</theme>\n  </system>\n</systemList>|g' /home/pi/.emulationstation/es_systems.cfg
                chown pi:pi /home/pi/.emulationstation/es_systems.cfg
                ;;
        0) 
                echo "Adding Steam to the list of Systems in EmulationStation"
                sed -i -e 's|</systemList>|  <system>\n    <name>steam</name>\n    <fullname>Steam</fullname>\n    <path>~/RetroPie/roms/SteamStreaming</path>\n    <extension>.sh .SH</extension>\n    <command>bash %ROM%</command>\n    <platform>steam</platform>\n    <theme>steam</theme>\n  </system>\n</systemList>|g' /home/pi/.emulationstation/es_systems.cfg
                chown pi:pi /home/pi/.emulationstation/es_systems.cfg
                ;;
        NULL)
                echo "RetroPie is not installed, skipping step."
                ;;
        INSTALLED)
                echo "Steam has already been added to the Emulation Station Systems Configuration file, skipping."
                ;;
esac
echo

echo 10. Finishing Up
echo ----------------
echo
echo "Moonlight has been successfully installed."
echo "To start Moonlight, type 'steam720p60' into a bash shell."
echo "Alternatively, if you use RetroPie, Steam should now show up as an option."
echo
echo "Thank you for using the Moonlight Auto Installer."
echo "Created by: Kurt Grosser"
echo "For more information, please visit: kurtgrosser.com"
echo
echo "In order to force the HDMI Audio to work and the aliases to register, the system must reboot."
echo

RebootNow=NULL

until [ "$RebootNow" = "Y" -o "$RebootNow" = "N" -o "$RebootNow" = "n" -o "$RebootNow" = "y" ]
do
        read -p "Reboot Now? (Y/N) " RebootNow
done

case "$RebootNow" in 
  y|Y ) 
        sudo shutdown -r now
        ;;
  n|N ) 
        echo "The script will now exit."
        exit 0
        ;;
esac