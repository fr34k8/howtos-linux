# Tripwire

## Install

	apt-get install tripwire

## Configure

	tripwire --init

### Update policy

Comment out the following lines:

	vi /etc/tripwire/twpol.txt
	#/proc          -> $(Device) ;

	tripwire --update-policy --secure-mode low /etc/tripwire/twpol.txt

### Cron

Execute tripwire in a weekly rhythm:

	dpkg-divert --local --rename --divert /etc/cron.weekly/tripwire --add /etc/cron.daily/tripwire

If you like to go back to a daily rhytm:

	dpkg-divert --rename --remove /etc/cron.daily/tripwire

## Test

	triwpire --check
	tripwire --update -r /var/lib/tripwire/report/hostname-20160520-072302.twr

## Usage

	triwpire --check
	tripwire --update -r /var/lib/tripwire/report/hostname-20160520-072302.twr
