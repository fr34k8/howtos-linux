# Monitoring with pi camera

Resicende monitoring for about CHF 200.- with (pure opensource) Raspian and motion.

## Hardware

* Raspberry Pi [Model B+](https://www.pi-shop.ch/raspberry-pi-model-b)
* Raspberry Pi [HD-Cam](https://www.pi-shop.ch/hd-kamera-raspberry-pi)
* Raspberry Pi [Silver Case](https://www.adafruit.com/products/2346)
* [Realtek RTL5370](https://www.pi-shop.ch/miniature-wifi-802-11b-g-n-module-fuer-raspberry-pi) Wireless LAN 802.11n USB 2.0 Network Adapter

## Firmware update

After boot of Pi:

	rpi-update
	reboot
	apt-get update
	apt-get upgrade

## Network

	modprobe ipv6
	echo "ipv6" >>/etc/modules
	wpa_passphrase sid passasdf

Copy output of psk="" to wlan0 interface config:

	vi /etc/network/interfaces
	allow-hotplug eth0
	iface eth0 inet dhcp

	allow-hotplug wlan0
	iface wlan0 inet dhcp
		wpa-ssid sid
		wpa-psk <from wpa_passphrase calculated hash>

## Camera driver

Enable raspi camera module ([from here](http://raspberrypi.stackexchange.com/questions/10480/raspi-camera-board-and-motion)):

Load camera modul into kernel:

	modprobe bcm2835-v4l2

Load it after reboot's too:

	echo "bcm2835-v4l2" >>/etc/modules

A new device /dev/video0 should be there now:

	dmesg | grep video
	[   13.234495] Linux video capture interface: v2.00
	[   13.317264] bcm2835-v4l2: V4L2 device registered as video0 - stills mode > 1280x720
	[   13.352375] bcm2835-v4l2: Broadcom 2835 MMAL video capture ver 0.0.2 loaded.

	ls -1 /dev/video*
	/dev/video0

# Config

How to [automatically emailing] (http://sirlagz.net/2013/02/18/how-to-automatically-emailing-motion-snapshots) snapshots:

	apt-get install mailutils ssmtp mpack

	vi /etc/motion/motion.conf
	width 1024
	height 800
	# Note:
	# Threshold will change if you change width and height
	# Based on 1024x800 I've got good results with threshold of 70000.
	threshold 70000
	lightswitch 10
	output_normal best
	quality 100
	webcam_quality 100
	ffmpeg_video_codec mpeg4
	on_picture_save mpack -s 'moni webcam alert' %f user@domain.tld
	on_movie_end mpack -s 'moni webcam movie alert' %f user@domain.tld
	on_camera_lost echo "Cam connection lost" | mail -s "Cam connection lost" user@domain.tld
	text_changes on
	# For e-mail testing set snapshot_interval
	# snapshot_interval 10

	vi /etc/default/motion
	start_motion_daemon=yes

Disable red led on the pi camera module:

	echo "disable_camera_led=1" >>/boot/config.txt
	reboot

Found this [here](http://www.raspberrypi-spy.co.uk/2013/05/how-to-disable-the-red-led-on-the-pi-camera-module/)

# Cron

Start and pause motion detection via cron:

	crontab -e
	00  7 * * * curl http://localhost:8080/0/detection/start
	00  8 * * * curl http://localhost:8080/0/detection/pause

Enjoy!
