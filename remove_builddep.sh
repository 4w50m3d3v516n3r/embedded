#!/bin/bash
#Source: https://askubuntu.com/questions/180504/how-can-i-remove-all-build-dependencies-for-a-particular-package
read -p "Enter package name: " packageName
sudo apt-mark auto $(apt-cache showsrc $packageName | sed -e '/Build-Depends/!d;s/Build-Depends: \|,\|([^)]*),*\|\[[^]]*\]//g' | sed -E 's/\|//g; s/<.*>//g')
sudo apt-mark manual build-essential fakeroot devscripts
sudo apt autoremove --purge
