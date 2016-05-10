# How to debug the linux kernel

## Kernel problems!?

	dmesg -l err

## kernel debug systemd

	vi /etc/default/grub
	GRUB_CMDLINE_LINUX="systemd.log_target=kmsg systemd.log_level=debug" <--- Add here (by uncommenting you can easily switch to debug)
