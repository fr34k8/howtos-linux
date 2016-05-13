# Modifications for t410s

## Backup

	apt-get install deja-dup
	cat << EOF >/etc/cron.weekly/backup-collection-status
	#!/bin/bash
	duplicity collection-status file:///media/doris/BACKUP_XY/
EOF

	chmod 711 /etc/cron.weekly/backup-collection-status

## Sprachen DE

    apt-get install icedove-l10n-de libreoffice-l10n-de

## Keepass Password Store

      apt-get install keepass2

## send ip

	cat << EOF >/etc/cron.daily/ip
	#!/bin/bash
	/sbin/ip -6 addr show
EOF
	chmod 755 /etc/cron.daily/ip
