#!/bin/bash

#variables
PYLINK="/bin/python"
IDFILE1=~/.ssh/id_rsa.pub
IDFILE2=~/.ssh/id_dsa.pub
PUBLIC_KEY1=~/.ssh/id_rsa.pub
PUBLIC_KEY2=~/.ssh/id_dsa.pub

wait_key_press() {

    read -n 1 -s -r -p "Press any key to continue"
}

add_python_symlink() {
    echo "checking for python symlink in /bin"

    if [ -L ${PYLINK} ]; then
        if [ -e ${PYLINK} ]; then
            echo "Python is already correctly linked."
            return 0
        else
            echo "Link to python is broken."
        fi
    elif [ -e ${PYLINK} ]; then
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
    echo "on_host.sh <RASPBERRY_IP> <QTVERSION_TO_CHECKOUT>"
    echo "Example:"
    echo "on_host.sh pi@raspberrypi 5.12"
    echo "or:"
    echo "on_host.sh pi@192.168.177.33 5.12"
    exit 1
fi

#setup host packages
echo "Setting up required packages (local packages)"
sudo apt update
sudo apt-get -y install build-essential cmake unzip gfortran g++ gperf flex texinfo
sudo apt-get -y install gawk bison libncurses-dev autoconf automake tar
sudo apt-get -y install gcc git bison python gperf pkg-config gdb-multiarch wget

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

#Create sysroot for cross-compilation
cd ~/raspi
mkdir sysroot sysroot/usr sysroot/opt

#authenticate on py without keys
echo "Trying to establish SSH key-based authentication for your Raspberry Pi"
echo "Checking first, if you created already an ssh rsa or dsa id...."

if [ -f "$IDFILE1" ]; then
    echo "You have an RSA key."
    echo "Trying to setup your public RSA key on your Raspberry"
    ssh-copy-id -i $PUBLIC_KEY1 $1
elif [ -f "$IDFILE2" ]; then
    echo "You have an DSA key."
    echo "Trying to setup your public DSA key on your Raspberry"
    ssh-copy-id -i $PUBLIC_KEY2 $1
else
    echo "You have no DSA or RSA key, let's generate one."
    echo "Please choose the default location and file-name..."
    echo "Please choose to encrypt the private SSH key and choose a passphrase."
    echo "It is more secure."
    echo "Calling ssh-keygen..."
    #check, what kind of key needs to be created
    PS3='Please choose the type of key to generate:'
    options=("1 RSA" "2 DSA")
    select opt in "${options[@]}"; do
        case $opt in
        "1 RSA")
            echo "Ok. Let's create an RSA key."
            ssh-keygen -t rsa -b 4096
            break
            ;;
        "2 DSA")
            echo "Ok. Let's create an DSA key"
            ssh-keygen -t dsa
            break
            ;;
        *) echo "invalid option $REPLY" ;;
        esac
    done

    echo "Checking for your newly generated public key...."

    if [ -f "$PUBLIC_KEY1" ]; then
        echo "Trying to setup your public RSA key on your Raspberry"
        ssh-copy-id -i $PUBLIC_KEY1 $1
    elif [ -f "$PUBLIC_KEY2" ]; then
        echo "Trying to setup your public DSA key on your Raspberry"
        ssh-copy-id -i $PUBLIC_KEY2 $1
    else
        echo "Could not find either an default RSA or default DSA key. You have to authenticate yourself against rsync."
    fi

fi

#copy on_rpi.sh script to the pi
cd ~
echo "copying on_pi.sh to the Raspberry"
scp ./on_rpi.sh $1:/home/pi

#set execution flag on the script and run it
echo "running script to prepare the pi, on the pi. This may take a while...."
ssh $1 'source /home/pi/.bashrc && chmod +x /home/pi/on_rpi.sh && /home/pi/on_rpi.sh'

cd ~/raspi
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
echo "Configuring QT"
./configure -release -opengl es2 -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=~/raspi/tools/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -sysroot ~/raspi/sysroot -opensource -confirm-license -nomake examples -no-compile-examples -skip qtwayland -skip qtwebengine -make libs -prefix /usr/local/qt5pi -skip qtlocation -v -no-use-gold-linker

echo "building QT, running make. Grab yourself a coffee and enjoy the show."
#build
make
#setup
echo "Installing Cross-Compiled qt on the raspi directory"
make install

#Setup qt5 on the pi
cd ~/raspi/sysroot/usr/local
rsync -avz qt5pi $1:/usr/local
ssh $1 sudo ldconfig

#now try to compile a sample, deploy and run it on the pi
cd ~/qt5/qtbase/examples/opengl/qopenglwidget
#run qmake
~/raspi/sysroot/usr/local/qt5pi/bin/qmake
#run make
make
#copy sample to the raspberry
scp qopenglwidget $1:/home/pi
#run the sample

ssh $1 /home/pi/qopenglwidget

echo "Done. Enjoy!"

wait_key_press
