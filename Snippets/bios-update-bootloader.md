# BIOS Update (Linux)

Download \*.iso image:

      sudo apt-get install grub-imageboot
      sudo mkdir -p /boot/images
      sudo cp /home/youruser/Downloads/6uuj12uc.iso /boot/images
      sudo update-grub

Wenn das Update fehlschlägt, von einem externen USB-Stick updaten:

      geteltorito -o bios.img g2uj18us.iso
      dd if=bios.img of=/dev/sdX bs=1M

Boot from USB Stick.

* [Updading the bios on lenovo laptops from linux](https://workaround.org/article/updating-the-bios-on-lenovo-laptops-from-linux-using-a-usb-flash-stick)

# Creating a bootable USB drive from an ISO image

	apt-get install syslinux-utils
	isohybrid path/to/image.iso
	lsblk
	dd if=path/to/image.iso of=/dev/sdX

<https://www.turnkeylinux.org/blog/iso2usb>
