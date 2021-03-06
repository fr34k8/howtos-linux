# Encrypted gpg backup of /etc and mysql database

Import your backup gpg key into root's gnupg keystore.

	mkdir -p /var/backup

	cat << EOF >>/etc/cron.daily/backup
	#!/bin/bash
	
	#set -x
	umask 077
	
	GPG_KEY=<gpg key>
	TMPDIR=/tmp
	USER=root
	DSTDIR=/var/backup/$HOSTNAME
	DBFILE=`hostname`.sql
	BACKUP_DIRS='/etc /var/spool/cron'
	
	# backup piwik mysql database
	mysqldump --all-databases \
	        --events --single-transaction --routines >${TMPDIR}/${DBFILE} && \
	        chown ${USER}:${USER} ${TMPDIR}/${DBFILE} && \
	        cat ${TMPDIR}/${DBFILE} | gpg --no-tty --encrypt \
	        -r ${GPG_KEY} - >${DSTDIR}/${DBFILE}.gpg" && \
	        rm ${TMPDIR}/$DBFILE || exit 3
	
	tar cfz ${TMPDIR}/${HOSTNAME}.tgz $BACKUP_DIRS &>/dev/null && \
	        chown ${USER}:${USER} ${TMPDIR}/${HOSTNAME}.tgz && \
	        cat ${TMPDIR}/${HOSTNAME}.tgz | gpg --no-tty --encrypt \
	        -r ${GPG_KEY} - >${DSTDIR}/${HOSTNAME}.tgz.gpg && \
	        rm ${TMPDIR}/${HOSTNAME}.tgz || exit 3
	
	exit 0
	EOF

	chmod 700 /etc/cron.daily/backup

# Links

* [GnuPG: stdin: is not a tty](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
