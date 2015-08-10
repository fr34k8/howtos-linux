# Zenoss 4.2.3 performance tuning

Die Wikipedia sagt zu [Zenoss](http://de.wikipedia.org/wiki/Zenoss):
*«...ist eine auf dem Zope Application Server basierende
Netzwerk-Monitoring-Software, die unter der GNU General Public Lizenz
steht. Mit ihr können Systemadministratoren über ein Web-Interface im
Browser die Verfügbarkeit sowie die Performance von Servern und
Netzwerkkomponenten überwachen.»*

Hier meine Erfahrungen, die ich mit Euch teile:

# LDAP

Der Logeintrag in */opt/zenoss/log/event.log*

    2013-08-29T01:35:57 INFO event.LDAPMultiPlugin Syncing properties from LDAP for user

wies permanent darauf hin, dass immer wieder vom gleichen Benutzer
LDAP-Properties synchronisiert wurden:

Wir fanden heraus, dass über die verschiedenen Upgrades *2.4.x --\>
2.5.x --\> 3.2.x --\> 4.2.3* dieser Installation, die von zenmigrate
geänderten Einstellungen für LDAP nicht sauber nachgeführt wurden.
Zenoss hat seit 4.2.3 einen **memcached** daemon, der viele variable
Daten zwischenlagert. Für den LDAP Teil hat memcached das in dieser
Instanz nicht korrekt erledigt. Folgendes haben wir geändert:

1.  LDAP mit dem Zenoss Wizard neu konfiguriert
    (*/zport/dmd/manageLDAPConfig*)
2.  Die alte Konfiguration via Zope-Interface deaktiviert
    (*/zport/acl\_users/manage\_workspace*)

## memcached

Anschliessend, diesen Cache je nach Bedarf vergrössern. *zentune run
-v10* sagt Dir wie gross der sein soll. **Vorsicht:** Erst nach minimum
24h Laufzeit, kann *zentune* anhand der Statisken vom memchached eine
passende Empfehlung abgeben.

    vim /etc/sysconfig/memcached 
    CACHESIZE="4096"

# zends

Diese Einstellungen haben eine nahezu verdoppelung der GUI-Performance
bewirkt:

    vim /opt/zends/etc/zends.conf 
    sort_buffer_size = 4M
    read_rnd_buffer_size = 512K
    table_cache = 512
    innodb_buffer_pool_size = ???

## innodb\_buffer\_pool\_size

Die zends.conf Einstellung *innodb\_buffer\_pool\_size* sollte ebenfalls
gemäss *zentune* Empfehlung eingestellt werden.

# Zusammenfassung

Das richtige einstellen von *memcached,zends und überprüfen des LDAP
cachings*, hat die Performance dieser Umgebung verdoppelt.
**Kennzahlen:** \>1000 Devices;\>150 Benutzer.
