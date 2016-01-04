# How to rescue a system

Boot into a grml.org rescue system.

## Rescue workplace

How to setup my workplace, if the disk which needs rescue is /dev/vda2:

	fsck /dev/vda2
	mkdir -p /mnt/rescue
	mount /dev/vda2 /mnt/rescue
	for i in /dev /dev/pts /sys /proc; do mount -B $i /mnt/rescue$i; done
	chroot /mnt/rescue /bin/bash
	export LC_ALL=C

## Rescue an encrypted disk

	cryptsetup luksOpen /dev/sda3 sda3_crypt
	vgchange -a y
	mount /dev/xy-vg/root-lv /mnt/target

## Rescue a UEFI based system

Inspired by [this page.](https://wiki.debian.org/GrubEFIReinstall)

Boot into a grml.org rescue system and check that the computer is booted in EFI mode:

	[ -d /sys/firmware/efi ] && echo "EFI boot on HDD" || echo "Legacy boot on HDD"
	should return "EFI boot on HDD".

	chroot /mnt/rescue /bin/bash
	export LC_ALL=C
	apt-get install --reinstall grub-efi
	install-grub --recheck /dev/sda
	update-grub

	efibootmgr --verbose | grep debian
	file /boot/efi/EFI/debian/grubx64.efi
	/boot/efi/EFI/debian/grubx64.efi: PE32+ executable (EFI application) x86-64 (stripped to external PDB), for MS Windows

## Rescue a broken initrd image

Boot into a grml.org rescue system, according to above.

	apt-get install --reinstall linux-image-3.16.0-4-amd64
	update-grub

If it is a UEFI system, check the bootloader:

	efibootmgr --verbose | grep debian
	file /boot/efi/EFI/debian/grubx64.efi
	/boot/efi/EFI/debian/grubx64.efi: PE32+ executable (EFI application) x86-64 (stripped to external PDB), for MS Windows
	export LC_ALL=C
