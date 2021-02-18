#!/bin/bash

#ensure environment is set
source ~/.bashrc

#first update the pi

sudo apt-get update
sudo apt-get upgrade

#setup the required dependencies
echo "Setup dependencies for the raspberry pi...."
sudo apt-get build-dep qt4-x11 
sudo apt-get build-dep libqt5gui5 
sudo apt-get install -y libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0
sudo apt-get install -y libegl1-mesa-dev libgbm-dev libgles2-mesa-dev mesa-common-dev
sudo apt-get install -y bluez libbluetooth-dev
sudo apt-get install -y git cmake autoconf automake bison vim
sudo apt-get install -y libxkbcommon0 libxkbcommon-dev
sudo apt-get install -y debhelper default-libmysqlclient-dev firebird-dev
sudo apt-get install -y freetds-dev libasound2-dev libatspi2.0-dev
sudo apt-get install -y libcups2-dev libdbus-1-dev libdouble-conversion-dev
sudo apt-get install -y libfontconfig1-dev libfreetype6-dev
sudo apt-get install -y libgbm-dev libgl1-mesa-dev
sudo apt-get install -y libgl-dev libgles2-dev
sudo apt-get install -y libglib2.0-dev libglu1-mesa-dev
sudo apt-get install -y libglu-dev libgtk-3-dev
sudo apt-get install -y libharfbuzz-dev libicu-dev libinput-dev
sudo apt-get install -y libjpeg-dev libmtdev-dev libpcre2-dev
sudo apt-get install -y libpng-dev libpq-dev libproxy-dev
sudo apt-get install -y libpulse-dev libsqlite3-dev libssl-dev
sudo apt-get install -y libudev-dev libvulkan-dev libx11-dev
sudo apt-get install -y libx11-xcb-dev libxcb-icccm4-dev libxcb-image0-dev
sudo apt-get install -y libxcb-keysyms1-dev libxcb-randr0-dev
sudo apt-get install -y libxcb-render-util0-dev libxcb-render0-dev
sudo apt-get install -y libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev
sudo apt-get install -y libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xkb-dev
sudo apt-get install -y libxcb1-dev libxext-dev libxi-dev libxkbcommon-dev
sudo apt-get install -y libxkbcommon-x11-dev libxrender-dev pkg-kde-tools
sudo apt-get install -y publicsuffix unixodbc-dev zlib1g-dev qttools5-dev-tools


#creating the folder for qt-cross compilation artifacts
sudo mkdir /usr/local/qt5pi 
sudo chown pi:pi /usr/local/qt5pi

#create ld entry
echo /usr/local/qt5pi/lib | sudo tee /etc/ld.so.conf.d/qt5pi.conf


#Set the QT Platform to EGLFS
echo "export QT_QPA_PLATFORM=eglfs" >> ~/.bashrc
#apply changes to environment
source ~/.bashrc



