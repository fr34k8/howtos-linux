# How to get citrix plugin for firefox running with special root certificate

	apt-get install ca-certificates

Install Citrix for Linux from [here](https://www.citrix.de/downloads/citrix-receiver/linux/receiver-for-linux-latest.html)

If you need a special root certificate from `ca-certificates` you can activate it this way:

	ln -s /etc/ssl/certs/thawte_Primary_Root_CA.pem /opt/Citrix/ICAClient/keystore/cacerts

It works immediately!
