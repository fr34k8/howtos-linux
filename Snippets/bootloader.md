# Creating a bootable USB drive from an ISO image

	apt-get install syslinux-utils
	isohybrid path/to/image.iso
	lsblk
	dd if=path/to/image.iso of=/dev/sdX

<https://www.turnkeylinux.org/blog/iso2usb>
