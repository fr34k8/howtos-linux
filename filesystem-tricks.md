# Filesystem tricks

## tar backup via ssh

	tar cfzv - --exclude=x --exclude=y /home/alice | ssh bob@hostname cat ' - > backup.tgz'

## Filesystem kopieren ohne Verlust von Zeitstempel

	tar cf - /mnt  | (cd /tmp/ && tar vxf -)

## Geometrie einer disk kopieren

	sfdisk -d /dev/sda | sfdisk --force /deb/sdb
