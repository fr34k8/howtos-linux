# How to test ssh network performance

	dd if=/dev/zero | ssh host cat >/dev/null

# Commands to monitor network bandwidth on Linux server

	apt-get install speedometer
	speedometer -r eth0 -t eth0

From [here](http://www.binarytides.com/linux-commands-monitor-network/)
