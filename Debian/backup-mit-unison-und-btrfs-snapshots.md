# Backup mit Sync (Unison) und Snapshots (BTRFS)

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

* BTRFS fs auf /home
* Unison
* btrbk
* 2 oder mehr WS

## Unison Sync

### Install

	apt-get install unison

* Both server should use the same Version of unison
* Both server should use a timeserver
* Setup ssh key's without-password.

### Test

	unison -testServer /home/user1 ssh://user@server2://home/user1

### Config

Auf der WS, die den **Stern** in der Topologie darstellt, werden alle Configs abgelegt. Pro entfernten Server eine \*.prf Datei.

	cd ~/.unison
	cat << EOF > common.prf
	group = true
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
	path = .unison/home-dir.prf
	path = .unison/local-dir.prf
	path = .unison/mbalmer2-dir.prf
	path = .unison/mutt-dir.prf
	perms = -1
	sortbysize = true
	sshargs = -C
	times = true
EOF

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

	cat << EOF > mutt-dir.prf
	path = localMaildir
	path =.mutt/colors.rc
	path =.mutt/gpg.rc
	path = .muttrc
EOF

	cat << EOF > local-dir.prf
	include mutt-dir
	path = backup
	path = bin
	path = .gitconfig
	path = .gnupg
	path = src
	path = .ssh
	path = .vim
	path = .vimrc
	path = .openvpn
EOF

	cat << EOF >{$HOSTNAME}-sync.prf
	include common

	root = /home/user
	root = ssh://user@host.domain.tld//home/user

	include local-dir
	include home-dir
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

### Initial sync

Während dem initalen Sync sehr genau aufpassen, was er wohin syncen will:

	unison sync-for-$HOSTNAME.prf -ui text

### Batch mode and silent

Erst wenn alles sauber sync, den batch job ausprobieren:

	unison sync-for-$HOSTNAME.prf -ui text -batch -auto -silent -terse

### Cron

