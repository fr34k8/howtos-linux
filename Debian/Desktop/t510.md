# Modifications for t510

[thinkwiki.de/T510](http://thinkwiki.de/T510)

## Cron

	crontab -e
	*/15 * * * * exec 1>/dev/null ; ping6 -c 1 yoga || autosync-all

## Cryptsetup

Falls die LUKS verschlüsselte USB Disk nicht angeschlossen ist, durch
die Option **noauto** den Boot nicht verzögern:

	vi /etc/crypttab
	bluedisk_crypt UUID=00000000-0000-0000-0000-000000000000 /etc/luksbackup.key luks,noauto
	yellowdisk_crypt UUID=00000000-0000-0000-0000-000000000000 /etc/luksbackup.key luks,noauto

	vi /etc/fstab
	/dev/mapper/bluedisk_crypt /media/backup ext4 user,noauto 0 0
	/dev/mapper/yellowdisk_crypt /media/backup ext4 user,noauto 0 0

## GSM Modem - GOBI

See install instructions here:

<https://github.com/micressor/firmware/tree/master/Qualcomm%20Gobi%202000>
