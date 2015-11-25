# Monitoring with pi camera

Resicende monitoring for about CHF 200.- with (pure opensource) Raspian and motion.

## Hardware

* Raspberry Pi [Model B+](https://www.pi-shop.ch/raspberry-pi-model-b)
* Raspberry Pi [HD-Cam](https://www.pi-shop.ch/hd-kamera-raspberry-pi)
* Raspberry Pi [Silver Case](https://www.adafruit.com/products/2346)
* [Realtek RTL5370](https://www.pi-shop.ch/miniature-wifi-802-11b-g-n-module-fuer-raspberry-pi) Wireless LAN 802.11n USB 2.0 Network Adapter

# Install Raspian
Download Raspian from [here](https://www.raspberrypi.org/downloads/raspbian/) and install it
according their instructions.

## Update firmware

After installation boot your pi and update firmware and packages:

	rpi-update
	reboot
	apt-get update
	apt-get upgrade

## Network

We'd like to use ipv6.

	modprobe ipv6

Be sure, that ipv6 is loaded until pi's next reboot:

	echo "ipv6" >>/etc/modules

Add FQDN to hosts file:

	vi /etc/hosts
	127.0.1.1       moni.domain.tld moni

### Configure WLAN

	wpa_passphrase sid passasdf

Copy psk="" part of wpa_passphrase's out:

	vi /etc/network/interfaces
	allow-hotplug eth0
	iface eth0 inet dhcp

	allow-hotplug wlan0
	iface wlan0 inet dhcp
		wpa-ssid sid
		wpa-psk <Copy content of psk="" here>

## Time and logging

Set time:

	dpkg-reconfigure tzdata
	apt-get install ntpdate

Enable syslog:

	apt-get install rsyslog
	update-rc.d rsyslog enable

## Camera driver

Enable pi's camera module ([found here](http://raspberrypi.stackexchange.com/questions/10480/raspi-camera-board-and-motion)):

Load camera modul into kernel:

	modprobe bcm2835-v4l2

Be sure it is loaded after pi's reboot:

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

	apt-get install mailutils ssmtp mpack motion

General settings:

	vi /etc/motion/motion.conf
	# Camera resolution optimized for recognition and performance.
	width 704
	height 576
	output_normal best
	rotate 90
	quality 75
	webcam_quality 100
	webcam_maxrate 4
	# Filename formats
	snapshot_filename %Y-%m-%dT%H%M_%v-%q-%D-snapshot
	jpeg_filename %Y-%m-%dT%H%M_%v-%q-%D
	movie_filename %Y-%m-%dT%H%M_%v-%q-%D
	timelapse_filename %Y-%m-%d_timelapse
	ffmpeg_video_codec mpeg4
	control_html_output off
	# Image detail
	text_changes on
	locate on
	text_left MONI
	text_double on
	# Event config
	# Use mpack to send out e-mail with images and videos
	on_picture_save mpack -s "MONI-Alert | %v-%v | Image | Noise: %N | Changed pixels: %D" %f user@domain.tld
	on_movie_end mpack -s "MONI-Alert | %v-%v | Movie | Noise: %N | Changed pixels: %D" %f user@domain.tld
	on_camera_lost echo "Oops!" | mail -s "MONI-Cam: Connection lost" user@domain.tld
	# Timelapse config
	ffmpeg_cap_new on
	ffmpeg_timelapse 120
	ffmpeg_timelapse_mode daily
	pre_capture 4
	post_capture 2

Relevant *Raspberry Pi HD-CAM* settings:
	vi /etc/motion/motion.conf
	threshold_tune off
	threshold 250
	noise_tune on
	noise_level 16
	lightswitch 50

	vi /etc/default/motion
	start_motion_daemon=yes

Disable red led on the pi camera module:

	echo "disable_camera_led=1" >>/boot/config.txt
	reboot

Found this [here](http://www.raspberrypi-spy.co.uk/2013/05/how-to-disable-the-red-led-on-the-pi-camera-module/)

# Delete files in /tmp

Older than 7 days:

	vi /etc/default/rcS
	TMPTIME=7

# Cron

Disable motion at raspi's start up:

	update-rc.d motion disable

Raspi is usually under power. If not cron.{daily,weekly,monthly} should run anyway. This is done with:

	apt-get install anacron

# Status via raspi's leds

This script will change red and green leds. If motion is on, red led is
turned on. If motion is not running, the green led is on.

	cd /usr/local/bin
	wget https://github.com/micressor/howtos-linux/raw/master/Raspberry-Pi/checkMotion.sh
	chmod 755 /usr/local/bin/checkMotion.sh

Start and pause motion detection via cron:

	crontab -e
	PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"
	15  7-16 * * 1-5 pidof motion >/dev/null || /usr/sbin/service motion start
	15    17 * * 1-5 service motion stop
	16     * * * *   checkMotion.sh
	16    17 * * *   mpack -s 'Moni-Daily_timelapse' /tmp/motion/$(date "+\%Y-\%m-\%d")_timelapse.mpg user@domain.tld

Enjoy!

# Links

* [Surveillance with Raspberry Pi NoIR Camera HowTo](http://www.home-automation-community.com/surveillance-with-raspberry-pi-noir-camera-howto)
