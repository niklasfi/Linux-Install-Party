#!/bin/bash

set -e

# Root pruefen 

if [ x$EUID != x0 ]
then
  echo "Du bist nicht ROOT ... verwende \"sudo bash $0\" !"
  exit 1
fi


#Allgemeine Programme, Codecs, etc. installieren (VPN, LaTeX, gcc, Flash, unrar...)

echo "Programme, die für alle Fachrichtungen interressant sind (VPN, LaTeX, Flash, unrar, etc.)"
echo "Magst du mit der Installation dieser fortfahren? (y/n)"

read allgemein


if [ "$allgemein" = "y" -o "$allgemein" = "Y" ]
	then apt-get -y --quiet install ubuntu-restricted-extras;
	echo "Codec Installation abgeschlossen";
	apt-get install -y build-essential gcc g++ make automake vpnc network-manager-vpnc pwgen;
	apt-get install texlive-full;
	echo "Development Programme, VPN und LaTeX abgeschlossen";
else
	echo "Es wurde nichts installiert"
fi


#Medibuntu einbinden

echo "Sollen die Medibuntu-Paketquellen hinzugefügt werden? (y/n)"

read medi;

if [ "$medi" = "y" -o "$medi" = "Y" ]
	then
	wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && apt-get --quiet update && apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && apt-get --quiet update
	apt-get --quiet install -y app-install-data-medibuntu apport-hooks-medibuntu
	apt-get --quiet install -y non-free-codecs;
	apt-get --quiet install -y libdvdread4;
	/usr/share/doc/libdvdread4/install-css.sh;
	apt-get --quiet install -y libdvdcss2 libxine1-ffmpeg gxine mencoder;
	apt-get --quiet install -y ffmpeg;
	apt-get --quiet install -y vlc mplayer;
	echo "DVDs abspielen ist nun möglich; der VLC Player und mplayer sind installiert worden";
else
	echo "Es wurde nichts installiert"
fi


#Fachrichtung wählen

echo "Wähle deine Fachrichtung:"
echo "Informatik: 1"
echo "Physik: 2"
echo "Mathematik: 3"

read answer

if [ $answer -eq 1 ]; then
	echo "deb http://archive.canonical.com/ubuntu/ natty partner
	deb-src http://archive.canonical.com/ubuntu/ natty partner" > /etc/apt/sources.list.d/java.list
	apt-get update
	apt-get --quiet install -y sun-java6-jdk eclipse hugs swi-prolog;

	echo "Java, Haskell, Prolog und Eclipse wurden installiert";
elif [ $answer -eq 2 ]; then
	wget -c http://downloads.sourceforge.net/project/cernrootdebs/latest-recommended/root_5.30.01_amd64.deb && dpkg -i root_5.30.01_amd64.deb && rm -f root_5.30.01_amd64.deb || { rm -f root_5.30.01_amd64.deb; echo "Interner-Fehler beim Installieren von root"; exit 1; }
	apt-get --quiet install -y python python-numpy python-simpy python-scipy python-matplotlib ipython python-dev gnuplot wxmaxima kmplot;
elif [ $answer -eq 3 ]
	then echo "Bitte wende dich an deine Professoren"
fi
