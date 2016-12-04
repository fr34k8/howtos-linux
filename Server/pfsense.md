# PfSense

## Dualstack IPv6 + IPv4 with DSL over PPPoE

Interfaces -> WAN:

1. IPv4 Configuration Type: PPPoE
2. IPv6 Configuration Type: DHCP6

DHCP6 Client Configuration:

* DHCPv6 Prefix Delegation size: 64
* [X] Request a IPv6 prefix/information through the IPv4 connectivity link
* [X] Send an IPv6 prefix hint to indicate the desired prefix size for delegation

PPPoE Configuration:

* Username: xyz
* Password: xyz

Because I have a LAN,WIFI bridge0, so I have to set my static IPv6 IP's at
the bridge0 interface:

IPv4 Configuration Type: Static IPv4
IPv6 Configuration Type: Static IPv6
IPv4 Address: 192.168.1.1
IPv6 Address: 2001:2002:2003:face::1 / 64
IPv6 Upstream gateway: none

Navigate to Services / DHCPv6 Server & RA / bridge0 / DHCPv6 Server:

* DHCPv6 Server: [X] Enable DHCPv6 server on interface bridge0
* Subnet: 2001:2002:2003:face::
* Subnet Mask: 64 bits
* Available Range: 2001:2002:2003:face:: to 2001:2002:2003:face:ffff:ffff:ffff:ffff
* Range: 2001:2002:2003:face:dddd::  to 2001:2002:2003:face:dddd:ffff:ffff:ffff
* Prefix Delegation Size: 48

Navigate to Services / DHCPv6 Server & RA / bridge0 / Router Advertisements:

* Router mode: Assisted
* Router priority : High
* Domain search list: xyz.domain.tld

## OpenVPN config

1. Start wizard
2. Select Type of Server: Local User Access
3. Create a New Certificate Authority (CA) Certificate
   Descriptive name: apu openvpn
   Key length: 4096
4. Create a New Server Certificate
   Descriptive name: apu openvpn
   Key length: 4096
5. General OpenVPN Server Information
   Interface: WAN
   Protocol: UDP
   Local Port: 1194
   TLS Authentication: Enabled
   Generate TLS Key: Enabled
   Tunnel Network: 192.168.3.0/24
   IPv6 Tunnel Network: fd00:9999::/64
   Redirect Gateway: Enabled
   (Force all client generated traffic through the tunnel.)
   Concurrent Connections: 5
   DNS Default Domain: vpn.domain.tld
   DNS Server enable: Copy dns servers from System / General Setup
   NTP Server enable: use pfsense ip as ntp master
6. Firewall Rule Configuration
   Traffic from clients to server: Enabled
   Traffic from clients through VPN: Enabled

Create a Client Certificate for the VPN user:

1. Navigate to SystemUser / Manager / Users / Edit 

2. Add a User Certificate:
   Method: Create an internal Certificate
   Certificate Type: User Certificate
   Key length: 4096
   Common Name: user.vpn.domain.tld
   Alternatives Names: email address

3. To be able to export client configurations, browse to System->Packages and install the OpenVPN Client Export package. Confirmation Required to install package pfSense-pkg-openvpn-client-export.

4. Navigate to VPN / OpenVPN / Client Export / OpenVPN Clients
   Download standard configuration: Archive

6. Extract to ~/.openvpn/xyz

7. Change `remote` ip at fw-udp-1194-username.ovpn

8. Import configuration via gnome openvpn importer.

* [PfSense: OpenVPN](https://doc.pfsense.org/index.php/Category:OpenVPN)
* [PfSense: Dualstack IPv6 + IPv4 mit pfSense an DSL](https://moerbst.wordpress.com/2016/07/31/ipv6mit-pfsense-an-dsl-der-telekom/)

## WLAN Router config

# Links

* [How to setup Wi-Fi with pfSense](https://www.servethehome.com/how-to-setup-wi-fi-with-pfsense/
