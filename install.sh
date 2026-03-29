#!/bin/bash
if (( $EUID != 0 )); then
    echo "Lo script deve essere eseguito con permessi di root"
    exit
fi



# Aggiungo utente fablab al gruppo dialout per farlo accedere
# alle porte seriali dall'IDE Arduino
usermod -a -G dialout fablab



##################
#    SOFTWARE    #
##################
apt update
apt upgrade --yes

#Install standard packages
apt -y install $(grep -vE "#" list.txt | tr "\n" " ")
apt -y autoremove

# Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main"
sudo apt update
sudo apt -y install google-chrome-stable

#Freecad
add-apt-repository ppa:freecad-maintainers/freecad-stable
apt update
apt install -y freecad 


#Visual Studio code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt update
apt install -y code


# Arduino IDE v2
flatpak install flathub cc.arduino.IDE2

#Bambustudio
flatpak install flathub com.bambulab.BambuStudio