# Bitcoind - full node

See also [Linux Instructions](https://bitcoin.org/en/full-node#linux-instructions)

# Install

	apt-get install openssh-server rsync ca-certificates lm-sensors postfix mailutils speedometer sysstat

Create user:

	useradd -m bitcoin
	su - bitcoin
	mkdir ~/src
	cd src
	wget [from here](https://bitcoin.org/bin/bitcoin-core-0.13.0/bitcoin-0.13.0-x86_64-linux-gnu.tar.gz)
	wget [signing key from here](https://bitcoin.org/laanwj-releases.asc)
	wget [SHA256SUMS.asc from here](https://bitcoin.org/bin/bitcoin-core-0.13.0/SHA256SUMS.asc)
	gpg --import laanwj-releases.asc

Verify fingerprint and local sign!

	gpg --verify SHA256SUMS.asc

If corret go on:

	tar xfz bitcoin-0.13.0-x86_64-linux-gnu.tar.gz
	install -m 0755 -o root -g root -t /usr/local/bin bitcoin-0.13.0/bin/*

## Configure

### Postfix

Configure postfix according to [this](https://github.com/micressor/howtos-linux/blob/master/Server/postfix.md)

### Logwatch

Configure logwatch according to [this](https://github.com/micressor/howtos-linux/blob/master/Server/logwatch.md)

### Fail2ban

Configure fail2ban according to [this](https://github.com/micressor/howtos-linux/blob/master/Server/fail2ban.md)

### Unattended upgrades

Configure unattended upgrades according to [this](https://github.com/micressor/howtos-linux/blob/master/Server/unattended-upgrades.md)

### Bitcoin core

Create config file:

	mkdir ~/.bitcoin
	touch ~/.bitcoin/bitcoin.conf
	chmod 600 ~/.bitcoin/bitcoin.conf
	cat << EOF >~/.bitcoin/bitcoin.conf
	par=3
	daemon=1
	txindex=1
	debug=mempool
	shrinkdebuglog=1
	maxuploadtarget=2700
	alertnotify=echo %s | mail -s "Bitcoin Alert" admin@foo.com
	EOF

Automatic start after reboot, if special disk monted on /home/bitcoin is there:

	cd /home/bitcoin
	mkdir -disk-here
	crontab -e
	PATH=/home/bitcoin/bin:/usr/local/bin:/usr/bin:/bin
	@reboot if [ -f /home/bitcoin/.disk-here ]; then bitcoind -daemon; fi

Tweaking .bashrc:

	vi ~/.bashrc
	alias log='tail -f ~/.bitcoin/*.log'
	alias alog='tail -f ~/.bitcoin/*.log | grep -v "UpdateTip"'
	alias speed='speedometer -r eth0 -t eth0'
	EOF
	. ~/.bashrc

### Firewall

Add port 8333 forwarding rule to the system that runs bitcoind.

Validate that connectioncount is >8, so bitcoind is accepting incoming
connections:

	bitcoin-cli getconnectioncount
	11
