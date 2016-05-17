# Logwatch

Wöchentlich eine logwatch e-mail der letzten 7 Tage:

	dpkg-divert --local --rename --divert /etc/cron.weekly/00logwatch --add /etc/cron.daily/00logwatch
	vi /etc/cron.weekly/00logwatch
	  /usr/sbin/logwatch --range 'between -7 days ago and yesterday' --output mail
