#!/bin/bash
#variables
FILE="sysroot-relativelinks.py"
PYLINK="/bin/python"
IDFILE1=~/.ssh/id_rsa.pub
IDFILE2=~/.ssh/id_dsa.pub
PUBLIC_KEY1=~/.ssh/id_rsa.pub
PUBLIC_KEY2=~/.ssh/id_dsa.pub

add_python_symlink()
{
    echo "checking for python symlink in /bin"
    
    if [ -L ${PYLINK} ] ; then
        if [ -e ${PYLINK} ] ; then
            echo "Python is already correctly linked."
            return 0
        else
            echo "Link to python is broken."
        fi
        elif [ -e ${PYLINK} ] ; then
        echo "Seems not to be a valid symlink, maybe a file"
        return 1
    else
        echo "The symlink to python does not exist."
        echo "Creating a symlink to the most current python version on the system"
        
        pyver=$(ls -1 /bin/python* | grep '[2-3]\{0,\}.$' | sort -r | head -n 1)
        
        if ! [ -z ${pyver} ]; then
            echo "Linking to python in $pyver"
            sudo ln -s $pyver /bin/python
            return 0
        else
            echo "cannot find a python interpreter in /bin"
            return 1
        fi
        
    fi
    
    
}

#parameter count check
if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "on_host.sh RASPBERRYIP QTVERSIONTOCHECKOUT"
    echo "Example:"
    echo "on_host.sh pi@raspberrypi 5.12"
    echo "or:"
    echo "on_host.sh pi@192.168.177.33 5.12"
    exit 1
fi

#create tooling directory and download ARM-Compiler, unpack
echo "Creating tooling directory"

mkdir ~/raspi
cd ~/raspi
mkdir tools
cd tools

#Download ARM Compiler
echo "Dowloading ARM Compiler... this may take a while...."
wget https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
echo "Extracting compiler binaries..."
tar -xvf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
echo "removing compiler binary..."
rm gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz

#Create Sys-Root
cd ~/raspi
mkdir sysroot sysroot/usr sysroot/opt

#authenticate on py without keys
echo "Trying to establish ssh-key authentication for your Raspberry Pi"
echo "Checking first, if you created already an ssh rsa id...."


if [ -f "$IDFILE1" ]; then
    echo "You have an RSA key."
    elif [ -f "$IDFILE2"]; then
    echo "You have an DSA key."
else
    echo "You have no DSA or RSA key, let's generate one. Calling ssh-keygen..."
    echo "Please choose the default location..."
    echo "Please choose to encrypt the private SSH key and choose a passphrase."
    echo "It is more secure."
    ssh-keygen
    echo "Checking for your public key...."
    if [ -f "$PUBLIC_KEY1" ]; then
        echo "Trying to setup your public RSA key on your Raspberry"
        ssh-copy-id -i $PUBLIC_KEY1 $1
        elif [ - "$PUBLIC_KEY2" ]; then
        echo "Trying to setup your public DSA key on your Raspberry"
        ssh-copy-id -i $PUBLIC_KEY1 $1
    else
        echo "Could not find either an RSA or DSA key. You have to authenticate yourself to rsync"
    elif
    
fi


#Sync libraries from Raspberry Pi
echo "Syncing libraries from Raspberry Pi into Sysroot. Remeber to do this every time you add any libraries to the PI"
rsync -avz --rsync-path="sudo rsync" --delete $1:/lib sysroot
rsync -avz --rsync-path="sudo rsync" --delete $1:/usr/include sysroot/usr
rsync -avz --rsync-path="sudo rsync" --delete $1:/usr/lib sysroot/usr
rsync -avz --rsync-path="sudo rsync" --delete $1:/opt/vc sysroot/opt

#Adjust Symlinks to be relative
wget https://raw.githubusercontent.com/Kukkimonsuta/rpi-buildqt/master/scripts/utils/sysroot-relativelinks.py
chmod +x sysroot-relativelinks.py

#Create symlink to latest python version and point to /bin/python
add_python_symlink

#TODO: Check if there is a symlink to python, what kind of pyhton naming is used here
./sysroot-relativelinks.py sysroot

#Get QT from git, specific branch
cd ~
git clone https://code.qt.io/qt/qt5.git
cd qt5
git checkout $2
./init-repository

#Cross Compile QT
#configure
./configure -release -opengl es2 -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=~/raspi/tools/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -sysroot ~/raspi/sysroot -opensource -confirm-license -nomake examples -no-compile-examples -skip qtwayland  -skip qtwebengine -make libs -prefix /usr/local/qt5pi -skip qtlocation -v -no-use-gold-linker
#check for python symlink in /bin folder
if add_python_symlink $1 ; then
    echo "building QT, running make...."
    #build
    make
    #setup
    echo "Installing QT into the raspi directory"
    make install
fi

#Setup qt5 on the pi
cd ~/raspi
rsync -avz qt5pi $1:/usr/local






