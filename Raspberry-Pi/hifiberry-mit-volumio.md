# Volumio audiophile music player (mit Raspberry Pi)

## Hardware

## Install

Download Volumio for Raspberry Pi ([Version 1.55](https://volumio.org/get-started))

	dd bs=1M if=volumio155.img of=/dev/sdX

## Configure raspian

According to [this](https://github.com/micressor/blob/master/Raspberry-Pi/raspian.md).

## Network

Configure WLAN USB stick:

	cat << EOF >/etc/apt/sources.list.d/non-free.list
	deb http://ftp.ch.debian.org/debian/ jessie non-free
	EOF

	apt-get update
	apt-get install firmware-realtek

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
