# Encrypted gpg backup of /etc and mysql database

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
	
	# backup piwik mysql database
	mysqldump --all-databases \
	        --events --single-transaction --routines >${TMPDIR}/${DBFILE} && \
	        chown ${USER}:${USER} ${TMPDIR}/${DBFILE} && \
	        su -c "cat ${TMPDIR}/${DBFILE} | gpg --encrypt \
	        -r ${GPG_KEY} - >${DSTDIR}/${DBFILE}.gpg" - ${USER} && \
	        rm ${TMPDIR}/$DBFILE || exit 3
	
	tar cfz ${TMPDIR}/${HOSTNAME}.tgz /etc /var/spool/cron &>/dev/null && \
	        chown ${USER}:${USER} ${TMPDIR}/${HOSTNAME}.tgz && \
	        su -c "cat ${TMPDIR}/${HOSTNAME}.tgz | gpg --encrypt \
	        -r ${GPG_KEY} - >${DSTDIR}/${HOSTNAME}.tgz.gpg" - ${USER} && \
	        rm ${TMPDIR}/${HOSTNAME}.tgz || exit 3
	
	exit 0
	EOF

	chmod 700 /etc/cron.daily/backup
