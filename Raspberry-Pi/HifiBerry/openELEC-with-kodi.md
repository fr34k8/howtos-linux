# Hifiberry with openELEC (Kodi)

	cd /tmp

Download the Raspberry Pi [Build](http://openelec.tv/get-openelec). Double
check, what Pi version (1/2) you have.

Insert a sd card and be sure, that all partitions are unmounted:

	gzip -d OpenELEC-RPi2.arm-6.0.0.img.gz
	sudo dd if=./OpenELEC-RPi2.arm-6.0.0.img of=/dev/mmcblk0 bs=4M
	sync

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
