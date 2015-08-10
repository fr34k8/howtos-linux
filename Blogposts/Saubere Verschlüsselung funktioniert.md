# Sauber implementierte und starke Verschlüsselung - aber sicher!

In einem Interview mit dem Guardian [bestätigte Insider Edward
Snowden](http://www.heise.de/security/meldung/NSA-und-GCHQ-Grossangriff-auf-Verschluesselung-im-Internet-1950935.html):
*«Verschlüsselung funktioniert. Sauber implementierte, starke
Verschlüsselung ist eines der wenigen Dinge, auf die man sich noch
verlassen kann.»*

# Wo gibt es sauber implementierte Verschlüsselung?

-   OpenOffice: siehe LibreOffice
-   [LibreOffice
    3.5](http://de.libreoffice.org/download/3-5-neuerungen/#Verschl%C3%BCsselung)
    unterstützt AES-256 für die Verschlüsselung passwortgeschützter
    Dateien in den Formaten ODF 1.2 und ODF 1.2. Die bisherige
    Blowfish-Verschlüsselung in ODF 1.2-Dateien gilt als veraltet.
-   [Firefox Sync
    Server](https://wiki.mozilla.org/Labs/Weave/Developer/Crypto) hat
    Hinweise auf gut implementierte Verschlüsselung.
-   [KeePass](http://keepass.info/help/base/security.html) beschreibt
    detailiert, wie saubere Verschlüsselung in den beliebten
    Passwort-Manager implementiert wurde.
-   [GnuPG](http://www.gnupg.org/documentation/index.de.html) -
    Web-of-Trust Basis und Katalysator von sehr vielen
    Opensource-Projekten.
-   [TrueCrypt](http://www.truecrypt.org/docs/aes) ist eine Software zur
    Datenverschlüsselung, insbesondere der vollständigen oder partiellen
    Verschlüsselung von Festplatten und Wechseldatenträgern. Auch diese
    Opensource Software liefert Hinweise auf gut implementierte
    Verschlüsselung.

# Dokumente an der Quelle schützen

Dokumente sind auf einem verschlüsselten Filesystem oder einem
verschlüsseltem Cloud-Storage nur bedingt sicher. *Was ist wenn mehrere
Personen auf das selbe Filesystem/Cloud-Storage Zugriff haben?* Die
Sicherheit von einer Datei, einem Dokument fängt auch genau an dieser
Stelle an: **Bei der Datei!**

## In nur 3 Schritten ein Dokument sicher verwalten

1.  **Mit dem Passwort-Generator von KeePass** ein langes Passwort
    erstellen und anschliessend verwalten.
2.  Ein neues oder bestehendes **LibreOffice**/OpenOffice Dokument **mit
    diesem generierten Passwort schützen**
3.  Auf diese Weise kann das Dokument **unabhänging von Webserver/E-Mail
    Verschlüsselung** auch über nicht verschlüsselte Kanäle
    **transportiert werden!**

## GnuPG/PGP für den sicheren Austausch via E-Mail

Das Gpg4win-Kompendium ist der ideale [Einstieg in die Welt der
Kryptografie](http://www.gpg4win.de/documentation-de.html).

*Ist Dir GnuPG zu aufwändig?* Es geht einfacher, indem Du Deine
Mailkonversation einfach in einem LibreOffice Dokument schreibst und
diese gemäss der obigen 3 Schritte Anleitung verschlüsselt an Deinen
Konversationspartner sendest. Einzig, das Passwort für dieses Dokument,
müsst Ihr vorher persönlich ausgetauscht haben. Daher [lohnt sich der
Einstieg in GnuPG auf jeden
Fall](http://www.gpg4win.de/documentation-de.html).

# Zugegeben, dass ist aufwändig!

Und **für jede/n mit dem Willen seine Dokumente/E-Mails zu schützen, ist
das umsetzbar.** Es ist nicht kompliziert, es ist nur aufwändig! Aufwand
der sich lohnt.

[heise security schrieb über Bruce
Schneier](http://www.heise.de/security/meldung/Bruce-Schneier-zum-NSA-Skandal-Die-US-Regierung-hat-das-Internet-verraten-1951318.html)
vor kurzem: *«Selbst verwendet Schneier unter anderem GPG, Silent
Circle, Tails Linux, OTR, TrueCrypt und BleachBit. Generell sei Linux
Windows-Systemen vorzuziehen, wobei er selber "unglücklicherweise" noch
schwerpunktmäßig Windows nutze. Alles in allem gelte: Auch wenn die NSA
das Internet in eine gewaltige Überwachungsplattform verwandelt habe,
könnten die Geheimdienstler dennoch nicht zaubern. Selbst deren enorme
Kapazitäten haben ihre Grenzen. "Verschlüsselung ist dein Freund", so
Schneier.*»

Was mich an den Einstieg dieses Artikels erinnert, da zitierte ich
Edward Snowden: **Sauber implementierte, starke Verschlüsselung ist
eines der wenigen Dinge, auf die man sich noch verlassen kann.**

Das gibt mir ein gutes Gefühl in Bezug auf meine Privatsphäre, **indem
ich Dokumente an der Quelle schütze.** Es ist eine Frage Deiner
Entscheidung!
