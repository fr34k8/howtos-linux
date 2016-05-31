# Modifications for yoga 3 pro

* [Yoga 3 pro](http://shop.lenovo.com/ch/de/laptops/lenovo/yoga/yoga-3-pro) auf lenovo.com

* [PDF's](https://github.com/micressor/docs-mirror/tree/master/lenovo/yoga)

* Inspired by [longsleep's yoga3pro-linux](https://github.com/longsleep/yoga3pro-linux) howto

## Test

Mit dem **non-free** live image lief Wifi einwandfrei.

Der debian-installer aus dem standard install image findet aber den Treiber trotz usb stick mit firmware nicht.

## Install

Die Installation (mit UEFI Support) erfolgt über Debian's [Standard Install Images](https://wiki.debian.org/UEFI#UEFI_support_in_live_images).

In den Live Images **noch kein** UEFI Support.

Weitere Infos zu  UEFI [Secure Boot](https://wiki.ubuntu.com/SecurityTeam/SecureBoot).

* In das UEFI Setup Utility (früher BIOS) booten und settings checken:

	* Secure Boot [Enabled]

	* Boot Mode [UEFI]

	* Fast Boot [Enabled]

	* USB Boot [Enabled]

* Unter Boot das *EFI USB Device (General USB Flash Disk)* an die erste stelle verschieben.

* Reset UEFI PKI to **Setup Mode**

* Yoga auschalten und mit *NOVO* Taste booten. Boot Option USB auswählen.

	* Installation **nur starten,** wenn das anders aussehende **Debian UEFI Installer Splash Logo** erscheint.


## Wifi

Das hinzufügen der Firmware über einen USB Stick während der Installation (mit *debian-installer*) hat nicht funktioniert.

Der Chip ist ein BCM4352 von [Broadcom](http://www.broadcom.com/support/802.11/linux_sta.php). Weitere Infos sind im [Debian Wiki (wl driver)](https://wiki.debian.org/wl).

Musste über einen anderen Weg in das Internet verbinden (Huawei USB Mobile Modem).

	apt-get install broadcom-sta-dkms firmware-brcm80211

## Intel Grafik

Sehr langsam mit dem Treiber aus Debian 8.0 (Jessie) unbrauchbar.

Ich nehme den Treiber aus Debian Testing ([Quelle](https://www.aeyoun.com/how-to/debian-newer-intel-graphics.html)).

	glxinfo | grep "OpenGL vendor"
	  OpenGL vendor string: VMWare, Inc.

	vi /etc/apt/apt.conf.d/80defaultrelease
	  APT::Default-Release "jessie";

[Priority](https://wiki.debian.org/AptPreferences) für testing [anpassen](http://www.argon.org/~roderick/apt-pinning.html):

	vi /etc/apt/preferences.d/pinning
	  Package: *
	  Pin: release o=Debian,a=testing
	  Pin-Priority: -500

	vi /etc/apt/sources.list
	deb http://ftp.ch.debian.org/debian/ jessie main contrib non-free
	deb-src http://ftp.ch.debian.org/debian/ jessie main contrib non-free
	# jessie-updates, previously known as 'volatile'
	deb http://ftp.ch.debian.org/debian/ jessie-updates main contrib
	deb-src http://ftp.ch.debian.org/debian/ jessie-updates main contrib
	# jessie-backports
	deb http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	deb-src http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	# testing
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free

	apt-get update

**Update 29.05.2016:** Der aktuelle **stable-updates** Paket
linux-image-3.16.0-4-amd64 mit Kernel 3.16.7-ckt25-1 hat ein Problem. Das
Display schaltet direkt vor der Passphrase Eingabe zum entschlüsseln der
Disk auf black. Den [Hinweis](https://wiki.debianforum.de/KMS) zum ausschalten
via Kernel Paramenter `i915.modeset=0` führt dazu, dass zwar die Passphrase
eingegeben werden kann und das System bootet. Jedoch der Intel Grafiktreiber
[xserver-xorg-video-intel](https://tracker.debian.org/pkg/xserver-xorg-video-intel) die Zusammenarbeit (siehe auch
[#817784](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=817784)) mit dem
Kernelmodul i915 verweigert.

Weitere gefundene Hinweise:

* [i915 Black Screen on Boot Issue](http://florian-berger.de/en/articles/i915-black-screen-on-boot-issue/)
* [archlinux - intel graphics](https://wiki.archlinux.org/index.php/intel_graphics)
* [wiki debian - KernelModesetting](https://wiki.debian.org/KernelModesetting#Intel_GfxCards)
* [archlinux - Intel](https://wiki.archlinux.org/index.php/Intel)
* [solved - KMS / Intel turns display off](https://bbs.archlinux.org/viewtopic.php?pid=1504326#p1504326)
* [snd-hda-intel: Cannot turn on display power on i915](https://forums.opensuse.org/showthread.php/508563-snd-hda-intel-Cannot-turn-on-display-power-on-i915)
* [Intel® Graphics for Linux - Black screen debian](https://01.org/linuxgraphics/forum/graphics-installer-discussions/nuc5i3ryh-black-screen-debian)

**Workaround** für das black screen issue ist ein aktueller 4.5er Kernel aus
dem **jessie-backports** repo.

Das System (manuell) via Grub mit dem Kernel parameter `i915.modeset=0` starten:

	apt-get -t jessie-backports install linux-image-4.5.0-0.bpo.2-amd64
	apt-get -t jessie-backports install xserver-xorg-video-intel

Das Modul `i915` in die initramfs aufzunehmen, führt dazu, dass KMS
(Kernelbased Mode-Setting) früher aktiv wird:

	vi /etc/initramfs-tools/modules
	i915
	update-initramfs -v -u

Entfernt wurden: xserver-org-video-modesetting xserver-xorg-video-siliconmotion

	reboot
	glxinfo | grep "OpenGL vendor"
	  OpenGL vendor string: Intel Open Source Technology Center



## Sehr hohe Auflösung

Zu kleine Schrift ([Quelle](https://www.aeyoun.com/posts/lenovo-yoga3-pro-linux.html)).

Sichtbar im Grub Menu:

	vi /etc/default/grub
	  GRUB_GFXMODE=800x600
	update-grub

Sichtbar in der Console (alt+ctrl+f1):

	vi /etc/default/console-setup
	  FONTFACE="Terminus"
	  FONTSIZE="16x32"

Für GNOME 3 ([Quelle](http://www.pcworld.com/article/2911509/how-to-make-linuxs-desktop-look-good-on-high-resolution-displays.html)):

	apt-get install gnome-tweak-tool

* Zum Windws Tab
* Unter HiDPI Skallierung auf 2 oder mehr anpassen

## Screen rotation script

[Quelle:](https://www.aeyoun.com/projects/snippets/hardware/screen-rotation-cycler.sh.html) Cycles screen rotations clockwise in 90 degree increments.

	vi /usr/local/bin/screen-rotation-cycler.sh

	  RANDR=/usr/bin/xrandr
	  ORIENTATION=$($RANDR -q --verbose | grep eDP1 | awk '{print $6}')

	  echo $ORIENTATION

	  if [ ! -z "$ORIENTATION" ]; then
		  case "$ORIENTATION" in
			  "normal")
				  $RANDR -o right;;
			  "right")
				  $RANDR -o inverted;;
			  "inverted")
				  $RANDR -o left;;
			  "left")
				  $RANDR -o normal;;
		  esac
	  fi

	chmod 755 /usr/local/bin/screen-rotation-cycler.sh

* Via GNOME Tastenkürzel: hier ein Beispiel:

	/usr/local/bin/screen-rotation-cycler.sh left

Lässt sich das eventuell (auch) über einen Lagesensor hooken/lösen?

## Generic Linux kernel tweaks: Modifying Grub boot config

Linux kernel has a power regression problem. ([Quelle](http://www.phoronix.com/scan.php?page=article&item=intel_i915_power))

This fix tweaks the Grub bootloader and helps extend battery life. Edit your grub config as follow:

	vi vim /etc/default/grub
	# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
	GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_aspm i915.lvds_downclock=1 i915.enable_rc6=1 i915.enable_fbc=1"

	update-grub
	reboot

## Known issues / Things to investigate / Things to investigate

## Power Management

Zugriff auf Batterie Infos ist da.

	$ acpitool -B
	Battery #1     : present
	Remaining capacity : 44210 mWh, 100.0%
	Design capacity    : 44000 mWh
	Last full capacity : 44210 mWh
	Present rate       : 0 mW
	Charging state     : Full
	Battery type       : Li-poly
	Model number       : SDS-BAT
	Serial number      : 123456789

Es fehlt:

* Cycle Count
* Fan speed (tp_smapi!?)
* start/stop threshold's

## Firmware

[Firmware](http://support.lenovo.com/ch/de/products/laptops-and-netbooks/yoga-series/yoga-3-1170?c=1) Upgrade!?

## Tablet Mode usability

Es geht, aber noch nicht sehr benutzbar.

## aiccu

Ipv6 tunnel via sixxs tunnel broker.

	apt-get install aiccu
	dpkg-reconfigure aiccu

	vi /etc/aiccu.conf
	verbose true

	vi /etc/default/aiccu
	# Run aiccu at startup ?
	AICCU_ENABLED=No
