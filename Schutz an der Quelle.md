# Daten an der Quelle schützen

Es ist schon beeindruckend was dank [Edward
Snowden](http://de.wikipedia.org/wiki/Edward_Snowden) weltweit für
Diskussionen in gang gesetzt wurden. Aus der Wikipedia: *«Seine
Enthüllungen gaben Einblicke in das Ausmass der weltweiten Überwachungs-
und Spionagepraktiken von US-Diensten und lösten so die Überwachungs-
und Spionageaffäre 2013 aus.»*  
 Auch mich hat das im Zusammenhang mit dem **Schutz von Daten** wie z.b.
E-Mail, Cloud Storage und gesicherte Datenverbindungen mittels
**TLS/SSL** zum nachdenken bewegt.  

# Wie sicher ist ein signiertes SSL Zertifikat?

Zertifkate werden von einer
[Zertifizierungsstelle](http://de.wikipedia.org/wiki/Zertifizierungsstelle)
signiert. Und die von uns allen eingesetzten Webbrowser vertrauen eben
genau diesen Zertifizierungsstellen.  

## So wie die Zertifizierungsstelle

*Überlegst Du Dir jeweils, wem Du vertraust? Überlegst Du Dir, welcher
Zertifizierungsstelle Du Dein Vertrauen schenken willst?* - Sobald eine
Zertifizierungsstelle in die Gewalt eines Geheimdienstes gerät,
**besteht die Möglichkeit, dass Dein Browser einem Zertifikat traut,
dass gar nicht mehr vertrauenswürdig ist.**  

## Der Fingerabdruck weiss Rat

    SHA-1 fingerprint:
    d0 1f 52 22 49 52 68 4e 79 ec 81 56 7c be 46 ce d1 fc ed b7

Der
[Fingerprint](http://de.wikipedia.org/wiki/Fingerprint_%28Hashfunktion%29)
eines Zertifikats ändert sich nie. Und trotzdem kann er sich ändern
wenn:  

1.  Das Zertifikat demnächst ausläuft und vom Herausgeber ausgewechselt
    wurde.
2.  Eine kriminelle Energie Erfolg hatte, mittels einem [Man in the
    middle
    Angriff](http://de.wikipedia.org/wiki/Man-in-the-middle-Angriff),
    zwischen dem Webserver und Browser zu lauschen oder Daten
    manipulieren.

# Und wie ist das z.b. mit E-Banking?

Sobald der Herausgeber, (in diesem Fall die Bank) eines Zertifikats Dir
den Fingerprint auf einem alternativen Weg wie der Post oder via Telefon
zur Verfügung stellt, kannst Du diesen vergleichen und anschliessend
eine sichere Verbindung zur Bank herstellen. Die Variante via Telefon
ist ausserdem schnell und flexibel. Hier ein passender Artikel der
[Hochschule
Luzern](https://www.ebankingbutsecure.ch/de/ihr-sicherheitsbeitrag/zertifikatspruefung).  

## Mein Herausgeber hat ein EV Zertifikat

[Extended Validation
Zertifikat](http://de.wikipedia.org/wiki/Extended-Validation-Zertifikat)
weisen angeblich eine höhere Sicherheit aus. Da dise unter anderem eine
notariele Beglaubigung fordern. Im Browser werden solche Zertifikate mit
einem grünen Balken markiert und der Name des Herausgebers steht
innerhalb von diesem Balken.

## Zertifikate von Firefox überwachen lassen

Für Firefox gibt es ein hervorragendes AddOn, dass für Dich die
Fingerprints der Zertifikate im Auge behält und Dich über Änderungen
sofort informiert: [Certificate
Patrol](https://addons.mozilla.org/de/firefox/addon/certificate-patrol/)
So der Herausgeber: *«Dein Web-Browser vertraut vielen
Zertifikationsautoritäten (CAs), welche wiederrum noch mehr Sub-CAs
vertrauen. Legitim digital signierte Zertifikate können von irgendwo
herkommen. Dieses Add-on hilft Dir den Überblick zu behalten.»*

# PKI versus Web of Trust

Die Wikipedia sagt dazu:  

-   Zu **Web of Trust:** Netz des Vertrauens bzw. Web of Trust (WOT) ist
    in der Kryptologie die Idee, die Echtheit von digitalen Schlüsseln
    durch ein Netz von gegenseitigen Bestätigungen (Signaturen),
    kombiniert mit dem individuell zugewiesenen Vertrauen in die
    Bestätigungen der anderen („Owner Trust“), zu sichern. Es stellt
    eine dezentrale Alternative zum hierarchischen PKI-System dar.
-   Zu **PKI**: Mit Public-Key-Infrastruktur (PKI, englisch public key
    infrastructure) bezeichnet man in der Kryptologie ein System, das
    digitale Zertifikate ausstellen, verteilen und prüfen kann. Die
    innerhalb einer PKI ausgestellten Zertifikate werden zur Absicherung
    rechnergestützter Kommunikation verwendet.

Organisationen, Firmen, Menschen oder Zertifizierungsstellen können
beinflusst, hintergangen oder gar bedroht werden. -Unabhängig davon:
**die freie Meinung eines Menschen bleibt auch immer die freie Meinung
eines Menschen.**  
 Es gibt Menschen in der IT Branche die sagen, dass das hirarchische PKI
Konzept brökelt. Ich glaube, dass Konzepte wie **[Web of
Trust](http://de.wikipedia.org/wiki/Web_of_Trust)**, die im übrigen
schon sehr lange, erfolgreich und für End-To-End Verschlüsselung
(PGP/GnuPG) eingesetzt werden, in Zukunft Erfolg haben werden.  

Im Zusammenhang mit Webserver Zertifikaten ist
[CAcert](http://www.cacert.org/), welche eine **nicht-kommerzielle
Zertifizierungsstelle** ist, ein positives Licht am Ende des Tunnels.
CAcert orientiert sich am **Web of Trust** Konzept.  

# Zusammenfassung

Die Lösung für dieses Problem besteht darin, die Echtheit eines
öffentlichen Schlüssels von einer vertrauenswürdigen Instanz durch ein
digitales Zertifikat bestätigen zu lassen.

-   Bei **Public-Key-Infrastrukturen** ist dies eine
    Zertifizierungsstelle;
-   im **Web of Trust** hingegen übernehmen alle Teilnehmer diese
    Funktion.

*Wie gross wird der Aufwand der Geheimdienste in Zukunft wohl sein,
sofern es diese bis dahin noch gibt ;), Zertifikate zu manipulieren,
welche der Idee von **Web of Trust** zu grunde liegen?*

[Edward Snowden](http://de.wikipedia.org/wiki/Edward_Snowden) hat uns
allen mit überzeugenden Argumenten bewiesen, wie wertvoll unsere Daten,
unsere Privatsphäre sind. - Denkt darüber nach!
