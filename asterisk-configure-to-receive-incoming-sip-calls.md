# Asterisk

    apt-get install asterisk

## sip.conf

	vi /etc/asterisk/sip.conf
	[general]
	register => 031XXXXXX1:xyz@sip.netvoip.ch/031XXXXXX1
	register => 031XXXXXX2:xyz@sip.netvoip.ch/031XXXXXX2
	; for security reason
	context=catchall
	allowguest=no
	alwaysauthreject=yes
	[netvoip]
	type=peer
	username=031XXXXXX1
	secret=xyz
	host=sip.netvoip.ch
	insecure=invite
	context=netvoip_in
	nat=no
	disallow=all
	allow=alaw 

<http://www.voip-info.org/wiki/view/Asterisk+codecs>

## extensions.conf

	vi /etc/asterisk/extensions.conf
	[netvoip_in]
	exten => 031XXXXXX1,1,Answer
	exten => 031XXXXXX1,2,System(echo "Greetings from asterisk" | mail -s "Verpasster Anruf von ${CALLERID(num)} an ${EXTEN}" user@domain.tld)
	exten => 031XXXXXX1,3,Dial(SIP/078xxxxxxx@netvoip,30,trg)
	exten => 031XXXXXX1,4,Hangup

	[catchall]
	; for security reason

	asterisk -R
	localhost*CLI> reload
