# pcengines apu2
## Serial port configuration

According to [user manual](http://pcengines.ch/pdf/apu2.pdf) set terminal
emulator to 115200 8N1

	apt-get install screen
	screen -T xterm-256color /dev/ttyUSB0 115200

Enter bios configuration with F10 key.

## Install debian on pcengines apu board

Follow this [instructions](https://github.com/ssinyagin/pcengines-apu-debian-cd)
to install debian on your apu. Recommended by pcengines list of
[disk images](http://pcengines.ch/howto.htm#images).

	cd /tmp
	wget https://github.com/ssinyagin/pcengines-apu-debian-cd/releases/download/8.3-20160401/debian-8.3-amd64-CD-1.iso
	dd if=images/debian-8.3-amd64-CD-1.iso of=/dev/sdX bs=16M


**WARNING:** this is a fully automated installation. Once you boot from the
USB stick, it will only give you 5 seconds in the initial menu, then in
a couple of minutes it will ask for the hostname, and the rest will be
done automatically, and a new Debian system will be installed on mSATA
SSD drive.

**!!! ALL EXISTING DATA ON THE DRIVE WILL BE LOST !!!**
