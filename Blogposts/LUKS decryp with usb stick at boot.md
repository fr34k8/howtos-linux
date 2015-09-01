# Linux Rechner: Einfaches entschlüsseln mit einem USB-Stick statt Passwort

Linux Benutzerlevel für diesen Artikel: fortgeschritten / advanced

Diese Anleitung beschreibt, wie **alternativ zum Passwort** ein
handelsüblicher **USB-Stick als Schlüssel** zum Freischalten des Systems
verwenden werden kann, ohne dass auf diesem eine offensichtliche
Schlüsseldatei angelegt werden muss.

# Den USB-Stick vorbereiten

## Alles auf dem Stick löschen

Den handelsüblichen USB-Stick mit **shred** inklusive
Partitionierungs-Tabelle löschen.

    shred -v -z -n0 /dev/sdX

# Partitionstabelle mit cfdisk erstellen

Mit **cfdisk** eine neue vfat Partition (Gesamtgrösse-2MB) am **Ende**
des USB-Sticks anlegen. So bleiben am Anfang einige Datenblöcke für den
**[LUKS](http://de.wikipedia.org/wiki/Linux_Unified_Key_Setup#LUKS)-Header**
frei.

# Filesystem erstellen

Das Filesystem kann nach belieben verwendet oder leer bleiben, da sich
der Key im Zwischenraum neben der Partition befindet. So fällt nicht
auf, dass es sich hierbei um einen USB-Stick handeln könnte, womit man
einen Computer entschlüsseln kann.

    mkfs.vfat /dev/sdX -n usblabel

# Den Schlüssel generieren

Es ist **wichtig** den Schlüssel an der genau passenden Stelle auf den
Stick zu schreiben. **cfdisk** zeigt bis wohin maximal geschrieben
werden darf, ohne das vfat Dateisystem zu verletzen.

    cfdisk -P t /dev/sdX
    Partition Table for /dev/sdX

             ---Starting----      ----Ending-----    Start     Number of
     # Flags Head Sect  Cyl   ID  Head Sect  Cyl     Sector    Sectors
    -- ----- ---- ---- ----- ---- ---- ---- ----- ----------- -----------
     1  0x00   10   21     4 0x0C   34   36  2708        6176     3905504

Der **Start Sector** der ersten Partition ist in diesem Beispiel bei
6176. Mit dem folgenden Befehl werden Zufallszahlen von Sektor 2 bis
6175 geschrieben. Sektor 1 darf nicht beschrieben werden, da sich die
**Partitionierungstabelle** darauf befindet, welche wir vorher mit
**cfdisk** erstellt haben.

    dd if=/dev/urandom | uuencode -m - | dd bs=512 seek=1 \
      count=6175 of=/dev/sdX

## Den Schlüssel sichern

Aus diesem grossen Zwischenraum (Sektor 2-6175) benötigt der Schlüssel
nur ca 5 Sektoren. Um es noch weniger auffällig zu machen entnehmen wir
den Schlüssel zwischen Sektor 3 und 7 und speichern Ihn aus dem
USB-Stick auf die Festplatte:

    dd if=/dev/sdX bs=512 skip=2 count=5 of=usb.key

## Schlüssel dem luks header hinzufügen

Mit **[cryptsetup](http://linuxwiki.de/cryptsetup)** wird der
gespeicherte Schlüssel *usb.key* nun im **LUKS**-Header installiert. In
der Datei */etc/crypttab* steht, welche Disks mit LUKS-Verschlüsselung
ausgerüstet sind und zur Verfügung stehen. In diesem Beispiel ist es
*/dev/sdX5*

    grep crypt /etc/crypttab
    cryptsetup luksAddKey /dev/sdX5 usb.key
    (aktuelle passphrase)
    rm usb.key

# Die initramfs des Kernels vorbereiten

    mkdir -p /etc/decryptkeydevice
    cd /etc/decryptkeydevice

## decryptkeydevice\_keyscript.sh

Download von decryptkeydevice_keyscript.sh von [hier.](https://github.com/micressor/howtos-linux/blob/master/Blogposts/uploads/decryptkeydevice_keyscript.sh)

    wget decryptkeydevice_keyscript.sh
    chmod +x decryptkeydevice_keyscript.sh

## decryptkeydevice.conf

Die USB-Schlüssel werden anhand ihrer vom System vergebenen Disk-ID
erkannt und in der Zeile DECRYPTKEYDEVICE\_DISKID=" " eingetragen. Die
Disk-ID des aktuell gesteckten USB-Sticks ermittelt der folgenden
Befehl:

    ls -l /dev/disk/by-id  |grep sdX | grep -v part

Und wie folgt ergänzen:

    vim decryptkeydevice.conf
      DECRYPTKEYDEVICE_SKIPBLOCKS="2"
      DECRYPTKEYDEVICE_READBLOCKS="5"
      DECRYPTKEYDEVICE_BLOCKSIZE="512"
      DECRYPTKEYDEVICE_DISKID="usb-Generic_STORAGE_DEVICE_000000034407-0:0"

## crypttab

Die betreffende sdXX\_crypt Zeile mit den Optionen **tries** und
**keyscript** erweitern.

    cat /etc/crypttab 
    sdXX_crypt UUID=615394ca-7ad7-11e3-b03b-001e6708b914 none luks,tries=3,keyscript=/etc/decryptkeydevice/decryptkeydevice_keyscript.sh

## update-initramfs

**Achtung:  
 Es wird dringend empfohlen, eine Kopie des originalen initramfs in der
/boot/ Partition anzulegen, damit man im Notfall damit das System wieder
starten kann.**

Mit der Datei *decryptkeydevice.hook* wird dem initramfs-tool
mitgeteilt, dass die gewünschten Konfigurationen mit in die initrd
einbezogen werden und die Festplatte anhand des USB-Schlüssels
entschlüsselt werden kann.

    cd /etc/initramfs-tools/hooks
    wget decryptkeydevice.hook
    update-initramfs -u

# Neustart

Und den USB-Schlüssel eingesteckt lassen.

# Referenzen

[Ubuntu users: Daten sicher
löschen](http://wiki.ubuntuusers.de/Daten_sicher_l%C3%B6schen)  
 [Ubuntu users: System Entschlüsseln mit einem
USB-Stick](http://wiki.ubuntuusers.de/System_verschl%C3%BCsseln/Entschl%C3%BCsseln_mit_einem_USB-Schl%C3%BCssel)  
 [How to setup passwordless disk encryption in Debian
Etch](http://wejn.org/how-to-make-passwordless-cryptsetup.html)
