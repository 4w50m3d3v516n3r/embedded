# embedded
Some bash-scripts for embedded development under Linux.

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
.\on_host.sh
```
That's it. Good luck!




