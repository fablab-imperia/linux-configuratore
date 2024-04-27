#!/bin/bash
if (( $EUID != 0 )); then
    echo "Lo script deve essere eseguito con permessi di root"
    exit
fi


##########################
#    Parte di sistema    #
##########################

## Aggiunge chiavi di Codium come da sito https://vscodium.com/#install-on-debian-ubuntu-deb-package
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list


# Aggiungo utente fablab al gruppo dialout per farlo accedere
# alle porte seriali dall'IDE Arduino
usermod -a -G dialout fablab



##################
#    SOFTWARE    #
##################
apt update
apt upgrade --yes
apt -y install $(grep -vE "#" list.txt | tr "\n" " ")
apt -y autoremove


# URL per scaricare software stampa 3D
URL_SW_STAMPANTE_3D="https://en.fss.flashforge.com/10000/software/e02d016281d06012ea71a671d1e1fdb7.deb"
# Installare software FlashPrint
wget "${URL_SW_STAMPANTE_3D}"
apt install ./e02d016281d06012ea71a671d1e1fdb7.deb



# Installa DigitalLogicSim
apt install unzip
FAB_PACKAGES_FOLDER="/opt/fablab/packages"
mkdir -p "${FAB_PACKAGES_FOLDER}"
unzip packages/Digital-Logic-Sim.zip -d "${FAB_PACKAGES_FOLDER}"
chmod +x "${FAB_PACKAGES_FOLDER}/Digital-Logic-Sim/Digital-Logic-Sim.x86_64"

cat > /usr/share/applications/digital_logic_sim.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=${FAB_PACKAGES_FOLDER}/Digital-Logic-Sim/Digital-Logic-Sim.x86_64
Name=Digital Logic Sim
EOF

