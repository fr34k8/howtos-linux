# iDevices ab Debian Jessie anbinden

Gefunden auf dem [Debian Wiki](https://wiki.debian.org/iPhone):

	apt-get install ideviceinstaller libimobiledevice-utils

	cat << EOF >>/etc/fuse
	user_allow_other
	EOF

Logoff and login in GNOME. Danach sollte das iPhone seine Filesysteme beim
Verbinden mit USB anzeigen.

## Backup

	idevicebackup2 backup ~/iphone4-test-backup

(idevicebackup hat nicht funktioniert.)

## Restore

Achtung: Find My iPhone must be disabled before restoring:

	idevicebackup2 restore ~/iphone4-test-backup

# Links

<http://blog.xenodesystems.com/2014/03/how-to-managesync-your-ios-7-device.html>

<https://wiki.ubuntuusers.de/Archiv/iPod/iPhone_und_iPod_touch>

* [Linux life: Syncing iPhone with iTunes on a virtual machine](https://jpamills.wordpress.com/2013/04/08/linux-life-syncing-iphone-with-itunes-on-a-virtual-machine/)

* <http://www.libimobiledevice.org>