Ping stuff in this script is from [stackoverflow](http://stackoverflow.com/questions/28130330/bash-script-to-ping-a-ip-and-if-the-ms-is-over-100-print-a-echo-msg).

	cat << EOF >/usr/local/bin/unison-cron
	#!/bin/bash
	# Usage: ./unison-cron server sync-to-server.prf

	#exec 1>/dev/null;
	#set -xv

	host=$1
	config=$2

	# Start unison sync only, if we have a low ping time. In this case, we assume
	# that the server is in the same local network.
	t="$(ping6 -c 1 $host | sed -ne '/.*time=/{;s///;s/\..*//;p;}')"

	if [ "$t" -lt "15" ];
	then
	  ps -ef | grep $LOGNAME | grep "unison $2" | \
	    grep -vE "grep|ssh|bash" || (unison -testServer $config 2>&1 >/dev/null && \
	    unison $config -batch -auto -repeat 300)
	else
	  # ping to high
	  #echo "ping is $t"
	  exit 1
	fi
EOF

	chmod +x /usr/local/bin/unison-cron

	su - user1
	crontab -e
	PATH="/usr/bin:/bin:/home/user/bin:/usr/local/bin"
	*/5  * * * * /usr/local/bin/unison-cron servername sync-for-xy.prf

## BTRFS Snapshots

### Install

Download btrbk from [here.](http://www.digint.ch/btrbk/download.html) Check status of [btrbk in debian.](https://tracker.debian.org/pkg/btrbk)

	apt-get -t testing install btrbk
	less /etc/btrbk/btrbk.conf.example

/home muss mit btrfs formatiert sein.

	mkdir /home/btrbk_snapshots

### Config

Create a btrfs subvolume for a new user:

	btrfs subvolume create /home/user1
	useradd -m user1

* Das Subvolume **muss vor dem useradd generiert werden.**
* Hier sind mehr Infos zum [BTRFS Backup Konzept](https://btrfs.wiki.kernel.org/index.php/Incremental_Backup).

Setup snapshot's for user1:

	cat << EOF >/etc/btrbk/btrbk.conf
	# Preserve matrix for source snapshots:
	snapshot_preserve_daily    14
	snapshot_preserve_weekly   4
	snapshot_preserve_monthly  12

	# Preserve matrix for backup targets:
	#target_preserve_daily      14
	#target_preserve_weekly     14
	#target_preserve_monthly    12

	volume /home
	  snapshot_dir btrbk_snapshots
	  subvolume user1
	  subvolume user1
	  # Pro User wird der snapshot separat konfiguriert.
	  #subvolume user2
	  #subvolume user3
EOF

### Cron

Stündliche Snapshots:

	cat << EOF >/etc/cron.daily/btrbk 
	#!/bin/bash
	btrbk run
EOF

	chmod 755 /etc/cron.daily/btrbk

## usb disk mit cryptsetup (luks)

Wenn nebst dem Unison Sync zwischen den WS ausserdem ein Backup auf eine verschlüsselte USB Disk folgen soll.

### Initial

Keyfile erstellen ([Quelle](http://www.finnie.org/2009/07/26/keyfile-based-luks-encryption-in-debian/)):

	dd if=/dev/random of=/etc/luksbackup.key bs=1 count=2560

(/dev/random vs [/dev/urandom](https://de.wikipedia.org/wiki//dev/random#.2Fdev.2Furandom))

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
	cryptdisks_stop yellowdisk_crypt
	cryptsetup status yellowdisk_crypt

### Enable

vi /etc/btrbk/btrbk.conf

	#add here:
	snapshot_create  ondemand

	volume /home
	  subvolume user1
	    #add here:
	    target send-receive  /srv/backup/user1

	sudo btrbk run

## Restore

Restore a single file:

	cp -p /home/btrbk_snapshots/user1.20150804/important.txt /home/user1/important.txt

Restore a whole snapshot ([Quelle](http://www.digint.ch/btrbk/doc/readme.html)):

	mv /home/user1 /home/user1.BROKEN
	btrfs subvolume snapshot /home/btrbk_snapshots/user1.20150805 /home/user1

That's it; your data subvolume is restored. If everything went fine, it's time to nuke the broken subvolume:

	btrfs subvolume delete /home/user1.BROKEN

Alternatively, if you're restoring data on a remote host, do something like this:

	btrfs send /srv/backup/subvol.20150101 | ssh root@my-remote-host.com btrfs receive /mnt/btr_pool/subvol

## Monitoring

Zu Überwachung, ob alle Sync's regelmässig laufen, sonst E-Mail senden.

	vi /etc/cron.daily/unison-moni
	#!/bin/bash
	su -c "/usr/local/bin/backup-cycle-checker.sh" - user1
	su -c "/usr/local/bin/backup-cycle-checker.sh" - user2
	  

	cat << backupEOF >/usr/local/bin/backup-cycle-checker.sh
	TMPDIR=/tmp
	FILE=backup-cycle-checker-$LOGNAME
	FLAG=$TMPDIR/$FILE

	# check, ob FLAG älter als 12h
	if [ -f $FLAG ]
	then
        	find $TMPDIR -name $FILE -mmin +720 -exec rm -f {} \;
	fi

	if [ ! -f $FLAG ]
	then
        	ps -ef | grep $LOGNAME | grep unison | \
	          grep -vE "grep|ssh|bash" &>/dev/null
	else
        	ps -ef | grep $LOGNAME | grep unison | \
	          grep -vE "grep|ssh|bash" &>/dev/null
	        if [ "$?" = "0" ]
	        then
	        cat << EOF | mailx -s "YEAH! $HOSTNAME:~$LOGNAME is SYNC again!!" $1
	`date`
	EOF

        	cd /tmp
	        rm $FLAG
	        fi

	fi

	# verschicke Mail, wenn wenn Unison Job nicht läuft
	if [ "$?" != "0" ]
	then
        	cat << EOF | mailx -s "OOPS! $HOSTNAME:~$LOGNAME backup is late!!" $1
	`date`
	EOF

	cd /tmp
	touch $FLAG
	fi
backupEOF