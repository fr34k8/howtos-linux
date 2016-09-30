# Logwatch

Wöchentlich eine logwatch e-mail der letzten 7 Tage:

	dpkg-divert --local --rename --divert /etc/cron.weekly/00logwatch --add /etc/cron.daily/00logwatch
	vi /etc/cron.weekly/00logwatch
	  /usr/sbin/logwatch --range 'since 7 days ago' --output mail
