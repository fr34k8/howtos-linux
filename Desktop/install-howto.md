# Pre install

	cd /root
	tar cfz etc-$HOSTNAME.tgz /etc
	dpkg -l >dpkg-$HOSTNAME.lst
	tar cfz home-$HOSTNAME.tgz /home

# Installing Debian OS

Aktuell ist Debian 8.0 (Jessie).

## From USB Live Image

Einen USB-Stick [vorbereiten](https://www.debian.org/releases/jessie/amd64/ch04s03.html.de#usb-copy-isohybrid) mit einem Hybrid-CD- oder -DVD-Image.

	cp debian.iso /dev/sdX
	sync

* Das Image muss auf das vollständige Gerät geschrieben werden, nicht auf eine einzelne Partition, also z.B. auf /dev/sdb, nicht auf /dev/sdb1. Nutzen Sie keine Werkzeuge wie unetbootin, da diese das Image verändern.

* Einfach das CD- oder DVD-Image wie hier gezeigt auf USB zu schreiben sollte für die meisten Benutzer funktionieren. Die anderen unten erwähnten Optionen sind komplexer und hauptsächlich für Leute mit speziellen Bedürfnissen gedacht.

* [Offizielle Releases](https://www.debian.org/releases/)

* [Statistik](https://wiki.debian.org/DebianReleases#Release_statistics)

* [Download LIVE ISO Images.](https://www.debian.org/CD/live)

Oder die [fehlende Firmware nachladen](https://www.debian.org/releases/jessie/amd64/ch06s04.html.de) für Wireless.

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

## Console font size

Sichtbar in der Console (alt+ctrl+f1):

	vi /etc/default/console-setup
	  FONTFACE="Terminus"
	  FONTSIZE="16x32"

	/etc/init.d/console-setup restart

Sichtbar im Grub Menu:

	vi /etc/default/grub
	  GRUB_GFXMODE=800x600
	update-grub
	reboot

## ssh

	apt-get install openssh-server rsync sshfs
	vi /etc/ssh/sshd_config
	# default but to be sure
	PasswordAuthentication no
	PermitRootLogin without-password

	vi /etc/ssh/ssh_config
	VisualHostKey yes

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

	usermod -a -G sudo user1
	visudo
	  %sudo  ALL = NOPASSWD: ALL

## apt

	apt-get install apt-file

	vi /etc/apt/sources.list
	# Debian 8.0 (Jessie)
	# jessie
	deb http://ftp.ch.debian.org/debian/ jessie main contrib non-free
	deb-src http://ftp.ch.debian.org/debian/ jessie main contrib non-free
	# jessie security updates
	deb http://security.debian.org/ jessie/updates main contrib non-free
	deb-src http://security.debian.org/ jessie/updates main contrib non-free
	# jessie updates
	deb http://ftp.ch.debian.org/debian/ jessie-updates main contrib
	deb-src http://ftp.ch.debian.org/debian/ jessie-updates main contrib
	# jessie-backports
	deb http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	deb-src http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	# testing
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free

### mixed mode with testing (optional)

[Priority](https://wiki.debian.org/AptPreferences) for testing [anpassen](http://www.argon.org/~roderick/apt-pinning.html) (order is important).

	cat << EOF > /etc/apt/preferences.d/pinning
	Package: *
	Pin: release o=Debian,a=testing
	Pin-Priority: -500
	EOF

	cat << EOF > /etc/apt/sources.list.d/testing.list
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free
	EOF

	apt-cache policy| grep testing
	500 http://ftp.ch.debian.org/debian/ testing/main Translation-en
	-500 http://ftp.ch.debian.org/debian/ testing/main amd64 Packages

## DNS Firewall (Response Policy Zone = RPZ)

	cd ~/src
	git clone https://github.com/StevenBlack/hosts
	cd hosts

Copy relevant local /etc/hosts entries into ./myhosts File.

	./makeHosts
	sudo cp ./hosts /etc/hosts
	sudo service network-manager restart
	sudo service networking restart

## Useful base software

	apt-get update
	apt-get upgrade
	apt-get install \
	uptimed sysstat popularity-contest deborphan mtr strace rfkill

## Useful monitoring software

	apt-get install mcelog logwatch

### logwatch

Moved [here](https://github.com/micressor/howtos-linux/blob/master/Server/logwatch.md)

## Useful tools

	apt-get install \
	bc flac gettext gimp \
	git qtgstreamer-plugins gstreamer0.10-plugins-ugly \
	gstreamer0.10-plugins-good \
	iptraf libdvdread4 lltag mc  \
	sox ttf-mscorefonts-installer uptimed \
	vorbis-tools vlc whois zip lame mtr

### build tools

	apt-get install \
	pbuilder debhelper git-buildpackage ruby devscripts lintian \
	autotools-dev autoconf automake build-essential \
	virt-manager jmeter

## Backup

[HOWTO: Install unison synchronisation together with btrfs snapshots.](https://github.com/micressor/howtos-linux/blob/master/Debian/backup-mit-unison-und-btrfs-snapshots.md)

## Useful for office

	apt-get install \
	audacity libreoffice-l10n-de default-jre \
	icedtea-plugin android-tools-adb \
	myspell-de-ch

## Remove rpcbind

Wir nutzen keinen nfs stuff.

      apt-get purge rpcbind

## Remove flashplugin-nonfree

I plan to no longer use flash websites:

	apt-get autoremove --purge flashplugin-nonfree

## Unattended-upgrades

Move to [unattended-upgrades](https://github.com/micressor/howtos-linux/blob/master/Server/unattended-upgrades.md)

## Power Management

	apt-get install acpitool laptop-mode-tools smartmontools

Wenn laptop-mode-tools installiert, schläft die USB Maus/Tastatur ständig ein. Lösung [gefunden:](https://debianforum.de/forum/viewtopic.php?f=13&t=152520)

	vi /etc/laptop-mode/conf.d/runtime-pm.conf
	AUTOSUSPEND_RUNTIME_DEVTYPE_BLACKLIST="usbhid usb-storage"

	reboot

## mail / SMTP (SSMTP)

Stepps according to [here](https://github.com/micressor/howtos-linux/blob/master/Server/ssmtp.md).

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

Official [ClamAV FAQ](https://github.com/vrtadmin/clamav-faq).

	apt-get install clamav-daemon clamav-freshclam

	cat << EOF >/etc/cron.weekly/clamscan
	#!/bin/bash
	nice -n 20 clamscan -o --stdout --quiet \
	--follow-file-symlinks=2 \
	--follow-dir-symlinks=0 \
	--exclude=.gpg \
	--exclude-dir=/home \
	--exclude-dir=_SNAPSHOTS \
	--exclude-dir=btr_backup \
	--exclude-dir=cache \
	--exclude-dir=/sys \
	--exclude-dir=/run \
	--exclude-dir=/dev \
	--exclude-dir=/proc -r /
	EOF

	chmod +x /etc/cron.weekly/clamscan
	wget http://www.eicar.org/download/eicar.com.txt

Viren werden mit dieser Konfiguration nur aufgezeigt! Um zu löschen ist
zusätzlich die Option.

      --remove=yes

notwendig. **Vorsicht!** 

### On-access Scan Settings

0.99 has a revamped on-access scanning engine.

	apt-get install clamav-daemon
	dpkg-reconfigure clamav-daemon

	cat << EOF >/usr/local/bin/clamav_alert.sh
	#!/bin/bash
	Subject="ClamAV VIRUS ALERT ${HOSTNAME}: $1"
	Msg=`mktemp`
	tail -n80 /var/log/clamav/clamav.log >$Msg
	cat $Msg | mail root -s "$Subject"
	rm $Msg
	EOF
	chmod +x /usr/local/bin/clamav_alert.sh

	vi /etc/clamav/clamd.conf
	User root
	ScanOnAccess yes
	OnAccessMountPath /home
	OnAccessIncludePath /home
	OnAccessExcludePath /home/*/_SNAPSHOTS
	VirusEvent /usr/local/bin/clamav_alert.sh "%v"

	service clamav-daemon restart

	tail -f /var/log/clamav/clamav.log

## Fail2ban

	apt-get install fail2ban
	fail2ban-client ping
	fail2ban-client status

### config

	cat << EOF >>/etc/fail2ban/jail.local
	[DEFAULT]
	action = %(action_mwl)s
	ignoreip = 127.0.0.1/8 # more ip's
	findtime = 600
	maxretry = 3
	bantime  = 86400  ; 1 day

	# destemail is necessary because of ssmtp config.
	destemail = my@email.tld

	[ssh]
	enabled  = true
	[ssh-ddos]
	enabled  = true
	[pam-generic]
	enabled = true
	EOF

	service fail2ban restart
