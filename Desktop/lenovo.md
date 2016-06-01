## Power Management

	apt-get install tp-smapi-dkms hdapsd
	echo "tp_smapi" >> /etc/modules
	echo "hdaps" >> /etc/modules
	update-initramfs -u

Ohne reboot:

	modprobe tp_smapi
	cat /sys/devices/platform/smapi/BAT0/cycle_count

* [Infos auf thinkwiki.org](http://www.thinkwiki.org/wiki/Tp_smapi)
