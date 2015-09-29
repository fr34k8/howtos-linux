# Pre install

	cd /root
	tar cfz etc-$HOSTNAME.tgz /etc
	dpkg -l >dpkg-$HOSTNAME.lst
	tar cfz home-$HOSTNAME.tgz /home

# Installing Debian OS

Aktuell ist Debian 8.0 (Jessie).

## From USB Live Image

* [Offizielle Releases](https://www.debian.org/releases/)

* [Statistik](https://wiki.debian.org/DebianReleases#Release_statistics)

* [Download LIVE ISO Images.](https://www.debian.org/CD/live)

cp [debian-live-8.0.0-amd64-gnome-desktop.iso](http://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid) /dev/sd{usb}

oder

cp [debian-live-8.1.0-amd64-gnome-desktop+nonfree.iso](http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/amd64/iso-hybrid) /dev/sd{usb}

oder die **fehlende Firmware** für Wireless von
[hier](https://www.debian.org/releases/stable/amd64/ch06s04.html.de) herunterladen und auf einem separaten
USB Stick bereitstellen.

	mount /dev/sd{usb} /mnt
	mkdir -p /mnt/firmware
	wget http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/jessie/current/firmware.tar.gz -O /mnt/firmware/firmware.tar.gz

Statt in das **Live**-System zu starten die Option **Install** auswählen.

## Partitionierung

    Die folgenden Partitionen werden formatiert:
      LVM VG, LV home als btrfs
      LVM VG, LV root als ext4
      LVM VG, LV swap_1 als Swap

## Zeitzone

	dpkg-reconfigure tzdata

	  Current default time zone: 'Europe/Zurich'
	  Local time is now: Thu Apr 10 10:42:19 CEST 2014.
	  Universal Time is now: Thu Apr 10 08:42:19 UTC 2014.

## vim

	apt-get purge nano
	apt-get install vim

The [EDITOR](http://unix.stackexchange.com/questions/4859/visual-vs-editor-whats-the-difference) editor should be able to work without use of "advanced" terminal functionality (like old ed or ex mode of vi). It was used on teletype terminals.

A VISUAL editor could be a full screen editor as vi or emacs.

	update-alternatives --config editor

	cat << EOF >/etc/vim/vimrc.local
	syntax on
	set ignorecase
	set ruler
	set showcmd
	set history=50
	set incsearch
	if &t_Co > 1
	  syntax enable
	endif
EOF

## ssh

	vi /etc/ssh/sshd_config

	PasswordAuthentication no
	PermitRootLogin without-password

## ntp

	apt-get install ntp ntpdate
	ntpq -p

### manuell

	service ntp stop
	ntpdate 0.debian.pool.ntp.org
	service ntp start

## Profile

Set default locales to de_CH.UTF-8.

	dpkg-reconfigure locales

	vi /etc/profile

	#umask 022 # Server
	#umask 027 # WS

## sudo

Weshalb [sudo](https://wiki.debian.org/sudo)?

Beispiele von [ubuntuusers.de](https://wiki.ubuntuusers.de/sudo/Konfiguration)

	adduser user1 sudo
	visudo
	  %sudo  ALL = NOPASSWD: ALL

## apt

	vi /etc/apt/sources.list
	# Debian 8.0 (Jessie)
	deb     http://ftp.ch.debian.org/debian/ jessie main contrib non-free
	deb     http://ftp.ch.debian.org/debian/ jessie-updates main contrib non-free
	deb-src http://ftp.ch.debian.org/debian/ jessie main contrib non-free
	deb http://security.debian.org jessie/updates main

### mixed mode with testing (optional)

	vi /etc/apt/apt.conf.d/80defaultrelease
	APT::Default-Release "jessie";

[Priority](https://wiki.debian.org/AptPreferences) für testing [anpassen](http://www.argon.org/~roderick/apt-pinning.html):

	vi /etc/apt/preferences.d/pinning
	Package: *
	Pin: release o=Debian,a=jessie
	Pin-Priority:  900
	Package: *
	Pin: release o=Debian,a=testing
	Pin-Priority: -500

	vi /etc/apt/sources.list
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free

	apt-cache policy| grep testing
	500 http://ftp.ch.debian.org/debian/ testing/main Translation-en
	-500 http://ftp.ch.debian.org/debian/ testing/main amd64 Packages

## Useful base software

	apt-get update
	apt-get upgrade
	apt-get install \
	uptimed logwatch sysstat popularity-contest deborphan mtr \
	strace

## Useful tools

	apt-get install \
	openssh-server \
	iceweasel-l10n-de \
	opensc pcscd autoconf automake \
	autotools-dev bc build-essential flac gettext gimp \
	git-core qtgstreamer-plugins \
	gstreamer0.10-plugins-ugly \
	gstreamer0.10-plugins-good \
	iptraf libdvdread4 lltag mc rsync sshfs \
	smartmontools sox ttf-mscorefonts-installer uptimed \
	vorbis-tools vlc whois \
	pbuilder debhelper zip lame lintian mtr \
	git-buildpackage ruby devscripts

## Useful for office

	apt-get install \
	audacity flashplugin-nonfree libreoffice-l10n-de default-jre \
	icedtea-plugin jmeter freemind android-tools-adb virt-manager \
	myspell-de-ch

## remove rpcbind

Wir nutzen keinen nfs stuff.

      apt-get purge rpcbind

## Related depends on lenovo's

      apt-get install firmware-iwlwifi tp-smapi-dkms hdapsd

## Unattended-upgrades

Aktualisiere Stabile und Sicherheits-Updates.

	apt-get install unattended-upgrades

	vi /etc/apt/apt.conf.d/50unattended-upgrades
	Unattended-Upgrade::Origins-Pattern {
        "o=Debian,a=stable";
        "o=Debian,a=stable-updates";
        "origin=Debian,codename=${distro_codename},label=Debian-Security";
	};
	Unattended-Upgrade::Mail "root";

	dpkg-reconfigure -plow unattended-upgrades
	unattended-upgrade -d –dry-run

Inspired by <https://wiki.debian.org/UnattendedUpgrades>

## Power Management

	apt-get install acpitool
	apt-get install tp-smapi-dkms hdapsd
	apt-get install laptop-mode-tools
	echo "tp_smapi" >> /etc/modules
	echo "hdaps" >> /etc/modules
	update-initramfs -u

Wenn laptop-mode-tools installiert, schläft die USB Maus/Tastatur ständig ein. Lösung [gefunden:](https://debianforum.de/forum/viewtopic.php?f=13&t=152520)

	vi /etc/laptop-mode/conf.d/runtime-pm.conf
	AUTOSUSPEND_RUNTIME_DEVTYPE_BLACKLIST="usbhid usb-storage"

	reboot
oder

	modprobe tp_smapi
	cat /sys/devices/platform/smapi/BAT0/cycle_count

* [Infos auf thinkwiki.org](http://www.thinkwiki.org/wiki/Tp_smapi)

## mail / SMTP (SSMTP)

**Manpage:** ssmtp is a send-only sendmail emulator for machines which
normally pick their mail up from a centralized mailhub (via pop, imap,
nfs mounts or other means). It provides the functionality required for
humans and programs to send mail via the standard or /usr/bin/mail user
agents. Konfiguration gemäss:

	apt-get install ssmtp

	vi /etc/ssmtp/ssmtp.conf
	# The person who gets all mail for userids < 1000
	root=myname

	# Where will the mail seem to come from?
	rewriteDomain=domain.tld

	# The full hostname of your workstation
	  hostname=ws.domain.tld

	# The place where the mail goes. The actual machine name is required no
	# MX records are consulted. Commonly mailhosts are named mail.domain.com
	mailhub=mailserver.domain.tld:587


	UseSTARTTLS=YES
	AutHUser=myname@domain.tld
	AuthPass=pass
	#Debug=YES

	vi /etc/ssmtp/revaliases
	# Example: root:your_login@your.domain:mailhub.your.domain[:port]
	# where [:port] is an optional port number that defaults to 25.
	root:myname@domain.tld

## Anacron

Anacron wird bei systemd Nutzung nur am Netz ausgeführt. Damit die /etc/cron.\* ausgeführt werden ist folgende Änderung notwendig. Siehe auch /usr/share/doc/anacron/README.Debian.

	apt-get install anacron

	cd /etc/systemd/system && \
	mkdir anacron.service.d && \
	cd anacron.service.d && \
	cat << EOF >on-ac.conf
	[Unit]
	ConditionACPower=
EOF

	systemctl daemon-reload

Um zu sehen ob die cron e-mail sauber kommt, anacron ausführen

	anacron -fn

## Clamav

	apt-get install clamav

	cat << EOF >/etc/cron.weekly/clamscan
	#!/bin/bash
	nice -n 20 clamscan -o -i --stdout \
	--follow-file-symlinks=2 \
	--follow-dir-symlinks=2 \
	--exclude-dir=backup \
	--exclude-dir=/sys \
	--exclude-dir=/run \
	--exclude-dir=/dev \
	--exclude-dir=/proc -r /
EOF

	chmod +x /etc/cron.daily/clamscan
	wget http://www.eicar.org/download/eicar.com.txt

Viren werden mit dieser Konfiguration nur aufgezeigt! Um zu löschen ist
zusätzlich die Option.

      --remove=yes

notwendig. **Vorsicht!** 

### On access scan

Wäre ideal aber läuft in 0.98.7 nicht wirklich.

	apt-get install clamav-daemon
	dpkg-reconfigure clamav-daemon
	vi /etc/clamav/clamd.conf
	ScanOnAccess yes
	# Wenn ganzes Filesystem muss clamav als root laufen.
	User root
	OnAccessIncludePath /
	OnAccessExcludePath /tmp
	OnAccessExcludePath /proc
	OnAccessExcludePath /sys

	service clamav-daemon restart

	tail -f /var/log/clamav/clamav.log

## logwatch

Wöchentlich eine logwatch e-mail der letzten 7 Tage:

	dpkg-divert --local --rename --divert /etc/cron.weekly/00logwatch --add /etc/cron.daily/00logwatch
	vi /etc/cron.weekly/00logwatch
	  /usr/sbin/logwatch --range 'between -7 days ago and yesterday' --output


