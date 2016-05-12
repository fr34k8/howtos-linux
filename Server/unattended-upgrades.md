# Unattended-upgrades

Aktualisiere Stabile und Sicherheits-Updates.

	apt-get install unattended-upgrades

	vi /etc/apt/apt.conf.d/50unattended-upgrades
	Unattended-Upgrade::Origins-Pattern {
        "o=Debian,a=stable";
        "o=Debian,a=stable-updates";
        "origin=Debian,codename=${distro_codename},label=Debian-Security";
	};
	Unattended-Upgrade::Mail "root";

testen:

	unattended-upgrade -d –dry-run

Und aktivieren mit:

	dpkg-reconfigure -plow unattended-upgrades

Add this line too:

	cat << EOF >>/etc/apt/apt.conf.d/20auto-upgrades
	APT::Periodic::Download-Upgradeable-Packages "1";
	EOF

Inspired by <https://wiki.debian.org/UnattendedUpgrades>
