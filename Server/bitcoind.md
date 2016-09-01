# Bitcoind - full node

See also [Linux Instructions](https://bitcoin.org/en/full-node#linux-instructions)

# Install

Create user:

	useradd -m bitcoind
	su - bitcoind
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

Create config file:

	mkdir ~/.bitcoin
	touch ~/.bitcoin/bitcoin.conf
	chmod 600 ~/.bitcoin/bitcoin.conf
	echo 'alertnotify=echo %s | mail -s "Bitcoin Alert" admin@foo.com' >~/.bitcoin/bitcoin.conf

Automatic start after reboot, if special disk monted on /home/bitcoind is there:

	cd /home/bitcoind
	mkdir -disk-here
	crontab -e
	PATH=/usr/local/bin
	@reboot if [ -f /home/bitcoind/.disk-here ]; then bitcoind -daemon; fi

### Firewall

Add port 8333 forwarding rule to the system that runs bitcoind.
