# How to rescue a system

## Workplace

	fsck /dev/vda2
	mkdir -p /mnt/rescue
	mount /dev/vda2 /mnt/rescue
	mount -B /dev /mnt/rescue/dev
	mount -B /sys /mnt/rescue/sys
	mount -B /proc /mnt/rescue/proc
	chroot /mnt/rescue

## Grub

	install-grub --recheck /dev/vda
	grup-update
