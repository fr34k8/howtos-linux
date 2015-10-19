# Extract hardware infos

Inspired by [this](http://www.binarytides.com/linux-commands-hardware-info).

	cat << EOF >/tmp/get-hw-info.sh
	#!/bin/bash
	set -x
	dmidecode
	cat /proc/partitions
	hdparm -i /dev/sda
	lsblk
	df -h
	fdisk -l
	grep MemTotal /proc/meminfo
	grep "model name" /proc/cpuinfo
	lscpu
	lsusb
	lspci
	EOF

	chmod +x /tmp/get-hw-info.sh
	/tmp/tmp/get-hw-info.sh
