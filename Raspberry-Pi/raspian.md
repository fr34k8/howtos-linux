# Install Raspian

Download Raspian from [here](https://www.raspberrypi.org/downloads/raspbian/)
and install it according their instructions.

## Update firmware

After installation boot your pi and update firmware and packages:

	rpi-update
	reboot
	apt-get update
	apt-get upgrade

	vi /etc/default/rcS
	# automatically repair filesystems with inconsistencies during boot
	FSCKFIX=yes

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

[Central Regulatory Domain Agent](https://packages.debian.org/jessie/crda) für kabellose Geräte:

	apt-get install crda

## SSH

Permit only ssh key login:

	grep PasswordAuthentication /etc/ssh/sshd_config
	PasswordAuthentication no

## Time and logging

Set time:

	dpkg-reconfigure tzdata
	apt-get install ntpdate

Enable syslog:

	apt-get install rsyslog
	update-rc.d rsyslog enable

Enable system e-mails:

	apt-get install ssmtp

Configuration according to [ssmtp.conf](https://github.com/micressor/howtos-linux/blob/master/Tools/ssmtp.md).

Enable anacron jobs:

	apt-get install anacron

Enjoy!
