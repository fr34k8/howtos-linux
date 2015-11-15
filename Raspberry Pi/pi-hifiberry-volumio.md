# Volumio audiophile music player (mit Raspberry Pi)

Download Volumio for Raspberry Pi ([Version 1.55](https://volumio.org/get-started))

	dd bs=1M if=volumio155.img of=/dev/sdX

After boot of Pi:

	rpi-update
	reboot
	apt-get update
	apt-get upgrade

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

Enable IPv6 access volumio web ui:

	grep -B 1 -A 2 "80;" /etc/nginx/nginx.conf
	server {
	  	#listen       80;
		listen       [::]:80;

There is a problem to add web radios with this version. Login via ssh:

	cd /var/lib/mpd/music/WEBRADIO
	cat << EOF >radioStation.pls
	[playlist]
	numberofentries=1
	File1=http://stream.url
	Length1=-1
	EOF

On the Volmio UI click on Menu > Library and then click *update library*.
