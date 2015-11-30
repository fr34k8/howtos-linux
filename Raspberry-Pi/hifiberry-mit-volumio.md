# Volumio audiophile music player (mit Raspberry Pi)

Download Volumio for Raspberry Pi ([Version 1.55](https://volumio.org/get-started))

	dd bs=1M if=volumio155.img of=/dev/sdX

After boot of Pi:

	rpi-update
	reboot
	apt-get update
	apt-get upgrade

	vi /etc/default/rcS
	# automatically repair filesystems with inconsistencies during boot
	FSCKFIX=yes

## Network

Configure WLAN USB stick:

	cat << EOF >/etc/apt/sources.list.d/non-free.list
	deb http://ftp.ch.debian.org/debian/ jessie non-free
	EOF

	apt-get update
	apt-get install firmware-realtek

[Central Regulatory Domain Agent](https://packages.debian.org/jessie/crda) für kabellose Geräte:

	apt-get install crda

Configure network:

	wpa_passphrase sid passasdf

Copy output of psk="" to wlan0 interface config:

	vi /etc/network/interfaces
	allow-hotplug eth0
	iface eth0 inet dhcp

	allow-hotplug wlan0
	iface wlan0 inet dhcp
		wpa-ssid sid
		wpa-psk <from wpa_passphrase calculated hash>

## SSH

Permit only ssh key login:

	grep PasswordAuthentication /etc/ssh/sshd_config
	PasswordAuthentication no

## Base

Set time:

	dpkg-reconfigure tzdata
	apt-get install ntpdate

Enable syslog:

	apt-get install rsyslog
	update-rc.d rsyslog enable

Enable system e-mails:

	apt-get install ssmtp

Enable anacron jobs:

	apt-get install anacron

Configuration according to [ssmtp.conf](https://github.com/micressor/howtos-linux/blob/master/Debian/Desktop/install-os.md#mail--smtp-ssmtp).

Enable IPv6 access volumio web ui:

	grep -B 1 -A 2 "80;" /etc/nginx/nginx.conf
	server {
	  	#listen       80;
		listen       [::]:80;

Setting up volumio to get [great audio](https://www.hifiberry.com/guides/setting-up-volumio-to-get-great-audio/):

* Go to Menu > System. I2S driver: Hifiberry+
* Go to Menu > Playback > General music daemon options > Auto update: yes

There is a problem to add web radios with this version. Login via ssh:

	cd /var/lib/mpd/music/WEBRADIO
	cat << EOF >radioStation.pls
	[playlist]
	numberofentries=1
	File1=http://stream.url
	Length1=-1
	EOF

Enjoy!
