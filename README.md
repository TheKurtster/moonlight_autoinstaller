# Moonlight Auto Installer Shell Script

This script will guide a user through the installation process of the Moonlight Embedded Streaming Service for the Raspberry Pi.
This will aid the user to run Steam In-Home Streaming straight from their Raspbian PIXEL Desktop.
The latest revision of the script also enables users to run Steam In-Home Streaming straight from RetroPie's EmulationStation interface.

To further simplify things, the script also creates Bash Aliases that will allow the user to seamlessly start the service in a variety of modes.
For RetroPie users, it creates a Steam Interface and adds launch scripts to avoid having to exit to the Terminal.
It also allows them to re-pair Moonlight with one command, should it be necessary.

Script Revisions are available for viewing in the "Script Revisions" folder.

For more information, you can visit KurtGrosser.com for the full video tutorial.


# How to Run the Installer

To begin the installation process, enter these commands in a Bash Terminal:

    wget kurtgrosser.com/moonlightautoinstall

    chmod +x moonlightautoinstall

    sudo ./moonlightautoinstall

Alternatively, if the above shortlink does not work you can also use:
    
    wget https://raw.githubusercontent.com/TheKurtster/moonlight_autoinstaller/master/moonlight_autoinstall.sh

    chmod +x moonlight_autoinstall.sh
    
    sudo ./moonlight_autoinstall.sh

Then just follow the on-screen instructions to install Moonlight.
