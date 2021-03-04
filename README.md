# qtpi
Some bash-scripts for embedded development under Linux. Using QT and crosscompiling it for the raspberry on a Ubuntu 20.04 virtual machine.

# on_host.sh
This is the main file. It will setup ubuntu 20.04 for cross-compilation of qt5 for the raspberry-pi.

# on_rpi.sh
This is a file that will be copied over to the raspberry-pi to setup all required dependencies to run the cross-compiled qt5.

# how-to
- Prepare a virtual machine that will run Ubuntu 20.04 Desktop x64 version.
- Clone the repo to your home directory
- Move or copy the two files *on_host.sh* and *on_rpi.sh* to your home directory

```console
cd ~
git clone https://github.com/4w50m3d3v516n3r/embedded.git
cd embedded
cp on_host.sh on_rpi.sh ~
chmod +x on_host.sh on_rpi.sh
```
Then execute on_host.sh:
```console
.\on_host.sh <RASPBERRY_IP> <QTVERSION_TO_CHECKOUT>

SAMPLE:
on_host.sh pi@192.168.177.33 5.12
```
Currently you have to give parameter two *<QTVERSION_TO_CHECKOUT>* even if you don't use QT Git-Source.

# Side notes and tipps
- The virtual machine should at least have 8GB of RAM and 50GB of harddisk space and at least 4 cores
- Not every version of QT5 will compile, some versions will not even build the samples after a successfull make and make install (could not figure out why until now)
- Reserve a good amount of time for cross-compiliation. About 2-3 hours. Sometimes even more.
- General security rule: always check everything that you download from Git or other repositories! It could harm your privacy or worse! Check and understand what you download.
- If you cannot start QT Creator after installing it on Ubuntu, setup *libxcb-xinerama0*




