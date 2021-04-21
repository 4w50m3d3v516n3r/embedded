#!/bin/bash

#ensure environment is set
# shellcheck disable=SC1090
source ~/.bashrc

#first update the pi

sudo apt-get update
sudo apt-get upgrade

#setup the required dependencies
echo "Setup dependencies for the raspberry pi...."
sudo apt-get build-dep qt4-x11 
sudo apt-get install -y libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0
sudo apt-get install -y libegl1-mesa-dev libgbm-dev mesa-common-dev bluez libbluetooth-dev
sudo apt-get install -y git cmake autoconf automake bison vim libxkbcommon-dev
sudo apt-get install -y debhelper default-libmysqlclient-dev freetds-dev libasound2-dev 
sudo apt-get install -y libcups2-dev libdbus-1-dev libfontconfig1-dev libfreetype6-dev
sudo apt-get install -y libgl1-mesa-dev libgl-dev libgles2-dev libglib2.0-dev libglu1-mesa-dev
sudo apt-get install -y libglu-dev libharfbuzz-dev libicu-dev  libjpeg-dev libpng-dev libpq-dev
sudo apt-get install -y libpulse-dev libsqlite3-dev libssl-dev libx11-dev libxcb-render-util0-dev 
sudo apt-get install -y libxcb-shm0-dev libxcb1-dev libxext-dev libxi-dev libxcb-render0-dev
sudo apt-get install -y libxrender-dev pkg-kde-tools publicsuffix unixodbc-dev zlib1g-dev
sudo apt-get install -y dbus-user-session dconf-gsettings-backend dconf-service dh-exec firebird-dev 
sudo apt-get install -y firebird3.0-common firebird3.0-common-doc gir1.2-atspi-2.0 gir1.2-gtk-3.0 glib-networking
sudo apt-get install -y glib-networking-common glib-networking-services gsettings-desktop-schemas libasyncns0 
sudo apt-get install -y libatk-bridge2.0-0 libatk-bridge2.0-dev libatspi2.0-0 libatspi2.0-dev libbrotli1 libclang1-7
sudo apt-get install -y libcolord2 libdconf1 libdouble-conversion-dev libdouble-conversion1 libegl-dev 
sudo apt-get install -y libegl-mesa0 libegl1 libepoxy-dev libepoxy0 libevdev-dev libevdev2 
sudo apt-get install -y libfbclient2 libflac8 libgbm-dev libgbm1 libgles-dev libgles1 libgles2 libgles2-mesa-dev 
sudo apt-get install -y libgstreamer-plugins-base1.0-0 libgstreamer1.0-0 libgtk-3-0 libgtk-3-common libgtk-3-dev 
sudo apt-get install -y libgudev-1.0-0 libhyphen0 libib-util libinput-bin libinput-dev libinput10 
sudo apt-get install -y libjson-glib-1.0-0 libjson-glib-1.0-common libllvm7 libmtdev-dev libmtdev1 libogg0 
sudo apt-get install -y liborc-0.4-0 libpcre2-16-0 libpcre2-32-0 libpcre2-dev libproxy-dev libproxy1v5 
sudo apt-get install -y libpulse-mainloop-glib0 libpulse0 librest-0.7-0 libsndfile1 
sudo apt-get install -y libsoup-gnome2.4-1 libsoup2.4-1 libtommath1 libudev-dev libvorbis0a libvorbisenc2 
sudo apt-get install -y libvulkan-dev libvulkan1 libwacom-common libwacom-dev libwacom2 libwayland-bin
sudo apt-get install -y libwayland-client0 libwayland-cursor0 libwayland-dev libwayland-egl1 
sudo apt-get install -y libwayland-server0 libwoff1 libx11-xcb-dev libxcb-icccm4 libxcb-icccm4-dev 
sudo apt-get install -y libxcb-image0 libxcb-image0-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-randr0 
sudo apt-get install -y libxcb-randr0-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-shape0 
sudo apt-get install -y libxcb-shape0-dev libxcb-sync-dev libxcb-util0 libxcb-xfixes0 libxcb-xfixes0-dev 
sudo apt-get install -y libxcb-xkb-dev libxcb-xkb1 libxkbcommon-dev 
sudo apt-get install -y libxkbcommon-x11-0 libxkbcommon-x11-dev libxkbcommon0 wayland-protocols
sudo apt-get install -y libinput10
sudo apt-get install -y libmtdev1
sudo apt-get install -y libpcre2-16-0
sudo apt-get install -y libdouble-conversion1
sudo apt-get install -y libharfbuzz0b
sudo apt-get install -y libgles2
sudo apt-get install -y libpulse-mainloop-glib0
sudo apt-get install -y libinput10


#creating the folder for qt-cross compilation artifacts
sudo mkdir /usr/local/qt5pi 
sudo chown pi:pi /usr/local/qt5pi

#create ld entry
echo /usr/local/qt5pi/lib | sudo tee /etc/ld.so.conf.d/qt5pi.conf


#Set the QT Platform to EGLFS
echo "export QT_QPA_PLATFORM=eglfs" >> ~/.bashrc
echo "export QT_DEBUG_PLUGINS=1" >> ~/.bashrc
#apply changes to environment
# shellcheck disable=SC1090
source ~/.bashrc









