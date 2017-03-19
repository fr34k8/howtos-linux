# Hifiberry with openELEC (Kodi)

	cd /tmp

Download the Raspberry Pi [Build](http://openelec.tv/get-openelec). Double
check, what Pi version (1/2) you have.

	apt-get install pv

Insert a sd card and be sure, that all partitions are unmounted:

	gzip -dc OpenELEC-RPi2.arm-6.0.0.img.gz | pv | sudo dd of=/dev/mmcblk0 bs=4M
	sync

## Enable hifiberry's DAC+

Login into openelec via ssh:

	mount -o remount,rw /flash
	vi /flash/config.txt
	dtoverlay=hifiberry-dacplus
	dtdebug=1
	sync
	mount -o remount,ro /flash
	shutdown -r now

Once rebooted, change System Settings > Audio output to **ALSA: Default
(snd_rpi_hifiberry_dac)**.

OpenElec seems to set the mixer to 100% by default. Try out what's the best
setting for your environment:

	amixer -c 0 set Digital 80%

## Enable IPv6

If you have native IPv6 at home. Login via ssh to the openELEC box:

	connmanctl
	connmanctl> config wifi_xyz ipv6 auto
	connmanctl> quit
	sync
	shutdown -r now

Now your openELECi's ssh should be reachable over the via IPv6 address.

	ip -6 addr show wlan0
	inet6 xyz:xyz:xyz:xyz:xyz:xyz:xyz:xyz/64 scope global dynamic 

Enjoy!

## How to disable open ports

* Open TCP Port 36666 and 36667: disable airplay in Kodi/XBMC's settings

* Open TCP Port 445: disable samba server in Kodi/XBMC's settings

* Open TCP Port 80: disable http server in Kodi/XBMC's settings

# Links

* [Disable Ports on OpenElec](http://openelec.tv/forum/69-network/75724-disable-ports-on-openelec)

* [HifiBerry: Configuring the sound card in OpenElec using device-tree-overlays](https://www.hifiberry.com/guides/configuring-the-sound-card-in-openelec-with-device-tree-overlays/)

* [Configuring wiht a pi 1](https://www.hifiberry.com/guides/openelec-configuration/)
