# Backup für Desktop Linux mit Sync (Unison) und Snapshots (BTRFS) howto

## Konzept

* 2 Workstations (WS) mit Sync statt 1 WS plus USB Harddisk

	+ Hardware Redundanz

	+ Beide Geräte lassen sich nutzen

* Die Technologien für **Sync** ([Unison](http://www.cis.upenn.edu/~bcpierce/unison/docs.html)) und **Snapshot** (BTRFS) sind austauschbar.

* Nur **ausgewählte** Verzeichnisse innerhalb von /home/user/ werden mit **Unison** in Sync gehalten.

* Jede WS implementiert unabhängig **Revisionssicherheit** mit Snapshots (hier mit BTRFS).

* Zeit **unabhängige Snapshots:** Es kann sein, dass ein Snapshots auf WS1 **nicht** die selben Daten enthält, wie ein Snapshot auf WS2.

* [Using Unison to Synchronize More Than Two Machines](http://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html#usingmultiple)
	* Unison is **designed for synchronizing pairs of replicas.** However, it is possible to use it to keep larger groups of machines in sync by performing multiple pairwise synchronizations.

	* If you need to do this, the most reliable way to set things up is to organize the machines into a **star topology,** with one machine designated as the “hub” and the rest as “spokes,” and with each spoke machine synchronizing only with the hub. The big advantage of the star topology is that it eliminates the possibility of confusing “spurious conflicts” arising from the fact that a separate archive is maintained by Unison for every pair of hosts that it synchronizes.

### Requirements

* BTRFS filesystem auf /home
* Unison
* btrbk
* 2 oder mehr WS

## Unison Sync

### Install

	apt-get install unison

* Both server should use the same Version of unison
* Both server should use a timeserver
* Setup ssh key's without-password.


### Configure

Auf der WS, die den **Stern** in der Topologie darstellt, werden alle Configs abgelegt. Pro entfernten Server eine \*.prf Datei.

	cd ~/.unison
	cat << EOF > common.prf
	group = false
	prefer = newer
	ignore = Name .*~
	ignore = Name *~
	ignore = Name desktop.ini
	ignore = Name .gnupg/random_seed
	ignore = Name *.o
	ignore = Name temp.*
	ignore = Name thumbs.db
	ignore = Name *.tmp
	ignore = Path .cache
	ignore = Path .kvm-images
	ignore = Path .work
	maxbackups = 0
	mountpoint = .unison-enabled
	owner = false
	path = .unison/common.prf
	perms = -1
	sortbysize = true
	sshargs = -C
	times = true
	EOF

Diese Pfade werden mit der zweiten Workstation in Sync gehalten:

	cat << EOF > home-dir.prf
	path = .bashrc
	path = Bilder
	path = Dokumente
	path = .local/share/gnome-shell/extensions/
	path = .mozilla
	path = Musik
	path = .profile
	path = Videos
	path = Vorlagen
	EOF

Diese Pfade werden zusätzlich in Sync gehalten:

	cat << EOF > local-dir.prf
	path = backup
	path = bin
	path = localMaildir
	path =.mutt/colors.rc
	path =.mutt/gpg.rc
	path = .muttrc
	path = src
	path = .ssh
	EOF

Diese Pfade werden mit dem Server in Sync gehalten:

	cat << EOF > server-dir.prf
	path = bin
	path = .dput.cf
	path = git
	path = .gitconfig
	path = .gnupg
	path = localMaildir
	path = .mcabber
	path =.mutt/colors.rc
	path =.mutt/gpg.rc
	path = .muttrc
	path = offlineIMAP
	path = .offlineimaprc
	path = .openvpn
	path = .vim
	path = .vimrc
	path = www
	EOF

Vorsicht bei cross syncing. Auf **Stern** anordnung achten.

	cat << EOF >{$HOSTNAME}-sync.prf
	include common

	root = /home/user
	root = ssh://user@host.domain.tld//home/user

	include local-dir
	include home-dir
	#include server-dir
	EOF

* -path Paths to synchronize 
* -mountpoint abort if this path does not exist
* -dontchmod when set, never use the chmod system call
* -perms part of the permissions which is synchronized
* -group synchronize group attributes
* -maxbackups number of backed up versions of a file
* -owner synchronize owner
* -sortbysize list changed files by size, not name
* sshargs = -C Enables ssh's compression feature.

### Test

	unison -testServer /home/user1 ssh://user@server2://home/user1

### Usage

Auf beiden root sync's muss das *.unison-mounted* file existieren.

Während dem initalen Sync sehr genau aufpassen, was er wohin syncen will:

	unison sync-for-$HOSTNAME.prf -ui text

#### Batch mode and silent

Erst wenn alles sauber sync, den batch job ausprobieren:

	unison sync-for-$HOSTNAME.prf -ui text -batch -auto -silent -terse

#### Cron

Zum starten und überwachen der sync jobs nutze ich diesen Script:

<https://github.com/micressor/howtos-linux/blob/master/scripts/unison-cron>

	crontab -l
	*/5 * * * * unison-cron my-sync-host my-unison-config.prf my@email.tld

Der ping stuff habe ich auf [stackoverflow](http://stackoverflow.com/questions/28130330/bash-script-to-ping-a-ip-and-if-the-ms-is-over-100-print-a-echo-msg) gefunden.

## BTRFS Snapshots

### Install

#### from source

Download btrbk from [here.](http://www.digint.ch/btrbk/download.html)

	apt-get install libdate-calc-perl
	cd /tmp
	wget http://www.digint.ch/download/btrbk/releases/btrbk-0.21.0.tar.xz
	unxz btrbk-0.21.0.tar.xz
	tar xf btrbk-0.21.0.tar
	cd btrbk-*
	make install

#### via apt-get

Check status of [btrbk in debian.](https://tracker.debian.org/pkg/btrbk)

	apt-get -t testing install btrbk
	less /etc/btrbk/btrbk.conf.example

/home muss mit btrfs formatiert sein.

	mkdir /home/user1/_SNAPSHOTS

### Configure

Create a btrfs subvolume for a new user:

	btrfs subvolume create /home/user1
	useradd -m user1

* Das Subvolume **muss vor dem useradd generiert werden.**
* Hier sind mehr Infos zum [BTRFS Backup Konzept](https://btrfs.wiki.kernel.org/index.php/Incremental_Backup).

Setup snapshot's for user1:

	cat << EOF >/etc/btrbk/btrbk.conf
	# Preserve matrix for source snapshots:
	snapshot_preserve_daily    7
	snapshot_preserve_weekly   4
	snapshot_preserve_monthly  6

	# Preserve matrix for backup targets:
	#target_preserve_daily      7
	#target_preserve_weekly     4
	#target_preserve_monthly    6

	timestamp_format long

	volume /home
	  subvolume user1
	    snapshot_dir user1/_SNAPSHOTS
	  subvolume user2
	    snapshot_dir user2/_SNAPSHOTS
	EOF

### Test

	btrbk run

### Usage

#### Cron

Täglicher Snapshot:

	cat << EOF >/etc/cron.daily/btrbk 
	#!/bin/bash

	# Vars
	DISK_CRYPT=disk_crypt
	MOUNT_CRYPT=/srv/btr_backup
	MOUNT_HOME=/home
	BALANCE_DUSAGE=55

	# Main
	set -x
	if sudo cryptdisks_start $DISK_CRYPT;
	then
	  mount $MOUNT_CRYPT
	fi
	btrfs filesystem show
	btrfs filesystem df $MOUNT_HOME
	btrfs filesystem df $MOUNT_CRYPT
	time btrfs balance start -dusage=$BALANCE_DUSAGE $MOUNT_HOME
	time btrfs balance start -dusage=$BALANCE_DUSAGE $MOUNT_CRYPT
	time btrbk run
	time sync
	btrbk stats
	EOF

	chmod 755 /etc/cron.daily/btrbk

#### Report about exclusive used data

	btrfs quota enable /home
	btrfs qgroup show -f /home
	wget https://raw.githubusercontent.com/agronick/btrfs-size/master/btrfs-size.sh -O /usr/local/bin/btrfs-size.sh
	chmod 755 /usr/local/bin/btrfs-size.sh
	btrfs-size.sh /home
	cat << EOF >/etc/cron.weekly/btrfs-size
	#!/bin/bash
	/usr/local/bin/btrfs-size.sh /home
	EOF
	chmod +x /usr/local/bin/btrfs-size.sh

### Appendix

#### Fixing Btrfs Filesystem Full Problems

Gefunden bei [merlins.org](http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html) und bei [btrfs.wiki.kernel.org](https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space).

## usb disk mit cryptsetup (luks)

Wenn nebst dem Unison Sync zwischen den WS ausserdem ein Backup auf eine verschlüsselte USB Disk folgen soll.

### Install

Keyfile erstellen ([Quelle](http://www.finnie.org/2009/07/26/keyfile-based-luks-encryption-in-debian/)):

	dd if=/dev/random of=/etc/luksbackup.key bs=1 count=2560

(/dev/random vs [/dev/urandom](https://de.wikipedia.org/wiki//dev/random#.2Fdev.2Furandom))

### Configure

Verschlüsselung einrichten:

	cryptsetup luksFormat -c aes-xts-plain64 -s 256 /dev/sdc1 /etc/luksbackup.key
	cryptsetup luksOpen /dev/sdc1 disk_crypt --key-file /etc/luksbackup.key
	  cryptsetup status yellowdisk_crypt
	  /dev/mapper/yellowdisk_crypt is active.
	    type:    LUKS1
	    cipher:  aes-xts-plain64
	    keysize: 256 bits
	    device:  /dev/sdc1
	    offset:  4096 sectors
	    size:    976769009 sectors
	    mode:    read/write

Disk formatieren:

	mkfs.btrfs -m single -L yellowdisk_crypt /dev/mapper/yellowdisk_crypt
	cryptsetup luksClose yellowdisk_crypt

Disk in /etc/{crypttab,fstab} eintragen:

	ls -l /dev/disk/by-uuid/ | grep sdc
	vim /etc/crypttab
	  yellowdisk_crypt UUID=ccbe7fdf-fd5e-481b-825f-5be0596bd6f1 /etc/luksbackup.key luks,noauto

	mkdir /srv/backup
	vim /etc/fstab
	  /dev/mapper/yellowdisk_crypt /srv/backup      btrfs    defaults,noauto 0 0

### Test

	cryptdisks_start yellowdisk_crypt
	cryptsetup status yellowdisk_crypt
	mount /srv/backup
	btrfs subvolume create /srv/backup/user1
	umount /srv/backup
	cryptdisks_stop yellowdisk_crypt

### Usage

vi /etc/btrbk/btrbk.conf

	#add here:
	snapshot_create  ondemand

	volume /home
	  subvolume user1
	    #add here:
	    target send-receive  /srv/backup/user1

	sudo btrbk run

#### Restore

Restore a single file:

	cp -p /home/user1/_SNAPSHOSTS/user1.20150804/important.txt /home/user1/important.txt

Restore a whole snapshot ([Quelle](http://www.digint.ch/btrbk/doc/readme.html)):

	mv /home/user1 /home/user1.BROKEN
	btrfs subvolume snapshot /home/user1/_SNAPSHOTS/user1.20150805 /home/user1

That's it; your data subvolume is restored. If everything went fine, it's time to nuke the broken subvolume:

	btrfs subvolume delete /home/user1.BROKEN

Alternatively, if you're restoring data on a remote host, do something like this:

	btrfs send /srv/backup/subvol.20150101 | ssh root@my-remote-host.com btrfs receive /mnt/btr_pool/subvol
