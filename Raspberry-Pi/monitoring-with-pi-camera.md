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

Set time:

	dpkg-reconfigure tzdata
	apt-get install ntpdate

Enable syslog:

	apt-get install rsyslog
	update-rc.d rsyslog enable

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
	# Camera resolution optimized for recognition and performance.
	width 704
	height 576
	# Combination of threshold and lightswitch are the most important
	# parameters.
	threshold 300
	lightswitch 98
	output_normal best
	quality 100
	webcam_quality 100
	webcam_maxrate 4
	ffmpeg_video_codec mpeg4
	rotate 90
	# Use mpack to send out e-mail with images and videos
	on_picture_save mpack -s 'moni webcam alert' %f user@domain.tld
	on_movie_end mpack -s 'moni webcam movie alert' %f user@domain.tld
	on_camera_lost echo "Cam connection lost" | mail -s "Cam connection lost" user@domain.tld
	text_changes on
	text_left MONI
	text_double on
	snapshot_interval 10800 # 3 hours

	vi /etc/default/motion
	start_motion_daemon=yes

Disable red led on the pi camera module:

	echo "disable_camera_led=1" >>/boot/config.txt
	reboot

Found this [here](http://www.raspberrypi-spy.co.uk/2013/05/how-to-disable-the-red-led-on-the-pi-camera-module/)

# Cron

Raspi is usually under power from 06:00 until 23:59. When I leave my residence
and start up raspi, anacron will shutup motion within an hour.

	apt-get install anacron

Let anacron check daily run's every hour:

	vi /etc/cron.d/anacron
	8 * * * * root test -x /etc/init.d/anacron && /usr/sbin/invoke-rc.d anacron start >/dev/null

This script will change red and green leds. If motion is on, red led is
turned on. If motion is not running, the green led is on.

	cd /usr/local/bin
	wget https://github.com/micressor/howtos-linux/raw/master/Raspberry-Pi/checkMotion.sh
	chmod 755 /usr/local/bin/checkMotion.sh

This check starts via cron:

	cat << EOF >/etc/cron.d/checkMotion
	*/5 * * * * root /usr/local/bin/checkMotion.sh
	EOF

Start and pause motion detection via cron:

	crontab -e
	PATH="/usr/bin:/bin:/usr/sbin:/sbin"
	# Shutdown motion detection after 17:15.
	15 17 * * 1-5  service motion stop
	# Shutdown raspi at 23:15 for this day.
	15 23 * * *    shutdown -h now
	# Optional configurations:
	#00 07 * * 1-5 service motion start
	#00  7 * * 1-5 curl http://localhost:8080/0/detection/start
	#15 17 * * 1-5 curl http://localhost:8080/0/detection/pause

Enjoy!
