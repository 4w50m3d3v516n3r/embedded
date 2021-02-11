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
sudo apt-get install libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0
sudo apt-get install -y libegl1-mesa-dev libgbm-dev libgles2-mesa-dev mesa-common-dev
sudo apt-get install -y bluez libbluetooth-dev
sudo apt-get install git cmake autoconf automake bison vim
sudo apt-get install libxkbcommon0 libxkbcommon-dev


#creating the folder for qt-cross compilation artifacts
sudo mkdir /usr/local/qt5pi 
sudo chown pi:pi /usr/local/qt5pi

#create ld entry
echo /usr/local/qt5pi/lib | sudo tee /etc/ld.so.conf.d/qt5pi.conf


#Set the QT Platform to EGLFS
echo "export QT_QPA_PLATFORM=eglfs" >> ~/.bashrc
#apply changes to environment
source ~/.bashrc




